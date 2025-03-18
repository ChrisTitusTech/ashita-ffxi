local gcheals = { };

gcheals.DebuffTimers = {};
gcheals.SpellQueue = { spell = nil, target = nil, timestamp = 0 };
gcheals.LastAction = { spell = nil, target = nil, timestamp = 0 };
gcheals.DebugTrusts = false;
gcheals.DebugHeals = false;

function gcheals.GetTrustNames()
    -- Trust names table (returns a lookup table for quick checking)
    local trusts = {
        -- A
        ["Ajido-Marujido"] = true,
        ["Aldo"] = true,
        ["Amchuchu"] = true,
        ["Apururu (UC)"] = true,
        ["Arciela"] = true,
        ["Arciela II"] = true,
        ["ArkEV"] = true,
        ["AAEV"] = true,
        ["August"] = true,
        ["Ayame"] = true,
        
        -- B
        ["Babban"] = true,
        ["Balamor"] = true,
        ["Brygid"] = true,
        ["Bubbles-Rabelles"] = true,
        
        -- C
        ["Cascadien"] = true,
        ["Chacharoon"] = true,
        ["Cherukiki"] = true,
        ["Cid"] = true,
        ["Cornelia"] = true,
        ["Curilla"] = true,
        
        -- D
        ["D. Shantotto"] = true,
        ["Darrcuiln"] = true,
        ["Domina Shantotto"] = true,
        
        -- E
        ["Elivira"] = true,
        ["Excenmille"] = true,
        ["Excenmille [S]"] = true,
        
        -- F
        ["Fablinix"] = true,
        ["Ferreous Coffin"] = true,
        ["Flaviria"] = true,
        
        -- G
        ["Gadalar"] = true,
        ["Gattsuo"] = true,
        ["Gessho"] = true,
        ["Gilgamesh"] = true,
        
        -- H
        ["Halver"] = true,
        
        -- I
        ["Ingrid"] = true,
        ["Ingrid II"] = true,
        ["Iroha"] = true,
        ["Iroha II"] = true,
        ["Ygnas"] = true,
        
        -- J
        ["Joachim"] = true,
        
        -- K
        ["Kayeel-Payeel"] = true,
        ["King of Hearts"] = true,
        ["Klara"] = true,
        ["Koru-Moru"] = true,
        ["Kukki-Chebukki"] = true,
        ["Kupipi"] = true,
        ["Kupofried"] = true,
        
        -- L
        ["Lehko Habhoka"] = true,
        ["Leonoyne"] = true,
        ["Lilisette"] = true,
        ["Lilisette II"] = true,
        ["Lion"] = true,
        ["Lion II"] = true,
        ["Lhe Lhangavo"] = true,
        ["Luzaf"] = true,
        
        -- M
        ["Maat"] = true,
        ["Makki-Chebukki"] = true,
        ["Margret"] = true,
        ["Matsui-P"] = true,
        ["Maximilian"] = true,
        ["Mayakov"] = true,
        ["Mihli Aliapoh"] = true,
        ["Mildaurion"] = true,
        ["Mnejing"] = true,
        ["Moogle"] = true,
        ["Monberaux"] = true,
        ["Morimar"] = true,
        
        -- N
        ["Nashmeira"] = true,
        ["Nashmeira II"] = true,
        ["Naja Salaheem"] = true,
        ["Nanaa Mihgo"] = true,
        ["Najelith"] = true,
        ["Naji"] = true,
        ["Nokoh Hachuuxo"] = true,
        
        -- O
        ["Ovjang"] = true,
        
        -- P
        ["Prishe"] = true,
        ["Prishe II"] = true,
        
        -- Q
        ["Qultada"] = true,
        
        -- R
        ["Rahal"] = true,
        ["Rainemard"] = true,
        ["Robel-Akbel"] = true,
        ["Rosulatia"] = true,
        ["Rughadjeen"] = true,
        
        -- S
        ["Sakura"] = true,
        ["Selh'teus"] = true,
        ["Semih Lafihna"] = true,
        ["Shantotto"] = true,
        ["Shantotto II"] = true,
        ["Shikaree Z"] = true,
        ["Star Sibyl"] = true,
        ["Sylvie"] = true,
        
        -- T
        ["Tenzen"] = true,
        ["Tenzen II"] = true,
        ["Teodor"] = true,
        ["Trion"] = true,
        
        -- U
        ["Ullegore"] = true,
        ["Ulmia"] = true,
        
        -- V
        ["Valaineral"] = true,
        ["Volker"] = true,
        
        -- W
        ["Wildkeeper Reive"] = true,
        
        -- Y
        ["Yoran-Oran"] = true,
        
        -- Z
        ["Zazarg"] = true,
        ["Zeid"] = true,
        ["Zeid II"] = true,
    }
    
    return trusts
