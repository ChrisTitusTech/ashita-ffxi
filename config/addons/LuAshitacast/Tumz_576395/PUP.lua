local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.Initialize();
    gcdisplay.CreateToggle('Pet', true);

    -- Set macro book/set
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 7');
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
        Ring1 = 'Vocane Ring',
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
        Main = 'Denouements',
        Range = 'Animator P II',
        Ammo = 'Automat. Oil +3',
        Head = 'Anwig Salade',
        Body = 'Heyoka Harness',
        Hands = 'Pantin Dastanas',
        Legs = 'Tali\'ah Sera. +2',
        Feet = 'Cirque Scarpe',
        Neck = 'Sanctity Necklace',
        Waist = 'Isa Belt',
        Ear1 = 'Charivari Earring',
        Ear2 = 'Burana Earring',
        Ring1 = 'Varar Ring',
        Ring2 = 'Varar Ring',
        Back = 'Visucius\'s Mantle'
    },

    ['Tp_Default'] = {
        Main = 'Jolt Counter',
        Range = 'Animator P II',
        Head = 'Heyoka cap',
        Neck = 'Asperity Necklace',
        Ear1 = 'Mache Earring',
        Ear2 = 'Cessance Earring',
        Body = 'Tali\'ah Manteel +2',
        Hands = 'Herculean Gloves',
        Ring1 = 'Chirich Ring',
        Ring2 = 'Epona\'s Ring',
        Back = 'Visucius\'s Mantle',
        Waist = 'Moonbow Belt',
        Legs = 'Samnuha Tights',
        Feet = 'Flamma Leggings +2'
    },

    ['Pet'] = {
        Main = 'Denouements',
        Range = 'Animator P II',
        Ammo = 'Automat. Oil +3',
        Head = 'Heyoka Cap',
        Body = 'Heyoka Harness',
        Hands = 'Heyoka Mittens',
        Legs = 'Heyoka Subligar',
        Feet = 'Tali\'ah Crackows +2',
        Neck = 'Sanctity Necklace',
        Waist = 'Incarnation Belt',
        Ear1 = 'Charivari Earring',
        Ear2 = 'Burana Earring',
        Ring1 = 'Varar Ring',
        Ring2 = 'Varar Ring',
        Back = 'Visucius\'s Mantle'
    },

    ['Ws_Default'] = {
        Neck = 'Fotia Gorget',
        Waist = 'Fotia Belt',
    },

    ['Tactical_Switch'] = {
        -- Can add Empy Feet when available
    },
    
    ['Ventriloquy'] = {
        Feet = "Pitre Churidars",
    },
    
    ['Role_Reversal'] = {
        -- Can add Relic Feet when available
    },
    
    ['Overdrive'] = {
        Body = 'Pitre Tobe +1',
    },
    
    ['TH'] = {
        Ammo = 'Per. Lucky Egg',
    },

    ['Repair'] = {
        Ammo = 'Automat. Oil +3',        
    },

    ['Manuever'] = {
        Neck = "Buffoon's Collar",
        Body = "Karagoz Farsetto",
        Hands = "Foire Dastanas",
        Back = "Visucius\'s Mantle",
        Ear1 = "Burana Earring",
    },
};

profile.Sets = sets;

profile.Packer = {
    'Sanctity Necklace',
    'Incarnation Belt',
    'Charivari Earring',
    'Burana Earring',
    'Varar Ring',
    'Visucius\'s Mantle',
    'Fotia Gorget',
    'Fotia Belt',
    'Pitre Churidars',
    'Pitre Tobe +1',
    'Per. Lucky Egg',
    'Automat. Oil +3',
    'Buffoon\'s Collar',
    'Karagoz Farsetto',
    'Foire Dastanas'
};   


profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);

    if (args[1] == 'pet') then
        gcdisplay.AdvanceToggle('Pet');
        toggle = 'Pet Set';
        status = gcdisplay.GetToggle('Pet');
        if (gcdisplay.GetToggle('Pet') == true) then gFunc.EquipSet(sets.Pet) end;
    end
end

profile.HandleDefault = function()
	local player = gData.GetPlayer();
    if (player.Status == 'Engaged') then
        if (gcdisplay.GetToggle('DTset') == true) then
            gFunc.EquipSet(sets.Dt)
        elseif (gcdisplay.GetToggle('Pet') == true) then
            gFunc.EquipSet(sets.Pet)
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
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
    
end

profile.HandleAbility = function()
    local action = gData.GetAction();

    if (action.Name == 'Tactical Switch') then
        gFunc.EquipSet(sets.Tactical_Switch);
    elseif (action.Name == 'Ventriloquy') then
        gFunc.EquipSet(sets.Ventriloquy);
    elseif (action.Name == 'Role Reversal') then
        gFunc.EquipSet(sets.Role_Reversal);
    elseif (action.Name == 'Overdrive') then
        gFunc.EquipSet(sets.Overdrive);
    elseif (action.Name == 'Repair') then
        gFunc.EquipSet(sets.Repair);
    elseif (string.match(action.Name, 'Maneuver')) then
        gFunc.EquipSet(sets.Manuever);
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