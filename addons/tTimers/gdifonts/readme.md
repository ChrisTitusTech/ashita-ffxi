# GdiFonts
GdiFonts is a library you can use to display high quality fonts in your Ashita4 addons.  It is optimized
in a way that fonts will have minimal cost to display except when changing, but please note that Gdiplus is
not hardware accelerated and it will still not be as performant as ashita font objects for rapidly updating text.
If you have text that will be changing every frame, consider limiting number of objects and profiling performance.
The compiled dll included in this library is open source and can be located at:<br>
https://github.com/ThornyFFXI/gdifonttexture
<br><br>

## Initializing the library
Create a folder named 'gdifonts' in your addon.  Copy the files from this repo into that folder.  Include the library
with:
```
local gdi = require('gdifonts.include');
```
Note that you may use any variable name or dependency directory you want, as long as all files remain in the same directory.
You must also add this call to unload to ensure proper cleanup:
```
gdi:destroy_interface();
```
<br><br>

## Creating a managed font object
GdiFonts creates class objects to manage each font.  Each object must be populated with a settings table.  Any value omitted from the table will use these defaults.  The background table can be omitted entirely, but if it is provided then members should be in the layout of 'Rectangle/Background Objects'.  When created as part of a font object, backgrounds will be automatically sized and positioned correctly.
```
local fontSettings = {    
    bg_overlap = 2,
    box_height = 0,
    box_width = 0,
    font_alignment = 0,
    font_color = 0xFFFFFFFF,
    font_family = 'Arial',
    font_flags = 0,
    font_height = 18,
    gradient_color = 0x00000000,
    gradient_style = 0,
    opacity = 1,
    outline_color = 0xFF000000,
    outline_width = 2,
    position_x = 0,
    position_y = 0,
    text = '',
    visible = true,
    z_order = 0,
    background = { visible = false }
};
```
Once you've created the settings table, you can create a managed font object with this call:
```
local myFontObject = gdi:create_object(fontSettings, false);
```
To remove the object from management, use this call:
```
gdi:destroy_object(myFontObject);
```
You do not need to destroy objects unless they are managed, once no remaining references remain the garbage collector will clear up resources.<br><br>


## Modifying a font object
To update the object's text or parameters, you can use any of these calls, which set the same values in defaults:
```
myFontObject:get_background(); --Returns a rectangle object that will always be drawn immediately prior to the font object if visible.
myFontObject:set_background(settings); --Sets the background using a table of the same format used in creating a rectangle.
myFontObject:set_bg_overlap(overlap); --Sets how many pixels the background should overlap the font.
myFontObject:set_box_height(height); --Sets maximum height of font.  Accepts a number, 0 will be treated as no maximum.
myFontObject:set_box_width(width); --Sets maximum width of displayed font.  Accepts a number, 0 will be treated as no maximum.
myFontObject:set_font_alignment(alignment);  --Sets font alignment.  Accepts gdi.Aligment.Left, gdi.Alignment.Center, or gdi.Alignment.Right.
myFontObject:set_font_color(color);  --Sets font color.  Accepts a 32 bit ARGB value.
myFontObject:set_font_family(family); --Sets font family.  Accepts a string.
myFontObject:set_font_flags(flags); --Sets font flags.  Accepts gdi.FontFlags.None, gdi.FontFlags.Bold, gdi.FontFlags.Italic, gdi.FontFlags.Underline, gdi.FontFlags.Strikeout, or a combination using bitwise or.
myFontObject:set_font_height(height); --Sets font height.  Accepts a number.
myFontObject:set_gradient_color(color); --Sets a color for the font gradient to blend into.  Accepts a 32 bit ARGB value.
myFontObject:set_gradient_style(style); --Sets a gradient style.  Styles are located in gdi.Gradient table.
myFontObject:set_opacity(opacity);  --Sets the overall opacity in the range of 0-1. If you need to simply fade in/out text, this is much better than setting font_color as it avoids texture re-creation.
myFontObject:set_outline_color(color); --Sets a color for the font outline.  Accepts a 32 bit ARGB value.
myFontObject:set_outline_width(width); --Sets width of outline.  Accepts a number, use 0 to disable outlines.
myFontObject:set_position_x(position); --Relocates the object.  Accepts a number.
myFontObject:set_position_y(position); --Relocates the object.  Accepts a number.
myFontObject:set_text(text); --Updates font object text.  Accepts a string.
myFontObject:set_visible(visible);  --Determines if render calls will draw the object.  Accepts a boolean.
myFontObject:set_z_order(order);  --Sets Z order.  Only applies to managed objects.  Accepts a number.
```