end

function gcheals.CheckDebuff(target)
    -- Table of WHM-curable debuff IDs
    local whmDebuffs = {
        [2] = 'Sleep',
        [3] = 'Poison',
        [4] = 'Paralysis',
        [5] = 'Blind',
        [6] = 'Silence',
        [7] = 'Petrification',
        [8] = 'Disease',
        [9] = 'Curse',
        [10] = 'Stun',
        [11] = 'Bind',
        [12] = 'Weight',
        [13] = 'Slow',
        [15] = 'Doom',
        [16] = 'Amnesia',
        [31] = 'Plague'
    };

    local partyManager = AshitaCore:GetMemoryManager():GetParty();
    if not partyManager then return {} end

    local memberDebuffs = {};
    local currentTime = os.time();
    local trustNames = gcheals.GetTrustNames();
    
    -- Default to player if no target is specified
    local targetIndex = target or 0;
    local memberName = partyManager:GetMemberName(targetIndex);
    
    if not memberName then return {} end
    
    -- Skip if member is a trust
    if trustNames[memberName] then return {} end
    
    -- Initialize timer table for this member if it doesn't exist
    if not gcheals.DebuffTimers[memberName] then
        gcheals.DebuffTimers[memberName] = {};
    end
    
    -- Check if the target is the player (index 0)
    if targetIndex == 0 then
        local statusManager = AshitaCore:GetMemoryManager():GetPlayer():GetStatusIcons();
        
        -- Read all status effects
        for i = 1, 32 do
            local statusId = statusManager[i];
            if statusId ~= 255 and statusId > 0 and whmDebuffs[statusId] then
                local debuffName = whmDebuffs[statusId];
                local lastAlert = gcheals.DebuffTimers[memberName][debuffName] or 0;
                
                -- Only include debuff if 30 seconds have passed since last alert
                if (currentTime - lastAlert) >= 30 then
                    table.insert(memberDebuffs, debuffName);
                    gcheals.DebuffTimers[memberName][debuffName] = currentTime;
                end
            end
        end
    else
        -- Get party member's status effects
        -- First make sure this is not a trust, AND that the index is valid
        if trustNames[memberName] then 
            return {}
        end
        
        -- In Ashita's API, GetMemberStatusIcons can return nil even for valid party members
        -- First check if the member is in zone and has valid data
        local memberServerId = partyManager:GetMemberServerId(targetIndex);
        if memberServerId == 0 then
            return {} -- Member exists but doesn't have server ID yet (data not loaded)
        end
        
        local memberStatus = partyManager:GetMemberStatusIcons(targetIndex);
        if memberStatus then
            for j = 1, 32 do
                local statusId = memberStatus[j];
                if statusId ~= 255 and statusId > 0 and whmDebuffs[statusId] then
                    local debuffName = whmDebuffs[statusId];
                    local lastAlert = gcheals.DebuffTimers[memberName][debuffName] or 0;
                    
                    -- Only include debuff if 30 seconds have passed since last alert
                    if (currentTime - lastAlert) >= 30 then
                        table.insert(memberDebuffs, debuffName);
                        gcheals.DebuffTimers[memberName][debuffName] = currentTime;
                    end
                end
            end
        end
    end
    
    -- Clean up this member's timer entries
    for debuffName, timestamp in pairs(gcheals.DebuffTimers[memberName]) do
        if (currentTime - timestamp) >= 35 then  -- Clean up entries older than 35 seconds
            gcheals.DebuffTimers[memberName][debuffName] = nil;
        end
    end
    
    -- Remove member entry if they have no debuffs
    if next(gcheals.DebuffTimers[memberName]) == nil then
        gcheals.DebuffTimers[memberName] = nil;
    end
    
    return memberDebuffs;
