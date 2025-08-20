local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.AntiSpawnVehicle
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

AddEventHandler('entityCreated', function(entity)
    if not DoesEntityExist(entity) then return end

    local model = GetEntityModel(entity)
    local entityType = GetEntityType(entity)
    local populationType = GetEntityPopulationType(entity)
    if entityType ~= 2 then return end
    if not Config.detectNPC then
        if populationType == 5 then return end
    end
    local owner = NetworkGetEntityOwner(entity)
    local netId = NetworkGetNetworkIdFromEntity(entity)
    if Config.preventUnnetworkedEnity then
        if not netId or netId == 0 then
            DeleteEntity(entity)
            Debug(owner, "Spawned Unnetworked Entity")
            return
        end
    end
    if Config.preventLaunchPlayer then
        local modelsToDelete = {
            [-1809822327] = true,
            [-1177863319] = true,
            [1728666326] = true,
        }
        
        if modelsToDelete[model] then
            DeleteEntity(entity)
            Debug(owner, "Tried to launch a player")
            TriggerEvent('fg:addon:dropMe','Tried to launch a player')
            return
        end
    end
    TriggerClientEvent("fg:addon:checkVehicle", owner, netId)
end)

RegisterNetEvent("fg:addon:dropMe", function(reason)
    if Config.ban then
        BanPlayer(source, reason, Config.recordPlayer)
    elseif Config.kick then
        DropPlayer(source, '[FIVEGUARD.NET] You have been kicked')
    end
end)
