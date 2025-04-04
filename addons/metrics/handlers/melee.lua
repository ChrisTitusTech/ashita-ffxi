H.Melee = {}

-- ------------------------------------------------------------------------------------------------------
-- Parse the melee attack packet.
-- ------------------------------------------------------------------------------------------------------
---@param action table action packet data.
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob table|nil (if pet) the mob data of the entity's owner.
---@param log_offense boolean if this action should actually be logged.
-- ------------------------------------------------------------------------------------------------------
H.Melee.Action = function(action, actor_mob, owner_mob, log_offense)
	if not log_offense then return nil end
	local result, target_mob
	local damage = 0
    local details = T{}
    local mult_attack = T{}

	for target_index, target_value in pairs(action.targets) do
		for action_index, _ in pairs(target_value.actions) do
			result = action.targets[target_index].actions[action_index]
			target_mob = Ashita.Mob.Get_Mob_By_ID(action.targets[target_index].id)
			if not target_mob then target_mob = {name = DB.Enum.Values.DEBUG} end
            if target_mob then
                if Ashita.Mob.Is_Monster(target_mob) then DB.Lists.Check.Mob_Exists(target_mob.name) end
                details = H.Melee.Parse(result, actor_mob.name, target_mob.name, owner_mob)

                if details and details.damage then damage = damage + details.damage end
                if details and details.type then
                    if not mult_attack[details.type] then mult_attack[details.type] = 0 end
                    mult_attack[details.type] = mult_attack[details.type] + 1
                end
            end
		end
	end

    if details and details.audits and details.audits.player_name and not owner_mob then
        for type, number in pairs(mult_attack) do
            local metric = nil
            if number == 1 then metric = DB.Enum.Metric.MULT_ATK_1 end
            if number == 2 then metric = DB.Enum.Metric.MULT_ATK_2 end
            if number == 3 then metric = DB.Enum.Metric.MULT_ATK_3 end
            if number == 4 then metric = DB.Enum.Metric.MULT_ATK_4 end
            if number == 5 then metric = DB.Enum.Metric.MULT_ATK_5 end
            if number == 6 then metric = DB.Enum.Metric.MULT_ATK_6 end
            if number == 7 then metric = DB.Enum.Metric.MULT_ATK_7 end
            if number == 8 then metric = DB.Enum.Metric.MULT_ATK_8 end
            if metric then
                if not DB.Tracking.Multi_Attack[details.audits.player_name] then DB.Tracking.Multi_Attack[details.audits.player_name] = T{} end
                DB.Tracking.Multi_Attack[details.audits.player_name][metric] = true
                DB.Data.Update(H.Mode.INC, 1, details.audits, type, metric)
                DB.Data.Update(H.Mode.INC, 1, details.audits, type, DB.Enum.Metric.ROUNDS)
                DB.Data.Update(H.Mode.INC, 1, details.audits, DB.Enum.Trackable.MELEE, DB.Enum.Metric.ROUNDS)
                if number > 1 then DB.Data.Update(H.Mode.INC, 1, details.audits, DB.Enum.Trackable.MELEE, DB.Enum.Metric.MULTI_TOTAL) end
            end
        end
    end

    -- Don't calculate attack speed for pets.
    if not owner_mob then DB.Attack_Speed.Update(actor_mob.name) end

    -- Keeps track of how many melee cycles have occurred (1 per packet).
    if not owner_mob then DB.Data.Update(DB.Enum.Mode.INC, 1, details.audits, DB.Enum.Trackable.MELEE, DB.Enum.Metric.CYCLE) end

    H.Melee.Blog(actor_mob, owner_mob, damage)
end

