local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.Initialize();

    -- Set up common aliases
    AshitaCore:GetChatManager():QueueCommand(1, '/alias /stat /lac fwd status');

    -- DRG-specific keybinds
    AshitaCore:GetChatManager():QueueCommand(1, '/bind ` /ws "Stardiver" <t>');
    AshitaCore:GetChatManager():QueueCommand(1, '/bind ^` /ws "Drakesbane" <t>');
    AshitaCore:GetChatManager():QueueCommand(1, '/bind !` /ws "Sonic Thrust" <t>');
    AshitaCore:GetChatManager():QueueCommand(1, '/bind numpad0 /ja "Jump" <t>');
    AshitaCore:GetChatManager():QueueCommand(1, '/bind numpad. /ja "High Jump" <t>');
    AshitaCore:GetChatManager():QueueCommand(1, '/bind !numpad0 /ja "Spirit Jump" <t>');
    AshitaCore:GetChatManager():QueueCommand(1, '/bind !numpad. /ja "Soul Jump" <t>');
    AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad0 /ja "Ancient Circle" <me>');
    AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad. /ja "Spirit Link" <me>');
    AshitaCore:GetChatManager():QueueCommand(1, '/bind numpad1 /ja "Call Wyvern" <me>');

    -- Add subjob specific binds
    local player = gData.GetPlayer();
    if player.SubJob == 'SAM' then
        AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad- /ja "Meditate" <me>');
    elseif player.SubJob == 'WAR' then
        AshitaCore:GetChatManager():QueueCommand(1, '/bind ^numpad- /ja "Berserk" <me>');
    end

    -- Set macro book/set
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 2');
end

profile.OnUnload = function()
    -- Remove all keybinds
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind `');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^`');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind !`');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind numpad0');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind numpad.');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind !numpad0');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind !numpad.');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^numpad0');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^numpad.');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind numpad1');
    AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^numpad-');
    
    gcinclude.Unload();
end

local sets = {};

-- Define weapon variables
local Setweapon = 'Gae Derg +1';
local Setoffhand = 'Kaja Grip';
local Setear1 = 'Telos Earring';
local Setear2 = 'Peltast\'s Earring';

sets.Weapons = {
    Main = Setweapon,
    Sub = Setoffhand,
    Ear1 = Setear1, 
    Ear2 = Setear2,
};

sets.Idle = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Staunch Tathlum',
    Head = 'Nyame Helm',
    Body = 'Nyame Mail',
    Hands = 'Nyame Gauntlets',
    Legs = 'Nyame Flanchard',
    Feet = 'Nyame Sollerets',
    Ring1 = 'Shneddick Ring',
    Ring2 = 'Moonbeam Ring',
    Neck = 'Dgn. Collar +1',
    Ear1 = 'Odnowa Earring +1',
    Ear2 = 'Peltast\'s Earring',
    Back = 'Brigantia\'s Mantle',
    Waist = 'Plat. Mog. Belt',
};

sets.Resting = {};
sets.Refresh = {};
sets.Movement = {};
sets.Precast = {};
sets.Midcast = {};

sets.DT = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub, 
    Ammo = 'Staunch Tathlum',
    Head = 'Peltast\'s Mezail +2',
    Body = 'Nyame Mail',
    Hands = 'Pel. Vambraces +2',
    Legs = 'Pelt. Cuissots +2',
    Ring1 = 'Moonbeam Ring',
    Ring2 = 'Moonbeam Ring',
    Neck = 'Dgn. Collar +1',
    Ear1 = 'Odnowa Earring +1',
    Ear2 = 'Peltast\'s Earring',
    Back = 'Brigantia\'s Mantle',
    Waist = 'Plat. Mog. Belt',
    Feet = 'Nyame Sollerets'
};

sets.Default = {
    Main = sets.Weapons.Main,
    Sub = sets.Weapons.Sub,
    Ammo = 'Coiste Bodhar',
    Head = 'Flam. Zucchetto +2',
    Neck = 'Dgn. Collar +1',
    Ear1 = sets.Weapons.Ear1,
    Ear2 = sets.Weapons.Ear2,
    Body = 'Pelt. Plackart +2',
    Hands = 'Pel. Vambraces +2',
    Ring1 = 'Chirich Ring',
    Ring2 = 'Epona\'s Ring',
    Back = 'Brigantia\'s Mantle',
    Waist = 'Sailfi Belt +1',
    Legs = 'Pelt. Cuissots +2',
    Feet = 'Flam. Gambieras +2'
};

sets.Acc = {};
sets.Hybrid = {};

sets.Ws_Default = {
    Ammo = 'Oshasha\'s Treatise',
    Neck = 'Fotia Gorget',
    Ear1 = 'Moonshade Earring',
    Ear2 = 'Thrud Earring',
    Ring1 = 'Cornelia\'s Ring',
    Ring2 = 'Beithir Ring',
    Waist = 'Fotia Belt',
    Head = 'Peltast\'s Mezail +2',
    Legs = 'Nyame Flanchard',
    Feet = 'Sulev. Leggings +2'
};

sets.Jumps_Default = {       
    Head = 'Vishap Armet',
    Neck = 'Dgn. Collar +1',
    Back = 'Brigantia\'s Mantle',
    Waist = 'Windbuffet Belt',
    Legs = 'Vishap Brais',
    Feet = 'Vishap Greaves'
};

