local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiStopper
while not Fiveguard do Wait(0) end
if not Config?.enable then return end

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("fg:addon:resourceState", GetResourceState(Fiveguard) == "started")
end)

local function check()
    TriggerServerEvent("fg:addon:resourceState", GetResourceState(Fiveguard) == "started")
    Citizen.SetTimeout(Config.checkInterval * 1000, check)
end
Citizen.SetTimeout(Config.checkInterval * 1000, check)
