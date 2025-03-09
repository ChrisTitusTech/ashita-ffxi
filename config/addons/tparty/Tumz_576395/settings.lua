require('common');

local settings = T{ };
settings["party"] = T{ };
settings["party"]["font"] = T{ };
settings["target"] = T{ };
settings["target"]["font"] = T{ };
settings["party"]["font"]["font_height"] = 8;
settings["party"]["font"]["font_family"] = "Arial";
settings["party"]["font"]["bold"] = true;
settings["party"]["font"]["color"] = 4294967295;
settings["party"]["font"]["visible"] = true;
settings["party"]["font"]["right_justified"] = true;
settings["party"]["font"]["locked"] = true;
settings["party"]["font"]["italic"] = true;
settings["target"]["font"]["font_height"] = 10;
settings["target"]["font"]["font_family"] = "Arial";
settings["target"]["font"]["bold"] = true;
settings["target"]["font"]["color"] = 4294967295;
settings["target"]["font"]["visible"] = true;
settings["target"]["font"]["right_justified"] = true;
settings["target"]["font"]["locked"] = true;
settings["target"]["font"]["italic"] = true;

return settings;
