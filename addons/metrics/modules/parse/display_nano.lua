Parse.Nano = T{}

Parse.Nano.Table_Flags = bit.bor(ImGuiTableFlags_Borders)

------------------------------------------------------------------------------------------------------
-- Loads shows just the Team tab with just the player.
------------------------------------------------------------------------------------------------------
Parse.Nano.Populate = function()
    local flags = Column.Flags.None
    local player = Ashita.Mob.Get_Mob_By_Target(Ashita.Enum.Targets.ME)
    if not player then return nil end
    local player_name = player.name

    local columns = 1
    if Metrics.Parse.DPS then columns = columns + 1 end
    if Metrics.Parse.Running_Acc then columns = columns + 1 end

    if UI.BeginTable("Team Nano", columns, Parse.Nano.Table_Flags) then
        UI.TableSetupColumn("Total", flags)
        if Metrics.Parse.DPS then         UI.TableSetupColumn(DB.DPS.Column_Header(), flags) end
        if Metrics.Parse.Running_Acc then UI.TableSetupColumn("%A-" .. Metrics.Model.Running_Accuracy_Limit, flags) end
        UI.TableHeadersRow()

        UI.TableNextRow()
        UI.TableNextColumn() Column.Damage.Total(player_name, false, true)
        if Metrics.Parse.DPS then UI.TableNextColumn() Column.Damage.DPS(player_name, true) end
        if Metrics.Parse.Running_Acc then UI.TableNextColumn() Column.Acc.Running(player_name, true) end

        UI.EndTable()
    end
end

------------------------------------------------------------------------------------------------------
-- Returns whether nano mode is enabled.
------------------------------------------------------------------------------------------------------
Parse.Nano.Is_Enabled = function()
    return Metrics.Parse.Display_Mode == Parse.Enum.Display_Mode.NANO
end

------------------------------------------------------------------------------------------------------
-- Toggles nano mode.
------------------------------------------------------------------------------------------------------
Parse.Nano.Toggle = function()
    Metrics.Parse.Display_Mode = Parse.Enum.Display_Mode.NANO
end