local gcinclude = T {};

--[[
Only edit the next two small sections here. See the readme on my github for more information on usages for my profiles.

These are universal sets for things like doomed or asleep; avoid main/sub/range/ammo here.
The second section is a couple basic settings to decide on whether or not to use you the automatic equiping function of idle regen, idle refresh, DT gear etc.
More details in each section.
]]
gcinclude.sets = T {
	Doomed = { -- this set will equip any time you have the doom status
		Ring1 = 'Purity Ring',
		Waist = 'Gishdubar Sash',
	},
	Holy_Water = { -- update with whatever gear you use for the Holy Water item
		Ring1 = 'Purity Ring',
		Ring2 = 'Blenmot\'s Ring',
	},
	Sleeping = { -- this set will auto equip if you are asleep
	},
	Fishing = { -- this set is meant as a default set for fishing, equip using /fishset
		Range = 'Lu Shang\'s F. Rod',
		Ammo = 'Sinking Minnow',
		--Ring2 = 'Pelican Ring',
	},
	Movement = {
	},
};
gcinclude.settings = {
	--[[
	You can also set any of these on a per job basis in the job file in the OnLoad function. See my COR job file to see how this is done
	but as an example you can just put 'gcinclude.settings.RefreshGearMPP = 50;' in your job files OnLoad function to modify for that job only
	]]
	Messages = true,             --set to true if you want chat log messages to appear on any /gc command used such as DT, TH, or KITE gear toggles, certain messages will always appear
	AutoGear = true,             --set to false if you dont want DT/Regen/Refresh/PetDT gear to come on automatically at the defined %'s here
	WScheck = true,               --set to false if you dont want to use the WSdistance safety check
	WSdistance = 8,               --default max distance (yalms) to allow non-ranged WS to go off at if the above WScheck is true
	RegenGearHPP = 60,            -- set HPP to have your idle regen set to come on
	RefreshGearMPP = 70,          -- set MPP to have your idle refresh set to come on
	DTGearHPP = 40,               -- set HPP to have your DT set to come on
	PetDTGearHPP = 50,            -- set pet HPP to have your PetDT set to come on
	Tele_Ring = 'Dim. Ring (Mea)', -- put your tele ring in here
	LastForbiddenKey = 0,         -- timestamp for last Forbidden Key usage
};

--[[
Everything else in this file should not be editted by anyone trying to use my profiles. You really just want to update the various gear sets
in each individual job lua file. Unless you know what you're doing then it is best to leave everything below this line alone, the rest here are various functions and arrays etc.
]]
gcdisplay = gFunc.LoadFile('common\\gcdisplay.lua');
gcmovement = gFunc.LoadFile('common\\gcmovement.lua');

