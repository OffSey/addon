local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.Heartbeat
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

local function check()
    TriggerServerEvent("fg:addon:heartbeat")
    Citizen.SetTimeout(Config.threadTime*1000, check)
end
check()
