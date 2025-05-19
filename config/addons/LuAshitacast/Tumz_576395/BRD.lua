local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

local sets = {};
Setweapon = 'Naegling';
Setoffhand = 'Blurred Knife +1';
sets.Weapons = {
    Main = Setweapon,
    Sub = Setoffhand,
};

sets.Default = {
    Main = Setweapon,
    Sub = Setoffhand,
    Range = 'Miracle Cheer',
    Head = 'Fili Calot +2',
    Neck = 'Bard\'s Charm',
    Ear1 = 'Suppanomimi',
    Ear2 = 'Eabani Earring',
    Body = 'Ayanmo Corazza +2',
    Hands = 'Bunzi\'s Gloves',
    Ring1 = 'Chirich Ring',
    Ring2 = 'Ephramad\'s Ring',
    Back = { Name = 'Intarabus\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = 'Evasion+20', [3] = 'Mag. Evasion+20', [4] = 'MND+30', [5] = 'Enmity-10' } },
    Waist = 'Sailfi Belt +1',
    Legs = 'Fili Rhingrave +2',
    Feet = 'Fili Cothurnes +2',
}
sets.Idle = sets.Default;
sets.Movement = {
    Feet = 'Fili Cothurnes +2',
}
profile.Sets = sets;

sets.Precast = {
    Head = 'Fili Calot +2',
    Body = 'Vrikodara Jupon',
    Hands = 'Gende. Gages +1',
    Legs = 'Aya. Cosciales +2',
    Feet = 'Fili Cothurnes +2',
    Neck = 'Mnbw. Whistle +1',
    Ear1 = 'Loquac. Earring',
    Ring1 = 'Prolix Ring',
    Ring2 = 'Naji\'s Loop',
    Back = 'Swith Cape',
    Waist = 'Embla Sash',
}

sets.Midcast = {
    Range = 'Miracle Cheer',
    Head = 'Fili Calot +2',
    Neck = 'Mnbw. Whistle +1',
    Ear2 = { Name = 'Fili Earring +1', Augment = { [1] = 'Accuracy+14', [2] = 'Damage taken-5%', [3] = 'Mag. Acc.+14' } },
    Back = 'Harmony Cape',
    Body = 'Fili Hongreline +2',
    Hands = 'Fili Manchettes +2',
    Ring1 = 'Stikini Ring',
    Ring2 = 'Stikini Ring',
    Legs = 'Fili Rhingrave +2',
    Feet = 'Fili Cothurnes +2',
}
sets.DTAdd = {
    Neck = 'Elite Royal Collar',
    Waist = 'Plat. Mog. Belt',
    Ear1 = { Name = 'Odnowa Earring +1', AugPath = 'A' },
    Ear2 = { Name = 'Fili Earring +1', Augment = { [1] = 'Accuracy+14', [2] = 'Damage taken-5%', [3] = 'Mag. Acc.+14' } },
    Ring1 = 'Moonbeam Ring',
    Ring2 = 'Moonbeam Ring',
}
sets.DT = gFunc.Combine(sets.Default, sets.DTAdd);
sets.Hybrid = sets.Default;
sets.AccAdd = {
    Neck = 'Bard\'s Charm',
    Ear1 = 'Cessance Earring',
    Waist = 'Sailfi Belt +1',
    Ring1 = 'Moonbeam Ring',
    Ring2 = 'Ephramad\'s Ring',
}
sets.Acc = gFunc.Combine(sets.Default, sets.AccAdd);
sets.Resting = sets.Default;

sets.WS = {
    Ammo = 'Oshasha\'s Treatise',
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
    Ear1 = 'Moonshade Earring',
}
sets.SavageBlade = sets.WS;

profile.Packer = {
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.Initialize();

    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 5');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 1');
end

profile.OnUnload = function()
    gcinclude.Unload();
end

profile.SoloMode = function()
    local player = gData.GetPlayer();
    if gcinclude.CheckWsBailout() == true and player.HPP > 35 and Setweapon == 'Kaja Knife' and player.TP >= 1000 then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Evisceration" <t>')
    elseif gcinclude.CheckWsBailout() == true and player.HPP > 35 and Setweapon == 'Naegling' and player.TP >= 1750 then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Savage Blade" <t>')
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

profile.AutoSing = function()
    if gData.GetBuffCount('madrigal') == 0 and AshitaCore:GetMemoryManager():GetRecast():GetSpellTimer(399) == 0 then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Blade Madrigal" <me>');
    elseif gData.GetBuffCount('minuet') == 0 and AshitaCore:GetMemoryManager():GetRecast():GetSpellTimer(398) == 0 then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Valor Minuet V" <me>');
    elseif gData.GetBuffCount('march') == 0 and AshitaCore:GetMemoryManager():GetRecast():GetSpellTimer(420) == 0 then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Victory March" <me>');
    end
end

profile.Weapons = function ()
    local player = gData.GetPlayer();
    if (gcdisplay.GetCycle('Weapon') == 'Primary') and (Setweapon ~= 'Naegling') then
        Setweapon = 'Naegling';
        if player.SubJob == 'DNC' or player.SubJob == 'NIN' then 
            Setoffhand = 'Blurred Knife +1';
        else
            Setoffhand = 'Ark Shield';
        end
    elseif (gcdisplay.GetCycle('Weapon') == 'Secondary') and (Setweapon ~= 'Kaja Knife') then
        Setweapon = 'Kaja Knife';
        if player.SubJob == 'DNC' or player.SubJob == 'NIN' then 
            Setoffhand = 'Blurred Knife +1';
        else
            Setoffhand = 'Ark Shield';
        end
       
    elseif gcdisplay.GetCycle('Weapon') == 'Third' and Setweapon ~= 'Naegling' then
        Setweapon = 'Naegling';
        if player.SubJob == 'DNC' or player.SubJob == 'NIN' then 
            Setoffhand = 'Blurred Knife +1';
        else
            Setoffhand = 'Ark Shield';
        end
    end
    for _, set in ipairs({'Weapons', 'Hybrid', 'Idle', 'Acc', 'DT', 'Default'}) do
        sets[set].Main = Setweapon
        sets[set].Sub = Setoffhand
    end
    gFunc.EquipSet(sets.Weapons)
    
end

profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();

    gFunc.EquipSet(gcdisplay.GetCycle('MeleeSet'));

    if gcdisplay.GetToggle('Solo') == true and player.Status == 'Engaged' then
        profile.SoloMode();
        if player.IsMoving ~= true then profile.AutoSing() end;
    end
    profile.Weapons();
    gcinclude.CheckDefault();
    gcinclude.AutoEngage();
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
end

profile.HandleAbility = function()
    local action = gData.GetAction();
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();
    gcinclude.DoShadows(spell);
    gFunc.EquipSet(sets.Precast);
    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    gFunc.EquipSet(sets.Midcast);
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    local canWS = gcinclude.CheckWsBailout();
    if (canWS == false) then
        gFunc.CancelAction()
        return;
    else
        local ws = gData.GetAction();

        gFunc.EquipSet('WS');

        if string.match(ws.Name, 'Aeolian Edge') then
            gFunc.EquipSet('Aedge')
        elseif string.match(ws.Name, 'Savage Blade') then
            gFunc.EquipSet('SavageBlade')
        end
    end
end

return profile;
