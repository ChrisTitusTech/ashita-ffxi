local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');
gcheals = gFunc.LoadFile('common\\gcheals.lua');

-- Add a variable to store main weapon
setweapon = 'Magesmasher +1';
setoffhand = 'Sors Shield';
local sets = {
    ['Idle'] = {
        Main = { Name = 'Magesmasher +1', AugPath='A' },
        Sub = 'Sors Shield',
        Range = 'Dunna',
        Head = 'Jhakri Coronal +1',
        Neck = 'Sanctity Necklace',
        Ear1 = { Name = 'Moonshade Earring', Augment = { [1] = 'Latent effect: "Refresh"+1', [2] = '"Mag. Atk. Bns."+4' } },
        Ear2 = 'Azimuth Earring',
        Body = 'Jhakri Robe +1',
        Hands = 'Jhakri Cuffs +2',
        Ring1 = 'Shneddick Ring',
        Ring2 = 'Chirich Ring',
        Back = { Name = 'Lifestream Cape', Augment = { [1] = 'Pet: Damage taken -4%', [2] = 'Geomancy Skill +7', [3] = 'Indi. eff. dur. +16' } },
        Waist = 'Cetl Belt',
        Legs = 'Jhakri Slops +1',
        Feet = 'Jhakri Pigaches +1',
    },
    ['Default'] = {
        Main = { Name = 'Magesmasher +1', AugPath='A' },
        Sub = 'Sors Shield',
        Range = 'Dunna',
        Head = 'Jhakri Coronal +1',
        Neck = 'Sanctity Necklace',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Cessance Earring',
        Body = 'Jhakri Robe +1',
        Hands = 'Jhakri Cuffs +2',
        Ring1 = 'Chirich Ring',
        Ring2 = 'Chirich Ring',
        Back = { Name = 'Lifestream Cape', Augment = { [1] = 'Pet: Damage taken -4%', [2] = 'Geomancy Skill +7', [3] = 'Indi. eff. dur. +16' } },
        Waist = 'Cetl Belt',
        Legs = 'Jhakri Slops +1',
        Feet = 'Jhakri Pigaches +1',
    },
};
sets.Weapons = {
    Main = setweapon,
    Sub = setoffhand
};
sets.Hybrid = {};
sets.Acc = {};
sets.Dt = {};
sets.Cure = {};
sets.Enfeebling = {};
sets.Elemental = {};
sets.Enhancing = {};

sets.Movement = {};
sets.Ws_Default = {
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt'
};
profile.Sets = sets;

profile.Packer = {
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.Initialize();

    AshitaCore:GetChatManager():QueueCommand(1, '/alias /stat /lac fwd status');

    -- Set macro book/set
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 4');
end

profile.OnUnload = function()
    AshitaCore:GetChatManager():QueueCommand(1, '/alias /del /stat');
    gcinclude.Unload();
end

profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();
    local target = gData.GetTarget();
    local recast = AshitaCore:GetMemoryManager():GetRecast();
    local blizzRecast = recast:GetSpellTimer(149);
    
    gcinclude.CheckDefault();
    if gcdisplay.GetToggle('Autoheal') == true then gcheals.CheckParty() end;
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end;
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
end

profile.HandleAbility = function()
    local action = gData.GetAction();

    
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
    local weather = gData.GetEnvironment();
    local player = gData.GetPlayer();
    local spell = gData.GetAction();
    local target = gData.GetActionTarget();
    local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing);
        
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Cure);
    elseif (spell.Skill == 'Elemental Magic') then
        gFunc.EquipSet(sets.Elemental);
        if (spell.Element == weather.WeatherElement) or (spell.Element == weather.DayElement) then
            gFunc.Equip('Waist', 'Hachirin-no-Obi');
        end
    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Enfeebling);
    end
end

profile.HandleWeaponskill = function()
    local canWS = gcinclude.CheckWsBailout();
    if (canWS == false) then gFunc.CancelAction() return;
    else gFunc.EquipSet(sets.Ws_Default) end
end

return profile; 