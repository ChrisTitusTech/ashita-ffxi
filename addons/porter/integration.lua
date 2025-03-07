local ffi = require('ffi');
ffi.cdef[[
    typedef struct GearListEntry_t {
        char Name[32];
        int32_t Quantity;
        int32_t AugPath;
        int32_t AugRank;
        int32_t AugTrial;
        int32_t AugCount;
        uint8_t AugString[10][100];
    } GearListEntry_t;
]];
ffi.cdef[[
    typedef struct GearListEvent_t {
        uint8_t ReturnEventPrefix[256];
        int32_t EntryCount;
        GearListEntry_t Entries[1000];
    } GearListEvent_t;
]]


local function CreateItemList(eventPtr)
    local eventStructure = ffi.cast('GearListEvent_t*', eventPtr)    
    local itemNames = T{};
    for i = 1,eventStructure.EntryCount do
        local item = eventStructure.Entries[i - 1];
        local name = string.lower(ffi.string(item.Name));
        if not itemNames:contains(name) then
            itemNames:append(name);
        end
    end

    local itemList = T{};
    local slips = gData:GetSlipTable();
    for slipId, slipItems in pairs(slips) do
        for _,itemId in pairs(slipItems) do
            local resource = AshitaCore:GetResourceManager():GetItemById(itemId);
            if resource and (itemNames:contains(string.lower(resource.Name[1]))) then
                itemList:append(itemId);
            end
        end
    end

    return itemList;
end

ashita.events.register('plugin_event', 'plugin_event_cb', function (e)
    if (e.name == 'porter_pack') then
        local itemList = CreateItemList(e.data_raw);
        if gEvent then
            print(chat.header(addon.name) .. chat.error('An event is already running.'));
            return;
        end
        gEvent = gPack:Initialize(itemList);
    elseif (e.name == 'porter_unpack') then
        local itemList = CreateItemList(e.data_raw);
        if gEvent then
            print(chat.header(addon.name) .. chat.error('An event is already running.'));
            return;
        end
        gEvent = gUnpack:Initialize(itemList);
    elseif (e.name == 'porter_preppack') then
        local itemList = CreateItemList(e.data_raw);
        if gEvent then
            print(chat.header(addon.name) .. chat.error('An event is already running.'));
            return;
        end
        gPrep:PreparePack(itemList);
    elseif (e.name == 'porter_prepunpack') then
        local itemList = CreateItemList(e.data_raw);
        if gEvent then
            print(chat.header(addon.name) .. chat.error('An event is already running.'));
            return;
        end
        gPrep:PrepareUnpack(itemList);
    end
end);