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
    Sub = 'Blurred Sword +1',
};

sets.Idle = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Staunch Tathlum',
    Head = 'Nyame Helm',
    Neck = 'Mirage Stole',
    Ear1 = { Name = 'Odnowa Earring +1', AugPath = 'A' },
    Ear2 = 'Ethereal Earring',
    Body = 'Nyame Mail',
    Hands = 'Nyame Gauntlets',
    Ring1 = 'Shneddick Ring',
    Ring2 = 'Chirich Ring',
    Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
    Waist = 'Plat. Mog. Belt',
    Legs = 'Hashishin Tayt +2',
    Feet = 'Nyame Sollerets',
};

sets.Refreshadd = {
    Neck = 'Sibyl Scarf',
    Body = 'Jhakri robe +2',
};
sets.Refresh = gFunc.Combine(sets.Idle, sets.Refreshadd);

sets.Resting = {};

gcinclude.sets.Movement = {
    Ring1 = 'Shneddick Ring',
};

sets.Precast = {
    Ammo = 'Sapience Orb',
    Ear1 = 'Loquac. Earring',
    Ring1 = 'Naji\'s Loop',
    Ring2 = 'Prolix Ring',
    Back = 'Swith Cape',
    Waist = 'Witful Belt',
    Legs = 'Aya. Cosciales +2',
};

sets.Midcast = {};

sets.DT = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Staunch Tathlum',
    Head = 'Nyame Helm',
    Neck = 'Elite Royal Collar',
    Ear1 = { Name = 'Odnowa Earring +1', AugPath = 'A' },
    Ear2 = 'Cessance Earring',
    Body = 'Nyame Mail',
    Hands = 'Nyame Gauntlets',
    Ring1 = 'Shneddick Ring',
    Ring2 = 'Chirich Ring',
    Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
    Waist = 'Plat. Mog. Belt',
    Legs = 'Hashishin Tayt +2',
    Feet = 'Nyame Sollerets',
};

sets.Default = {
    Ammo = 'Coiste Bodhar',
    Neck = 'Mirage Stole',
    Ear1 = 'Suppanomimi',
    Ear2 = 'Cessance Earring',
    Head = 'Nyame Helm',
    Body = 'Adhemar Jacket +1',
    Hands = { Name = 'Herculean Gloves', Augment = { [1] = 'Accuracy+25', [2] = 'Attack+14', [3] = '"Triple Atk."+3' } },
    Legs = { Name = 'Samnuha Tights', Augment = { [1] = 'STR+9', [2] = '"Dbl.Atk."+2', [3] = '"Triple Atk."+2', [4] = 'DEX+8' } },
    Feet = 'Herculean Boots',
    Ring1 = 'Chirich Ring',
    Ring2 = 'Chirich Ring',
    Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
    Waist = { Name = 'Sailfi Belt +1', AugPath = 'A' },
};

sets.Hybrid = {
    Ammo = 'Coiste Bodhar',
    Head = 'Nyame Helm',
    Neck = 'Mirage Stole',
    Ear1 = { Name = 'Odnowa Earring +1', AugPath = 'A' },
    Ear2 = 'Telos Earring',
    Body = 'Adhemar Jacket +1',
    Hands = { Name = 'Herculean Gloves', Augment = { [1] = 'Accuracy+25', [2] = 'Attack+14', [3] = '"Triple Atk."+3' } },
    Ring1 = 'Chirich Ring',
    Ring2 = 'Chirich Ring',
    Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = '"Dbl.Atk."+10', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = 'DEX+26' } },
    Waist = { Name = 'Sailfi Belt +1', AugPath = 'A' },
    Legs = 'Hashishin Tayt +2',
    Feet = 'Herculean Boots',
};

sets.Acc = {};