sets.Spirit_Surge = {
    --Petroslaver Mail 
};
sets.Call_Wyvern = {
    --Ptroslaver Mail
};
sets.Ancient_Circle = {
    --Vishap Brais
};
sets.Spirit_Link = {
    Head = 'Vishap Armet',
    Hands = 'Pel. Vambraces +2',
};
sets.Steady_Wing = {
    Back = 'Updraft Mantle'
};

sets.TH = {
    Ammo = 'Per. Lucky Egg'
};

sets.Angon = {
    Ammo = 'Angon'
};

sets.LockStyle = {
    Head = 'Vishap Armet',
    Body = 'Pteroslaver Mail',
    Hands = 'Vishap Finger Gauntlets',
    Legs = 'Vishap Brais',
    Feet = 'Vishap Greaves'
}

profile.Sets = sets;

profile.Packer = {
    {'Angon', Quantity = 'all'},
    {'Holy Water', Quantity = '12'},
    {'Remedy', Quantity = '12'},
    {'Panacea', Quantity = '12'},
    {'Prism Powder', Quantity = '12'},
    {'Silent Oil', Quantity = '12'},
    {'Holy Water', Quantity = '12'},
    {'Grape Daifuku',  Quantity = '12'},
    'Reraiser',
    'Hi-Reraiser',
};   


profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.UpdateSets = function()
    local gearSets = { 'Weapons', 'Idle', 'DT', 'Default', 'Hybrid', 'Acc' }

    for _, set in ipairs(gearSets) do
        sets[set].Main = Setweapon
        sets[set].Sub = Setoffhand
        if set ~= 'DT' then
            sets[set].Ear1 = Setear1
            sets[set].Ear2 = Setear2
        end
    end
end

profile.Weapons = function()
    if (gcdisplay.GetCycle('Weapon') == 'Primary') and (Setweapon ~= 'Gae Derg +1') then
        Setweapon = 'Gae Derg +1';
        Setoffhand = 'Kaja Grip';
        Setear1 = 'Telos Earring';
        Setear2 = 'Cessance Earring';
        profile.UpdateSets();
        gFunc.EquipSet(sets.Weapons)
    elseif (gcdisplay.GetCycle('Weapon') == 'Secondary') and (Setweapon ~= 'Naegling') then
        Setweapon = 'Naegling';
        Setoffhand = 'Ark Shield';
        Setear1 = 'Telos Earring';
        Setear2 = 'Cessance Earring';
        profile.UpdateSets();
        gFunc.EquipSet(sets.Weapons)
    elseif (gcdisplay.GetCycle('Weapon') == 'Third') and (Setweapon ~= 'Exalted Staff +1') then
        Setweapon = 'Exalted Staff +1';
        Setoffhand = 'Kaja Grip';
        Setear1 = 'Telos Earring';
        Setear2 = 'Cessance Earring';
        profile.UpdateSets();
        gFunc.EquipSet(sets.Weapons)
    end
end



profile.HandleDefault = function()
    local player = gData.GetPlayer();
    local bodyequip = gData.GetEquipment().Body;
    local target = gData.GetTarget();
    if player.Status == 'Zoning' then return end;  
    profile.Weapons();
    if player.Status == 'Engaged' then
        if (player.HPP < 50) then
            gFunc.EquipSet(sets.DT)
        else
            gFunc.EquipSet(gcdisplay.GetCycle('MeleeSet'))
        end
        if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    elseif player.Status == 'Resting' then
        gFunc.EquipSet(sets.Resting);
    elseif (gcdisplay.GetCycle('MeleeSet') == sets.DT) then
        gFunc.EquipSet(sets.DT);
    else
        gFunc.EquipSet(sets.Idle);
    end
    
    gcinclude.CheckDefault();
    gcinclude.AutoEngage();
    if (gcdisplay.GetToggle('Solo') == true) then profile.SoloMode() end;
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

profile.SoloMode = function()
    local player = gData.GetPlayer();
    local pet = gData.GetPet();
    local target = gData.GetTarget();

    if player.Status == 'Engaged' then
        -- Auto WS logic
        if player.TP >= 1000 and gcinclude.CheckWsBailout() == true and gData.GetEquipment().Main.Name == 'Gae Derg +1' then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Camlann\'s Torment" <t>');
        elseif player.TP >= 1750 and gcinclude.CheckWsBailout() == true and gData.GetEquipment().Main.Name == 'Naegling' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Savage Blade" <t>');
        end

        -- Auto Jump logic
        if gcinclude.CheckAbilityRecast('Jump') == 0 and player.TP < 1000 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Jump" <t>');
        elseif gcinclude.CheckAbilityRecast('High Jump') == 0 and player.TP < 1000 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "High Jump" <t>');
        elseif gcinclude.CheckAbilityRecast('Spirit Jump') == 0 and player.TP < 1000 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Spirit Jump" <t>');
        elseif gcinclude.CheckAbilityRecast('Soul Jump') == 0 and player.TP < 1000 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Soul Jump" <t>');
        end

        -- HP management
        if pet then
            if pet.HPP < 50 and gcinclude.CheckAbilityRecast('Spirit Link') == 0 then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Spirit Link" <me>');
            end
        end

        -- Buff maintenance
        if gData.GetBuffCount('Hasso') == 0 and gcinclude.CheckAbilityRecast('Hasso') == 0 and player.SubJob == 'SAM' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Hasso" <me>');
        end

        -- Auto engage
        if target == 'Monster' then
            gcinclude.AutoEngage();
        end
    end
end

return profile;