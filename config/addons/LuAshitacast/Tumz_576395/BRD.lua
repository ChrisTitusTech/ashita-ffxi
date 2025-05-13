local profile = {};
local sets = {
    ['Default'] = {
        Main = 'Kaja Knife',
        Sub = 'Naegling',
        Range = 'Terpander',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Elite Royal Collar',
        Ear1 = { Name = 'Odnowa Earring +1', AugPath='A' },
        Ear2 = { Name = 'Fili Earring +1', Augment = { [1] = 'Accuracy+14', [2] = 'Damage taken-5%', [3] = 'Mag. Acc.+14' } },
        Body = 'Ayanmo Corazza +2',
        Hands = 'Nyame Gauntlets',
        Ring1 = 'Shneddick Ring',
        Ring2 = 'Stikini Ring',
        Back = 'Swith Cape',
        Waist = 'Plat. Mog. Belt',
        Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },
    ['empy'] = {
        Main = 'Kaja Knife',
        Sub = 'Naegling',
        Range = 'Terpander',
        Head = 'Fili Calot +1',
        Neck = 'Elite Royal Collar',
        Ear1 = { Name = 'Odnowa Earring +1', AugPath='A' },
        Ear2 = { Name = 'Fili Earring +1', Augment = { [1] = 'Accuracy+14', [2] = 'Damage taken-5%', [3] = 'Mag. Acc.+14' } },
        Body = 'Fili Hongreline +1',
        Hands = 'Fili Manchettes +1',
        Ring1 = 'Shneddick Ring',
        Ring2 = 'Stikini Ring',
        Back = 'Swith Cape',
        Waist = 'Plat. Mog. Belt',
        Legs = 'Fili Rhingrave +1',
        Feet = 'Fili Cothurnes +1',
    },
};
profile.Sets = sets;

profile.Packer = {
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
end

profile.HandleDefault = function()
end

profile.HandleAbility = function()
end

profile.HandleItem = function()
end

profile.HandlePrecast = function()
end

profile.HandleMidcast = function()
end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
end

return profile;