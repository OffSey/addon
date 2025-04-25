local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiStopper
while not Fiveguard do Wait(0) end
if not Config?.enable then return end

local oldGameTimer = nil

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("fg:addon:resourceState", GetResourceState(Fiveguard) == "started")
end)

local function check()
    TriggerServerEvent("fg:addon:resourceState", GetResourceState(Fiveguard) == "started")
    Citizen.SetTimeout(Config.checkInterval * 1000, check)
    
    if oldGameTimer and oldGameTimer == GetGameTimer() then
        TriggerServerEvent("fg:addon:resourceState", false, true) -- Susano Advenced Anti Stopper.
    end
    oldGameTimer = GetGameTimer()
end
check()