------------------------------------------------------------------------------------------------------
-- Set data for a melee action.
-- NOTES:
-- message 				https://github.com/Windower/Lua/wiki/Message-IDs
-- has_add_effect		boolean
-- add_effect_animation	https://github.com/Windower/Lua/wiki/Additional-Effect-IDs
-- Enspell element
-- add_effect_message	229: comes up with Ygnas bonus attack
-- add_effect_param		enspell damage
-- spike_effect_param	0: consistently on MNK vs Apex bats
-- spike_effect_effect
-- effect 				2: killing blow
-- 						4: counter? (probably not)
-- stagger 				animation the target does when being hit
-- reaction 			8: hit; consistently on MNK vs Apex bats
-- 						9: miss?; very rarely on MNK vs Apex bats
------------------------------------------------------------------------------------------------------
---@param result table contains all the information for the action.
---@param player_name string name of the player that did the action.
---@param target_name string name of the target that received the action.
---@param owner_mob? table if the action was from a pet then this will hold the owner's mob.
---@return table
------------------------------------------------------------------------------------------------------
H.Melee.Parse = function(result, player_name, target_name, owner_mob)
    Debug.Packet.Add_Action(player_name, target_name, "Melee", result)
    local animation_id = result.animation
    local damage = result.param
    local message_id = result.message
    local throwing = false

    local melee_type_broad = DB.Enum.Trackable.MELEE
    local melee_type_discrete = H.Melee.Melee_Type(animation_id)

    -- Need special handling for pets
    local pet_name
    if owner_mob then
        melee_type_broad = DB.Enum.Trackable.PET_MELEE
        melee_type_discrete = DB.Enum.Trackable.PET_MELEE_DISCRETE
        pet_name = player_name
        player_name = owner_mob.name
    end

    local audits = {
        player_name = player_name,
        target_name = target_name,
        pet_name = pet_name,
    }

    local no_damage = H.Melee.No_Damage_Messages(result)            -- No damage Messages
    H.Melee.Totals(audits, damage, melee_type_discrete, no_damage)  -- Totals
    H.Melee.Pet_Total(owner_mob, audits, damage, no_damage)         -- Pet Totals
    throwing = H.Melee.Animation(animation_id, audits, damage, melee_type_broad, throwing, no_damage)   -- Melee or Throwing Totals and Counts
    H.Melee.Min_Max(throwing, damage, audits, melee_type_broad, melee_type_discrete, no_damage)         -- Min/Max
    H.Melee.Additional_Effect(audits, result, no_damage)                                                -- Additional effects like enspell.
    H.Melee.Message(audits, damage, message_id, melee_type_broad, melee_type_discrete)                  -- Accuracy, crits, absorbed by shadows, etc.
    H.Melee.Reaction(result, audits, melee_type_broad)              -- Guard
    H.Melee.Spikes(audits, result, owner_mob)                       -- Spike damage

    return {damage = damage, type = melee_type_discrete, audits = audits}
end

-- ------------------------------------------------------------------------------------------------------
-- Adds melee damage to the battle log.
-- ------------------------------------------------------------------------------------------------------
---@param actor_mob table the mob data of the entity performing the action.
---@param owner_mob table|nil (if pet) the mob data of the entity's owner.
---@param damage number
-- ------------------------------------------------------------------------------------------------------
H.Melee.Blog = function(actor_mob, owner_mob, damage)
    if owner_mob then
        Blog.Add(owner_mob.name, actor_mob.name, Blog.Enum.Types.PET_MELEE, DB.Enum.Trackable.PET_MELEE, damage)
    else
        Blog.Add(actor_mob.name, nil, Blog.Enum.Types.MELEE, DB.Enum.Trackable.MELEE, damage)
    end
end

------------------------------------------------------------------------------------------------------
-- Map an animation to a discrete type of melee action.
------------------------------------------------------------------------------------------------------
---@param animation_id number represents, primary attack, offhand attack, kicking, etc.
---@return string
------------------------------------------------------------------------------------------------------
H.Melee.Melee_Type = function(animation_id)
    if animation_id == Ashita.Enum.Animation.MELEE_MAIN then
        return H.Trackable.MELEE_MAIN
    elseif animation_id == Ashita.Enum.Animation.MELEE_OFFHAND then
        return H.Trackable.MELEE_OFFHAND
    elseif animation_id == Ashita.Enum.Animation.MELEE_KICK or animation_id == Ashita.Enum.Animation.MELEE_KICK2 then
        return H.Trackable.MELEE_KICK
    elseif animation_id == Ashita.Enum.Animation.DAKEN then
        return H.Trackable.THROWING
    else
        return H.Trackable.DEFAULT
    end
