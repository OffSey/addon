local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiThrow
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

local function checkThrow ()
    local players = GetPlayers()
    for _, src in ipairs(players) do
        local ped = GetPlayerPed(src)
        if ped and ped ~= 0 then
            -- local vehicles0 = GetGamePool("CVehicle")
            local vehicles = GetAllVehicles()
            ---@diagnostic disable-next-line: param-type-mismatch
            for _, veh in pairs(vehicles) do
                if DoesEntityExist(veh) then
                    local attachedTo = GetEntityAttachedTo(veh)
                    if attachedTo == ped and GetPedInVehicleSeat(veh, -1) ~= ped then
                        PunishPlayer(sender, Config.ban, "Tried to throw a vehicle (2)", Config.banMedia)
                    end
                end
            end
        end
    end
    Citizen.SetTimeout(3000, checkThrow)
end
checkThrow()

RegisterNetEvent('fg:addon:antiThrow:punish', function()
    PunishPlayer(source, Config.ban, "Tried to throw a vehicle (1)",Config.banMedia)
end)
