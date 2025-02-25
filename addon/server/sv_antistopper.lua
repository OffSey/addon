if Config.AntiStopper then
    local resourceNameToMonitor = Config.ResourceName
    local checkInterval = Config.CheckInterval * 1000

    local playerStates = {}

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(checkInterval)
            for playerId, state in pairs(playerStates) do
                if not state.isResourceActive then
                    exports[Config.ResourceName]:fg_BanPlayer(playerId, "Tried to stop fiveguard", true)
                end
            end
        end
    end)

    RegisterNetEvent("jetecheck:comme:alabatch")
    AddEventHandler("jetecheck:comme:alabatch", function(isResourceActive)
        local playerId = source
        playerStates[playerId] = { isResourceActive = isResourceActive }
    end)
end