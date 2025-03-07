--[[

MIT License

Copyright (c) 2024 ThornyFFXI

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]--

local state = {
    LStick = {
        Blocking = false,
        State = 'Idle',
        Horizontal = 0,
        Vertical = 0,
    },
    RStick = {
        Blocking = false,
        State = 'Idle',
        Horizontal = 0,
        Vertical = 0,
    },
};
local stickDeadZone = 10837;

local function HandleStick(stickName, horizontal, vertical)
    local stick = state[stickName];
    if (horizontal == nil) or (math.abs(horizontal) < stickDeadZone) then
        horizontal = 0;
    end
    if (vertical == nil) or (math.abs(vertical) < stickDeadZone) then
        vertical = 0;
    end
    stick.Horizontal = horizontal;
    stick.Vertical = vertical;

    local currentState = 'Idle';
    if (vertical ~= 0) then
        currentState = (vertical < 0) and 'Down' or 'Up';
        if (horizontal ~= 0) then
            currentState = currentState .. ((horizontal > 0) and 'Right' or 'Left');
        end
    elseif (horizontal ~= 0) then
        currentState = ((horizontal > 0) and 'Right' or 'Left');
    end

    if (currentState == 'Idle') then
        if (stick.State ~= 'Idle') then
            HandleBinding(stickName .. '_' .. stick.State, false);
            local block = stick.Blocking;
            stick.Blocking = false;
            stick.State = currentState;
            return block;
        end
    elseif (currentState ~= stick.State) then
        if (stick.State ~= 'Idle') then
            HandleBinding(stickName .. '_' .. stick.State, false);
            stick.Blocking = false;
        end
        if HandleBinding(stickName .. '_' .. currentState, true) then
            stick.Blocking = true;
        end
    end

    stick.State = currentState;
    return stick.Blocking;
end

local function HandleButton(buttonName, buttonState)
    local button = state[buttonName];
    if (button == nil) then
        button = { Blocking = false, State = false };
        state[buttonName] = button;
    end

    if (buttonState == false) then
        if (button.State ~= false) then
            HandleBinding(buttonName, false);
            local block = button.Blocking;
            button.Blocking = false;
            button.State = false;
            return block;
        end
    elseif (button.State == false) then
        if HandleBinding(buttonName, true) then
            button.Blocking = true;
        end
    end

    button.State = buttonState;
    return button.Blocking;
end

local offset = 32;
if (ashita.interface_version ~= nil) then
    offset = 16;
end
local handlers = {
    [0] = function(e)
        if HandleButton('Dpad_Up', e.state == 1) then
            e.blocked = true;
        end
    end,
    
    --Dpad Down
    [1] = function(e)
        if HandleButton('Dpad_Down', e.state == 1) then
            e.blocked = true;
        end
    end,
    
    --Dpad Left
    [2] = function(e)
        if HandleButton('Dpad_Left', e.state == 1) then
            e.blocked = true;
        end
    end,
    
    --Dpad Right
    [3] = function(e)
        if HandleButton('Dpad_Right', e.state == 1) then
            e.blocked = true;
        end
    end,
    
    --Menu
    [4] = function(e)
        if HandleButton('Menu', e.state == 1) then
            e.blocked = true;
        end
    end,
    
    --View
    [5] = function(e)
        if HandleButton('View', e.state == 1) then
            e.blocked = true;
        end
    end,
    
    --L3
    [6] = function(e)
        if HandleButton('L3', e.state == 1) then
            e.blocked = true;
        end
    end,
    
    --R3
    [7] = function(e)
        if HandleButton('R3', e.state == 1) then
            e.blocked = true;
        end
    end,
    
    --L1
    [8] = function(e)
        if HandleButton('L1', e.state == 1) then
            e.blocked = true;
        end
    end,
    
    --R1
    [9] = function(e)
        if HandleButton('R1', e.state == 1) then
            e.blocked = true;
        end
    end,
    
    --A
    [12] = function(e)
        if HandleButton('A', e.state == 1) then
            e.blocked = true;
        end
    end,
    
    --B
    [13] = function(e)
        if HandleButton('B', e.state == 1) then
            e.blocked = true;
        end
    end,
    
    --X
    [14] = function(e)
        if HandleButton('X', e.state == 1) then
            e.blocked = true;
        end
    end,
    
    --Y
    [15] = function(e)
        if HandleButton('Y', e.state == 1) then
            e.blocked = true;
        end
    end,

    --L2
    [offset] = function(e)
        if HandleButton('L2', e.state > 0) then
            e.blocked = true;
        end
    end,
    
    --R2
    [offset+1] = function(e)
        if HandleButton('R2', e.state > 0) then
            e.blocked = true;
        end
    end,

    --Horizontal L-Stick Movement
    [offset+2] = function(e)
        if HandleStick('LStick', e.state, state.LStick.Vertical) then
            e.state = 0;
        end
    end,
    
    --Vertical L-Stick Movement
    [offset+3] = function(e)
        if HandleStick('LStick', state.LStick.Horizontal, e.state) then
            e.state = 0;
        end
    end,

    --Horizontal R-Stick Movement
    [offset+4] = function(e)
        if HandleStick('RStick', e.state, state.RStick.Vertical) then
            e.state = 0;
        end
    end,
    
    --Vertical R-Stick Movement
    [offset+5] = function(e)
        if HandleStick('RStick', state.RStick.Horizontal, e.state) then
            e.state = 0;
        end
    end,
};

local controller = {};
controller.Buttons = {
    'A',
    'B',
    'X',
    'Y',
    'L1',
    'R1',
    'L2',
    'R2',
    'L3',
    'R3',
    'Dpad_Up',
    'Dpad_Right',
    'Dpad_Down',
    'Dpad_Left',
    'Menu',
    'View',
    'LStick_Up',
    'LStick_UpRight',
    'LStick_Right',
    'LStick_DownRight',
    'LStick_Down',
    'LStick_DownLeft',
    'LStick_Left',
    'LStick_UpLeft',
    'RStick_Up',
    'RStick_UpRight',
    'RStick_Right',
    'RStick_DownRight',
    'RStick_Down',
    'RStick_DownLeft',
    'RStick_Left',
    'RStick_UpLeft',
};

controller.HandleXInput = function(self, e)
    local handler = handlers[e.button];
    if handler then
        handler(e);
    end
end

return controller;