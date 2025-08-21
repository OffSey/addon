local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.Bypasses
if not Config.enable then return end
while not READY do Citizen.Wait(0) end
local R_EVENTS = {}
local B_CATEGORY = {
    -- AdminMenu
    ["AdminMenuAccess"] = "AdminMenu",
    ["AnnouncementAccess"] = "AdminMenu",
    ["ESPAccess"] = "AdminMenu",
    ["ClearEntitiesAccess"] = "AdminMenu",
    ["BanAndKickAccess"] = "AdminMenu",
    ["GotoAndBringAccess"] = "AdminMenu",
    ["VehicleAccess"] = "AdminMenu",
    ["MiscAccess"] = "AdminMenu",
    ["LogsAccess"] = "AdminMenu",
    ["PlayerSelectorAccess"] = "AdminMenu",
    ["BanListAndUnbanAccess"] = "AdminMenu",
    ["ModelChangerAccess"] = "AdminMenu",
    -- Client
    ["BypassSpectate"] = "Client",
    ["BypassGodMode"] = "Client",
    ["BypassInvisible"] = "Client",
    ["BypassStealOutfit"] = "Client",
    ["BypassInfStamina"] = "Client",
    ["BypassNoclip"] = "Client",
    ["BypassSuperJump"] = "Client",
    ["BypassFreecam"] = "Client",
    ["BypassSpeedHack"] = "Client",
    ["BypassTeleport"] = "Client",
    ["BypassNightVision"] = "Client",
    ["BypassThermalVision"] = "Client",
    ["BypassExplosiveAmmo"] = "Client",
    ["BypassOCR"] = "Client",
    ["BypassNuiDevtools"] = "Client",
    ["BypassBlacklistedTextures"] = "Client",
    ["BlipsBypass"] = "Client",
    ["BypassCbScanner"] = "Client",
    ["BypassSpoofedBulletShot"] = "Client",
    -- Weapon
    ["BypassWeaponDmgModifier"] = "Weapon",
    ["BypassInfAmmo"] = "Weapon",
    ["BypassNoReload"] = "Weapon",
    ["BypassRapidFire"] = "Weapon",
    -- Vehicle
    ["BypassVehicleFixAndGodMode"] = "Vehicle",
    ["BypassVehicleHandlingEdit"] = "Vehicle",
    ["BypassVehicleModifier"] = "Vehicle",
    ["BypassBulletproofTires"] = "Vehicle",
    ["BypassVehiclePlateChanger"] = "Vehicle",
    -- Blacklist
    ["BypassModelChanger"] = "Blacklist",
    ["BypassWeaponBlacklist"] = "Blacklist",
    -- Misc
    ["FGCommands"] = "Misc",
    ["BypassVPN"] = "Misc",
    ["BypassExplosion"] = "Misc",
    ["BypassClearTasks"] = "Misc",
    ["BypassParticle"] = "Misc",
    ["BypassSpoofedWeapons"] = "Misc"
}

