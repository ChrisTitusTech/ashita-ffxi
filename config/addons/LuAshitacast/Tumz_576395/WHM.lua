local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');
local sets = {
    ['Idle'] = {
        Main = 'Queller Rod',
        Sub = 'Sors Shield',
        Ammo = 'Homiliary',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Clr. Torque +1',
        Ear1 = 'Moonshade Earring',
        Ear2 = 'Ethereal Earring',
        Body = 'Ebers Bliaut +2',
        Hands = 'Ebers Mitts +2',
        Ring1 = 'Vocane Ring',
        Ring2 = 'Prolix Ring',
        Back = { Name = 'Alaunus\'s Cape', Augment = {'MND+10','Eva.+20 /Mag. Eva.+20','MND+10','Enmity-10','Damage taken-5%'} },
        Waist = 'Cetl Belt',
        Legs = 'Ebers Pant. +2',
        Feet = 'Aya. Gambieras +2'
    },

    ['Dt'] = {
        Main = 'Queller Rod',
        Sub = 'Sors Shield',
        Ammo = 'Hasty Pinion +1',
        Head = 'Aya. Zucchetto +2',
        Body = 'Ayanmo Corazza +2',
        Hands = 'Aya. Manopolas +2',
        Legs = 'Aya. Cosciales +2',
        Feet = 'Aya. Gambieras +2',
        Neck = 'Asperity Necklace',
        Waist = 'Cetl Belt',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Cessance Earring',
        Ring1 = 'Vocane Ring',
        Ring2 = 'Rajas Ring',
        Back = { Name = 'Alaunus\'s Cape', Augment = {'MND+10','Eva.+20 /Mag. Eva.+20','MND+10','Enmity-10','Damage taken-5%'} }
    },
    
    ['Resting'] = {},
    
    ['Precast'] = {
        Ammo = 'Incantor Stone',
        Neck = 'Clr. Torque +1',
        Ear1 = 'Loquac. Earring',
        Ear2 = 'Orison Earring',
        Hands = 'Gende. Gages +1',
        Ring1 = 'Prolix Ring',
        Back = 'Swith Cape',
        Waist = 'Witful Belt',
        Legs = 'Aya. Cosciales +2',
        Feet = 'Theo. Duckbills +1'
    },

    ['Midcast'] = {
        ['Cure'] = {
            Ammo = 'Staunch Tathlum',
            Head = 'Ebers Cap +1',
            Neck = 'Clr. Torque +1',
            Ear1 = 'Roundel Earring',
            Ear2 = 'Orison Earring',
            Body = 'Ebers Bliaut +2',
            Hands = 'Telchine Gloves',
            Ring1 = 'Sirona\'s Ring',
            Ring2 = 'Ephedra Ring',
            Back = { Name = 'Alaunus\'s Cape', Augment = {'MND+10','Eva.+20 /Mag. Eva.+20','MND+10','Enmity-10','Damage taken-5%'} },
            Waist = 'Witful Belt',
            Legs = 'Ebers Pant. +2',
            Feet = 'Theo. Duckbills +1'
        },
        
        ['Enhancing_Magic'] = {
            Ammo = 'Staunch Tathlum',
            Head = 'Ebers Cap +1',
            Neck = 'Clr. Torque +1',
            Ear1 = 'Roundel Earring',
            Ear2 = 'Orison Earring',
            Body = 'Piety Bliaut +1',
            Hands = 'Ebers Mitts +2',
            Ring1 = 'Sirona\'s Ring',
            Ring2 = 'Ephedra Ring',
            Back = { Name = 'Alaunus\'s Cape', Augment = {'MND+10','Eva.+20 /Mag. Eva.+20','MND+10','Enmity-10','Damage taken-5%'} },
            Waist = 'Witful Belt',
            Legs = 'Piety Pantaloons',
            Feet = 'Theo. Duckbills +1'
        },

        ['Regen'] = {
            Legs = 'Theo. Pant.+1',
        },

        ['Elemental_Magic'] = {
            Ammo = 'Kalboron Stone',
            Head = 'Aya. Zucchetto +2',
            Neck = 'Sanctity Necklace',
            Ear1 = 'Friomisi Earring',
            Ear2 = 'Hecate\'s Earring',
            Body = 'Witching Robe',
            Hands = 'Fanatic Gloves',
            Ring1 = 'Strendu Ring',
            Ring2 = 'Vertigo Ring',
            Back = 'Toro Cape',
            Waist = 'Hachirin-no-Obi',
            Legs = 'Ebers Pant. +2',
            Feet = 'Theo. Duckbills +1'
        }
    },

    ['Tp_Default'] = {
        Main = 'Queller Rod',
        Sub = 'Sors Shield',
        Ammo = 'Hasty Pinion +1',
        Head = 'Aya. Zucchetto +2',
        Body = 'Ayanmo Corazza +2',
        Hands = 'Aya. Manopolas +2',
        Legs = 'Aya. Cosciales +2',
        Feet = 'Aya. Gambieras +2',
        Neck = 'Asperity Necklace',
        Waist = 'Cetl Belt',
        Ear1 = 'Brutal Earring',
        Ear2 = 'Cessance Earring',
        Ring1 = 'Chirich Ring',
        Ring2 = 'Rajas Ring',
        Back = { Name = 'Alaunus\'s Cape', Augment = {'MND+10','Eva.+20 /Mag. Eva.+20','MND+10','Enmity-10','Damage taken-5%'} }
    },

    ['Movement'] = {},
    ['Weaponskill'] = {},
    ['Afflatus_Solace'] = {
        Body = 'Ebers Bliaut +2',
    },
};
profile.Sets = sets;

