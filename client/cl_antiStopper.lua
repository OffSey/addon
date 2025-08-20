local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiStopper
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

local function check()
    TriggerServerEvent("fg:addon:resourceState", GetResourceState(Fiveguard) == "started")
    Citizen.SetTimeout(Config.checkInterval * 1000, check)
end
check()
