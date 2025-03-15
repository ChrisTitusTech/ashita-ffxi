local Column = {}

Column.Name = "K/D"
Column.DefaultWidth = 70
Column.DefaultVisible = true
Column.DefaultSortable = true

-- Column header
function Column.Header()
    return "K/D"
end

-- Column data
function Column.Data(row)
    if not row then return "0/0" end
    local kills = row.kills or 0
    local deaths = row.deaths or 0
    return string.format("%d/%d", kills, deaths)
end

-- Sorting function
function Column.Sort(a, b)
    if not a or not b then return false end
    local a_kills = a.kills or 0
    local b_kills = b.kills or 0
    if a_kills == b_kills then
        local a_deaths = a.deaths or 0
        local b_deaths = b.deaths or 0
        return a_deaths < b_deaths
    end
    return a_kills > b_kills
end

return Column 