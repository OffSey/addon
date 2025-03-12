local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AcePermissions
while not Fiveguard do Wait(0) end
while not PermsReady do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

for group, groupConfig in pairs(Config.groups) do
    for i = 1 , #groupConfig do
        if IsPrincipalAceAllowed(('fg.%s'):format(group),groupConfig[i]) then
            Error(('[ACE Permission] Ignored permission %s for group %s because is already registered'):format(groupConfig[i],group))
        else
            ExecuteCommand(("add_ace fg.%s %s allow"):format(group, groupConfig[i]))
        end
    end
end

AddEventHandler('playerJoining', function(source, oldSrc)
    Debug('[playerJoining]', source, oldSrc)
    for group,_ in pairs(Config.groups) do
        if IsPlayerAceAllowed(source, group) then
            SetPermission(source, group, true)
            break
        end
    end
end)

RegisterNetEvent('fg:addon:playerSpawned', function()
    Debug('[fg:addon:playerSpawned]', source)
    for group, _ in pairs(Config.groups) do
        if IsPlayerAceAllowed(source, group) then
            SetPermission(source, group, true)
            break
        end
    end
end)

AddEventHandler('playerDropped', function()
    Debug('[playerDropped]', source)
    for group,_ in pairs(Config.groups) do
        if IsPlayerAceAllowed(source, group) then
            SetPermission(source, group, false)
            break
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if CurrentResourceName ~= res then return end
    for group, groupConfig in pairs(Config.groups) do
        for i = 1 , #groupConfig do
            ExecuteCommand(("remove_ace fg.%s %s allow"):format(group, groupConfig[i]))
        end
    end
end)
