Config = {}
Config.ResourceName = "fiveguard" -- resource name

-- ANTI CARRY
Config.AntiCarry = true -- Activate AntiCarry or not ?
Config.RecordPlayer = true -- Record ? true = yes / false = no | FOR ANTI CARRY
Config.WebhookURL = "https://discord.com/api/webhooks/URL" -- | Not useful if "Config.RecordPlayer" is false| FOR ANTI CARRY
Config.RecordTime = 1000 -- 2000 = 2 Seconde (The player will be banned after 2 seconds) | Not useful if "Config.RecordPlayer" is false| FOR ANTI CARRY
Config.WlZone = { -- | FOR ANTI CARRY
    {coords = vector3(-1659.5439, -1102.4888, 13.1184), radius = 150.0}, -- Rtx ThemePark (Beach ThemePark)
    -- {coords = vector3(-1659.5439, -1102.4888, 33.1184), radius = 150.0}, -- Rtx ThemePark (Beach ThemePark) etc...
}

-- ANTI STOP
Config.AntiStopper = true
Config.CheckInterval = 10  -- | FOR ANTI STOP

-- RTX DEV
Config.ThemeParkRTX = true -- For remove false ban

-- TxAdmin Permissions
Config.TxAdminBypass = true -- Bypass all people on TxAdmin (Admin User)
Config.PermissionsTxAdmin = { -- Permissions that'll be set if player has TxAdmin Access
    --[[ AdminMenu ]]  --
    "AdminMenuAccess",
    "AnnouncementAccess",
    "ESPAccess",
    "ClearEntitiesAccess",
    "BanAndKickAccess",
    "GotoAndBringAccess",
    "VehicleAccess",
    "MiscAccess",
    "LogsAccess",
    "PlayerSelectorAccess",
    "BanListAndUnbanAccess",
    "ModelChangerAccess",
    --[[ Client ]] --
    "BypassSpectate",
    "BypassGodMode",
    "BypassInvisible",
    "BypassStealOutfit",
    "BypassInfStamina",
    "BypassNoclip",
    "BypassSuperJump",
    "BypassFreecam",
    "BypassSpeedHack",
    "BypassTeleport",
    "BypassNightVision",
    "BypassThermalVision",
    "BypassOCR",
    "BypassNuiDevtools",
    "BypassBlacklistedTextures",
    "BlipsBypass",
    "BypassCbScanner",
    --[[ Weapon ]] --
    "BypassWeaponDmgModifier",
    "BypassInfAmmo",
    "BypassNoReload",
    "BypassRapidFire",
    --[[ Vehicle ]] --
    "BypassVehicleFixAndGodMode",
    "BypassVehicleHandlingEdit",
    "BypassVehicleModifier",
    "BypassBulletproofTires",
    --[[ Blacklist ]] --
    "BypassModelChanger",
    "BypassWeaponBlacklist",
    --[[ Misc ]] --
    "FGCommands",
    "BypassVPN",
    "BypassExplosion",
    "BypassClearTasks",
    "BypassParticle"
}