gcinclude.AliasList = T { 'gcmessages', 'wsdistance', 'setcycle', 'meleeset', 'setweapon', 'setprime', 'solo', 'th', 'kite', 'warpring', 'telering', 'fishset', 'autoheal', 'roll1', 'roll2', 'autoroll','cureself' };
gcinclude.Towns = T { 'Tavnazian Safehold', 'Al Zahbi', 'Aht Urhgan Whitegate', 'Nashmau', 'Southern San d\'Oria [S]', 'Bastok Markets [S]', 'Windurst Waters [S]', 'San d\'Oria-Jeuno Airship', 'Bastok-Jeuno Airship', 'Windurst-Jeuno Airship', 'Kazham-Jeuno Airship', 'Southern San d\'Oria', 'Northern San d\'Oria', 'Port San d\'Oria', 'Chateau d\'Oraguille', 'Bastok Mines', 'Bastok Markets', 'Port Bastok', 'Metalworks', 'Windurst Waters', 'Windurst Walls', 'Port Windurst', 'Windurst Woods', 'Heavens Tower', 'Ru\'Lude Gardens', 'Upper Jeuno', 'Lower Jeuno', 'Port Jeuno', 'Rabao', 'Selbina', 'Mhaura', 'Kazham', 'Norg', 'Mog Garden', 'Celennia Memorial Library', 'Western Adoulin', 'Eastern Adoulin' };
gcinclude.LockingRings = T { 'Echad Ring', 'Trizek Ring', 'Endorsement Ring', 'Capacity Ring', 'Warp Ring', 'Facility Ring', 'Dim. Ring (Dem)', 'Dim. Ring (Mea)', 'Dim. Ring (Holla)' };
gcinclude.DistanceWS = T { 'Flaming Arrow', 'Piercing Arrow', 'Dulling Arrow', 'Sidewinder', 'Blast Arrow', 'Arching Arrow', 'Empyreal Arrow', 'Refulgent Arrow', 'Apex Arrow', 'Namas Arrow', 'Jishnu\'s Randiance', 'Hot Shot', 'Split Shot', 'Sniper Shot', 'Slug Shot', 'Blast Shot', 'Heavy Shot', 'Detonator', 'Numbing Shot', 'Last Stand', 'Coronach', 'Wildfire', 'Trueflight', 'Leaden Salute', 'Myrkr', 'Dagan', 'Moonlight', 'Starlight' };
gcinclude.BstPetAttack = T { 'Foot Kick', 'Whirl Claws', 'Big Scissors', 'Tail Blow', 'Blockhead', 'Sensilla Blades', 'Tegmina Buffet', 'Lamb Chop', 'Sheep Charge', 'Pentapeck', 'Recoil Dive', 'Frogkick', 'Queasyshroom', 'Numbshroom', 'Shakeshroom', 'Nimble Snap', 'Cyclotail', 'Somersault', 'Tickling Tendrils', 'Sweeping Gouge', 'Grapple', 'Double Claw', 'Spinning Top', 'Suction', 'Tortoise Stomp', 'Power Attack', 'Rhino Attack', 'Razor Fang', 'Claw Cyclone', 'Crossthrash', 'Scythe Tail', 'Ripper Fang', 'Chomp Rush', 'Pecking Flurry', 'Sickle Slash', 'Mandibular Bite', 'Wing Slap', 'Beak Lunge', 'Head Butt', 'Wild Oats', 'Needle Shot', 'Disembowel', 'Extirpating Salvo', 'Mega Scissors', 'Back Heel', 'Hoof Volley', 'Fluid Toss', 'Fluid Spread' };
gcinclude.BstPetMagicAttack = T { 'Gloom Spray', 'Fireball', 'Acid Spray', 'Molting Plumage', 'Cursed Sphere', 'Nectarous Deluge', 'Charged Whisker', 'Nepenthic Plunge', 'Entomb', 'Subduction', 'Tenebral Crush', 'Spectral Floe', 'Tem. Upheaval', 'Embalming Earth' };
gcinclude.BstPetMagicAccuracy = T { 'Toxic Spit', 'Acid Spray', 'Leaf Dagger', 'Venom Spray', 'Venom', 'Dark Spore', 'Sandblast', 'Dust Cloud', 'Stink Bomb', 'Slug Family', 'Intimidate', 'Gloeosuccus', 'Spider Web', 'Filamented Hold', 'Choke Breath', 'Blaster', 'Snow Cloud', 'Roar', 'Palsy Pollen', 'Spore', 'Brain Crush', 'Choke Breath', 'Silence Gas', 'Chaotic Eye', 'Sheep Song', 'Soporific', 'Predatory Glare', 'Sudden Lunge', 'Numbing Noise', 'Jettatura', 'Bubble Shower', 'Spoil', 'Scream', 'Noisome Powder', 'Acid Mist', 'Rhinowrecker', 'Swooping Frenzy', 'Venom Shower', 'Corrosive Ooze', 'Spiral Spin', 'Infrasonics', 'Hi-Freq Field', 'Purulent Ooze', 'Foul Waters', 'Sandpit', 'Infected Leech', 'Pestilent Plume' };
gcinclude.SmnSkill = T { 'Shining Ruby', 'Glittering Ruby', 'Crimson Howl', 'Inferno Howl', 'Frost Armor', 'Crystal Blessing', 'Aerial Armor', 'Hastega II', 'Fleet Wind', 'Hastega', 'Earthen Ward', 'Earthen Armor', 'Rolling Thunder', 'Lightning Armor', 'Soothing Current', 'Ecliptic Growl', 'Heavenward Howl', 'Ecliptic Howl', 'Noctoshield', 'Dream Shroud', 'Altana\'s Favor', 'Reraise', 'Reraise II', 'Reraise III', 'Raise', 'Raise II', 'Raise III', 'Wind\'s Blessing' };
gcinclude.SmnMagical = T { 'Searing Light', 'Meteorite', 'Holy Mist', 'Inferno', 'Fire II', 'Fire IV', 'Meteor Strike', 'Conflag Strike', 'Diamond Dust', 'Blizzard II', 'Blizzard IV', 'Heavenly Strike', 'Aerial Blast', 'Aero II', 'Aero IV', 'Wind Blade', 'Earthen Fury', 'Stone II', 'Stone IV', 'Geocrush', 'Judgement Bolt', 'Thunder II', 'Thunder IV', 'Thunderstorm', 'Thunderspark', 'Tidal Wave', 'Water II', 'Water IV', 'Grand Fall', 'Howling Moon', 'Lunar Bay', 'Ruinous Omen', 'Somnolence', 'Nether Blast', 'Night Terror', 'Level ? Holy' };
gcinclude.SmnHealing = T { 'Healing Ruby', 'Healing Ruby II', 'Whispering Wind', 'Spring Water' };
gcinclude.SmnHybrid = T { 'Flaming Crush', 'Burning Strike' };
gcinclude.SmnEnfeebling = T { 'Diamond Storm', 'Sleepga', 'Shock Squall', 'Slowga', 'Tidal Roar', 'Pavor Nocturnus', 'Ultimate Terror', 'Nightmare', 'Mewing Lullaby', 'Eerie Eye' };
gcinclude.BluMagPhys = T { 'Foot Kick', 'Sprout Smack', 'Wild Oats', 'Power Attack', 'Queasyshroom', 'Battle Dance', 'Feather Storm', 'Helldive', 'Bludgeon', 'Claw Cyclone', 'Screwdriver', 'Grand Slam', 'Smite of Rage', 'Pinecone Bomb', 'Jet Stream', 'Uppercut', 'Terror Touch', 'Mandibular Bite', 'Sickle Slash', 'Dimensional Death', 'Spiral Spin', 'Death Scissors', 'Seedspray', 'Body Slam', 'Hydro Shot', 'Frenetic Rip', 'Spinal Cleave', 'Hysteric Barrage', 'Asuran Claws', 'Cannonball', 'Disseverment', 'Ram Charge', 'Vertical Cleave', 'Final Sting', 'Goblin Rush', 'Vanity Dive', 'Whirl of Rage', 'Benthic Typhoon', 'Quad. Continuum', 'Empty Thrash', 'Delta Thrust', 'Heavy Strike', 'Quadrastrike', 'Tourbillion', 'Amorphic Spikes', 'Barbed Crescent', 'Bilgestorm', 'Bloodrake', 'Glutinous Dart', 'Paralyzing Triad', 'Thrashing Assault', 'Sinker Drill', 'Sweeping Gouge', 'Saurian Slide' };
gcinclude.BluMagDebuff = T { 'Filamented Hold', 'Cimicine Discharge', 'Demoralizing Roar', 'Venom Shell', 'Light of Penance', 'Sandspray', 'Auroral Drape', 'Frightful Roar', 'Enervation', 'Infrasonics', 'Lowing', 'CMain Wave', 'Awful Eye', 'Voracious Trunk', 'Sheep Song', 'Soporific', 'Yawn', 'Dream Flower', 'Chaotic Eye', 'Sound Blast', 'Blank Gaze', 'Stinking Gas', 'Geist Wall', 'Feather Tickle', 'Reaving Wind', 'Mortal Ray', 'Absolute Terror', 'Blistering Roar', 'Cruel Joke' };
gcinclude.BluMagStun = T { 'Head Butt', 'Frypan', 'Tail Slap', 'Sub-zero Smash', 'Sudden Lunge' };
gcinclude.BluMagBuff = T { 'Cocoon', 'Refueling', 'Feather Barrier', 'Memento Mori', 'Zephyr Mantle', 'Warm-Up', 'Amplification', 'Triumphant Roar', 'Saline Coat', 'Reactor Cool', 'Plasma Charge', 'Regeneration', 'Animating Wail', 'Battery Charge', 'Winds of Promy.', 'Barrier Tusk', 'Orcish Counterstance', 'Pyric Bulwark', 'Nat. Meditation', 'Restoral', 'Erratic Flutter', 'Carcharian Verve', 'Harden Shell', 'Mighty Guard' };
gcinclude.BluMagSkill = T { 'Metallic Body', 'Diamondhide', 'Magic Barrier', 'Occultation', 'Atra. Libations' };
gcinclude.BluMagDiffus = T { 'Erratic Flutter', 'Carcharian Verve', 'Harden Shell', 'Mighty Guard' };
gcinclude.BluMagCure = T { 'Pollen', 'Healing Breeze', 'Wild Carrot', 'Magic Fruit', 'Plenilune Embrace' };
gcinclude.BluMagEnmity = T { 'Actinic Burst', 'Exuviation', 'Fantod', 'Jettatura', 'Temporal Shift' };
gcinclude.BluMagTH = T { 'Actinic Burst', 'Dream Flower' };
gcinclude.Elements = T { 'Thunder', 'Blizzard', 'Fire', 'Stone', 'Aero', 'Water', 'Light', 'Dark' };
gcinclude.HelixSpells = T { 'Ionohelix', 'Cryohelix', 'Pyrohelix', 'Geohelix', 'Anemohelix', 'Hydrohelix', 'Luminohelix', 'Noctohelix' };
gcinclude.StormSpells = T { 'Thunderstorm', 'Hailstorm', 'Firestorm', 'Sandstorm', 'Windstorm', 'Rainstorm', 'Aurorastorm', 'Voidstorm' };
gcinclude.NinNukes = T { 'Katon: Ichi', 'Katon: Ni', 'Katon: San', 'Hyoton: Ichi', 'Hyoton: Ni', 'Hyoton: San', 'Huton: Ichi', 'Huton: Ni', 'Huton: San', 'Doton: Ichi', 'Doton: Ni', 'Doton: San', 'Raiton: Ichi', 'Raiton: Ni', 'Raiton: San', 'Suiton: Ichi', 'Suiton: Ni', 'Suiton: San' };
gcinclude.FishSet = false;
gcinclude.CraftSet = false;
gcinclude.TargetNames = T { 'Apex', 'Skeleton Warrior', 'Agitated', 'Devouring', 'Ascended', 'Locus Armet Beetle', 'Temenos' };

