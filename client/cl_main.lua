-- local data = LoadResourceFile(CurrentResourceName,'config.lua')
-- local Config = assert(load(data))()
while not Fiveguard do Citizen.Wait(0) end

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('fg:addon:playerSpawned')
end)
READY = true
