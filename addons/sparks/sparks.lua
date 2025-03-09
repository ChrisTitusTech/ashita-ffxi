addon.name      = 'sparks'
addon.author    = 'Tumz'
addon.version   = '0.0.0.1'
addon.desc      = 'Automates sparks and unity accolade purchases'
addon.commands  = {'/sparks'}

require('common')
local chat = require('chat')

-- Only keep the essential zones and NPCs
local zones = {
    [230] = {sparks = 'Rolandienne',     unity = 'Urbiolaine'},
    [235] = {sparks = 'Isakoth',         unity = 'Igsli'},
    [241] = {sparks = 'Fhelm Jobeizat',  unity = 'Teldro-Kesdrodo'},
    [256] = {sparks = 'Eternal Flame',   unity = 'Nunaarl Bthtrogg'},
}

local state = 0  -- 0 = idle, 1 = waiting for menu

-- Copy sellit's exact packet structure
local function interact_npc(entity)
    local appraise = struct.pack('LLHHFF', 0, entity.ServerId, entity.TargetIndex, 0, 0, 0):totable()
    AshitaCore:GetPacketManager():AddOutgoingPacket(0x1A, appraise)
    state = 1
end

ashita.events.register('command', 'command_cb', function(e)
    if string.sub(string.lower(e.command), 1, 7) ~= '/sparks' then
        return
    end

    e.blocked = true
    
    local target = AshitaCore:GetMemoryManager():GetTarget()
    local entity = AshitaCore:GetMemoryManager():GetEntity()
    local zone_id = AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0)
    
    local targetIndex = target:GetTargetIndex()
    local targetEntity = entity:GetEntity(targetIndex)
    
    if targetIndex == 0 or not targetEntity then
        print(chat.header(addon.name):append('No target selected'))
        return
    end

    if not zones[zone_id] then
        print(chat.header(addon.name):append('Not in a valid sparks zone'))
        return
    end

    -- Debug output
    print(chat.header(addon.name):append(string.format('Target: %s, ID: %u, Index: %u', 
        targetEntity.Name, targetEntity.ServerId, targetIndex)))

    if targetEntity.Name == zones[zone_id].sparks or targetEntity.Name == zones[zone_id].unity then
        local packet = {
            0x00, 0x00, 0x00, 0x00,  -- uint32 zero
            0x00, 0x00, 0x00, 0x00,  -- uint32 target_id
            0x00, 0x00,              -- uint16 target_index
            0x00, 0x00,              -- uint16 zero
            0x00, 0x00, 0x00, 0x00,  -- float zero
            0x00, 0x00, 0x00, 0x00   -- float zero
        }
        struct.pack(packet, 1, 'LLHHFF', 0, targetEntity.ServerId, targetIndex, 0, 0.0, 0.0)
        AshitaCore:GetPacketManager():AddOutgoingPacket(0x1A, packet)
        state = 1
    else
        print(chat.header(addon.name):append('Invalid target. Please select a Sparks or Unity NPC'))
    end
end)

-- Handle menu responses
ashita.events.register('packet_in', 'packet_in_cb', function(e)
    if e.id == 0x034 and state == 1 then
        local target = AshitaCore:GetMemoryManager():GetTarget()
        local entity = AshitaCore:GetMemoryManager():GetEntity()
        local zone_id = AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0)
        local targetIndex = target:GetTargetIndex()
        local targetEntity = entity:GetEntity(targetIndex)
        
        if targetEntity.Name == zones[zone_id].sparks then
            local menu = {
                0x00, 0x00, 0x00, 0x00,  -- uint32 zero
                0x00, 0x00, 0x00, 0x00,  -- uint32 target_id
                0x00, 0x00,              -- uint16 option
                0x00, 0x00,              -- uint16 target_index
                0x00, 0x00,              -- uint16 automated
                0x00, 0x00               -- uint16 zone_id
            }
            struct.pack(menu, 1, 'LLHHHH', 0, targetEntity.ServerId, 0x03020F, targetIndex, 1, zone_id)
            AshitaCore:GetPacketManager():AddOutgoingPacket(0x5B, menu)
        elseif targetEntity.Name == zones[zone_id].unity then
            local menu = {
                0x00, 0x00, 0x00, 0x00,  -- uint32 zero
                0x00, 0x00, 0x00, 0x00,  -- uint32 target_id
                0x00, 0x00,              -- uint16 option
                0x00, 0x00,              -- uint16 target_index
                0x00, 0x00,              -- uint16 automated
                0x00, 0x00               -- uint16 zone_id
            }
            struct.pack(menu, 1, 'LLHHHH', 0, targetEntity.ServerId, 0x00A, targetIndex, 1, zone_id)
            AshitaCore:GetPacketManager():AddOutgoingPacket(0x5B, menu)
        end
        state = 0
    end
end)
