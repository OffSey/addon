local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.EasyBypass
if not Config?.enable then return end
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
        R_EVENTS[se] = AddEventHandler(se, function()
            for i = 1, #bp do
                result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY[bp[i]], bp[i], true)
                if not result then
                    if Config.verbose then
                        Warn(("[SetTempPermission] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(B_CATEGORY[bp[i]], bp[i],source,GetPlayerName(source),errorText))
                    end
                else
                    Debug(("[SetTempPermission] temporany Permission ^5\"%s.%s\"^0 was %s succesfully!\nPlayer changed: ^5[%s] %s^0"):format(B_CATEGORY[bp[i]], bp[i],"^2granted^0",source,GetPlayerName(source)))
                end
            end
        end)
        Debug(('Event ^5"%s"^0 registered to ^2enable^0 bypass ^5%s^0'):format(se,json.encode(bp)))
        if R_EVENTS[ee] then return Warn(('Event %s is already registered'):format(ee)) end
        R_EVENTS[ee] = AddEventHandler(ee, function()
            for i = 1, #bp do
                result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY[bp[i]], bp[i], false)
                if not result then
                    if Config.verbose then
                        Warn(("[SetTempPermission] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(B_CATEGORY[bp[i]], bp[i],source,GetPlayerName(source),errorText))
                    end
                else
                    Debug(("[SetTempPermission] temporany Permission ^5\"%s.%s\"^0 was %s succesfully!\nPlayer changed: ^5[%s] %s^0"):format(B_CATEGORY[bp[i]], bp[i],"^1removed^0",source,GetPlayerName(source)))
                end
            end
        end)
        Debug(('Event ^5"%s"^0 registered to ^1disable^0 bypass ^5%s^0'):format(ee,json.encode(bp)))
    else
        if useBooleanArg then
            R_EVENTS[se] = AddEventHandler(se, function(bol)
                if not bol then return Error(se.. 'don\'t have a boolean argoument! Make sure it\'s configured correctly') end
                for i = 1, #bp do
                    result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY[bp[i]], bp[i], bol)
                    if not result then
                        if Config.verbose then
                            Warn(("[SetTempPermission] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(B_CATEGORY[bp[i]], bp[i],source,GetPlayerName(source),errorText))
                        end
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
                        if Config.verbose then
                            Warn(("[SetTempPermission] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(B_CATEGORY[bp[i]], bp[i],source,GetPlayerName(source),errorText))
                        end
                    else
                        Debug(("[SetTempPermission] temporany Permission ^5\"%s.%s\"^0 was %s succesfully!\nPlayer changed: ^5[%s] %s^0"):format(B_CATEGORY[bp[i]], bp[i],"^2granted^0",source,GetPlayerName(source)))
                    end
                end
                Citizen.SetTimeout(5000, function()
                    for i = 1, #bp do
                        result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY[bp[i]], bp[i], false)
                        if not result then
                            if Config.verbose then
                                Warn(("[SetTempPermission] Can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(B_CATEGORY[bp[i]], bp[i],source,GetPlayerName(source),errorText))
                            end
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

local SafeSetEntityCoords = function(bol, resName)
    if resName == CurrentResourceName then return end
    if not Resources[resName] then return Warn(("[^4%s^0] ^4%s^0 tried to get a BypassTeleport using the resource: %s"):format(source,GetPlayerName(source),resName)) end
    if Config.wrapNatives.SetEntityCoords then
        local result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY["BypassTeleport"], "BypassTeleport", bol, false)
        if not result then
            if Config.verbose then
                Warn(("The resource ^5%s^0 can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(resName,"Client","BypassTeleport",source,GetPlayerName(tostring(source)),errorText))
            end
        else
            Debug(("Temporany Permission ^5\"%s.%s\"^0 was %s succesfully by ^5\"%s\"^0!\nPlayer changed: ^5[%s] %s^0"):format(B_CATEGORY["BypassTeleport"],"BypassTeleport",bol == true and"^2granted^0" or "^1removed^0",resName,source,GetPlayerName(tostring(source))))
        end
    else
        Warn("Can't give/remove BypassTeleport since the option is disabled ")
    end
end

local SafeSetEntityVisible = function(bol, resName)
    if resName == CurrentResourceName then return end
    if not Resources[resName] then return Warn(("[^4%s^0] ^4%s^0 tried to get a BypassInvisible using the resource: %s"):format(source,GetPlayerName(source),resName)) end
    if Config.wrapNatives.SetEntityVisible then
        local result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY["BypassInvisible"], "BypassInvisible", bol, false)
        if not result then
            if Config.verbose then
                Warn(("The resource ^5%s^0  can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(resName,"Client","BypassInvisible",source,GetPlayerName(tostring(source)),errorText))
            end
        else
            Debug(("Temporany Permission ^5\"%s.%s\"^0 was %s succesfully by ^5\"%s\"^0!\nPlayer changed: ^5[%s] %s^0"):format("Client","BypassInvisible",bol == true and"^2granted^0" or "^1removed^0",resName,source,GetPlayerName(tostring(source))))
        end
    else
        Warn("Can't give/remove BypassInvisible since the option is disabled ")
    end
end

RegisterNetEvent("fg:addon:SetTempPermission:BypassVehicleFixAndGodMode", function (bol,resName)
    if resName == CurrentResourceName then return end
    if not Resources[resName] then return Warn(("[^4%s^0] ^4%s^0 tried to get a BypassVehicleFixAndGodMode using the resource: %s"):format(source,GetPlayerName(source),resName)) end
    if Config.wrapNatives.SetVehicleFixed then
        local result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY["BypassVehicleFixAndGodMode"], "BypassVehicleFixAndGodMode", bol, false)
        if not result then
            if Config.verbose then
                Warn(("The resource ^5%s^0 can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(resName,B_CATEGORY["BypassVehicleFixAndGodMode"],"BypassVehicleFixAndGodMode",source,GetPlayerName(tostring(source)),errorText))
            end
        else
            Debug(("Temporany Permission ^5\"%s.%s\"^0 was %s succesfully by ^5\"%s\"^0!\nPlayer changed: ^5[%s] %s^0"):format(B_CATEGORY["BypassVehicleFixAndGodMode"],"BypassVehicleFixAndGodMode",bol == true and"^2granted^0" or "^1removed^0",resName,source,GetPlayerName(tostring(source))))
        end
    else
        Warn("Can't give/remove BypassVehicleFixAndGodMode since the option is disabled ")
    end
end)

RegisterNetEvent("fg:addon:SetTempPermission:BypassTeleport", SafeSetEntityCoords)
RegisterNetEvent("fg:addon:SetTempPermission:BypassInvisible", SafeSetEntityVisible)

exports("SafeSetEntityCoords", SafeSetEntityCoords)
exports("SafeSetEntityVisible", SafeSetEntityVisible)

do
    for startEvent, value in pairs(Config.onServerTrigger) do
        if type(value) ~= "table" then return Error("Can't load bypasses config") end
        if not value.enable then goto continue end
        if value.endEvent == false then
            RegisterNetEvent(startEvent)
            setAutoBypass(startEvent, nil, value.bypass, false)
        elseif startEvent == value.endEvent then
            RegisterNetEvent(startEvent)
            setAutoBypass(startEvent, nil, value.bypass, true)
        else
            RegisterNetEvent(startEvent)
            RegisterNetEvent(value.endEvent)
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
    for _, value in pairs(R_EVENTS) do
        if value then
            RemoveEventHandler(value)
        end
    end
end)