## Rectangle Objects
Gdifonts can create rectangles or rounded rectangles to serve as backgrounds.  This is **not** efficient rendering, and should not be used as a primary graphics source.  Each object must be populated with a settings table.  Any value omitted from the table will use these defaults.
```
local rectSettings = {
    width = 40,
    height = 150,
    corner_rounding = 0,
    outline_color = 0xFF000000,
    outline_width = 0,
    fill_color = 0x80000000,
    gradient_style = 0,
    gradient_color = 0x00000000,
    
    position_x = 0,
    position_y = 0,
    visible = true,
    z_order = 0,
};
```
Once you've created the settings table, you can create a managed rectangle object with this call:
```
local myRectObject = gdi:create_rect(rectSettings, false);
```
To remove the object from management, use this call:
```
gdi:destroy_object(myRectObject);
```
You do not need to destroy objects unless they are managed, once no remaining references remain the garbage collector will clear up resources.

## Modifying a rectangle object
To update the object's text or parameters, you can use any of these calls, which set the same values as in defaults:
```
myRectObject:set_width(width); --Changes width of object.  Accepts a number.
myRectObject:set_height(height); --Changes height of object. Accepts a number.
myRectObject:set_corner_rounding(rounding); --Changes corner rounding. Accepts a number.
myRectObject:set_outline_color(color); --Changes outline color. Accepts a 32 bit ARGB valrue.
myRectObject:set_outline_width(width); --Sets width of outline(0 to disable). Accepts a number.
myRectObject:set_fill_color(color); --Sets fill color for the rectangle. Accepts a 32 bit ARGB value.
myRectObject:set_gradient_color(color); --Sets a color for the fill gradient to blend into.  Accepts a 32 bit ARGB value.
myRectObject:set_gradient_style(style); --Sets a gradient style.  Styles are located in gdi.Gradient table.
myRectObject:set_position_x(position); --Relocates the object.  Accepts a number.
myRectObject:set_position_y(position); --Relocates the object.  Accepts a number.
myRectObject:set_visible(visible); --Determines if render calls will draw the object.  Accepts a boolean.
myRectObject:set_z_order(order); --Sets Z order.  Only applies to managed objects.  Accepts a number.
```


## Altering render time
By default, objects are created as managed.  This means GdiFonts will track and render them, and all you need to do is change the parameters.
If you need to render at a specific time, you can use this function to toggle automatic rendering of managed objects:
```
gdi:set_auto_render(enabled);
```
When auto render is disabled, you must call:
```
gdi:render();
```
during every frame you want your managed objects to appear, at the time you want them to be drawn.<br><br>

## Unmanaged Objects
If you need further control than that, you can still use this library to create unmanaged objects by specifying true for the second parameter of
create_object or create_rect as so:
```
local myFontObject = gdi:create_object(default_settings, true);
```
This will make you fully responsible for the object.  Objects do not memory leak, once they go out of scope entirely they will be cleaned up by garbage collector.  To render an unmanaged object, you can use this call:
```
fontObject:render(sprite);
```
which requires you pass in a sprite that has already begun rendering.  Alternatively, if you need higher control, you can call get_texture:
```
local texture, rect = fontObject:get_texture();
```
This will return nil if the object has no text, or cannot be rendered.  Otherwise, it will give you a texture and the rect within the texture where the font is located.  You can use these to draw via sprite as you see fit.  These functions are identical for both fontObjects and rectObjects.  Note that when calling render on a fontObject, the built in background will automatically be drawn, while calling get_texture will not draw it.

## Font Helper Function
This is a small extra, but it is tedious to do from lua, so I have included it here.  It may be moved elsewhere eventually.
If you need to check if a font is available on the system, you can use this call:
```
local font = 'Grammara';
local isAvailable = gdi:get_font_available(font);
```
It will return true or false, depending on if the system has the font.

## Saving output to disc
For creating static assets, you can use the following calls:
```
gdi:enable_texture_dump('C:/Ashita 4/temp/');
```
```
gdi:disable_texture_dump();
```
When enabled, every rendered font or rectangle object will be saved to the specified folder as a PNG file.  This will use a lot of resources and should never be used in production code.
If you want to capture the next auto-render frame, you can use this call to enable dumps for only a single render:
```
gdi:dump_frame('C:/Ashita 4/temp/);
```

## Using Japanese FFXI resources
Because FFXI resources are stored in Shift-JIS, they must be converted to render properly.  You can accomplish this using the included encoding lib.  Simply require the lib, and use the function ShiftJIS_To_UTF8 prior to rendering your text.
```
local encoding = require('gdifonts.encoding');
local sjResource = AshitaCore:GetResourceManager():GetString('zones.names', 60, 1);
local utf8Resource = encoding:ShiftJIS_To_UTF8(sjResource);
```

You can also convert back to shift-JIS if necessary.
```
local sjResourceAgain = encoding:UTF8_To_ShiftJIS(utf8Resource);
```

ShiftJIS_To_UTF8 and UTF8_To_ShiftJIS both take an optional second parameter `cache`, which if set to `true` will cache the converted string and skip conversion the next time the same input string is provided.
```
local utf8Resource = encoding:ShiftJIS_To_UTF8(sjResource, true);
```