end

------------------------------------------------------------------------------------------------------
-- Certain messages may come in with damage, but it's not actually damage.
-- Need to set the damage to zero for these cases.
------------------------------------------------------------------------------------------------------
---@param result table
---@return boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee.No_Damage_Messages = function(result)
    local message_id = result.message
    local add_effect_message_id = result.add_effect_message
    return message_id == Ashita.Enum.Message.DODGE or
           message_id == Ashita.Enum.Message.MISS or
           message_id == Ashita.Enum.Message.SHADOWS or
           message_id == Ashita.Enum.Message.MOBHEAL373 or
           add_effect_message_id == Ashita.Enum.Message.ENASPIR
end

------------------------------------------------------------------------------------------------------
-- Increment Grand Totals.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param melee_type_discrete string main-hand, off-hand, etc.
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee.Totals = function(audits, damage, melee_type_discrete, no_damage)
    if no_damage then damage = 0 end
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.TOTAL, H.Metric.TOTAL)
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.TOTAL_NO_SC, H.Metric.TOTAL)
    DB.Data.Update(H.Mode.INC, damage, audits, melee_type_discrete, H.Metric.TOTAL)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.COUNT)
end

------------------------------------------------------------------------------------------------------
-- Increment total pet damage.
------------------------------------------------------------------------------------------------------
---@param owner_mob table|nil if the action was from a pet then this will hold the owner's mob.
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee.Pet_Total = function(owner_mob, audits, damage, no_damage)
    if no_damage then damage = 0 end
    if owner_mob then
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.PET, H.Metric.TOTAL)
    end
end

------------------------------------------------------------------------------------------------------
-- The melee's animation to determine whether this is a regular melee of throwing melee.
------------------------------------------------------------------------------------------------------
---@param animation_id number this determines if the melee is main-hand, off-hand, etc.
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param melee_type_broad string player melee or pet melee.
---@param throwing boolean whether or not the animation is a NIN auto throwing attack.
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
---@return boolean throwing whether or not the animation is a NIN auto throwing attack.
------------------------------------------------------------------------------------------------------
H.Melee.Animation = function(animation_id, audits, damage, melee_type_broad, throwing, no_damage)
    if no_damage then damage = 0 end
    if animation_id >= Ashita.Enum.Animation.MELEE_MAIN and animation_id < Ashita.Enum.Animation.DAKEN then
        DB.Data.Update(H.Mode.INC, damage, audits, melee_type_broad, H.Metric.TOTAL)
        DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad, H.Metric.COUNT)
    elseif animation_id == Ashita.Enum.Animation.DAKEN then
        throwing = true
        DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.RANGED, H.Metric.TOTAL)
        DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.COUNT)
    else
        Debug.Error.Add("Melee.Animation: {" .. tostring(audits.player_name) .. "} Unhandled animation: " .. tostring(animation_id))
    end
    return throwing
end

------------------------------------------------------------------------------------------------------
-- The melee's reaction to determine whether the attack was guarded or not.
------------------------------------------------------------------------------------------------------
---@param result table
---@param audits table
---@param melee_type_broad string
------------------------------------------------------------------------------------------------------
H.Melee.Reaction = function(result, audits, melee_type_broad)
    local reaction = result.reaction
    if reaction == Ashita.Enum.Reaction.GUARD then
        DB.Data.Update(H.Mode.INC, 1, audits, melee_type_broad, H.Metric.GUARD)
    end
end

