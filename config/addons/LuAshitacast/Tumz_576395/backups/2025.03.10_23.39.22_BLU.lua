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
        Main = { Name = 'Colada', Augment = { [1] = 'Accuracy+8', [2] = '"Dbl.Atk."+3', [3] = 'Attack+7', [4] = 'DMG:+16' } },
        Sub = 'Kaja Sword',
        Ammo = 'Staunch Tathlum',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Defiant Collar',
        Ear1 = { Name = 'Odnowa Earring +1', AugPath='A' },
        Ear2 = 'Cessance Earring',
        Body = 'Ayanmo Corazza +2',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Vocane Ring',
        Ring2 = 'Rajas Ring',
        Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
        Waist = 'Flume Belt',
        Legs = 'Aya. Cosciales +2',
        Feet = 'Aya. Gambieras +2',
    },

    ['Resting'] = {},
    ['Movement'] = {},
    ['Precast'] = {},
    ['Midcast'] = {},
    
    ['Dt'] = {
        Main = { Name = 'Colada', Augment = { [1] = 'Accuracy+8', [2] = '"Dbl.Atk."+3', [3] = 'Attack+7', [4] = 'DMG:+16' } },
        Sub = 'Kaja Sword',
        Ammo = 'Staunch Tathlum',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Defiant Collar',
        Ear1 = { Name = 'Odnowa Earring +1', AugPath='A' },
        Ear2 = 'Cessance Earring',
        Body = 'Ayanmo Corazza +2',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Vocane Ring',
        Ring2 = 'Rajas Ring',
        Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
        Waist = 'Flume Belt',
        Legs = 'Aya. Cosciales +2',
        Feet = 'Aya. Gambieras +2',
    },

    ['Tp_Default'] = {
        Main = { Name = 'Colada', Augment = { [1] = 'Accuracy+8', [2] = '"Dbl.Atk."+3', [3] = 'Attack+7', [4] = 'DMG:+16' } },
        Sub = 'Kaja Sword',
        Ammo = 'Coiste Bodhar',
        Head = { Name = 'Adhemar Bonnet', AugPath='A' },
        Neck = 'Defiant Collar',
        Ear1 = 'Suppanomimi',
        Ear2 = 'Cessance Earring',
        Body = 'Ayanmo Corazza +2',
        Hands = { Name = 'Herculean Gloves', Augment = { [1] = 'Accuracy+25', [2] = 'Attack+14', [3] = '"Triple Atk."+3' } },
        Ring1 = 'Chirich Ring',
        Ring2 = 'Epona\'s Ring',
        Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
        Waist = { Name = 'Sailfi Belt +1', AugPath='A' },
        Legs = 'Aya. Cosciales +2',
        Feet = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+20', [2] = 'Attack+10', [3] = 'AGI+8', [4] = '"Triple Atk."+3' } },
    },

    ['Ws_Default'] = {
        Neck = 'Fotia Gorget',
        Waist = 'Fotia Belt',
    },

    ['Magic'] = {       
        Head = 'Vishap Armet',
        Neck = 'Dgn. Collar +1',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Cessance Earring',
        Ring1 = 'Rajas Ring',
        Ring2 = 'Epona\'s Ring',
        Back = 'Brigantia\'s Mantle',
        Waist = 'Windbuffet Belt',
        Legs = 'Vishap Brais',
        Feet = 'Vishap Greaves'
    },

    ['Chain_Affinity'] = {
        
    },
    
    ['Burst_Affinity'] = {
        
    },
    
    ['Diffusion'] = {
        
    },
    
    ['Efflux'] = {
        
    },

    ['TH'] = {
        Ammo = 'Per. Lucky Egg',
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
    'Rajas Ring',
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