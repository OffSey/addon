local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.txAdminPermissions
while not Fiveguard do Wait(0) end
while not PermsReady do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if GetResourceState('monitor') ~= 'started' then return Error('[txAdmin Permission] You can not use this permission without txAdmin in your server!') end
if not Config?.enable then return end

for i = 1, #Config.fgPermissions do
    if IsPrincipalAceAllowed('fg.txadmin', Config.fgPermissions[i]) then
        Error(('[txAdmin Permissions] Ignored permission %s for group fg.txadmin because is already registered'):format(Config.fgPermissions[i]))
    else
        ExecuteCommand(("add_ace fg.txadmin %s allow"):format(Config.fgPermissions[i]))
    end
end

AddEventHandler("txAdmin:events:adminAuth", function(data)
    Debug('[txAdmin:events:adminAuth]', json.encode(data, {indent=true}))
    if not data then return end
    if data.netid >= 1 then
        SetPermission(data.netid, 'txadmin', data?.isAdmin)
    else
        Info('txAdmin sent a broadcast reauth')
        local targets = GetPlayers()
        for i = 1, #targets do
            SetPermission(targets[i], 'txadmin', data?.isAdmin)
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= CurrentResourceName then return end
    for i = 1, #Config.fgPermissions do
        ExecuteCommand(("remove_ace fg.txadmin %s allow"):format(Config.fgPermissions[i]))
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= 'monitor' then return end
    for i = 1, #Config.fgPermissions do
        ExecuteCommand(("remove_ace fg.txadmin %s allow"):format(Config.fgPermissions[i]))
    end
end)
