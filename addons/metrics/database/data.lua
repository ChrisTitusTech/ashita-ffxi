DB.Data = T{}

------------------------------------------------------------------------------------------------------
-- Initializes an "actor:target" combination in the primary data and catalog data nodes.
-- Also initializes separate tracking globals for Running Accuracy.
-- If the "actor:target" combo has already been initialized then this will quit out early.
-- CALLED BY: Init.Catalog, Update.Data, and Get.Total_Party_Damage
------------------------------------------------------------------------------------------------------
---@param index string "actor_name:target_name"
---@param player_name? string used for maintaining various player indexed tables. In the case of pets this will be the owner.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Init = function(index, player_name)
	if not index then
		Debug.Error.Add("Data.Init: Player name {" .. tostring(player_name) .. "} has nil index passed in.")
		return false
	end
	if not player_name or player_name == "" then
		Debug.Error.Add("Data.Init: Index {" .. tostring(index) .. "} has nil or blank player name." )
		return false
	end

	-- Check to see if the nodes have already been initialized for the player and the pet.
	if DB.Parse[index] then return false end

	-- Initialize primary node.
	DB.Parse[index] = {}

	-- Initialize data nodes.
	for _, trackable in pairs(DB.Enum.Trackable) do
		DB.Parse[index][trackable] = {}
		DB.Parse[index][trackable][DB.Enum.Values.CATALOG] = {}
		for _, metric in pairs(DB.Enum.Metric) do
			DB.Data.Set(0, index, trackable, metric)
		end
	end

	-- Need to set minimum high manually to capture accurate minimums.
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.MELEE, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.MELEE_MAIN, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.MELEE_OFFHAND, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.MELEE_KICK, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.ENSPELL, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.ENDAMAGE, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.ENASPIR, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.PET_MELEE, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.PET_MELEE_DISCRETE, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.RANGED, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.ENDAMAGE_R, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.THROWING, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.WS, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.SC, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.PET_WS, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.MP_DRAIN, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.ABILITY_DAMAGING, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.ABILITY_HEALING, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.ABILITY_MP_RECOVERY, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.PET_ABILITY, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.PET_HEAL, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.NUKE, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.PET_NUKE, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.HEALING, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.HEALING_RECEIVED, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.MELEE_DMG_TAKEN, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.MELEE_PET_DMG_TAKEN, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.SPELL_DMG_TAKEN, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.SPELL_PET_DMG_TAKEN, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.TP_DMG_TAKEN, DB.Enum.Metric.MIN)
	DB.Data.Set(DB.Enum.Values.MAX_DAMAGE, index, DB.Enum.Trackable.PET_TP_DMG_TAKEN, DB.Enum.Metric.MIN)

	-- Initialize tracking tables.
	DB.Data.Init_Player(player_name)

	return true
end

------------------------------------------------------------------------------------------------------
-- Initializes a player in the player list.
------------------------------------------------------------------------------------------------------
---@param player_name? string
------------------------------------------------------------------------------------------------------
DB.Data.Init_Player = function(player_name)
	if player_name and player_name ~= "" and not DB.Tracking.Initialized_Players[player_name] then
		DB.Tracking.Initialized_Players[player_name] = true
		DB.Lists.Sort.Players()
		DB.Tracking.Running_Accuracy[player_name] = T{}
		DB.Tracking.Running_Damage[player_name] = 0
		DB.Tracking.Running_Attack_Speed[player_name] = T{}
		DB.Tracking.Multi_Attack[player_name] = T{}
	end
end

------------------------------------------------------------------------------------------------------
-- A handler function that makes sure the data is set appropriately.
-- This does not set data directly. Rather, it calls the Set~ or Inc~ functions.
-- This is called by the functions that perform the action handling.
------------------------------------------------------------------------------------------------------
---@param mode string flag calling out whether the data should be set or incremented.
---@param value number the value to set or increment the node to/by.
---@param audits table Contains necessary data; helps save on parameter slots.
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
------------------------------------------------------------------------------------------------------
DB.Data.Update = function(mode, value, audits, trackable, metric)
	if audits.player_name == "" or audits.target_name == "" then
		Debug.Error.Add("Data.Update: Empty name: " .. tostring(audits.player_name) .. " " .. tostring(audits.target_name)
		.. " " .. tostring(trackable) .. " " .. tostring(metric))
		return nil
	end

	local player_name = audits.player_name
	local target_name = audits.target_name
	local pet_name = audits.pet_name
	local index = DB.Data.Build_Index(player_name, target_name)
	DB.Data.Init(index, player_name)
	if pet_name then DB.Pet_Data.Init(index, player_name, pet_name) end

	-- Peform the operation.
	if mode == DB.Enum.Mode.INC then
		DB.Data.Inc(value, index, trackable, metric)
		if pet_name then
			DB.Pet_Data.Inc(value, index, pet_name, trackable, metric)
		end
	elseif mode == DB.Enum.Mode.SET then
		DB.Data.Set(value, index, trackable, metric)
		if pet_name then
			DB.Pet_Data.Set(value, index, pet_name, trackable, metric)
		end
	end

	-- Increment the running damage count for DPS if this is a total damage increase.
	if mode == DB.Enum.Mode.INC and trackable == DB.Enum.Trackable.TOTAL and metric == DB.Enum.Metric.TOTAL then
		DB.DPS.Inc_Buffer(player_name, value)
	end