function gcinclude.Message(toggle, status)
	if toggle ~= nil and status ~= nil then
		print(chat.header('GCinclude'):append(chat.message(toggle .. ' is now ' .. tostring(status))))
	end
end

function gcinclude.SetAlias()
	for _, v in ipairs(gcinclude.AliasList) do
		AshitaCore:GetChatManager():QueueCommand(-1, '/alias /' .. v .. ' /lac fwd ' .. v);
	end
end

function gcinclude.ClearAlias()
	for _, v in ipairs(gcinclude.AliasList) do
		AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /' .. v);
	end
end

function gcinclude.SetVariables()
	local player = gData.GetPlayer();

	gcdisplay.CreateCycle('MeleeSet', { [1] = 'Default', [2] = 'Hybrid', [3] = 'Acc', [4] = 'DT' });
	gcdisplay.CreateCycle('Weapon', { [1] = 'Primary', [2] = 'Secondary', [3] = 'Third' });
	gcdisplay.CreateToggle('Kite', false);
	gcdisplay.CreateToggle('Solo', false);
	if player.MainJob == 'WHM' or player.SubJob == 'WHM' then gcdisplay.CreateToggle('Autoheal', false) end;
	if player.MainJob == 'COR' then
		gcdisplay.CreateCycle('Roll1',
			{ [1] = 'Samurai', [2] = 'EXP', [3] = 'Evoker', [4] = 'Hunter' })
	end;
	if player.MainJob == 'COR' then gcdisplay.CreateCycle('Roll2', { [1] = 'Chaos', [2] = 'Tactician', [3] = 'MAB' }) end;
	if player.MainJob == 'COR' then gcdisplay.CreateToggle('Rolls', false) end;
	gcdisplay.CreateToggle('TH', false)
