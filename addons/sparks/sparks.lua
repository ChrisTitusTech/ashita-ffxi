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

-- Debug configuration
local debug = {
    enabled = true,
    log_path = string.format('%s/config/addons/%s/debug.log', AshitaCore:GetInstallPath(), 'sparks'),
    ignored_packets = { [0x0E] = true, [0x00] = true, [0x17] = true, [0x0D] = true }
};

-- Simplified debug logging
local function log(msg, level)
    if not debug.enabled then return end
    
    -- Ensure log directory exists
    local dir_path = string.format('%s/config/addons/%s', AshitaCore:GetInstallPath(), 'sparks');
    if not ashita.fs.create_directory(dir_path) then
        print(chat.header('Sparks') .. chat.error('Failed to create log directory'));
        return;
    end
    
    -- Format message with timestamp
    local log_msg = string.format("[%s] %s\n", os.date("%Y-%m-%d %H:%M:%S"), msg);
    
    -- Write to file
    local file = io.open(debug.log_path, 'a');
    if file then
        file:write(log_msg);
        file:close();
        
        -- Print to chat if it's an error or warning
        if level == 'error' or level == 'warning' then
            print(chat.header('Sparks') .. chat[level](msg));
        elseif debug.enabled then
            print(chat.header('Sparks Debug') .. chat.message(msg));
        end
    end
end

