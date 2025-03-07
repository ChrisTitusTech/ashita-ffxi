local pWardrobe = ashita.memory.find('FFXiMain.dll', 0, 'A1????????8B88B4000000C1E907F6C101E9', 1, 0);
local pZoneFlags = ashita.memory.find('FFXiMain.dll', 0, '8B8C24040100008B90????????0BD18990????????8B15????????8B82', 0, 0);
local pZoneOffset;
if (pWardrobe == 0) then
    print(chat.header('Porter') .. chat.error('Wardrobe access signature scan failed.'));
end
if (pZoneFlags == 0) then
    print(chat.header('Porter') .. chat.error('Zone flag signature scan failed.'));
else
    pZoneOffset = ashita.memory.read_uint32(pZoneFlags + 0x09);
    if (pZoneOffset == 0) then
        pZoneFlags = 0;
        print(chat.header('Porter') .. chat.error('Zone flag offset not found.'));
    else
        pZoneFlags = ashita.memory.read_uint32(pZoneFlags + 0x17);
        if (pZoneFlags == 0) then
            print(chat.header('Porter') .. chat.error('Zone flag sub pointer not found.'));
        end
    end
end
local slipData = require('slips');
local slipTable = slipData.SlipItems;
local slipIDs = slipData.SlipIDs;

local data = {};

local relicSlips = T{ 29324, 29328, 29329, 29337, 29338 };

function data:CheckAugment(slipNumber, extdata)
    local augType = struct.unpack('B', extdata, 1);
    local augFlag = struct.unpack('B', extdata, 2);
    local itemTable = extdata:totable();
    local maxAugments = 5;
    
    --Magian style augment
    if (bit.band(augFlag, 0x40) ~= 0) then
        maxAugments = 4;
        --An item with an incomplete trial can never be stored.
        if (ashita.bits.unpack_be(itemTable, 80, 15) ~= 0) and (ashita.bits.unpack_be(itemTable, 95, 1) == 0) then
            return false;
        end
    end
    
    if slipNumber == 29313 then
        --No augmented items in sky/abj slip..        
        if (augType == 2) or (augType == 3) then
            return false;
        end
    elseif relicSlips:contains(slipNumber) then
        --Relic must be augmented to store it.
        if (augType == 2) or (augType == 3) then
            local itemTable = extdata:totable();
            local hasAugment = false;
            for i = 1,maxAugments do
                local augmentId = ashita.bits.unpack_be(itemTable, (16 * i), 11);
                if (augmentId > 0) then
                    hasAugment = true;
                end
            end
            return hasAugment;
        end
        return false;
    end
    
    return true;
end


function data:CheckInMogHouse()
    --Default to false if pointer scan failed
    if (pZoneFlags == 0) then
        return false;
    end

    local zonePointer = ashita.memory.read_uint32(pZoneFlags + 0);
    if (zonePointer ~= 0) then
        local zoneFlags = ashita.memory.read_uint32(zonePointer + pZoneOffset);
        if (bit.band(zoneFlags, 0x100) == 0x100) then
            return true;
        end
    end

    return false;
end

function data:CheckForNomad()
    local entity = AshitaCore:GetMemoryManager():GetEntity();
    for i = 0,1023,1 do
        if (entity:GetRawEntity(i) ~= nil) then
            local renderFlags = entity:GetRenderFlags0(i);
            if (bit.band(renderFlags, 0x200) == 0x200) and (entity:GetDistance(i) < 36) then
                local entityName = entity:GetName(i);
                if (entityName == 'Nomad Moogle') or (entityName == 'Pilgrim Moogle') then
                    return true;
                end
            end
        end
    end                
end

function data:GetAccountFlags()
    local subPointer = ashita.memory.read_uint32(pWardrobe);
	subPointer = ashita.memory.read_uint32(subPointer);
    return ashita.memory.read_uint8(subPointer + 0xB4);
end

