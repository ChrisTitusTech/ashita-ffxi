require('common');
local chat = require('chat');
local ffi = require('ffi');

-- Define Windows API functions through FFI
ffi.cdef[[
    void keybd_event(uint8_t bVk, uint8_t bScan, uint32_t dwFlags, uintptr_t dwExtraInfo);
    short GetAsyncKeyState(int vKey);
    void* GetForegroundWindow();
    int PostMessageA(void* hWnd, unsigned int Msg, uintptr_t wParam, intptr_t lParam);
    void* FindWindowA(const char* lpClassName, const char* lpWindowName);
    int GetWindowTextA(void* hWnd, char* lpString, int nMaxCount);
    int SetForegroundWindow(void* hWnd);
]]

-- Constants for Windows messages
local WM_KEYDOWN = 0x0100
local WM_KEYUP = 0x0101
local KEYEVENTF_KEYUP = 0x0002

local gcmovement = {};
gcmovement.DebugMode = true;

-- Define the virtual key constants for FFXI movement with numpad
local VK_NUMPAD8 = 0x68;  -- Numpad 8 for moving forward
local VK_NUMPAD2 = 0x62;  -- Numpad 2 for moving backward
local VK_NUMPAD4 = 0x64;  -- Numpad 4 for moving left
local VK_NUMPAD6 = 0x66;  -- Numpad 6 for moving right

-- Helper function for debug messages
function gcmovement.Debug(message)
    if gcmovement.DebugMode then
        print(chat.header('GCMovement'):append(chat.message(message)));
    end
end

-- Function to get the FFXI window handle
local function getFFXIWindow()
    -- First, try to find window by the most reliable class name
    local ffxiWindow = ffi.C.FindWindowA("FFXiClass", nil);
    
    if ffxiWindow ~= nil then
        if gcmovement.DebugMode then
            gcmovement.Debug('Found FFXI window by class: FFXiClass');
        end
        return ffxiWindow;
    end
    
    -- If class isn't found, look for windows from pol.exe process
    -- We'll need to enumerate all top-level windows
    -- Since this requires complex window enumeration, we'll use a simpler approach
    -- by trying known patterns in window titles
    
    -- Get the current foreground window and check if it's an FFXI window
    local fgWindow = ffi.C.GetForegroundWindow();
    if fgWindow ~= nil then
        local buffer = ffi.new("char[256]");
        ffi.C.GetWindowTextA(fgWindow, buffer, 256);
        local title = ffi.string(buffer);
        
        -- Check if the title matches expected patterns for FFXI/POL
        if string.find(title, "Final Fantasy XI") or 
           string.find(title, "PlayOnline") or
           string.find(title, "FINAL FANTASY XI") then
            if gcmovement.DebugMode then
                gcmovement.Debug('Found FFXI window by title: ' .. title);
            end
            return fgWindow;
        end
    end
    
    -- Final fallback: use foreground window regardless of title
    if gcmovement.DebugMode then
        gcmovement.Debug('Could not find FFXI window, using foreground window as fallback');
    end
    return ffi.C.GetForegroundWindow();
end

-- Function to send a key press or release to FFXI window
local function sendWindowsKey(vkey, isDown)
    local scanCode = 0;
    
    -- Convert virtual key to proper scan code for FFXI
    if vkey == VK_NUMPAD8 then scanCode = 0x48; end      -- Numpad 8
    if vkey == VK_NUMPAD2 then scanCode = 0x50; end      -- Numpad 2
    if vkey == VK_NUMPAD4 then scanCode = 0x4B; end      -- Numpad 4
    if vkey == VK_NUMPAD6 then scanCode = 0x4D; end      -- Numpad 6
    
    -- Get the FFXI window handle
    local ffxiWindow = getFFXIWindow();
    
    if ffxiWindow ~= nil then
        -- Get window title for debugging
        local buffer = ffi.new("char[256]");
        ffi.C.GetWindowTextA(ffxiWindow, buffer, 256);
        local title = ffi.string(buffer);
        
        -- Send the message directly to the FFXI window
        local msg = isDown and WM_KEYDOWN or WM_KEYUP;
        
        -- Create proper lParam for keyboard messages
        -- See: https://docs.microsoft.com/en-us/windows/win32/inputdev/wm-keydown
        local repeatCount = 1;
        local extendedKey = 0; -- 1 for extended keys like numpad with NumLock off
        local prevKeyState = isDown and 0 or 1;
        local transitionState = isDown and 0 or 1;
        
        local lParam = bit.bor(
            repeatCount,
            bit.lshift(scanCode, 16),
            bit.lshift(extendedKey, 24),
            bit.lshift(prevKeyState, 30),
            bit.lshift(transitionState, 31)
        );
        
        if gcmovement.DebugMode then
            gcmovement.Debug('Sending ' .. (isDown and 'KEYDOWN' or 'KEYUP') .. 
                ' to window "' .. title .. '": VK=' .. vkey .. 
                ' SC=' .. scanCode .. ' lParam=0x' .. string.format("%08x", lParam));
        end
        
        local result = ffi.C.PostMessageA(ffxiWindow, msg, vkey, lParam);
        
        if result == 0 then
            -- PostMessage failed, try setting foreground and using keybd_event
            if gcmovement.DebugMode then
                gcmovement.Debug('PostMessage failed! Trying to set foreground window...');
            end
            
            ffi.C.SetForegroundWindow(ffxiWindow);
            local flags = isDown and 0 or KEYEVENTF_KEYUP;
            ffi.C.keybd_event(vkey, scanCode, flags, 0);
        end
    else
        -- Fallback to global keybd_event if FFXI window not found
        if gcmovement.DebugMode then
            gcmovement.Debug('FFXI window not found, using global keybd_event');
        end
        
        local flags = isDown and 0 or KEYEVENTF_KEYUP;
        ffi.C.keybd_event(vkey, scanCode, flags, 0);
    end
