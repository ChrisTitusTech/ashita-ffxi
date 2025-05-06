local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');
gcheals = gFunc.LoadFile('common\\gcheals.lua');
local sets = {};

sets.Weapons = {};

-- Add these near the top after sets declaration
Setweapon = 'Epeolatry';
Setoffhand = 'Refined Grip +1';
Setear1 = 'Brutal Earring';
Setear2 = 'Cessance Earring';
SetBody = 'Runeist Coat +2';

sets.Weapons = {
    Main = Setweapon,
    Sub = Setoffhand,
    Ear1 = Setear1,
    Ear2 = Setear2,
    Body = SetBody,
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.Initialize();

    -- Set up aliases for commands
    AshitaCore:GetChatManager():QueueCommand(1, '/alias /stat /lac fwd status');
    
    -- Check subjob and adjust weapons accordingly
    local player = gData.GetPlayer();
    
    if player.SubJob == 'NIN' or player.SubJob == 'DNC' then
        sets.Weapons.Main = 'Naegling';
        sets.Weapons.Sub = 'Blurred Sword +1';
        sets.Weapons.Ear1 = 'Suppanomimi';
        print(chat.header('RUN'):append(chat.message('Dual Wield detected - using swords')));
    else
        sets.Weapons.Main = 'Epeolatry';
        sets.Weapons.Sub = 'Refined Grip +1';
        sets.Weapons.Ear1 = 'Brutal Earring';
    end
    print(chat.header('RUN'):append(chat.message('Main Weapon: ' .. sets.Weapons.Main)));
    print(chat.header('RUN'):append(chat.message('Sub Weapon: ' .. sets.Weapons.Sub)));
    -- Set macro book/set
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 8');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind ` /ws "Dimidiation" <t>');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind ^` /ws "Resolution" <t>');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind numpad0 /ma "Foil" <me>');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind numpad. /ma "Crusade" <me>');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind numpad3 /ma "Refresh" <me>');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind numpad1 /ma "Phalanx" <me>');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind !numpad0 /ja "Swipe" <t>');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind !numpad. /ja "Swordplay" <me>');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind !numpad3 /ma "Temper" <me>');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind !numpad1 /ja "Rayke" <t>');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad0 /ja "Pflug" <me>');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad. /ja "Elemental Sforzo" <me> ');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad3 /ma "Shell V" <me>');
   AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad1 /ma "Protect IV" <me>');
    

    if player.SubJob == 'DRK' then
       AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad/ /ja "Souleater" <me>');
       AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad* /ja "Weapon Bash" <t>');
       AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad- /ja "Last Resort" <me>');
    elseif player.SubJob == 'SAM' then
       AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad/ /ja "Meditate" <me>');
       AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad* /ja "Sekkanoki" <me>');
       AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad- /ja "Third Eye" <me>');
    elseif player.SubJob == 'BLU' then
        AshitaCore:GetChatManager():QueueCommand(1, '/bind ~ /ma "Cocoon" <me>');
        AshitaCore:GetChatManager():QueueCommand(1, '/bind ^~ /ma "Sheep Song" <t>');
        AshitaCore:GetChatManager():QueueCommand(1, '/bind !~ /ma "Battle Dance" <t>');
        AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad/ /ma "Refueling" <me>');
       AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad* /ma "Wild Carrot" <me>');
       AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad- /ma "Terror Touch" <t>');
    end
    
end

profile.OnUnload = function()
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind `');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^`');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind numpad0');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind numpad.');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind numpad3');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind numpad1');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind !numpad0');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind !numpad.');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind !numpad3');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind !numpad1');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^numpad0');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^numpad.');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^numpad3');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^numpad1');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^numpad/');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^numpad*');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^numpad-');
    gcinclude.Unload();
end

sets.Idle = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Homiliary',
    Head = 'Erilaz Galea +2',
    Neck = 'Bathy Choker +1',
    Body = 'Turms Harness',
    Hands = 'Turms Mittens',
    Waist = 'Plat. Mog. Belt',
    Ear1 = 'Odnowa Earring +1',
    Ear2 = 'Ethereal Earring',
    Ring1 = 'Shneddick Ring',
    Ring2 = 'Moonbeam Ring',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Weapon skill damage +10%', [2] = 'STR+20', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = '"Regen"+5' } },
    Legs = 'Turms Subligar',
    Feet = 'Turms Leggings',
};

sets.Movement = {
    Ring1 = 'Shneddick Ring',
};

sets.Resting = sets.Idle;

