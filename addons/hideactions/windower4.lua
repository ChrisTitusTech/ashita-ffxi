_addon.name    = 'HideActions'
_addon.author  = 'Thorny';
_addon.version = '1.0'

local bit = require('bit');
require('table');

local spellIds = {};
local weaponSkillIds = {};
local jobAbilityIds = {};
local petAbilityIds = {};
local jobTraitIds = {};
local mountIds = {};

do
    local res = require('resources');
    local hideList = require('hidelist');

    for i = 0,1023 do
        local spell = res.spells[i];
        if spell and hideList.Spells:contains(spell.en) then
            spellIds[i] = true;
        end
    end
    for i = 0,255 do
        local ws = res.weapon_skills[i];
        if ws and hideList.WeaponSkills:contains(ws.en) then
            weaponSkillIds[i] = true;
        end
    end
    for i = 0,1023 do
        local ja = res.job_abilities[i];
        if ja and hideList.Abilities:contains(ja.en) then
            jobAbilityIds[i] = true;
        end
    end
    for i = 0,1023 do
        local ja = res.job_abilities[i];
        if ja and hideList.PetAbilities:contains(ja.en) then
            jobAbilityIds[i] = true;
        end
    end
    for i = 0,255 do
        local trait = res.job_traits[i];
        if trait and hideList.Traits:contains(trait.en) then
            jobTraitIds[i] = true;
        end
    end
    for i = 0,63 do
        local mount = res.mounts[i];
        if mount and hideList.Mounts:contains(mount.en) then
            mountIds[i] = true;
        end
    end
end

local function HandleByte(byte, byteIndex, dataSet)
    local offset = byteIndex * 8;
    local validBits = 0xFF;
    for i = 0,7 do
        if dataSet[offset + i] then
            validBits = validBits - math.pow(2, i);
        end
    end

    local initialValue = string.byte(byte);
    local newValue = bit.band(initialValue, validBits);
    return string.char(newValue);
end

windower.register_event('incoming chunk', function(id, data)
    if (id == 0x0AA) then
        local byteIndex = 0;
        return string.gsub(data, "(.)", function(byte)
            byteIndex = byteIndex + 1;
            if byteIndex < 5 then
                return byte;
            elseif byteIndex < 133 then
                return HandleByte(byte, byteIndex-5, spellIds);
            else
                return byte;
            end
        end);
    end
    if (id == 0x0AC) then
        local byteIndex = 0;
        return string.gsub(data, "(.)", function(byte)
            byteIndex = byteIndex + 1;
            if byteIndex < 69 then
                return HandleByte(byte, byteIndex-5, weaponSkillIds);
            elseif byteIndex < 133 then
                return HandleByte(byte, byteIndex-69, jobAbilityIds);
            elseif byteIndex < 197 then
                return HandleByte(byte, byteIndex-133, petAbilityIds);
            elseif byteIndex < 229 then
                return HandleByte(byte, byteIndex-197, jobTraitIds);
            else
                return byte;
            end
        end);
    end
    if (id == 0x0AE) then
        local byteIndex = 0;
        return string.gsub(data, "(.)", function(byte)
            byteIndex = byteIndex + 1;
            if byteIndex < 5 then
                return byte;
            elseif byteIndex < 13 then
                return HandleByte(byte, byteIndex-5, mountIds);
            else
                return byte;
            end
        end);
    end
end);