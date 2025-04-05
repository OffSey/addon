local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.Heartbeat
while not Fiveguard do Wait(0) end
if not Config?.enable then return end

local function check()
    TriggerServerEvent("fg:addon:heartbeat", GetGameTimer())
    Citizen.SetTimeout(Config.timeOut*1000, check)
end
check()
