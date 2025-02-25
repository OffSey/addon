if Config.AntiModelDetector then
    local function checkModel(source)
        local model = GetEntityModel(GetPlayerPed(source))

        for _, forbidden in ipairs(SVConfig.ForbiddenModels) do
            if model == GetHashKey(forbidden) then
                local message = SVConfig.Messages[SVConfig.Language] .. forbidden

                if SVConfig.TestMode then
                    Debug("Test Mode: Detected Player ID: " .. source .. " using model: " .. forbidden)
                else
                    exports[Config.ResourceName]:fg_BanPlayer(source, message, true)
                end
                break
            end
        end
    end

    Citizen.CreateThread(function()
        Debug("AntiCheat model detection thread started. Interval: " .. SVConfig.ModelCheck .. "ms")

        while true do
            Citizen.Wait(SVConfig.ModelCheck)
            local players = GetPlayers()
            Debug("Scanning " .. #players .. " players for forbidden models.")

            for i = 1, #players do
                checkModel(tonumber(players[i]))
            end
        end
    end)

    RegisterCommand("checkmodel", function(source, args)
        local target = tonumber(args[1])
        if target then 
            Debug("Admin triggered manual model check on Player ID: " .. target)
            checkModel(target)
        else
            print("/checkmodel [PlayerID]")
        end
    end, true)
end