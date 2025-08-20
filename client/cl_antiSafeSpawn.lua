local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiSafeSpawn
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

--thanks to https://discord.com/users/589401992305311756
local function check_veh()
    local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if DoesEntityExist(veh) and not NetworkGetEntityIsNetworked(veh) then
                local pos = GetEntityCoords(ped)
                local inWhitelistZone = false
                for i=1, #Config.whitelistedZones do
                    local zone = Config.whitelistedZones[i]
                    local rq = zone.radius * zone.radius
                    if Vdist2(pos.x,pos.y,pos.z, zone.coords.x,zone.coords.y,zone.coords.z) <= rq then
                        inWhitelistZone = true
                        break
                    end
                end
                Debug('inWhitelistZone',inWhitelistZone)
                if not inWhitelistZone then
                    DeleteEntity(veh)
                end
            end
        end
    Citizen.SetTimeout(10000,check_veh)
end
check_veh()