sets.Precast = {
    Ammo = 'Sapience orb',
    Head = 'Rune. Bandeau +1',
    Ear1 = 'Loquac. Earring',
    Body = 'Erilaz Surcoat +2',
    Ring1 = 'Prolix Ring',
    Ring2 = 'Naji\'s Loop',
    Legs = 'Aya. Cosciales +2',
};

sets.EnhancePrecastAdd = {
    Legs = 'Futhark Trousers',
    Waist = 'Siegel Sash',
};
sets.EnhancePrecast = gFunc.Combine(sets.Precast, sets.EnhancePrecastAdd);

sets.Enhancing = {
    Head = 'Erilaz Galea +2',
    Legs = 'Futhark Trousers',
};

sets.DT = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Staunch Tathlum',
    Neck = 'Futhark Torque',
    Head = 'Erilaz Galea +2',
    Body = sets.Weapons.Body,
    Hands = 'Turms Mittens',
    Legs = 'Eri. Leg Guards +3',
    Feet = 'Erilaz Greaves +2',
    Waist = 'Plat. Mog. Belt',
    Ear1 = 'Odnowa Earring +1',
    Ear2 = sets.Weapons.Ear2,
    Ring1 = 'Moonbeam Ring',
    Ring2 = 'Moonbeam Ring',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Damage Taken-5', [2] = 'HP+60', [3] = 'Mag. Evasion+30', [4] = '"Store TP"+10', [5] = 'Evasion+20' } },
};

sets.Hybrid = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Coiste Bodhar',
    Head = 'Erilaz Galea +2',
    Body = 'Adhemar Jacket +1',
    Hands = 'Turms Mittens',
    Legs = 'Eri. Leg Guards +3',
    Feet = 'Erilaz Greaves +2',
    Neck = 'Futhark Torque',
    Waist = 'Sailfi Belt +1',
    Ear1 = sets.Weapons.Ear1,
    Ear2 = sets.Weapons.Ear2,
    Ring1 = 'Epona\'s Ring',
    Ring2 = 'Ephramad\'s Ring',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Damage Taken-5', [2] = 'HP+60', [3] = 'Mag. Evasion+30', [4] = '"Store TP"+10', [5] = 'Evasion+20' } },
}

sets.Acc = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Hasty Pinion +1',
    Head = 'Erilaz Galea +2',
    Body = 'Adhemar Jacket +1',
    Hands = 'Turms Mittens',
    Legs = 'Eri. Leg Guards +3',
    Feet = 'Erilaz Greaves +2',
    Neck = 'Defiant Collar',
    Waist = 'Ioskeha Belt',
    Ear1 = sets.Weapons.Ear1,
    Ear2 = sets.Weapons.Ear2,
    Ring1 = 'Ephramad\'s Ring',
    Ring2 = 'Chirich Ring',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Damage Taken-5', [2] = 'HP+60', [3] = 'Mag. Evasion+30', [4] = '"Store TP"+10', [5] = 'Evasion+20' } },
}

sets.Default = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Coiste Bodhar',
    Head = 'Adhemar Bonnet',
    Body = 'Adhemar Jacket +1',
    Hands = 'Herculean Gloves',
    Legs = 'Meg. Chausses +2',
    Feet = 'Herculean Boots',
    Neck = 'Defiant Collar',
    Waist = 'Sailfi Belt +1',
    Ear1 = sets.Weapons.Ear1,
    Ear2 = sets.Weapons.Ear2,
    Ring1 = 'Epona\'s Ring',
    Ring2 = 'Ephramad\'s Ring',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Damage Taken-5', [2] = 'HP+60', [3] = 'Mag. Evasion+30', [4] = '"Store TP"+10', [5] = 'Evasion+20' } },
};

sets.Ws_Default = {
    Ammo = 'Oshasha\'s Treatise',
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
    Hands = 'Meg. Gloves +2',
    Ear1 = 'Moonshade Earring',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Weapon skill damage +10%', [2] = 'STR+20', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = '"Regen"+5' } },
};

sets.Savage_Blade = {
    Ammo = 'Oshasha\'s Treatise',
    Ear1 = 'Moonshade Earring',
    Ear2 = 'Cessance Earring',
    Head = 'Erilaz Galea +2',
    Body = 'Erilaz Surcoat +2',
    Hands = 'Meg. Gloves +2',
    Ring1 = 'Spiral Ring',
    Ring2 = 'Ephramad\'s Ring',
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
    Legs = 'Eri. Leg Guards +3',
    Feet = 'Erilaz Greaves +2',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Weapon skill damage +10%', [2] = 'STR+20', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = '"Regen"+5' } },
};

