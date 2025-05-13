local profile = {};

gcinclude = gFunc.LoadFile('common\\gcinclude.lua');
gcheals = gFunc.LoadFile('common\\gcheals.lua');
gcinclude.sets.Sleeping = {
    Main = 'Prime Maul',
};
-- Add a variable to store main weapon
Setweapon = 'Queller Rod';
Setoffhand = 'Sors Shield';
local sets = {};

sets.Weapons = {
    Main = Setweapon,
    Sub = Setoffhand
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
    Legs = 'Ebers Pant. +2',
    Feet = 'Nyame Sollerets'
};

sets.Dt = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Hasty Pinion +1',
    Head = 'Nyame Helm',
    Body = 'Nyame Mail',
    Hands = 'Nyame Gauntlets',
    Legs = 'Nyame Flanchard',
    Feet = 'Nyame Sollerets',
    Neck = 'Asperity Necklace',
    Waist = 'Plat. Mog. Belt',
    Ear1 = 'Odnowa Earring +1',
    Ear2 = 'Cessance Earring',
    Ring1 = 'Shneddick Ring',
    Ring2 = 'Ephramad\'s Ring',
    Back = 'Alaunus\'s Cape'
};

sets.Resting = {};

sets.Precast = {
    Ammo = 'Incantor Stone',
    Head = 'Ebers Cap +2',
    Neck = { Name = 'Clr. Torque +1', AugPath='A' },
    Ear1 = 'Loquac. Earring',
    Ear2 = 'Malignance Earring',
    Body = 'Inyanga Jubbah +1',
    Hands = 'Gende. Gages +1',
    Ring1 = 'Prolix Ring',
    Ring2 = 'Naji\'s Loop',
    Back = 'Swith Cape',
    Waist = 'Embla Sash',
    Legs = 'Aya. Cosciales +2',
    Feet = 'Theo. Duckbills +1', --Need FastCast
};

sets.Cure = {
    Ammo = 'Staunch Tathlum',
    Head = 'Ebers Cap +2',
    Neck = 'Clr. Torque +1',
    Ear1 = 'Roundel Earring',
    Ear2 = 'Ebers Earring',
    Body = 'Ebers Bliaut +2',
    Ring1 = 'Sirona\'s Ring',
    Ring2 = 'Ephedra Ring',
    Back = 'Alaunus\'s Cape',
    Waist = 'Witful Belt',
    Legs = 'Ebers Pant. +2',
    Feet = 'Theo. Duckbills +1'
};

sets.Enhancing = {
    Ammo = 'Staunch Tathlum',
    Head = 'Ebers Cap +2',
    Neck = 'Clr. Torque +1',
    Ear1 = 'Roundel Earring',
    Ear2 = 'Orison Earring',
    Body = 'Piety Bliaut +1',
    Hands = 'Ebers Mitts +2',
    Ring1 = 'Sirona\'s Ring',
    Ring2 = 'Ephedra Ring',
    Back = 'Alaunus\'s Cape',
    Waist = 'Embla Sash',
    Legs = 'Piety Pantaloons',
    Feet = 'Theo. Duckbills +1'
};

sets.Regen = {
    Head = 'Inyanga Tiara',
    Hands = 'Ebers Mitts +2',
    Legs = 'Theo. Pant. +1',
    Waist = 'Embla Sash'
};

sets.Elemental = {
    Ammo = 'Kalboron Stone',
    Head = 'Nyame Helm',
    Neck = 'Sanctity Necklace',
    Ear1 = 'Friomisi Earring',
    Ear2 = 'Strophadic Earring',
    Body = 'Ebers Bliaut +2',
    Hands = 'Nyame Gauntlets',
    Ring1 = 'Sangoma Ring',
    Ring2 = 'Prolix Ring',
    Back = 'Alaunus\'s Cape',
    Waist = 'Aswang Sash',
    Legs = 'Ebers Pant. +2',
    Feet = 'Manabyss Pigaches',
};

sets.Default = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Staunch Tathlum',
    Head = 'Nyame Helm',
    Body = 'Nyame Mail',
    Hands = 'Nyame Gauntlets',
    Legs = 'Nyame Flanchard',
    Feet = 'Nyame Sollerets',
    Neck = 'Sanctity Necklace',
    Waist = 'Cetl Belt',
    Ear1 = 'Brutal Earring',
    Ear2 = 'Cessance Earring',
    Ring1 = 'Chirich Ring',
    Ring2 = 'Ephramad\'s Ring',
    Back = 'Alaunus\'s Cape'
};

