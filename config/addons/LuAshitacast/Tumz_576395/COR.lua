local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');
gcheals = gFunc.LoadFile('common\\gcheals.lua');
gcrolls = gFunc.LoadFile('common\\gcrolls.lua');
gcinclude.sets.Sleeping = { Range = 'Earp' }
local sets = {};
local Setweapon = 'Naegling';
local player = gData.GetPlayer();
if player.SubJob == 'DNC' or player.SubJob == 'NIN' then 
            Setoffhand = 'Rostam';
        else
            Setoffhand = 'Ark Shield';
        end
local Setrange = 'Ataktos';
sets.Weapons = {
    Main = Setweapon,
    Sub = Setoffhand,
    Range = Setrange,
};
gcinclude.sets.TH = {
    Hands = { Name = 'Herculean Gloves', Augment = { [1] = 'Pet: INT+10', [2] = '"Treasure Hunter"+1', [3] = 'Accuracy+8', [4] = '"Mag. Atk. Bns."+18', [5] = 'Attack+8', [6] = 'Mag. Acc.+18' } },
    Feet = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+24', [2] = 'Pet: DEX+8', [3] = 'Attack+1', [4] = '"Treasure Hunter"+1' } },
};
sets.Refresh = {};
sets.Idle = {
    Main = Setweapon,
    Sub = Setoffhand,
    Range = Setrange,
    Ammo = 'Eminent Bullet',
    Head = 'Chass. Tricorne +2',
    Neck = 'Bathy Choker +1',
    Ear1 = { Name = 'Odnowa Earring +1', AugPath='A' },
    Ear2 = 'Ethereal Earring',
    Body = 'Chasseur\'s Frac +2',
    Hands = 'Chasseur\'s Gants +3',
    Ring1 = 'Shneddick Ring',
    Ring2 = 'Chirich Ring',
    Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Phys. dmg. taken -10%', [2] = 'Accuracy+30', [3] = 'DEX+20', [4] = 'Attack+20', [5] = '"Dual Wield"+10' } },
    Waist = 'Plat. Mog. Belt',
    Legs = 'Chas. Culottes +3',
    Feet = 'Chass. Bottes +2',
};
sets.Default = {
    Main = Setweapon,
    Sub = Setoffhand,
    Range = Setrange,
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
    Feet = 'Herculean Boots',
};
sets.Acc = {
    Main = Setweapon,
    Sub = Setoffhand,
    Range = Setrange,
    Ammo = 'Eminent Bullet',
    Head = 'Chass. Tricorne +2',
    Neck = 'Defiant Collar',
    Ear1 = 'Cessance Earring',
    Ear2 = 'Telos Earring',
    Body = 'Adhemar Jacket +1',
    Hands = 'Chasseur\'s Gants +3',
    Ring1 = 'Chirich Ring',
    Ring2 = 'Epona\'s Ring',
    Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Phys. dmg. taken -10%', [2] = 'Accuracy+30', [3] = 'DEX+20', [4] = 'Attack+20', [5] = '"Dual Wield"+10' } },
    Waist = { Name = 'Sailfi Belt +1', AugPath='A' },
    Legs = 'Chas. Culottes +3',
    Feet = 'Chass. Bottes +2',
};
sets.DT = {
    Main = Setweapon,
    Sub = Setoffhand,
    Range = Setrange,
    Ammo = 'Eminent Bullet',
    Head = 'Chass. Tricorne +2',
    Neck = 'Elite Royal Collar',
    Ear1 = { Name = 'Odnowa Earring +1', AugPath='A' },
    Ear2 = 'Suppanomimi',
    Body = 'Chasseur\'s Frac +2',
    Hands = { Name = 'Herculean Gloves', Augment = { [1] = 'Accuracy+25', [2] = 'Attack+14', [3] = '"Triple Atk."+3' } },
    Ring1 = 'Chirich Ring',
    Ring2 = 'Meghanada Ring',
    Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Phys. dmg. taken -10%', [2] = 'Accuracy+30', [3] = 'DEX+20', [4] = 'Attack+20', [5] = '"Dual Wield"+10' } },
    Waist = { Name = 'Sailfi Belt +1', AugPath='A' },
    Legs = 'Chas. Culottes +3',
    Feet = 'Herculean Boots',
};
sets.Hybrid = {
    Main = Setweapon,
    Sub = Setoffhand,
    Range = Setrange,
    Ammo = 'Eminent Bullet',
    Head = 'Chass. Tricorne +2',
    Neck = 'Defiant Collar',
    Ear1 = 'Suppanomimi',
    Ear2 = 'Eabani Earring',
    Body = 'Adhemar Jacket +1',
    Hands = { Name = 'Herculean Gloves', Augment = { [1] = 'Accuracy+25', [2] = 'Attack+14', [3] = '"Triple Atk."+3' } },
    Ring1 = 'Epona\'s Ring',
    Ring2 = 'Chirich Ring',
    Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Phys. dmg. taken -10%', [2] = 'Accuracy+30', [3] = 'DEX+20', [4] = 'Attack+20', [5] = '"Dual Wield"+10' } },
    Waist = { Name = 'Sailfi Belt +1', AugPath='A' },
    Legs = 'Chas. Culottes +3',
    Feet = 'Herculean Boots',

};
sets.Resting = {};
gcinclude.sets.Movement = {
    Ring1 = 'Shneddick Ring',
};

