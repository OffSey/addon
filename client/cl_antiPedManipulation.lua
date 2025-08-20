local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.AntiPedManipulation
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

Citizen.CreateThread(function()
    while true do
        SetCreateRandomCops(false)
        SetCreateRandomCopsNotOnScenarios(false)
        SetCreateRandomCopsOnScenarios(false)
        SetGarbageTrucks(false)
        SetRandomBoats(false)
        SetVehicleDensityMultiplierThisFrame(0.0)
        SetPedDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
        ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
        RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
        Citizen.Wait(0)
    end
end)
