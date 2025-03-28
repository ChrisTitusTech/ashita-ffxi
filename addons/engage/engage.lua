--[[
* MIT License
* 
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

addon.name      = 'engage';
addon.author    = 'christitustech';
addon.version   = '1.0';
addon.desc      = 'Removes locking and delays from engage and job abilities.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local ffi = require('ffi');

local engage = {
    ja0_ptr = 0,
    engage_ptr = 0,
    ja0_backup = nil,
    engage_backup = nil,
    gc = nil,
};

-- Add packet handling variables
local packets = {
    action = 0x28, -- Action packet ID
    category_offset = 10,
    category_size = 4,
    position_bits = {60, 121, 122}, -- Bits to clear for position data
};

-- Add near the top of the file with other variables
local debug_enabled = false;
local anchor_enabled = true; -- Default to enabled

-- Add these new memory signature patterns near the top with other variables
local MOVEMENT_SIGNATURES = {
    tp_move = ashita.memory.find('FFXiMain.dll', 0, '8B????????????????????D95C24', 0x00, 0x00),
    animation = ashita.memory.find('FFXiMain.dll', 0, '89??????????8B??????????8B????89', 0x00, 0x00),
};

print(chat.header(addon.name):append(chat.message('Loaded with packet handling enabled.')));

---------------------------------------------------------------------------------------------------
-- ja0wait Table
---------------------------------------------------------------------------------------------------
local JA0WAIT = { };
local ENGAGE0WAIT = { };

--search bytes
JA0WAIT.pointer = ashita.memory.find('FFXiMain.dll', 0, '8B81FC00000040', 0x00, 0x00);
ENGAGE0WAIT.pointer = ashita.memory.find('FFXiMain.dll', 0, '66FF81????????66C781????????0807C3', 0x00, 0x00);

--patches
JA0PATCH = { 0x8B, 0x81, 0xFC, 0x00, 0x00, 0x00, 0x90 };
ENGAGEPATCH = { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 };

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.events.register('load', 'load_cb', function ()
    -- Find the memory patterns
    engage.ja0_ptr = ashita.memory.find('FFXiMain.dll', 0, '8B81FC00000040', 0x00, 0x00);
    engage.engage_ptr = ashita.memory.find('FFXiMain.dll', 0, '66FF81????????66C781????????0807C3', 0x00, 0x00);

    -- Validate the pointers
    if (engage.ja0_ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Failed to find ja0wait signature.')));
        return;
    end
    if (engage.engage_ptr == 0) then
        error(chat.header(addon.name):append(chat.error('Failed to find engage0wait signature.')));
        return;
    end

    -- Backup the original bytes
    engage.ja0_backup = ashita.memory.read_array(engage.ja0_ptr, 7);
    engage.engage_backup = ashita.memory.read_array(engage.engage_ptr, 7);

    -- Write the patches
    ashita.memory.write_array(engage.ja0_ptr, JA0PATCH);
    ashita.memory.write_array(engage.engage_ptr, ENGAGEPATCH);

    -- Add new movement related patches
    if (MOVEMENT_SIGNATURES.tp_move ~= 0) then
        -- Patch TP movement handler
        ashita.memory.write_array(MOVEMENT_SIGNATURES.tp_move, {0x90, 0x90, 0x90, 0x90, 0x90});
    end
    
    if (MOVEMENT_SIGNATURES.animation ~= 0) then
        -- Patch animation movement handler
        ashita.memory.write_array(MOVEMENT_SIGNATURES.animation, {0x90, 0x90, 0x90, 0x90});
    end

    print(chat.header(addon.name):append(chat.message('Functions patched; slip and slide around all you want.')));
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.events.register('unload', 'unload_cb', function ()
    if (engage.ja0_backup ~= nil) then
        ashita.memory.write_array(engage.ja0_ptr, engage.ja0_backup);
    end
    if (engage.engage_backup ~= nil) then
        ashita.memory.write_array(engage.engage_ptr, engage.engage_backup);
    end
end);

-- Garbage Collection Cleanup
engage.gc = ffi.gc(ffi.cast('uint8_t*', 0), function ()
    if (engage.ja0_backup ~= nil) then
        ashita.memory.write_array(engage.ja0_ptr, engage.ja0_backup);
    end
    if (engage.engage_backup ~= nil) then
        ashita.memory.write_array(engage.engage_ptr, engage.engage_backup);
    end
    engage.ja0_ptr = 0;
    engage.engage_ptr = 0;
end);

-- Simplified bit manipulation helper functions
local function clear_bit_at_position(bytes, bit_offset)
    local byte_index = math.floor(bit_offset / 8) + 1
    local bit_index = bit_offset % 8
    
    if byte_index <= #bytes then
        local before = bytes[byte_index]
        bytes[byte_index] = bit.band(bytes[byte_index], bit.bnot(bit.lshift(1, bit_index)))
        return before ~= bytes[byte_index]
    end
    return false
end

----------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Event called when the addon is processing incoming packets.
----------------------------------------------------------------------------------------------------
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Only process packets if anchor is enabled
    if not anchor_enabled then
        return false
    end
    
    -- Check for movement packets (0x28 and 0x29)
    if (e.id == 0x28 or e.id == 0x29) then
        local data = e.data_modified
        local animation_type = struct.unpack('B', data, 11)
        
        -- If this is a TP move or ability animation
        if (animation_type >= 0x20 and animation_type <= 0x24) then
            -- Zero out movement coordinates
            local modified_data = data:sub(1, 28) .. string.char(0,0,0,0) .. data:sub(33)
            e.data_modified = modified_data
            return true
        end
    end
    
    -- Process action packets
    if e.id == packets.action then
        local data = e.data_modified
        local count = struct.unpack('B', data, 10)
        local raw_category = struct.unpack('B', data, 11)
        local category = bit.rshift(bit.band(raw_category, 63), 2)
        
        -- Convert data to a mutable format
        local bytes = {}
        for i = 1, #data do
            bytes[i] = struct.unpack('B', data, i)
        end
        
        local modified = false
        local position = 150
        
        -- Handle all action packet types in a consistent way
        if category == 11 or raw_category == 0x2C or raw_category == 0xAC then
            if debug_enabled then
                print(string.format('[Engage] Processing packet - Count: %d, Category: %d, Raw: 0x%x', 
                    count, category, raw_category))
            end
            
            -- Process each target in the packet
            for target = 1, count do
                -- Determine which bits to clear based on packet type
                local bits_to_clear = {60, 121, 122}
                
                -- Special case for 0xAC packets
                if raw_category == 0xAC then
                    -- For 0xAC packets we need to clear additional bits
                    bits_to_clear = {60, 121, 122, 123, 124, 125}
                    
                    -- Handle the problematic bit at offset 725 (byte 91, bit 5)
                    -- Force clear this specific bit that's causing movement
                    local byte_91 = math.floor(725 / 8) + 1  -- Should be 91
                    local bit_5 = 5  -- The specific bit position
                    
                    if byte_91 <= #bytes then
                        -- Directly manipulate the specific byte and bit
                        local before = bytes[byte_91]
                        bytes[byte_91] = bit.band(bytes[byte_91], bit.bnot(bit.lshift(1, bit_5)))
                        local after = bytes[byte_91]
                        
                        if before ~= after then
                            modified = true
                            if debug_enabled then
                                print(string.format('[Engage] Directly cleared movement bit at byte 91, bit 5: %02x -> %02x', 
                                    before, after))
                            end
                        end
                    end
                    
                    -- Additionally, clear specific ranges where movement flags might exist
                    -- First range: around position + 575
                    for offset = position + 570, position + 580 do
                        if clear_bit_at_position(bytes, offset) then
                            modified = true
                            if debug_enabled then
                                print(string.format('[Engage] Cleared bit in first range at offset %d', offset))
                            end
                        end
                    end
                    
                    -- Second range: check entire packet for bit 5 patterns (common movement flag)
                    for byte_idx = 1, #bytes do
                        -- Check if bit 5 is set in this byte
                        if bit.band(bytes[byte_idx], bit.lshift(1, 5)) ~= 0 then
                            -- Clear the specific bit 5
                            local old_val = bytes[byte_idx]
                            bytes[byte_idx] = bit.band(bytes[byte_idx], bit.bnot(bit.lshift(1, 5)))
                            
                            if old_val ~= bytes[byte_idx] and debug_enabled then
                                print(string.format('[Engage] Cleared movement pattern at byte %d, bit 5: %02x -> %02x', 
                                    byte_idx, old_val, bytes[byte_idx]))
                            end
                            modified = true
                        end
                    end
                    
                    -- Also clear some additional potential movement flags in the header
                    -- Many movement flags are in the header area
                    for header_byte = 20, 40 do
                        if header_byte <= #bytes then
                            local old_val = bytes[header_byte]
                            -- Clear bits 4, 5, and 6 which are commonly used for movement flags
                            bytes[header_byte] = bit.band(bytes[header_byte], bit.bnot(0x70))  -- 0x70 = bits 4,5,6
                            
                            if old_val ~= bytes[header_byte] and debug_enabled then
                                print(string.format('[Engage] Cleared header movement flags at byte %d: %02x -> %02x', 
                                    header_byte, old_val, bytes[header_byte]))
                            end
                            modified = true
                        end
                    end
                end
                
                -- Clear all relevant bits
                for _, bit_pos in ipairs(bits_to_clear) do
                    local bit_offset = position + bit_pos
                    if clear_bit_at_position(bytes, bit_offset) then
                        modified = true
                        if debug_enabled then
                            local byte_index = math.floor(bit_offset / 8) + 1
                            local bit_index = bit_offset % 8
                            print(string.format('[Engage] Modified bit at offset %d (byte %d, bit %d)', 
                                bit_offset, byte_index, bit_index))
                        end
                    end
                end
                
                -- Calculate next position based on packet type and bit flags
                local next_position
                if raw_category == 0xAC then
                    next_position = position + 150
                    
                    -- For 0xAC packets, also check bits in the potential movement area
                    for check_pos = position + 570, position + 580 do
                        -- Check every bit in this range that might control movement
                        if check_pos % 8 == 5 and check_bit_at_position(bytes, check_pos) then
                            if clear_bit_at_position(bytes, check_pos) then
                                modified = true
                                if debug_enabled then
                                    print(string.format('[Engage] Cleared additional movement bit at offset %d', check_pos))
                                end
                            end
                        end
                    end
                else
                    next_position = position + 123
                    
                    -- Check extension bits and adjust position
                    if check_bit_at_position(bytes, position + 121) then
                        next_position = next_position + 37
                    end
                    if check_bit_at_position(bytes, position + 122) then
                        next_position = next_position + 34
                    end
                end
                
                if debug_enabled then
                    print(string.format('[Engage] Processed target %d/%d, position: %d -> %d', 
                        target, count, position, next_position))
                end
                
                position = next_position
            end
            
            -- If we modified the packet, rebuild it and return
            if modified then
                local new_data = ''
                for i = 1, #bytes do
                    new_data = new_data .. struct.pack('B', bytes[i])
                end
                e.data_modified = new_data
                if debug_enabled then
                    print('[Engage] Packet modification complete')
                end
                return true
            elseif debug_enabled then
                print('[Engage] No modifications needed for packet')
            end
        end
    end
    
    return false
end)

-- Update the command handler to include anchor toggle
ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args > 0 and args[1]:lower() == '/engage') then
        if (#args > 1) then
            if (args[2]:lower() == 'debug') then
                debug_enabled = not debug_enabled;
                print(string.format('[Engage] Debug output %s', debug_enabled and 'enabled' or 'disabled'));
                e.blocked = true;
            elseif (args[2]:lower() == 'anchor') then
                anchor_enabled = not anchor_enabled;
                print(string.format('[Engage] Anchor functionality %s', anchor_enabled and 'enabled' or 'disabled'));
                e.blocked = true;
            end
        else
            -- Show help
            print(chat.header(addon.name):append(chat.message('Available commands:')));
            print(chat.header(addon.name):append(chat.message('/engage debug - Toggle debug output')));
            print(chat.header(addon.name):append(chat.message('/engage anchor - Toggle anchor functionality')));
            e.blocked = true;
        end
    end
end);
