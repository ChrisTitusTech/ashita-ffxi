addon.name      = 'HideActions';
addon.author    = 'Thorny';
addon.version   = '1.0';
addon.desc      = 'Modifies packets so the client believes you do not know specified actions.';
addon.link      = 'https://ashitaxi.com/';

require('common');

local spellIds = T{};
local weaponSkillIds = T{};
local jobAbilityIds = T{};
local petAbilityIds = T{};
local jobTraitIds = T{};
local mountIds = T{};

do
    local hideList = require('hidelist');
    local res = AshitaCore:GetResourceManager();

    for i = 0,1023 do
        local spell = res:GetSpellById(i);
        if spell and hideList.Spells:contains(spell.Name[1]) then
            spellIds:append(i);
        end
    end
    for i = 0,511 do
        local ws = res:GetAbilityById(i);
        if ws and hideList.WeaponSkills:contains(ws.Name[1]) then
            weaponSkillIds:append(i);
        end
    end
    for i = 512,1535 do
        local ja = res:GetAbilityById(i);
        if ja then
            if hideList.Abilities:contains(ja.Name[1]) then
                jobAbilityIds:append(i-512);
            elseif hideList.PetAbilities:contains(ja.Name[1]) then
                jobAbilityIds:append(i-512);
            end
        end
    end
    for i = 1536,1791 do
        local trait = res:GetAbilityById(i);
        if trait and hideList.Traits:contains(trait.Name[1]) then
            jobTraitIds:append(i-1536);
        end
    end
    for i = 0,63 do
        local mount = res:GetString('mounts.names', i, 0);
        if mount and hideList.Mounts:contains(mount) then
            mountIds:append(i);
        end
    end
end

ashita.events.register('packet_in', 'packet_in_cb', function (e)
    if (e.id == 0x0AA) then
        for _,id in ipairs(spellIds) do
            ashita.bits.pack_be(e.data_modified_raw, 0, 0x04, id, 1);
        end
    end

    if  (e.id == 0x0AC) then
        for _,id in ipairs(weaponSkillIds) do
            ashita.bits.pack_be(e.data_modified_raw, 0, 0x04, id, 1);
        end
        
        for _,id in ipairs(jobAbilityIds) do
            ashita.bits.pack_be(e.data_modified_raw, 0, 0x44, id, 1);
        end
        
        for _,id in ipairs(petAbilityIds) do
            ashita.bits.pack_be(e.data_modified_raw, 0, 0x84, id, 1);
        end
        
        for _,id in ipairs(jobTraitIds) do
            ashita.bits.pack_be(e.data_modified_raw, 0, 0xC4, id, 1);
        end
    end

    if (e.id == 0x0AE) then
        for _,id in ipairs(mountIds) do
            ashita.bits.pack_be(e.data_modified_raw, 0, 0x04, id, 1);
        end
    end
end);