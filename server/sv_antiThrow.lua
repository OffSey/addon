local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiThrow
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

local function checkThrow ()
    local pedToSrc = {}
    for _, src in ipairs(GetPlayers()) do
        local ped = GetPlayerPed(src)
        if ped and ped ~= 0 then
            pedToSrc[ped] = src
        end
    end
    for _, veh in ipairs(GetGamePool("CVehicle")) do
        if DoesEntityExist(veh) then
            local attachedTo = GetEntityAttachedTo(veh)
            local src = pedToSrc[attachedTo]
            if src and GetPedInVehicleSeat(veh, -1) ~= attachedTo then
                PunishPlayer(src, Config.ban, "Tried to throw a vehicle (2)", Config.banMedia)
            end
        end
    end
    Citizen.SetTimeout(3000, checkThrow)
end
checkThrow()

RegisterNetEvent('fg:addon:antiThrow:punish', function()
    PunishPlayer(source, Config.ban, "Tried to throw a vehicle (1)",Config.banMedia)
end)
