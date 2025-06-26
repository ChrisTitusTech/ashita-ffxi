-- Move these to the top for better organization
local profile = {};
local sets = {};

-- Cache frequently accessed objects to reduce API calls
local chatManager = AshitaCore:GetChatManager();
local memoryManager = AshitaCore:GetMemoryManager();

-- Constants for better maintainability
local RUNE_LIST = { 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae' };
-- Keybind configuration table for easier management
local KEYBINDS = {
    { key = '`', command = '/ws "Dimidiation" <t>' },
    { key = '^`', command = '/ws "Resolution" <t>' },
    { key = 'numpad0', command = '/ma "Foil" <me>' },
    { key = 'numpad.', command = '/ma "Crusade" <me>' },
    { key = 'numpad3', command = '/ma "Refresh" <me>' },
    { key = 'numpad1', command = '/ma "Phalanx" <me>' },
    { key = '!numpad0', command = '/ja "Swipe" <t>' },
    { key = '!numpad.', command = '/ja "Swordplay" <me>' },
    { key = '!numpad3', command = '/ma "Temper" <me>' },
    { key = '!numpad1', command = '/ja "Rayke" <t>' },
    { key = '^numpad0', command = '/ja "Pflug" <me>' },
    { key = '^numpad.', command = '/ja "Elemental Sforzo" <me> ' },
    { key = '^numpad3', command = '/ma "Shell V" <me>' },
    { key = '^numpad1', command = '/ma "Protect IV" <me>' },
};

gcinclude = gFunc.LoadFile('common\\gcinclude.lua');
gcheals = gFunc.LoadFile('common\\gcheals.lua');

gcinclude.sets.Movement = {
    Ring1 = 'Shneddick Ring',
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.Initialize();
    
    -- Set up aliases and binds only for RUN job
    local player = gData.GetPlayer();
    if player and player.MainJob == 'RUN' then
        -- Set up aliases for commands
        AshitaCore:GetChatManager():QueueCommand(1, '/alias /stat /lac fwd status');
        AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
        AshitaCore:GetChatManager():QueueCommand(1, '/macro set 8');
        
    end
end

profile.OnUnload = function()
    for _, bind in ipairs(KEYBINDS) do
        AshitaCore:GetChatManager():QueueCommand(1, '/unbind ' .. bind.key);
    end
    gcinclude.Unload();
end

-- weapon configuration system
local WEAPON_CONFIGS = {
    Primary = {
        main = 'Epeolatry',
        sub = 'Refined Grip +1',
        ear1 = 'Brutal Earring',
        ear2 = 'Cessance Earring'
    },
    Secondary = {
        main = 'Naegling',
        sub = 'Blurred Sword +1',
        ear1 = 'Suppanomimi',
        ear2 = 'Eabani Earring'
    },
    Third = {
        main = 'Hepatizon Axe +1',
        sub = 'Refined Grip +1',
        ear1 = 'Telos Earring',
        ear2 = 'Cessance Earring'
    }
};

local Setweapon = WEAPON_CONFIGS.Primary.main;
local Setoffhand = WEAPON_CONFIGS.Primary.sub;
local Setear1 = WEAPON_CONFIGS.Primary.ear1;
local Setear2 = WEAPON_CONFIGS.Primary.ear2;
local SetBody = 'Erilaz Surcoat +3';

sets.Weapons = {
    Main = Setweapon,
    Sub = Setoffhand,
    Ear1 = Setear1,
    Ear2 = Setear2,
    Body = SetBody,
};

sets.Idle = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Homiliary',
    Head = 'Erilaz Galea +3',
    Neck = 'Bathy Choker +1',
    Body = 'Turms Harness',
    Hands = 'Turms Mittens +1',
    Waist = 'Plat. Mog. Belt',
    Ear1 = 'Odnowa Earring +1',
    Ear2 = 'Ethereal Earring',
    Ring1 = 'Shneddick Ring',
    Ring2 = 'Moonbeam Ring',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = 'HP+60', [3] = 'Mag. Evasion+30', [4] = '"Store TP"+10', [5] = 'Evasion+20' } },
    Legs = 'Turms Subligar',
    Feet = 'Turms Leggings',
};

sets.Resting = sets.Idle;

sets.Precast = {
    Ammo = 'Sapience orb',
    Head = 'Rune. Bandeau +1',
    Ear1 = 'Loquac. Earring',
    Body = 'Erilaz Surcoat +3',
    Legs = 'Aya. Cosciales +2',
};

