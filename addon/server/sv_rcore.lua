if Config.RcoreClothing then
    RegisterNetEvent("rcore_clothing:fiveguard:stealoutfit")
    AddEventHandler("rcore_clothing:fiveguard:stealoutfit", function(booloen)
        local playersource = source
        local bypass = {
            {category = "Client", permission = "BypassStealOutfit"},
        }
        for k, v in pairs(bypass) do
            
            local result, errorText = exports[Config.ResourceName]:SetTempPermission(playersource, v.category, v.permission, booloen, false)
            if not result then
                Debug("[Fiveguard] Error for permissions for Rcore_Clothing for the permissions: "..v.permission.. " PlayerID: "..playersource.." Error Text: "..errorText)
            else
                Debug("[Fiveguard] Permissions for Rcore_Clothing for the permissions: "..v.permission.." its: "..booloen.. "PlayerID: "..playersource)
            end
        end
    end)
end
