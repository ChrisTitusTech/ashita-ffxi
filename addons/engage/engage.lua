--[[
* MIT License
* 
* Copyright (c) 2017 zechs6437 [github.com/zechs6437]
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

----------------------------------------------------------------------------------------------------
-- func: incoming_packet
-- desc: Event called when the addon is processing incoming packets.
----------------------------------------------------------------------------------------------------
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Check if this is an action packet
    if (e.id == packets.action) then
        local data = e.data_modified;
        local count = struct.unpack('B', data, 10);
        local raw_category = struct.unpack('B', data, 11);
        local category = bit.rshift(bit.band(raw_category, 63), 2);
        
        -- Handle both regular (0x2C) and special (0xAC) action packets
        if (raw_category == 0x2C or raw_category == 0xAC) then
            if debug_enabled then
                print(string.format('[Engage] Processing action packet - Count: %d, Raw Category: %x', count, raw_category));
            end
            
            local offset = 150;
            local modified = false;

            -- Convert data to a mutable format
            local bytes = {};
            for i = 1, #data do
                bytes[i] = struct.unpack('B', data, i);
            end

            -- Process each target in the packet
            for i = 1, count do
                -- Clear all movement/position related bits
                local bits_to_clear = {60, 121, 122}
                if raw_category == 0xAC then
                    -- Add additional bits for special action packets
                    bits_to_clear = {60, 121, 122, 123, 124, 125}
                end

                for _, bit_pos in ipairs(bits_to_clear) do
                    local bit_offset = offset + bit_pos;
                    local byte_index = math.floor(bit_offset / 8) + 1;
                    local bit_index = bit_offset % 8;
                    
                    if byte_index <= #bytes then
                        local before = bytes[byte_index];
                        bytes[byte_index] = bit.band(bytes[byte_index], bit.bnot(bit.lshift(1, bit_index)));
                        local after = bytes[byte_index];
                        
                        if before ~= after and debug_enabled then
                            print(string.format('[Engage] Modified bit at offset %d (byte %d, bit %d): %02x -> %02x', 
                                bit_offset, byte_index, bit_index, before, after));
                            modified = true;
                        end
                    end
                end

                -- Calculate next offset based on packet type
                local next_offset = offset + 123;
                if raw_category == 0xAC then
                    next_offset = offset + 150; -- Adjust for special action packets
                end
                
                -- Check for additional data
                local check_offset1 = math.floor((offset + 121) / 8) + 1;
                local check_offset2 = math.floor((offset + 122) / 8) + 1;
                
                if check_offset1 <= #bytes and check_offset2 <= #bytes then
                    if bit.band(bytes[check_offset1], bit.lshift(1, ((offset + 121) % 8))) ~= 0 then
                        next_offset = next_offset + 37;
                    end
                    if bit.band(bytes[check_offset2], bit.lshift(1, ((offset + 122) % 8))) ~= 0 then
                        next_offset = next_offset + 34;
                    end
                end
                
                if debug_enabled then
                    print(string.format('[Engage] Processed target %d/%d, offset: %d -> %d (Raw Category: %x)', 
                        i, count, offset, next_offset, raw_category));
                end
                
                offset = next_offset;
            end

            -- If we modified the packet, rebuild it and return
            if modified then
                local new_data = '';
                for i = 1, #bytes do
                    new_data = new_data .. struct.pack('B', bytes[i]);
                end
                e.data_modified = new_data;
                if debug_enabled then
                    print(string.format('[Engage] Packet modified successfully (Raw Category: %x)', raw_category));
                end
                return true;
            elseif debug_enabled then
                print(string.format('[Engage] No modifications needed for packet (Raw Category: %x)', raw_category));
            end
        end
    end
end);

-- Add this function after the other event handlers
ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args > 0 and args[1]:lower() == '/engage') then
        if (#args > 1 and args[2]:lower() == 'debug') then
            debug_enabled = not debug_enabled;
            print(string.format('[Engage] Debug output %s', debug_enabled and 'enabled' or 'disabled'));
            e.blocked = true;
        end
    end
end);
