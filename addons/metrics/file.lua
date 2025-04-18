File = T{}

File.Addend_Path = "config\\Metrics"
File.Delimiter = ","
File.Pattern  = "([^" .. File.Delimiter .. "]+)"

-- ------------------------------------------------------------------------------------------------------
-- Write to file for the basic data.
-- ------------------------------------------------------------------------------------------------------
File.Save_Data = function()
    local path = File.Path()
    File.File_Exists(path)

    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    if not player then return nil end
    local filename = tostring(os.date("%m-%d-%Y %H-%M-%S Basic ", os.time()) .. " " .. tostring(player.name) .. ".csv")

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(path, filename), "w")
    if file ~= nil then
        -- Headers
        file:write(tostring("Actor") .. File.Delimiter .. tostring("Target") .. File.Delimiter .. tostring("Pet") .. File.Delimiter
                .. tostring("Trackable") .. File.Delimiter .. tostring("Metric") .. File.Delimiter .. tostring("Value") .. "\n")
        -- Player Data
        for index, trackable_data in pairs(DB.Parse) do
            for trackable, metric_data in pairs(trackable_data) do
                for metric, data in pairs(metric_data) do
                    if metric ~= DB.Enum.Values.CATALOG and data > 0 then
                        local player_target = index:gsub(":", File.Delimiter)
                        file:write(tostring(player_target) .. File.Delimiter .. File.Delimiter .. tostring(trackable) .. File.Delimiter
                                .. tostring(metric) .. File.Delimiter .. tostring(data) .. "\n")
                    end
                end
            end
        end
        -- Pet Data
        for index, pet_data in pairs(DB.Pet_Parse) do
            for pet_name, trackable_data in pairs(pet_data) do
                for trackable, metric_data in pairs(trackable_data) do
                    for metric, data in pairs(metric_data) do
                        if metric ~= DB.Enum.Values.CATALOG and data > 0 then
                            local player_target = index:gsub(":", File.Delimiter)
                            file:write(tostring(player_target) .. File.Delimiter .. tostring(pet_name) .. File.Delimiter
                                    .. tostring(trackable) .. File.Delimiter .. tostring(metric) .. File.Delimiter .. tostring(data) .. "\n")
                        end
                    end
                end
            end
        end
        file:close()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Write to file for cataloged data.
-- ------------------------------------------------------------------------------------------------------
File.Save_Catalog = function()
    local path = File.Path()
    File.File_Exists(path)

    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    if not player then return nil end
    local filename = tostring(os.date("%m-%d-%Y %H-%M-%S Catalog ", os.time()) .. tostring(player.name) .. ".csv")

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(path, filename), "w")
    if file ~= nil then
        -- Headers
        file:write(tostring("Actor") .. File.Delimiter .. tostring("Target") .. File.Delimiter .. tostring("Pet") .. File.Delimiter
                .. tostring("Trackable") .. File.Delimiter .. tostring("Action") .. File.Delimiter .. tostring("Metric") .. File.Delimiter
                .. tostring("Value") .. "\n")
        -- Player Data
        for index, trackable_data in pairs(DB.Parse) do
            for trackable, metric_data in pairs(trackable_data) do
                for catalog_metric, catalog_data in pairs(metric_data) do
                    if catalog_metric == DB.Enum.Values.CATALOG then
                        for action_name, action_data in pairs(catalog_data) do
                            for metric, data in pairs(action_data) do
                                if not metric or not data then
                                    Debug.Error.Add("File.Save_Catalog: Nil data: Metric: " .. tostring(metric) .. " Data: " .. tostring(data))
                                elseif data > 0 then
                                    if data == 100000 and metric == DB.Enum.Metric.MIN then data = 0 end
                                    local player_target = index:gsub(":", File.Delimiter)
                                    file:write(tostring(player_target) .. File.Delimiter .. File.Delimiter .. tostring(trackable) .. File.Delimiter
                                        .. tostring(action_name) .. File.Delimiter .. tostring(metric) .. File.Delimiter .. tostring(data) .. "\n")
                                end
                            end
                        end
                    end
                end
            end
        end
        -- Pet Data
        for index, pet_data in pairs(DB.Pet_Parse) do
            for pet_name, trackable_data in pairs(pet_data) do
                for trackable, metric_data in pairs(trackable_data) do
                    for catalog_metric, catalog_data in pairs(metric_data) do
                        if catalog_metric == DB.Enum.Values.CATALOG then
                            for action_name, action_data in pairs(catalog_data) do
                                for metric, data in pairs(action_data) do
                                    if not metric or not data then
                                        Debug.Error.Add("File.Save_Catalog: Nil data: Metric: " .. tostring(metric) .. " Data: " .. tostring(data))
                                    elseif data > 0 then
                                        if data == 100000 and metric == DB.Enum.Metric.MIN then data = 0 end
                                        local player_target = index:gsub(":", File.Delimiter)
                                        file:write(tostring(player_target) .. File.Delimiter .. tostring(pet_name) .. File.Delimiter
                                                .. tostring(trackable) .. File.Delimiter .. tostring(action_name) .. File.Delimiter
                                                .. tostring(metric) .. File.Delimiter .. tostring(data) .. "\n")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        file:close()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Write to file for the battle log data.
