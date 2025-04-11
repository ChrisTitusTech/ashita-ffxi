local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');
gcmovement = gFunc.LoadFile('common\\gcmovement.lua');

local sets = {
    ['Idle'] = {
        Sub = 'Blurred Knife +1',
        Main = 'Kaja Knife',
        Range = { Name = 'Compensator', AugPath='B' },
        Ammo = 'Eminent Bullet',
        Head = { Name = 'Lanun Tricorne +1', AugTrial=5310 },
        Neck = 'Elite Royal Collar',
        Ear1 = { Name = 'Odnowa Earring +1', AugPath='A' },
        Ear2 = 'Ethereal Earring',
        Body = 'Mummu Jacket +2',
        Hands = 'Mummu Wrists +2',
        Ring1 = 'Vocane Ring',
        Ring2 = 'Rajas Ring',
        Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Phys. dmg. taken -10%', [2] = 'Accuracy+30', [3] = 'DEX+20', [4] = 'Attack+20', [5] = '"Dual Wield"+10' } },
        Waist = 'Flume Belt',
        Legs = 'Meg. Chausses +2',
        Feet = 'Mummu Gamash. +2',
    },
    ['Default'] = {
        Sub = 'Blurred Knife +1',
        Main = 'Kaja Knife',
        Range = { Name = 'Compensator', AugPath='B' },
        Ammo = 'Eminent Bullet',
        Head = { Name = 'Adhemar Bonnet', AugPath='A' },
        Neck = 'Defiant Collar',
        Ear1 = 'Suppanomimi',
        Ear2 = 'Eabani Earring',
        Body = 'Adhemar Jacket +1',
        Hands = { Name = 'Herculean Gloves', Augment = { [1] = 'Accuracy+25', [2] = 'Attack+14', [3] = '"Triple Atk."+3' } },
        Ring1 = 'Chirich Ring',
        Ring2 = 'Epona\'s Ring',
        Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Phys. dmg. taken -10%', [2] = 'Accuracy+30', [3] = 'DEX+20', [4] = 'Attack+20', [5] = '"Dual Wield"+10' } },
        Waist = { Name = 'Sailfi Belt +1', AugPath='A' },
        Legs = { Name = 'Samnuha Tights', Augment = { [1] = 'STR+9', [2] = '"Dbl.Atk."+2', [3] = '"Triple Atk."+2', [4] = 'DEX+8' } },
        Feet = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+20', [2] = 'Attack+10', [3] = 'AGI+8', [4] = '"Triple Atk."+3' } },
    },
    ['Acc'] = {
        Sub = 'Blurred Knife +1',
        Main = 'Kaja Knife',
        Range = { Name = 'Compensator', AugPath='B' },
        Ammo = 'Eminent Bullet',
        Head = 'Mummu Bonnet +2',
        Neck = 'Defiant Collar',
        Ear1 = 'Suppanomimi',
        Ear2 = 'Cessance Earring',
        Body = 'Adhemar Jacket +1',
        Hands = 'Mummu Wrists +2',
        Ring1 = 'Epona\'s Ring',
        Ring2 = 'Chirich Ring',
        Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Phys. dmg. taken -10%', [2] = 'Accuracy+30', [3] = 'DEX+20', [4] = 'Attack+20', [5] = '"Dual Wield"+10' } },
        Waist = { Name = 'Sailfi Belt +1', AugPath='A' },
        Legs = 'Meg. Chausses +2',
        Feet = 'Mummu Gamash. +2',
    },
    ['DT'] = {
        Sub = 'Blurred Knife +1',
        Main = 'Kaja Knife',
        Range = { Name = 'Anarchy', AugTrial=1783 },
        Ammo = 'Eminent Bullet',
        Head = 'Mummu Bonnet +2',
        Neck = 'Elite Royal Collar',
        Ear1 = { Name = 'Odnowa Earring +1', AugPath='A' },
        Ear2 = 'Suppanomimi',
        Body = 'Chasseur\'s Frac +2',
        Hands = 'Mummu Wrists +2',
        Ring1 = 'Vocane Ring',
        Ring2 = 'Chirich Ring',
        Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Phys. dmg. taken -10%', [2] = 'Accuracy+30', [3] = 'DEX+20', [4] = 'Attack+20', [5] = '"Dual Wield"+10' } },
        Waist = 'Flume Belt',
        Legs = 'Meg. Chausses +2',
        Feet = 'Mummu Gamash. +2',
    },
};
sets.Hybrid = {};
sets.Resting = {};
sets.Movement = {};

sets.Evisceration = {
    Head = 'Mummu Bonnet +2',
    Body = 'Mummu Jacket +2',
    Hands = 'Mummu Wrists +2',
    Legs = 'Samnuha Tights',
    Feet = 'Mummu Gamash. +2',
    Neck = 'Fotia Gorget',
    Ear1 = 'Moonshade Earring',
    Ear2 = 'Mache Earring',
    Ring1 = 'Epona\'s Ring',
    Ring2 = 'Rajas Ring',    
    Waist = 'Fotia Belt',
};
sets.Requiescat = {
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
};
sets.Savage_Blade = {
    Neck = 'Rep. Plat. Medal',
    Ear1 = 'Moonshade Earring',
};
sets.Ws_Default = {
    Ear1 = 'Moonshade Earring',
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
};

