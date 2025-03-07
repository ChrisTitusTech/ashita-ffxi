--[[
Copyright 2023 Thorny

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

local d3d = require('d3d8');
local ffi = require('ffi');
local default_settings = {
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

local function CreateRectData(settings)
    local data = ffi.new('GdiRectData_t');
    data.Width = settings.width;
    data.Height = settings.height;
    data.Diameter = settings.corner_rounding;
    data.OutlineColor = settings.outline_color;
    data.OutlineWidth = settings.outline_width;
    data.FillColor = settings.fill_color;
    data.GradientStyle = settings.gradient_style;
    data.GradientColor = settings.gradient_color;
    return data;
end

local object = {};

function object:get_texture()
    if (self.is_dirty == true) then
        self.is_dirty = false;
        self.texture = nil;
        self.rect = nil;
        local tx = self.renderer.CreateRectTexture(self.interface, CreateRectData(self.settings));
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
    return o;
end

local vec_position = ffi.new('D3DXVECTOR2', { 0, 0, });
local vec_scale = ffi.new('D3DXVECTOR2', { 1.0, 1.0, });
local d3dwhite = d3d.D3DCOLOR_ARGB(255, 255, 255, 255);
function object:render(sprite)
    if (self.settings.visible ~= true) then
        return;
    end
    local texture, rect = self:get_texture();
    if (texture ~= nil) then
        vec_position.x = self.settings.position_x;
        vec_position.y = self.settings.position_y;
        sprite:Draw(texture, rect, vec_scale, nil, 0.0, vec_position, d3dwhite);
    end
end


function object:set_width(width)
    if (width ~= self.settings.width) then
        self.is_dirty = true;
    end

    self.settings.width = width;
end

function object:set_height(height)
    if (height ~= self.settings.height) then
        self.is_dirty = true;
    end

    self.settings.height = height;
end

function object:set_corner_rounding(rounding)
    if (rounding ~= self.settings.corner_rounding) then
        self.is_dirty = true;
    end

    self.settings.corner_rounding = rounding;
end

function object:set_fill_color(color)
    if (color ~= self.settings.fill_color) then
        self.is_dirty = true;
    end

    self.settings.fill_color = color;
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

function object:set_visible(visible)
    self.settings.visible = visible;
end

function object:set_z_order(z_order)
    if (type(z_order) == 'number') and (z_order ~= self.settings.z_order) then
        self.settings.z_order = z_order;
        self.sort();
    end
end

return object;