end

function gcheals.QueueSpell(spell, target)
    -- Validate inputs
    if not spell or not target then 
        print(chat.header('gcheals'):append(chat.error('Invalid spell or target')));
        return false;
    end
    
    -- Check if we can cast spells
    if not gcinclude.CheckSpellBailout() then
        gcheals.SpellQueue = { spell = nil, target = nil, timestamp = 0 }; -- Clear queue if we can't cast
        return false;
    end
    
    -- Check player status
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    if not player then return false end
    
    local currentAction = gData.GetAction();
    if gcheals.LastAction.spell and os.time() - gcheals.LastAction.timestamp < 2 then return false end

    -- Prevent double casting of the same spell
    if currentAction then
        -- Only check if the queue has an active spell
        if gcheals.SpellQueue.spell and 
           ((target == gcheals.SpellQueue.target) and
            ((spell:match("Cure%s?[IVX]*") and gcheals.SpellQueue.spell:match("Cure%s?[IVX]*")) or
             spell == gcheals.SpellQueue.spell or
             (spell:match("na$") and gcheals.SpellQueue.spell:match("na$")) or
             (spell:match("Erase") and gcheals.SpellQueue.spell:match("Erase")))) then
            return false;
        end
    end
    
    -- Update the queue with the new spell (instead of adding to an array)
    gcheals.SpellQueue = { 
        spell = spell, 
        target = target, 
        timestamp = os.time() 
    };

    -- Cast the spell
    print(chat.header('gcheals'):append(chat.message('Casting: ' .. spell .. ' on ' .. target)));
    AshitaCore:GetChatManager():QueueCommand(-1, '/ma "' .. spell .. '" ' .. target);
    gcheals.LastAction = { 
        spell = spell, 
        target = target, 
        timestamp = os.time() 
    };
    return true;
end