end

function gcinclude.HasItem(itemName)
    local inventory = AshitaCore:GetMemoryManager():GetInventory();
    for i = 0, 80 do
        local item = inventory:GetContainerItem(0, i);
        if item and item.Id ~= 0 then
            local resource = AshitaCore:GetResourceManager():GetItemById(item.Id);
            if resource and resource.Name[1] == itemName then
                return item.Count > 0;
            end
        end
    end
    return false;
end

function gcinclude.HandleCommands(args)
	if not gcinclude.AliasList:contains(args[1]) then return end

	local player = gData.GetPlayer();
	local toggle = nil;
	local status = nil;

	if args[1] == 'gcmessages' then
		if gcinclude.settings.Messages then
			gcinclude.settings.Messages = false;
			print(chat.header('GCinclude'):append(chat.message('Chat messanges are disabled')));
		else
			gcinclude.settings.Messages = true;
			print(chat.header('GCinclude'):append(chat.message('Chat messanges are enabled')));
		end
	elseif (args[1] == 'wsdistance') then
		if (tonumber(args[2])) then
			gcinclude.settings.WScheck = true;
			gcinclude.settings.WSdistance = tonumber(args[2]);
			print(chat.header('GCinclude'):append(chat.message('WS Distance is on and set to ' .. gcinclude.settings
				.WSdistance)));
		else
			gcinclude.settings.WScheck = not gcinclude.settings.WScheck;
			print(chat.header('GCinclude'):append(chat.message('WS distance check is now ' ..
				tostring(gcinclude.settings.WScheck))));
		end
	elseif (args[1] == 'meleeset') then
		gcdisplay.AdvanceCycle('MeleeSet');
		toggle = 'Melee Gear Set';
		status = gcdisplay.GetCycle('MeleeSet');
	elseif (args[1] == 'setweapon') then
		gcdisplay.AdvanceCycle('Weapon');
		toggle = 'Changing Weapon Set';
		status = gcdisplay.GetCycle('Weapon');
	elseif (args[1] == 'setprime') then
		gcdisplay.SetCycle('Weapon', 'Primary');
		toggle = 'Changing Weapon Set';
		status = gcdisplay.GetCycle('Weapon');
	elseif (#args == 3 and args[1] == 'setcycle') then
		if gcdisplay.SetCycle(args[2], args[3]) then
			toggle = args[2];
			status = gcdisplay.GetCycle(args[2]);
		end
	elseif (args[1] == 'kite') then
		gcdisplay.AdvanceToggle('Kite');
		toggle = 'Kite Set';
		status = gcdisplay.GetToggle('Kite');
	elseif (args[1] == 'solo') then
		gcdisplay.AdvanceToggle('Solo');
		toggle = 'Solo Mode';
		status = gcdisplay.GetToggle('Solo');
	elseif (args[1] == 'autoheal') and (player.MainJob == 'WHM' or player.SubJob == 'WHM') then
		gcdisplay.AdvanceToggle('Autoheal');
		toggle = 'Autoheal';
		status = gcdisplay.GetToggle('Autoheal');
	elseif (args[1] == 'roll1') and player.MainJob == 'COR' then
		gcdisplay.AdvanceCycle('Roll1');
		toggle = 'Roll1';
		status = gcdisplay.GetCycle('Roll1');
	elseif (args[1] == 'roll2') and player.MainJob == 'COR' then
		gcdisplay.AdvanceCycle('Roll2');
		toggle = 'Roll2';
		status = gcdisplay.GetCycle('Roll2');
	elseif (args[1] == 'autoroll') and player.MainJob == 'COR' then
		gcdisplay.AdvanceToggle('Rolls');
		toggle = 'Rolls';
		status = gcdisplay.GetToggle('Rolls');
	elseif (args[1] == 'th') then
		gcdisplay.AdvanceToggle('TH');
		toggle = 'TH Set';
		status = gcdisplay.GetToggle('TH');
	elseif (args[1] == 'warpring') then
		gcinclude.DoWarpRing();
	elseif (args[1] == 'rrcap') then
		gcinclude.DoRRCap();
	elseif (args[1] == 'telering') then
		gcinclude.DoTeleRing();
	elseif (args[1] == 'fishset') then
		gcinclude.FishSet = not gcinclude.FishSet;
		toggle = 'Fishing Set';
		status = gcinclude.FishSet;
	elseif (args[1] == 'cureself') then
    if gData.GetBuffCount('Silence') > 0 then
        if gcinclude.HasItem('Echo Drops') then
            AshitaCore:GetChatManager():QueueCommand(1, '/item "echo drops" <me>');
				elseif gcinclude.HasItem('Remedy') then
						AshitaCore:GetChatManager():QueueCommand(1, '/item "remedy" <me>');
				end
    end
	end

	if gcinclude.settings.Messages then
		gcinclude.Message(toggle, status)
	end
end

function gcinclude.GetPlayerStatus()
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    local INFINITE_DURATION = 0x7FFFFFFF;
    if not player then return nil end

    -- Get the correct UTC timestamp pointer using the actual working pattern from statustimers
    local real_utcstamp_pointer = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????8B410C8B49108D04808D04808D04808D04C1C3', 2, 0);
    if not real_utcstamp_pointer or real_utcstamp_pointer == 0 then
        print(chat.header('GCinclude'):append(chat.message('Error: Unable to find UTC timestamp pointer for buff durations')));
        return nil;
    end

    local function get_utcstamp()
        local ptr = real_utcstamp_pointer;
        if (ptr == 0) then
            return INFINITE_DURATION;
        end

        -- Double dereference the pointer to get the correct address
        ptr = ashita.memory.read_uint32(ptr);
        if ptr == 0 then return INFINITE_DURATION end
        ptr = ashita.memory.read_uint32(ptr);
        if ptr == 0 then return INFINITE_DURATION end
        -- The utcstamp is at offset 0x0C
        return ashita.memory.read_uint32(ptr + 0x0C);
    end

    local function buff_duration(raw_duration)
        if (raw_duration == INFINITE_DURATION) then
            return -1;
        end

        local vana_base_stamp = 0x3C307D70;
        --get the time since vanadiel epoch
        local offset = get_utcstamp() - vana_base_stamp;
        --multiply it by 60 to create like terms
        local comparand = offset * 60;
        --get actual time remaining
        local real_duration = raw_duration - comparand;
        --handle the triennial spillover..
        while (real_duration < -2147483648) do
            real_duration = real_duration + 0xFFFFFFFF;
        end

        if real_duration < 1 then
            return 0;
        else
            --convert to seconds..
            return math.ceil(real_duration / 60);
        end
    end

    -- Single loop to process both icons and timers
    local icons = player:GetStatusIcons();
    local timers = player:GetStatusTimers();
    local status_ids = T{};

    for j = 0,31,1 do
        if (icons[j + 1] ~= 255 and icons[j + 1] > 0) then
            status_ids[#status_ids+1] = T{
                id = icons[j + 1],
                duration = buff_duration(timers[j + 1])
            };
        end
    end
    
    if (next(status_ids)) then
        return status_ids;
    end
    return nil;
end

function gcinclude.CheckCommonDebuffs()
	local weakened = gData.GetBuffCount('Weakened');
	local sleep = gData.GetBuffCount('Sleep');
	local doom = (gData.GetBuffCount('Doom')) + (gData.GetBuffCount('Bane'));

	if (sleep >= 1) then gFunc.EquipSet(gcinclude.sets.Sleeping) end
	if (doom >= 1) then gFunc.EquipSet(gcinclude.sets.Doomed) end
end

function gcinclude.CheckAbilityRecast(check)
    local player = gData.GetPlayer();
    if not player or player.Status == 'Zoning' then
        return 0;
    end
    
    local RecastTime = 0;

    for x = 0, 31 do
        local id = AshitaCore:GetMemoryManager():GetRecast():GetAbilityTimerId(x);
        local timer = AshitaCore:GetMemoryManager():GetRecast():GetAbilityTimer(x);

        if ((id ~= 0 or x == 0) and timer > 0) then
            local ability = AshitaCore:GetResourceManager():GetAbilityByTimerId(id);
            if ability == nil then return RecastTime end
            if (ability.Name[1] == check) and (ability.Name[1] ~= 'Unknown') then
                RecastTime = timer;
            end
        end
    end

    return RecastTime;
end

function gcinclude.CheckLockingRings()
    local player = gData.GetPlayer();
    if not player or player.Status == 'Zoning' then
        return;
    end
    
	local rings = gData.GetEquipment();
	if (rings.Ring1 ~= nil) and (gcinclude.LockingRings:contains(rings.Ring1.Name)) then
		local tempRing1 = rings.Ring1.Name;
		gFunc.Equip('Ring1', tempRing1);
	end
	if (rings.Ring2 ~= nil) and (gcinclude.LockingRings:contains(rings.Ring2.Name)) then
		local tempRing2 = rings.Ring2.Name;
		gFunc.Equip('Ring2', tempRing2);
	end
end

function gcinclude.SetTownGear()
	local zone = gData.GetEnvironment();
	if (zone.Area ~= nil) and (gcinclude.Towns:contains(zone.Area)) then gFunc.EquipSet(gcinclude.sets.Movement) end
end

function gcinclude.SetRegenRefreshGear()
	if gcinclude.settings.AutoGear == false then return end
	local player = gData.GetPlayer();
	local pet = gData.GetPet();
	
	if (player.Status == 'Engaged') then
    gFunc.EquipSet(gcdisplay.GetCycle('MeleeSet'));
	elseif (player.Status == 'Resting') then
		gFunc.EquipSet('Resting');
	elseif (player.Status == 'Idle') then
		gFunc.EquipSet('Idle');
	end
	if (player.MPP < gcinclude.settings.RefreshGearMPP) then gFunc.EquipSet('Refresh') end
	if (player.HPP < gcinclude.settings.DTGearHPP) or (gcdisplay.GetCycle('MeleeSet') == 'DT') then gFunc.EquipSet('DT') end
end

function gcinclude.CheckWsBailout()
	local player = gData.GetPlayer();
	local ws = gData.GetAction();
	local target = gData.GetActionTarget();
	local sleep = gData.GetBuffCount('Sleep');
	local petrify = gData.GetBuffCount('Petrification');
	local stun = gData.GetBuffCount('Stun');
	local terror = gData.GetBuffCount('Terror');
	local amnesia = gData.GetBuffCount('Amnesia');
	local charm = gData.GetBuffCount('Charm');

	if ws then
		if gcinclude.settings.WScheck and not gcinclude.DistanceWS:contains(ws.Name) and (tonumber(target.Distance) > gcinclude.settings.WSdistance) then
			print(chat.header('GCinclude'):append(chat.message('Distance at:' ..
				string.format("%.1f", tonumber(target.Distance)) ..
				'/ Max:' .. gcinclude.settings.WSdistance .. ' Change /wsdistance ##')));
			return false;
		end
	end
	if (player.HPP <= 0) or (player.Status == 'Dead') or (player.Status == 'Knocked Out') then
		return false;
	end
	if (player.TP <= 999) or (sleep + petrify + stun + terror + amnesia + charm >= 1) then
		return false;
	end
	return true;
end

function gcinclude.CheckSpellBailout()
	local sleep = gData.GetBuffCount('Sleep');
	local petrify = gData.GetBuffCount('Petrification');
	local stun = gData.GetBuffCount('Stun');
	local terror = gData.GetBuffCount('Terror');
	local silence = gData.GetBuffCount('Silence');
	local charm = gData.GetBuffCount('Charm');
	local cast = gData.GetAction();
	local player = gData.GetPlayer();

	-- Check if player is performing an action
	if cast then
		return false
	end
	if player.IsMoving == true then
		return false;
	end

	if (player.HPP <= 0) or (player.Status == 'Dead') or (player.Status == 'Knocked Out') then
		return false;
	end

	if (sleep + petrify + stun + terror + silence + charm >= 1) then
		return false;
	else
		return true;
	end
end

function gcinclude.DoWarpRing()
	AshitaCore:GetChatManager():QueueCommand(1, '/lac equip ring2 "Warp Ring"');

	local function usering()
		local function forceidleset()
			AshitaCore:GetChatManager():QueueCommand(1, '/lac set Idle');
		end
		AshitaCore:GetChatManager():QueueCommand(1, '/item "Warp Ring" <me>');
		forceidleset:once(8);
	end

	usering:once(11);
end

function gcinclude.DoTeleRing()
	AshitaCore:GetChatManager():QueueCommand(1, '/lac equip ring2 "' .. gcinclude.settings.Tele_Ring .. '"');

	local function usering()
		local function forceidleset()
			AshitaCore:GetChatManager():QueueCommand(1, '/lac set Idle');
		end
		AshitaCore:GetChatManager():QueueCommand(1, '/item "' .. gcinclude.settings.Tele_Ring .. '" <me>');
		forceidleset:once(8);
	end
	usering:once(11);
end

function gcinclude.DoShadows(spell)
	if spell.Name == 'Utsusemi: Ichi' then
		local delay = 2.4
		if gData.GetBuffCount(66) == 1 then
			(function() AshitaCore:GetChatManager():QueueCommand(-1, '/cancel 66') end):once(delay)
		elseif gData.GetBuffCount(444) == 1 then
			(function() AshitaCore:GetChatManager():QueueCommand(-1, '/cancel 444') end):once(delay)
		elseif gData.GetBuffCount(445) == 1 then
			(function() AshitaCore:GetChatManager():QueueCommand(-1, '/cancel 445') end):once(delay)
		elseif gData.GetBuffCount(446) == 1 then
			(function() AshitaCore:GetChatManager():QueueCommand(-1, '/cancel 446') end):once(delay)
		end
	end

	if spell.Name == 'Utsusemi: Ni' then
		local delay = 0.5
		if gData.GetBuffCount(66) == 1 then
			(function() AshitaCore:GetChatManager():QueueCommand(-1, '/cancel 66') end):once(delay)
		elseif gData.GetBuffCount(444) == 1 then
			(function() AshitaCore:GetChatManager():QueueCommand(-1, '/cancel 444') end):once(delay)
		elseif gData.GetBuffCount(445) == 1 then
			(function() AshitaCore:GetChatManager():QueueCommand(-1, '/cancel 445') end):once(delay)
		elseif gData.GetBuffCount(446) == 1 then
			(function() AshitaCore:GetChatManager():QueueCommand(-1, '/cancel 446') end):once(delay)
		end
	end
end

function gcinclude.CheckCancels()
	local player = gData.GetPlayer();
	if not player or player.Status == 'Zoning' then
		return;
	end
	
	local action = gData.GetAction();
	local sneak = gData.GetBuffCount('Sneak');
	local stoneskin = gData.GetBuffCount('Stoneskin');
	local target = gData.GetActionTarget();
	
	-- Add null check for party member access
	local party = AshitaCore:GetMemoryManager():GetParty();
	if not party then return end
	
	local me = party:GetMemberName(0);
	if not me then return end
	
	local function do_jig()
		AshitaCore:GetChatManager():QueueCommand(1, '/ja "Spectral Jig" <me>');
	end
	local function do_sneak()
		AshitaCore:GetChatManager():QueueCommand(1, '/ma "Sneak" <me>');
	end
	local function do_ss()
		AshitaCore:GetChatManager():QueueCommand(1, '/ma "Stoneskin" <me>');
	end

	if (action.Name == 'Spectral Jig' and sneak ~= 0) then
		gFunc.CancelAction();
		AshitaCore:GetChatManager():QueueCommand(1, '/cancel Sneak');
		do_jig:once(1);
	elseif (action.Name == 'Sneak' and sneak ~= 0 and target.Name == me) then
		gFunc.CancelAction();
		AshitaCore:GetChatManager():QueueCommand(1, '/cancel Sneak');
		do_sneak:once(1);
	elseif (action.Name == 'Stoneskin' and stoneskin ~= 0) then
		gFunc.CancelAction();
		AshitaCore:GetChatManager():QueueCommand(1, '/cancel Stoneskin');
		do_ss:once(1);
	end
end

function gcinclude.AutoEngage()
	-- This function looks for engage and moves forward if out of range
	local player = gData.GetPlayer();
	local target = gData.GetTarget();

	if target and gcdisplay.GetToggle('Solo') == true then
		local shouldEngage = false;
		for _, name in ipairs(gcinclude.TargetNames) do
			if string.find(target.Name, name) then
				shouldEngage = true;
				break;
			end
		end

		if shouldEngage then
			if player.Status == 'Idle' and target.Type == 'Monster' and target.Distance < 30 then
				AshitaCore:GetChatManager():QueueCommand(1, '/attack on');
				gcmovement.tapBackward(0.5);
			end
			if player.Status == 'Engaged' and target.Type == 'Monster' then
				if target.Distance > 3 then
					-- Move to a target
					gcmovement.tapForward(0.5);
				elseif target.Distance < 1.5 then
					gcmovement.tapBackward(0.2);
				end
			end
		end
	elseif gcdisplay.GetToggle('Solo') == true then
		--8AshitaCore:GetChatManager():QueueCommand(1, '/targetbnpc');
	end
end

function gcinclude.AutoAssist()
    local player = gData.GetPlayer();
    local target = gData.GetTarget();
    
    -- Safety check for zoning
    if not player or player.Status == 'Zoning' then
        return;
    end
    
    local followTarget = AshitaCore:GetMemoryManager():GetAutoFollow():GetFollowTargetIndex();
    local LEADER_NAME = '<p1>'; -- set leader to party member 1
    local ENGAGE_DISTANCE = 20;
    
	if target then
		if player.Status == 'Idle' and target.Type == 'Monster' and target.Distance < ENGAGE_DISTANCE then
			AshitaCore:GetChatManager():QueueCommand(1, '/attack on');
			gcmovement.tapBackward(0.2);
		elseif target.Name == LEADER_NAME and not followTarget then
			AshitaCore:GetChatManager():QueueCommand(1, '/follow');
		elseif target.Name == LEADER_NAME and followTarget then
			AshitaCore:GetChatManager():QueueCommand(1, '/assist');
		end
	else
		AshitaCore:GetChatManager():QueueCommand(1, '/target ' .. LEADER_NAME);
	end
end

function gcinclude.CheckDefault()
	local player = gData.GetPlayer();
	local target = gData.GetTarget();
	
	-- Early return if zoning to prevent crashes
	if not player or player.Status == 'Zoning' then 
			return 
	end
    
	gcinclude.SetRegenRefreshGear();
	gcinclude.SetTownGear();
	gcinclude.CheckCommonDebuffs();
	gcinclude.CheckLockingRings();

	if target then
		if target.Name == 'Sturdy Pyxis' then
			local currentTime = os.time();
			if (currentTime - gcinclude.settings.LastForbiddenKey) >= 5 then
				AshitaCore:GetChatManager():QueueCommand(1, '/item "Forbidden Key" <t>');
				gcinclude.settings.LastForbiddenKey = currentTime;
			end
		end
	end
	if (gcinclude.CraftSet == true) then gFunc.EquipSet(gcinclude.sets.Crafting) end
	if (gcinclude.FishSet == true) then gFunc.EquipSet(gcinclude.sets.Fishing) end
	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(gcinclude.sets.TH) end
	if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(gcinclude.sets.Movement) end;
	gcdisplay.Update();
end

gcinclude.aggrolist = function()
    -- Add safety check for zoning
    local player = gData.GetPlayer();
    if not player or player.Status == 'Zoning' then
        return false, 0;
    end
    
    -- Initialize the aggro targets table if it doesn't exist
    if not gcinclude.aggroTargets then
        gcinclude.aggroTargets = {};
    end
    local allClaimedTargets = gcinclude.aggroTargets or {};
    local count = 0;
    
    -- Check and clean up targets
    for k, v in pairs(allClaimedTargets) do
        local ent = GetEntity(k);
        if not ent then
            allClaimedTargets[k] = nil;
            goto continue;
        end
        
        local renderflags = AshitaCore:GetMemoryManager():GetEntity():GetRenderFlags0(k);
        local isValid = bit.band(renderflags, 0x200) == 0x200 and bit.band(renderflags, 0x4000) == 0;
        
        if (v ~= nil and ent ~= nil and isValid) then
            count = count + 1;
        else
            allClaimedTargets[k] = nil;
        end
        
        ::continue::
    end
    
    gcinclude.aggroTargets = allClaimedTargets;
    return count > 0, count;
end

function gcinclude.Unload()
	gcinclude.ClearAlias();
	gcdisplay.Unload();
	AshitaCore:GetChatManager():QueueCommand(1, '/unbind F9');
	AshitaCore:GetChatManager():QueueCommand(1, '/unbind F10');
	AshitaCore:GetChatManager():QueueCommand(1, '/unbind F11');
	AshitaCore:GetChatManager():QueueCommand(1, '/unbind F12');
	AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^F9');
	AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^F10');
	AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^F11');
	AshitaCore:GetChatManager():QueueCommand(1, '/unbind ^F12');
	AshitaCore:GetChatManager():QueueCommand(1, '/unbind !F9');
	AshitaCore:GetChatManager():QueueCommand(1, '/unbind !F10');
	AshitaCore:GetChatManager():QueueCommand(1, '/unbind !F12');
	AshitaCore:GetChatManager():QueueCommand(1, '/unbind numpad1');
	AshitaCore:GetChatManager():QueueCommand(1, '/unbind numpad3');
end

function gcinclude.SetJobSets()
	local player = gData.GetPlayer();
	if not player or player.Status == 'Zoning' then return end

	if player.MainJob == 'RUN' then gcdisplay.SetCycle('MeleeSet', 'DT') end;
	if player.MainJob == 'WHM' and (player.SubJob == 'NIN' or player.SubJob == 'DNC') then
		gcdisplay.SetCycle('Weapon', 'Secondary')
	end
end

function gcinclude.Initialize()
	gcdisplay.Initialize:once(2);
	gcinclude.SetVariables:once(2);
	gcinclude.SetAlias:once(2);
	gcinclude.SetJobSets:once(2);
	local player = gData.GetPlayer();
	AshitaCore:GetChatManager():QueueCommand(1, '/bind F9 /meleeset');
	AshitaCore:GetChatManager():QueueCommand(1, '/bind F10 /setcycle MeleeSet DT');
	AshitaCore:GetChatManager():QueueCommand(1, '/bind F11 /solo');
	AshitaCore:GetChatManager():QueueCommand(1, '/bind F12 /th');
	AshitaCore:GetChatManager():QueueCommand(1, '/bind ^F9 /setweapon');
	AshitaCore:GetChatManager():QueueCommand(1, '/bind !F9 /setprime');
	AshitaCore:GetChatManager():QueueCommand(1, '/bind ^F10 /setcycle MeleeSet Default');
	AshitaCore:GetChatManager():QueueCommand(1, '/bind ^F11 /setcycle MeleeSet Hybrid');
	AshitaCore:GetChatManager():QueueCommand(1, '/bind ^F12 /setcycle MeleeSet Acc');
	if (player.MainJob == 'WHM' or player.SubJob == 'WHM') then AshitaCore:GetChatManager():QueueCommand(1, '/bind !F12 /autoheal') end;
	if player.MainJob == 'COR' then AshitaCore:GetChatManager():QueueCommand(1, '/bind numpad1 /roll1') end;
	if player.MainJob == 'COR' then AshitaCore:GetChatManager():QueueCommand(1, '/bind numpad3 /roll2') end;
	if player.MainJob == 'COR' then AshitaCore:GetChatManager():QueueCommand(1, '/bind !F10 /autoroll') end;
end

return gcinclude;
