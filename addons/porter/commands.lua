local function LoadList(listName)
    local path = ('%sconfig\\addons\\%s\\lists\\%s.lua'):fmt(AshitaCore:GetInstallPath(), addon.name, listName);
    if not ashita.fs.exists(path) then
        path = ('%sconfig\\addons\\%s\\lists\\%s'):fmt(AshitaCore:GetInstallPath(), addon.name, listName);
    end

    if not ashita.fs.exists(path) then
        print(chat.header(addon.name) .. chat.error('List does not exist: ') .. chat.color1(2, path));
        return nil;
    end
    
    local loadedFile, errorText = loadfile(path);
    if not loadedFile then
        print(chat.header(addon.name) .. chat.error('Failed to load list: ') .. chat.color1(2, path));
        print(chat.header(addon.name) .. chat.error(errorText));
        return nil;
	end

    local settings = loadedFile();
    if type(settings) ~= 'table' then        
        print(chat.header(addon.name) .. chat.error('File did not return a table: ') .. chat.color1(2, path));
        print(chat.header(addon.name) .. chat.error(errorText));
        return nil;
    end

    local itemList = T{};
    for _,v in pairs(settings) do
        if (type(v) == 'number') then
            local resource = AshitaCore:GetResourceManager():GetItemById(v);
            if resource then
                itemList:append(resource.Id);
            else
                print(chat.header(addon.name) .. chat.error('Failed to locate item resource for item ID: ') .. chat.color1(2, v));
            end
        elseif (type(v) == 'string') then
            local resource = AshitaCore:GetResourceManager():GetItemByName(v, 0);
            if resource then
                itemList:append(resource.Id);
            else
                print(chat.header(addon.name) .. chat.error('Failed to locate item resource for item name: ') .. chat.color1(2, v));
            end
        else
            print(chat.header(addon.name) .. chat.error('Items must be listed as string(name) or number(item id).  A table entry was of type: ') .. chat.color1(2, type(v)));
        end
    end
    
    return itemList;
end

ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0) then
        return;
    end
    args[1] = string.lower(args[1]);
    if (args[1] ~= '/porter') and (args[1] ~= '/po') then
        return;
    end
    e.blocked = true;
    if (#args < 2) then
        gSettings.GUI.IsOpen[1] = not gSettings.GUI.IsOpen[1];
        return;
    end

    args[2] = string.lower(args[2]);
    if (args[2] == 'preppack') then
        local itemList = T{};
        if (#args > 2) then
            itemList = LoadList(args[3]);
            if not itemList then
                return;
            end
        end
        if gEvent then
            print(chat.header(addon.name) .. chat.error('An event is already running.'));
            return;
        end
        gPrep:PreparePack(itemList);
        return;
    elseif (args[2] == 'pack') then
        local itemList = T{};
        if (#args > 2) then
            itemList = LoadList(args[3]);
            if not itemList then
                return;
            end
        end
        if gEvent then
            print(chat.header(addon.name) .. chat.error('An event is already running.'));
            return;
        end
        gEvent = gPack:Initialize(itemList);
        return;
    elseif (args[2] == 'prepunpack') then
        if (#args < 3) then            
            print(chat.header(addon.name) .. chat.error('You must specify a list for prepunpack.'));
            return;
        end
        local itemList = LoadList(args[3]);
        if not itemList then
            return;
        end
        if gEvent then
            print(chat.header(addon.name) .. chat.error('An event is already running.'));
            return;
        end
        gPrep:PrepareUnpack(itemList);
        return;
    elseif (args[2] == 'unpack') then
        if (#args < 3) then            
            print(chat.header(addon.name) .. chat.error('You must specify a list for unpack.'));
            return;
        end
        local itemList = LoadList(args[3]);
        if not itemList then
            return;
        end
        if gEvent then
            print(chat.header(addon.name) .. chat.error('An event is already running.'));
            return;
        end
        gEvent = gUnpack:Initialize(itemList);
        return;
    elseif (args[2] == 'help') then
        gSettings.GUI.DisplayHelp[1] = true;
    end
end);