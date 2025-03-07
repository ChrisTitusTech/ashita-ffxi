local chat = require('chat');
local imgui = require('imgui');
local ContainerList = {};

local containerNames = {
    'Inventory',
    'Safe',
    'Storage',
    'Temporary',
    'Locker',
    'Satchel',
    'Sack',
    'Case',
    'Wardrobe',
    'Safe2',
    'Wardrobe2',
    'Wardrobe3',
    'Wardrobe4',
    'Wardrobe5',
    'Wardrobe6',
    'Wardrobe7',
    'Wardrobe8',
    'Recycle'
};

function ContainerList:New(windowContainer, settingClass, settingName, displayName)
    for _,v in pairs(windowContainer) do
        if (v.SettingClass == settingClass) and (v.SettingName == settingName) then
            return;
        end
    end

    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.IsOpen = { true };
    o.ActiveContainers = {};
    for i = 1,18 do
        o.ActiveContainers[i] = false;
    end
    o.DisplayName = displayName;
    o.SettingClass = settingClass;
    o.Theme = settingClass.GUI.Theme;
    o.SettingName = settingName;
    local settingTable = settingClass[settingName];
    if (type(settingTable) == 'table') then
        for _,v in pairs(settingTable) do
            if (type(v) == 'number') then
                o.ActiveContainers[math.floor(v) + 1] = true;
            end
        end
    end
    windowContainer:append(o);
end

function ContainerList:Render()
    imgui.SetNextWindowSize({ 335, 220, });
    imgui.SetNextWindowSizeConstraints({ 335, 220, }, { FLT_MAX, FLT_MAX, });
    if (imgui.Begin(self.DisplayName .. '##' .. addon.name .. '_ContainerList_' .. self.SettingName, self.IsOpen, ImGuiWindowFlags_NoResize)) then
        imgui.BeginGroup();
        imgui.BeginChild('leftpane', { 100, 157 }, false, 128);
        for i = 1,6 do
            if imgui.Checkbox(containerNames[i], { self.ActiveContainers[i] }) then
                self.ActiveContainers[i] = not self.ActiveContainers[i];
            end
        end
        imgui.EndChild();
        imgui.EndGroup();
        imgui.SameLine();
        imgui.BeginGroup();
        imgui.BeginChild('middlepane', { 100, 157 }, false, 128);
        for i = 7,12 do
            if imgui.Checkbox(containerNames[i], { self.ActiveContainers[i] }) then
                self.ActiveContainers[i] = not self.ActiveContainers[i];
            end
        end
        imgui.EndChild();
        imgui.EndGroup();
        imgui.SameLine();
        imgui.BeginGroup();
        imgui.BeginChild('rightpane', { 100, 157 }, false, 128);
        for i = 13,18 do
            if imgui.Checkbox(containerNames[i], { self.ActiveContainers[i] }) then
                self.ActiveContainers[i] = not self.ActiveContainers[i];
            end
        end
        imgui.EndChild();
        imgui.EndGroup();
        if (imgui.Button('Cancel', { 106 })) then
            self.IsOpen[1] = false;
        end
        imgui.SameLine(imgui.GetWindowWidth() - 111);
        if (imgui.Button('Save', { 106 })) then
            self.IsOpen[1] = false;
            local returnTable = T{};
            for i,v in pairs(self.ActiveContainers) do
                if v then
                    returnTable:append(i - 1);
                end
            end
            self.SettingClass[self.SettingName] = returnTable;
            self.SettingClass:Save();
        end
        imgui.End();
    end
end

return ContainerList;