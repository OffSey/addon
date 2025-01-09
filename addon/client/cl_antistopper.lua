if Config.AntiStopper then
    local resourceNameToMonitor = Config.ResourceName

    local function isResourceActive()
        return GetResourceState(resourceNameToMonitor) == "started"
    end

    AddEventHandler("playerSpawned", function()
        TriggerServerEvent("jetecheck:comme:alabatch", isResourceActive())
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.CheckInterval * 1000)
            TriggerServerEvent("jetecheck:comme:alabatch", isResourceActive())
        end
    end)
end