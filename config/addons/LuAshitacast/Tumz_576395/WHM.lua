local profile = {};

gcinclude = gFunc.LoadFile('common\\gcinclude.lua');
gcheals = gFunc.LoadFile('common\\gcheals.lua');
gcinclude.sets.Sleeping = {
    Main = 'Lorg Mor',
};
-- Add a variable to store main weapon
Setweapon = 'Queller Rod';
Setoffhand = 'Sors Shield';
local sets = {};

sets.Weapons = {
    Main = Setweapon,
    Sub = Setoffhand
};
sets.Refresh = {
    Ammo = 'Homiliary',
    Neck = 'Sibyl Scarf',
    Body = 'Ebers Bliaut +2',
};
sets.Idle = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Homiliary',
    Head = 'Nyame Helm',
    Neck = 'Clr. Torque +1',
    Ear1 = 'Odnowa Earring +1',
    Ear2 = 'Ethereal Earring',
    Body = 'Ebers Bliaut +2',
    Hands = 'Ebers Mitts +2',
    Ring1 = 'Shneddick Ring',
    Ring2 = 'Prolix Ring',
    Back = 'Alaunus\'s Cape',
    Waist = 'Plat. Mog. Belt',
    Legs = 'Ebers Pant. +3',
    Feet = 'Nyame Sollerets'
};

sets.Resting = {};

sets.Precast = {
    Ammo = 'Incantor Stone',
    Head = 'Ebers Cap +2',
    Neck = { Name = 'Clr. Torque +1', AugPath = 'A' },
    Ear2 = 'Malignance Earring',
    Body = 'Inyanga Jubbah +2',
    Hands = 'Gende. Gages +1',
    Ring2 = 'Prolix Ring',
    Ring1 = 'Naji\'s Loop',
    Back = 'Swith Cape',
    Waist = 'Embla Sash',
    Legs = 'Aya. Cosciales +2',
};

sets.Cure = {
    Ammo = 'Staunch Tathlum', --SIRD 10%
    Head = 'Ebers Cap +2',
    Neck = 'Clr. Torque +1',
    Ear1 = 'Roundel Earring',
    Ear2 = 'Ebers Earring',
    Body = 'Ebers Bliaut +2',
    Ring1 = 'Sirona\'s Ring',
    Ring2 = 'Menelaus\'s Ring',
    Back = 'Alaunus\'s Cape',
    Legs = 'Ebers Pant. +3',
    Feet = 'Theo. Duckbills +3', --SIRD 29%
};
sets.LockStyle = sets.Cure;

sets.Enhancing = {
    Ammo = 'Staunch Tathlum',
    Head = 'Befouled Crown',
    Neck = 'Colossus\'s Torque',
    Ear2 = 'Halasz Earring',
    Ring1 = 'Stikini Ring',
    Ring2 = 'Stikini Ring',
    Waist = 'Embla Sash',
    Legs = 'Piety Pantaloons',
    Feet = 'Theo. Duckbills +3'
};

sets.Regen = {
    Head = 'Inyanga Tiara +2',
    Body = 'Piety Bliaut +1',
    Hands = 'Ebers Mitts +2',
    Legs = 'Theo. Pant. +1',
    Waist = 'Embla Sash',
    Feet = 'Theo. Duckbills +3',
};

sets.Elemental = {
    Ammo = 'Staunch Tathlum',
    Neck = 'Sanctity Necklace',
    Ear1 = 'Friomisi Earring',
    Ear2 = 'Halasz Earring',
    Ring1 = 'Sangoma Ring',
    Ring2 = 'Prolix Ring',
    Back = 'Alaunus\'s Cape',
    Waist = 'Aswang Sash',
    Head = 'Nyame Helm',
    Body = 'Nyame Mail',
    Hands = 'Nyame Gauntlets',
    Legs = 'Nyame Flanchard',
    Feet = 'Nyame Sollerets',
};

