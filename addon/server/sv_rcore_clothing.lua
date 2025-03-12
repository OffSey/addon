local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.rcore_clothing_bypass
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

RegisterNetEvent("fg:addon:rcore_clothing:onClothingShop", function(bol)
    local result, errorText = exports[Fiveguard]:SetTempPermission(source, "Client", "BypassStealOutfit", bol, false)
    if not result then
        Error(("[rcore_clothing] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format("Client","BypassStealOutfit",source,GetPlayerName(source),errorText))
    else
        Debug(("[rcore_clothing] temporany Permission ^5\"%s.%s\"^0 was %s succesfully!\nPlayer changed: ^5[%s] %s^0"):format("Client","BypassStealOutfit",state == true and"^2granted^0" or "^1removed^0",source,GetPlayerName(source)))
    end
end)