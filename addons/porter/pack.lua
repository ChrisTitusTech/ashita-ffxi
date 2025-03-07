
local ffi = require("ffi");
ffi.cdef[[
    int32_t memcmp(const void* buff1, const void* buff2, size_t count);
]];

local pack = {};

local PackState = {
    COMPLETE = 0,
    READY_TO_TRADE = 1,
    AWAITING_TRADE_RESPONSE = 2,
    AWAITING_MENU_STATUS = 3,
    AWAITING_MENU_COMPLETION = 4
};

local MenuIdByZone = {
    [26]  = 620,    --Tavnazian Safehold
    [50]  = 958,    --Aht Urhgan Whitegate
    [53]  = 329,    --Nashmau
    [80]  = 660,    --Southern San d'Oria [S]
    [87]  = 602,    --Bastok Markets [S]
    [94]  = 524,    --Windurst Waters [S]
    [231] = 873,    --Northern San d'Oria
    [235] = 546,    --Bastok Markets
    [240] = 869,    --Port Windurst
    [245] = 10105,  --Lower Jeuno
    [247] = 137,    --Rabao
    [248] = 1138,   --Selbina
    [249] = 337,    --Mhaura
    [250] = 308,    --Kazham
    [252] = 245,    --Norg
    [256] = 42,     --Western Adoulin
    [279] = 12,     --Walk of Echoes [P2]
    [280] = 801,    --Mog Garden
    [298] = 12      --Walk of Echoes [P1]
}

function pack:HandleIncomingPacket(e)
    if (self.State == PackState.COMPLETE) then
        return;
    end

    if (e.id == 0x34) then
        local entityIndex = struct.unpack('H', e.data, 0x28 + 1);
        if (AshitaCore:GetMemoryManager():GetEntity():GetName(entityIndex) == 'Porter Moogle') then
            local expectedId = MenuIdByZone[AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0)];
            local menuId = struct.unpack('H', e.data, 0x2C + 1);
            if (menuId ~= expectedId) then
                print(chat.header(addon.name) .. chat.error(string.format('Menu ID does not match table.  Expected %u, got %u.', expectedId, menuId)));
                self.State = PackState.COMPLETE;
                return;
            end
            e.blocked = true;
            if (self.State == PackState.AWAITING_TRADE_RESPONSE) then
                self.MenuId = menuId;
                self.MenuEntityIndex = entityIndex;
                self.MenuEntityId = struct.unpack('L', e.data, 0x04 + 1);
                self.State = PackState.AWAITING_MENU_STATUS;
            end
        end
    end
end

function pack:HandleOutgoingPacket(e)
    --Only trigger once per new chunk.
    if (ffi.C.memcmp(e.data_raw, e.chunk_data_raw, e.size) ~= 0) or (self.State == PackState.COMPLETE) then
        return;
    end


    local myIndex = AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0);
    local myStatus = AshitaCore:GetMemoryManager():GetEntity():GetStatus(myIndex);
    if (self.State == PackState.READY_TO_TRADE) then
        if (os.clock() > self.Delay) then
            self:SendTrade();
        end
    end
    if (self.State == PackState.AWAITING_TRADE_RESPONSE) then
        if (os.clock() > self.Delay) then
            self.State = PackState.READY_TO_TRADE;
        end
    end
    if (self.State == PackState.AWAITING_MENU_STATUS) then
        if (myStatus == 4) then
            self.State = PackState.AWAITING_MENU_COMPLETION;
            self.Delay = os.clock() - 1;
        end
    end
    if (self.State == PackState.AWAITING_MENU_COMPLETION) then
        if (myStatus ~= 4) then
            self.State = PackState.READY_TO_TRADE;
            self.Delay = os.clock() - 1;
        elseif (os.clock() > self.Delay) then
            self:SendMenuCompletion();
            self.Delay = os.clock() + gSettings.RetryDelay;
        end
    end
end

