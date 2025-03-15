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
