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
    local player = gData.GetPlayer();
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
    if player.MPP < 8 then 
        print(chat.header('gcheals'):append(chat.error('No MP available')));
        return false 
    end
    
    if player.MainJob == 'WHM' and string.find(spell, 'Cure') then
        if gData.GetBuffCount('Afflatus Solace') == 0 and gcinclude.CheckAbilityRecast('Afflatus Solace') == 0 and gData.GetBuffCount('Afflatus Misery') == 0 then
            print(chat.header('gcheals'):append(chat.message('Activating Afflatus Solace')));
            AshitaCore:GetChatManager():QueueCommand(1, '/ja "Afflatus Solace" <me>');
            return true;
        end
    end
    
    if not spell or not target then 
        print(chat.header('gcheals'):append(chat.error('Invalid spell or target')));
        return false;
    elseif gcinclude.CheckSpellBailout() == false then
        return false;
    end
    if target ~= '<me>' and string.find(spell, 'Cure') then
        local cleanTarget = tonumber(target:sub(3, 3));
        spell = gcheals.SelectCure(cleanTarget);
    end
    -- Cast the spell
    print(chat.header('gcheals'):append(chat.message('Casting: ' .. spell .. ' on ' .. target)));
    AshitaCore:GetChatManager():QueueCommand(-1, '/ma "' .. spell .. '" ' .. target);
    return true;
end

function gcheals.SelectCure(target)
    local party = AshitaCore:GetMemoryManager():GetParty();
    local curePotency = 50;
    local targetName = party:GetMemberName(target);
    local targetHP = party:GetMemberHP(target);
    local targetHPP = party:GetMemberHPPercent(target);
    if not targetName or not targetHP or not targetHPP or targetHPP <= 0 then 
        print(chat.header('gcheals'):append(chat.error('Invalid target information')));
        return false 
    end
    local targetMaxHP = math.floor(targetHP / (targetHPP / 100));
    local targetCurrentHP = targetHP;
    local missingHP = targetMaxHP - targetCurrentHP;
    local potencyMultiplier = 1 + (curePotency / 100);
    -- Define cure potencies (base values)
    local curePotencies = {
        ['Cure'] = 65*potencyMultiplier,
        ['Cure II'] = 145*potencyMultiplier,
        ['Cure III'] = 340*potencyMultiplier,
        ['Cure IV'] = 640*potencyMultiplier,
        ['Cure V'] = 780*potencyMultiplier,
        ['Cure VI'] = 1010*potencyMultiplier
    };

    local selectedCure = nil;
    if missingHP <= curePotencies['Cure III']then
        selectedCure = 'Cure III';
    elseif missingHP <= curePotencies['Cure IV'] then
        selectedCure = 'Cure IV';
    elseif missingHP <= curePotencies['Cure V'] then
        selectedCure = 'Cure V';
    elseif missingHP >= 71 then  -- If none of the above match, use Cure VI as fallback
        selectedCure = 'Cure VI';
    end
    return selectedCure;
end