-- ------------------------------------------------------------------------------------------------------
File.Save_Battlelog = function()
    local path = File.Path()
    File.File_Exists(path)

    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    if not player then return nil end
    local filename = tostring(os.date("%m-%d-%Y %H-%M-%S Battle Log ", os.time()) .. tostring(player.name) .. ".csv")

    ---@diagnostic disable-next-line: undefined-field
    local file = io.open(('%s/%s'):fmt(path, filename), "w")
    if file ~= nil then
        file:write(tostring("Time") .. File.Delimiter .. tostring("Flag") .. File.Delimiter .. tostring("Player Name") .. File.Delimiter
                .. tostring("Pet Name") .. File.Delimiter.. tostring("Damage") .. File.Delimiter .. tostring("Action") .. File.Delimiter .. tostring("Note") .. "\n")
        for _, data in pairs(Blog.Log) do
            local time        = data.Time
            local flag        = data.Flag
            local player_name = data.Player
            local pet_name    = data.Pet
            local damage      = data.Damage
            local action      = data.Action
            local note        = data.Note
            if not time or not flag or  not player_name or not pet_name or not damage or not action or not note then
                Debug.Error.Add("File.Save_Battlelog: Nil data: Time " .. tostring(time) .. " Flag: " .. tostring(flag) " Player Name: " .. tostring(player_name)
                              .. " Pet Name: " .. tostring(pet_name) .. " Damage: " .. tostring(damage) .. " Action: " .. tostring(action) .. " Note: " .. tostring(note))
            else
                file:write(tostring(time.Value) .. File.Delimiter .. tostring(flag.Value) .. File.Delimiter .. tostring(player_name.Value) .. File.Delimiter
                        .. tostring(pet_name.Value) .. File.Delimiter .. tostring(damage.Value) .. File.Delimiter .. tostring(action.Value) .. File.Delimiter
                        .. tostring(note.Value) .. "\n")
            end
        end
        file:close()
    end
end

-- ------------------------------------------------------------------------------------------------------
-- Create the base file path.
-- ------------------------------------------------------------------------------------------------------
File.Path = function()
    local directory = tostring(AshitaCore:GetInstallPath()) .. File.Addend_Path
    ---@diagnostic disable-next-line: undefined-field
    return ('%s/'):fmt(directory)
end

-- ------------------------------------------------------------------------------------------------------
-- Check if the base directory exists. If it doesn't, create it.
-- ------------------------------------------------------------------------------------------------------
---@param path string
-- ------------------------------------------------------------------------------------------------------
File.File_Exists = function(path)
    if not ashita.fs.exists(path) then
        ashita.fs.create_dir(path)
    end
end