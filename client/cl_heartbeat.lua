local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.Heartbeat
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

local fastTick = GetGameTimer()
local slowTick = GetGameTimer()

CreateThread(function()
    while true do
        Wait(0)
        fastTick = GetGameTimer()
    end
end)

local function check()
    slowTick = GetGameTimer()
    Citizen.SetTimeout(100, check)
end
check()

RegisterNetEvent("fg:addon:heartbeat:ping", function(token)
    TriggerServerEvent("fg:addon:heartbeat:pong", token, fastTick, slowTick)
end)
