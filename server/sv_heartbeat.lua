local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.Heartbeat
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end
local hbState = {}

local function newToken(src)
    return ("%d:%d:%d"):format(src, GetGameTimer(), math.random(100000, 999999))
end

local function intervalWithJitter()
    local jitter = (math.random() * 2 - 1) * (Config.jitter)
    return math.floor((Config.threadTime * 1000) * (1 + jitter))
end

CreateThread(function()
    Citizen.Wait(1000)
    for _, id in ipairs(GetPlayers()) do
        local src = tonumber(id)
        ---@diagnostic disable-next-line: need-check-nil
        hbState[src] = { clientReady = false, lastSeen = GetGameTimer(), expected = nil, misses = 0, lastFast = 0, lastSlow = 0 }
    end
end)

AddEventHandler("playerJoining", function()
    hbState[source] = { clientReady = false, lastSeen = GetGameTimer(), expected = nil, misses = 0, lastFast = 0, lastSlow = 0 }
end)

AddEventHandler("playerDropped", function()
    hbState[source] = nil
end)

RegisterNetEvent("fg:addon:heartbeat:pong", function(token, clientFast, clientSlow)
    Debug(("heartbeat received! source: %s token: %s clientFast: %s clientSlow: %s"):format(source, token, clientFast, clientSlow))
    local st = hbState[source]
    if not st then return end
    if not st.clientReady then
        st.clientReady = true
    end
    if not (token and token == st.expected) then
        st.misses = math.min(st.misses + 1, Config.graceMisses)
        return
    end

    local okFast = type(clientFast) == "number" and clientFast > st.lastFast
    local okSlow = type(clientSlow) == "number" and clientSlow > st.lastSlow

    if okFast and okSlow then
        st.lastSeen = GetGameTimer()
        st.lastFast = clientFast
        st.lastSlow = clientSlow
        st.misses = 0
        st.expected = nil
    else
        st.misses += 1
        st.expected = nil
    end
end)

CreateThread(function()
    while true do
        local cycleStart = GetGameTimer()
        for _, id in ipairs(GetPlayers()) do
            local src = tonumber(id)
            ---@diagnostic disable-next-line: need-check-nil
            hbState[src] = hbState[src] or { clientReady = false, lastSeen = GetGameTimer(), expected = nil, misses = 0, lastFast = 0, lastSlow = 0 }
            local t = newToken(src)
            hbState[src].expected = t
            ---@diagnostic disable-next-line: param-type-mismatch
            TriggerClientEvent("fg:addon:heartbeat:ping", src, t)
            Debug(("heartbeat sent to %s with token %s"):format(src,t))
        end

        Citizen.Wait(math.floor((Config.threadTime * 1000) / 2))

        local now = GetGameTimer()
        for _, id in ipairs(GetPlayers()) do
            local src = tonumber(id)
            local st = hbState[src]
            if st and st.clientReady then
                    if now - st.lastSeen > (Config.timeOut * 1000) then
                    st.misses += 1
                end
                if st.misses >= (Config.graceMisses) then
                    PunishPlayer(src, Config.ban, "Heartbeat not received (misses: "..tostring(st.misses)..")", false)
                end
            end
        end

        local spent = GetGameTimer() - cycleStart
        local sleep = intervalWithJitter() - spent
        if sleep < 0 then sleep = 0 end
        Citizen.Wait(sleep)
    end
end)
