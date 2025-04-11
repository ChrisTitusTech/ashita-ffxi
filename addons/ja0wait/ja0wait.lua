--[[
* MIT License
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

addon.author   = 'christitustech';
addon.name     = 'ja0wait';
addon.version  = '1.0.0';
addon.desc      = 'Removes JA0WAIT and ENGAGE0WAIT from the game.';
addon.link      = 'https://ashitaxi.com/';

require 'common'

---------------------------------------------------------------------------------------------------
-- ja0wait Table
---------------------------------------------------------------------------------------------------
local JA0WAIT = { };
local ENGAGE0WAIT = { };

-- Patches to apply
local JA0PATCH = { 0x8B, 0x81, 0xFC, 0x00, 0x00, 0x00, 0x90 };
local ENGAGEPATCH = { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 };

----------------------------------------------------------------------------------------------------
-- func: load
-- desc: Event called when the addon is being loaded.
----------------------------------------------------------------------------------------------------
ashita.events.register('load', 'load_cb', function()
    -- Find the memory patterns
    JA0WAIT.pointer = ashita.memory.find('FFXiMain.dll', 0, '8B81FC00000040', 0x00, 0x00);
    ENGAGE0WAIT.pointer = ashita.memory.find('FFXiMain.dll', 0, '66FF81????????66C781????????0807C3', 0x00, 0x00);

    -- Validate the pointers
    if (JA0WAIT.pointer == 0) then
        print('\31\200[\31\05' .. 'ja0wait'.. '\31\200]\30\01 ' .. '\30\68Failed to find ja0wait signature.\30\01');
        return;
    end
    if (ENGAGE0WAIT.pointer == 0) then
        print('\31\200[\31\05' .. 'ja0wait'.. '\31\200]\30\01 ' .. '\30\68Failed to find engage0wait signature.\30\01');
        return;
    end

    -- Backup original bytes
    JA0WAIT.backup = ashita.memory.read_array(JA0WAIT.pointer, 7);
    ENGAGE0WAIT.backup = ashita.memory.read_array(ENGAGE0WAIT.pointer, 7);

    -- Write patches
    ashita.memory.write_array(JA0WAIT.pointer, JA0PATCH);
    ashita.memory.write_array(ENGAGE0WAIT.pointer, ENGAGEPATCH);

    print(string.format('\31\200[\31\05' .. 'ja0wait'.. '\31\200] \31\130Functions patched; slip and slide around all you want.'));
end);

----------------------------------------------------------------------------------------------------
-- func: unload
-- desc: Event called when the addon is being unloaded.
----------------------------------------------------------------------------------------------------
ashita.events.register('unload', 'unload_cb', function()
    -- Restore original bytes if we have backups
    if (JA0WAIT.backup ~= nil) then
        ashita.memory.write_array(JA0WAIT.pointer, JA0WAIT.backup);
    end

    if (ENGAGE0WAIT.backup ~= nil) then
        ashita.memory.write_array(ENGAGE0WAIT.pointer, ENGAGE0WAIT.backup);
    end
end);