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

local function CheckButton(matchButton)
    if cbind.Controller == nil then
        return;
    end
    for _,button in ipairs(cbind.Controller.Buttons) do
        if string.lower(button) == string.lower(matchButton) then
            return button;
        end
    end
end

ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if #args > 0 and string.lower(args[1]) == '/cbind' then
        e.blocked = true;
        if #args == 1 then
            gui:Open();
            return;
        end

        if #args > 1 and (string.lower(args[2]) == 'debug') then
            gDebug = not gDebug;
            Message(string.format("Debug Mode: $H%s$R", gDebug and "Enabled" or "Disabled"));
            return;
        end

        if #args >= 3 then
            local button = CheckButton(args[2]);
            if button ~= nil then
                local binding = { Button=button, Down=true };
                local spaceSkip = 2;
                if string.lower(args[3]) == 'up' then
                    spaceSkip = 3;
                    binding.Down = false;
                elseif string.lower(args[3]) == 'down' then
                    spaceSkip = 3;
                end

                local command = e.command;
                for i = 1,spaceSkip do
                    local space = string.find(command, ' ');
                    command = string.sub(command, space + 1);
                end
                binding.Command = command;

                local key = (binding.Down and "(\x81\xAB)" or "(\x81\xAA)") .. binding.Button;
                Message(string.format('Bound $H%s$R to: %s', key, command));
                CreateBinding(binding);
            end
        end
    end
    
    if #args > 0 and string.lower(args[1]) == '/cunbind' then
        e.blocked = true;
        if #args >= 2 then
            local button = CheckButton(args[2]);
            if button ~= nil then
                local down = true;
                if #args >= 3 and string.lower(args[3]) == 'up' then
                    down = false;
                end
                local bindings = T{};
                local unbound = false;
                for _,entry in ipairs(cbind.Settings.Bindings[cbind.Settings.Controller_Layout]) do
                    if (entry.Button == button) and (entry.Down == down) then
                        unbound = true;
                    else
                        bindings:append(entry);
                    end
                end

                if unbound then
                    cbind.Settings.Bindings[cbind.Settings.Controller_Layout] = bindings;
                    settings.save();
                    local key = (down and "(\x81\xAB)" or "(\x81\xAA)") .. button;
                    Message(string.format('Unbound: $H%s$R', key));
                end
            end
        end
    end
end);