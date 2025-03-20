local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiCarry
while not Fiveguard do Wait(0) end
if not Config?.enable then return end

local function isPlayingBlacklistedAnim(ped)
    if IsEntityPlayingAnim(ped, 'anim@mp_rollarcoaster', 'hands_up_idle_a_player_one', 3) then
        return true
    end
    return false
end

local function isWhitelistedZone(ped)
    local playerCoords = GetEntityCoords(ped)
    for i = 1, #Config.whitelistedZones do
        local distance = #(playerCoords - zone.coords)
        if distance <= Config.whitelistedZones[i].radius then
            return true
        end
    end
    return false
end

local function check()
    local playerPed = PlayerPedId()
    if isPlayingBlacklistedAnim(playerPed) and not isWhitelistedZone(playerPed) then
        TriggerServerEvent("fg:addon:antiThrow")
    end
    Citizen.SetTimeout(200, check)
end
check()
