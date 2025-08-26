local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.AntiPedManipulation
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

for i = 0, Config.maxBucketUsed do
    SetRoutingBucketPopulationEnabled(i, false)
end
local lastDetection = 0

AddEventHandler('entityCreated', function(entity)
    if not DoesEntityExist(entity) then return end

    local popType = GetEntityPopulationType(entity)
    if popType ~= 5 then return end

    local entity_type = GetEntityType(entity)
    if entity_type ~= 2 and entity_type ~= 1 then return end

    local owner = NetworkGetEntityOwner(entity)
    if not owner or owner == 0 or owner == -1 or owner == "" then return end

    local currentTime = os.time()
    if currentTime - lastDetection < 15 then
        return
    end

    lastDetection = currentTime

    PunishPlayer(owner, Config.ban, ("Tried To Spawn a Ped (%s)"):format(GetEntityModel(entity)), "image")
    DeleteEntity(entity)
end)
