local gcheals = { };

gcheals.DebuffTimers ={};
gcheals.DebugParty = false;
gcheals.DebugHeals = false;
gcheals.DebugDebuffs = false;
gcheals.DebugAttacks = false;

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
        ["Cha8oon"] = true,
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
        ["KingOfHearts"] = true,
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

function gcheals.QueueSpell(spell, target)
    if not spell or not target then 
        print(chat.header('gcheals'):append(chat.error('Invalid spell or target')));
        return false;
    elseif gcinclude.CheckSpellBailout() == false then
        return false;
    end
    -- Cast the spell
    print(chat.header('gcheals'):append(chat.message('Casting: ' .. spell .. ' on ' .. target)));
    AshitaCore:GetChatManager():QueueCommand(-1, '/ma "' .. spell .. '" ' .. target);
    return true;
end

function gcheals.AutoCure(target)
    -- Set default values if not specified
    local curePotency = 50;
        
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
    
    if mainJob == 3 then -- WHM job ID
        -- Check if Afflatus Solace is not active
        if gData.GetBuffCount('Afflatus Solace') == 0 and gcinclude.CheckAbilityRecast('Afflatus Solace') == 0 then
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
        if gcheals.DebugHeals == true then gcheals.DebugPrint('Queueing ' .. selectedCure .. ' for ' .. targetName) end;
        gcheals.QueueSpell(selectedCure, targetSyntax);
        return true;
    end
end

