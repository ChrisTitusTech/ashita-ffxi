local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');
gcmovement = gFunc.LoadFile('common\\gcmovement.lua');

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

local sets = {};
sets.Weapons = {
    Main = 'Naegling',
    Sub = { Name = 'Colada', Augment = { [1] = 'Accuracy+8', [2] = '"Dbl.Atk."+3', [3] = 'Attack+7', [4] = 'DMG:+16' } },
};

sets.Idle = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Staunch Tathlum',
    Head = 'Aya. Zucchetto +2',
    Neck = 'Mirage Stole',
    Ear1 = { Name = 'Odnowa Earring +1', AugPath='A' },
    Ear2 = 'Ethereal Earring',
    Body = 'Ayanmo Corazza +2',
    Hands = 'Aya. Manopolas +2',
    Ring1 = 'Shneddick Ring',
    Ring2 = 'Rajas Ring',
    Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
    Waist = 'Flume Belt',
    Legs = 'Hashishin Tayt +2',
    Feet = 'Aya. Gambieras +2',
};

sets.Refresh = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Staunch Tathlum',
    Head = 'Aya. Zucchetto +2',
    Neck = 'Mirage Stole',
    Body = 'Jhakri robe +1',
    Ear1 = { Name = 'Odnowa Earring +1', AugPath='A' },
    Ear2 = 'Ethereal Earring',
    Hands = 'Aya. Manopolas +2',
    Ring1 = 'Shneddick Ring',
    Ring2 = 'Rajas Ring',
    Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
    Waist = 'Flume Belt',
    Legs = 'Hashishin Tayt +2',
    Feet = 'Aya. Gambieras +2',
};

sets.Resting = {};

sets.Movement = {};

sets.Precast = {
    Ammo = 'Sapience Orb',
    Head = 'Aya. Zucchetto +2',
    Neck = 'Mirage Stole',
    Ear1 = 'Loquac. Earring',
    Body = 'Ayanmo Corazza +2',
    Hands = { Name = 'Telchine Gloves', Augment = '"Fast Cast"+4' },
    Ring1 = 'Sangoma Ring',
    Ring2 = 'Prolix Ring',
    Back = 'Swith Cape',
    Waist = 'Witful Belt',
    Legs = 'Aya. Cosciales +2',
    Feet = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+20', [2] = 'Attack+10', [3] = 'AGI+8', [4] = '"Triple Atk."+3' } },
};

sets.Midcast = {};

sets.DT = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Staunch Tathlum',
    Head = 'Aya. Zucchetto +2',
    Neck = 'Mirage Stole',
    Ear1 = { Name = 'Odnowa Earring +1', AugPath='A' },
    Ear2 = 'Cessance Earring',
    Body = 'Ayanmo Corazza +2',
    Hands = 'Aya. Manopolas +2',
    Ring1 = 'Shneddick Ring',
    Ring2 = 'Rajas Ring',
    Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
    Waist = 'Flume Belt',
    Legs = 'Hashishin Tayt +2',
    Feet = 'Aya. Gambieras +2',
};

sets.Default = {
    Ammo = 'Coiste Bodhar',
    Head = 'Aya. Zucchetto +2',
    Neck = 'Mirage Stole',
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
};

sets.Hybrid = {
    Ammo = 'Coiste Bodhar',
    Head = 'Aya. Zucchetto +2',
    Neck = 'Mirage Stole',
    Ear1 = { Name = 'Odnowa Earring +1', AugPath='A' },
    Ear2 = 'Cessance Earring',
    Body = 'Ayanmo Corazza +2',
    Hands = { Name = 'Herculean Gloves', Augment = { [1] = 'Accuracy+25', [2] = 'Attack+14', [3] = '"Triple Atk."+3' } },
    Ring1 = 'Chirich Ring',
    Ring2 = 'Shneddick Ring',
    Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
    Waist = { Name = 'Sailfi Belt +1', AugPath='A' },
    Legs = 'Hashishin Tayt +2',
    Feet = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+20', [2] = 'Attack+10', [3] = 'AGI+8', [4] = '"Triple Atk."+3' } },
};

sets.Acc = {};

sets.Ws_Default = {
    Head = 'Hashishin Kavuk +2',
    Neck = 'Fotia Gorget',
    Ear1 = 'Moonshade Earring',
    Waist = 'Fotia Belt',
};

