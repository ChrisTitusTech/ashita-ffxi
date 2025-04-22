local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

local sets = {};
sets.Weapons = {};

-- Add these near the top after sets declaration
local setweapon = 'Epeolatry';
local setoffhand = 'Refined Grip +1';
local setear1 = 'Brutal Earring';
local setear2 = 'Cessance Earring';

sets.Weapons = {
    Main = setweapon,
    Sub = setoffhand,
    Ear1 = setear1,
    Ear2 = setear2
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
    Neck = 'Futhark Torque',
    Body = 'Runeist Coat +2',
    Hands = 'Turms Mittens',
    Waist = 'Flume Belt',
    Ear1 = 'Odnowa Earring +1',
    Ear2 = 'Ethereal Earring',
    Ring1 = 'Shneddick Ring',
    Ring2 = 'Moonbeam Ring',
    Back = 'Ogma\'s Cape',
    Legs = 'Eri. Leg Guards +2',
    Feet = 'Turms Leggings',
};

sets.Movement = {};

sets.Resting = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Staunch Tathlum',
    Head = 'Aya. Zucchetto +2',
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
    Body = 'Erilaz Surcoat +2',
    Ring1 = 'Prolix Ring',
    Ring2 = 'Naji\'s Loop',
    Legs = 'Aya. Cosciales +2',
    Waist = 'Siegel Sash',
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
    Feet = 'Erilaz Greaves +2',
    Waist = 'Flume Belt',
    Ear1 = 'Odnowa Earring +1',
    Ear2 = 'Ethereal Earring',
    Ring1 = 'Shneddick Ring',
    Ring2 = 'Moonbeam Ring',
};

sets.Hybrid = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Coiste Bodhar',
    Head = 'Adhemar Bonnet',
    Body = 'Adhemar Jacket +1',
    Hands = 'Turms Mittens',
    Legs = 'Eri. Leg Guards +2',
    Feet = 'Erilaz Greaves +2',
    Neck = 'Futhark Torque',
    Waist = 'Sailfi Belt +1',
    Ear1 = sets.Weapons.Ear1,
    Ear2 = sets.Weapons.Ear2,
    Ring1 = 'Epona\'s Ring',
    Ring2 = 'Chirich Ring',
    Back = 'Ogma\'s Cape',
}

sets.Acc = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Hasty Pinion +1',
    Head = 'Erilaz Galea +2',
    Body = 'Adhemar Jacket +1',
    Hands = 'Turms Mittens',
    Legs = 'Eri. Leg Guards +2',
    Feet = 'Erilaz Greaves +2',
    Neck = 'Defiant Collar',
    Waist = 'Ioskeha Belt',
    Ear1 = sets.Weapons.Ear1,
    Ear2 = sets.Weapons.Ear2,
    Ring1 = 'Moonbeam Ring',
    Ring2 = 'Chirich Ring',
    Back = 'Ogma\'s Cape',
}

sets.Default = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Coiste Bodhar',
    Head = 'Adhemar Bonnet',
    Body = 'Adhemar Jacket +1',
    Hands = 'Herculean Gloves',
    Legs = 'Samnuha Tights',
    Feet = 'Herculean Boots',
    Neck = 'Defiant Collar',
    Waist = 'Sailfi Belt +1',
    Ear1 = sets.Weapons.Ear1,
    Ear2 = sets.Weapons.Ear2,
    Ring1 = 'Epona\'s Ring',
    Ring2 = 'Chirich Ring',
    Back = 'Ogma\'s Cape',
};