end

------------------------------------------------------------------------------------------------------
-- Directly sets a trackable's metric to a specified value.
------------------------------------------------------------------------------------------------------
---@param value number the value to set the node to.
---@param index string "actor_name:target_name".
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Set = function(value, index, trackable, metric)
	if not value or not index or not trackable or not metric then
		Debug.Error.Add("Data.Set: Index {" .. tostring(index) .. "}; Trackable {" .. tostring(trackable) .. "}; "
		            .. "Metric {" .. tostring(metric) .. "} nil required parameter passed in.")
		return false
	end
	if not DB.Parse or not DB.Parse[index] then
		Debug.Error.Add("Data.Set: Index {" .. tostring(index) .. "} is not initialized.")
		return false
	end

	DB.Parse[index][trackable][metric] = value
	return true
end

------------------------------------------------------------------------------------------------------
-- Increments a trackable's metric by a specified amount.
------------------------------------------------------------------------------------------------------
---@param value number the value to increment the node by.
---@param index string "player_name:mob_name"
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return boolean
------------------------------------------------------------------------------------------------------
DB.Data.Inc = function(value, index, trackable, metric)
	if not value or not index or not trackable or not metric then
		Debug.Error.Add("Data.Set: Index {" .. tostring(index) .. "}; Trackable {" .. tostring(trackable) .. "}; "
		            .. "Metric {" .. tostring(metric) .. "} nil required parameter passed in.")
		return false
	end
	if not DB.Parse or not DB.Parse[index] or not DB.Parse[index][trackable] or not DB.Parse[index][trackable][metric] then
		Debug.Error.Add("Data.Inc: DB.Parse uninitialized {" .. tostring(index) .. "} {" .. tostring(trackable) .. "} {" .. tostring(metric) .. "}." )
		return false
	end

	DB.Parse[index][trackable][metric] = DB.Parse[index][trackable][metric] + value
	return true
end

------------------------------------------------------------------------------------------------------
-- Gets data from a trackable metric.
-- If the mob filter is set then only actions towards that mob are counted.
------------------------------------------------------------------------------------------------------
---@param player_name string the player or entity name to search data for.
---@param trackable string a tracked item from the trackable list.
---@param metric string a trackable's metric from the metric list.
---@return number
------------------------------------------------------------------------------------------------------
DB.Data.Get = function(player_name, trackable, metric)
	if not player_name or not trackable or not metric then
		Debug.Error.Add("Get.Data: Nil player name. Trackable {" .. tostring(trackable) .. "}; Metric {" .. tostring(metric) .. "}.")
		return 0
	end

	-- Dont get new data unless we are in a new throttle cycle or cached data doesn't exist.
	if Throttle.Is_Enabled() and not Throttle.Allow_Calculation() then
		if DB.Cache[player_name] and DB.Cache[player_name][trackable] and DB.Cache[player_name][trackable][metric] then
			return DB.Cache[player_name][trackable][metric]
		end
	end

	local total = 0
	if metric == DB.Enum.Metric.MIN then total = DB.Enum.Values.MAX_DAMAGE end
	local mob_focus = DB.Widgets.Util.Get_Mob_Focus()
	local search_string = player_name .. ":" .. mob_focus
	if mob_focus == DB.Widgets.Dropdown.Enum.NONE then search_string = player_name .. ":" end

	for index, _ in pairs(DB.Parse) do
		if string.find(index, search_string) then
			local value = DB.Parse[index][trackable][metric]
			if metric == DB.Enum.Metric.MIN then
				if value < total then total = value end
			elseif metric == DB.Enum.Metric.MAX then
				if value > total then total = value end
			else
				total = total + value
			end
		end
	end

	-- Cache for performance.
	if not DB.Cache[player_name] then DB.Cache[player_name] = T{} end
	if not DB.Cache[player_name][trackable] then DB.Cache[player_name][trackable] = T{} end
	DB.Cache[player_name][trackable][metric] = total

	return total
end

------------------------------------------------------------------------------------------------------
-- Builds the primary index in the form player_name:mob_name
------------------------------------------------------------------------------------------------------
---@param actor_name string name of the player or entity performing the action
---@param target_name? string name of the mob or entity receiving the action
---@return string [actor_name:target_name]
------------------------------------------------------------------------------------------------------
DB.Data.Build_Index = function(actor_name, target_name)
	if not target_name then
		Debug.Error.Add("Util.Build_Index: Actor {" .. tostring(actor_name) .. "}; Target {" .. tostring(target_name) .. "} nil target name passed in.")
		target_name = DB.Enum.Values.DEBUG
	end
	if not actor_name then
		Debug.Error.Add("Util.Build_Index: Actor {" .. tostring(actor_name) .. "}; Target {" .. tostring(target_name) .. "} nil actor name passed in.")
		actor_name = DB.Enum.Values.DEBUG
	end

	return actor_name .. ":" .. target_name
end