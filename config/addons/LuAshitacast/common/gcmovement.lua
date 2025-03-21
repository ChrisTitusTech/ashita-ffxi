require('common');
local chat = require('chat');
local ffi = require('ffi');

-- Define Windows API functions through FFI
ffi.cdef[[
    void keybd_event(uint8_t bVk, uint8_t bScan, uint32_t dwFlags, uintptr_t dwExtraInfo);
    short GetAsyncKeyState(int vKey);
]]

-- Constants for keybd_event
local KEYEVENTF_KEYUP = 0x0002

local gcmovement = {};

-- Virtual key constants for FFXI movement with numpad
-- Use the correct numeric keypad scan codes for FFXI
local VK_NUMPAD8 = 0x68;  -- Numpad 8 for moving forward
local VK_NUMPAD2 = 0x62;  -- Numpad 2 for moving backward
local VK_NUMPAD4 = 0x64;  -- Numpad 4 for moving left
local VK_NUMPAD6 = 0x66;  -- Numpad 6 for moving right

-- Debug mode
gcmovement.DebugMode = true;

-- Helper function for debug messages
function gcmovement.Debug(message)
    if gcmovement.DebugMode then
        print(chat.header('GCMovement'):append(chat.message(message)));
    end
end

-- Function to send a key press or release using Windows API
local function sendWindowsKey(vkey, isDown)
    local flags = isDown and 0 or KEYEVENTF_KEYUP;
    local scanCode = 0;
    
    -- Convert virtual key to proper scan code for FFXI
    if vkey == VK_NUMPAD8 then scanCode = 0x48; end      -- Numpad 8
    if vkey == VK_NUMPAD2 then scanCode = 0x50; end      -- Numpad 2
    if vkey == VK_NUMPAD4 then scanCode = 0x4B; end      -- Numpad 4
    if vkey == VK_NUMPAD6 then scanCode = 0x4D; end      -- Numpad 6
    
    gcmovement.Debug('Sending key: ' .. vkey .. ' (scan: ' .. scanCode .. ') - Down: ' .. tostring(isDown));
    ffi.C.keybd_event(vkey, scanCode, flags, 0);
end

-- Check if a key is currently down
local function isKeyDown(vkey)
    return bit.band(ffi.C.GetAsyncKeyState(vkey), 0x8000) ~= 0;
end

-- Move character forward
function gcmovement.moveForward()
    gcmovement.Debug('Moving forward');
    sendWindowsKey(VK_NUMPAD8, true);
end

-- Stop moving forward
function gcmovement.stopForward()
    gcmovement.Debug('Stopping forward movement');
    sendWindowsKey(VK_NUMPAD8, false);
end

-- Move character backward
function gcmovement.moveBackward()
    gcmovement.Debug('Moving backward');
    sendWindowsKey(VK_NUMPAD2, true);
end

-- Stop moving backward
function gcmovement.stopBackward()
    gcmovement.Debug('Stopping backward movement');
    sendWindowsKey(VK_NUMPAD2, false);
end

-- Move character left
function gcmovement.moveLeft()
    gcmovement.Debug('Moving left');
    sendWindowsKey(VK_NUMPAD4, true);
end

-- Stop moving left
function gcmovement.stopLeft()
    gcmovement.Debug('Stopping left movement');
    sendWindowsKey(VK_NUMPAD4, false);
end

-- Move character right
function gcmovement.moveRight()
    gcmovement.Debug('Moving right');
    sendWindowsKey(VK_NUMPAD6, true);
end

-- Stop moving right
function gcmovement.stopRight()
    gcmovement.Debug('Stopping right movement');
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
    gcmovement.Debug('Tapping key ' .. vkey .. ' for ' .. duration .. ' seconds');
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
            gcmovement.Debug('Released key ' .. keyInfo.key);
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
    gcmovement.Debug('Tapping forward');
    gcmovement.tapKey(VK_NUMPAD8, duration);
end

-- Tap backward (press and release Numpad 2)
function gcmovement.tapBackward(duration)
    gcmovement.Debug('Tapping backward');
    gcmovement.tapKey(VK_NUMPAD2, duration);
end

-- Tap left (press and release Numpad 4)
function gcmovement.tapLeft(duration)
    gcmovement.Debug('Tapping left');
    gcmovement.tapKey(VK_NUMPAD4, duration);
end

-- Tap right (press and release Numpad 6)
function gcmovement.tapRight(duration)
    gcmovement.Debug('Tapping right');
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
    gcmovement.Debug('Stopping all movement');
    gcmovement.stopForward();
    gcmovement.stopBackward();
    gcmovement.stopLeft();
    gcmovement.stopRight();
end

-- Log a message when the module is loaded
print(chat.header('GCMovement'):append(chat.message('Movement module loaded using Windows API.')));

-- Register with Ashita
ashita.events.register('d3d_present', 'movement_update', function()
    gcmovement.update();
end);

return gcmovement;