end

-- Move character forward
function gcmovement.moveForward()
    if gcmovement.DebugMode == true then gcmovement.Debug('Moving forward') end;
    sendWindowsKey(VK_NUMPAD8, true);
end

-- Stop moving forward
function gcmovement.stopForward()
    if gcmovement.DebugMode == true then gcmovement.Debug('Stopping forward movement') end;
    sendWindowsKey(VK_NUMPAD8, false);
end

-- Move character backward
function gcmovement.moveBackward()
    if gcmovement.DebugMode == true then gcmovement.Debug('Moving backward') end;
    sendWindowsKey(VK_NUMPAD2, true);
end

-- Stop moving backward
function gcmovement.stopBackward()
    if gcmovement.DebugMode == true then gcmovement.Debug('Stopping backward movement') end;
    sendWindowsKey(VK_NUMPAD2, false);
end

-- Move character left
function gcmovement.moveLeft()
    if gcmovement.DebugMode == true then gcmovement.Debug('Moving left') end;
    sendWindowsKey(VK_NUMPAD4, true);
end

-- Stop moving left
function gcmovement.stopLeft()
    if gcmovement.DebugMode == true then gcmovement.Debug('Stopping left movement') end;
    sendWindowsKey(VK_NUMPAD4, false);
end

-- Move character right
function gcmovement.moveRight()
    if gcmovement.DebugMode == true then gcmovement.Debug('Moving right') end;
    sendWindowsKey(VK_NUMPAD6, true);
end

-- Stop moving right
function gcmovement.stopRight()
    if gcmovement.DebugMode == true then gcmovement.Debug('Stopping right movement') end;
    sendWindowsKey(VK_NUMPAD6, false);
end

-- Store our key release timer information
gcmovement.KeyReleaseTimer = {};
gcmovement.TargetDistance = 0;

-- Helper function to tap a key (press and release)
function gcmovement.tapKey(vkey, duration)
    duration = duration or 0.1; -- Default duration of 0.1 seconds
    
    -- Check if player is moving
    if gcmovement.isMoving() then
        return false;
    end
    
    -- Press the key down
    if gcmovement.DebugMode == true then gcmovement.Debug('Tapping key ' .. vkey .. ' for ' .. duration .. ' seconds') end;
    sendWindowsKey(vkey, true);
    
    -- Store when to release the key using os.clock() for more precise timing
    table.insert(gcmovement.KeyReleaseTimer, {
        key = vkey,
        releaseTime = os.clock() + duration
    });
    
    return true;
end

-- Function to be called every frame update
function gcmovement.update()
    local currentTime = os.clock();
    local keysToRemove = {};
    
    -- Check for keys that need to be released
    for index, keyInfo in ipairs(gcmovement.KeyReleaseTimer) do
        if currentTime >= keyInfo.releaseTime then
            sendWindowsKey(keyInfo.key, false);
            if gcmovement.DebugMode == true then gcmovement.Debug('Released key ' .. keyInfo.key) end;
            table.insert(keysToRemove, index);
        end
    end
    
    -- Remove the released keys (in reverse order)
    for i = #keysToRemove, 1, -1 do
        table.remove(gcmovement.KeyReleaseTimer, keysToRemove[i]);
    end
end

-- Tap forward (press and release Numpad 8)
function gcmovement.tapForward(duration)
    if gcmovement.DebugMode == true then gcmovement.Debug('Tapping forward') end;
    gcmovement.tapKey(VK_NUMPAD8, duration);
end

-- Tap backward (press and release Numpad 2)
function gcmovement.tapBackward(duration)
    if gcmovement.DebugMode == true then gcmovement.Debug('Tapping backward') end;
    gcmovement.tapKey(VK_NUMPAD2, duration);
end

-- Tap left (press and release Numpad 4)
function gcmovement.tapLeft(duration)
    if gcmovement.DebugMode == true then gcmovement.Debug('Tapping left') end;
    gcmovement.tapKey(VK_NUMPAD4, duration);
end

-- Tap right (press and release Numpad 6)
function gcmovement.tapRight(duration)
    if gcmovement.DebugMode == true then gcmovement.Debug('Tapping right') end;
    gcmovement.tapKey(VK_NUMPAD6, duration);
end

-- Check if character is currently moving by checking game data
function gcmovement.isMoving()
    local target = gData.GetTarget();

    if target then
        local moving = AshitaCore:GetMemoryManager():GetTarget():GetIsPlayerMoving();
        if moving > 0 then
            return true;       
        end        
    end

    return false;
end

-- Stop all movement
function gcmovement.stopAll()
    if gcmovement.DebugMode == true then gcmovement.Debug('Stopping all movement') end;
    gcmovement.stopForward();
    gcmovement.stopBackward();
    gcmovement.stopLeft();
    gcmovement.stopRight();
end

-- Update the module loaded message to reflect the change
print(chat.header('GCMovement'):append(chat.message('Movement module loaded using targeted Windows messages.')));

-- Register with Ashita
ashita.events.register('d3d_present', 'movement_update', function()
    gcmovement.update();
end);

return gcmovement;