return {
    Debug = false,
    CheckUpdates = true, --RECOMMENDED Enable this to be notified when an update is available!

    -- prevent cheaters to stop client side of this resource
    Heartbeat = {
        enable = true,
        timeOut = 60, -- How long after the difference with os.time is the ban? (If not, in how many seconds is the ban (60 seconds is fine, 60 is fine for not false ban))
        ThreadTime = 5, -- Thread Time (5 seconds is fine)
        ban = true
    },

    -- prevent cheaters to take and launch vehicles
    AntiCarry = {
        enable = true,
        recordPlayer = true, --send a clip in your whebhook before player get banned
        webhookURL = "https://discord.com/api/webhooks/URL", -- Discord webhook URL (store recorded clips)
        recordTime = 1000, -- in seconds
        whitelistedZones = {
            -- { -- EXAMPLE
            --     coords = vector3(0, 0, 0),
            --     radius = 100.0
            -- },
            GetResourceState('rtx_themepark') ~= 'missing' and { --JUST A WHITELIST FOR A SPECIFIC SCRIPT
                coords = vector3(-1659.5439, -1102.4888, 13.1184),  -- RTX ThemePark (Beach ThemePark)
                radius = 150.0
            } or nil
        }
    },
    
    --Name Managament
    CheckNicknames = {
        enable = true,
        allowedCharacters = { -- Only people with these characters in their username will be able connect to server, set to false if u don't need this
            "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
            "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "=", "+", "[", "]", "{", "}", ";", ":", "'", "\"", ",", ".", "<", ">", "/", "?", "\\", "|", "`", "~", " "
        },
        maxNicknameLenght = 25 --Maximum lenght of palyer nicknames, set false to disable
    },
    --Fiveguard AntiStopper
    AntiStopper = {
        enable = true,
        checkInterval = 5 --interval in seconds
    },

    -- For set temp permissions in native
    ExportsNative = { --- /!\ BETA /!\ U CAN USE, IF YOU HAVE ERROR OR OTHER PROBLEM CONTACT: offsey
        enable = false,
        SetEntityCoords = true, -- Replace 'SetEntityCoords' in your script with 'exports["addon"]:FgSetEntityCoords'
        SetEntityVisible = true, -- Replace 'SetEntityVisible' in your script with 'exports["addon"]:FgSetEntityVisible'
    },

    -- Anti Vehicle Spawner | Crédit: Jona0081
    AntiSpawnVehicle = {
        enable = false,
        Ban = true, -- Ban (Just false = Delete vehicles)
        Kick = false, -- Kick (Just false = Delete vehicle)
        DetectNilResources = true, -- Can make false ban, disable if you have false ban
        DetectNPC = false, -- Can spawn client side event 
        DetectNetId = false, -- Can make false ban with script (like cardealer)
        DetectOwner = false, -- Can make false ban with script
        DetectResource = true, -- Just wl resource in ResourceWhitelisted
        MaxVehicleCheckDistance = 50,
        CheckInterval = 15,
        MaxRetries = 5,
        ResourceWhitelisted = {
            ["monitor"] = true,
            ["es_extended"] = GetResourceState('es_extended') ~= 'missing',
            ["qb-core"] = GetResourceState('qb-core') ~= 'missing',
        }
    },

    -- Anti GiveWeapon and others detection |For dist detection Credit: locutor404 (remake by offsey for addon)
    WeaponDetection = { 
        enable = true,
        AntiGiveWeapon = false, -- /!\ BETA | WORK WITH FRAMEWORK: ESX, QbCore (for moment) and works with inventory (no weapon wheel)
        AntiGiveWeaponBan = true, -- If false, the weapon will just be removed from the hands 
        DetectPunchDist = true, 
        MaxPunchDist = 10.0,
        DetectStunGunDist = true,
        MaxStunGunDist = 10.0,
        DetectExploitPunchDist = true,
        MaxExploitPunchDist = 10.0,
    },

    -- Anti Cheat Explosions Undetected | Crédit: Jona0081
    AntiExplosions = {
        enable = true,
        Ban = false,
    },

    --Enable this if u have rtx_themepark or rtx_themepark_dlc to prevent false bans, now it will detect automatically
    RTX_ThemePark_Bypass = {
        enable = GetResourceState('rtx_themepark') ~= 'missing' or GetResourceState('rtx_themepark_dlc') ~= 'missing'
    },

    -- Enable this if u have rcore_lunapark to prevent false bans, now it will detect automatically
    rcore_lunapark_Bypass = {
        enable = GetResourceState('rcore_lunapark') ~= 'missing'
    },

    --Enable this if u have rcore_clothing to prevent false bans, now it will detect automatically
    rcore_clothing_bypass = {
        enable = GetResourceState('rcore_clothing') ~= 'missing'
    },

    -- Check for a specified time if a player have a model, if true he will be banned/kicked
    BlacklistedModels = {
        enable = true,
        ban = true, --if false player is kicked
        checkInterval = 10, --in seconds
        blacklist = { -- a list of ped/animal models that player can't use
            "a_c_fish",
            'A_C_Boar',
            'A_C_Boar_02',
            'A_C_Cat_01',
            'A_C_Chickenhawk',
            'A_C_Chimp',
            'A_C_Chimp_02',
            'A_C_HumpBack',
        },
        EnableCrahingPrevent = true
    },

    -- !! DO NOT ENABLE MORE THAN 1 PERMISSION SYSTEM AT SAME TIME !!
    -- Bypass txAdmin admins
    txAdminPermissions = {
        enable = false,
        fgPermissions = { -- Permissions that'll be set if player has TxAdmin Access
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
    },

    -- Use framework permission to determinate when add or remove fg perms
    FrameworkPermissions = {
        enable = false,
        customFramework = {
            enable = false, -- enable this only if u have a custom settings and u know what u are doing
            customEvent = '', -- name of the events that's triggered when a player get/lose a group
            invokerResource = '', -- name of the resource that's triggers the event (security check)
        },
        groups = {
            ['god'] = {
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
            ['admin'] = {
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
            ['mod'] = {
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
            ['helper'] = {
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
    },

    -- Use ACE Permissions from FiveM natives
    AcePermissions = {
        enable = false, -- Group Ace Permissions // ONLY ESX FOR THE MOMENT (Soon QbCore & vRP)
        groups = {      -- define wich perms you want to add for a specific group
            ['admin'] = {
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
            ['mod'] = {
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
            ['helper'] = {
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
    }
}