sets.Default = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Hasty Pinion +1',
    Head = 'Nyame Helm',
    Body = 'Ayanmo Corazza +2',
    Hands = 'Bunzi\'s Gloves',
    Legs = 'Ebers Pant. +3',
    Feet = 'Nyame Sollerets',
    Neck = 'Sanctity Necklace',
    Waist = 'Cetl Belt',
    Ear1 = 'Cessance Earring',
    Ear2 = 'Telos Earring',
    Ring1 = 'Chirich Ring',
    Ring2 = 'Rajas Ring',
    Back = 'Alaunus\'s Cape'
};
sets.DTadd = {
    Head = 'Nyame Helm',
    Body = 'Nyame Mail',
    Hands = 'Nyame Gauntlets',
    Legs = 'Nyame Flanchard',
    Feet = 'Nyame Sollerets',
    Waist = 'Plat. Mog. Belt',
    Neck = 'Elite Royal Collar',
};
sets.DT = gFunc.Combine(sets.Default, sets.DTadd);
sets.Hybrid = sets.Default
sets.AccAdd = {
    Ammo = 'Hasty Pinion +1',
    Waist = 'Famine Sash',
}
sets.Acc = gFunc.Combine(sets.Default, sets.AccAdd);

gcinclude.sets.Movement = {
    Ring1 = 'Shneddick Ring',
};
sets.Ws_Default = {
    Ammo = 'Oshasha\'s Treatise',
    Neck = 'Fotia Gorget',
    Ear1 = 'Moonshade Earring',
    Ring1 = 'Cornelia\'s Ring',
    Waist = 'Fotia Belt',
    Body = 'Nyame Mail',
    Hands = 'Nyame Gauntlets',
    Legs = 'Nyame Flanchard',
    Feet = 'Nyame Sollerets',
};
sets.Afflatus_Solace = {
    Body = 'Ebers Bliaut +2'
};

sets.Cursna = {
    Neck = 'Malison Medallion',
    Ring1 = 'Menelaus\'s Ring',
    Ring2 = 'Haoma\'s Ring',
    Back = 'Alaunus\'s Cape',
    Waist = 'Gishdubar Sash',
    Legs = 'Theo. Pant. +1',
};

profile.Sets = sets;

profile.Packer = {
    'Echo Drops',
    'Holy Water',
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.Initialize();
    AshitaCore:GetChatManager():QueueCommand(1, '/alias /stat /lac fwd status');

    -- Set macro book/set
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 1');
end

profile.OnUnload = function()
    AshitaCore:GetChatManager():QueueCommand(1, '/alias /del /stat');
    gcinclude.Unload();
end

profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.UpdateSets = function()
    local player = gData.GetPlayer();
    
    -- Safety checks to prevent crashes
    if not player then return end;
    if player.MainJob ~= 'WHM' then return end; -- Only run on WHM job
    
    if (gcdisplay.GetCycle('Weapon') == 'Secondary') and (Setweapon ~= 'Magesmasher +1') then
        Setweapon = 'Magesmasher +1'
        if player.SubJob == 'NIN' or player.SubJob == 'DNC' then
            Setoffhand = 'Bunzi\'s Rod'
        else
            Setoffhand = 'Sors Shield'
        end
        for _, set in ipairs({ 'Weapons', 'Idle', 'DT', 'Default', 'Acc' }) do
            if sets[set] then
                sets[set].Main = Setweapon
                sets[set].Sub = Setoffhand
            end
        end
        gFunc.EquipSet(sets.Weapons)
    elseif (gcdisplay.GetCycle('Weapon') == 'Primary') and (Setweapon ~= 'Queller Rod') then
        Setweapon = 'Queller Rod'
        if player.SubJob == 'NIN' or player.SubJob == 'DNC' then
            gcdisplay.SetCycle('Weapon', 'Secondary')
        else
            Setoffhand = 'Sors Shield'
        end
        for _, set in ipairs({ 'Weapons', 'Idle', 'DT', 'Default', 'Acc' }) do
            if sets[set] then
                sets[set].Main = Setweapon
                sets[set].Sub = Setoffhand
            end
        end
        gFunc.EquipSet(sets.Weapons)
    end
end

profile.SoloMode = function()
    local player = gData.GetPlayer();
    local recast = AshitaCore:GetMemoryManager():GetRecast();
    local hasteRecast = recast:GetSpellTimer(57);
    local target = gData.GetTarget();
    if gcinclude.CheckWsBailout() == true and player.HPP > 35 and player.MPP > 50 and player.TP > 1000 and target then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Flash Nova" <t>');
    elseif gcinclude.CheckWsBailout() == true and player.MPP <= 50 and player.TP > 1000 and target then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Mystic Boon" <t>');
    elseif gcinclude.CheckAbilityRecast('Curing Waltz III') == 0 and player.HPP <= 35 and player.SubJob == 'DNC' and player.TP > 500 then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Curing Waltz III" <me>');
    elseif gcinclude.CheckAbilityRecast('Healing Waltz') == 0 and player.TP >= 200 and gData.GetBuffCount('Paralysis') ~= 0 and player.SubJob == 'DNC' then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Healing Waltz" <me>');
    elseif gData.GetBuffCount('Haste Samba') == 0 and gcinclude.CheckAbilityRecast('Sambas') == 0 and (player.TP >= 350) and player.SubJob == 'DNC' then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Haste Samba" <me>');
    elseif gData.GetBuffCount('Haste') == 0 and hasteRecast == 0 then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Haste" <me>');
    end
    gcinclude.AutoEngage();
    gcinclude.AutoAssist();
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();
    local inventory = AshitaCore:GetMemoryManager():GetInventory();
    -- Enhanced safety checks
    if not player or not player.MainJob or player.MainJob ~= 'WHM' or player.Status == 'Zoning' or not inventory then
        return;
    end
    profile.UpdateSets();
    gcinclude.CheckDefault();
    if gcdisplay.GetToggle('Autoheal') == true then gcheals.CheckParty() end;
    if gcdisplay.GetToggle('Solo') == true then profile.SoloMode() end;
    if gData.GetBuffCount('Corsair\'s Roll') == 0 and gcinclude.CheckAbilityRecast('Phantom Roll') == 0 and gData.GetBuffCount('Double-Up Chance') == 0 and player.SubJob == 'COR' then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Corsair\'s Roll" <me>');
    end
