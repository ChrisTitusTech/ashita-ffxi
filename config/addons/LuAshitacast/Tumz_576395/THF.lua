local profile = {};
local sets = {
    ['th'] = {
        Main = 'Kaja Knife',
        Sub = 'Thief\'s Knife',
        Ammo = 'Per. Lucky Egg',
        Head = 'Wh. Rarab Cap +1',
        Neck = 'Bathy Choker +1',
        Ear1 = 'Eabani Earring',
        Ear2 = 'Cessance Earring',
        Body = { Name = 'Adhemar Jacket +1', AugPath='A' },
        Hands = { Name = 'Herculean Gloves', Augment = { [1] = 'Pet: INT+10', [2] = '"Treasure Hunter"+1', [3] = 'Accuracy+8', [4] = '"Mag. Atk. Bns."+18', [5] = 'Attack+8', [6] = 'Mag. Acc.+18' } },
        Ring1 = 'Shneddick Ring',
        Ring2 = 'Warp Ring',
        Back = { Name = 'Toutatis\'s Cape', Augment = { [1] = 'Damage taken-5%', [2] = 'Accuracy+20', [3] = 'Weapon skill damage +10%', [4] = 'Attack+20', [5] = 'DEX+20' } },
        Waist = 'Plat. Mog. Belt',
        Legs = 'Meg. Chausses +2',
        Feet = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+24', [2] = 'Pet: DEX+8', [3] = 'Attack+1', [4] = '"Treasure Hunter"+1' } },
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