require('common');

local imgui = require('imgui');
local itemList = require('itemlist');
local containerList = require('containerlist');
local ui = T{
    IsOpen = T{ false },
}

local SettingsGui = {
    IsOpen = { false },
    SubWindows = {};
    Theme = {
        Header = { 1.0, 0.75, 0.55, 1.0 },
        Command = { 0.0, 1.0, 0.2, 1.0 }
    }
};

function SettingsGui:Initialize(parent)
    self.DisplayHelp = { false };
    self.Parent = parent;
    self.MaxPackets = T{ parent.MaxPackets };
    self.RetryDelay = T{ parent.RetryDelay };
end

function SettingsGui:Render()
    if (self.IsOpen[1]) then
        if (imgui.Begin(string.format('%s v%s', addon.name, addon.version), self.IsOpen, ImGuiWindowFlags_AlwaysAutoResize)) then
            imgui.TextColored(self.Theme.Header, 'Save Mode');
            if imgui.Checkbox('Character-Specific', { self.Parent.CharacterSpecific }) then
                self.Parent:ToggleCharacterSpecific();
                self.SubWindows = T{};
            end
            imgui.ShowHelp('Uses settings specific to this character, rather than defaults.', true);
            imgui.TextColored(self.Theme.Header, 'Settings');
            if (imgui.Button('Pack Exclusions')) then
                itemList:New(self.SubWindows, self.Parent, 'ExcludePack', 'Porter: Pack Exclusions');
            end
            imgui.ShowHelp('Any items selected in this submenu will not be stored on porter moogle regardless of list in use.', true);
            if (imgui.Button('Unpack Exclusions')) then
                itemList:New(self.SubWindows, self.Parent, 'ExcludeUnpack', 'Porter: Unpack Exclusions');
            end
            imgui.ShowHelp('Any items selected in this submenu will not be retrieved from porter moogle regardless of list in use.', true);
            if (imgui.Button('Force Disable Containers')) then
                containerList:New(self.SubWindows, self.Parent, 'ForceDisableContainers', 'Porter: Disabled Containers');
            end
            imgui.ShowHelp('Any containers disabled in this submenu will be treated as if you do not have access to them, even if memory checks imply you do.', true);
            if (imgui.Button('Force Enable Containers')) then
                containerList:New(self.SubWindows, self.Parent, 'ForceEnableContainers', 'Porter: Enabled Containers');
            end
            imgui.ShowHelp('Any containers enabled in this submenu will be treated as if you do have access to them, even if memory checks imply you do not.', true);
            if imgui.Checkbox('Block Input', { self.Parent.BlockInput }) then
                self.Parent.BlockInput = not self.Parent.BlockInput;
                self.Parent:Save(self.Parent.CharacterSpecific);
            end
            imgui.ShowHelp('When checked, Porter will block input while dealing with porter moogle to prevent accidentally talking to NPCs and locking client.', true);
            if imgui.Checkbox('Reverse Pack', { self.Parent.ReversePack }) then
                self.Parent.ReversePack = not self.Parent.ReversePack;
                self.Parent:Save(self.Parent.CharacterSpecific);
            end
            imgui.ShowHelp('When checked, pack and preppack commands will use the items your current xml/lua needs instead of the items it doesn\'t.', true);
            imgui.TextColored(self.Theme.Header, 'Retry Delay');
            imgui.ShowHelp('Delay, in seconds, before Porter will resend a packet that the server has not responded to.', true);
            local retryDelay = { self.Parent.RetryDelay; }
            if (imgui.SliderFloat('##Retry Delay', retryDelay, 1, 10, '%.1f', ImGuiSliderFlags_AlwaysClamp)) then
                if (retryDelay[1] ~= self.Parent.RetryDelay) then
                    self.Parent.RetryDelay = retryDelay[1];
                    self.Parent:Save(self.Parent.CharacterSpecific);
                end
            end
            imgui.TextColored(self.Theme.Header, 'Max Packets');
            imgui.ShowHelp('The max amount of item retrieve packets that will be sent at one time.  Legitimate client can only send 1, there is some risk associated with increasing this value.', true);
            local maxPackets = { self.Parent.MaxPackets };
            if (imgui.SliderInt('##Max Packets',  maxPackets, 1, 8, '%d', ImGuiSliderFlags_AlwaysClamp)) then
                if (maxPackets[1] ~= self.Parent.MaxPackets) then
                    self.Parent.MaxPackets = maxPackets[1];
                    self.Parent:Save(self.Parent.CharacterSpecific);
                end
            end
            if (imgui.Button('Defaults')) then
                local path = self.Parent.Path;
                local charSpecific = self.Parent.CharacterSpecific;
                self.Parent:Reset();
                self.Parent.CharacterSpecific = charSpecific;
                self.Parent.Path = path;
                self.Parent:Save();
            end
            imgui.SameLine();
            if (imgui.Button('Help')) then
                self.DisplayHelp = { true };
            end
            imgui.End();
        end

        local swapWindows = T{};
        for _,v in pairs(self.SubWindows) do
            if v.IsOpen[1] then
                v:Render();
                swapWindows:append(v);
            end
        end
        self.SubWindows = swapWindows;
    else
        self.SubWindows = T{};
    end

    if (self.DisplayHelp[1]) then
        imgui.SetNextWindowContentSize({ 600, 260 });
        if (imgui.Begin(string.format('%s Help##HELP_%sv%s', addon.name, addon.name, addon.version), self.DisplayHelp, ImGuiWindowFlags_AlwaysAutoResize)) then
            imgui.BeginGroup();
            imgui.TextColored(self.Theme.Command, '/po pack [optional: file name]');
            imgui.TextWrapped('Stores items in your inventory on porter moogle using slips in your inventory.  If a file is specified, no items listed in that file will be stored.');
            imgui.TextColored(self.Theme.Command, '/po unpack [required: file name]');
            imgui.TextWrapped('Retrieves items listed in the specified file from porter moogle, using slips in your inventory.');
            imgui.TextColored(self.Theme.Command, '/po preppack [optional: file name]');
            imgui.TextWrapped('Retrieves items and slips that can be stored from accessible containers.  If a file is specified, no items listed in that file will be retrieved.');
            imgui.TextColored(self.Theme.Command, '/po prepunpack [required: file name]');
            imgui.TextWrapped('Retrieves slips containing any items listed in the specified file from accessible containers.');
            imgui.TextColored(self.Theme.Command, 'Ashitacast, LegacyAC, and LuAshitacast Integration');
            imgui.TextWrapped('Prefixing any of the above commands with /ac(Ashitacast or LegacyAC) or /lac(LuAshitacast) instead of /po will trigger the command using your currently loaded XML or Lua profile as an item list.');
            imgui.EndGroup();
            imgui.End();
        end
    end
end

return SettingsGui;