sets.Evisceration = {
    Head = 'Adhemar Bonnet',
    Body = 'Laksa. Frac +2',
    Hands = 'Chasseur\'s Gants +3',
    Legs = 'Meg. Chausses +2',
    Feet = 'Mummu Gamash. +2',
    Neck = 'Fotia Gorget',
    Ear1 = 'Moonshade Earring',
    Ear2 = 'Brutal Earring',
    Ring1 = 'Epona\'s Ring',
    Ring2 = 'Cornelia\'s Ring',
    Waist = 'Fotia Belt',
    Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Mag. Acc.+20', [2] = 'Weapon skill damage +10%', [3] = 'Magic Damage+20', [4] = 'AGI+20', [5] = 'Magic Damage +10' } },
};
sets.Requiescat = {
    Body = 'Laksa. Frac +2',
    Hands = 'Chasseur\'s Gants +3',
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
    Ear1 = 'Moonshade Earring',
    Ring1 = 'Cornelia\'s Ring',
    Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Mag. Acc.+20', [2] = 'Weapon skill damage +10%', [3] = 'Magic Damage+20', [4] = 'AGI+20', [5] = 'Magic Damage +10' } },
};
sets.Savage_Blade = {
    Body = 'Nyame Mail',
    Hands = 'Chasseur\'s Gants +3',
    Legs = 'Nyame Flanchard',
    Feet = 'Lanun Bottes +3',
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
    Ear1 = 'Moonshade Earring',
    Ring1 = 'Cornelia\'s Ring',
    Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Mag. Acc.+20', [2] = 'Weapon skill damage +10%', [3] = 'Magic Damage+20', [4] = 'AGI+20', [5] = 'Magic Damage +10' } },
};
sets.Ws_Default = {
    Ear1 = 'Moonshade Earring',
    Ring1 = 'Cornelia\'s Ring',
    Neck = 'Fotia Gorget',
    Body = 'Laksa. Frac +2',
    Hands = 'Chasseur\'s Gants +3',
    Feet = 'Lanun Bottes +3',
    Legs = 'Nyame Flanchard',
    Waist = 'Fotia Belt',
    Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Mag. Acc.+20', [2] = 'Weapon skill damage +10%', [3] = 'Magic Damage+20', [4] = 'AGI+20', [5] = 'Magic Damage +10' } },
};