profile.Packer = {
    'Echo Drops',
    'Holy Water',
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.Initialize();

    AshitaCore:GetChatManager():QueueCommand(1, '/alias /stat /lac fwd status');

    -- Set macro book/set
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 1');
end

profile.OnUnload = function()
    AshitaCore:GetChatManager():QueueCommand(1, '/alias /del /stat');
    gcinclude.Unload();
end

local function handleStatusRemoval()
    local target = gData.GetActionTarget();
    if not target then return false end
    
    local buffs = AshitaCore:GetMemoryManager():GetPlayer():GetBuffs(target.TargetIndex);
    if not buffs then return false end

    -- Priority order for status removal
    for i = 1, 32 do
        local buffId = buffs[i];
        -- Paralysis
        if buffId == 4 then
            AshitaCore:GetChatManager():QueueCommand(1, '/ma "Paralyna" <t>');
            return true;
        -- Silence
        elseif buffId == 6 then
            AshitaCore:GetChatManager():QueueCommand(1, '/ma "Silena" <t>');
            return true;
        -- Curse
        elseif buffId == 8 then
            AshitaCore:GetChatManager():QueueCommand(1, '/ma "Cursna" <t>');
            return true;
        -- Stone/Petrification
        elseif buffId == 10 then
            AshitaCore:GetChatManager():QueueCommand(1, '/ma "Stona" <t>');
            return true;
        -- Poison
        elseif buffId == 3 then
            AshitaCore:GetChatManager():QueueCommand(1, '/ma "Poisona" <t>');
            return true;
        -- Disease
        elseif buffId == 7 then
            AshitaCore:GetChatManager():QueueCommand(1, '/ma "Viruna" <t>');
            return true;
        -- Blind
        elseif buffId == 5 then
            AshitaCore:GetChatManager():QueueCommand(1, '/ma "Blindna" <t>');
            return true;
        elseif buffId == 13 then
            AshitaCore:GetChatManager():QueueCommand(1, '/ma "Erase" <t>');
            return true;
        end
    end
    return false;
end

profile.HandleCommand = function(args)
    if (args[1] == 'cure' or args[1] == 'status') then
        handleStatusRemoval();
        return;
    end
    
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
	local player = gData.GetPlayer();
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.Tp_Default)
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

    if (action.Name == 'Afflatus Solace') then
        gFunc.EquipSet(sets.Afflatus_Solace);
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
    local weather = gData.GetEnvironment();
    local player = gData.GetPlayer();
    local spell = gData.GetAction();
    local target = gData.GetActionTarget();
    local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Midcast.Enhancing_Magic);
        if string.contains(spell.Name, 'Regen') then
            gFunc.EquipSet(sets.Midcast.Regen);
        end
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Midcast.Cure);
        if string.match(spell.Name, 'Cursna') then
            gFunc.EquipSet(sets.Midcast.Cursna);
        end
    elseif (spell.Skill == 'Elemental Magic') then
        gFunc.EquipSet(sets.Midcast.Elemental_Magic);
        if (spell.Element == weather.WeatherElement) or (spell.Element == weather.DayElement) then
            gFunc.Equip('Waist', 'Hachirin-no-Obi');
        end
    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Midcast.Enfeebling_Magic);
    end

	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
end

profile.HandleWeaponskill = function()
    local canWS = gcinclude.CheckWsBailout();
    if (canWS == false) then gFunc.CancelAction() return;
    else gFunc.EquipSet(sets.Ws_Default) end
end

return profile; 