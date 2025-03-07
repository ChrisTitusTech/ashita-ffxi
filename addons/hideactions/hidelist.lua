return {
    Spells = T{ },
    WeaponSkills = T{ },
    Abilities = T{ },
    PetAbilities = T{ },
    Traits = T{ },
    Mounts = T{ },
};

--[[
    The default config is blank so you don't have things blocked you don't intend.  A configured example would look like this:

return {
    Spells = T{ 'Naji', 'Curilla', 'Zeid', 'Lion', 'Teleport-Dem' },
    WeaponSkills = T{ 'Fast Blade', 'Burning Blade' },
    Abilities = T{ 'Phantom Roll', 'Double-Up' },
    PetAbilities = T{ 'Retreat', 'Release' },
    Traits = T{ 'Resist Paralyze', 'Resist Silence' },
    Mounts = T{ 'Raptor', 'Red Crab' },
};

]]--