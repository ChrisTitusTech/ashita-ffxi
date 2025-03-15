local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.Initialize();
    

    -- Set macro book/set
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 3');
end

profile.OnUnload = function()
    gcinclude.Unload();
end

local sets = {
    ['Idle'] = {
        Main = 'Kaja Sword',
        Sub = { Name = 'Colada', Augment = { [1] = 'Accuracy+8', [2] = '"Dbl.Atk."+3', [3] = 'Attack+7', [4] = 'DMG:+16' } },
        Ammo = 'Staunch Tathlum',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Defiant Collar',
        Ear1 = { Name = 'Odnowa Earring +1', AugPath='A' },
        Ear2 = 'Moonshade Earring',
        Body = 'Ayanmo Corazza +2',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Vocane Ring',
        Ring2 = 'Rajas Ring',
        Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
        Waist = 'Flume Belt',
        Legs = 'Hashishin Tayt +2',
        Feet = 'Aya. Gambieras +2',
    },

    ['Resting'] = {},
    ['Movement'] = {},
    ['Precast'] = {
        Ammo = 'Sapience Orb',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Sanctity Necklace',
        Ear1 = 'Loquac. Earring',
        Ear2 = { Name = 'Moonshade Earring', Augment = { [1] = 'Latent effect: "Refresh"+1', [2] = '"Mag. Atk. Bns."+4' } },
        Body = 'Ayanmo Corazza +2',
        Hands = { Name = 'Telchine Gloves', Augment = '"Fast Cast"+4' },
        Ring1 = 'Sangoma Ring',
        Ring2 = 'Prolix Ring',
        Back = 'Swith Cape',
        Waist = 'Witful Belt',
        Legs = 'Aya. Cosciales +2',
        Feet = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+20', [2] = 'Attack+10', [3] = 'AGI+8', [4] = '"Triple Atk."+3' } },
    },
    ['Midcast'] = {},
    
    ['Dt'] = {
        Main = 'Kaja Sword',
        Sub = { Name = 'Colada', Augment = { [1] = 'Accuracy+8', [2] = '"Dbl.Atk."+3', [3] = 'Attack+7', [4] = 'DMG:+16' } },
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
        Legs = 'Hashishin Tayt +2',
        Feet = 'Aya. Gambieras +2',
    },

    ['Tp_Default'] = {
        Main = 'Kaja Sword',
        Sub = { Name = 'Colada', Augment = { [1] = 'Accuracy+8', [2] = '"Dbl.Atk."+3', [3] = 'Attack+7', [4] = 'DMG:+16' } },
        Ammo = 'Coiste Bodhar',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Sanctity Necklace',
        Ear1 = 'Suppanomimi',
        Ear2 = 'Cessance Earring',
        Body = 'Ayanmo Corazza +2',
        Hands = { Name = 'Herculean Gloves', Augment = { [1] = 'Accuracy+25', [2] = 'Attack+14', [3] = '"Triple Atk."+3' } },
        Ring1 = 'Chirich Ring',
        Ring2 = 'Rajas Ring',
        Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
        Waist = { Name = 'Sailfi Belt +1', AugPath='A' },
        Legs = { Name = 'Samnuha Tights', Augment = { [1] = 'STR+9', [2] = '"Dbl.Atk."+2', [3] = '"Triple Atk."+2', [4] = 'DEX+8' } },
        Feet = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+20', [2] = 'Attack+10', [3] = 'AGI+8', [4] = '"Triple Atk."+3' } },
    },

    ['Tp_Hybrid'] = {
        Main = 'Kaja Sword',
        Sub = { Name = 'Colada', Augment = { [1] = 'Accuracy+8', [2] = '"Dbl.Atk."+3', [3] = 'Attack+7', [4] = 'DMG:+16' } },
        Ammo = 'Coiste Bodhar',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Sanctity Necklace',
        Ear1 = 'Suppanomimi',
        Ear2 = 'Cessance Earring',
        Body = 'Ayanmo Corazza +2',
        Hands = { Name = 'Herculean Gloves', Augment = { [1] = 'Accuracy+25', [2] = 'Attack+14', [3] = '"Triple Atk."+3' } },
        Ring1 = 'Chirich Ring',
        Ring2 = 'Rajas Ring',
        Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
        Waist = { Name = 'Sailfi Belt +1', AugPath='A' },
        Legs = 'Hashishin Tayt +2',
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

    ['CDC'] = {
        Ammo = 'Coiste Bodhar',
        Head = { Name = 'Adhemar Bonnet', AugPath='A' },
        Neck = 'Fotia Gorget',
        Ear1 = 'Mache Earring',
        Ear2 = 'Mache Earring',
        Body = 'Ayanmo Corazza +2',
        Hands = { Name = 'Herculean Gloves', Augment = { [1] = 'Accuracy+25', [2] = 'Attack+14', [3] = '"Triple Atk."+3' } },
        Ring1 = 'Epona\'s Ring',
        Ring2 = 'Rajas Ring',
        Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
        Waist = 'Fotia Belt',
        Legs = { Name = 'Samnuha Tights', Augment = { [1] = 'STR+9', [2] = '"Dbl.Atk."+2', [3] = '"Triple Atk."+2', [4] = 'DEX+8' } },
        Feet = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+20', [2] = 'Attack+10', [3] = 'AGI+8', [4] = '"Triple Atk."+3' } },
    },
    --SB Priority STR > ATK/ACC > Weapon Skill DMG
    ['Savage_Blade'] = {
        Ammo = 'Coiste Bodhar',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Chivalrous Chain',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Cessance Earring',
        Body = 'Ayanmo Corazza +2',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Spiral Ring',
        Ring2 = 'Rajas Ring',
        Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
        Waist = { Name = 'Sailfi Belt +1', AugPath='A' },
        Legs = { Name = 'Samnuha Tights', Augment = { [1] = 'STR+9', [2] = '"Dbl.Atk."+2', [3] = '"Triple Atk."+2', [4] = 'DEX+8' } },
        Feet = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+20', [2] = 'Attack+10', [3] = 'AGI+8', [4] = '"Triple Atk."+3' } },
    },
    --Sanguine Blade Priority INT > Magic Atk and Magic Damage
    ['Sanguine_Blade'] = {
        Ammo = 'Coiste Bodhar',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Sanctity Necklace',
        Ear1 = 'Friomisi Earring',
        Ear2 = { Name = 'Moonshade Earring', Augment = { [1] = 'Latent effect: "Refresh"+1', [2] = '"Mag. Atk. Bns."+4' } },
        Body = 'Ayanmo Corazza +2',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Sangoma Ring',
        Ring2 = 'Spiral Ring',
        Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
        Waist = 'Fotia Belt',
        Legs = 'Hashishin Tayt +2',
        Feet = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+20', [2] = 'Attack+10', [3] = 'AGI+8', [4] = '"Triple Atk."+3' } },
    },

};

profile.Sets = sets;

profile.Packer = {

};   


profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
	local player = gData.GetPlayer();
    local target = gData.GetTarget();
    if (player.Status == 'Engaged') then
        if (player.TP >= 1000) and (player.HPP > 50) and (gcdisplay.GetToggle('Solomode') == true) then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Chant du Cygne" <t>');
        end
        if (player.HPP < 50) then
            gFunc.EquipSet(sets.Dt)
            if (player.TP >= 1000) and (gcdisplay.GetToggle('Solomode') == true) and (target.Name ~= 'Lady Lilith|Cacheaemic Ghost') then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Sanguine Blade" <t>');
            end
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

    if (action.Name == 'Azure Lore') then
        gFunc.EquipSet(sets.Azure_Lore);
    elseif (action.Name == 'Chain Affinity') then
        gFunc.EquipSet(sets.Chain_Affinity);
    elseif (action.Name == 'Burst Affinity') then
        gFunc.EquipSet(sets.Burst_Affinity);
    elseif (action.Name == 'Diffusion') then
        gFunc.EquipSet(sets.Diffusion);
    elseif (action.Name == 'Unbridled Learning') then
        gFunc.EquipSet(sets.Unbridled_Learning);
    elseif (action.Name == 'Efflux') then
        gFunc.EquipSet(sets.Efflux);
    elseif (action.Name == 'Convergence') then
        gFunc.EquipSet(sets.Convergence);
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
        if string.match(ws.Name, 'Chant du Cygne') then
            gFunc.EquipSet(sets.CDC)
        elseif string.match(ws.Name, 'Savage Blade') then
            gFunc.EquipSet(sets.Savage_Blade)
        elseif string.match(ws.Name, 'Sanguine Blade') then
            gFunc.EquipSet(sets.Sanguine_Blade)
        else
            gFunc.EquipSet(sets.Ws_Default)
        end
    end
end

return profile; 