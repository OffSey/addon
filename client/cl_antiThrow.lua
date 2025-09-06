local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiThrow
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

local function isPlayingBlacklistedAnim(ped)
    if IsEntityPlayingAnim(ped, 'anim@mp_rollarcoaster', 'hands_up_idle_a_player_one', 3) then
        return true
    end
    return false
end

local function isWhitelistedZone(ped)
    local playerCoords = GetEntityCoords(ped)
    for i = 1, #Config.whitelistedZones do
        if #(playerCoords - zone.coords) < Config.whitelistedZones[i].radius then
            return true
        end
    end
    return false
end

local function check()
    local playerPed = PlayerPedId()
    if isPlayingBlacklistedAnim(playerPed) and not isWhitelistedZone(playerPed) then
        TriggerServerEvent("fg:addon:antiThrow:punish")
        ForceSocialClubUpdate()
    end
    Citizen.SetTimeout(200, check)
end
check()