sets.PhantomRoll = {
    Head = 'Lanun Tricorne +1',
    Hands = 'Chasseur\'s Gants +3',
    Back = 'Gunslinger\'s Cape',
    Ring1 = 'Barataria Ring',
    Ring2 = 'Luzaf\'s Ring',
};
sets.PhantomWeaps = {
    Main = 'Rostam',
    Range = 'Compensator',
};
sets.WildCard = {
    Feet = 'Lanun Bottes +3',
};
sets.RandomDeal = {
    Body = 'Lanun Frac +1',
};
sets.TripleShot = {
    Body = 'Chasseur\'s Frac +2',
};
sets.CuttingCards = {};
sets.CrookedCards = {};
--Snapshot and speed for ranged
sets.Preshot = {
    Head = 'Chass. Tricorne +2',
    Body = 'Laksa. Frac +2',
    Hands = 'Manibozho Gloves',
    Legs = 'Adhemar Kecks',
    Feet = 'Meg. Jam. +2',
    Ear1 = 'Volley Earring',
    Neck = 'Comm. Charm +1',
    Waist = 'Impulse Belt',
    Back = 'Gunslinger\'s Cape',

};
-- Recycle and ranged Accuracy and Attack
sets.Midshot = {
    Head = 'Chass. Tricorne +2',
    Neck = 'Comm. Charm +1',
    Body = 'Chasseur\'s Frac +2',
    Hands = 'Chasseur\'s Gants +3',
    Ear1 = 'Volley Earring',
    Ring1 = 'Paqichikaji Ring',
    Ring2 = 'Meghanada Ring',
    Legs = 'Chas. Culottes +3',
    Feet = 'Chass. Bottes +2',
    Back = 'Gunslinger\'s Cape',
};
sets.QuickDrawAdd = {
    Head = 'Chass. Tricorne +2',
    Neck = 'Comm. Charm +1',
    Body = 'Chasseur\'s Frac +2',
    Hands = 'Chasseur\'s Gants +3',
    Legs = 'Chas. Culottes +3',
    Feet = 'Chass. Bottes +2',
};
sets.QuickDraw = gFunc.Combine(sets.Midshot, sets.QuickDrawAdd);
sets.WSShot = sets.Midshot
sets.LastStandAdd = {
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
    Body = 'Laksa. Frac +2',
    Hands = 'Chasseur\'s Gants +3',
    Ear2 = 'Moonshade Earring',
    Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Mag. Acc.+20', [2] = 'Weapon skill damage +10%', [3] = 'Magic Damage+20', [4] = 'AGI+20', [5] = 'Magic Damage +10' } },
};
sets.LastStand = gFunc.Combine(sets.Midshot, sets.LastStandAdd);
sets.WildfireAdd = {
    Ear1 = 'Friomisi Earring',
    Ear2 = 'Moonshade Earring',
    Ring1 = 'Sangoma Ring',
    Ring2 = 'Chirich Ring',
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
    Head = 'Nyame Helm',
    Body = 'Laksa. Frac +2',
    Hands = 'Chasseur\'s Gants +3',
    Legs = 'Nyame Flanchard',
    Feet = 'Lanun Bottes +3',
    Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Mag. Acc.+20', [2] = 'Weapon skill damage +10%', [3] = 'Magic Damage+20', [4] = 'AGI+20', [5] = 'Magic Damage +10' } },
};
sets.Wildfire = gFunc.Combine(sets.Midshot, sets.WildfireAdd);
sets.AeolianEdge = sets.WildfireAdd;
sets.LeadenSaluteAdd = {
    -- Magic Attack Bonus Gear
    Ear1 = 'Friomisi Earring',
    Ear2 = 'Moonshade Earring',
    Ring1 = 'Sangoma Ring',
    Ring2 = 'Archon Ring',
    Neck = 'Fotia Gorget',
    Waist = 'Fotia Belt',
    Head = 'Pixie Hairpin +1',
    Body = 'Nyame Mail',
    Hands = 'Nyame Gauntlets',
    Legs = 'Nyame Flanchard',
    Feet = 'Lanun Bottes +3',
    Back = { Name = 'Camulus\'s Mantle', Augment = { [1] = 'Mag. Acc.+20', [2] = 'Weapon skill damage +10%', [3] = 'Magic Damage+20', [4] = 'AGI+20', [5] = 'Magic Damage +10' } },

};
sets.LeadenSalute = gFunc.Combine(sets.Midshot, sets.LeadenSaluteAdd);
sets.LockStyleAdd = {
    Head = 'Lanun Tricorne +1',
    Body = 'Lanun Frac +1',
    Feet = 'Lanun Bottes +3',
}
sets.LockStyle = gFunc.Combine(sets.Idle, sets.LockStyleAdd);
profile.Sets = sets;

profile.Packer = {
    {Name = 'Eminent Bullet', Quantity = 'all'},
    --{Name = 'Em. Bul. Pouch', Quantity = 'all'},
    {Name = 'Trump Card', Quantity = 'all'},
    {Name = 'Trump Card Case', Quantity = 'all'},
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    gcinclude.Initialize();
    
    gFunc.LockStyle(sets.LockStyle)
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 4');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 10');
end

profile.OnUnload = function()
    gcinclude.Unload();
