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

local imgui = require('imgui');
local state = {
    IsOpen = { false },
    Controllers = {},
    SelectedController = 1,
    SelectedButton = 1,
    Release = { false },
    BindCommand = { '' },
};
local tableFlags = bit.bor(ImGuiTableFlags_RowBg, ImGuiTableFlags_BordersH, ImGuiTableFlags_BordersV, ImGuiTableFlags_ScrollX, ImGuiTableFlags_ScrollY, ImGuiTableFlags_SizingFixedFit);

local function GetControllers()
    local path = string.format('%s/addons/%s/controllers/', AshitaCore:GetInstallPath(), addon.name);
    local controllers = T{};
    if not (ashita.fs.exists(path)) then
        ashita.fs.create_directory(path);
    end
    local contents = ashita.fs.get_directory(path, '.*\\.lua');
    for _,file in pairs(contents) do
        file = string.sub(file, 1, -5);
        if not controllers:contains(file) then
            controllers:append(file);
        end
    end

    state.Controllers = controllers;
    state.SelectedController = 1;
    for index,controller in ipairs(state.Controllers) do
        if (cbind.Settings.Controller_Layout == controller) then
            state.SelectedController = index;
        end
    end
end

local function UpdateController(force)
    local newController = state.Controllers[state.SelectedController];
    if newController ~= cbind.Settings.Controller_Layout or force then
        local flush = false;
        cbind.Controller = LoadFile_s(string.format('%s/addons/%s/controllers/%s.lua', AshitaCore:GetInstallPath(), addon.name, newController));
        if newController ~= cbind.Settings.Controller_Layout then
            cbind.Settings.Controller_Layout = newController;
            flush = true;
        end
        if (cbind.Settings.Bindings[newController] == nil) then
            cbind.Settings.Bindings[newController] = T{};
            flush = true;
        end
        if flush then
            settings.save();
        end
        state.SelectedButton = 1;
    end
end

local function UpdateBindings(changedBinding)
    local bindings = cbind.Settings.Bindings[cbind.Settings.Controller_Layout];

    if changedBinding.Delete then
        cbind.Settings.Bindings[cbind.Settings.Controller_Layout] = bindings:filteri(function(a) return a ~= changedBinding end);
    else
        cbind.Settings.Bindings[cbind.Settings.Controller_Layout] = bindings:filteri(function(a)
            if a == changedBinding then
                return true;
            end

            return (a.Button ~= changedBinding.Button) or (a.Down ~= changedBinding.Down);
        end);
    end
end

local function open(self)
    state.IsOpen[1] = true;
end


local function render(self)
    if state.IsOpen[1] then
        if imgui.Begin(string.format('%s v%.2f Configuration', addon.name, addon.version), state.IsOpen) then
            imgui.TextColored({1.0, 0.65, 0.26, 1.0}, 'Select Controller Type');
            if (imgui.BeginCombo('##SelectControllerType', state.Controllers[state.SelectedController], ImGuiComboFlags_None)) then
                for index,controller in ipairs(state.Controllers) do
                    if (imgui.Selectable(controller, index == state.SelectedController)) then
                        state.SelectedController = index;
                        UpdateController(false);
                    end
                end
                imgui.EndCombo();
            end
            imgui.TextColored({1.0, 0.65, 0.26, 1.0}, 'Create New Controller Bind');
            imgui.Separator();
            if imgui.BeginCombo('##SelectControllerButton', cbind.Controller.Buttons[state.SelectedButton], ImGuiComboFlags_None) then
                for index,button in ipairs(cbind.Controller.Buttons) do
                    if (imgui.Selectable(button, index == state.SelectedButton)) then
                        state.SelectedButton = index;
                    end
                end
                imgui.EndCombo();
            end
            imgui.Checkbox("Release##cbind_release", state.Release);
            imgui.ShowHelp("If checked, the binding will trigger when the button is released.  If not checked, the binding will trigger when the button is pressed.");
            imgui.SetNextItemWidth(-1);
            imgui.InputText("##cbind_cmd", state.BindCommand, 1024);
            if imgui.Button("Create Bind##cbind_createbind") then
                CreateBinding({
                    Button = cbind.Controller.Buttons[state.SelectedButton],
                    Down = state.Release[1] == false,
                    Command = state.BindCommand[1],
                });
                state.BindCommand[1] = '';
            end
            imgui.NewLine();
            imgui.TextColored({1.0, 0.65, 0.26, 1.0}, 'Current Controller Binds');
            imgui.Separator();
            if imgui.BeginTable('##bind_display_table', 2, tableFlags) then
                imgui.TableSetupColumn("Bind", ImGuiTableColumnFlags_WidthFixed, 120, 0);
                imgui.TableSetupColumn("Command", ImGuiTableColumnFlags_WidthStretch, 0, 1);
                imgui.TableSetupScrollFreeze(0, 1);
                imgui.TableHeadersRow();

                local id = 0;
                local updatedBinding;
                for _,binding in pairs(cbind.Settings.Bindings[cbind.Settings.Controller_Layout]) do
                    imgui.PushID(id);
                    imgui.TableNextRow();
                    imgui.TableNextColumn();
                    local text = (binding.Down and "\xEF\x81\xA3" or "\xEF\x81\xA2") .. binding.Button;
                    local macro = binding.Command;
                    imgui.Selectable(text, false, bit.bor(ImGuiSelectableFlags_SpanAllColumns, ImGuiSelectableFlags_AllowItemOverlap));
                    if imgui.IsItemHovered() then
                        imgui.SetTooltip(string.format('Button: %s\r\n\r\n%s', text, macro));
                    end
                    if imgui.BeginPopupContextItem("cbind_bind_editor_popup") then
                        if imgui.BeginCombo('##SelectButtonSubMenu', binding.Button, ImGuiComboFlags_None) then
                            for index,button in ipairs(cbind.Controller.Buttons) do
                                if (imgui.Selectable(button, button == binding.Button)) then
                                    if binding.Button ~= button then
                                        binding.Button = button;
                                        updatedBinding = binding;
                                    end
                                end
                            end
                            imgui.EndCombo();
                        end

                        local buff = { not binding.Down };
                        if imgui.Checkbox("Release##ContextMenuRelease", buff) then
                            if binding.Down == buff[1] then
                                binding.Down = not buff[1];
                                updatedBinding = binding;
                            end
                        end
                        imgui.ShowHelp("If checked, the binding will trigger when the button is released.  If not checked, the binding will trigger when the button is pressed.");

                        buff = { binding.Command };
                        imgui.SetNextItemWidth(-1);
                        if imgui.InputText("##ContextMenu_cbind_cmd", buff, 1024) then
                            if buff[1] ~= binding.Command then
                                binding.Command = buff[1];
                                updatedBinding = binding;
                            end
                        end

                        if imgui.Button("Close") then
                            imgui.CloseCurrentPopup();
                        end
                        imgui.SameLine();

                        if imgui.Button("Unbind") then
                            binding.Delete = true;
                            updatedBinding = binding;
                            imgui.CloseCurrentPopup();
                        end

                        imgui.EndPopup();
                    end
                    
                    imgui.TableNextColumn();
                    imgui.Text(macro);
                    imgui.PopID();
                    id = id + 1;
                end
                imgui.EndTable();

                if updatedBinding then
                    UpdateBindings(updatedBinding);
                end
            end

            imgui.End();
        end
    end
end

local function update()
    GetControllers();
    UpdateController(true);
end

local exposed = {
    Open = open,
    Render = render,
    Update = update,
};

return exposed;