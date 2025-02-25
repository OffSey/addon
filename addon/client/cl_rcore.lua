if Config.RcoreClothing then
    AddEventHandler('rcore_clothing:onClothingShopOpened', function()
        TriggerServerEvent("rcore_clothing:fiveguard:stealoutfit", true)
    end)
    AddEventHandler('rcore_clothing:onClothingShopClosed', function()
        TriggerServerEvent("rcore_clothing:fiveguard:stealoutfit", false)
    end)
end