sets.EnhancePrecastAdd = {
    Legs = 'Futhark Trousers +3',
    Waist = 'Siegel Sash',
};
sets.EnhancePrecast = gFunc.Combine(sets.Precast, sets.EnhancePrecastAdd);

sets.Midcast = {                 -- 100% SIRD
    Ammo = 'Staunch Tathlum',    -- 10% SIRD
    Ear2 = 'Halasz Earring',    -- 5% SIRD
    Head = 'Erilaz Galea +3',    -- 20% SIRD
    Neck = 'Moonbeam Necklace',  -- 10% SIRD
    Legs = 'Carmine Cuisses +1', -- 20% SIRD
    Hands = 'Rawhide Gloves',  -- 15% SIRD
    Waist = 'Audumbla Sash', -- 10% SIRD
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Spell interruption rate down-10%', [2] = 'MND+25', [3] = '"Cure" potency +10%' } },
}
sets.EnhancingMidcastAdd = {
    Legs = 'Futhark Trousers +3',
}
sets.EnhancingMidcast = gFunc.Combine(sets.Midcast, sets.EnhancingMidcastAdd);

sets.DT = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Staunch Tathlum',
    Neck = 'Futhark Torque +2',
    Head = 'Erilaz Galea +3',
    Body = sets.Weapons.Body,
    Hands = 'Turms Mittens +1',
    Legs = 'Eri. Leg Guards +3',
    Feet = 'Erilaz Greaves +3',
    Waist = 'Plat. Mog. Belt',
    Ear1 = 'Odnowa Earring +1',
    Ear2 = sets.Weapons.Ear2,
    Ring1 = 'Moonbeam Ring',
    Ring2 = 'Moonbeam Ring',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = 'HP+60', [3] = 'Mag. Evasion+30', [4] = '"Store TP"+10', [5] = 'Evasion+20' } },
};

sets.Hybrid = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Coiste Bodhar',
    Head = 'Erilaz Galea +3',
    Body = 'Adhemar Jacket +1',
    Hands = 'Turms Mittens +1',
    Legs = 'Eri. Leg Guards +3',
    Feet = 'Erilaz Greaves +3',
    Neck = 'Futhark Torque +2',
    Waist = 'Sailfi Belt +1',
    Ear1 = sets.Weapons.Ear1,
    Ear2 = sets.Weapons.Ear2,
    Ring1 = 'Epona\'s Ring',
    Ring2 = 'Niqmaddu Ring',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = 'HP+60', [3] = 'Mag. Evasion+30', [4] = '"Store TP"+10', [5] = 'Evasion+20' } },
}

sets.Acc = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Hasty Pinion +1',
    Head = 'Erilaz Galea +3',
    Body = 'Adhemar Jacket +1',
    Hands = 'Turms Mittens +1',
    Legs = 'Eri. Leg Guards +3',
    Feet = 'Erilaz Greaves +3',
    Neck = 'Defiant Collar',
    Waist = 'Ioskeha Belt',
    Ear1 = 'Telos Earring',
    Ear2 = sets.Weapons.Ear2,
    Ring1 = 'Chirich Ring',
    Ring2 = 'Moonbeam Ring',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = 'HP+60', [3] = 'Mag. Evasion+30', [4] = '"Store TP"+10', [5] = 'Evasion+20' } },
}

sets.Default = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Coiste Bodhar',
    Head = 'Adhemar Bonnet',
    Body = 'Adhemar Jacket +1',
    Hands = 'Herculean Gloves',
    Legs = 'Meg. Chausses +2',
    Feet = 'Herculean Boots',
    Neck = 'Defiant Collar',
    Waist = 'Sailfi Belt +1',
    Ear1 = sets.Weapons.Ear1,
    Ear2 = sets.Weapons.Ear2,
    Ring1 = 'Epona\'s Ring',
    Ring2 = 'Niqmaddu Ring',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = 'HP+60', [3] = 'Mag. Evasion+30', [4] = '"Store TP"+10', [5] = 'Evasion+20' } },
};

sets.Ws_Default = {
    Ammo = 'Oshasha\'s Treatise',
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
    Ear1 = 'Moonshade Earring',
    Ring1 = 'Cornelia\'s Ring',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Weapon skill damage +10%', [2] = 'STR+20', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = '"Regen"+5' } },
    Hands = 'Meg. Gloves +2',
    Body = 'Nyame Mail',
    Legs = 'Nyame Flanchard',
};

sets.Savage_BladeAdd = {
    Ear2 = 'Cessance Earring',
    Head = 'Erilaz Galea +3',
    Ring2 = 'Chirich Ring',
    Feet = 'Erilaz Greaves +3',
};
sets.Savage_Blade = gFunc.Combine(sets.Ws_Default, sets.Savage_BladeAdd);

