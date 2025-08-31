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
    if GetEntityPopulationType(entity) ~= 5 then return end
    local et = GetEntityType(entity)
    if et ~= 2 and et ~= 1 then return end
    local owner = NetworkGetEntityOwner(entity)
    if not owner or owner == 0 or owner == -1 or owner == "" then return end
    local currentTime = os.time()
    if currentTime - lastDetection < 15 then
        return
    end
    lastDetection = currentTime
    PunishPlayer(owner, Config.ban, ("Tried To Spawn a %s (%s)"):format(et == 1 and "Ped" or "Vehicle", GetEntityModel(entity)), "image")
    DeleteEntity(entity)
end)
