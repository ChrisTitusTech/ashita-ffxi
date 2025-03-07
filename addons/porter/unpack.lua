
local ffi = require("ffi");
ffi.cdef[[
    int32_t memcmp(const void* buff1, const void* buff2, size_t count);
]];

local unpack = {};

local UnpackState = {
    COMPLETE = 0,
    READY_TO_TRADE = 1,
    AWAITING_TRADE_RESPONSE = 2,
    AWAITING_MENU_STATUS = 3,
    SENDING_ITEM_REQUEST = 4,
    AWAITING_ITEM_RECEIPT = 5,
    AWAITING_MENU_EXIT = 6
};

local MenuIdByZone = {
    [26]  = 621,    --Tavnazian Safehold
    [50]  = 959,    --Aht Urhgan Whitegate
    [53]  = 330,    --Nashmau
    [80]  = 661,    --Southern San d'Oria [S]
    [87]  = 603,    --Bastok Markets [S]
    [94]  = 525,    --Windurst Waters [S]
    [231] = 874,    --Northern San d'Oria
    [235] = 547,    --Bastok Markets
    [240] = 870,    --Port Windurst
    [245] = 10106,  --Lower Jeuno
    [247] = 138,    --Rabao
    [248] = 1139,   --Selbina
    [249] = 338,    --Mhaura
    [250] = 309,    --Kazham
    [252] = 246,    --Norg
    [256] = 43,     --Western Adoulin
    [279] = 13,     --Walk of Echoes [P2]
    [280] = 802,    --Mog Garden
    [298] = 13      --Walk of Echoes [P1]
}

local StorageSlipIds = gData:GetSlipIDs();

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

function unpack:Initialize(includeList)
    self.Delay = os.clock();
    self.State = UnpackState.READY_TO_TRADE;
    self.Include = T{};

    for _,v in pairs(includeList) do
        if not gSettings.ExcludeUnpack:contains(v) and not hasItem(v) then
            self.Include:append(v);
        end
    end

    if (gSettings.BlockInput) then
        AshitaCore:GetInputManager():GetKeyboard():SetBlockInput(true);
        AshitaCore:GetInputManager():GetMouse():SetBlockInput(true);
    end

    return self;
end

function unpack:HandleIncomingPacket(e)
    if (self.State == UnpackState.COMPLETE) then
        return;
    end

    if (e.id == 0x34) then
        local entityIndex = struct.unpack('H', e.data, 0x28 + 1);
        if (AshitaCore:GetMemoryManager():GetEntity():GetName(entityIndex) == 'Porter Moogle') then
            local expectedId = MenuIdByZone[AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0)];
            local menuId = struct.unpack('H', e.data, 0x2C + 1);
            if (menuId ~= expectedId) then
                print(chat.header(addon.name) .. chat.error(string.format('Menu ID does not match table.  Expected %u, got %u.', expectedId, menuId)));
                self.State = UnpackState.COMPLETE;
                return;
            end
            e.blocked = true;
            if (self.State == UnpackState.AWAITING_TRADE_RESPONSE) then
                self.MenuId = menuId;
                self.MenuEntityIndex = entityIndex;
                self.MenuEntityId = struct.unpack('L', e.data, 0x04 + 1);                
                self.State = UnpackState.AWAITING_MENU_STATUS;
                self.MenuItems = T{};
                local slipId = StorageSlipIds[struct.unpack('B', e.data, 0x24 + 1) + 1];
                local slipItems = gData:GetSlipTable()[slipId];
                if slipItems then
                    for index,itemId in ipairs(slipItems) do
                        local byteOffset = 8 + math.floor((index - 1) / 8);
                        local byte = struct.unpack('B', e.data, byteOffset + 1);
                        local dbit = bit.rshift(byte, math.fmod(index - 1, 8));
                        if (bit.band(dbit, 1) == 1) then
                            self.MenuItems:append(itemId);
                        end
                    end
                end
            end
        end
    elseif (e.id == 0x5C) then
        if (self.State == UnpackState.SENDING_ITEM_REQUEST) or (self.State == UnpackState.AWAITING_ITEM_RECEIPT) then
            self.MenuItems = T{};
            local slipId = struct.unpack('H', e.data, 0x1C + 1);
            local slipItems = gData:GetSlipTable()[slipId];
            if slipItems then
                for index,itemId in ipairs(slipItems) do
                    local byteOffset = 4 + math.floor((index - 1) / 8);
                    local byte = struct.unpack('B', e.data, byteOffset + 1);
                    local dbit = bit.rshift(byte, math.fmod(index - 1, 8));
                    if (bit.band(dbit, 1) == 1) then
                        self.MenuItems:append(itemId);
                    end
                end
            end
        end
    end
end

function unpack:HandleOutgoingPacket(e)
    --Only trigger once per new chunk.
    if (ffi.C.memcmp(e.data_raw, e.chunk_data_raw, e.size) ~= 0) or (self.State == UnpackState.COMPLETE) then
        return;
    end

    self:HandleOutgoingLogic();
end