sets.DimidationAdd = {
    Ear2 = 'Brutal Earring',
    Head = 'Nyame Helm',
    Feet = 'Erilaz Greaves +3',
};
sets.Dimidiation = gFunc.Combine(sets.Ws_Default, sets.DimidationAdd);

sets.Resolution = sets.Ws_Default;

gcinclude.sets.TH = {
    Ammo = 'Per. Lucky Egg',
};

sets.Valiance = {
    Body = 'Runeist Coat +2',
};

sets.Vivacious_Pulse = {
    Head = 'Erilaz Galea +3',
};

sets.Pflug = {
    Feet = 'Runeist Bottes',
};

sets.Rayke = {
    Feet = 'Futhark Boots +1',
};

sets.Gambit = {
    Hands = 'Runeist Mitons',
};

sets.Phalanx = {
    Main = 'Deacon Sword',
    Head = 'Fu. Bandeau +1',
    Back = 'Evasionist\'s Cape',
    Body = 'Taeon Tabard',
    Hands = 'Taeon Gloves',
    Legs = 'Taeon Tights',
    Feet = 'Taeon Boots',
}

sets.Refresh = {};
sets.LockStyle = {
    Main = 'Epeolatry',
    Sub = 'Refined Grip +1',
    Head = 'Erilaz Galea +3',
    Body = 'Erilaz Surcoat +3',
    Hands = 'Erilaz Gauntlets',
    Legs = 'Eri. Leg Guards +3',
    Feet = 'Erilaz Greaves +3',
}

profile.Sets = sets;

profile.Packer = {};

profile.UpdateSets = function()
    for _, set in ipairs({ 'Weapons', 'Hybrid', 'Idle', 'Acc', 'DT', 'Default' }) do
        if sets[set] then
            sets[set].Main = Setweapon
            sets[set].Sub = Setoffhand
            sets[set].Ear1 = Setear1
            sets[set].Ear2 = Setear2
            if set == 'DT' then sets[set].Body = SetBody end
        end
    end
end

profile.CountRunes = function()
    -- Count the number of runes active on the player
    local runeCount = 0;

    for i = 1, #RUNE_LIST do
        if (gData.GetBuffCount(RUNE_LIST[i]) > 0) then
            runeCount = runeCount + gData.GetBuffCount(RUNE_LIST[i]);
        end
    end

    return runeCount;
end

profile.SoloMode = function()
    local player = gData.GetPlayer();
    local recast = AshitaCore:GetMemoryManager():GetRecast();
    local temperRecast = recast:GetSpellTimer(493);
    local target = gData.GetTarget();
    if player.Status == 'Engaged' and gData.GetEquipment() and gData.GetEquipment().Main then
        if player.TP > 1000 and gcinclude.CheckWsBailout() == true and gData.GetEquipment().Main.Name == 'Epeolatry' and gcheals.CheckTrustMembers() == 5 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Dimidiation" <t>');
        elseif player.TP > 1000 and gcinclude.CheckWsBailout() == true and gData.GetEquipment().Main.Name == 'Hepatizon Axe +1' and gcheals.CheckTrustMembers() == 5 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Steel Cyclone" <t>');
        elseif player.TP > 1750 and gcinclude.CheckWsBailout() == true and (player.HPP > 50) and gData.GetEquipment().Main.Name == 'Naegling' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Savage Blade" <t>');
        elseif player.TP > 1000 and gcinclude.CheckWsBailout() == true and (player.HPP <= 50) and gData.GetEquipment().Main.Name == 'Naegling' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Sanguine Blade" <t>');
        end
        if (player.HPP < 50) and gcinclude.CheckAbilityRecast('Vivacious Pulse') == 0 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Vivacious Pulse" <me>');
        elseif gData.GetBuffCount('Multi Strikes') == 0 and temperRecast == 0 and (player.MPP > 50) and gcinclude.CheckSpellBailout() == true then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Temper" <me>');
        elseif gcinclude.CheckAbilityRecast('Curing Waltz III') == 0 and player.HPP < 35 and player.SubJob == 'DNC' and player.TP > 500 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Curing Waltz III" <me>');
        elseif gcinclude.CheckAbilityRecast('Healing Waltz') == 0 and player.TP >= 200 and gData.GetBuffCount('Paralysis') ~= 0 and player.SubJob == 'DNC' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Healing Waltz" <me>');
        elseif gcinclude.CheckAbilityRecast('Rune Enchantment') == 0 and profile.CountRunes() ~= 3 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Sulpor" <me>');
        elseif gData.GetBuffCount('Haste Samba') == 0 and gcinclude.CheckAbilityRecast('Sambas') == 0 and (player.TP >= 350) and player.SubJob == 'DNC' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Haste Samba" <me>');
        elseif gData.GetBuffCount('Hasso') == 0 and gcinclude.CheckAbilityRecast('Hasso') == 0 and player.SubJob == 'SAM' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Hasso" <me>');
        elseif target then
            gcinclude.AutoEngage();
        end
    elseif player.Status ~= 'Engaged' then
        if player.MPP < 50 and gcinclude.CheckAbilityRecast('Rune Enchantment') == 0 and gData.GetBuffCount('Lux') ~= 3 and gData.GetBuffCount('Invisible') == 0 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Lux" <me>');
        end
    end
