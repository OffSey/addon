local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiStopper
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end
local playerStates = {}

local function check()
    for playerId, state in pairs(playerStates) do
        if not state then
            if Config.ban then
                BanPlayer(playerId, "Stopped Fiveguard", false)
            else
                DropPlayer(sender,"[FIVEGUARD.NET] You have been kicked")
            end
        end
    end
    Citizen.SetTimeout(Config.checkInterval * 1000, check)
end
check()

RegisterNetEvent("fg:addon:resourceState", function(isResourceActive)
    -- Debug(('[AntiStopper] Fiveguard state received from %s with status %s'):format(source,isResourceActive))
    playerStates[source] = isResourceActive
end)