sets.Magic = {
    Ammo = 'Staunch Tathlum',
    Head = 'Hashishin Kavuk +2',
    Neck = 'Stoicheion Medal',
    Ear1 = 'Friomisi Earring',
    Ear2 = 'Strophadic Earring',
    Body = 'Jhakri robe +1',
    Hands = 'Jhakri Cuffs +1',
    Ring1 = 'Sangoma Ring',
    Ring2 = 'Spiral Ring',
    Back = { Name = 'Cornflower Cape', Augment = { [1] = 'Accuracy+2', [2] = 'Blue Magic skill +9', [3] = 'MP+16', [4] = 'DEX+2' } },
    Waist = 'Aswang Sash',
    Legs = 'Hashishin Tayt +2',
    Feet = 'Jhakri Pigaches +1',
};

sets.Chain_Affinity = {};

sets.Burst_Affinity = {};

sets.Diffusion = {};

sets.Efflux = {
    Legs = 'Hashishin Tayt +2',
};

sets.TH = {
    Ammo = 'Per. Lucky Egg',
};

sets.CDC = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Coiste Bodhar',
    Head = 'Hashishin Kavuk +2',
    Neck = 'Fotia Gorget',
    Ear1 = 'Moonshade Earring',
    Ear2 = 'Mache Earring',
    Body = 'Ayanmo Corazza +2',
    Hands = { Name = 'Herculean Gloves', Augment = { [1] = 'Accuracy+25', [2] = 'Attack+14', [3] = '"Triple Atk."+3' } },
    Ring1 = 'Epona\'s Ring',
    Ring2 = 'Rajas Ring',
    Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
    Waist = 'Fotia Belt',
    Legs = { Name = 'Samnuha Tights', Augment = { [1] = 'STR+9', [2] = '"Dbl.Atk."+2', [3] = '"Triple Atk."+2', [4] = 'DEX+8' } },
    Feet = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+20', [2] = 'Attack+10', [3] = 'AGI+8', [4] = '"Triple Atk."+3' } },
};

sets.Savage_Blade = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Coiste Bodhar',
    Head = 'Hashishin Kavuk +2',
    Neck = 'Mirage Stole',
    Ear1 = 'Moonshade Earring',
    Ear2 = 'Cessance Earring',
    Body = 'Ayanmo Corazza +2',
    Hands = 'Aya. Manopolas +2',
    Ring1 = 'Spiral Ring',
    Ring2 = 'Rajas Ring',
    Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
    Waist = { Name = 'Sailfi Belt +1', AugPath='A' },
    Legs = { Name = 'Samnuha Tights', Augment = { [1] = 'STR+9', [2] = '"Dbl.Atk."+2', [3] = '"Triple Atk."+2', [4] = 'DEX+8' } },
    Feet = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+20', [2] = 'Attack+10', [3] = 'AGI+8', [4] = '"Triple Atk."+3' } },
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
    if (player.Status == 'Engaged') and target then
        if (player.TP >= 1000) and (player.HPP > 50) and (gcdisplay.GetToggle('Solo') == true) and (gcinclude.CheckWsBailout() == true) then
            local mainWeapon = gData.GetEquipment().Main;
            if mainWeapon then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Chant du Cygne" <t>');
            elseif mainWeapon.Name == 'Naegling' then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Savage Blade" <t>');
            end
        end
        if (player.HPP < 50) then
            gFunc.EquipSet(sets.DT)
            if (player.TP >= 1000) and (gcdisplay.GetToggle('Solo') == true) and (target.Name ~= 'Lady Lilith') and (gcinclude.CheckWsBailout() == true) then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Sanguine Blade" <t>');
            end
        else
            gFunc.EquipSet(gcdisplay.GetCycle('MeleeSet'))
        end
		if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    elseif (player.MPP < 90) then 
        gFunc.EquipSet(sets.Refresh)
    else
		gFunc.EquipSet(sets.Idle);
    end
	
    gcinclude.CheckDefault();
    gcinclude.AutoEngage();
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
    if (gcinclude.CheckSpellBailout == false) then gFunc.CancelAction() return;
    else
        gFunc.EquipSet(sets.Precast);
    end

    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
	local spell = gData.GetAction();

    gFunc.EquipSet(sets.Midcast);
    if (gcinclude.BstPetMagicAttack ~= nil) and gcinclude.BstPetMagicAttack:contains(spell.Name) then
        gFunc.EquipSet(sets.Magic);
    end
    if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end

end

profile.HandleWeaponskill = function()
    if (gcinclude.CheckWsBailout() == false) then gFunc.CancelAction() return;
    else
        local ws = gData.GetAction();        
        if string.match(ws.Name, 'Chant du Cygne') then
            gFunc.EquipSet(sets.CDC)
        elseif string.match(ws.Name, 'Savage Blade') then
            gFunc.EquipSet(sets.Savage_Blade)
        elseif string.match(ws.Name, 'Sanguine Blade') then
            gFunc.EquipSet(sets.Magic)
        else
            gFunc.EquipSet(sets.Ws_Default)
        end
    end
end

return profile; 