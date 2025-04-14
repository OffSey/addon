local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiFreeCam
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

local function GetFreeCamAdmin(playerId)
    local group = nil
    if GetResourceState('es_extended') == 'started' then
        local ESX = exports.es_extended:getSharedObject()
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            group = xPlayer.getGroup()
        end
    elseif GetResourceState('qbx_core') == 'started' then
        for _, g in pairs(Config.AdminGroup) do
            if IsPlayerAceAllowed(playerId, g) then
                return true
            end
        end
        return false
    elseif GetResourceState('qb-core') == 'started' then
        for _, g in pairs(Config.AdminGroup) do
            if IsPlayerAceAllowed(playerId, g) then
                return true
            end
        end
        return false
    elseif GetResourceState('vrp') == 'started' then
        local chunk = LoadResourceFile('vrp','lib/utils.lua')
        if chunk then
            load(chunk)()
            ---@diagnostic disable-next-line: deprecated
            local Proxy = module("vrp", "lib/Proxy")
            local vRP = Proxy.getInterface("vRP")
            local user_id = vRP.getUserId(playerId)
            for _, g in pairs(Config.AdminGroup) do
                if vRP.hasGroup(user_id, g) then
                    return true
                end
            end
        end
        return false
    end
    if group then
        for _, g in pairs(Config.AdminGroup) do
            if group == g then
                return true
            end
        end
    end
    return false
end

local function IsInWhiteListZone(coords)
    if not next(Config.WhiteListZone) then return false end
    for _, zone in pairs(Config.WhiteListZone) do
        if zone and zone.coords and zone.radius then
            if #(coords - zone.coords) <= zone.radius then
                return true
            end
        end
    end
    return false
end

local function checkFreeCamPlayer(playerId)
    if GetFreeCamAdmin(playerId) then return end
    local coords = GetEntityCoords(GetPlayerPed(playerId))

    TriggerClientCallback(playerId, "fg:addon:getFocusPos", function(getPlayerFocusPos)
        if not getPlayerFocusPos then return end
        if #(coords - getPlayerFocusPos) > Config.DistanceFreeCam then
            TriggerClientCallback(playerId, "fg:addon:freecam:client", function(bypass)
                if not bypass then bypass = IsInWhiteListZone(coords) end
                if not bypass then
                    if Config.Ban then
                        exports[Fiveguard]:fg_BanPlayer(playerId, "Anti FreeCam [Addon]", true)
                    else
                        DropPlayer(playerId, "[fiveguard] You have been kicked by the anticheat")
                    end
                end
            end)
        end
    end)
end

RegisterNetEvent('fg:addon:checkFreeCam', function()
    local src = source
    checkFreeCamPlayer(src)
end)