function unpack:HandleOutgoingLogic()
    local myIndex = AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0);
    local myStatus = AshitaCore:GetMemoryManager():GetEntity():GetStatus(myIndex);

    if (self.State == UnpackState.READY_TO_TRADE) then
        if (os.clock() > self.Delay) then
            if self:SendTrade() then
                self.State = UnpackState.AWAITING_TRADE_RESPONSE;
            else
                self.State = UnpackState.COMPLETE;
            end
        end
    elseif (self.State == UnpackState.AWAITING_TRADE_RESPONSE) then
        if (os.clock() > self.Delay) then
            self.State = UnpackState.READY_TO_TRADE;
            self.Delay = os.clock() - 1;
            self:HandleOutgoingLogic();
        end
    elseif (self.State == UnpackState.AWAITING_MENU_STATUS) then
        if (myStatus == 4) then
            self.State = UnpackState.SENDING_ITEM_REQUEST;
            self.Delay = os.clock() - 1;
            self:HandleOutgoingLogic();
        end
    elseif (self.State == UnpackState.SENDING_ITEM_REQUEST) then
        if (os.clock() > self.Delay) then
            if self:SendItemRequest() then
                self.State = UnpackState.AWAITING_ITEM_RECEIPT;
            else
                self.State = UnpackState.AWAITING_MENU_EXIT;
            end
        end
    elseif (self.State == UnpackState.AWAITING_ITEM_RECEIPT) then
        if (self:CheckItemRequestCompleted()) then
            self.State = UnpackState.SENDING_ITEM_REQUEST;
            self.Delay = os.clock() - 1;
            self:HandleOutgoingLogic();
        elseif (os.clock() > self.Delay) then
            self.State = UnpackState.AWAITING_MENU_EXIT;
            self.Delay = os.clock() - 1;
            self:HandleOutgoingLogic();
        end
    elseif (self.State == UnpackState.AWAITING_MENU_EXIT) then
        if (myStatus ~= 4) then
            self.State = UnpackState.READY_TO_TRADE;
            self.Delay = os.clock() - 1;
            self:HandleOutgoingLogic();
        elseif (os.clock() > self.Delay) then
            self:SendMenuCompletion();
            self.Delay = os.clock() + gSettings.RetryDelay;
        end
    end
end

function unpack:SendTrade()    
    local playerSlips = gData:GetPlayerSlips();
    for _,itemId in ipairs(self.Include) do
        if not hasItem(itemId) then
            local slipId, storageIndex = gData:GetSlip(itemId);
            if slipId then
                local slip = playerSlips[slipId];
                if slip and (slip.Container == 0) and gData:CheckSlipItem(slip, storageIndex) then
                    if (slip.Count) then
                        slip.Count = slip.Count + 1;
                    else
                        slip.Count = 1;
                    end
                end
            end
        end
    end
    
    local bestSlip;
    for _,slip in pairs(playerSlips) do
        if (slip.Count) then
            if (bestSlip == nil) or (slip.Count > bestSlip.Count) then
                bestSlip = slip;
            end
        end
    end

    if not bestSlip then
        print(chat.header(addon.name) .. chat.message('Unpacking complete.'));
        return false;
    end

    local porter = gData:GetPorterIndex();
    if porter == 0 then
        print(chat.header(addon.name) .. chat.error('Unpacking failed.  Could not locate porter moogle.'));
        return false;
    end

    if (gData:GetFreeSpace(0) == 0) then
        print(chat.header(addon.name) .. chat.error('Unpacking failed.  Ran out of inventory space.'));
        return false;
    end

    local tradeItems = { { Count = 1, Index = bestSlip.Index } };
    print(chat.header('Porter') .. chat.message('Trading ') .. chat.color1(2, AshitaCore:GetResourceManager():GetItemById(bestSlip.Item.Id).Name[1]) .. chat.message(' to the porter moogle.'));
    gData:SendTradePacket(porter, tradeItems);
    self.Delay = os.clock() + gSettings.RetryDelay;
    return true;
end

function unpack:SendItemRequest()
    --Request items up to limit defined in settings.  Return true if any items requested, false if not.
    local maxItems = gData:GetFreeSpace(0);
    if (maxItems == 0) then
        print(chat.header(addon.name) .. chat.error('Unpacking failed.  Ran out of inventory space.'));
        return false;
    end
    if (maxItems > gSettings.MaxPackets) then
        maxItems = gSettings.MaxPackets;
    end

    self.PendingItems = T{};
    --Reverse iterate to remove items so indexes don't shift.
    for i = #self.MenuItems,1,-1 do
        local item = self.MenuItems[i];
        if (self.Include:contains(item)) and (not hasItem(item)) then
            local packet = struct.pack('LLHHHBBHH', 0, self.MenuEntityId, i - 1, 0, self.MenuEntityIndex, 1, 0,
            AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0), self.MenuId);
            AshitaCore:GetPacketManager():AddOutgoingPacket(0x5B, packet:totable());
            self.Delay = os.clock() + gSettings.RetryDelay;
            self.PendingItems:append(item);
            if (#self.PendingItems == maxItems) then
                break;
            end
        end
    end

    local count = #self.PendingItems;
    if (count == 1) then
        print(chat.header('Porter') .. chat.message('Requesting ') .. chat.color1(2, AshitaCore:GetResourceManager():GetItemById(self.PendingItems[1]).Name[1]) .. chat.message(' from the porter moogle.'));
        return true;
    elseif (count > 1) then
        print(chat.header('Porter') .. chat.message('Requesting ') .. chat.color1(2, count .. ' items') .. chat.message(' from the porter moogle.'));        
        return true;
    else
        return false;
    end
end

function unpack:CheckItemRequestCompleted()
    --Check if all items stored in SendItemRequest are in inventory.  If so, return true.
    local swap = T{};
    for _,itemId in ipairs(self.PendingItems) do
        if not hasItem(itemId) then
            swap:append(itemId);
        else
            self.MenuItems:delete(itemId);
        end
    end
    self.PendingItems = swap;
    return (#swap == 0);
end

function unpack:SendMenuCompletion()
    local packet = struct.pack('LLHHHBBHH', 0, self.MenuEntityId, 0, 0x4000, self.MenuEntityIndex, 0, 0,
    AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0), self.MenuId);
    AshitaCore:GetPacketManager():AddOutgoingPacket(0x5B, packet:totable());
    print(chat.header('Porter') .. chat.message('Sending menu exit packet.'));
end

return unpack;