function gcheals.GetParty()
    local trustNames = gcheals.GetTrustNames();
    local partyMembers = {};
    local party = AshitaCore:GetMemoryManager():GetParty();
    local partySize = party:GetAlliancePartyMemberCount1();
    -- Note: all Ashita arrays start at 0 and partyMembers array will start at 1
    -- Initialize party members array
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
                pnum = i,
                name = memberName,
                HPP = party:GetMemberHPPercent(i) or 0,
                currentHP = party:GetMemberHP(i) or 0,
                zone = party:GetMemberZone(i) or 0,
                isTrust = isTrust,
                distance = 0 -- Initialize distance value
            });
            
            -- Try to get the entity's distance if it exists
            local entityMgr = AshitaCore:GetMemoryManager():GetEntity();
            if entityMgr and partyMembers[i+1].isTrust == false then
                -- Get the actual entity array size
                local entityCount = entityMgr:GetEntityMapSize();
                
                -- Search for the entity by name
                for j = 0, entityCount - 1 do
                    local entName = entityMgr:GetName(j);
                    if entName == memberName then
                        partyMembers[i+1].distance = math.sqrt(entityMgr:GetDistance(j));
                        if gcheals.DebugParty and partyMembers[i+1].distance > 0 then 
                            gcheals.DebugPrint('Found entity ' .. memberName .. ' at index ' .. j .. 
                                ' with distance: ' .. tostring(partyMembers[i+1].distance));
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
    local player = gData.GetPlayer();
    local recast = AshitaCore:GetMemoryManager():GetRecast();
    local curaRecast = recast:GetSpellTimer(475);
    local curaga2Recast = recast:GetSpellTimer(8);
    local curaga3Recast = recast:GetSpellTimer(9);
    local targetSyntax = '<me>';

    if player.Status == 'Zoning' then return end
    local partyMembers = gcheals.GetParty();
    -- Find the most injured party member
    local lowestHPP = 100
    local mostInjuredIndex = 1
    local mostDistant = 0
    local numberOfInjured = 0
    local numberOfMinorInjured = 0
    local injuredDistance = 0
    
    for i = 1, #partyMembers do
        if partyMembers[i].isTrust or (partyMembers[i].zone == partyMembers[1].zone and partyMembers[i].distance < 21) then
            if partyMembers[i].HPP < 70 and partyMembers[i].HPP > 0 then
                numberOfInjured = numberOfInjured + 1
            elseif partyMembers[i].HPP < 80 and partyMembers[i].HPP > 0 then
                numberOfMinorInjured = numberOfMinorInjured + 1
            end
            if partyMembers[i].HPP < lowestHPP and partyMembers[i].HPP > 0 then
                lowestHPP = partyMembers[i].HPP
                mostInjuredIndex = i
                if gcheals.DebugHeals == true then gcheals.DebugPrint('Found injured member: ' .. partyMembers[i].name .. 
                    ' (HP%: ' .. tostring(lowestHPP) .. ')') end;
            end
            if partyMembers[i].distance > mostDistant and partyMembers[i].isTrust == false then
                mostDistant = partyMembers[i].distance
            end
        end
    end
    if partyMembers[mostInjuredIndex] then
        targetSyntax = string.format('<p%d>', partyMembers[mostInjuredIndex].pnum);
        if partyMembers[mostInjuredIndex].isTrust == false then injuredDistance = partyMembers[mostInjuredIndex].distance; end
    end

    if mostInjuredIndex then
        if lowestHPP < 75 and (numberOfInjured == 1 or player.MPP <= 25) and injuredDistance < 21 then
            if gcheals.DebugHeals == true then gcheals.DebugPrint('Attempting to cure member at index: ' .. tostring(mostInjuredIndex)) end;
            gcheals.QueueSpell('Cure IV', targetSyntax);
        elseif lowestHPP > 50 and lowestHPP < 80 and curaRecast == 0 and numberOfMinorInjured > 1 and mostDistant < 11 and player.MainJob == 'WHM' then
            if gcheals.DebugHeals == true then gcheals.DebugPrint('Attempting party Cura III') end;
            gcheals.QueueSpell('Cura III', '<me>');
        elseif lowestHPP < 70 and numberOfInjured > 1 and curaga3Recast == 0 and player.MPP > 25 and injuredDistance < 21 then
            if gcheals.DebugHeals == true then gcheals.DebugPrint('Attempting party Curaga III') end;
            gcheals.QueueSpell('Curaga III', targetSyntax);
        elseif lowestHPP < 80 and numberOfMinorInjured > 1 and curaga2Recast == 0 and player.MPP > 25 and injuredDistance < 21 then
            if gcheals.DebugHeals == true then gcheals.DebugPrint('Attempting party Curaga II') end;
            gcheals.QueueSpell('Curaga II', targetSyntax);
        end
    else
        if gcheals.DebugHeals == true then gcheals.DebugPrint('No members need healing at this time') end;
    end
end

function gcheals.DebugPrint(message)

        print(chat.header('gcheals'):append(chat.message(message)));

end



return gcheals;

