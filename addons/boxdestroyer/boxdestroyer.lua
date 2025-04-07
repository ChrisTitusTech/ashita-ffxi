--[[
Copyright (c) 2014, Seth VanHeulen
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:
1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]

-- addon information
addon.name = 'boxdestroyer'
addon.version = '1.0.0'
addon.command = 'boxdestroyer'
addon.author = 'Zechs6437 (Maarek@Fenrir) (original by Seth VanHeulen (Acacia@Odin))'
addon.desc = 'Helps solve treasure caskets by tracking possible combinations.'

-- modules
require('common')
local chat = require('chat')
require('messages')

-- global constants
default = {
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
    40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
    50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
    60, 61, 62, 63, 64, 65, 66, 67, 68, 69,
    70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
    80, 81, 82, 83, 84, 85, 86, 87, 88, 89,
    90, 91, 92, 93, 94, 95, 96, 97, 98, 99
}

-- global variables
local box = {}

-- filter helper functions
local function greater_less(id, greater, num)
    if box[id] == nil then
        box[id] = default
    end
    local new = {}
    for _,v in pairs(box[id]) do
        if greater and v > num or not greater and v < num then
            table.insert(new, v)
        end
    end
    return new
end

local function even_odd(id, div, rem)
    if box[id] == nil then
        box[id] = default
    end
    local new = {}
    for _,v in pairs(box[id]) do
        if (math.floor(v / div) % 2) == rem then
            table.insert(new, v)
        end
    end
    return new
end

local function equal(id, first, num)
    if box[id] == nil then
        box[id] = default
    end
    local new = {}
    for _,v in pairs(box[id]) do
        if first and math.floor(v / 10) == num or not first and (v % 10) == num then
            table.insert(new, v)
        end
    end
    return new
end

-- display helper function
local function display(id, chances)
    if #box[id] == 90 then
        AshitaCore:GetChatManager():AddChatMessage(207, 'possible combinations: 10~99')
    else
        AshitaCore:GetChatManager():AddChatMessage(207, 'possible combinations: ' .. table.concat(box[id], ' '))
    end
    local remaining = math.floor(#box[id] / math.pow(2, (chances - 1)))
    if remaining == 0 then
        remaining = 1
    end
    AshitaCore:GetChatManager():AddChatMessage(207, string.format('best guess: %d (%d%%)', box[id][math.ceil(#box[id] / 2)], 1 / remaining * 100))
end

-- ID obtaining helper function
local function get_id(zone_id,str)
    return messages[zone_id] + offsets[str]
end

-- Register packet handler
ashita.events.register('packet_in', 'packet_in_cb', function(e)
    local entityMgr = AshitaCore:GetMemoryManager():GetEntity()
    if not entityMgr then return false end

    -- Get current zone from the first entity (player)
    local zone_id = entityMgr:GetZone(0)
    if messages[zone_id] then
        if e.id == 0x0B then
            box = {}
        elseif e.id == 0x2A then
            local box_id = struct.unpack('H', e.data_modified, 25)
            local param0 = struct.unpack('I', e.data_modified, 9)
            local param1 = struct.unpack('I', e.data_modified, 13)
            local param2 = struct.unpack('I', e.data_modified, 17)
            local message_id = struct.unpack('H', e.data_modified, 27) % 0x8000

            if get_id(zone_id,'greater_less') == message_id then
                box[box_id] = greater_less(box_id, param1 == 0, param0)
            elseif get_id(zone_id,'second_even_odd') == message_id then
                box[box_id] = even_odd(box_id, 1, param0)
            elseif get_id(zone_id,'first_even_odd') == message_id then
                box[box_id] = even_odd(box_id, 10, param0)
            elseif get_id(zone_id,'range') == message_id then
                box[box_id] = greater_less(box_id, true, param0)
                box[box_id] = greater_less(box_id, false, param1)
            elseif get_id(zone_id,'less') == message_id then
                box[box_id] = greater_less(box_id, false, param0)
            elseif get_id(zone_id,'greater') == message_id then
                box[box_id] = greater_less(box_id, true, param0)
            elseif get_id(zone_id,'equal') == message_id then
                local new = equal(box_id, true, param0)
                local duplicate = param0 * 10 + param0
                for k,v in pairs(new) do
                    if v == duplicate then
                        table.remove(new, k)
                    end
                end
                for _,v in pairs(equal(box_id, false, param0)) do table.insert(new, v) end
                table.sort(new)
                box[box_id] = new
            elseif get_id(zone_id,'second_multiple') == message_id then
                local new = equal(box_id, false, param0)
                for _,v in pairs(equal(box_id, false, param1)) do table.insert(new, v) end
                for _,v in pairs(equal(box_id, false, param2)) do table.insert(new, v) end
                table.sort(new)
                box[box_id] = new
            elseif get_id(zone_id,'first_multiple') == message_id then
                local new = equal(box_id, true, param0)
                for _,v in pairs(equal(box_id, true, param1)) do table.insert(new, v) end
                for _,v in pairs(equal(box_id, true, param2)) do table.insert(new, v) end
                table.sort(new)
                box[box_id] = new
            elseif get_id(zone_id,'success') == message_id or get_id(zone_id,'failure') == message_id then
                box[box_id] = nil
            end
        elseif e.id == 0x34 then
            local box_id = struct.unpack('H', e.data_modified, 41)
            -- Get the entity map size
            local entityCount = entityMgr:GetEntityMapSize()
            
            -- Search through all entities to find the treasure casket
            for i = 0, entityCount - 1 do
                local entName = entityMgr:GetName(i)
                if entName == 'Treasure Casket' and i == box_id then
                    local chances = e.data_modified:byte(9)
                    if box[box_id] == nil then
                        box[box_id] = default
                    end
                    if chances > 0 and chances < 7 then
                        display(box_id, chances)
                    end
                    break
                end
            end
        elseif e.id == 0x5B then
            box[struct.unpack('I', e.data_modified, 17)] = nil
        end
    end
    return false
end)

-- Register load event
ashita.events.register('load', 'load_cb', function()
    print(chat.header(addon.name):append(chat.message('Loaded successfully.')))
end)

-- Register unload event
ashita.events.register('unload', 'unload_cb', function()
    print(chat.header(addon.name):append(chat.message('Unloaded successfully.')))
end)