------------------------------------------------------------------------------------------------------
-- Handle the various metrics based on message.
-- The range attacks here are specifically the NIN auto throwing attacks while engaged.
-- https://github.com/Windower/Lua/wiki/Message-IDs
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param message_id number numberic identifier for system chat messages.
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Message = function(audits, damage, message_id, melee_type_broad, melee_type_discrete)
    if message_id == Ashita.Enum.Message.HIT then
        H.Melee.Hit(audits, melee_type_broad, melee_type_discrete)
    elseif message_id == Ashita.Enum.Message.MISS then
        H.Melee.Miss(audits, melee_type_broad)
    elseif message_id == Ashita.Enum.Message.CRIT then
        H.Melee.Crit(audits, damage, melee_type_broad, melee_type_discrete)
    elseif message_id == Ashita.Enum.Message.SHADOWS then
        H.Melee.Shadows(audits, melee_type_broad, melee_type_discrete)
    elseif message_id == Ashita.Enum.Message.DODGE then
        H.Melee.Dodge(audits, melee_type_broad, melee_type_discrete)
    elseif message_id == Ashita.Enum.Message.MOBHEAL3 or message_id == Ashita.Enum.Message.MOBHEAL373 then
        H.Melee.Mob_Heal(audits, damage, melee_type_broad, melee_type_discrete)
    elseif message_id == Ashita.Enum.Message.RANGEHIT then
        H.Melee.Daken_Hit(audits)
    elseif message_id == Ashita.Enum.Message.RANGEMISS then
        H.Melee.Daken_Miss(audits)
    elseif message_id == Ashita.Enum.Message.SQUARE then
        H.Melee.Daken_Square(audits)
    elseif message_id == Ashita.Enum.Message.TRUE then
        H.Melee.Daken_Truestrike(audits)
    elseif message_id == Ashita.Enum.Message.RANGECRIT then
        H.Melee.Daken_Crit(audits, damage)
    else
        Debug.Error.Add("Melee.Message: {" .. tostring(audits.player_name) .. "} Unhandled Melee Nuance " .. tostring(message_id))
    end
end

------------------------------------------------------------------------------------------------------
-- Regular melee hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Hit = function(audits, melee_type_broad, melee_type_discrete)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    if melee_type_broad ~= H.Trackable.PET_MELEE then DB.Accuracy.Update(audits.player_name, true) end
end

------------------------------------------------------------------------------------------------------
-- Regular melee miss.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param melee_type_broad string player melee or pet melee.
------------------------------------------------------------------------------------------------------
H.Melee.Miss = function(audits, melee_type_broad)
    if melee_type_broad ~= H.Trackable.PET_MELEE then DB.Accuracy.Update(audits.player_name, false) end
end

------------------------------------------------------------------------------------------------------
-- Regular melee critical hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Crit = function(audits, damage, melee_type_broad, melee_type_discrete)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.CRIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, melee_type_broad,    H.Metric.CRIT_DAMAGE)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.CRIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, melee_type_discrete, H.Metric.CRIT_DAMAGE)
    if melee_type_broad ~= H.Trackable.PET_MELEE then DB.Accuracy.Update(audits.player_name, true) end
end

------------------------------------------------------------------------------------------------------
-- Regular melee absorbed by shadows.
-- These are counted as hits in terms of accuracy.
-- Sometimes you just need to melee down through shadows. I don't think your accuracy should suffer.
-- If you actually miss, only then should the accuracy suffer.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Shadows = function(audits, melee_type_broad, melee_type_discrete)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.SHADOWS)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.SHADOWS)
end

------------------------------------------------------------------------------------------------------
-- Regular melee evaded by Pefect Dodge.
-- Remove the count so perfect dodge isn't penalized.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Dodge = function(audits, melee_type_broad, melee_type_discrete)
    DB.Data.Update(H.Mode.INC,     -1, audits, melee_type_broad,    H.Metric.COUNT)
    DB.Data.Update(H.Mode.INC,     -1, audits, melee_type_discrete, H.Metric.COUNT)
end

------------------------------------------------------------------------------------------------------
-- Healing the mob with a melee hit.
-- Accuracy doesn't suffer because this isn't a miss. It just heals the mob.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string main-hand, off-hand, etc.
------------------------------------------------------------------------------------------------------
H.Melee.Mob_Heal = function(audits, damage, melee_type_broad, melee_type_discrete)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_broad,    H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, melee_type_discrete, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, melee_type_broad,    H.Metric.MOB_HEAL)
    DB.Data.Update(H.Mode.INC, damage, audits, melee_type_discrete, H.Metric.MOB_HEAL)
