local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.VehicleProtection
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

local function getVehiclesInArea(coords, radius)
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

local function isVehicleValid(vehicle)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    local owner = NetworkGetEntityOwner(vehicle)
    local scriptName = GetEntityScript(vehicle)
    if Config.preventUnNetworkedEnity and (not netId or netId == 0) then
        return false, "Vehicle with Invalid net id"
    end
    if Config.preventInvalidOwner and (not owner or owner == -1) then
        return false, "Vehicle with Invalid Owner"
    end
    if Config.preventUnauthorizedResource.enable and Config.preventNilResource and scriptName == nil then
        return false, "Vehicle with an invalid resource (2)"
    end
    if Config.preventUnauthorizedResource.enable and not Config.preventUnauthorizedResource.resourceWhitelisted[scriptName] then
        return false, "Vehicle from non-whitelisted script: " .. tostring(scriptName) .. " (2)"
    end
    return true
end

local trackedVehicles = {}
local function check()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local nearbyVehicles = getVehiclesInArea(playerCoords, Config.maxVehicleCheckDistance)
    for i=1, #nearbyVehicles do
        local vehicle = nearbyVehicles[i]
        if not trackedVehicles[vehicle] then
            local isValid, reason = isVehicleValid(vehicle)

            if not isValid then
                DeleteEntity(vehicle)
                TriggerServerEvent("fg:addon:punish", reason)
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
    Citizen.SetTimeout(Config.checkInterval * 1000,check)
end
check()

if Config.preventSafeSpawn.enable then
    local function check_safespawn()
        local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                if DoesEntityExist(veh) and not NetworkGetEntityIsNetworked(veh) then
                    local pos = GetEntityCoords(ped)
                    local inWhitelistZone = false
                    for i=1, #Config.whitelistedCoords do
                        local zone = Config.whitelistedCoords[i]
                        if #(pos-zone.coords) <= zone.radius then
                            inWhitelistZone = true
                            break
                        end
                    end
                    Debug('[AntiSafeSpawn] inWhitelistZone',inWhitelistZone)
                    if not inWhitelistZone then
                        DeleteEntity(veh)
                    end
                end
            end
        Citizen.SetTimeout(10000,check_safespawn)
    end
    check_safespawn()
end