sets.DimidationAdd = {
    Ammo = 'Oshasha\'s Treatise',
    Head = 'Aya. Zucchetto +2',
    Neck = 'Fotia Gorget',
    Ear1 = 'Moonshade Earring',
    Ear2 = 'Brutal Earring',
    Body = 'Adhemar Jacket +1',
    Hands = 'Meg. Gloves +2',
    Ring1 = 'Epona\'s Ring',
    Ring2 = 'Ephramad\'s Ring',
    Back = { Name = 'Ogma\'s Cape', Augment = { [1] = 'Weapon skill damage +10%', [2] = 'STR+20', [3] = 'Accuracy+20', [4] = 'Attack+20', [5] = '"Regen"+5' } },
    Waist = 'Fotia Belt',
    Legs = 'Aya. Cosciales +2',
    Feet = 'Aya. Gambieras +2',
};
sets.Dimidiation = gFunc.Combine(sets.Ws_Default, sets.DimidationAdd);

sets.Resolution = sets.Ws_Default;

sets.TH = {
    Ammo = 'Per. Lucky Egg',
};

sets.Valiance = {
    Body = 'Runeist Coat +2',
};

sets.Vivacious_Pulse = {
    Head = 'Erilaz Galea +2',
};

sets.Pflug = {
    Feet = 'Runeist Bottes',
};

profile.Sets = sets;

profile.Packer = {};

profile.UpdateSets = function()
    local gearSets = {'Weapons', 'Idle', 'DT', 'Default', 'Hybrid', 'Acc'}
    
    for _, set in ipairs(gearSets) do
        sets[set].Main = Setweapon
        sets[set].Sub = Setoffhand
        if set ~= 'DT' then
            sets[set].Ear1 = Setear1
            sets[set].Ear2 = Setear2
        end
    end
    
    sets.DT.Body = SetBody
end