end

profile.CountRolls = function()
    -- Count the number of runes active on the player
    local rollList = { 
        'Corsair\'s Roll', 'Ninja Roll', 'Hunter\'s Roll', 'Chaos Roll', 'Magus\'s Roll',
        'Healer\'s Roll', 'Drachen Roll', 'Choral Roll', 'Monk\'s Roll', 'Beast Roll',
        'Samurai Roll', 'Evoker\'s Roll', 'Rogue\'s Roll', 'Warlock\'s Roll', 'Fighter\'s Roll',
        'Puppet Roll', 'Gallant\'s Roll', 'Wizard\'s Roll', 'Dancer\'s Roll', 'Scholar\'s Roll',
        'Naturalist\'s Roll', 'Runeist\'s Roll', 'Bolter\'s Roll', 'Caster\'s Roll', 'Courser\'s Roll',
        'Blitzer\'s Roll', 'Tactician\'s Roll', 'Allies\' Roll', 'Miser\'s Roll', 'Companion\'s Roll',
        'Avenger\'s Roll'
    };
    local rollCount = 0;
    
    -- Check for each roll in the list
    for i = 1, #rollList do
        local rollName = rollList[i];
        -- Check if this roll is active
        if gData.GetBuffCount(rollName) > 0 then
            rollCount = rollCount + 1;
        end
    end

    return rollCount;
end

profile.SoloMode = function()
    local player = gData.GetPlayer();
    if gcinclude.CheckWsBailout() == true and player.HPP > 35 and player.TP > 1000 then
        if gData.GetEquipment().Ammo and Setoffhand ~= 'Naegling' and Setweapon ~= 'Naegling' and player.TP > 1000 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Leaden Salute" <t>');
        elseif (player.HPP > 50) and gData.GetEquipment().Main.Name == 'Naegling' and player.TP > 1500 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Savage Blade" <t>');
        elseif gData.GetEquipment().Main and (player.HPP <= 50) and gData.GetEquipment().Main.Name == 'Naegling' and player.TP > 1000 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Sanguine Blade" <t>');
        elseif gData.GetEquipment().Ammo  and player.TP > 2000 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Leaden Salute" <t>');
        elseif not gData.GetEquipment().Ammo and player.TP > 1000 then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Evisceration" <t>');
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

profile.AutoRolls = function ()
    if gData.GetBuffCount('Samurai Roll') == 0 and gcinclude.CheckAbilityRecast('Phantom Roll') == 0 and gData.GetBuffCount('Double-Up Chance') == 0 and gcdisplay.GetCycle('Roll1') == 'Samurai' then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Samurai Roll" <me>');
    elseif gData.GetBuffCount('Corsair\'s Roll') == 0 and gcinclude.CheckAbilityRecast('Phantom Roll') == 0 and gData.GetBuffCount('Double-Up Chance') == 0 and gcdisplay.GetCycle('Roll1') == 'EXP' then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Corsair\'s Roll" <me>');
    elseif gData.GetBuffCount('Evoker\'s Roll') == 0 and gcinclude.CheckAbilityRecast('Phantom Roll') == 0 and gData.GetBuffCount('Double-Up Chance') == 0 and gcdisplay.GetCycle('Roll1') == 'Evoker' then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Evoker\'s Roll" <me>');
    elseif gData.GetBuffCount('Hunter\'s Roll') == 0 and gcinclude.CheckAbilityRecast('Phantom Roll') == 0 and gData.GetBuffCount('Double-Up Chance') == 0 and gcdisplay.GetCycle('Roll1') == 'Hunter' then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Hunter\'s Roll" <me>');

    elseif gData.GetBuffCount('Chaos Roll') == 0 and gcinclude.CheckAbilityRecast('Phantom Roll') == 0 and gData.GetBuffCount('Double-Up Chance') == 0 and gcdisplay.GetCycle('Roll2') == 'Chaos' then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Chaos Roll" <me>');
    elseif gData.GetBuffCount('Tactician\'s Roll') == 0 and gcinclude.CheckAbilityRecast('Phantom Roll') == 0 and gData.GetBuffCount('Double-Up Chance') == 0 and gcdisplay.GetCycle('Roll2') == 'Tactician' then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Tactician\'s Roll" <me>');
    elseif gData.GetBuffCount('Wizard\'s Roll') == 0 and gcinclude.CheckAbilityRecast('Phantom Roll') == 0 and gData.GetBuffCount('Double-Up Chance') == 0 and gcdisplay.GetCycle('Roll2') == 'MAB' then
        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Wizard\'s Roll" <me>');
    end
