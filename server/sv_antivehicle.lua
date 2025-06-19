local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.AntiSpawnVehicle
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

AddEventHandler('entityCreated', function(entity)
    if not DoesEntityExist(entity) then return end

    local entityType = GetEntityType(entity)
    local populationType = GetEntityPopulationType(entity)
    if entityType ~= 2 then return end
    if not Config.DetectNPC then
        if populationType == 5 then return end
    end
    local owner = NetworkGetEntityOwner(entity)
    local netId = NetworkGetNetworkIdFromEntity(entity)

    if Config.DetectNetId then
        if not netId or netId == 0 then
            DeleteEntity(entity)
            _security.BanPlayer(owner, "Spawn Vehicle without netid valid")
            return
        end
    end
    TriggerClientEvent("fg:addon:checkVehicle", owner, netId)
end)

RegisterNetEvent("fg:addon:playerDroped", function(reason)
    local source = source
    if Config.Ban then
        exports[Fiveguard]:fg_BanPlayer(source, reason, true)
    elseif Config.Kick then
        DropPlayer(source, '[Fiveguard] '..reason)
    end
end)
