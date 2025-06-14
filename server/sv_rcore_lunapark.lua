local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.rcore_lunapark_Bypass
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

local function HandleTempPermissionsRcoreLunaPark(attraction, state)
    local source = source
    local bypassList = {
        {category = "Client", permission = "BypassNoclip"},
    }

    for i = 1, #bypassList do
        local category = bypassList[i].category
        local permission = bypassList[i].permission
        local result, errorText = exports[Fiveguard]:SetTempPermission(source, category, permission, state, false)

        if not result then
            print(("[rcore_lunapark] Failed to change permission!\nAttraction: ^3%s^0\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(attraction, category, permission, source, GetPlayerName(source), errorText))
        else
            print(("[rcore_lunapark] Temp permission ^5\"%s.%s\"^0 was %s successfully!\nAttraction: ^3%s^0\nPlayer: ^5[%s] %s^0"):format(category, permission, state and "^2granted^0" or "^1removed^0", attraction, source, GetPlayerName(source)))
        end
    end
end

-- Freefall
RegisterNetEvent("lsrp_lunapark:Freefall:attachPlayer", function()
    HandleTempPermissionsRcoreLunaPark("Freefall", true)
end)

RegisterNetEvent("lsrp_lunapark:Freefall:detachPlayer", function()
    HandleTempPermissionsRcoreLunaPark("Freefall", false)
end)

-- RollerCoaster
RegisterNetEvent("lsrp_lunapark:RollerCoaster:attachPlayer", function()
    HandleTempPermissionsRcoreLunaPark("RollerCoaster", true)
end)

RegisterNetEvent("lsrp_lunapark:RollerCoaster:detachPlayer", function()
    HandleTempPermissionsRcoreLunaPark("RollerCoaster", false)
end)

-- Wheel
RegisterNetEvent("lsrp_lunapark:Wheel:attachPlayer", function()
    HandleTempPermissionsRcoreLunaPark("Wheel", true)
end)

RegisterNetEvent("lsrp_lunapark:Wheel:detachPlayer", function()
    HandleTempPermissionsRcoreLunaPark("Wheel", false)
end)