sets.PhantomRoll = {
    Head = 'Lanun Tricorne +1',
    Hands = 'Chasseur\'s Gants +1',
    Ring1 = 'Merirosvo Ring',
    Ring2 = 'Luzaf\'s Ring',
    Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Phys. dmg. taken -10%', [2] = 'Accuracy+30', [3] = 'DEX+20', [4] = 'Attack+20', [5] = '"Dual Wield"+10' } },
};
sets.QuickDraw = {};
sets.WildCard = {
    Feet = 'Lanun Bottes',
};
sets.RandomDeal = {
    Body = 'Lanun Frac',
};
sets.TripleShot = {
    Body = 'Chasseur\'s Frac +2',
};
sets.CuttingCards = {};
sets.CrookedCards = {};
--Snapshot and speed for ranged
sets.Preshot = {
    Hands = 'Manibozho Gloves',
    Legs = 'Nahtirah Trousers',
    Neck = 'Comm. Charm +1',

};
-- Recycle and ranged Accuracy and Attack
sets.Midshot = {
    Head = 'Mummu Bonnet +2',
    Neck = 'Comm. Charm +1',
    Body = 'Mummu Jacket +2',
    Hands = 'Mummu Wrists +2',
    Ear1 = 'Volley Earring',
    Ring1 = 'Paqichikaji Ring',
    Ring2 = 'Meghanada Ring',
    Legs = 'Meg. Chausses +2',
    Feet = 'Mummu Gamash. +2',
};

sets.WSShot = sets.Midshot

profile.Sets = sets;

profile.Packer = {
    {Name = 'Decimating Bullet', Quantity = 'all'},
    {Name = 'Dec. Bul. Pouch', Quantity = 'all'},
    {Name = 'Trump Card', Quantity = 'all'},
    {Name = 'Trump Card Case', Quantity = 'all'},
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.Initialize();
    
    gFunc.LockStyle(sets.Idle)
    gFunc.Disable('Range');
    -- Set macro book/set
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 10');
end

profile.OnUnload = function()
    gcinclude.Unload();
end


profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
	local player = gData.GetPlayer();
    local target = gData.GetTarget();

    if (player.Status == 'Engaged') and target then
        if (player.TP >= 1000) and (gcdisplay.GetToggle('Solomode') == true) and (gcinclude.CheckWsBailout() == true) then
            local mainWeapon = gData.GetEquipment().Main;
            local rangeWeapon = gData.GetEquipment().Range;
            if rangeWeapon.Name == 'Anarchy' then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Sniper Shot" <t>');
            elseif mainWeapon.Name == 'Blurred Knife +1' then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Savage Blade" <t>');
            elseif mainWeapon.Name == 'Kaja Knife' then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Evisceration" <t>');
            end
        end
        if gData.GetBuffCount('Tactician\'s Roll') == 0 and gcinclude.CheckAbilityRecast('Phantom Roll') == 0 and (gcdisplay.GetToggle('Solomode') == true) then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Tactician\'s Roll" <me>');
        elseif gData.GetBuffCount('Corsair\'s Roll') == 0 and gcinclude.CheckAbilityRecast('Phantom Roll') == 0 and (gcdisplay.GetToggle('Solomode') == true) then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Corsair\'s Roll" <me>');
        elseif gData.GetBuffCount('Haste Samba') == 0 and gcinclude.CheckAbilityRecast('Sambas') == 0 and (gcdisplay.GetToggle('Solomode') == true) and (player.TP >= 350) and player.SubJob == 'DNC' then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Haste Samba" <me>');
        end

        if (player.HPP >= 50) then
            gFunc.EquipSet(gcdisplay.GetCycle('MeleeSet'))
        elseif (player.HPP < 50) then
            gFunc.EquipSet(sets.DT)
        end
        
		if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    else
		gFunc.EquipSet(sets.Idle);
    end
	
    gcinclude.CheckDefault();
    gcinclude.AutoEngage();
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
    
end

profile.HandleAbility = function()
    local action = gData.GetAction();

    if (action.Name:contains('Roll')) then
        gFunc.EquipSet(sets.PhantomRoll);
        if (action.Name == 'Tactician\'s Roll') then gFunc.Equip('Body', 'Chasseur\'s Frac +2') end
    elseif (action.Name == 'Quick Draw') then
        gFunc.EquipSet(sets.QuickDraw);
    elseif (action.Name == 'Wild Card') then
        gFunc.EquipSet(sets.WildCard);
    elseif (action.Name == 'Random Deal') then
        gFunc.EquipSet(sets.RandomDeal);
    elseif (action.Name == 'Triple Shot') then
        gFunc.EquipSet(sets.TripleShot);
    elseif (action.Name == 'Cutting Cards') then
        gFunc.EquipSet(sets.CuttingCards);
    elseif (action.Name == 'Crooked Cards') then
        gFunc.EquipSet(sets.CrookedCards);
    end

    gcinclude.CheckCancels();
end

profile.HandleItem = function()
    local item = gData.GetAction();

	if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(gcinclude.sets.Holy_Water) end
end

profile.HandlePreshot = function()
    gFunc.EquipSet(sets.Preshot);
    gcinclude.CheckCancels();
end

profile.HandleMidshot = function()
    gFunc.EquipSet(sets.Midshot);
    gcinclude.CheckCancels();
end

profile.HandleWeaponskill = function()
    if (gcinclude.CheckWsBailout() == false) then gFunc.CancelAction() return;
    else
        local ws = gData.GetAction();        
        if string.match(ws.Name, 'Requiescat') then
            gFunc.EquipSet(sets.Requiescat)
        elseif string.match(ws.Name, 'Savage Blade') then
            gFunc.EquipSet(sets.Savage_Blade)
        elseif string.match(ws.Name, 'Evisceration') then
            gFunc.EquipSet(sets.Evisceration )
        elseif string.find(ws.Name, 'Shot') then
            gFunc.EquipSet(sets.WSShot)
        else
            gFunc.EquipSet(sets.Ws_Default)
        end
    end
end

return profile; 