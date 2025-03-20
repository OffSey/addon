local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiStopper
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end
local playerStates = {}

local function check()
    for playerId, state in pairs(playerStates) do
        if not state then
            exports[Fiveguard]:fg_BanPlayer(playerId, "Stopped fiveguard", true)
        end
    end
    Citizen.SetTimeout(Config.checkInterval * 1000, check)
end
Citizen.SetTimeout(Config.checkInterval * 1000, check)

RegisterNetEvent("fg:addon:resourceState", function(isResourceActive)
    Debug(('[AntiStopper] Fiveguard state received from %s with status %s'):format(source,isResourceActive))
    playerStates[source] = isResourceActive
end)
