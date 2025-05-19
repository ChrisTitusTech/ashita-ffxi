--[[]
---MIT License---
Copyright 2022 Banggugyangu

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--

addon.name    = 'AutoRA';
addon.author  = 'banggugyangu';
addon.version = '1.3';

--Dependencies--
require('common');
local chat = require('chat');
local settings = require('settings');
gPacket = require('packetHandler');

local default_settings = T{

    HaltOnTP = true,
    Delay = 0,
    DelayOffset = 0,
    verbose = true;
};

--Addon Variables--
local autora = T{
    auto = false;
    running = false;
    Firing = false;
    settings = settings.load(default_settings),
};

settings.register('settings', 'settings_update', function(s)
    if (s ~=nil) then
        autora.settings = s;
    end

    settings.save();
end);

local makeString = function(table, value)
    if (table[value] == nil) then
        return 'Nil';
    else
        return table[value];
    end
end

local StatusTable = T{
    [0] = 'Idle',
    [1] = 'Engaged',
    [2] = 'Dead',
    [3] = 'Dead',
    [4] = 'Zoning',
    [33] = 'Resting'
};

local playerData = {};

--Send Shoot Command to Client--
local shoot = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/shoot <t>');
end

--Logic--
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    gPacket.HandleIncomingPacket(e);
end);

ashita.events.register('d3d_present', 'present_cb', function()
    --Player Information Build--
    local playerEntity = AshitaCore:GetMemoryManager():GetEntity();
    local party = AshitaCore:GetMemoryManager():GetParty();
    local playerIndex = party:GetMemberTargetIndex(0);
    playerData.statusID = playerEntity:GetStatus(playerIndex);
    playerData.status = makeString(StatusTable, playerEntity:GetStatus(playerIndex));
    playerData.TP = party:GetMemberTP(0);

    local LastRA = gPacket.RAFinTime;
    local delay = LastRA + 3;
    local curTime = os.time();
    playerData.TP = party:GetMemberTP(0);

    if(playerData.status == 'Engaged')then

        if(autora.auto == true)then
            if(playerData.TP >= 1000)then
                autora.auto = false;
                if(autora.settings.verbose == true)then
                    print(chat.header('AutoRA:  Auto Fire Blocked'));
                    print(chat.message('Reason:  1000 TP'));
                end
                return;
            end
            if(curTime > delay and gPacket.Firing == false)then
                gPacket.Firing = true;
                shoot();
            end
            if(curTime >= delay + 5 and gPacket.Firing == true)then
                gPacket.Firing = false;
            end
        else
            gPacket.Firing = false;
        end

    else

        if(autora.settings.verbose == true and autora.auto == true) then
            autora.auto = false;
            print(chat.header('AutoRA:  Auto Fire Blocked'));
            print(chat.message('Reason:  Player Not Engaged with Target'));
        end

    end

end);

ashita.events.register('command', 'command_cb', function (e)
    --Parse Arguments
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/autora')) then
        return;
    end

    --Block all related commands
    e.blocked = true;

    --Handle Command
    if(#args == 1) then
        return;
    end


    if (#args >= 2 and args[2]:any('start')) then
        if(playerData.statusID == 1) then
            autora.auto = true;
            shoot();
        end
    end
    if (#args >= 2 and args[2]:any('stop')) then
        autora.auto = false;
        if(autora.settings.verbose) then
            print(chat.header('AutoRA:  Auto Fire Disabled'));
            print(chat.message('Reason:  Player Manually Disabled'));
        end
    end
    if (#args >=2 and args[2]:any('verbose')) then
        autora.settings.verbose = not autora.settings.verbose;
        print(chat.header('Verbose mode toggled to:  '..tostring(autora.settings.verbose)));
    end
    if(#args >=2 and args[2]:any('haltontp')) then
        autora.settings.HaltOnTP = not autora.settings.HaltOnTP;
        print(chat.header('Halt On TP toggled to:  '..tostring(autora.settings.HaltOnTP)));
    end

end);

ashita.events.register('load', 'load_cb', function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/bind ^D /autora start');
    AshitaCore:GetChatManager():QueueCommand(-1, '/bind !D /autora stop');
end)

ashita.events.register('unload', 'unload_cb', function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/unbind ^D');
    AshitaCore:GetChatManager():QueueCommand(-1, '/unbind !D');
    settings.save();
end)

