--[[

MIT License

Copyright (c) 2024 ThornyFFXI

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]--

local chat = require('chat')

function Error(text)
    local color = ('\30%c'):format(68);
    local highlighted = color .. string.gsub(text, '$H', '\30\01\30\02');
    highlighted = string.gsub(highlighted, '$R', '\30\01' .. color);
    print(chat.header(addon.name) .. highlighted .. '\30\01');
end


function Message(text)
    local color = ('\30%c'):format(106);
    local highlighted = color .. string.gsub(text, '$H', '\30\01\30\02');
    highlighted = string.gsub(highlighted, '$R', '\30\01' .. color);
    print(chat.header(addon.name) .. highlighted .. '\30\01');
end

function LoadFile_s(filePath)
    if (filePath == nil) then
        return nil;
    end
    
    if not ashita.fs.exists(filePath) then
        return nil;
    end

    local success, loadError = loadfile(filePath);
    if not success then
        Error(string.format('Failed to load resource file: $H%s', filePath));
        Error(loadError);
        return nil;
    end

    local result, output = pcall(success);
    if not result then
        Error(string.format('Failed to execute resource file: $H%s', filePath));
        Error(loadError);
        return nil;
    end

    return output;
end

function CreateBinding(binding)
    local bindings = cbind.Settings.Bindings[cbind.Settings.Controller_Layout];

    local found = false;
    for key,entry in ipairs(bindings) do
        if entry.Button == binding.Button and entry.Down == binding.Down then
            entry.Command = binding.Command;
            found = true;
            break;
        end
    end

    if not found then
        bindings:append(binding);
        table.sort(bindings, function(a,b)
            if (a.Button ~= b.Button) then
                return a.Button < b.Button;
            else
                return (a.Down and 0 or 1) < (b.Down and 0 or 1);
            end
        end);
    end
    
    settings.save();
end