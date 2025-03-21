local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

local sets = {};
sets.Weapons = {};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.Initialize();

    -- Set up aliases for commands
    AshitaCore:GetChatManager():QueueCommand(1, '/alias /stat /lac fwd status');
    
    -- Check subjob and adjust weapons accordingly
    local player = gData.GetPlayer();
    
    if player.SubJob == 'NIN' or player.SubJob == 'DNC' then
        sets.Weapons.Main = 'Kaja Sword';
        sets.Weapons.Sub = 'Malignance Sword';
        print(chat.header('RUN'):append(chat.message('Dual Wield detected - using swords')));
    else
        sets.Weapons.Main = 'Epeolatry';
        sets.Weapons.Sub = 'Refined Grip +1';
    end
    print(chat.header('RUN'):append(chat.message('Main Weapon: ' .. sets.Weapons.Main)));
    print(chat.header('RUN'):append(chat.message('Sub Weapon: ' .. sets.Weapons.Sub)));
    -- Set macro book/set
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 8');
end

profile.OnUnload = function()
    gcinclude.Unload();
end

sets.Idle = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Staunch Tathlum',
    Head = 'Erilaz Galea +2',
    Body = 'Ayanmo Corazza +2',
    Hands = 'Turms Mittens',
    Waist = 'Flume Belt',
    Ear1 = 'Odnowa Earring +1',
    Ear2 = 'Ethereal Earring',
    Ring1 = 'Vocane Ring',
    Ring2 = 'Moonbeam Ring',
};

sets.Movement = {};

sets.Resting = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Staunch Tathlum',
    Head = 'Erilaz Galea +2',
    Body = 'Ayanmo Corazza +2',
    Hands = 'Turms Mittens',
    Waist = 'Flume Belt',
    Ear1 = 'Odnowa Earring +1',
    Ear2 = 'Ethereal Earring',
    Ring1 = 'Moonbeam Ring',
    Ring2 = 'Moonbeam Ring',
};

sets.Precast = {
    Ammo = 'Sapience orb',
    Head = 'Rune. Bandeau +1',
    Ear1 = 'Loquac. Earring',
    Ring1 = 'Prolix Ring',
    Legs = 'Aya. Cosciales +2',
};

sets.Midcast = {
    Head = 'Erilaz Galea +2',
    Body = 'Runeist Coat +2',
    Hands = 'Runeist Mitons',
    Legs = 'Futhark Trousers',
    Waist = 'Siegel Sash',
};

sets.Dt = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Staunch Tathlum',
    Neck = 'Futhark Torque',
    Head = 'Aya. Zucchetto +2',
    Body = 'Ayanmo Corazza +2',
    Hands = 'Turms Mittens',
    Legs = 'Eri. Leg Guards +2',
    Feet = 'Turms Leggings',
    Waist = 'Flume Belt',
    Ear1 = 'Odnowa Earring +1',
    Ear2 = 'Ethereal Earring',
    Ring1 = 'Vocane Ring',
    Ring2 = 'Moonbeam Ring',
};

sets.Tp_Default = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Coiste Bodhar',
    Head = 'Adhemar Bonnet',
    Body = 'Ayanmo Corazza +2',
    Hands = 'Herculean Gloves',
    Legs = 'Samnuha Tights',
    Feet = 'Herculean Boots',
    Neck = 'Defiant Collar',
    Waist = 'Sailfi Belt +1',
    Ear1 = 'Brutal Earring',
    Ear2 = 'Cessance Earring',
    Ring1 = 'Epona\'s Ring',
    Ring2 = 'Chirich Ring',
    Back = 'Ogma\'s Cape',
};

sets.Ws_Default = {
    Ammo = 'Hasty Pinion +1',
    Body = 'Ayanmo Corazza +2',
    Hands = 'Herculean Gloves',
    Legs = 'Samnuha Tights',
    Feet = 'Herculean Boots',
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
    Ear1 = 'Brutal Earring',
    Ear2 = 'Cessance Earring',
    Ring2 = 'Chirich Ring',
    Back = 'Ogma\'s Cape',
};

sets.TH = {
    Ammo = 'Per. Lucky Egg',
};

sets.Valiance = {};

sets.Vivacious_Pulse = {
    Head = 'Erilaz Galea +2',
};

sets.Pflug = {
    Feet = 'Runeist Bottes',
};

profile.Sets = sets;

profile.Packer = {};

profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
	local player = gData.GetPlayer();
    local target = gData.GetTarget();
    if (player.Status == 'Engaged') then
        if (player.TP > 1000) and (gcdisplay.GetToggle('Solomode') == true) and sets.Weapons.Main == 'Epeolary' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Dimidiation" <t>');
        elseif (player.TP > 1000) and (player.HPP > 50) and (gcdisplay.GetToggle('Solomode') == true) and sets.Weapons.Main == 'Kaja Sword' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Savage Blade" <t>');
        elseif (player.TP > 1000) and (player.HPP <= 50) and (gcdisplay.GetToggle('Solomode') == true) and sets.Weapons.Main == 'Kaja Sword' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Sanguine Blade" <t>');
            
        end
        if (player.HPP < 50) then
            gFunc.EquipSet(sets.Dt)
        else
            gFunc.EquipSet(sets.Tp_Default)
        end
		if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    elseif (player.IsMoving == true) then
		gFunc.EquipSet(sets.Idle);
    end
	
    gcinclude.CheckDefault ();
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end;
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
    
end

profile.HandleAbility = function()
    local action = gData.GetAction();

    if (action.Name == 'Valiance') then
        gFunc.EquipSet(sets.Valiance);
    elseif (action.Name == 'Vivacious Pulse') then
        gFunc.EquipSet(sets.Vivacious_Pulse);
    elseif (action.Name == 'Pflug') then
        gFunc.EquipSet(sets.Pflug);
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
	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
end

profile.HandleWeaponskill = function()
    local canWS = gcinclude.CheckWsBailout();
    if (canWS == false) then gFunc.CancelAction() return;
    else
        local ws = gData.GetAction();
    
        gFunc.EquipSet(sets.Ws_Default)
        
        if string.match(ws.Name, 'Aeolian Edge') then
            gFunc.EquipSet(sets.Aedge_Default)
        end
    end
end

return profile; 