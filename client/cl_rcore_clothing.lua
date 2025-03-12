local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.rcore_clothing_bypass
while not Fiveguard do Wait(0) end
if not Config?.enable then return end

AddEventHandler('rcore_clothing:onClothingShopOpened', function()
    TriggerServerEvent("fg:addon:rcore_clothing:onClothingShop", true)
end)
AddEventHandler('rcore_clothing:onClothingShopClosed', function()
    TriggerServerEvent("fg:addon:rcore_clothing:onClothingShop", false)
end)