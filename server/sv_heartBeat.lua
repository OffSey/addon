local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.Heartbeat
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end
local lastHeartbeat = {}

RegisterNetEvent("fg:addon:heartbeat", function()
    local src = source
    lastHeartbeat[src] = os.time()
    -- Debug("Heartbeat received from: " .. src)
end)

local function check()
    for src, lastTime in pairs(lastHeartbeat) do
        if GetPlayerName(src) ~= nil then
            if os.time() - lastTime > Config.timeOut then
                local playerName = GetPlayerName(src)
                local identifier = GetPlayerIdentifier(src, 0) or "Unknown"
                Warn("The player " .. playerName .. " (ID:" .. src .. ", Identifier:" .. identifier .. ") no longer responds to the heartbeat!")
                PunishPlayer(src, Config.ban, "Heartbeat not received", false)
                lastHeartbeat[src] = nil
            end
        else
            lastHeartbeat[src] = nil
        end
    end
    Citizen.SetTimeout(Config.threadTime*1000, check)
end
check()