end

profile.Weapons = function ()
    local player = gData.GetPlayer();
    if (gcdisplay.GetCycle('Weapon') == 'Primary') and (Setrange ~= 'Ataktos') then
        Setweapon = 'Naegling';
        if player.SubJob == 'DNC' or player.SubJob == 'NIN' then 
            Setoffhand = 'Rostam';
        else
            Setoffhand = 'Ark Shield';
        end
        Setrange = 'Ataktos';
        for _, set in ipairs({'Weapons', 'Hybrid', 'Idle', 'Acc', 'DT', 'Default'}) do
            sets[set].Main = Setweapon
            sets[set].Sub = Setoffhand
            sets[set].Range = Setrange
        end
        gFunc.EquipSet(sets.Weapons)
    elseif (gcdisplay.GetCycle('Weapon') == 'Secondary') and (Setrange ~= 'Compensator') then
        Setweapon = 'Rostam';
        if player.SubJob == 'DNC' or player.SubJob == 'NIN' then 
            Setoffhand = 'Blurred Knife +1';
        else
            Setoffhand = 'Ark Shield';
        end
        Setrange = 'Compensator';
        for _, set in ipairs({'Weapons', 'Hybrid', 'Idle', 'Acc', 'DT', 'Default'}) do
            sets[set].Main = Setweapon
            sets[set].Sub = Setoffhand
            sets[set].Range = Setrange
        end
        gFunc.EquipSet(sets.Weapons)
    elseif gcdisplay.GetCycle('Weapon') == 'Third' and Setrange ~= 'Holliday' then
        Setweapon = 'Naegling';
        if player.SubJob == 'DNC' or player.SubJob == 'NIN' then 
            Setoffhand = 'Rostam';
        else
            Setoffhand = 'Ark Shield';
        end
        Setrange = 'Holliday';
        for _, set in ipairs({'Weapons', 'Hybrid', 'Idle', 'Acc', 'DT', 'Default'}) do
            sets[set].Main = Setweapon
            sets[set].Sub = Setoffhand
            sets[set].Range = Setrange
        end
        gFunc.EquipSet(sets.Weapons)
    end
    
end


profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
	local player = gData.GetPlayer();
    if gcdisplay.GetToggle('Solo') == true and player.Status == 'Engaged' then profile.SoloMode() end;
    if player.Status == 'Engaged' and gcdisplay.GetToggle('Rolls') == true then profile.AutoRolls() end;
    profile.Weapons();
    gcinclude.CheckDefault();
    gcinclude.AutoEngage();
    
end

profile.HandleAbility = function()
    local action = gData.GetAction();
    local player = gData.GetPlayer();
    local quickDraws = {
        'Light Shot',
        'Dark Shot',
        'Fire Shot',
        'Water Shot',
        'Thunder Shot',
        'Earth Shot',
        'Wind Shot',
        'Ice Shot'
    };

    if (action.Name:contains('Roll')) or action.Name == 'Double-Up' then
        if player.Status ~= 'Engaged' then gFunc.EquipSet(sets.PhantomWeaps) end
        gFunc.EquipSet(sets.PhantomRoll);
        if (action.Name == 'Tactician\'s Roll') then gFunc.Equip('Body', 'Chasseur\'s Frac +2') end
    elseif (action.Name == 'Quick Draw' or table.contains(quickDraws, action.Name)) then
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
        elseif string.match(ws.Name, 'Last Stand') then
            gFunc.EquipSet(sets.LastStand)
        elseif string.match(ws.Name, 'Wildfire') then
            gFunc.EquipSet(sets.Wildfire)
        elseif string.match(ws.Name, 'Leaden Salute') then
            gFunc.EquipSet(sets.LeadenSalute)
        elseif string.find(ws.Name, 'Shot') then
            gFunc.EquipSet(sets.WSShot)
        elseif string.find(ws.Name, 'Aeolian Edge') then
            gFunc.EquipSet(sets.AeolianEdge)
        else
            gFunc.EquipSet(sets.Ws_Default)
        end
    end
end

return profile; 