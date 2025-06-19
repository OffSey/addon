local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.ExportsNative
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end


if Config.SetEntityCoords then
    RegisterNetEvent("fg:addon:EntityCoords", function(bol)
        local result, errorText = exports[Fiveguard]:SetTempPermission(source, "Client", "BypassTeleport", bol, false)
        if not result then
            Error(("[Addon] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format("Client","BypassTeleport",source,GetPlayerName(source),errorText))
        else
            Debug(("[Addon] temporany Permission ^5\"%s.%s\"^0 was %s succesfully!\nPlayer changed: ^5[%s] %s^0"):format("Client","BypassTeleport",state == true and"^2granted^0" or "^1removed^0",source,GetPlayerName(source)))
        end
    end)
end

if Config.SetEntityVisible then
    RegisterNetEvent("fg:addon:EntityVisible", function(bol)
        local result, errorText = exports[Fiveguard]:SetTempPermission(source, "Client", "BypassInvisible", bol, false)
        if not result then
            Error(("[Addon] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format("Client","BypassInvisible",source,GetPlayerName(source),errorText))
        else
            Debug(("[Addon] temporany Permission ^5\"%s.%s\"^0 was %s succesfully!\nPlayer changed: ^5[%s] %s^0"):format("Client","BypassInvisible",state == true and"^2granted^0" or "^1removed^0",source,GetPlayerName(source)))
        end
    end)
end