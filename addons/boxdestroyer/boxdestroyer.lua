--[[
Copyright (c) 2014, Seth VanHeulen
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:
1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
3. Neither the name of the copyright holder nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]

-- addon information
addon.name = 'boxdestroyer'
addon.version = '1.0.0'
addon.command = 'boxdestroyer'
addon.author = 'Zechs6437 (Maarek@Fenrir) (original by Seth VanHeulen (Acacia@Odin))'
addon.desc = 'Automatically destroys Sturdy Pyxis.'

-- modules
require('common')
local chat = require('chat')

-- Track last processed entity to avoid duplicates
local lastProcessedEntity = nil

-- Register d3d_present event to check for nearby Sturdy Pyxis
ashita.events.register('d3d_present', 'present_cb', function()
    local entityMgr = AshitaCore:GetMemoryManager():GetEntity()
    if not entityMgr then return end

    -- Get the entity map size
    local entityCount = entityMgr:GetEntityMapSize()
    
    -- Search through all entities to find nearby Sturdy Pyxis
    for i = 0, entityCount - 1 do
        local entName = entityMgr:GetName(i)
        if entName == 'Sturdy Pyxis' and i ~= lastProcessedEntity then
            -- Get the entity for proper distance calculation
            local target = GetEntity(i)
            if target then
                local distance = math.sqrt(target.Distance)
                if distance and distance <= 6 then  -- Check if within 6 yalms
                    -- Set target using target manager
                    local targetMgr = AshitaCore:GetMemoryManager():GetTarget()
                    if targetMgr then
                        targetMgr:SetTarget(i)
                        -- Use Forbidden Key on the target
                        AshitaCore:GetChatManager():QueueCommand('/item "Forbidden Key" <t>', 1)
                        lastProcessedEntity = i
                    end
                end
            end
        end
    end
end)

-- Register load event
ashita.events.register('load', 'load_cb', function()
    print(chat.header(addon.name):append(chat.message('Loaded successfully.')))
end)

-- Register unload event
ashita.events.register('unload', 'unload_cb', function()
    print(chat.header(addon.name):append(chat.message('Unloaded successfully.')))
end)