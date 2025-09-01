local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.VehicleProtection
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

AddEventHandler('entityCreated', function(entity)
    if not DoesEntityExist(entity) then return end
    if GetEntityType(entity) ~= 2 then return end
    local model = GetEntityModel(entity)
    local populationType = GetEntityPopulationType(entity)
    local firstOwner = NetworkGetFirstEntityOwner(entity)
    local owner = NetworkGetEntityOwner(entity)
    local netId = NetworkGetNetworkIdFromEntity(entity)
    local scriptName = GetEntityScript(entity)
    local attached = GetEntityAttachedTo(entity)

    if not Config.detectNPC and populationType == 5 then
        return
    end
    if Config.cleanNotOwnedVehicles then
        if not firstOwner or firstOwner == -1 then
            Debug(("Vehicle without owner deleted (entity: %s)"):format(entity))
            DeleteEntity(entity)
            return
        end
    end
    if Config.preventAttachVehicles then
        if attached ~= 0 and IsPedAPlayer(attached) then
            PunishPlayer(firstOwner,Config.ban, 'Tried to attach a vehicle to a player', "image")
            DeleteEntity(entity)
            return
        end
    end
    if Config.preventUnNetworkedEnity then
        if not netId or netId == 0 then
            Debug(owner, "Spawned Unnetworked Entity")
            DeleteEntity(entity)
            return
        end
    end
    if Config.preventLaunchPlayer then
        local modelsToDelete = {
            [-1809822327] = true, -- Cargoplane
            [-1177863319] = true, -- Tug
            [1728666326] = true,  -- Large vehicle exploit
        }
        if modelsToDelete[model] then
            PunishPlayer(owner, true, "Tried to launch a player with "..tostring(model),"image")
            DeleteEntity(entity)
            return
        end
    end
    if Config.preventNilResources and scriptName == nil then
        PunishPlayer(owner, true, "Spawned vehicle with an invalid resource (1)",false)
        DeleteEntity(entity)
        return
    end
    if Config.preventUnauthorizedResource.enable and scriptName and not Config.preventUnauthorizedResource.resourceWhitelisted[scriptName] then
        PunishPlayer(owner, true, "Spawned vehicle from non-whitelisted script: " .. tostring(scriptName) .. " (1)","image")
        DeleteEntity(entity)
        return
    end
end)

RegisterNetEvent("fg:addon:punish", function(reason)
    Debug(GetInvokingResource())
    PunishPlayer(source, Config.ban, reason, Config.banMedia)
end)