local setAutoBypass = function(se, ee, bp, useBooleanArg)
    local result, errorText
    if not se or not bp then return end
    if R_EVENTS[se] then return Warn(('Event %s is already registered to bypass %s'):format(se,bp)) end
    if type(bp) == "string" then bp = { bp } end
    if ee then
        R_EVENTS[se] = AddEventHandler(se, function(...)
            for i = 1, #bp do
                result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY[bp[i]], bp[i], true)
                if not result then
                    Error(("[SetTempPermission] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(B_CATEGORY[bp[i]], bp[i],source,GetPlayerName(source),errorText))
                else
                    Debug(("[SetTempPermission] temporany Permission ^5\"%s.%s\"^0 was %s succesfully!\nPlayer changed: ^5[%s] %s^0"):format(B_CATEGORY[bp[i]], bp[i],"^2granted^0",source,GetPlayerName(source)))
                end
            end
        end)
        Debug(('Event ^5"%s"^0 registered to ^2enable^0 bypass ^5%s^0'):format(se,json.encode(bp)))
        if R_EVENTS[ee] then return Warn(('Event %s is already registered'):format(ee)) end
        R_EVENTS[ee] = AddEventHandler(ee, function(...)
            for i = 1, #bp do
                result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY[bp[i]], bp[i], false)
                if not result then
                    Error(("[SetTempPermission] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(B_CATEGORY[bp[i]], bp[i],source,GetPlayerName(source),errorText))
                else
                    Debug(("[SetTempPermission] temporany Permission ^5\"%s.%s\"^0 was %s succesfully!\nPlayer changed: ^5[%s] %s^0"):format(B_CATEGORY[bp[i]], bp[i],"^1removed^0",source,GetPlayerName(source)))
                end
            end
        end)
        Debug(('Event ^5"%s"^0 registered to ^1disable^0 bypass ^5%s^0'):format(ee,json.encode(bp)))
    else
        if useBooleanArg then
            R_EVENTS[se] = AddEventHandler(se, function(bol,...)
                if not bol then return Error(se.. 'don\'t have a boolean argoument!') end
                for i = 1, #bp do
                    result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY[bp[i]], bp[i], bol)
                    if not result then
                        Error(("[SetTempPermission] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(B_CATEGORY[bp[i]], bp[i],source,GetPlayerName(source),errorText))
                    else
                        Debug(("[SetTempPermission] temporany Permission ^5\"%s.%s\"^0 was %s succesfully!\nPlayer changed: ^5[%s] %s^0"):format(B_CATEGORY[bp[i]], bp[i],bol == true and"^2granted^0" or "^1removed^0",source,GetPlayerName(source)))
                    end
                end
            end)
            Debug(('Event ^5"%s"^0 registered to ^3swith^0 bypass ^5%s^0'):format(se,json.encode(bp)))
        else
            R_EVENTS[se] = AddEventHandler(se, function(...)
                for i = 1, #bp do
                    result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY[bp[i]], bp[i], true)
                    if not result then
                        Error(("[SetTempPermission] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(B_CATEGORY[bp[i]], bp[i],source,GetPlayerName(source),errorText))
                    else
                        Debug(("[SetTempPermission] temporany Permission ^5\"%s.%s\"^0 was %s succesfully!\nPlayer changed: ^5[%s] %s^0"):format(B_CATEGORY[bp[i]], bp[i],"^2granted^0",source,GetPlayerName(source)))
                    end
                end
                Citizen.SetTimeout(5000, function()
                    for i = 1, #bp do
                        result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY[bp[i]], bp[i], false)
                        if not result then
                            Error(("[SetTempPermission] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(B_CATEGORY[bp[i]], bp[i],source,GetPlayerName(source),errorText))
                        else
                            Debug(("[SetTempPermission] temporany Permission ^5\"%s.%s\"^0 was %s succesfully!\nPlayer changed: ^5[%s] %s^0"):format(B_CATEGORY[bp[i]], bp[i],"^1removed^0",source,GetPlayerName(source)))
                        end
                    end
                end)
            end)
            Debug(('Event ^5"%s"^0 registered to ^2enable^0 bypass ^5%s^0'):format(se,json.encode(bp)))
        end
    end
end

do
    for startEvent, value in pairs(Config.onServerTrigger) do
        if type(value) ~= "table" then return Error("Can't load bypasses config") end
        if not value.enable then goto continue end
        if value.endEvent == false then
            setAutoBypass(startEvent, nil, value.bypass, false)
        elseif startEvent == value.endEvent then
            setAutoBypass(startEvent, nil, value.bypass, true)
        else
            setAutoBypass(startEvent, value.endEvent, value.bypass)
        end
        ::continue::
    end
    for startEvent, value in pairs(Config.onClientTrigger) do
        if type(value) ~= "table" then return Error("Can't load bypasses config") end
        if not value.enable then goto continue end
        if value.endEvent == false then
            RegisterNetEvent(('fg:addon:%s'):format(startEvent))
            setAutoBypass('fg:addon:'..startEvent, nil, value.bypass, false)
        elseif startEvent == value.endEvent then
            RegisterNetEvent(('fg:addon:%s'):format(startEvent))
            setAutoBypass('fg:addon:'..startEvent, nil, value.bypass, true)
        else
            RegisterNetEvent(('fg:addon:%s'):format(startEvent))
            RegisterNetEvent(('fg:addon:%s'):format(value.endEvent))
            setAutoBypass('fg:addon:'..startEvent, value?.endEvent and 'fg:addon:'..value.endEvent or nil, value.bypass)
        end
        ::continue::
    end
end

AddEventHandler('onResourceStop', function(res)
    if CurrentResourceName ~= res then return end
    for eventName , value in pairs(R_EVENTS) do
        if value then
            RemoveEventHandler(value)
            R_EVENTS[eventName] = nil
        end
    end
end)
