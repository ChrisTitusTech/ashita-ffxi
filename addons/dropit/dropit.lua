addon.name      = 'DropIt';
addon.author    = 'christitustech';
addon.version   = '1.0';
addon.desc      = 'Automatically drops specified items from inventory based on autodrop list';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local autodrop = require('profiles');

-- Configuration
local autoDropEnabled = true; -- Default state for auto-dropping
local debug_enabled = false;

-- Create a lookup table for faster item checking
local itemsToAutoDrop = {};
local lastDropTime = {};  -- Track last drop time for each item

-- Function to reload profiles and update the itemsToAutoDrop table
local function ReloadProfiles()
    -- Clear the current itemsToAutoDrop table
    itemsToAutoDrop = {};
    
    -- Reload the profiles module
    package.loaded.profiles = nil;
    local newAutodrop = require('profiles');
    
    -- Update the itemsToAutoDrop table with new items
    for _, itemName in ipairs(newAutodrop) do
        -- Normalize item names by trimming whitespace and converting to lowercase
        local normalizedName = string.lower(string.gsub(itemName, "^%s*(.-)%s*$", "%1"));
        itemsToAutoDrop[normalizedName] = true;
        
        if debug_enabled then
            print(chat.header('DropIt') .. chat.message('Added to drop list: ' .. itemName));
        end
    end
    
    if debug_enabled then
        print(chat.header('DropIt') .. chat.message('Profiles reloaded. Items to drop: ' .. #newAutodrop));
    end
end

-- Initialize items from autodrop list
ReloadProfiles();

local function CheckInventory()
    if not autoDropEnabled then return end
    
    local invMgr = AshitaCore:GetMemoryManager():GetInventory();
    local count = invMgr:GetContainerCountMax(0); -- 0 is main inventory
    local currentTime = os.time();
    
    if debug_enabled then
        print(string.format('[Debug] Checking main inventory. Total slots: %d', count));
    end
    
    -- Scan through inventory
    for index = 1, count do
        local item = invMgr:GetContainerItem(0, index);
        if (item ~= nil and item.Id > 0) then
            if debug_enabled then
                print(string.format('[Debug] Found item ID: %d, Count: %d in slot %d', item.Id, item.Count, index));
            end
            
            local resource = AshitaCore:GetResourceManager():GetItemById(item.Id);
            if resource ~= nil then
                local itemName = resource.Name[1];
                local itemNameLower = string.lower(string.gsub(itemName, "^%s*(.-)%s*$", "%1"));
                
                if debug_enabled then
                    print(string.format('[Debug] Item details - Name: %s, ID: %d', itemName, item.Id));
                    print(string.format('[Debug] In drop list: %s', itemsToAutoDrop[itemNameLower] and 'yes' or 'no'));
                end
                
                -- Check if item should be dropped and hasn't been dropped recently
                if autoDropEnabled and itemsToAutoDrop[itemNameLower] and 
                   (not lastDropTime[itemNameLower] or currentTime - lastDropTime[itemNameLower] >= 2) then
                    if debug_enabled then
                        print(chat.header('DropIt') .. chat.message('Dropping: ' .. itemName));
                    end
                    lastDropTime[itemNameLower] = currentTime;  -- Update last drop time
                    AshitaCore:GetChatManager():QueueCommand(1, string.format('/drop "%s"', itemName));
                end
            else
                if debug_enabled then
                    print(string.format('[Debug] Could not get resource info for item ID: %d', item.Id));
                end
            end
        end
    end
end

-- Command handler for manual control
ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:lower():args();
    if (not args[1] or args[1] ~= '/dropit') then
        return;
    end

    e.blocked = true;

    if args[2] == 'debug' then
        debug_enabled = not debug_enabled;
        print(chat.header('DropIt') .. chat.message('Debug mode: ' .. (debug_enabled and 'enabled' or 'disabled')));
        return;
    end
    
    -- Add command to reload profiles
    if args[2] == 'reload' then
        ReloadProfiles();
        print(chat.header('DropIt') .. chat.message('Profiles reloaded'));
        return;
    end

    -- Force inventory check if no arguments provided
    if not args[2] then
        print(chat.header('DropIt') .. chat.message('Forcing inventory check...'));
        CheckInventory();
        return;
    end
end);

-- Monitor inventory changes
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Inventory Item Update (0x20) or Inventory Finished (0x1D)
    if (e.id == 0x20 or e.id == 0x1D) then
        -- Reload profiles before checking inventory
        ReloadProfiles();
        CheckInventory();
    end
end);
