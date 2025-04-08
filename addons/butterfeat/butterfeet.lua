--[[
    MIT LICENSE

    Copyright (c) 2021 banggugyangu

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


Original idea and memory locations/patches are credited to zechs6437 [github.com/zechs6437]

Original License as follows:

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
]]

addon.author    = 'banggugyangu modifed by christitustech';
addon.name      = 'butterfeet';
addon.version   = '2.0.0';

require 'common';
require 'ffi';


--Definitions
local JADELAY = { };
local ENDELAY = { };
local ANIMATION = { };
JADELAY.pointer = ashita.memory.find('FFXIMain.dll', 0, '8B81FC00000040', 0x00, 0x00);
ENDELAY.pointer = ashita.memory.find('FFXiMain.dll', 0, '66FF81????????66C781????????0807C3', 0x00, 0x00);
ANIMATION.pointer = ashita.memory.find('FFXiMain.dll', 0, '89??????????8B??????????8B????89', 0x00, 0x00);

jadjustment = { 0x8B, 0x81, 0xFC, 0x00, 0x00, 0x00, 0x90 };
eadjustment = { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 };
animationadjustment = { 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 };

--OnLoad
ashita.events.register('load', 'load_cb', function ()

    if (JADELAY.pointer == nil) then;
        print('ButterFeet cannot find the correct memory address for JA lock');
        print(JADELAY);
        return;
    end
    if (ENDELAY.pointer == nil) then;
        print('ButterFeet cannot find the correct memory address for Engagement Lock');
        return;
    end
    if (ANIMATION.pointer == nil) then;
        print('ButterFeet cannot find the correct memory address for Animation Lock');
        return;
    end

    --Backup of original values
    JADELAY.backup = ashita.memory.read_array(JADELAY.pointer, 7);
    ENDELAY.backup = ashita.memory.read_array(ENDELAY.pointer, 7);
    ANIMATION.backup = ashita.memory.read_array(ANIMATION.pointer, 7);
    --Writing of new values
    ashita.memory.write_array(JADELAY.pointer, jadjustment);
    ashita.memory.write_array(ENDELAY.pointer, eadjustment);
    ashita.memory.write_array(ANIMATION.pointer, animationadjustment);
    print('Your feet are thoroughly buttered.')
end);

--OnUnload
ashita.events.register('unload', 'unload_cb', function()

    if (JADELAY.backup ~= nil) then
        ashita.memory.write_array(JADELAY.pointer, JADELAY.backup);
    end
    if (ENDELAY.backup ~= nil) then
        ashita.memory.write_array(ENDELAY.pointer, ENDELAY.backup);
    end
    if (ANIMATION.backup ~= nil) then
        ashita.memory.write_array(ANIMATION.pointer, ANIMATION.backup);
    end
end);