end

profile.HandleAbility = function()
    local action = gData.GetAction();
    
    -- Safety check to prevent crashes
    if not action or not action.Name then return end;

    if (action.Name == 'Afflatus Solace') then
        gFunc.EquipSet(sets.Afflatus_Solace);
    end

    gcinclude.CheckCancels();
end

profile.HandleItem = function()
    local item = gData.GetAction();
    
    -- Safety check to prevent crashes
    if not item or not item.Name then return end;

    if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(gcinclude.sets.Holy_Water) end
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();
    
    -- Safety check to prevent crashes
    if not spell then return end;
    
    gFunc.EquipSet(sets.Precast);

    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    local weather = gData.GetEnvironment();
    local player = gData.GetPlayer();
    local spell = gData.GetAction();
    
    -- Safety checks to prevent crashes
    if not spell or not player or not weather then return end;
    if player.MainJob ~= 'WHM' then return end; -- Only run on WHM job

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing);
        if string.match(spell.Name, 'Regen') then
            gFunc.EquipSet(sets.Regen);
        end
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Cure);
        if string.match(spell.Name, 'Cursna') then
            gFunc.EquipSet(sets.Cursna);
        end
    elseif (spell.Skill == 'Elemental Magic') then
        gFunc.EquipSet(sets.Elemental);
        if spell.Element and weather.WeatherElement and weather.DayElement and
           ((spell.Element == weather.WeatherElement) or (spell.Element == weather.DayElement)) then
            gFunc.Equip('Waist', 'Hachirin-no-Obi');
        end
    elseif (spell.Skill == 'Enfeebling Magic') then
        -- Fix: Check if sets.Enfeebling_Magic exists before using it
        if sets.Enfeebling_Magic then
            gFunc.EquipSet(sets.Enfeebling_Magic);
        end
    end
end

profile.HandleWeaponskill = function()
    local canWS = gcinclude.CheckWsBailout();
    if (canWS == false) then
        gFunc.CancelAction()
        return;
    else
        gFunc.EquipSet(sets.Ws_Default)
    end
end

return profile;
