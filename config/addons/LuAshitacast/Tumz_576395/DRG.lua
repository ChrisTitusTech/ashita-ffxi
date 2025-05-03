local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.Initialize();

    -- Set macro book/set
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 2');
end

profile.OnUnload = function()
    gcinclude.Unload();
end

local sets = {
    ['Idle'] = {
        Main = 'Gae Derg +1',
        Sub = 'Eletta Grip',
        Ammo = 'Staunch Tathlum',
        Head = 'Sulevia\'s Mask +2',
        Body = 'Sulevia\'s Plate. +2',
        Hands = 'Sulev. Gauntlets +2',
        Legs = 'Sulev. Cuisses +2',
        Ring1 = 'Shneddick Ring',
        Ring2 = 'Moonbeam Ring',
        Neck = 'Dgn. Collar +1',
        Ear1 = 'Odnowa Earring +1',
        Ear2 = 'Cessance Earring',
        Back = 'Brigantia\'s Mantle',
        Waist = 'Flume Belt',
        Feet = 'Sulev. Leggings +2'
    },

    ['Resting'] = {},
    ['Movement'] = {},
    ['Precast'] = {},
    ['Midcast'] = {},
    
    ['Dt'] = {
        Main = 'Gae Derg +1',
        Sub = 'Eletta Grip',
        Ammo = 'Staunch Tathlum',
        Head = 'Sulevia\'s Mask +2',
        Body = 'Sulevia\'s Plate. +2',
        Hands = 'Sulev. Gauntlets +2',
        Legs = 'Sulev. Cuisses +2',
        Ring1 = 'Shneddick Ring',
        Ring2 = 'Moonbeam Ring',
        Neck = 'Dgn. Collar +1',
        Ear1 = 'Odnowa Earring +1',
        Ear2 = 'Cessance Earring',
        Back = 'Brigantia\'s Mantle',
        Waist = 'Flume Belt',
        Feet = 'Sulev. Leggings +2'
    },

    ['Default'] = {
        Main = 'Gae Derg +1',
        Sub = 'Eletta Grip',
        Ammo = 'Coiste Bodhar',
        Head = 'Flam. Zucchetto +2',
        Neck = 'Dgn. Collar +1',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Cessance Earring',
        Body = 'Flamma Korazin +2',
        Hands = 'Heyoka Mittens',
        Ring1 = 'Chirich Ring',
        Ring2 = 'Epona\'s Ring',
        Back = 'Brigantia\'s Mantle',
        Waist = 'Sailfi Belt +1',
        Legs = 'Sulev. Cuisses +2',
        Feet = 'Flamma Leggings +2'
    },

    ['Ws_Default'] = {
        Ammo = 'Coiste Bodhar',
        Head = 'Flam. Zucchetto +2',
        Neck = 'Fotia Gorget',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Moonshade Earring',
        Body = 'Flamma Korazin +2',
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = 'Ephramad\'s Ring',
        Ring2 = 'Epona\'s Ring',
        Back = 'Brigantia\'s Mantle',
        Waist = 'Fotia Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = 'Sulev. Leggings +2'
    },

    ['Jumps_Default'] = {       
        Head = 'Vishap Armet',
        Neck = 'Dgn. Collar +1',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Cessance Earring',
        Ring1 = 'Ephramad\'s Ring',
        Ring2 = 'Epona\'s Ring',
        Back = 'Brigantia\'s Mantle',
        Waist = 'Windbuffet Belt',
        Legs = 'Vishap Brais',
        Feet = 'Vishap Greaves'
    },

    ['Spirit_Surge'] = {
        -- Can add Pteroslaver Mail +3 when available
    },
    
    ['Call_Wyvern'] = {
        -- Can add Pteroslaver Mail +3 when available
    },
    
    ['Ancient_Circle'] = {
        -- Can add enhanced Vishap Brais when available
    },
    
    ['Spirit_Link'] = {
        Head = 'Vishap Armet',
        -- Add Pelago Vambraces and Pteroslaver Greaves when available
    },
    
    ['Steady_Wing'] = {
        Back = 'Updraft Mantle',
        -- Add enhanced Vishap Brais when available
    },

    ['TH'] = {
        Ammo = 'Per. Lucky Egg',
    },

    ['Angon'] = {
        Ammo = 'Angon',
    },
};

profile.Sets = sets;

profile.Packer = {
    'Gae Derg +1',
    'Angon',
    'Vishap Armet',
    'Dgn. Collar +1',
    'Brutal Earring',
    'Cessance Earring',
    'Heyoka Harness',
    'Heyoka Mittens',
    'Ephramad\'s Ring',
    'Epona\'s Ring',
    'Brigantia\'s Mantle',
    'Windbuffet Belt',
    'Vishap Brais',
    'Vishap Greaves',
    'Moonshade Earring',
    'Fotia Belt',
    'Fotia Gorget',
    'Defending Ring',
    'Moonbeam Ring',
    'Flume Belt'
};   


profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
	local player = gData.GetPlayer();
    if (player.Status == 'Engaged') then
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

    if (string.contains(action.Name, 'Jump')) then
        gFunc.EquipSet(sets.Jumps_Default);
    elseif (action.Name == 'Spirit Surge') then
        gFunc.EquipSet(sets.Spirit_Surge);
    elseif (action.Name == 'Call Wyvern') then
        gFunc.EquipSet(sets.Call_Wyvern);
    elseif (action.Name == 'Ancient Circle') then
        gFunc.EquipSet(sets.Ancient_Circle);
    elseif (action.Name == 'Spirit Link') then
        gFunc.EquipSet(sets.Spirit_Link);
    elseif (action.Name == 'Steady Wing') then
        gFunc.EquipSet(sets.Steady_Wing);   
    elseif (action.Name == 'Angon') then
        gFunc.EquipSet(sets.Angon);
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