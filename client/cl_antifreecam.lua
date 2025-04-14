local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiFreeCam
while not Fiveguard do Wait(0) end
if not Config?.enable then return end

local function checkFreeCam()
    TriggerServerEvent('fg:addon:checkFreeCam')
    Citizen.SetTimeout(5000, checkFreeCam)
end

AddEventHandler('playerSpawned', function()
    checkFreeCam()
end)

_RegisterClientCallback('fg:addon:getFocusPos', function(callback)
    local focusPos = GetFinalRenderedCamCoord()
    callback(focusPos)
end)

_RegisterClientCallback("fg:addon:freecam:client", function(callback)
    local isHousingBypass = false
    local isApartmentsBypass = false

    if Config.QS_Housing_Bypass then
        pcall(function()
            isHousingBypass = exports['qs-housing']:inDecorate()
        end)
    end

    if Config.QS_Apartments_Bypass then
        pcall(function()
            isApartmentsBypass = exports['qs-apartments']:inDecorate()
        end)
    end

    local isBypassed = isHousingBypass or isApartmentsBypass
    callback(isBypassed)
end)

