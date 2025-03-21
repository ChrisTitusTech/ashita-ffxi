addon.name      = 'SellIt';
addon.author    = 'christitustech';
addon.version   = '2.1';
addon.desc      = 'Originally made by Thorny, but I added a profile system to it.';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
-- We'll load profiles on demand instead of at startup
local profiles;

--Reduce the minimum delay between item sales
local baseDelay = 0.1; -- Changed from 2 to 0.5 seconds

local activeTerm;
local activeDelay = 0;

-- Add this at the top with other local variables
local itemQueue = {};
local lastSoldItemId = 0;
local lastSoldItemIndex = 0;
local waitingForSale = false;
local minDelay = 0.1; -- Minimum delay between attempts

local function loadProfiles()
    -- Force reload by clearing the cache first
    package.loaded['profiles'] = nil;
    profiles = require('profiles');
    return profiles;
end

local function LocateItem(itemTerm)
    local invMgr = AshitaCore:GetMemoryManager():GetInventory();
    for i = 1,80 do
        local item = invMgr:GetContainerItem(0, i);
        if (item.Id > 0) then
            local resource = AshitaCore:GetResourceManager():GetItemById(item.Id);
            -- Uncomment this for debugging
            --print(string.format("Comparing: '%s' with '%s'", string.lower(resource.Name[1]), string.lower(itemTerm)));
            -- Ensure proper string cleaning for both strings
            local itemName = string.lower(string.gsub(string.trim(resource.Name[1]), "%s+", " "));
            local cleanTerm = string.lower(string.gsub(string.trim(itemTerm), "%s+", " "));
            if (itemName == cleanTerm) and (bit.band(resource.Flags, 0x1000) == 0) then
                return item;
            end
        end
    end
end

local function SellProfile(profileName)
    -- Load the latest profiles data when a sell command is used
    profiles = loadProfiles();
    
    if not profiles[profileName] then
        print(chat.header('SellIt') .. chat.error('Profile not found: ' .. profileName));
        return;
    end

    itemQueue = {}; -- Clear the queue first
    local itemsFound = false;
    for _, itemName in ipairs(profiles[profileName]) do
        local item = LocateItem(itemName);
        if item then
            itemsFound = true;
            table.insert(itemQueue, string.lower(itemName));
            local res = AshitaCore:GetResourceManager():GetItemById(item.Id);
            print(chat.header('SellIt') .. chat.message('Adding ') .. chat.color1(2, res.Name[1]) .. chat.message(' to sale queue.'));
        end
    end

    if not itemsFound then
        print(chat.header('SellIt') .. chat.error('No matching items found in profile: ' .. profileName));
    else
        -- Start with the first item
        activeTerm = table.remove(itemQueue, 1);
    end
end

ashita.events.register('command', 'cb_HandleCommand', function (e)
    if string.sub(string.lower(e.command),1,8) ~= '/sellit ' then
        return;
    end

    e.blocked = true;
    if (string.len(e.command) < 9) then
        return;
    end
    
    local args = string.sub(e.command, 9);
    if args:sub(1,1) == '@' then
        -- Load profiles and handle profile command
        local profileName = args:sub(2);
        SellProfile(profileName);
    else
        -- Handle single item selling (existing functionality)
        local itemTerm = string.lower(AshitaCore:GetChatManager():ParseAutoTranslate(args, false));
        local item = LocateItem(itemTerm);
        if (item ~= nil) then
            local res = AshitaCore:GetResourceManager():GetItemById(item.Id);
            activeTerm = itemTerm;
            print(chat.header('SellIt') .. chat.message('Beginning sale of ') .. chat.color1(2, res.Name[1]) .. chat.message('.'));
        else
            activeTerm = nil;
            print(chat.header('SellIt') .. chat.error('No matching items were found.'));
        end
    end
end);

ashita.events.register('packet_out', 'cb_HandleOutgoingPacket', function (e)
    if (e.id == 0x15) and (activeTerm ~= nil) then
        local item = LocateItem(activeTerm);
        if (item == nil) then
            if #itemQueue > 0 then
                -- Move to next item in queue immediately
                activeTerm = table.remove(itemQueue, 1);
                print(chat.header('SellIt') .. chat.message('Moving to next item.'));
            else
                print(chat.header('SellIt') .. chat.message('Sale complete.'));
                activeTerm = nil;
            end
            return;
        else
            -- Send the sell packets with minimal delay
            local appraise = struct.pack('LLHBB', 0, item.Count, item.Id, item.Index, 0);
            AshitaCore:GetPacketManager():AddOutgoingPacket(0x84, appraise:totable());
            local confirm = struct.pack('LL', 0, 1);
            AshitaCore:GetPacketManager():AddOutgoingPacket(0x85, confirm:totable());
            
            -- Use coroutine to check if item is gone
            ashita.tasks.once(minDelay, function()
                -- Check if item is gone
                if LocateItem(activeTerm) == nil then
                    if #itemQueue > 0 then
                        activeTerm = table.remove(itemQueue, 1);
                    else
                        print(chat.header('SellIt') .. chat.message('All sales complete.'));
                        activeTerm = nil;
                    end
                end
            end);
        end
    end
end);

-- Add a new packet_in handler to detect inventory changes
ashita.events.register('packet_in', 'cb_HandleIncomingPacket', function (e)
    -- Packet 0x1D (Inventory Finished) or 0x20 (Inventory Item Update)
    if waitingForSale and (e.id == 0x1D or e.id == 0x20) then
        -- Check if our current item is no longer in inventory
        local item = LocateItem(activeTerm);
        if item == nil then
            -- Item is gone, move to next
            if #itemQueue > 0 then
                activeTerm = table.remove(itemQueue, 1);
                print(chat.header('SellIt') .. chat.message('Item sold. Moving to next item.'));
            else
                print(chat.header('SellIt') .. chat.message('All sales complete.'));
                activeTerm = nil;
            end
            waitingForSale = false;
            -- Reset delay to allow immediate processing
            activeDelay = 0;
        end
    end
    
    -- Also check merchant completion packet (0xAE)
    if waitingForSale and e.id == 0x3C then
        -- Short delay to let inventory update
        activeDelay = os.clock() + 0.2;
    end
end);