end

profile.Weapons = function()
    local currentCycle = gcdisplay.GetCycle('Weapon');
    local config = WEAPON_CONFIGS[currentCycle];
    
    if config and (Setweapon ~= config.main) then
        Setweapon = config.main;
        Setoffhand = config.sub;
        Setear1 = config.ear1;
        Setear2 = config.ear2;
        profile.UpdateSets();
        gFunc.EquipSet(sets.Weapons);
    end
end

profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();
    local inventory = AshitaCore:GetMemoryManager():GetInventory();
    -- Enhanced safety checks
    if not player or not player.MainJob or player.MainJob ~= 'RUN' or player.Status == 'Zoning' or not inventory then
        return;
    end

    local equipment = gData.GetEquipment();
    local equipbody = equipment and equipment.Body and equipment.Body.Name or 'Nothing';
    local target = gData.GetTarget();

    profile.Weapons();
    if (gcdisplay.GetToggle('Solo') == true) then profile.SoloMode() end;
    gcinclude.CheckDefault();
    gcinclude.AutoEngage();
    
    -- Safer phalanx failsafe
    if equipbody and target and player.MainJob == 'RUN' then
        if equipbody == 'Taeon Tabard' and target.Type == 'Monster' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac set DT 1');
        end
    end
end

profile.HandleAbility = function()
    local action = gData.GetAction();
    
    -- Safety check to prevent crashes
    if not action or not action.Name then return end;

    if (action.Name == 'Valiance') then
        gFunc.EquipSet(sets.Valiance);
    elseif (action.Name == 'Vivacious Pulse') then
        gFunc.EquipSet(sets.Vivacious_Pulse);
    elseif (action.Name == 'Pflug') then
        gFunc.EquipSet(sets.Pflug);
    elseif (action.Name == 'Rayke') then
        gFunc.EquipSet(sets.Rayke);
    elseif (action.Name == 'Gambit') then
        gFunc.EquipSet(sets.Gambit);
    end

    gcinclude.CheckCancels();
end

profile.HandleItem = function()
    local item = gData.GetAction();
    
    -- Safety check to prevent crashes
    if not item or not item.Name then return end;

    if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(gcinclude.sets.Holy_Water) end;
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();
    
    -- Safety check to prevent crashes
    if not spell then return end;
    
    gcinclude.DoShadows(spell);
    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.EnhancePrecast);
    else
        gFunc.EquipSet(sets.Precast);
    end

    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    local spell = gData.GetAction();
    local player = gData.GetPlayer();
    
    -- Safety checks to prevent crashes
    if not spell or not player then return end;
    
    if spell.Skill == 'Enhancing Magic' and player.Status ~= 'Engaged' then
        gFunc.EquipSet(sets.EnhancingMidcast);
        if spell.Name == 'Phalanx' then
            gFunc.EquipSet(sets.Phalanx);
        end
    else
        gFunc.EquipSet(sets.Midcast);
    end
end

profile.HandleWeaponskill = function()
    local canWS = gcinclude.CheckWsBailout();
    if (canWS == false) then
        gFunc.CancelAction()
        return;
    else
        local ws = gData.GetAction();
        
        -- Safety check to prevent crashes
        if not ws or not ws.Name then return end;

        gFunc.EquipSet(sets.Ws_Default)

        if string.match(ws.Name, 'Savage Blade') then
            gFunc.EquipSet(sets.Savage_Blade)
        elseif string.match(ws.Name, 'Resolution') then
            gFunc.EquipSet(sets.Resolution)
        elseif string.match(ws.Name, 'Dimidiation') then
            gFunc.EquipSet(sets.Dimidiation)
        end
    end
end

return profile;
