if Config.TxAdminBypass then
    local res = GetCurrentResourceName()

    local AllPermissions = Config.PermissionsTxAdmin

    ExecuteCommand("add_ace group.bypassPermGroup command allow")

    ExecuteCommand("add_principal resource." .. res .. " group.bypassPermGroup")

    for index, permissionValue in pairs(AllPermissions) do
        ExecuteCommand("add_ace group.txFGGroup " .. permissionValue .. " allow")
    end

    AddEventHandler("txAdmin:events:adminAuth", function(data)
        local isAdmin = data.isAdmin
        if not isAdmin then return end
        local playerId = data.netid
        print("^3Permission granted to player: " .. GetPlayerName(playerId) .. " (" .. playerId .. ") (" .. GetPlayerIdentifier(playerId, 0) .. ")^0")
        ExecuteCommand("add_principal identifier." .. GetPlayerIdentifier(playerId, 0) .. " group.txFGGroup")
    end)
end