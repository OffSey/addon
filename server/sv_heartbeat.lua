local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.Heartbeat
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end
local lastHeartbeat = {}

---@param identifier string
---@param callback fun(playtime:integer)
local function getPlayerPlaytime(identifier, callback)
    local playtime = math.random(1, 100)
    if callback then
        callback(playtime)
    end
end


local verifyHeartbeat = {}
RegisterNetEvent("fg:addon:heartbeat", function(gameTime)
    local src = source
    if verifyHeartbeat[src] and verifyHeartbeat[src] <= gameTime then
        return exports[Fiveguard]:fg_BanPlayer(src, "Try to create fake heartbeats.", true)
    end
    verifyHeartbeat[src] = gameTime

    lastHeartbeat[src] = os.time()
    Debug("Heartbeat received from: " .. src)
end)

AddEventHandler('playerDropped', function()
    local src = source
    if lastHeartbeat[src] then
        lastHeartbeat[src] = nil
        Debug("Player " .. src .. " removed from lastHeartbeat table.")
    end
end)

local function check()
    for src, lastTime in pairs(lastHeartbeat) do
        if GetPlayerName(src) ~= nil then
            if os.time() - lastTime > Config.timeOut then
                local playerName = GetPlayerName(src)
                local identifier = GetPlayerIdentifier(src, 0) or "Unknown"

                Warn("The player " .. playerName .. " (ID:" .. src .. ", Identifier:" .. identifier .. ") no longer responds to the heartbeat!")

                getPlayerPlaytime(identifier, function(playtime)
                    print("[ALERTE] The player " .. playerName .. " (ID:" .. src .. ", Identifier:" .. identifier .. " , Playtime Total:" .. playtime .. ") seems to have disabled its client-side script")
                end)
                Debug("Running the DropPlayer for the player " .. playerName .. " (ID: " .. src .. ")")
                if Config.Ban then
                    exports[Fiveguard]:fg_BanPlayer(src, "Heartbeat not received", true)
                else
                    DropPlayer(src, "Heartbeat not received")
                end

                Citizen.Wait(1000)

                if GetPlayerName(src) ~= nil then
                    Debug("DropPlayer failed for player ID: " .. src)
                else
                    Debug("Player " .. playerName .. " (ID: " .. src .. ") has been disconnected due to Heartbeat inactivity.")
                end

                lastHeartbeat[src] = nil
                Debug("Player Reset " .. playerName .. " (ID: " .. src .. ") in the lastHeartbeat table.")
            end
        else
            lastHeartbeat[src] = nil
            Debug("Deleting the ID entry " .. src .. " because the player is no longer present.")
        end
    end
    Citizen.SetTimeout(Config.ThreadTime*1000, check)
end
Citizen.SetTimeout(Config.ThreadTime*1000, check)
