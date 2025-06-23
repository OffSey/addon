local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.AntiSpawnVehicle
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

function FgGetVehiclesInArea(coords, radius)
    local vehicles = {}
    local handle, vehicle = FindFirstVehicle()
    local success

    repeat
        if DoesEntityExist(vehicle) then
            local vehicleCoords = GetEntityCoords(vehicle)
            if #(coords - vehicleCoords) <= radius then
                vehicles[#vehicles + 1] = vehicle
            end
        end
        success, vehicle = FindNextVehicle(handle)
    until not success

    EndFindVehicle(handle)
    return vehicles
end

function FgIsVehicleValid(vehicle)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    if Config.DetectNetId and (not netId or netId == 0) then
        return false, "Invalid netId"
    end


    local owner = NetworkGetEntityOwner(vehicle)
    if Config.DetectOwner then
        if not owner or owner == -1 then return false, "Invalid Owner" end
    end

    local scriptName = GetEntityScript(vehicle)
    
    if Config.DetectResource and scriptName == nil then
        return false, "Unknown script (nil) detected on the vehicle"
    end
    
    if Config.DetectResource and not Config.ResourceWhitelisted[scriptName] then
        return false, "Script not whitelisted: " .. scriptName
    end

    return true
end

Citizen.CreateThread(function()
    local trackedVehicles = {}

    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local nearbyVehicles = FgGetVehiclesInArea(playerCoords, Config.MaxVehicleCheckDistance)

        for _, vehicle in ipairs(nearbyVehicles) do
            if not trackedVehicles[vehicle] then
                local isValid, reason = FgIsVehicleValid(vehicle)

                if not isValid then
                    TriggerServerEvent("fg:addon:playerDroped", reason)
                    DeleteEntity(vehicle)
                else
                    trackedVehicles[vehicle] = true
                end
            end
        end

        for vehicle in pairs(trackedVehicles) do
            if not DoesEntityExist(vehicle) then
                trackedVehicles[vehicle] = nil
            end
        end

        Citizen.Wait(Config.CheckInterval * 1000)
    end
end)

RegisterNetEvent("fg:addon:checkVehicle", function(netId)
    local entity = NetworkGetEntityFromNetworkId(netId)
    local retries = 0

    while not DoesEntityExist(entity) and retries < Config.MaxRetries do
        Citizen.Wait(500)
        entity = NetworkGetEntityFromNetworkId(netId)
        retries = retries + 1
    end

    if DoesEntityExist(entity) then
        local scriptName = GetEntityScript(entity)

        -- if scriptName == nil then
        --     DeleteEntity(entity)
        --     if Config.Ban or Config.Kick then
        --         TriggerServerEvent("fg:addon:playerDroped", "Vehicle spawned with no script source.")
        --     end
        --     return
        -- end

        if not Config.ResourceWhitelisted[scriptName] then
            if Config.Ban or Config.Kick then
                TriggerServerEvent("fg:addon:playerDroped", "Vehicle spawned on a No-Whitelisted resource: " .. scriptName)
            end
            DeleteEntity(entity)
        end
    end
end)
