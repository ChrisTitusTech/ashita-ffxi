addon.name      = 'sparks';
addon.author    = 'original: Brax, sammeh - converted: christitustech';
addon.version   = '1.0';
addon.desc      = 'Buy items with sparks currency';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');

-- Valid zones and their NPCs
local valid_zones = {
    [256] = {npc="Eternal Flame", menu=5081}, -- Western Adoulin
    [230] = {npc="Rolandienne", menu=995},    -- Southern San d'Oria
    [235] = {npc="Isakoth", menu=26},         -- Bastok Markets
    [241] = {npc="Fhelm Jobeizat", menu=850}, -- Windurst Woods
    [288] = {npc="Affi", menu=9701},          -- Escha Zitah
    [289] = {npc="Dremi", menu=9701},         -- Escha RuAun
    [291] = {npc="Shiftrix", menu=9701},      -- Reisinjima
};

local busy = false;
local pkt = {};

-- Sample item database (you'll need to expand this)
local db = {
    ['acheron shield'] = {
        Name = 'Acheron Shield',
        Option = 9,    -- Menu option from packet
        Index = 41     -- Item index from packet
    },
    -- Add more items here
};

-- Add at the top with other locals
local debug_mode = true;

-- Helper function for debug logging
local function debug_print(msg)
    if debug_mode then
        print(chat.header('Sparks Debug') .. chat.message(msg));
    end
end

-- Helper function to find NPC by name
local function GetNPCByName(name)
    local entityArray = AshitaCore:GetMemoryManager():GetEntity();
    local entityCount = entityArray:GetEntityMapSize();
    for i = 0, entityCount do
        local ent_name = entityArray:GetName(i);
        if (ent_name ~= nil and ent_name == name) then
            return { index = i };
        end
    end
    return nil;
end

-- Helper function to fetch item from database
local function fetch_db(item)
    return db[item:lower()];
end

-- Helper function to validate item purchase
local function validate(item)
    debug_print('Validating item: ' .. item);
    local zone = AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0);
    debug_print('Current zone: ' .. zone);
    
    local result = {};
    
    if valid_zones[zone] then
        debug_print('Found valid zone entry: ' .. valid_zones[zone].npc);
        local npc = GetNPCByName(valid_zones[zone].npc);
        if npc then
            debug_print('Found NPC at index: ' .. npc.index);
            local ite = fetch_db(item);
            if ite then
                debug_print(string.format('Found item in db - Option: %d, Index: %d', ite.Option, ite.Index));
                result = {
                    Target = 17764603,
                    ['Target Index'] = npc.index,
                    Zone = zone,
                    ['Menu ID'] = valid_zones[zone].menu,
                    ['Option Index'] = ite.Option,
                    ['_unknown1'] = ite.Index
                };
                debug_print('Result packet created');
            else
                debug_print('Item not found in database');
                print(chat.header('Sparks') .. chat.error("Item not found in database"));
            end
        else
            debug_print('NPC not found');
        end
    else
        debug_print('Not in a valid zone');
        print(chat.header('Sparks') .. chat.error('Not in a zone with sparks NPC'));
    end
    
    return result;
end

-- Add this helper function at the top with other functions
local function poke_npc(target_id, target_index)
    if target_id and target_index then
        local packet = struct.pack('LHBBBB', 
            target_index,    -- Target Index first
            0,              -- Category
            0,              -- Param
            0,
            0,
            0
        );
        AshitaCore:GetPacketManager():AddOutgoingPacket(0x1A, packet:totable());
    end
end

-- Modify the command handler
ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args > 0 and args[1]:lower() == '/sparks') then
        e.blocked = true;
        
        if (#args < 2) then
            print(chat.header('Sparks') .. chat.message('Usage: /sparks buy <item>'));
            return;
        end

        local cmd = args[2]:lower();
        local item = table.concat(args, ' ', 3):lower();

        if cmd == 'buy' then
            busy = false;
            pkt = validate(item);
            if next(pkt) ~= nil then
                busy = true;
                debug_print('Poking NPC');
                poke_npc(17764603, pkt['Target Index']);
                debug_print('Initial interaction sent');
            else
                print(chat.header('Sparks') .. chat.error("Can't find NPC"));
            end
        end
    end
end);

-- Packet handler - Menu interaction
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    if not busy then return false; end

    -- Only show important packets
    if e.id ~= 0x0E and e.id ~= 0x00 and e.id ~= 0x17 and e.id ~= 0x0D then
        debug_print(string.format('Received packet: 0x%02X', e.id));
        
        -- If it's the response packet, let's see what's in it
        if e.id == 0x52 then
            local data = e.data_modified;
            local bytes = data:totable();
            local byteString = '';
            for i = 1, math.min(16, #bytes) do
                byteString = byteString .. string.format(' %02X', bytes[i]);
            end
            debug_print('Response packet bytes:' .. byteString);
        end
    end

    -- When we get the NPC response packet
    if e.id == 0x52 and busy then
        debug_print('NPC response received - sending menu choice');
        
        -- Menu selection packet
        local packet = struct.pack('LHHLLBB', 
            2686985,            -- Target ID from debug output
            9,                  -- Option for Acheron Shield
            41,                 -- Index for Acheron Shield
            251,                -- Target Index from debug output
            pkt['Menu ID'],
            1,                  -- Automated flag
            0
        );
        AshitaCore:GetPacketManager():AddOutgoingPacket(0x5B, packet:totable());
        debug_print('Sent menu selection');

        coroutine.sleep(0.2);

        -- Confirmation packet
        packet = struct.pack('LHHLLBB',
            2686990,            -- Target ID from second debug output
            14,                 -- Confirm option
            41,                 -- Keep Acheron Shield index
            251,                -- Target Index
            pkt['Menu ID'],
            1,                  -- Automated flag
            0
        );
        AshitaCore:GetPacketManager():AddOutgoingPacket(0x5B, packet:totable());
        debug_print('Sent confirmation');

        coroutine.sleep(0.2);

        -- Exit packet
        packet = struct.pack('LHHLLBB',
            2686990,            -- Keep last Target ID
            0,                  -- Exit option
            16384,              -- Exit index
            251,                -- Target Index
            pkt['Menu ID'],
            0,                  -- Not automated
            0
        );
        AshitaCore:GetPacketManager():AddOutgoingPacket(0x5B, packet:totable());
        debug_print('Sent exit');
        
        busy = false;
        return true;
    end
    return false;
end);

-- Add packet out monitoring with parsed values
ashita.events.register('packet_out', 'packet_out_cb', function (e)
    if e.id == 0x5B then
        local p = e.data_modified;
        local target = struct.unpack('L', p, 0x04 + 1);
        local option = struct.unpack('H', p, 0x08 + 1);
        local index = struct.unpack('H', p, 0x0A + 1);
        print(chat.header('Sparks') .. chat.message(string.format(
            'Menu Selection - Target: %d, Option: %d, Index: %d',
            target, option, index
        )));
    end
end);

-- Modified packet monitor
ashita.events.register('packet_in', 'monitor_cb', function (e)
    if busy then
        -- Only show important packets
        if e.id ~= 0x0E and e.id ~= 0x00 and e.id ~= 0x17 then
            debug_print(string.format('Received packet: 0x%02X', e.id));
        end
    end
end);