-- Custom Permissions
Config.UseAcePermissions = true -- Group Ace Permissions // ONLY ESX FOR THE MOMENT (Soon QbCore & vRP)
Config.UserGroup = "user"
Config.PermissionsCustom = {
    fondateur = {
        --[[ AdminMenu ]] --
        "AdminMenuAccess",
        "AnnouncementAccess",
        "ESPAccess",
        "ClearEntitiesAccess",
        "BanAndKickAccess",
        "GotoAndBringAccess",
        "VehicleAccess",
        "MiscAccess",
        "LogsAccess",
        "PlayerSelectorAccess",
        "BanListAndUnbanAccess",
        "ModelChangerAccess",
        --[[ Client ]] --
        "BypassSpectate",
        "BypassGodMode",
        "BypassInvisible",
        "BypassStealOutfit",
        "BypassInfStamina",
        "BypassNoclip",
        "BypassSuperJump",
        "BypassFreecam",
        "BypassSpeedHack",
        "BypassTeleport",
        "BypassNightVision",
        "BypassThermalVision",
        "BypassOCR",
        "BypassNuiDevtools",
        "BypassBlacklistedTextures",
        "BlipsBypass",
        "BypassCbScanner",
        --[[ Weapon ]] --
        "BypassWeaponDmgModifier",
        "BypassInfAmmo",
        "BypassNoReload",
        "BypassRapidFire",
        --[[ Vehicle ]] --
        "BypassVehicleFixAndGodMode",
        "BypassVehicleHandlingEdit",
        "BypassVehicleModifier",
        "BypassBulletproofTires",
        --[[ Blacklist ]] --
        "BypassModelChanger",
        "BypassWeaponBlacklist",
        --[[ Misc ]] --
        "FGCommands",
        "BypassVPN",
        "BypassExplosion",
        "BypassClearTasks",
        "BypassParticle"
    },
    responsable = {
        --[[ Client ]] --
        "BypassSpectate",
        "BypassGodMode",
        "BypassInvisible",
        "BypassStealOutfit",
        "BypassInfStamina",
        "BypassNoclip",
        "BypassSuperJump",
        "BypassFreecam",
        "BypassSpeedHack",
        "BypassTeleport",
        "BypassNightVision",
        "BypassThermalVision",
        "BypassOCR",
        "BypassNuiDevtools",
        "BypassBlacklistedTextures",
        "BlipsBypass",
        "BypassCbScanner",
        --[[ Weapon ]] --
        "BypassWeaponDmgModifier",
        "BypassInfAmmo",
        "BypassNoReload",
        "BypassRapidFire",
        --[[ Vehicle ]] --
        "BypassVehicleFixAndGodMode",
        "BypassVehicleHandlingEdit",
        "BypassVehicleModifier",
        "BypassBulletproofTires",
        --[[ Blacklist ]] --
        "BypassModelChanger",
        "BypassWeaponBlacklist",
        --[[ Misc ]] --
        "FGCommands",
        "BypassVPN",
        "BypassExplosion",
        "BypassClearTasks",
        "BypassParticle"
    },
    admin = {
        --[[ Client ]] --
        "BypassSpectate",
        "BypassGodMode",
        "BypassInvisible",
        "BypassStealOutfit",
        "BypassInfStamina",
        "BypassNoclip",
        "BypassSuperJump",
        "BypassFreecam",
        "BypassSpeedHack",
        "BypassTeleport",
        "BypassNightVision",
        "BypassThermalVision",
        "BypassOCR",
        "BypassNuiDevtools",
        "BypassBlacklistedTextures",
        "BlipsBypass",
        "BypassCbScanner",
        --[[ Weapon ]] --
        "BypassWeaponDmgModifier",
        "BypassInfAmmo",
        "BypassNoReload",
        "BypassRapidFire",
        --[[ Vehicle ]] --
        "BypassVehicleFixAndGodMode",
        "BypassVehicleHandlingEdit",
        "BypassVehicleModifier",
        "BypassBulletproofTires",
        --[[ Blacklist ]] --
        "BypassModelChanger",
        "BypassWeaponBlacklist",
        --[[ Misc ]] --
        "FGCommands",
        "BypassVPN",
        "BypassExplosion",
        "BypassClearTasks",
        "BypassParticle"
    },
    modo = {
        --[[ Client ]] --
        "BypassSpectate",
        "BypassGodMode",
        "BypassInvisible",
        "BypassStealOutfit",
        "BypassInfStamina",
        "BypassNoclip",
        "BypassSuperJump",
        "BypassFreecam",
        "BypassSpeedHack",
        "BypassTeleport",
        "BypassNightVision",
        "BypassThermalVision",
        "BypassOCR",
        "BypassNuiDevtools",
        "BypassBlacklistedTextures",
        "BlipsBypass",
        "BypassCbScanner",
        --[[ Weapon ]] --
        "BypassWeaponDmgModifier",
        "BypassInfAmmo",
        "BypassNoReload",
        "BypassRapidFire",
        --[[ Vehicle ]] --
        "BypassVehicleFixAndGodMode",
        "BypassVehicleHandlingEdit",
        "BypassVehicleModifier",
        "BypassBulletproofTires",
        --[[ Blacklist ]] --
        "BypassModelChanger",
        "BypassWeaponBlacklist",
        --[[ Misc ]] --
        "BypassVPN",
        "BypassExplosion",
        "BypassClearTasks",
        "BypassParticle"
    },
    helper = {
        --[[ Client ]] --
        "BypassSpectate",
        "BypassGodMode",
        "BypassInvisible",
        "BypassStealOutfit",
        "BypassInfStamina",
        "BypassNoclip",
        "BypassSuperJump",
        "BypassFreecam",
        "BypassSpeedHack",
        "BypassTeleport",
        "BypassNightVision",
        "BypassThermalVision",
        "BypassOCR",
        "BypassNuiDevtools",
        "BypassBlacklistedTextures",
        "BlipsBypass",
        "BypassCbScanner",
        --[[ Vehicle ]] --
        "BypassVehicleFixAndGodMode",
        "BypassVehicleHandlingEdit",
        "BypassVehicleModifier",
        "BypassBulletproofTires",
        --[[ Misc ]] --
        "BypassVPN",
        "BypassExplosion",
        "BypassClearTasks",
        "BypassParticle"
    },
}