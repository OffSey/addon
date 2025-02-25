if Config.UseAcePermissions then
    AddEventHandler('esx:playerLoaded', function(source, xPlayer)
        local source = source
        local GroupFiveguard = xPlayer.getGroup()
        TriggerEvent('offsey:customperm', source, GroupFiveguard)
    end)

    ExecuteCommand("add_ace group.bypassPermGroup command allow")
    ExecuteCommand("add_principal resource." .. GetCurrentResourceName() .. " group.bypassPermGroup")

    local permissionsGroups = Config.PermissionsCustom

    for groupName, permissionsObject in pairs(permissionsGroups) do
        for _, permissionValue in ipairs(permissionsObject) do
            ExecuteCommand("add_ace group." .. groupName .. "_FgGroup " .. permissionValue .. " allow")
        end
    end

    AddEventHandler("offsey:customperm", function(playerId, group)
        local identifier = GetPlayerIdentifier(playerId, 0)
        if identifier then
            if group == Config.UserGroup then
                print("[^2AntiCheat^7] The player "..GetPlayerName(playerId).." its connected on group: "..group.." (USER)")
            else
            ExecuteCommand("add_principal identifier." .. identifier .. " group." .. group .. "_FgGroup")
            print(("[^2AntiCheat^7] Permission granted to player: %s Group: %s_FgGroup"):format(GetPlayerName(playerId), group))
            end
        else
            print(("[^2AntiCheat^7]-[^3WARNING^7] Error for find identifier player: %s"):format(GetPlayerName(playerId)))
        end
    end)
end