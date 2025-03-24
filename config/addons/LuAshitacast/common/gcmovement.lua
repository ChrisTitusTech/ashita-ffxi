require('common');
local chat = require('chat');
local ffi = require('ffi');

-- Define Windows API functions through FFI
ffi.cdef[[
    void keybd_event(uint8_t bVk, uint8_t bScan, uint32_t dwFlags, uintptr_t dwExtraInfo);
    short GetAsyncKeyState(int vKey);
    int PostMessageA(void* hWnd, unsigned int Msg, uintptr_t wParam, intptr_t lParam);
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

-- Function to send a key press or release using Windows key messages
local function sendWindowsKey(vkey, isDown)
    local scanCode = 0;
    
    -- Convert virtual key to proper scan code for FFXI
    if vkey == VK_NUMPAD8 then scanCode = 0x48; end      -- Numpad 8
    if vkey == VK_NUMPAD2 then scanCode = 0x50; end      -- Numpad 2
    if vkey == VK_NUMPAD4 then scanCode = 0x4B; end      -- Numpad 4
    if vkey == VK_NUMPAD6 then scanCode = 0x4D; end      -- Numpad 6
    
    if gcmovement.DebugMode then
        gcmovement.Debug('Sending ' .. (isDown and 'KEYDOWN' or 'KEYUP') .. 
            ': VK=' .. vkey .. ' SC=' .. scanCode);
    end
    
    -- Queue the bringtofront command to ensure window focus
    AshitaCore:GetChatManager():QueueCommand(1, '/bringtofront');
    
    -- Store when to send the key to allow time for focus to be gained
    local focusWaitTime = 0.1; -- Wait 100ms for focus to be gained
    table.insert(gcmovement.KeySendQueue, {
        vkey = vkey,
        scanCode = scanCode,
        isDown = isDown,
        sendTime = os.clock() + focusWaitTime
    });
end

-- Initialize key send queue
gcmovement.KeySendQueue = {};

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

-- Process key send queue in the update function
function gcmovement.update()
    local currentTime = os.clock();
    local keysToRemove = {};
    
    -- Process queued key sends
    for index, keyInfo in ipairs(gcmovement.KeySendQueue) do
        if currentTime >= keyInfo.sendTime then
            -- Use direct keybd_event for sending keys
            local flags = keyInfo.isDown and 0 or KEYEVENTF_KEYUP;
            ffi.C.keybd_event(keyInfo.vkey, keyInfo.scanCode, flags, 0);
            
            if gcmovement.DebugMode then
                gcmovement.Debug('Key sent after focus wait: VK=' .. keyInfo.vkey);
            end
            
            table.insert(keysToRemove, index);
        end
    end
    
    -- Remove the processed key sends (in reverse order)
    for i = #keysToRemove, 1, -1 do
        table.remove(gcmovement.KeySendQueue, keysToRemove[i]);
    end
    
    -- Check for keys that need to be released (from original code)
    keysToRemove = {};
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
print(chat.header('GCMovement'):append(chat.message('Movement module loaded. Use /bringtofront command to ensure window focus.')));

-- Register with Ashita
ashita.events.register('d3d_present', 'movement_update', function()
    gcmovement.update();
end);

return gcmovement;