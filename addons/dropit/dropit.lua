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

-- Initialize items from autodrop list
for _, itemName in ipairs(autodrop) do
    itemsToAutoDrop[string.lower(itemName)] = true;
end

local function CheckInventory()
    if not autoDropEnabled then return end
    
    local invMgr = AshitaCore:GetMemoryManager():GetInventory();
    local count = invMgr:GetContainerCount(0); -- 0 is main inventory
    local currentTime = os.time();
    
    if debug_enabled then
        print(string.format('[Debug] Checking inventory. Count: %d', count));
    end
    
    -- Scan through inventory
    for index = 1, count do
        local item = invMgr:GetContainerItem(0, index);
        if (item ~= nil and item.Id > 0) then
            local resource = AshitaCore:GetResourceManager():GetItemById(item.Id);
            if resource ~= nil then
                local itemName = resource.Name[1];
                local itemNameLower = string.lower(itemName);
                -- Check if item should be dropped and hasn't been dropped recently
                if autoDropEnabled and itemsToAutoDrop[itemNameLower] and 
                   (not lastDropTime[itemNameLower] or currentTime - lastDropTime[itemNameLower] >= 2) then
                    if debug_enabled then
                        print(chat.header('DropIt') .. chat.message('Dropping: ' .. itemName));
                    end
                    lastDropTime[itemNameLower] = currentTime;  -- Update last drop time
                    AshitaCore:GetChatManager():QueueCommand(1, string.format('/drop "%s"', itemName));
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

    -- Add command to toggle auto-drop
    if args[2] == 'toggle' then
        autoDropEnabled = not autoDropEnabled;
        print(chat.header('DropIt') .. chat.message('Auto-drop is now: ' .. (autoDropEnabled and 'enabled' or 'disabled')));
        if autoDropEnabled then
            CheckInventory(); -- Check inventory immediately when enabling
        end
        return;
    end

    if not args[2] then
        print(chat.header('DropIt') .. chat.error('Commands: /dropit toggle - Toggle auto-drop'));
        print(chat.header('DropIt') .. chat.message('          /dropit debug - Toggle debug mode'));
        return;
    end
end);

-- Monitor inventory changes
ashita.events.register('packet_in', 'packet_in_cb', function (e)
    -- Inventory Item Update (0x20) or Inventory Finished (0x1D)
    if (e.id == 0x20 or e.id == 0x1D) then
        CheckInventory();
    end
end);
