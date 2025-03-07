local chat = require('chat');
local imgui = require('imgui');
local ItemList = {};

function ItemList:New(windowContainer, settingClass, settingName, displayName)
    for _,v in pairs(windowContainer) do
        if (v.SettingClass == settingClass) and (v.SettingName == settingName) then
            return;
        end
    end

    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.IsOpen = { true };
    o.ActiveItems = T{};
    o.DisplayName = displayName;
    o.SearchBuffer = {};
    o.SearchItems = T{ };
    o.SettingClass = settingClass;
    o.ListSelected = { -1 };
    o.SearchBuffer = { '' };
    o.SearchSelected = { -1 };
    o.Theme = settingClass.GUI.Theme;
    o.SettingName = settingName;
    local settingTable = settingClass[settingName];
    if (type(settingTable) == 'table') then
        for _,v in pairs(settingTable) do        
            if (type(v) == 'number') then
                local resource = AshitaCore:GetResourceManager():GetItemById(v);
                if (resource ~= nil and resource.Name[1] ~= nil and resource.Name[1]:len() > 1) then
                    o.ActiveItems:append({ string.format('[%u] %s', v, resource.Name[1]), v });
                end
            end
        end
    end
    windowContainer:append(o);
end

function ItemList:Render()
    imgui.SetNextWindowSize({ 465, 420, });
    imgui.SetNextWindowSizeConstraints({ 465, 420, }, { FLT_MAX, FLT_MAX, });
    if (imgui.Begin(self.DisplayName .. '##' .. addon.name .. '_ItemList_' .. self.SettingName, self.IsOpen, ImGuiWindowFlags_NoResize)) then
        imgui.BeginGroup();
        imgui.TextColored(self.Theme.Header, 'Current Items');
        imgui.BeginChild('leftpane', { 220, 340 }, true);
        local items = self.ActiveItems;
        local deleteIndex = 0;
        for i = 0, #items - 1 do
            if (i < #items) then
                if  (imgui.Selectable(items[i + 1][1], self.ListSelected[1] == i)) then
                    self.ListSelected[1]  = i;
                end
            end

            if (imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0)) then
                deleteIndex = self.ListSelected[1] + 1;
            end
        end
        if (deleteIndex > 0) then
            for j = deleteIndex, #items - 1 do
                items[j] = items[j + 1];
            end
            items[#items] = nil;
            self.ListSelected[1] = -1;
        end
        imgui.EndChild();

        if (imgui.Button('Remove One', { 106 })) then
            local deleteIndex = self.ListSelected[1];
            if (deleteIndex >= 0) then
                for j = deleteIndex, #items - 1 do
                    items[j] = items[j + 1];
                end
                items[#items] = nil;
            end            
        end
        imgui.SameLine();
        if (imgui.Button('Remove All', { 106 })) then
            self.ListSelected = { -1 };
            self.ActiveItems = T{};
            items = self.ActiveItems;
        end
        imgui.EndGroup();
        imgui.SameLine();

        
        imgui.SetCursorPosY(imgui.GetCursorPosY() - imgui.GetStyle().FramePadding.y);
        imgui.BeginGroup();
        imgui.TextColored(self.Theme.Header, 'Item Lookup Tool');
        imgui.BeginChild('rightpane', { 220, 340 }, true);
        imgui.PushItemWidth(-1);
        if (imgui.InputText('##Item Name', self.SearchBuffer, 256, ImGuiInputTextFlags_EnterReturnsTrue)) then
            self:Search();
        end
        imgui.PopItemWidth();
        if (imgui.Button('Search', { -1, 0 })) then
            self:Search();
        end
        imgui.BeginChild('rightpane_items');
        
        local items = self.SearchItems;
        for i = 0, #items - 1 do
            if (i < #items) then
                if (imgui.Selectable(items[i + 1][1], self.SearchSelected[1] == i)) then
                    self.SearchSelected[1] = i;
                end
            end

            if (imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0)) then
                local addItem = self.SearchItems[self.SearchSelected[1] + 1];
                if addItem then
                    self.ActiveItems:append(T{ addItem[1], addItem[2] });
                end
                self.SearchSelected[1] = -1;
            end
        end
        imgui.EndChild();
        imgui.EndChild();
        if (imgui.Button('Cancel', { 106 })) then
            self.IsOpen[1] = false;
        end
        imgui.SameLine();
        if (imgui.Button('Save', { 106 })) then
            self.IsOpen[1] = false;
            local returnTable = T{};
            for _,v in pairs(self.ActiveItems) do
                returnTable:append(v[2]);
            end
            self.SettingClass[self.SettingName] = returnTable;
            self.SettingClass:Save();
        end
        imgui.EndGroup();
        imgui.End();
    end
end

function ItemList:Search()
    local start = os.clock();
    self.SearchItems = T{};
    local term = self.SearchBuffer[1]:lower();
    local resultCount = 0;
    for x = 0, 65535 do
        local item = AshitaCore:GetResourceManager():GetItemById(x);
        if (item ~= nil and item.Name[1] ~= nil and item.Name[1]:len() > 1) then
            if (item.Name[1]:lower():contains(term)) then
                local found = false;
                for i = 1,#self.SearchItems do
                    if (self.SearchItems[i][3] == item.Name[1]) then
                        self.SearchItems[i][1] = string.format('[%u] %s', self.SearchItems[i][2], item.Name[1]);
                        found = true;
                    end
                end

                if found then                    
                    self.SearchItems:append({ string.format('[%u] %s', x, item.Name[1]), x, item.Name[1] });
                else
                    self.SearchItems:append({ item.Name[1], x, item.Name[1] });
                end

                resultCount = resultCount + 1;
                if (resultCount > 100) then
                    print(chat.header('ItemList') .. chat.error('Found more than 100 matching items.  Displaying first 100 results.'));
                    break;
                end
            end
        end
    end
    table.sort(self.SearchItems, function(a,b)
        if (a[3] == b[3]) then
            return a[2] < b[2];
        else
            return a[3] < b[3];
        end
    end);
end

return ItemList;