if Config.ThemeParkRTX then
    RegisterNetEvent("rtx_themepark:Global:UsingAttractionPlayer")
    AddEventHandler("rtx_themepark:Global:UsingAttractionPlayer", function(themeparkhandlerusing)
        local playersource = source
        local bypass = {
            {category = "Client", permission = "BypassNoclip"},
            {category = "Misc", permission = "BypassSpoofedWeapons"},
            {category = "Vehicle", permission = "BypassBulletproofTires"}
        }
        for k, v in pairs(bypass) do
            
            local result, errorText = exports[Config.ResourceName]:SetTempPermission(playersource, v.category, v.permission, themeparkhandlerusing, false)
            if not result then
                print("[Fiveguard] Error for permissions for RTX_ThemePark for the permissions: "..v.permission.. " PlayerID: "..playersource.." Error Text: "..errorText)
            else
                print("[Fiveguard] Permissions for RTX_ThemePark for the permissions: "..v.permission.." its: "..themeparkhandlerusing.. "PlayerID: "..playersource)
            end
        end
    end)
end
