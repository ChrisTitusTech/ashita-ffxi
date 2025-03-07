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

addon.name      = 'cbind';
addon.author    = 'Thorny';
addon.version   = '1.01';
addon.desc      = 'Allows you to bind controller buttons to commands.';
addon.link      = 'https://ashitaxi.com/';

require('common');
require('commands');
require('helpers');
gDebug = false;
gui = require('gui');
settings = require('settings');
local defaultSettings = T{
    Controller_Layout = 'xinput',
    Bindings = T{},
};
cbind = {
    Controller = nil,
    Settings = settings.load(defaultSettings),
};
gui:Update();

settings.register('settings', 'settings_update', function(newSettings)
    cbind.Settings = newSettings;
    gui:Update();
end);

ashita.events.register('dinput_button', 'dinput_button_cb', function(e)
    if type(cbind.Controller) == 'table' and type(cbind.Controller.HandleDirectInput) == 'function' then
        cbind.Controller:HandleDirectInput(e);
    end
end);

ashita.events.register('xinput_button', 'xinput_button_cb', function(e)
    if type(cbind.Controller) == 'table' and type(cbind.Controller.HandleXInput) == 'function' then
        cbind.Controller:HandleXInput(e);
    end
end);

local pendingCommands = T{};
ashita.events.register('d3d_present', 'd3d_present_cb', function ()
    gui:Render();

    local now = os.clock();
    local remainingCommands = T{};
    for _,command in ipairs(pendingCommands) do
        if now > command.Execution then
            AshitaCore:GetChatManager():QueueCommand(-1, command.Command);
        else
            remainingCommands:append(command);
        end
    end
    pendingCommands = remainingCommands;
end);

--[[
    This splits multi-line bindings by semicolon and applies any /wait or <wait #> tags to later commands.
]]--
local function ExecuteBinding(binding)
    local commands = T{};
    for command in string.gmatch(binding, "[^;]+") do
        commands:append(command);
    end
    local delay = 0;
    for _,command in ipairs(commands) do
        if (string.sub(command, 1, 6) == '/wait ') then
            local waitTime = tonumber(string.sub(command, 7));
            if type(waitTime) == 'number' then
                delay = delay + waitTime;
            end
        else
            local waitTime;
            local waitStart, waitEnd = string.find(command, ' <wait %d*%.?%d+>');
            if (waitStart ~= nil) and (waitEnd == string.len(command)) then
                waitTime = tonumber(string.match(command, ' <wait (%d*%.?%d+)>'));
                command = string.sub(command, 1, waitStart - 1);
            end

            if string.len(command) > 0 then
                pendingCommands:append({Execution=os.clock()+delay,Command=command});
            end
            if (type(waitTime) == 'number') then
                delay = delay + waitTime;
            end
        end
    end
end
HandleBinding = function(buttonName, newState)
    if gDebug then
        Message(string.format('Input detected: $H%s%s$R', buttonName, newState and "(\x81\xAB)" or "(\x81\xAA)"));
    end

    local bindings = cbind.Settings.Bindings[cbind.Settings.Controller_Layout];
    for _,binding in ipairs(bindings) do
        if (binding.Button == buttonName) and (binding.Down == newState) then
            ExecuteBinding(binding.Command);
            return true;
        end
    end
end