function gcheals.AutoCure(target)
    -- Set default values if not specified
    local curePotency = 50;
    local ignoreMissingHP = 200;
    
    -- Get player information
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    local mainJob = player:GetMainJob();
    local mainJobLevel = player:GetMainJobLevel();
    local party = AshitaCore:GetMemoryManager():GetParty();
    
    if not player or not party then 
        print(chat.header('gcheals'):append(chat.error('Player or party data not available')));
        return false 
    end

    -- Convert numerical target to proper FFXI syntax
    local targetSyntax = '<me>';
    if target > 0 and target <= 5 then
        targetSyntax = string.format('<p%d>', target);
    end
    
    -- Check if WHM and handle Afflatus Solace
    if mainJob == 3 then -- WHM job ID
        -- Check if Afflatus Solace is not active
        if gData.GetBuffCount('Afflatus Solace') == 0 then
            -- Check if Afflatus Solace is ready
            print(chat.header('gcheals'):append(chat.message('Activating Afflatus Solace')));
            AshitaCore:GetChatManager():QueueCommand(1, '/ja "Afflatus Solace" <me>');
            return true;
        end
    end
    
    -- Get current MP safely
    local currentMP = party:GetMemberMP(0);
    if not currentMP or currentMP <= 0 then 
        print(chat.header('gcheals'):append(chat.error('No MP available')));
        return false 
    end
    
    -- Get target information directly from party manager
    local targetName = party:GetMemberName(target);
    local targetHP = party:GetMemberHP(target);
    local targetHPP = party:GetMemberHPPercent(target);
    
    -- Validate basic target info
    if not targetName or not targetHP or not targetHPP or targetHPP <= 0 then 
        print(chat.header('gcheals'):append(chat.error('Invalid target information')));
        return false 
    end

    local targetMaxHP = math.floor(targetHP / (targetHPP / 100));
    local targetCurrentHP = targetHP;
    
    -- Define spell costs
    local spellCosts = {
        ['Cure'] = 8,
        ['Cure II'] = 24,
        ['Cure III'] = 46,
        ['Cure IV'] = 88,
        ['Cure V'] = 135,
        ['Cure VI'] = 227,
        ['Cursna'] = 20,
        ['Silena'] = 15,
        ['Erase'] = 25,
        ['Viruna'] = 15,
        ['Stona'] = 15,
        ['Paralyna'] = 15,
        ['Blindna'] = 15,
        ['Poisona'] = 15
    };

    -- Calculate missing HP
    local missingHP = targetMaxHP - targetCurrentHP;
    if missingHP <= ignoreMissingHP then 
        gcheals.DebugPrint('Missing HP (' .. missingHP .. ') below threshold (' .. ignoreMissingHP .. ')');
        return false 
    end

    -- Define cure potencies (base values)
    local curePotencies = {
        ['Cure'] = 65,
        ['Cure II'] = 145,
        ['Cure III'] = 400,
        ['Cure IV'] = 700,
        ['Cure V'] = 1000,
        ['Cure VI'] = 2000
    };

    -- Calculate cure potency multiplier (adding base 100%)
    local potencyMultiplier = 1 + (curePotency / 100);
    
    -- Calculate how much we want to cure for based on missing HP and potency
    local desiredCure = missingHP / potencyMultiplier;
    
    -- Select appropriate cure spell based on desired cure amount and available spells
    local selectedCure = nil;
    
    -- Normal cure selection logic - Compare against base cure values
    if desiredCure <= curePotencies['Cure'] and mainJobLevel >= 1 then
        selectedCure = 'Cure';
    elseif desiredCure <= curePotencies['Cure II'] and mainJobLevel >= 11 then
        selectedCure = 'Cure II';
    elseif desiredCure <= curePotencies['Cure III'] and mainJobLevel >= 21 then
        selectedCure = 'Cure III';
    elseif desiredCure <= curePotencies['Cure IV'] and mainJobLevel >= 41 then
        selectedCure = 'Cure IV';
    elseif desiredCure <= curePotencies['Cure V'] and mainJobLevel >= 61 then
        selectedCure = 'Cure V';
    elseif mainJobLevel >= 71 then  -- If none of the above match, use Cure VI as fallback
        selectedCure = 'Cure VI';
    end
    
    -- Check if we can cast the selected cure (MP check)
    if selectedCure and spellCosts[selectedCure] <= currentMP then
        gcheals.DebugPrint('Queueing ' .. selectedCure .. ' for ' .. targetName);
        gcheals.QueueSpell(selectedCure, targetSyntax);
        return true;
    end

    -- Create a priority map for debuff handling
    local debuffHandlers = {
        ['Curse'] = { spell = 'Cursna', cost = spellCosts['Cursna'] },
        ['Doom'] = { spell = 'Cursna', cost = spellCosts['Cursna'] },
        ['Silence'] = { spell = 'Silena', cost = spellCosts['Silena'] },
        ['Slow'] = { spell = 'Erase', cost = spellCosts['Erase'] },
        ['Weight'] = { spell = 'Erase', cost = spellCosts['Erase'] },
        ['Bind'] = { spell = 'Erase', cost = spellCosts['Erase'] },
        ['Amnesia'] = { spell = 'Erase', cost = spellCosts['Erase'] },
        ['Disease'] = { spell = 'Viruna', cost = spellCosts['Viruna'] },
        ['Plague'] = { spell = 'Viruna', cost = spellCosts['Viruna'] },
        ['Sleep'] = { spell = 'Cure', cost = spellCosts['Cure'] },
        ['Petrification'] = { spell = 'Stona', cost = spellCosts['Stona'] },
        ['Paralysis'] = { spell = 'Paralyna', cost = spellCosts['Paralyna'] },
        ['Blind'] = { spell = 'Blindna', cost = spellCosts['Blindna'] },
        ['Poison'] = { spell = 'Poisona', cost = spellCosts['Poisona'] }
    };
    
    -- Process debuffs in priority order
    for _, debuff in ipairs(targetDebuffs) do
        local handler = debuffHandlers[debuff];
        if handler and handler.cost <= currentMP then
            gcheals.DebugPrint('Handling debuff: ' .. debuff .. ' on ' .. targetName);
            gcheals.QueueSpell(handler.spell, targetSyntax);
            return true;
        end
    end
    
    gcheals.DebugPrint('No suitable cure found for ' .. targetName);
    return false;