function gcheals.GetParty()
    local trustNames = gcheals.GetTrustNames();
    local partyMembers = {};
    local party = AshitaCore:GetMemoryManager():GetParty();
    local partySize = party:GetAlliancePartyMemberCount1();
    
    -- Index Party zone hp and distance
    if gcheals.DebugParty then gcheals.DebugPrint('Starting party check - Party size: ' .. tostring(partySize)) end
    
    for i = 0, partySize - 1 do
        local memberName = party:GetMemberName(i);
        if memberName then
            local isTrust = trustNames[memberName] and true or false;
            
            -- Debug output for each party member
            if gcheals.DebugParty then gcheals.DebugPrint('Member [' .. i .. ']: ' .. memberName .. ' (Trust: ' .. tostring(isTrust) .. ')') end
            
            -- Add to overall party list
            table.insert(partyMembers, {
                index = i,
                name = memberName,
                hpp = party:GetMemberHPPercent(i) or 0,
                currentHP = party:GetMemberHP(i) or 0,
                zone = party:GetMemberZone(i) or 0,
                isTrust = isTrust,
                distance = 0 -- Initialize distance value
            });
            
            -- Try to get the entity's distance if it exists
            local entityMgr = AshitaCore:GetMemoryManager():GetEntity();
            if entityMgr then
                -- Get the actual entity array size
                local entityCount = entityMgr:GetEntityMapSize();
                
                -- Search for the entity by name
                for j = 0, entityCount - 1 do
                    local entName = entityMgr:GetName(j);
                    if entName == memberName then
                        partyMembers[#partyMembers].distance = entityMgr:GetDistance(j);
                        if gcheals.DebugParty and partyMembers[#partyMembers].distance > 0 then 
                            gcheals.DebugPrint('Found entity ' .. memberName .. ' at index ' .. j .. 
                                ' with distance: ' .. tostring(partyMembers[#partyMembers].distance));
                        end
                        break;
                    end
                end
            end
        end
    end
    return partyMembers;
end

function gcheals.CheckTrustMembers()
    local partyMembers = gcheals.GetParty();
    local numberOfTrusts = 0;
    
    for i = 1, #partyMembers do
        if partyMembers[i].isTrust then
            numberOfTrusts = numberOfTrusts + 1;
        end
    end
    
    return numberOfTrusts;
end

function gcheals.CheckParty()
    local partyMembers = gcheals.GetParty();
    -- Find the most injured party member
    local lowestHpp = 100
    local mostInjuredIndex = 0
    local numberOfInjured = 0
    local numberOfMinorInjured = 0
    
    for i = 1, #partyMembers do
        -- Note on Entity Distance - Trusts are 0 and distance is NOT in yalms but a unique unit that is much smaller than yalms which means higher number
        if partyMembers[i] and partyMembers[i].isTrust or partyMembers[i].zone == partyMembers[1].zone and partyMembers[i].distance < 350 then
            if partyMembers[i].hpp < 70 and partyMembers[i].hpp > 0 then
                numberOfInjured = numberOfInjured + 1
            elseif partyMembers[i].hpp < 85 and partyMembers[i].hpp > 0 then
                numberOfMinorInjured = numberOfMinorInjured + 1
            end
            if partyMembers[i] and partyMembers[i].hpp < lowestHpp and partyMembers[i].hpp > 0 then
                lowestHpp = partyMembers[i].hpp
                mostInjuredIndex = partyMembers[i].index
                if gcheals.DebugHeals == true then gcheals.DebugPrint('Found injured member: ' .. partyMembers[i].name .. 
                    ' (HP%: ' .. tostring(lowestHpp) .. ')') end;
            end
        end
    end
    local player = gData.GetPlayer();
    local recast = AshitaCore:GetMemoryManager():GetRecast();
    local curaRecast = recast:GetSpellTimer(475);
    local curaga2Recast = recast:GetSpellTimer(8);
    local curaga3Recast = recast:GetSpellTimer(9);
    local diaRecast = recast:GetSpellTimer(24);
    local paraRecast = recast:GetSpellTimer(58);
    local target = gData.GetTarget()
    local targetSyntax = '<me>';
    local injuredDistance = 0;
    if mostInjuredIndex > 0  then
        targetSyntax = string.format('<p%d>', mostInjuredIndex);
        injuredDistance = partyMembers[mostInjuredIndex].Distance
    else
        injuredDistance = 400;
    end

    if mostInjuredIndex then
        if lowestHpp < 75 and numberOfInjured == 1 then
            if gcheals.DebugHeals == true then gcheals.DebugPrint('Attempting to cure member at index: ' .. tostring(mostInjuredIndex)) end;
            gcheals.AutoCure(mostInjuredIndex)
        elseif lowestHpp < 85 and numberOfMinorInjured > 1 and injuredDistance < 350 and curaRecast == 0 then
            if gcheals.DebugHeals == true then gcheals.DebugPrint('Attempting party Cura III') end;
            gcheals.QueueSpell('Cura III', '<me>');
        elseif lowestHpp < 75 and numberOfInjured > 1 and curaga3Recast == 0 then
            if gcheals.DebugHeals == true then gcheals.DebugPrint('Attempting party Curaga III') end;
            gcheals.QueueSpell('Curaga III', targetSyntax);
        elseif lowestHpp < 85 and numberOfMinorInjured > 1 and curaga2Recast == 0 then
            if gcheals.DebugHeals == true then gcheals.DebugPrint('Attempting party Curaga II') end;
            gcheals.QueueSpell('Curaga II', targetSyntax);
        end
    else
        if gcheals.DebugHeals == true then gcheals.DebugPrint('No members need healing at this time') end;
        if (player.Status == 'Engaged') and (gcdisplay.GetToggle('Solo') == true) then
            if (player.TP >= 1000) and gcinclude.CheckWsBailout() == true then
                local mainWeapon = gData.GetEquipment().Main;
                if (player.MPP > 80) then
                    AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Hexa Strike" <t>');
                elseif (player.MPP <= 80) then
                    AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Mystic Boon" <t>');
                end
            end
            if (gData.GetBuffCount('Haste') == 0) and gcinclude.CheckSpellBailout() == true then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Haste" <me>');
            elseif (gData.GetBuffCount('Protect') == 0) and gcinclude.CheckSpellBailout() == true then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Protectra V" <me>');
            elseif (gData.GetBuffCount('Shell') == 0) and gcinclude.CheckSpellBailout() == true then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Shellra V" <me>');
            elseif (gData.GetBuffCount('STR Boost') == 0) and gcinclude.CheckSpellBailout() == true then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Boost-STR" <me>');
            elseif gcinclude.CheckAbilityRecast('Healing Waltz') == 0 and player.TP >= 200 and gData.GetBuffCount('Paralysis') ~= 0 and player.SubJob == 'DNC' then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Healing Waltz" <me>');    
            elseif gData.GetBuffCount('Haste Samba') == 0 and gcinclude.CheckAbilityRecast('Sambas') == 0 and (player.TP >= 350) and player.SubJob == 'DNC' then
                AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Haste Samba" <me>');
            end
            
        elseif target and player.status ~= 'Engaged' and gcinclude.CheckSpellBailout() == true and (gcdisplay.GetToggle('Solo') == true) then
            if target.Type == 'Monster' and target.Distance < 21 and string.find(target.Name, 'Apex') then
                if gcheals.DebugAttacks == true then print(chat.header('gcheals'):append(chat.message('Target Found: ' .. target.Name .. ' Target Distance: ' .. target.Distance))) end;
                if diaRecast == 0 and player.HPP > 85 and target.Distance > 5 then AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Dia II" <t>'); 
                elseif paraRecast == 0 and player.HPP > 85 then AshitaCore:GetChatManager():QueueCommand(-1, '/ma "Paralyze" <t>'); end

            end
        end
    end
end

function gcheals.DebugPrint(message)

        print(chat.header('gcheals'):append(chat.message(message)));

end



return gcheals;

