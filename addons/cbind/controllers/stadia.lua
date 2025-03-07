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
    Dpad = {
        Blocking = false,
        State = 'Idle',
    },
};

local function HandleStick(stickName, horizontal, vertical)
    local stick = state[stickName];
    if (horizontal == nil) or (math.abs(horizontal) < 42) then
        horizontal = 0;
    end
    if (vertical == nil) or (math.abs(vertical) < 42) then
        vertical = 0;
    end
    stick.Horizontal = horizontal;
    stick.Vertical = vertical;

    local currentState = 'Idle';
    if (vertical ~= 0) then
        currentState = (vertical < 0) and 'Up' or 'Down';
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
        end
        if HandleBinding(stickName .. '_' .. currentState, true) then
            stick.Blocking = true;
        end
    end

    stick.State = currentState;
    return stick.Blocking;
end

local dpadLookup = {
    [-1] = 'Idle',
    [0] = 'Up',
    [4500] = 'UpRight',
    [9000] = 'Right',
    [13500] = 'DownRight',
    [18000] = 'Down',
    [22500] = 'DownLeft',
    [27000] = 'Left',
    [31500] = 'UpLeft',
};

local function HandleDPad(buttonState)
    local currentState = dpadLookup[buttonState] or 'Idle';
    local pad = state.Dpad;

    if (currentState == 'Idle') then
        if (pad.State ~= 'Idle') then
            HandleBinding('Dpad_' .. pad.State, false);
            local block = pad.Blocking;
            pad.Blocking = false;
            pad.State = currentState;
            return block;
        end
    elseif (currentState ~= pad.State) then
        if (pad.State ~= 'Idle') then
            HandleBinding('Dpad_' .. pad.State, false);
            pad.Blocking = false;
        end
        if HandleBinding('Dpad_' .. currentState, true) then
            pad.Blocking = true;
        end
    end

    pad.State = currentState;
    return pad.Blocking;
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

local handlers = {
    --Horizontal L-Stick Movement
    [0] = function(e)
        if HandleStick('LStick', e.state, state.LStick.Vertical) then
            e.blocked = true;
        end
    end,

    --Vertical L-Stick Movement
    [4] = function(e)
        if HandleStick('LStick', state.LStick.Horizontal, e.state) then
            e.blocked = true;
        end
    end,
    
    --Horizontal R-Stick Movement
    [8] = function(e)
        if HandleStick('RStick', e.state, state.RStick.Vertical) then
            e.blocked = true;
        end
    end,

    --Vertical R-Stick Movement
    [20] = function(e)
        if HandleStick('RStick', state.RStick.Horizontal, e.state) then
            e.blocked = true;
        end
    end,
    
    [32] = function(e)
        if HandleDPad(e.state) then
            e.blocked = true;
        end
    end,

    [48] = function(e)
        if HandleButton('A', e.state == 128) then
            e.blocked = true;
        end
    end,

    [49] = function(e)
        if HandleButton('B', e.state == 128) then
            e.blocked = true;
        end
    end,

    [50] = function(e)
        if HandleButton('X', e.state == 128) then
            e.blocked = true;
        end
    end,

    [51] = function(e)
        if HandleButton('Y', e.state == 128) then
            e.blocked = true;
        end
    end,

    [52] = function(e)
        if HandleButton('L1', e.state == 128) then
            e.blocked = true;
        end
    end,

    [53] = function(e)
        if HandleButton('R1', e.state == 128) then
            e.blocked = true;
        end
    end,

    [54] = function(e)
        if HandleButton('L3', e.state == 128) then
            e.blocked = true;
        end
    end,

    [55] = function(e)
        if HandleButton('R3', e.state == 128) then
            e.blocked = true;
        end
    end,

    [56] = function(e)
        if HandleButton('Options', e.state == 128) then
            e.blocked = true;
        end
    end,

    [57] = function(e)
        if HandleButton('Menu', e.state == 128) then
            e.blocked = true;
        end
    end,

    [58] = function(e)
        if HandleButton('Stadia', e.state == 128) then
            e.blocked = true;
        end
    end,

    [59] = function(e)
        if HandleButton('R2', e.state == 128) then
            e.blocked = true;
        end
    end,

    [60] = function(e)
        if HandleButton('L2', e.state == 128) then
            e.blocked = true;
        end
    end,

    [61] = function(e)
        if HandleButton('Assistant', e.state == 128) then
            e.blocked = true;
        end
    end,

    [62] = function(e)
        if HandleButton('Capture', e.state == 128) then
            e.blocked = true;
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
    'Dpad_UpRight',
    'Dpad_Right',
    'Dpad_DownRight',
    'Dpad_Down',
    'Dpad_DownLeft',
    'Dpad_Left',
    'Dpad_UpLeft',
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
    'Menu',
    'Options',
    'Assistant',
    'Capture',
    'Stadia',
};

controller.HandleDirectInput = function(self, e)
    local handler = handlers[e.button];
    if handler then
        handler(e);
    end
end

return controller;