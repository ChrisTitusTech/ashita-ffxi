addon.name      = 'Porter';
addon.author    = 'Thorny';
addon.version   = '1.11';
addon.desc      = 'Simplifies usage of porter moogles.';
addon.link      = 'https://github.com/ThornyFFXI/';

require('common');
chat = require('chat');
gData = require('data');
gPack = require('pack');
gPrep = require('prep');
gSettings = require('settings');
gUnpack = require('unpack');
gEvent = nil;
require('commands');
require('integration');

ashita.events.register('packet_in', 'packet_in_cb', function (e)
    if (type(gEvent) == 'table') then
        if (type(gEvent.HandleIncomingPacket) == 'function') then
            gEvent:HandleIncomingPacket(e);
        end
        if (gEvent.State == 0) then
            gEvent = nil;
            if (gSettings.BlockInput) then
                AshitaCore:GetInputManager():GetKeyboard():SetBlockInput(false);
                AshitaCore:GetInputManager():GetMouse():SetBlockInput(false);
            end
        end
    end
end);

ashita.events.register('packet_out', 'packet_out_cb', function (e)
    if (type(gEvent) == 'table') then
        if (type(gEvent.HandleOutgoingPacket) == 'function') then
            gEvent:HandleOutgoingPacket(e);
        end
        if (gEvent.State == 0) then
            gEvent = nil;
            if (gSettings.BlockInput) then
                AshitaCore:GetInputManager():GetKeyboard():SetBlockInput(false);
                AshitaCore:GetInputManager():GetMouse():SetBlockInput(false);
            end
        end
    end
end);