end

function gcheals.CheckParty()
    local trustNames = gcheals.GetTrustNames();
    local partyMembers = {};
    local party = AshitaCore:GetMemoryManager():GetParty();
    local partySize = party:GetAlliancePartyMemberCount1();
    
    -- Debug output for trust detection
    if gcheals.DebugTrusts then gcheals.DebugPrint('Starting party check - Party size: ' .. tostring(partySize)) end
    
    for i = 0, partySize - 1 do
        local memberName = party:GetMemberName(i);
        if memberName then
            local isTrust = trustNames[memberName] and true or false;
            
            -- Debug output for each party member
            if gcheals.DebugTrusts then gcheals.DebugPrint('Member [' .. i .. ']: ' .. memberName .. ' (Trust: ' .. tostring(isTrust) .. ')') end
            
            -- Add to overall party list
            table.insert(partyMembers, {
                index = i,
                name = memberName,
                hpp = party:GetMemberHPPercent(i) or 0,
                currentHP = party:GetMemberHP(i) or 0,
                isTrust = isTrust
            });
            
            -- Check for debuffs on non-trust party members
            if not isTrust then
                local memberDebuffs = gcheals.CheckDebuff(i);
                -- Debug debuffs found
                if memberDebuffs and #memberDebuffs > 0 then
                    gcheals.DebugPrint('Debuffs for ' .. memberName .. ': ' .. table.concat(memberDebuffs, ', '));
                    partyMembers[#partyMembers].debuffs = memberDebuffs;
                end
            end
        end
    end
    
    -- Find the most injured party member
    local lowestHpp = 100
    local mostInjuredIndex = nil
    
    for i = 1, #partyMembers do
        if partyMembers[i] and partyMembers[i].hpp < lowestHpp then
            lowestHpp = partyMembers[i].hpp
            mostInjuredIndex = partyMembers[i].index
            gcheals.DebugPrint('Found injured member: ' .. partyMembers[i].name .. 
                ' (HP%: ' .. tostring(lowestHpp) .. ')');
        end
    end
    
    -- Auto-cure the most injured member if they're below a certain threshold
    if mostInjuredIndex and lowestHpp < 75 then  -- You can adjust this threshold
        gcheals.DebugPrint('Attempting to cure member at index: ' .. tostring(mostInjuredIndex));
        gcheals.AutoCure(mostInjuredIndex)
    else
        gcheals.DebugPrint('No members need healing at this time');
    end
end

function gcheals.DebugPrint(message)
    if gcheals.DebugHeals then
        print(chat.header('gcheals'):append(chat.message(message)));
    end
end

return gcheals;