end

------------------------------------------------------------------------------------------------------
-- Daken regular hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Hit = function(audits)
    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.THROWING, H.Metric.HIT_COUNT)
    DB.Accuracy.Update(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Daken square hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Square = function(audits)
    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.THROWING, H.Metric.HIT_COUNT)
    DB.Accuracy.Update(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Daken truestrike hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Truestrike = function(audits)
    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.THROWING, H.Metric.HIT_COUNT)
    DB.Accuracy.Update(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Daken miss.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Miss = function(audits)
    DB.Accuracy.Update(audits.player_name, false)
end

------------------------------------------------------------------------------------------------------
-- Daken critical hit.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param damage number
------------------------------------------------------------------------------------------------------
H.Melee.Daken_Crit = function(audits, damage)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.RANGED, H.Metric.CRIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.RANGED, H.Metric.CRIT_DAMAGE)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.THROWING, H.Metric.HIT_COUNT)
    DB.Data.Update(H.Mode.INC,      1, audits, H.Trackable.THROWING, H.Metric.CRIT_COUNT)
    DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.THROWING, H.Metric.CRIT_DAMAGE)
    DB.Accuracy.Update(audits.player_name, true)
end

------------------------------------------------------------------------------------------------------
-- Minimum and maximum melee values.
------------------------------------------------------------------------------------------------------
---@param throwing boolean whether or not the animation is a NIN auto throwing attack.
---@param damage number
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param melee_type_broad string player melee or pet melee.
---@param melee_type_discrete string player melee or pet melee.
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee.Min_Max = function(throwing, damage, audits, melee_type_broad, melee_type_discrete, no_damage)
    if no_damage then damage = 0 end
    if throwing then
        if damage > 0 and (damage < DB.Data.Get(audits.player_name, H.Trackable.RANGED, H.Metric.MIN)) then DB.Data.Update(H.Mode.SET, damage, audits, H.Trackable.RANGED, H.Metric.MIN) end
        if damage > DB.Data.Get(audits.player_name, H.Trackable.RANGED, H.Metric.MAX) then DB.Data.Update(H.Mode.SET, damage, audits, H.Trackable.RANGED, H.Metric.MAX) end
        if damage > 0 and (damage < DB.Data.Get(audits.player_name, H.Trackable.THROWING, H.Metric.MIN)) then DB.Data.Update(H.Mode.SET, damage, audits, H.Trackable.THROWING, H.Metric.MIN) end
        if damage > DB.Data.Get(audits.player_name, H.Trackable.THROWING, H.Metric.MAX) then DB.Data.Update(H.Mode.SET, damage, audits, H.Trackable.THROWING, H.Metric.MAX) end
    else
        if damage > 0 and (damage < DB.Data.Get(audits.player_name, melee_type_discrete, H.Metric.MIN)) then DB.Data.Update(H.Mode.SET, damage, audits, melee_type_discrete, H.Metric.MIN) end
        if damage > DB.Data.Get(audits.player_name, melee_type_discrete, H.Metric.MAX) then DB.Data.Update(H.Mode.SET, damage, audits, melee_type_discrete, H.Metric.MAX) end
        if damage > 0 and (damage < DB.Data.Get(audits.player_name, melee_type_broad, H.Metric.MIN)) then DB.Data.Update(H.Mode.SET, damage, audits, melee_type_broad, H.Metric.MIN) end
        if damage > DB.Data.Get(audits.player_name, melee_type_broad, H.Metric.MAX) then DB.Data.Update(H.Mode.SET, damage, audits, melee_type_broad, H.Metric.MAX) end
    end
end