sets.Ws_Default = {
    Ammo = 'Oshasha\'s Treatise',
    Head = 'Hashishin Kavuk +2',
    Neck = 'Fotia Gorget',
    Ear1 = 'Moonshade Earring',
    Ring1 = 'Cornelia\'s Ring',
    Waist = 'Fotia Belt',
    Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'STR+30', [2] = 'Weapon skill damage +10%', [3] = 'Attack+20', [4] = 'Accuracy+20' } },
};

sets.Magic = {
    Ammo = 'Staunch Tathlum',
    Head = 'Hashishin Kavuk +2',
    Neck = 'Stoicheion Medal',
    Ear1 = 'Friomisi Earring',
    Ear2 = 'Halasz Earring',
    Body = 'Jhakri robe +2',
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
    Ammo = 'Oshasha\'s Treatise',
    Ear1 = 'Moonshade Earring',
    Ear2 = 'Cessance Earring',
    Ring1 = 'Cornelia\'s Ring',
    Ring2 = 'Chirich Ring',
    Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'STR+30', [2] = 'Weapon skill damage +10%', [3] = 'Attack+20', [4] = 'Accuracy+20' } },
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
    Head = 'Hashishin Kavuk +2',
    Body = 'Nyame Mail',
    Hands = 'Nyame Gauntlets',
    Legs = 'Nyame Flanchard',
    Feet = 'Nyame Sollerets',
};

sets.Savage_Blade = {
    Ammo = 'Oshasha\'s Treatise',
    Head = 'Hashishin Kavuk +2',
    Ear1 = 'Moonshade Earring',
    Ear2 = 'Cessance Earring',
    Body = 'Nyame Mail',
    Hands = 'Nyame Gauntlets',
    Legs = 'Nyame Flanchard',
    Feet = 'Nyame Sollerets',
    Ring1 = 'Cornelia\'s Ring',
    Ring2 = 'Chirich Ring',
    Back = { Name = 'Rosmerta\'s Cape', Augment = { [1] = 'STR+30', [2] = 'Weapon skill damage +10%', [3] = 'Attack+20', [4] = 'Accuracy+20' } },
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
};

profile.Sets = sets;

profile.Packer = {

};


profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.SoloMode = function()
    local player = gData.GetPlayer();
    if gcinclude.CheckWsBailout() == true and player.HPP > 35 and player.TP > 1000 then
        if gcdisplay.GetCycle('Weapon') == 'Primary' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Chant du Cygne" <t>');
        elseif (player.TP >= 1800) and gcdisplay.GetCycle('Weapon') == 'Secondary' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Savage Blade" <t>');
        end
    else
        if gcinclude.CheckAbilityRecast('Curing Waltz III') == 0 and player.HPP <= 35 and player.SubJob == 'DNC' and player.TP > 500 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Curing Waltz III" <me>');
        elseif gcinclude.CheckAbilityRecast('Healing Waltz') == 0 and player.TP >= 200 and gData.GetBuffCount('Paralysis') ~= 0 and player.SubJob == 'DNC' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Healing Waltz" <me>');
        elseif gData.GetBuffCount('Haste Samba') == 0 and gcinclude.CheckAbilityRecast('Sambas') == 0 and (player.TP >= 350) and player.SubJob == 'DNC' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Haste Samba" <me>');
        end
    end
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();
    local meleeSet = sets[gcdisplay.GetCycle('MeleeSet')];
    if (player.Status == 'Engaged') then
        if (player.HPP < 50) then
            gFunc.EquipSet(sets.DT)
        else
            gFunc.EquipSet(meleeSet);
        end
        if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    elseif (player.MPP < 90) then
        gFunc.EquipSet(sets.Refresh);
    else
        gFunc.EquipSet(sets.Idle);
    end
    if gcdisplay.GetToggle('Solo') == true and player.Status == 'Engaged' then profile.SoloMode() end;
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
    if (gcinclude.CheckSpellBailout == false) then
        gFunc.CancelAction()
        return;
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
    if (gcinclude.CheckWsBailout() == false) then
        gFunc.CancelAction()
        return;
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
