local prep = {};

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

local function hasItem(id)
    local inventory = AshitaCore:GetMemoryManager():GetInventory();
    for container = 0,16 do
        for index = 1,81 do
            local item = inventory:GetContainerItem(container, index);
            if (item.Id == id) and (item.Count > 0) then
                return true;
            end
        end
    end
    return false;
end

function prep:PreparePack(includeList)
    local shouldContain = (gSettings.ReversePack == true);
    local exclude = gSettings.ExcludePack;
    local prepItems = T{};
    local playerSlips = gData:GetPlayerSlips();
    for container = 0,16 do
        if gData:GetContainerAvailable(container) then
            local inventory = AshitaCore:GetMemoryManager():GetInventory();
            for index = 1,81 do
                local item = inventory:GetContainerItem(container, index);
                if item and (item.Id > 0) and (item.Count > 0) and (item.Flags ~= 5) and (item.Flags ~= 19) and (item.Flags ~= 25) then
                    local slipId, storageIndex = gData:GetSlip(item.Id);
                    if slipId and storageIndex and gData:CheckAugment(slipId, item.Extra) then
                        local slip = playerSlips[slipId];
                        if slip then
                            if (not gData:CheckSlipItem(slip, storageIndex)) and (not exclude:contains(item.Id)) and (includeList:contains(item.Id) == shouldContain) then
                                if (type(prepItems[slipId]) ~= 'table') then
                                    prepItems[slipId] = T{{ ItemId = slip.Item.Id, Container = slip.Container, Index = slip.Index }};
                                end
                                prepItems[slipId]:append({ ItemId = item.Id, Container = container, Index = index });
                            end
                        end
                    end
                end
            end
        end
    end

    local freeSpace = gData:GetFreeSpace(0);
    local itemsRemaining = 0;
    local itemsRetrieved = 0;
    
    for _,slipItems in pairs(prepItems) do
        for _,item in ipairs(slipItems) do
            if (item.Container ~= 0) then
                if freeSpace > 0 then
                    self:RetrieveItem(item.Container, item.Index, item.ItemId);
                    freeSpace  = freeSpace - 1;
                    itemsRetrieved = itemsRetrieved + 1;
                else
                    itemsRemaining = itemsRemaining + 1;
                end
            end
        end
    end
    
    print(chat.header('Porter') .. chat.color1(2, itemsRetrieved) .. chat.message(' items were retrieved.  ') .. chat.color1(2, itemsRemaining) .. chat.message(' items remain.'));
    if gData:GetContainerAvailable(1) == false then
        print(chat.header('Porter') .. chat.error('Note that you are not currently in range of a nomad moogle or in the mog house.'))
    end
end

function prep:PrepareUnpack(includeList)
    local exclude = gSettings.ExcludeUnpack;
    local retrieveSlips = T{};
    local playerSlips = gData:GetPlayerSlips();
    for id,slip in pairs(playerSlips) do
        local slipItems = gData:GetSlipItems(slip);
        for _,item in pairs(slipItems) do
            if (includeList:contains(item)) and (not hasItem(item)) then
                retrieveSlips:append(slip);
                break;
            end
        end
    end

    local freeSpace = gData:GetFreeSpace(0);
    local itemsRemaining = 0;
    local itemsRetrieved = 0;
    
    for _,slip in ipairs(retrieveSlips) do
        if (slip.Container ~= 0) then
            if freeSpace > 0 then
                self:RetrieveItem(slip.Container, slip.Index, slip.Item.Id);
                freeSpace  = freeSpace - 1;
                itemsRetrieved = itemsRetrieved + 1;
            else
                itemsRemaining = itemsRemaining + 1;
            end
        end
    end
    
    print(chat.header('Porter') .. chat.color1(2, itemsRetrieved) .. chat.message(' items were retrieved.  ') .. chat.color1(2, itemsRemaining) .. chat.message(' items remain.'));
    if gData:GetContainerAvailable(1) == false then
        print(chat.header('Porter') .. chat.error('Note that you are not currently in range of a nomad moogle or in the mog house.'))
    end
end

function prep:RetrieveItem(container, index, id)
    local packet = struct.pack('LLBBBB', 0, 1, container, 0, index, 0x52);
    AshitaCore:GetPacketManager():AddOutgoingPacket(0x29, packet:totable());
    print(chat.header('Porter') .. chat.message('Retrieving a ') .. chat.color1(2, AshitaCore:GetResourceManager():GetItemById(id).Name[1]) .. chat.message(' from ') .. chat.color1(2, containerNames[container + 1]) .. chat.message('.'));
end

return prep;