profile.CountRunes = function()
    -- Count the number of runes active on the player
    local runeList = { 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda', 'Lux', 'Tenebrae' };
    local runeCount = 0;

    for i = 1, #runeList do
        if (gData.GetBuffCount(runeList[i]) > 0) then
            runeCount = runeCount + gData.GetBuffCount(runeList[i]);
        end
    end

    return runeCount;
end

profile.SoloMode = function()
    local player = gData.GetPlayer();
    local recast = AshitaCore:GetMemoryManager():GetRecast();
    local temperRecast = recast:GetSpellTimer(493);
    local target = gData.GetTarget();
    if player.Status == 'Engaged' then
        if player.TP > 1000 and gcinclude.CheckWsBailout() == true and gData.GetEquipment().Main.Name == 'Epeolatry' and gcheals.CheckTrustMembers() == 5 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Dimidiation" <t>');
        elseif player.TP > 1750 and gcinclude.CheckWsBailout() == true and (player.HPP > 50) and gData.GetEquipment().Main.Name == 'Naegling' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Savage Blade" <t>');
        elseif player.TP > 1000 and gcinclude.CheckWsBailout() == true and (player.HPP <= 50) and gData.GetEquipment().Main.Name == 'Naegling' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Sanguine Blade" <t>');
        end
        if (player.HPP < 50) and gcinclude.CheckAbilityRecast('Vivacious Pulse') == 0 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Vivacious Pulse" <me>');
        elseif gData.GetBuffCount('Multi Strikes') == 0 and temperRecast == 0 and (player.MPP > 50) and gcinclude.CheckSpellBailout() == true then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Temper" <me>');
        elseif gcinclude.CheckAbilityRecast('Curing Waltz III') == 0 and player.HPP < 35 and player.SubJob == 'DNC' and player.TP > 500 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Curing Waltz III" <me>');
        elseif gcinclude.CheckAbilityRecast('Healing Waltz') == 0 and player.TP >= 200 and gData.GetBuffCount('Paralysis') ~= 0 and player.SubJob == 'DNC' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Healing Waltz" <me>');
        elseif gcinclude.CheckAbilityRecast('Rune Enchantment') == 0 and profile.CountRunes() ~= 3 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Sulpor" <me>');
        elseif gData.GetBuffCount('Haste Samba') == 0 and gcinclude.CheckAbilityRecast('Sambas') == 0 and (player.TP >= 350) and player.SubJob == 'DNC' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Haste Samba" <me>');
        elseif gData.GetBuffCount('Hasso') == 0 and gcinclude.CheckAbilityRecast('Hasso') == 0 and player.SubJob == 'SAM' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Hasso" <me>');
        elseif target == 'Monster' then
            gcinclude.AutoEngage();

        end
    elseif player.Status ~= 'Engaged' then
        if player.MPP < 50 and gcinclude.CheckAbilityRecast('Rune Enchantment') == 0 and gData.GetBuffCount('Lux') ~= 3 and gData.GetBuffCount('Invisible') == 0 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Lux" <me>');
        end
    end

    
end

profile.Weapons = function ()
    if (gcdisplay.GetCycle('Weapon') == 'Primary') and (Setweapon ~= 'Epeolatry') then
        Setweapon = 'Epeolatry';
        Setoffhand = 'Refined Grip +1';
        Setear1 = 'Brutal Earring';
        Setear2 = 'Cessance Earring';
        for _, set in ipairs({'Weapons', 'Hybrid', 'Idle', 'Acc', 'DT', 'Default'}) do
            sets[set].Main = Setweapon
            sets[set].Sub = Setoffhand
            sets[set].Ear1 = Setear1
            sets[set].Ear2 = Setear2
        end
        gFunc.EquipSet(sets.Weapons)
    elseif (gcdisplay.GetCycle('Weapon') == 'Secondary') and (Setweapon ~= 'Naegling') then
        Setweapon = 'Naegling';
        Setoffhand = 'Blurred Sword +1';
        Setear1 = 'Suppanomimi';
        Setear2 = 'Eabani Earring';
        for _, set in ipairs({'Weapons', 'Hybrid', 'Idle', 'Acc', 'DT', 'Default'}) do
            sets[set].Main = Setweapon
            sets[set].Sub = Setoffhand
            sets[set].Ear1 = Setear1
            sets[set].Ear2 = Setear2
        end
        gFunc.EquipSet(sets.Weapons)
    end
    
end

profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();
    if player.Status == 'Zoning' then return end;
    
    -- Add this weapon swap logic near the start of HandleDefault
    profile.Weapons();
    local meleeSet = sets[gcdisplay.GetCycle('MeleeSet')];
    if gData.GetEquipment().Body then
        if player.MPP < 50 and meleeSet == sets.DT and gData.GetEquipment().Body.Name ~= 'Erilaz Surcoat +2' then
            SetBody = 'Erilaz Surcoat +2';
            profile.UpdateSets();
        elseif player.MPP >= 50 and meleeSet == sets.DT and gData.GetEquipment().Body.Name ~= 'Runeist Coat +2' then
            SetBody = 'Runeist Coat +2';
            profile.UpdateSets();
        end
    end
    if player.Status == 'Engaged' then
        if (player.HPP < 50) then
            gFunc.EquipSet(sets.DT);
        else
            gFunc.EquipSet(meleeSet);
        end
        if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end;
    elseif player.Status == 'Resting' then
        gFunc.EquipSet(sets.Resting);
    elseif (meleeSet == sets.DT) then 
        gFunc.EquipSet(sets.DT);
    else
        gFunc.EquipSet(sets.Idle);
	end
    if (gcdisplay.GetToggle('Solo') == true) then profile.SoloMode() end;
    gcinclude.CheckDefault();
    gcinclude.AutoEngage();
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

	if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(gcinclude.sets.Holy_Water) end;
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();
    gcinclude.DoShadows(spell);
    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.EnhancePrecast);
    else
        gFunc.EquipSet(sets.Precast);
    end

    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    local player = gData.GetPlayer();
    local spell = gData.GetAction();
    local meleeSet = sets[gcdisplay.GetCycle('MeleeSet')];
    if (spell.Skill == 'Enhancing Magic') then
        local quickcastset = gFunc.Combine(meleeSet, sets.Enhancing);
        gFunc.EquipSet(quickcastset);
    elseif player.HPP < 50 then
        gFunc.EquipSet(sets.DT);
    else
        gFunc.EquipSet(meleeSet);
    end
    if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end;
end

profile.HandleWeaponskill = function()
    local canWS = gcinclude.CheckWsBailout();
    if (canWS == false) then gFunc.CancelAction() return;
    else
        local ws = gData.GetAction();
    
        gFunc.EquipSet(sets.Ws_Default)
        
        if string.match(ws.Name, 'Aeolian Edge') then
            gFunc.EquipSet(sets.Aedge_Default)
        elseif string.match(ws.Name, 'Savage Blade') then
            gFunc.EquipSet(sets.Savage_Blade)
        elseif string.match(ws.Name, 'Resolution') then
            gFunc.EquipSet(sets.Resolution)
        elseif string.match(ws.Name, 'Dimidiation') then
            gFunc.EquipSet(sets.Dimidiation)
        end
    end
end

return profile; 