function data:GetContainerAvailable(container)
    if gSettings.ForceEnableContainers:contains(container) then
        return true;
    end
    if gSettings.ForceDisableContainers:contains(container) then
        return false;
    end
 
    --Satchel, Wardrobe3+ checks work on retail, but as of 9/4/2021 they do not work on topaz because flags are passed in POL(?) 
    if ((container == 0) or (container == 8) or (container == 10)) then --Inventory, Wardrobe, Wardrobe2
        return true;
    elseif (container > 10) then --Wardrobe3+
        local flag = 2 ^ (container - 9);
        return (bit.band(self:GetAccountFlags(), flag) ~= 0);
    elseif ((container == 1) or (container == 4) or (container == 9)) then --Safe, Locker, Safe2
        return ((self:CheckInMogHouse() == true) or (self:CheckForNomad() == true));
    elseif (container == 2) then --Storage
        return ((self:CheckInMogHouse() == true) or ((self:CheckForNomad() == true) and (gSettings.EnableNomadStorage == true)));
    elseif (container == 3) then --Temporary
        return false;
    elseif (container == 5) then --Satchel
        return (bit.band(self:GetAccountFlags(), 0x01) == 0x01);
    else --Sack, Case
        return true;
    end
end

--Returns a table of the player's current slip items.
function data:GetPlayerSlips()
    local slips = self:GetSlipTable();
    local playerSlips = {};
    for container = 0,16 do
        if self:GetContainerAvailable(container) then
            local inventory = AshitaCore:GetMemoryManager():GetInventory();
            for index = 1,81 do
                local item = inventory:GetContainerItem(container, index);
                if item and (item.Id > 0) and (item.Count > 0) then
                    local slip = slips[item.Id];
                    if slip then
                        playerSlips[item.Id] = { Container = container, Index = index, Item = item };
                    end
                end
            end
        end
    end
    return playerSlips;
end

function data:GetSlipItems(slip)
    local slips = self:GetSlipTable();
    local items = T{};
    local slipData = slips[slip.Item.Id];
    if slipData then
        for key,value in ipairs(slipData) do
            if (self:CheckSlipItem(slip, key)) then
                items:append(value);
            end        
        end
    end
    return items;
end

function data:CheckSlipItem(slip, storageIndex)
    local index = storageIndex - 1;
    local extData = slip.Item.Extra;
    local byte = struct.unpack('B', extData, math.floor(index / 8) + 1);
    local dbit = bit.rshift(byte, math.fmod(index, 8));
    return (bit.band(dbit, 1) == 1);
end

--Returns the slip index and the storage index of a slip where the item can be stored, or nil if it cannot.
function data:GetSlip(itemId)
    local resource = AshitaCore:GetResourceManager():GetItemById(itemId);
    if (not resource) or (resource.StackSize ~= 1) then
        return nil;
    end

    local slips = self:GetSlipTable();
    for slipId,slipItems in pairs(slips) do
        for storageIndex,item in ipairs(slipItems) do
            if item == itemId then
                return slipId, storageIndex;
            end
        end
    end

    return nil;
end

function data:GetSlipIDs()
    return slipIDs;
end

function data:GetSlipTable()
    return slipTable;
end

function data:GetFreeSpace(container)
    local inventory = AshitaCore:GetMemoryManager():GetInventory();
    local inventoryMax = inventory:GetContainerCountMax(container);
    local freeSpace = inventoryMax;
    for i = 1,inventoryMax do
        local item = inventory:GetContainerItem(container, i);
        if item and (item.Id > 0) and (item.Count > 0) then
            freeSpace = freeSpace - 1;
        end
    end
    return freeSpace;
end

function data:GetPorterIndex()
    local entMgr = AshitaCore:GetMemoryManager():GetEntity();
    for i = 1,0x400 do
        if entMgr:GetRawEntity(i) then
            if (entMgr:GetName(i) == 'Porter Moogle') and (entMgr:GetDistance(i) < 35) then
                return i;
            end
        end
    end

    return 0;
end

function data:SendTradePacket(entityIndex, items)
    local entityId = AshitaCore:GetMemoryManager():GetEntity():GetServerId(entityIndex);
    local itemCount = #items;
    if (itemCount < 9) then
        for i = itemCount + 1,9 do
            items[i] = { Count = 0, Index = 0 };
        end
    end
    for i = 1,9 do
        if (items[i].Count > 0) then
            local id = AshitaCore:GetMemoryManager():GetInventory():GetContainerItem(0, items[i].Index).Id;
        end
    end
    local packet = struct.pack('LLLLLLLLLLLLBBBBBBBBBBHL',
        0, entityId, items[1].Count, items[2].Count, items[3].Count, items[4].Count, items[5].Count, items[6].Count, items[7].Count, items[8].Count, items[9].Count, 0,
        items[1].Index, items[2].Index, items[3].Index, items[4].Index, items[5].Index, items[6].Index, items[7].Index, items[8].Index, items[9].Index, 0,
        entityIndex, itemCount);
    AshitaCore:GetPacketManager():AddOutgoingPacket(0x36, packet:totable());
end

return data;