function pack:Initialize(includeList)
    self.Delay = os.clock();
    self.State = PackState.READY_TO_TRADE;
    self.Include = includeList;
    if (gSettings.BlockInput) then
        AshitaCore:GetInputManager():GetKeyboard():SetBlockInput(true);
        AshitaCore:GetInputManager():GetMouse():SetBlockInput(true);
    end
    return self;
end

function pack:SendMenuCompletion()
    local packet = struct.pack('LLHHHBBHH', 0, self.MenuEntityId, 0, 0, self.MenuEntityIndex, 0, 0,
    AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0), self.MenuId);
    AshitaCore:GetPacketManager():AddOutgoingPacket(0x5B, packet:totable());
    print(chat.header('Porter') .. chat.message('Sending menu completion packet.'));
end

function pack:ItemNameByIndex(index)
    local itemId = AshitaCore:GetMemoryManager():GetInventory():GetContainerItem(0, index).Id;
    local resource = AshitaCore:GetResourceManager():GetItemById(itemId);
    return resource.Name[1];
end

function pack:SendTrade()
    local shouldContain = (gSettings.ReversePack == true);
    local playerSlips = gData:GetPlayerSlips();
    local slippableItems = {};
    local inventory = AshitaCore:GetMemoryManager():GetInventory();
    for index = 1,81 do
        local item = inventory:GetContainerItem(0, index);
        if (item.Id > 0) and (item.Count > 0) then
            local slipNumber, storageIndex = gData:GetSlip(item.Id);
            if slipNumber then
                if (self.Include:contains(item.Id) == shouldContain) and (not gSettings.ExcludePack:contains(item.Id)) then
                    local slip = playerSlips[slipNumber];
                    if slip and slip.Container == 0 and not gData:CheckSlipItem(slip, storageIndex) and gData:CheckAugment(slipNumber, item.Extra) then
                        local slipId = slip.Item.Id;
                        if not slippableItems[slipId] then
                            slippableItems[slipId] = T{ slip.Item.Index, index };
                        else
                            local alreadyExists = false;
                            for _,index in pairs(slippableItems[slipId]) do
                                if (inventory:GetContainerItem(0, index).Id == item.Id) then
                                    alreadyExists = true;
                                    break;
                                end
                            end
                            if not alreadyExists then
                                slippableItems[slipId]:append(index);
                            end
                        end 
                    end
                end
            end
        end
    end

    local slipId = 0;
    for id,slip in pairs(slippableItems) do
        if (slipId == 0) or (#slip > #slippableItems[slipId]) then
            slipId = id;
        end
    end

    if slipId == 0 then
        self.State = PackState.COMPLETE;
        print(chat.header(addon.name) .. chat.message('Packing complete.'));
        return;
    end

    local porter = gData:GetPorterIndex();
    if porter == 0 then
        self.State = PackState.COMPLETE;
        print(chat.header(addon.name) .. chat.error('Packing failed.  Could not locate porter moogle.'));
        return;
    end

    local index = 1;
    local tradeItems = {};
    for _,itemIndex in pairs(slippableItems[slipId]) do
        tradeItems[index] = { Count = 1, Index = itemIndex };
        index = index + 1;
        if (index > 8) then
            break;
        end
    end

    local count = #tradeItems;
    if count == 2 then
        print(chat.header('Porter') .. chat.message('Trading ') .. chat.color1(2, self:ItemNameByIndex(tradeItems[1].Index)) .. chat.message(' and ') .. chat.color1(2, self:ItemNameByIndex(tradeItems[2].Index)) .. chat.message(' to the porter moogle.'));
    else
        print(chat.header('Porter') .. chat.message('Trading ') .. chat.color1(2, self:ItemNameByIndex(tradeItems[1].Index)) .. chat.message(' and ') .. chat.color1(2, (count - 1) .. ' items') .. chat.message(' to the porter moogle.'));
    end
    gData:SendTradePacket(porter, tradeItems);
    self.Delay = os.clock() + gSettings.RetryDelay;
    self.State = PackState.AWAITING_TRADE_RESPONSE;
end


return pack;