sets.Ws_Default = {
    Ammo = 'Oshasha\'s Treatise',
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

sets.Savage_Blade = {
    Ammo = 'Oshasha\'s Treatise',
    Ear1 = 'Moonshade Earring',
    Ear2 = 'Cessance Earring',
    Neck = 'Rep. Plat. Medal',
    Head = 'Erilaz Galea +2',
    Body = 'Erilaz Surcoat +2',
    Hands = 'Aya. Manopolas +2',
    Ring1 = 'Spiral Ring',
    Ring2 = 'Rajas Ring',
    Waist = { Name = 'Sailfi Belt +1', AugPath='A' },
    Legs = { Name = 'Samnuha Tights', Augment = { [1] = 'STR+9', [2] = '"Dbl.Atk."+2', [3] = '"Triple Atk."+2', [4] = 'DEX+8' } },
    Feet = 'Erilaz Greaves +2',
};


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
    -- Update weapons in all sets
    sets.Weapons.Main = setweapon;
    sets.Weapons.Sub = setoffhand;
    sets.Weapons.Ear1 = setear1;
    sets.Weapons.Ear2 = setear2;
    
    -- Update all sets that reference weapons
    sets.Idle.Main = setweapon;
    sets.Idle.Sub = setoffhand;
    sets.Dt.Main = setweapon;
    sets.Dt.Sub = setoffhand;
    sets.Default.Main = setweapon;
    sets.Default.Sub = setoffhand;
    sets.Default.Ear1 = setear1;
    sets.Default.Ear2 = setear2;
    sets.Hybrid.Main = setweapon;
    sets.Hybrid.Sub = setoffhand;
    sets.Hybrid.Ear1 = setear1;
    sets.Hybrid.Ear2 = setear2;
    sets.Acc.Main = setweapon;
    sets.Acc.Sub = setoffhand;
    sets.Acc.Ear1 = setear1;
    sets.Acc.Ear2 = setear2;
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
    local temper = gData.GetBuffCount('Multi Strikes');
    local temperRecast = recast:GetSpellTimer(493);
    if player.TP > 1750 and gcinclude.CheckWsBailout() == true and player.Status == 'Engaged' then
        if gData.GetEquipment().Main.Name == 'Epeolatry' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Dimidiation" <t>');
        elseif (player.HPP > 50) and gData.GetEquipment().Main.Name == 'Naegling' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Savage Blade" <t>');
        elseif (player.HPP <= 50) and gData.GetEquipment().Main.Name == 'Naegling' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Sanguine Blade" <t>');
        end
    -- Handle Spells
    elseif gcinclude.CheckSpellBailout() == true and player.Status == 'Engaged' then
        if (player.HPP < 50) then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Vivacious Pulse" <me>');
        elseif temper == 0 and temperRecast == 0 and (player.MPP > 50) then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Temper" <me>');
        elseif gcinclude.CheckAbilityRecast('Curing Waltz III') == 0 and player.HPP < 35 and player.SubJob == 'DNC' and player.TP > 500 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Curing Waltz III" <me>');
        elseif gcinclude.CheckAbilityRecast('Healing Waltz') == 0 and player.TP >= 200 and gData.GetBuffCount('Paralysis') ~= 0 and player.SubJob == 'DNC' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Healing Waltz" <me>');
        elseif gcinclude.CheckAbilityRecast('Rune Enhancement') == 0 and profile.CountRunes() ~= 3 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Sulpor" <me>');
        elseif gData.GetBuffCount('Haste Samba') == 0 and gcinclude.CheckAbilityRecast('Sambas') == 0 and (player.TP >= 350) and player.SubJob == 'DNC' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Haste Samba" <me>');
        end
    elseif player.Status ~= 'Engaged' then
        if player.MPP < 50 and gcinclude.CheckAbilityRecast('Rune Enhancement') == 0 and gData.GetBuffCount('Lux') ~= 3 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Lux" <me>');
        end
    end

    
end

profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();
    
    -- Add this weapon swap logic near the start of HandleDefault
    if (player.SubJob == 'NIN' or player.SubJob == 'DNC') and (setweapon ~= 'Naegling') then
        setweapon = 'Naegling';
        setoffhand = 'Blurred Sword +1';
        setear1 = 'Suppanomimi';
        setear2 = 'Eabani Earring';
        profile.UpdateSets();
        gFunc.EquipSet(sets.Weapons);
    elseif (player.SubJob ~= 'NIN' and player.SubJob ~= 'DNC') and (setweapon ~= 'Epeolatry') then
        setweapon = 'Epeolatry';
        setoffhand = 'Refined Grip +1';
        setear1 = 'Brutal Earring';
        setear2 = 'Cessance Earring';
        profile.UpdateSets();
        -- Force equipment update
        gFunc.EquipSet(sets.Weapons);
    end
    if player.Status == 'Engaged' then
        if (player.HPP < 50) then
            gFunc.EquipSet(sets.Dt)
        else
            gFunc.EquipSet(gcdisplay.GetCycle('MeleeSet'))
        end
		if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    elseif player.Status == 'Resting' then
        gFunc.EquipSet(sets.Resting);
    else
		gFunc.EquipSet(sets.Idle);
    end
	
    if (gcdisplay.GetToggle('Solo') == true) then profile.SoloMode() end;
    gcinclude.CheckDefault();
    gcinclude.AutoEngage();
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
    gcinclude.DoShadows(spell);
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
        elseif string.match(ws.Name, 'Savage Blade') then
            gFunc.EquipSet(sets.Savage_Blade)
        end
    end
end

return profile; 