------------------------------------------------------------------------------------------------------
-- Captures additional effects from melee.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param result table
---@param no_damage? boolean whether or not the damage from this should be treated as actual damage or not.
------------------------------------------------------------------------------------------------------
H.Melee.Additional_Effect = function(audits, result, no_damage)
    if not result then return nil end
    if result.has_add_effect then
        local message_id = result.add_effect_message
        local animation_id = result.add_effect_animation
        local param = result.add_effect_param   -- This is either damage or the type of debuff applied.

        if message_id == Ashita.Enum.Message.ENSPELL then
            if no_damage then param = 0 end
            DB.Data.Update(H.Mode.INC, param, audits, H.Trackable.MAGIC,   H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC,     1, audits, H.Trackable.ENSPELL, H.Metric.HIT_COUNT)
            DB.Data.Update(H.Mode.INC,     1, audits, H.Trackable.MAGIC,   H.Metric.COUNT)       -- Used to flag that data is availabel for show in Focus.
            if Res.Spells.Get_Enspell_Type(animation_id) then
                local enspell_name = Res.Spells.Get_Enspell_Type(animation_id)
                DB.Catalog.Update_Damage(audits.player_name, audits.target_name, H.Trackable.ENSPELL, param, enspell_name)
                DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.ENSPELL, enspell_name, H.Metric.HIT_COUNT)
            end
        elseif message_id == Ashita.Enum.Message.ENDAMAGE then
            local effect_name = Res.Game.Get_Additional_Effect_Animation(animation_id)
            if animation_id then
                DB.Data.Update(H.Mode.INC, param, audits, H.Trackable.MAGIC,    H.Metric.TOTAL)
                DB.Data.Update(H.Mode.INC,     1, audits, H.Trackable.ENDAMAGE, H.Metric.HIT_COUNT)
                DB.Catalog.Update_Damage(audits.player_name, audits.target_name, H.Trackable.ENDAMAGE, param, effect_name)
                DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.ENDAMAGE, effect_name, H.Metric.HIT_COUNT)
            end
        elseif message_id == Ashita.Enum.Message.ENDEBUFF then
            local buff = Res.Buffs.Get_Buff(param)
            if buff then
                DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.ENDEBUFF, H.Metric.HIT_COUNT)
                DB.Catalog.Update_Metric(H.Mode.INC, 1, audits, H.Trackable.ENDEBUFF, buff.en, H.Metric.HIT_COUNT)
            end
        elseif message_id == Ashita.Enum.Message.ENDRAIN then
            -- Drain Samba and Blood Weapon do not contribute to net new damage.
            DB.Data.Update(H.Mode.INC, param, audits, H.Trackable.ENDRAIN, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.ENDRAIN, H.Metric.HIT_COUNT)
        elseif message_id == Ashita.Enum.Message.ENASPIR then
            DB.Data.Update(H.Mode.INC, param, audits, H.Trackable.ENASPIR, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.ENASPIR, H.Metric.HIT_COUNT)
        end
    end
end

------------------------------------------------------------------------------------------------------
-- Detects how much damage the player took from the spike damage.
------------------------------------------------------------------------------------------------------
---@param audits table Contains necessary entity audit data; helps save on parameter slots.
---@param result table action data
---@param owner_mob? table
------------------------------------------------------------------------------------------------------
H.Melee.Spikes = function(audits, result, owner_mob)
    if owner_mob or result.animation == Ashita.Enum.Animation.DAKEN then return nil end

    DB.Data.Update(H.Mode.INC, 1, audits, H.Trackable.MELEE_COUNTERED, H.Metric.COUNT)
    local spike_effect = result.has_spike_effect
    if spike_effect and not audits.pet_name then
        local damage = result.spike_effect_param
        local spike_message = result.spike_effect_message
        if spike_message == Ashita.Enum.Message.SPIKE_DMG then
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DAMAGE_TAKEN_TOTAL, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.SPELL_DMG_TAKEN, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.INCOMING_SPIKE_DMG, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, 1     , audits, H.Trackable.INCOMING_SPIKE_DMG, H.Metric.HIT_COUNT)
        elseif spike_message == Ashita.Enum.Message.COUNTER then
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.DAMAGE_TAKEN_TOTAL, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.MELEE_DMG_TAKEN, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, damage, audits, H.Trackable.MELEE_COUNTERED, H.Metric.TOTAL)
            DB.Data.Update(H.Mode.INC, 1     , audits, H.Trackable.MELEE_COUNTERED, H.Metric.HIT_COUNT)
        end
    end
end