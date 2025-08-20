local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiCarry
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

local function checkThrow ()
    local players = GetPlayers()
    for _, src in ipairs(players) do
        local ped = GetPlayerPed(src)
        if ped and ped ~= 0 then
            -- local vehicles0 = GetGamePool("CVehicle")
            local vehicles = GetAllVehicles()
            for _, veh in pairs(vehicles) do
                if DoesEntityExist(veh) then
                    local attachedTo = GetEntityAttachedTo(veh)
                    if attachedTo == ped and GetPedInVehicleSeat(veh, -1) ~= ped then
                        if Config.ban then
                            BanPlayer(sender,"Tried to throw a vehicle (2)", Config.recordPlayer)
                        else
                            DropPlayer(sender,"[FIVEGUARD.NET] You have been kicked")
                        end
                    end
                end
            end
        end
    end
    Citizen.SetTimeout(3000, checkThrow)
end
checkThrow()

RegisterNetEvent('fg:addon:antiThrow')
AddEventHandler('fg:addon:antiThrow', function()
    if Config.ban then
        BanPlayer(source, "Tried to throw a vehicle (1)",Config.recordPlayer)
    else
        DropPlayer(sender,"[FIVEGUARD.NET] You have been kicked")
    end
end)
