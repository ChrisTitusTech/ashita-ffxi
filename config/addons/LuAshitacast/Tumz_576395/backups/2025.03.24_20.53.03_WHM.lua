local profile = {};

gcinclude = gFunc.LoadFile('common\\gcinclude.lua');
gcheals = gFunc.LoadFile('common\\gcheals.lua');

-- Add a variable to store main weapon
setweapon = 'Queller Rod';
setoffhand = 'Sors Shield';
local sets = {};

sets.Weapons = {
    Main = setweapon,
    Sub = setoffhand
};

sets.Idle = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Homiliary',
    Head = 'Aya. Zucchetto +2',
    Neck = 'Clr. Torque +1',
    Ear1 = 'Moonshade Earring',
    Ear2 = 'Ethereal Earring',
    Body = 'Ebers Bliaut +2',
    Hands = 'Ebers Mitts +2',
    Ring1 = 'Vocane Ring',
    Ring2 = 'Prolix Ring',
    Back = 'Alaunus\'s Cape',
    Waist = 'Cetl Belt',
    Legs = 'Ebers Pant. +2',
    Feet = 'Aya. Gambieras +2'
};

sets.Dt = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Hasty Pinion +1',
    Head = 'Aya. Zucchetto +2',
    Body = 'Ayanmo Corazza +2',
    Hands = 'Aya. Manopolas +2',
    Legs = 'Aya. Cosciales +2',
    Feet = 'Aya. Gambieras +2',
    Neck = 'Asperity Necklace',
    Waist = 'Cetl Belt',
    Ear1 = 'Brutal Earring',
    Ear2 = 'Cessance Earring',
    Ring1 = 'Vocane Ring',
    Ring2 = 'Rajas Ring',
    Back = 'Alaunus\'s Cape'
};

sets.Resting = {};

sets.Precast = {
    Ammo = 'Incantor Stone',
    Head = 'Aya. Zucchetto +2', -- Need Fastcast
    Neck = { Name = 'Clr. Torque +1', AugPath='A' },
    Ear1 = 'Loquac. Earring',
    Ear2 = 'Malignance Earring',
    Body = 'Inyanga Jubbah +1',
    Hands = 'Gende. Gages +1',
    Ring1 = 'Prolix Ring',
    Ring2 = 'Naji\'s Loop',
    Back = 'Swith Cape',
    Waist = 'Witful Belt',
    Legs = 'Aya. Cosciales +2',
    Feet = 'Theo. Duckbills +1', --Need FastCast
};

sets.Cure = {
    Ammo = 'Staunch Tathlum',
    Head = 'Ebers Cap +1',
    Neck = 'Clr. Torque +1',
    Ear1 = 'Roundel Earring',
    Ear2 = 'Ebers Earring',
    Body = 'Ebers Bliaut +2',
    Hands = 'Telchine Gloves',
    Ring1 = 'Sirona\'s Ring',
    Ring2 = 'Ephedra Ring',
    Back = 'Alaunus\'s Cape',
    Waist = 'Witful Belt',
    Legs = 'Ebers Pant. +2',
    Feet = 'Theo. Duckbills +1'
};

sets.Enhancing = {
    Ammo = 'Staunch Tathlum',
    Head = 'Ebers Cap +1',
    Neck = 'Clr. Torque +1',
    Ear1 = 'Roundel Earring',
    Ear2 = 'Orison Earring',
    Body = 'Piety Bliaut +1',
    Hands = 'Ebers Mitts +2',
    Ring1 = 'Sirona\'s Ring',
    Ring2 = 'Ephedra Ring',
    Back = 'Alaunus\'s Cape',
    Waist = 'Witful Belt',
    Legs = 'Piety Pantaloons',
    Feet = 'Theo. Duckbills +1'
};

sets.Regen = {
    Legs = 'Theo. Pant.+1'
};

