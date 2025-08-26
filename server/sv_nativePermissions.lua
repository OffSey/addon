local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.ExportsNative
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end
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

RegisterNetEvent("fg:addon:SetTempPermission:BypassTeleport", function(bol,resName)
    if resName == CurrentResourceName then return end
    if not Resources[resName] then return Warn(("%s tried to get a bypass"):format(source)) end
    if Config.SetEntityCoords then
        local result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY["BypassTeleport"], "BypassTeleport", bol, false)
        if not result then
            Warn(("^0The resource ^5\"%s\"^0 can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(resName,"Client","BypassTeleport",source,GetPlayerName(tostring(source)),errorText))
        else
            Debug(("Temporany Permission ^5\"%s.%s\"^0 was %s succesfully by ^5\"%s\"^0!\nPlayer changed: ^5[%s] %s^0"):format(B_CATEGORY["BypassTeleport"],"BypassTeleport",bol == true and"^2granted^0" or "^1removed^0",resName,source,GetPlayerName(tostring(source))))
        end
    else
        Warn("Can't give/remove BypassTeleport since the option is disabled ")
    end
end)

RegisterNetEvent("fg:addon:SetTempPermission:BypassInvisible", function(bol,resName)
    if resName == CurrentResourceName then return end
    if not Resources[resName] then return Warn(("%s tried to get a bypass"):format(source)) end
    if Config.SetEntityVisible then
        local result, errorText = exports[Fiveguard]:SetTempPermission(source, B_CATEGORY["BypassInvisible"], "BypassInvisible", bol, false)
        if not result then
            Warn(("^0The resource ^5\"%s\"^0  can't give temporany permission!\nPermission: ^5\"%s.%s\"^0\nPlayer: ^5[%s] %s^0\nReason: ^5%s^0"):format(resName,"Client","BypassInvisible",source,GetPlayerName(tostring(source)),errorText))
        else
            Debug(("Temporany Permission ^5\"%s.%s\"^0 was %s succesfully by ^5\"%s\"^0!\nPlayer changed: ^5[%s] %s^0"):format("Client","BypassInvisible",bol == true and"^2granted^0" or "^1removed^0",resName,source,GetPlayerName(tostring(source))))
        end
    else
        Warn("Can't give/remove BypassInvisible since the option is disabled ")
    end
end)
