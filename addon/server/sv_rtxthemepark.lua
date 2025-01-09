if Config.ThemeParkRTX then
    print("Debug: ThemePark-RTX: "..tostring(Config.ThemeParkRTX))
    RegisterNetEvent("rtx_themepark:Global:UsingAttractionPlayer")
    AddEventHandler("rtx_themepark:Global:UsingAttractionPlayer", function(themeparkhandlerusing)
        local playersource = source
        if themeparkhandlerusing then
            local result, errorText = exports[Config.ResourceName]:SetTempPermission(playersource, "Client", "BypassNoclip", true, false)
            if not result then
                print("[fiveguard] Error for approved the RTX_ThemePark NoClip permissions for " .. playersource .. ": " .. errorText)
            else
                print("[fiveguard] Permissions for RTX_ThemePark Noclip approved for " .. playersource)
            end
            local result, errorText = exports[Config.ResourceName]:SetTempPermission(playersource, "Misc", "BypassSpoofedWeapons", true, false)
            if not result then
                print("[fiveguard] Error for approved the RTX_ThemePark SpoofedWeapons permissions for " .. playersource .. ": " .. errorText)
            else
                print("[fiveguard] Permissions for RTX_ThemePark SpoofedWeapons approved for " .. playersource)
            end
            local result, errorText = exports[Config.ResourceName]:SetTempPermission(playersource, "Vehicle", "BypassBulletproofTires", true, false)
            if not result then
                print("[fiveguard] Error for approved the RTX_ThemePark BulletproofTires permissions for " .. playersource .. ": " .. errorText)
            else
                print("[fiveguard] Permissions for RTX_ThemePark BulletproofTires approved for " .. playersource)
            end
        else
            local result, errorText = exports[Config.ResourceName]:SetTempPermission(playersource, "Client", "BypassNoclip", false, false)
            if not result then
                print("[fiveguard] Error for removed the RTX_ThemePark NoClip permissions " .. playersource .. ": " .. errorText)
            else
                print("[fiveguard] Permissions for approved RTX_ThemePark Noclip for " .. playersource)
            end
            local result, errorText = exports[Config.ResourceName]:SetTempPermission(playersource, "Misc", "BypassSpoofedWeapons", false, false)
            if not result then
                print("[fiveguard] Error for removed the RTX_ThemePark SpoofedWeapons permissions for " .. playersource .. ": " .. errorText)
            else
                print("[fiveguard] Permissions for RTX_ThemePark SpoofedWeapons removed for " .. playersource)
            end
            local result, errorText = exports[Config.ResourceName]:SetTempPermission(playersource, "Vehicle", "BypassBulletproofTires", false, false)
            if not result then
                print("[fiveguard] Error for removed the RTX_ThemePark BulletproofTires permissions for " .. playersource .. ": " .. errorText)
            else
                print("[fiveguard] Permissions for RTX_ThemePark BulletproofTires removed for " .. playersource)
            end
        end
    end)
else
    print("Debug: ThemePark-RTX: "..tostring(Config.ThemeParkRTX))
end