sets.Elemental = {
    Ammo = 'Kalboron Stone',
    Head = 'Aya. Zucchetto +2',
    Neck = 'Sanctity Necklace',
    Ear1 = 'Friomisi Earring',
    Ear2 = 'Strophadic Earring',
    Body = 'Ebers Bliaut +2',
    Hands = { Name = 'Fanatic Gloves', Augment = { [1] = '"Conserve MP"+4', [2] = 'MP+30', [3] = 'Healing magic skill +5' } },
    Ring1 = 'Sangoma Ring',
    Ring2 = 'Prolix Ring',
    Back = { Name = 'Alaunus\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = 'Evasion+20', [3] = 'Mag. Evasion+20', [4] = 'MND+20', [5] = 'Enmity-10' } },
    Waist = 'Aswang Sash',
    Legs = 'Ebers Pant. +2',
    Feet = 'Manabyss Pigaches',
};

sets.Default = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Vanir Battery',
    Head = 'Aya. Zucchetto +2',
    Body = 'Ayanmo Corazza +2',
    Hands = 'Aya. Manopolas +2',
    Legs = 'Aya. Cosciales +2',
    Feet = 'Aya. Gambieras +2',
    Neck = 'Sanctity Necklace',
    Waist = 'Cetl Belt',
    Ear1 = 'Brutal Earring',
    Ear2 = 'Cessance Earring',
    Ring1 = 'Chirich Ring',
    Ring2 = 'Rajas Ring',
    Back = 'Alaunus\'s Cape'
};

sets.Acc = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Hasty Pinion +1',
    Head = 'Aya. Zucchetto +2',
    Body = 'Ayanmo Corazza +2',
    Hands = 'Aya. Manopolas +2',
    Legs = 'Aya. Cosciales +2',
    Feet = 'Aya. Gambieras +2',
    Neck = 'Sanctity Necklace',
    Waist = 'Cetl Belt',
    Ear1 = 'Brutal Earring',
    Ear2 = 'Cessance Earring',
    Ring1 = 'Chirich Ring',
    Ring2 = 'Rajas Ring',
    Back = 'Alaunus\'s Cape'
};

sets.Hybrid = {};

sets.Movement = {};
sets.Ws_Default = {
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt'
};
sets.Afflatus_Solace = {
    Body = 'Ebers Bliaut +2'
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

profile.HandleDefault = function()
	local player = gData.GetPlayer();
    
    if (gcdisplay.GetCycle('Weapon') == 'Secondary') and (setweapon ~= 'Magesmasher +1') then
        setweapon = 'Magesmasher +1'
        sets.Weapons.Main = setweapon
        -- Update all sets that reference the weapon
        sets.Idle.Main = setweapon
        sets.Dt.Main = setweapon
        sets.Default.Main = setweapon
        if player.SubJob == 'NIN' or player.SubJob == 'DNC' then
            setoffhand = 'Tamaxchi'
        else
            setoffhand = 'Sors Shield'
        end
            sets.Weapons.Sub = setoffhand
            sets.Idle.Sub = setoffhand
            sets.Dt.Sub = setoffhand
            sets.Default.Sub = setoffhand
        -- Force equipment update
        gFunc.EquipSet(sets.Weapons)
    elseif (gcdisplay.GetCycle('Weapon') == 'Primary') and (setweapon ~= 'Queller Rod') then
        setweapon = 'Queller Rod'
        sets.Weapons.Main = setweapon
        -- Update all sets that reference the weapon
        sets.Idle.Main = setweapon
        sets.Dt.Main = setweapon
        sets.Default.Main = setweapon
        if player.SubJob == 'NIN' or player.SubJob == 'DNC' then
            setoffhand = 'Tamaxchi'
        else
            setoffhand = 'Sors Shield'
        end
            sets.Weapons.Sub = setoffhand
            sets.Idle.Sub = setoffhand
            sets.Dt.Sub = setoffhand
            sets.Default.Sub = setoffhand
        -- Force equipment update
        gFunc.EquipSet(sets.Weapons)
    end
    
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.Default);
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
    local target = gData.GetActionTarget();
    local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);

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
        gFunc.EquipSet(sets.Enfeebling);
    end

	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
end

profile.HandleWeaponskill = function()
    local canWS = gcinclude.CheckWsBailout();
    if (canWS == false) then gFunc.CancelAction() return;
    else gFunc.EquipSet(sets.Ws_Default) end
end

return profile; 