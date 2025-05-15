local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.RTX_ThemePark_Bypass
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

RegisterNetEvent("rtx_themepark:Global:UsingAttractionPlayer", function(state)
    local bypass = {
        {category = "Client", permission = "BypassNoclip"},
        {category = "Misc", permission = "BypassSpoofedWeapons"},
        {category = "Vehicle", permission = "BypassBulletproofTires"}
    }
    for i = 1, #bypass do
        local result, errorText = exports[Fiveguard]:SetTempPermission(source, bypass[i].category, bypass[i].permission, state, false)
        if not result then
            Error(("[RTX Theme Park] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(bypass[i].category,bypass[i].permission,source,GetPlayerName(source),errorText))
        else
            Debug(("[RTX Theme Park] temporany Permission ^5\"%s.%s\"^0 was %s succesfully!\nPlayer changed: ^5[%s] %s^0"):format(bypass[i].category,bypass[i].permission,state == true and"^2granted^0" or "^1removed^0",source,GetPlayerName(source)))
        end
    end
end)