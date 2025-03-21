gcchecks {};

    gcmovement.Debug('Checking indexes:');
    -- Print available entity methods for debugging
    local player = AshitaCore:GetMemoryManager():GetEntity();
    gcmovement.Debug('Enttity Name: ' .. player:GetName(0));
    gcmovement.Debug('Entity Movement Speed: ' .. player:GetMovementSpeed(0));
    
    
    if player then
        gcmovement.Debug('Available methods:');
        for k, v in pairs(getmetatable(player).__index) do
            if type(v) == 'function' then
                gcmovement.Debug('- ' .. k);
            end
        end
    end


return gcchecks;