sets.Acc = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Hasty Pinion +1',
    Head = 'Nyame Helm',
    Body = 'Ebers Bliaut +2',
    Hands = 'Ebers Mitts +2',
    Legs = 'Ebers Pant. +2',
    Feet = 'Nyame Sollerets',
    Neck = 'Sanctity Necklace',
    Waist = 'Famine Sash',
    Ear1 = 'Cessance Earring',
    Ear2 = 'Ebers Earring',
    Ring1 = 'Chirich Ring',
    Ring2 = 'Ephramad\'s Ring',
    Back = 'Alaunus\'s Cape'
};

sets.Hybrid = {};

sets.Movement = {
    Ring1 = 'Shneddick Ring',
};
sets.Ws_Default = {
    Ear1 = 'Moonshade Earring',
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt'
};
sets.Afflatus_Solace = {
    Body = 'Ebers Bliaut +2'
};

sets.Cursna = {
    Neck = 'Malison Medallion',
    Ring1 = 'Ephedra Ring',
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
    if (gcdisplay.GetCycle('Weapon') == 'Secondary') and (Setweapon ~= 'Magesmasher +1') then
        Setweapon = 'Magesmasher +1'
        if player.SubJob == 'NIN' or player.SubJob == 'DNC' then
            Setoffhand = 'Tamaxchi'
        else
            Setoffhand = 'Sors Shield'
        end
        for _, set in ipairs({'Weapons', 'Idle', 'Dt', 'Default', 'Acc'}) do
            sets[set].Main = Setweapon
            sets[set].Sub = Setoffhand
        end
        gFunc.EquipSet(sets.Weapons)
    elseif (gcdisplay.GetCycle('Weapon') == 'Primary') and (Setweapon ~= 'Queller Rod') then
        Setweapon = 'Queller Rod'
        if player.SubJob == 'NIN' or player.SubJob == 'DNC' then
            Setoffhand = 'Tamaxchi'
        else
            Setoffhand = 'Sors Shield'
        end
        for _, set in ipairs({'Weapons', 'Idle', 'Dt', 'Default', 'Acc'}) do
            sets[set].Main = Setweapon
            sets[set].Sub = Setoffhand
        end
        gFunc.EquipSet(sets.Weapons)
    end
end

profile.HandleDefault = function()
	local player = gData.GetPlayer();
    
    profile.UpdateSets();
    
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(gcdisplay.GetCycle('MeleeSet'))
		if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    else
		gFunc.EquipSet(sets.Idle);
    end
	
    gcinclude.CheckDefault();
    gcinclude.AutoEngage();
    if gcdisplay.GetToggle('Autoheal') == true then gcheals.CheckParty() end;
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end;
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
end

profile.HandleAbility = function()
    local action = gData.GetAction();

    if (action.Name == 'Afflatus Solace') then
        gFunc.EquipSet(sets.Afflatus_Solace);
    end

    gcinclude.CheckCancels();
end

profile.HandleItem = function()
    local item = gData.GetAction();

	if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(gcinclude.sets.Holy_Water) end
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();
    gFunc.EquipSet(sets.Precast);

    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    local weather = gData.GetEnvironment();
    local player = gData.GetPlayer();
    local spell = gData.GetAction();
    
    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing);
        if string.contains(spell.Name, 'Regen') then
            gFunc.EquipSet(sets.Regen);
        end
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Cure);
        if string.match(spell.Name, 'Cursna') then
            gFunc.EquipSet(sets.Cursna);
        end
    elseif (spell.Skill == 'Elemental Magic') then
        gFunc.EquipSet(sets.Elemental);
        if (spell.Element == weather.WeatherElement) or (spell.Element == weather.DayElement) then
            gFunc.Equip('Waist', 'Hachirin-no-Obi');
        end
    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Enfeebling_Magic);
    end

	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
end

profile.HandleWeaponskill = function()
    local canWS = gcinclude.CheckWsBailout();
    if (canWS == false) then gFunc.CancelAction() return;
    else gFunc.EquipSet(sets.Ws_Default) end
end

return profile; 