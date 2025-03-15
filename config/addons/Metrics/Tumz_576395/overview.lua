require('common');

local settings = T{ };
settings["Visible"] = T{ };
settings["Melee"] = false;
settings["Pets"] = false;
settings["Ranged"] = false;
settings["Visible"][1] = false;
settings["Nuke"] = false;
settings["WS"] = false;
settings["X"] = 100;
settings["Mobs_Defeated"] = false;
settings["Y"] = 100;
settings["Defense"] = false;
settings["Healing"] = false;
settings["Timer"] = true;

return settings;