-- Packet debug helper
local function log_packet(id, data, direction)
    if debug.ignored_packets[id] then return end
    
    -- Basic packet info
    local msg = string.format('%s packet: 0x%02X', direction, id);
    
    -- For specific packets, add detailed info
    if id == 0x52 and data then
        local bytes = data:totable();
        local byteString = table.concat(
            table.map(bytes, function(b, i) 
                return string.format('%02X', b) 
            end, 1, math.min(16, #bytes)),
            ' '
        );
        msg = msg .. '\nBytes: ' .. byteString;
    end
    
    log(msg);
end

-- Clear debug log
local function clear_debug_log()
    local file = io.open(debug.log_path, 'w');
    if file then
        file:write(string.format("--- New Debug Session Started: %s ---\n", os.date()));
        file:close();
        log('Debug log cleared');
    else
        log('Failed to clear log file', 'error');
    end
end

-- Helper function to find NPC by name
local function GetNPCByName(name)
    local entityArray = AshitaCore:GetMemoryManager():GetEntity();
    local entityCount = entityArray:GetEntityMapSize();
    for i = 0, entityCount do
        local ent_name = entityArray:GetName(i);
        if (ent_name ~= nil and ent_name == name) then
            local serverId = entityArray:GetServerId(i);
            -- Extract the lower 16 bits of the server ID to match successful purchases
            local targetId = bit.band(serverId, 0xFFFF);
            log(string.format('Found NPC: %s, Index: %d, Server ID: %d, Target ID: %d', name, i, serverId, targetId));
            return { 
                index = i,
                target = targetId  -- Use the lower 16 bits instead of full server ID
            };
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
    log('Validating item: ' .. item);
    local zone = AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0);
    log('Current zone: ' .. zone);
    
    local result = {};
    
    if valid_zones[zone] then
        log('Found valid zone entry: ' .. valid_zones[zone].npc);
        local npc = GetNPCByName(valid_zones[zone].npc);
        if npc then
            log(string.format('Found NPC at index: %d with target ID: %d', npc.index, npc.target));
            local ite = fetch_db(item);
            if ite then
                log(string.format('Found item in db - Option: %d, Index: %d', ite.Option, ite.Index));
                result = {
                    Target = npc.target,        -- Use actual server ID
                    ['Target Index'] = npc.index,
                    Zone = zone,
                    ['Menu ID'] = valid_zones[zone].menu,
                    ['Option Index'] = ite.Option,
                    ['_unknown1'] = ite.Index
                };
                log('Result packet created');
            else
                log('Item not found in database');
                print(chat.header('Sparks') .. chat.error("Item not found in database"));
            end
        else
            log('NPC not found');
        end
    else
        log('Not in a valid zone');
        print(chat.header('Sparks') .. chat.error('Not in a zone with sparks NPC'));
    end
    
    return result;
end

-- Update the poke_npc function to include debug info
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
        log(string.format('Sending poke packet - Target Index: %d, Target ID: %d', target_index, target_id));
        AshitaCore:GetPacketManager():AddOutgoingPacket(0x1A, packet:totable());
    end
end

-- Modify the command handler
ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args > 0 and args[1]:lower() == '/sparks') then
        e.blocked = true;
        
        if (#args < 2) then
            print(chat.header('Sparks') .. chat.message('Usage: /sparks buy <item> or /sparks clearlog'));
            return;
        end

        local cmd = args[2]:lower();
        
        if cmd == 'clearlog' then
            clear_debug_log();
            return;
        elseif cmd == 'buy' then
            if (#args < 3) then
                print(chat.header('Sparks') .. chat.message('Usage: /sparks buy <item>'));
                return;
            end
            
            -- Join all words after "buy" into a single item name
            local item_name = table.concat(args, ' ', 3);
            busy = false;
            pkt = validate(item_name:lower());
            if next(pkt) ~= nil then
                busy = true;
                log('Poking NPC');
                poke_npc(pkt.Target, pkt['Target Index']);
                log('Initial interaction sent');
            else
                log('Can\'t find NPC');
            end
        end
    end
end);

-- Update packet handlers to use new logging
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    if not busy then return false; end
    
    log_packet(e.id, e.data_modified, 'Received');
    
    -- Handle menu response (0x52) or completion (0x67) packets
    if (e.id == 0x52 or e.id == 0x67) and busy then
        local menuId = valid_zones[pkt.Zone].menu;
        local npc = GetNPCByName(valid_zones[pkt.Zone].npc);
        
        -- Create menu packet
        local menu_packet = {
            0x5B,        -- Packet ID
            0x0A,        -- Size
            0x1F, 0x13,  -- Sequence
            bit.band(npc.target, 0xFF), bit.rshift(npc.target, 8),  -- Target ID bytes
            0x0F,        -- Flag
            0x01,        -- Sub flag
            (e.id == 0x52) and pkt['Option Index'] or 0x00, 0x00,  -- Option
            (e.id == 0x52) and pkt['_unknown1'] or 0x00, 0x00,     -- Index
            npc.index, 0x00,  -- Target Index
            0x01, 0x00,  -- Flag
            0xF1, 0x03,  -- Menu flag
            bit.band(menuId, 0xFF), bit.rshift(menuId, 8)  -- Menu ID
        };

        if e.id == 0x52 then
            -- Add small delay before sending menu selection
            coroutine.sleep(0.5);
            
            log('Sending menu selection packet...');
            local packet = string.char(unpack(menu_packet));
            AshitaCore:GetPacketManager():AddOutgoingPacket(0x5B, packet:totable());
            log('Menu selection packet sent');

            -- Wait exactly 2 seconds before sending exit
            coroutine.sleep(2.0);
            
            -- Send exit packet
            menu_packet[9] = 0x00;   -- Change to exit option
            menu_packet[11] = 0x00;  -- Change index to 0
            packet = string.char(unpack(menu_packet));
            AshitaCore:GetPacketManager():AddOutgoingPacket(0x5B, packet:totable());
            log('Exit packet sent');
        end
        
        busy = false;
        return true;
    end
    return false;
end);

ashita.events.register('packet_out', 'packet_out_cb', function (e)
    if e.id == 0x5B then
        local p = e.data_modified;
        local details = {
            target = struct.unpack('B', p, 0x04 + 1) + (struct.unpack('B', p, 0x05 + 1) * 256),
            option = struct.unpack('B', p, 0x08 + 1),
            index = struct.unpack('B', p, 0x0A + 1),
            target_index = struct.unpack('B', p, 0x0C + 1),
            menu_id = struct.unpack('H', p, 0x12 + 1)
        };
        
        log(string.format(
            'Menu Selection Details:\n' ..
            '  Target: %d (0x%X)\n' ..
            '  Option: %d (0x%X)\n' ..
            '  Index: %d (0x%X)\n' ..
            '  Target Index: %d (0x%X)\n' ..
            '  Menu ID: %d (0x%X)',
            details.target, details.target,
            details.option, details.option,
            details.index, details.index,
            details.target_index, details.target_index,
            details.menu_id, details.menu_id
        ));
    end
end);

