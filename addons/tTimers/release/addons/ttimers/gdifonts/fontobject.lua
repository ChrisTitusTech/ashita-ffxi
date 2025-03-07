--[[
Copyright 2023 Thorny

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

local chat = require('chat');
local d3d = require('d3d8');
local ffi = require('ffi');

local default_font = 'Arial';
local default_settings = {
    bg_overlap = 2,
    box_height = 0,
    box_width = 0,
    font_alignment = 0,
    font_color = 0xFFFFFFFF,
    font_family = default_font,
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
};

local function CreateFontData(settings)
    local data = ffi.new('GdiFontData_t');
    data.BoxHeight = settings.box_height;
    data.BoxWidth = settings.box_width;
    data.FontHeight = settings.font_height;
    data.OutlineWidth = settings.outline_width;
    data.FontFlags = settings.font_flags;
    data.FontColor = settings.font_color;
    data.OutlineColor = settings.outline_color;
    data.GradientStyle = settings.gradient_style;
    data.GradientColor = settings.gradient_color;
    data.FontFamily = settings.font_family;
    data.FontText = settings.text;
    return data;
end

local function Error(text)
    local stripped = string.gsub(text, '$H', ''):gsub('$R', '');
    LogManager:Log(1, 'GdiFonts', stripped);
    local color = ('\30%c'):format(68);
    local highlighted = color .. string.gsub(text, '$H', '\30\01\30\02');
    highlighted = string.gsub(highlighted, '$R', '\30\01' .. color);
    print(chat.header('GdiFonts') .. highlighted .. '\30\01');
end


local checkedFonts = T{};
local function GetFontAvailable(renderer, fontName)
    local result = checkedFonts[fontName];
    if result ~= nil then
        return result;
    end
    result = renderer.GetFontAvailable(fontName);
    checkedFonts[fontName] = result;
    return result;
end

local notifiedFonts = {};
local function GetDefaultFont(renderer)
    if GetFontAvailable(renderer, default_font) then
        return default_font;
    elseif not notifiedFonts[default_font] then
        Error(string.format('The default font ($H%s$R) is not installed.  Failed to load a valid font.', default_font));
        notifiedFonts[default_font] = true;
    end
end
local function ValidateFont(renderer, font)
    if (GetFontAvailable(renderer, font) == false) then
        if not notifiedFonts[font] then
            Error(string.format('Could not load the font $H%s$R.', font));
            notifiedFonts[font] = true;
        end
        return GetDefaultFont(renderer);
    end
    return font;
end

local object = {};


function object:get_texture()
    if (self.is_dirty == true) then
        self.is_dirty = false;
        self.texture = nil;
        self.rect = nil;
        if (self.settings.text == '') then
            return;
        end
        local tx = self.renderer.CreateTexture(self.interface, CreateFontData(self.settings));
        if (tx.Texture == nil) or (tx.Width == 0) or (tx.Height == 0) then
            return;
        else
            self.texture = d3d.gc_safe_release(tx.Texture);
            self.rect = ffi.new('RECT', { 0, 0, tx.Width, tx.Height });
        end
    end

    return self.texture, self.rect;
end

function object:new(args, settings)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.args = args;
    o.is_dirty = true;
    o.interface = args.Interface;
    o.renderer = args.Renderer;
    o.sort = args.Sort;
    o.settings = {};
    for key,value in pairs(default_settings) do
        if (type(settings) == 'table') and (settings[key] ~= nil) then
            o.settings[key] = settings[key];
        else
            o.settings[key] = value;
        end
    end
    if (type(settings) == 'table') and (type(settings.background) == 'table') then
        o.bg_obj = o.args.Rect:new(args, settings.background);
    end
    o.settings.font_family = ValidateFont(o.renderer, o.settings.font_family);
    return o;
end

local vec_position = ffi.new('D3DXVECTOR2', { 0, 0, });
local vec_scale = ffi.new('D3DXVECTOR2', { 1.0, 1.0, });
function object:render(sprite)
    if (self.settings.visible ~= true) or (self.settings.opacity == 0) then
        return;
    end

    local texture, rect = self:get_texture();
    if (texture ~= nil) then
        if (self.settings.font_alignment == 1) then
            vec_position.x = self.settings.position_x - (rect.right / 2);
        elseif (self.settings.font_alignment == 2) then
            vec_position.x = self.settings.position_x - rect.right;
        else
            vec_position.x = self.settings.position_x;
        end
        vec_position.y = self.settings.position_y;

        if (self.bg_obj ~= nil) then
            local bgOverlap = self.settings.bg_overlap + self.bg_obj.settings.outline_width;
            self.bg_obj:set_width(rect.right + (2 * bgOverlap));
            self.bg_obj:set_height(rect.bottom + (2 * bgOverlap));
            self.bg_obj:set_position_x(vec_position.x - bgOverlap);
            self.bg_obj:set_position_y(vec_position.y - bgOverlap);
            self.bg_obj:render(sprite);
        end

        
        local render_color = d3d.D3DCOLOR_ARGB(math.ceil(255 * self.settings.opacity), 255, 255, 255);
        sprite:Draw(texture, rect, vec_scale, nil, 0.0, vec_position, render_color);
    end
end

function object:get_background()
    return self.bg_obj;
end

function object:set_background(settings)
    self.bg_obj = self.args.Rect:new(self.args, self.interface, settings);
end

function object:set_bg_overlap(overlap)
    self.settings.bg_overlap = overlap;
end
    
function object:set_box_height(height)
    if (self.settings.box_height ~= height) then
        self.is_dirty = true;
    end
    self.settings.box_height = height;
end
    
function object:set_box_width(width)
    if (self.settings.box_width ~= width) then
        self.is_dirty = true;
    end
    
    self.settings.box_width = width;
end

function object:set_font_alignment(alignment)
    self.settings.font_alignment = alignment;
end

function object:set_font_color(color)
    if (color ~= self.settings.font_color) then
        self.is_dirty = true;
    end

    self.settings.font_color = color;
end

function object:set_font_family(family)
    family = ValidateFont(self.renderer, family);
    if (family ~= self.settings.font_family) then
        self.is_dirty = true;
    end

    self.settings.font_family = family;
end

function object:set_font_flags(flags)
    if (flags ~= self.settings.font_flags) then
        self.is_dirty = true;
    end

    self.settings.font_flags = flags;
end

function object:set_font_height(height)
    if (height ~= self.settings.font_height) then
        self.is_dirty = true;
    end

    self.settings.font_height = height;
end

function object:set_gradient_color(color)
    if (color ~= self.settings.gradient_color) then
        self.is_dirty = true;
    end

    self.settings.gradient_color = color;
end

function object:set_gradient_style(style)
    if (style ~= self.settings.gradient_style) then
        self.is_dirty = true;
    end

    self.settings.gradient_style = style;
end

function object:set_opacity(opacity)
    self.settings.opacity = math.max(0, math.min(1, opacity));
end

function object:set_outline_color(color)
    if (color ~= self.settings.outline_color) then
        self.is_dirty = true;
    end

    self.settings.outline_color = color;
end

function object:set_outline_width(width)
    if (width ~= self.settings.outline_width) then
        self.is_dirty = true;
    end

    self.settings.outline_width = width;
end

function object:set_position_x(x)
    self.settings.position_x = x;
end

function object:set_position_y(y)
    self.settings.position_y = y;
end

function object:set_text(text)
    if (text ~= self.settings.text) then
        self.is_dirty = true;
    end

    self.settings.text = text;
end

function object:set_visible(visible)
    self.settings.visible = visible;
end

function object:set_z_order(z_order)
    if (type(z_order) == 'number') and (z_order ~= self.settings.z_order) then
        self.settings.z_order = z_order;
        self.sort();
    end
end

function object:get_text_size()
    if self.is_dirty then
        self:get_texture();
    end
    if self.rect == nil then
        return 0, 0;
    end
    return (self.rect.right - self.rect.left), (self.rect.bottom - self.rect.top);
end

return object;