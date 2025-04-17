--[[
* MIT License
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
]]--

addon.author   = 'christitustech';
addon.name     = 'speed';
addon.version  = '1.0.0';
addon.desc     = 'Allows modifying player movement speed.';
addon.link     = 'https://ashitaxi.com/';

require 'common'
local chat = require('chat');

---------------------------------------------------------------------------------------------------
-- Default settings
---------------------------------------------------------------------------------------------------
local settings = {
    defaultSpeed = 5.0,
    currentSpeed = 5.0,
    playerid = 0,
};

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.events.register('load', 'load_cb', function()
    print(chat.header(addon.name):append(chat.message(string.format('Speed addon loaded. Default speed: %.1f', settings.defaultSpeed))));
    print(chat.header(addon.name):append(chat.message('Use /speed help for command information.')));
end);

----------------------------------------------------------------------------------------------------
-- func: set_player_speed
-- desc: Helper function to set player speed with error handling
----------------------------------------------------------------------------------------------------
local function set_player_speed(playerid, speed)
    local memoryManager = AshitaCore:GetMemoryManager();
    if not memoryManager then
        print(chat.header(addon.name):append(chat.error('Failed to get memory manager.')));
        return false;
    end
    
    local player = memoryManager:GetPlayer();
    if not player then
        print(chat.header(addon.name):append(chat.error('Failed to get player data.')));
        return false;
    end
    
    -- Get entity manager
    local entityManager = memoryManager:GetEntity();
    if not entityManager then
        print(chat.header(addon.name):append(chat.error('Failed to get entity manager.')));
        return false;
    end
    
    entityManager:SetMovementSpeed(playerid, speed);
    entityManager:SetMovementSpeed2(playerid, speed);
    return true;
end

----------------------------------------------------------------------------------------------------
-- func: handle_command
-- desc: Command handler for the speed addon
----------------------------------------------------------------------------------------------------
local function handle_command(args)
    -- Setup values for playerid and speed
    local memoryManager = AshitaCore:GetMemoryManager();
    local entityManager = memoryManager:GetEntity();
    local partyManager = memoryManager:GetParty();
    
    if entityManager then
        -- Get the actual entity array size
        local entityCount = entityManager:GetEntityMapSize();
        
        -- Search for the entity by name
        for j = 0, entityCount - 1 do
            local entName = entityManager:GetName(j);
            local playerName = partyManager:GetMemberName(0);
            if entName and playerName and string.lower(entName) == string.lower(playerName) then
                settings.playerid = j;
                print(chat.header(addon.name):append(chat.message('Current Entity Name: ' .. entityManager:GetName(j))));
                -- Get the movement speed of the entity
                local currentSpeed = entityManager:GetMovementSpeed(j);
                local currentSpeed2 = entityManager:GetMovementSpeed2(j);
                if currentSpeed and currentSpeed > 0 then
                    print(chat.header(addon.name):append(chat.message(string.format('Current speed: %.1f', currentSpeed))));
                    print(chat.header(addon.name):append(chat.message(string.format('Current speed2: %.1f', currentSpeed2))));
                    return;
                end
            end
        end
    end

    if #args == 0 then
        print(chat.header(addon.name):append(chat.message(string.format('Stored speed: %.1f', settings.currentSpeed))));
        return;
    end

    local command = args[1]:lower();
    
    if command == 'help' then
        print(chat.header(addon.name):append(chat.message('Speed Addon Commands:')));
        print(chat.header(addon.name):append(chat.message('  /speed <value> - Set speed to specified value (default is 5.0)')));
        print(chat.header(addon.name):append(chat.message('  /speed reset   - Reset speed to default value')));
        print(chat.header(addon.name):append(chat.message('  /speed help    - Show this help information')));
        return;
    end
    
    if command == 'reset' then
        settings.currentSpeed = settings.defaultSpeed;
        if set_player_speed(settings.playerid, settings.currentSpeed) then
            print(chat.header(addon.name):append(chat.message(string.format('Speed reset to default: %.1f', settings.currentSpeed))));
        end
        return;
    end
    
    -- Try to parse the speed value
    local newSpeed = tonumber(command);
    if newSpeed then
        if newSpeed < 0.1 then
            print(chat.header(addon.name):append(chat.error('Speed value must be at least 0.1')));
            return;
        end
        
        settings.currentSpeed = newSpeed;
        if set_player_speed(settings.playerid, settings.currentSpeed) then
            print(chat.header(addon.name):append(chat.message(string.format('Speed set to: %.1f', settings.currentSpeed))));
        end
        return;
    end
    
    print(chat.header(addon.name):append(chat.error('Invalid command. Use /speed help for usage information.')));
end

-- Register command
ashita.events.register('command', 'speed_cmd', function(e)
    if string.sub(string.lower(e.command), 1, 6) ~= '/speed' then
        return;
    end

    e.blocked = true;
    if (string.len(e.command) < 7) then
        handle_command({});
        return;
    end
    
    local args = string.sub(e.command, 8);
    local cmdArgs = {};
    for arg in string.gmatch(args, "%S+") do
        table.insert(cmdArgs, arg);
    end
    handle_command(cmdArgs);
end);
