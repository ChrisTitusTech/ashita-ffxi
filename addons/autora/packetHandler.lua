local ffi = require('ffi');
local chat = require('chat');

local packet = {}

packet.Player = 0;

packet.RAFinTime = 0;

packet.Firing = false;

--Handle Action Packets
packet.ActionPacket = function(pkt)
    local user = struct.unpack('L', pkt.data, 0x05 + 1);
    local actionType = ashita.bits.unpack_be(pkt.data_raw, 10, 2, 4);


    --Check if player server ID set.  If not, Set it.
    if(packet.Player == 0) then
        packet.Player = GetPlayerEntity().ServerId;
    end


    if(user == packet.Player)then
        if(actionType == 2 or actionType == 8 or actionType == 12) then
            packet.RAFinTime = os.time();
            packet.Firing = false;
        end
    end
end

packet.HandleIncomingPacket = function(pkt)
    if(pkt.id == 0x28)then
        packet.ActionPacket(pkt);
    end
end

return packet;