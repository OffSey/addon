return {
    Debug = true,
    CheckUpdates = false, --RECOMMENDED Enable this to be notified when an update is available!
    -- Record clip before banning settings
    CustomWebhookURL = "https://discord.com/api/webhooks/URL", -- Discord webhook URL to ban with a videoclip (store recorded clips)
    RecordTime = 5, -- in seconds

    -- prevent cheaters to stop client side of this resource
    Heartbeat = {
        enable = true,
        timeOut = 60, -- How long after the difference with os.time is the ban? (If not, in how many seconds is the ban (60 seconds is fine, 60 is fine for not false ban))
        threadTime = 5, -- Thread Time (5 seconds is fine)
        ban = true -- If false player will kicked insted
    },

    -- prevent cheaters to take and launch vehicles
    AntiCarry = {
        enable = true,
        ban = true,
        recordPlayer = true, -- send a clip in your whebhook before player get banned
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
        maxNicknameLenght = 25 -- Maximum lenght of palyer nicknames, set false to disable
    },
    --Fiveguard AntiStopper
    AntiStopper = {
        enable = true,
        ban = true,
        checkInterval = 5 --interval in seconds
    },

    -- For set temp permissions in native
    ExportsNative = { --- /!\ BETA /!\ U CAN USE, IF YOU HAVE ERROR OR OTHER PROBLEM CONTACT: offsey
        enable = true,
        SetEntityCoords = true, -- Replace 'SetEntityCoords' in your script with 'exports["addon"]:FgSetEntityCoords'
        SetEntityVisible = true, -- Replace 'SetEntityVisible' in your script with 'exports["addon"]:FgSetEntityVisible'
    },

    AntiPedManipulation = {
        enable = not GetConvarBool("onesync_population", true),
        maxBucketUsed = 15000,
        ban = true
    },

    AntiSafeSpawn = {
        enable = true,
        whitelistedZones = {
            { coords =  vec3(-47.500000, -1097.199951, 25.400000), radius = 20.0 },   -- dealership preview
            { coords = vector3(100.0, 100.0, 100.0), radius = 5.0 },    -- rent vehicle preview
        },
    },
    -- Anti Vehicle Spawner | Crédit: Jona0081
    AntiSpawnVehicle = {
        enable = true,
        ban = true, -- Ban (Just false = Delete vehicles)
        recordPlayer = true,
        detectNilResources = true, -- Can make false ban, disable if you have false ban
        detectNPC = false, -- Can spawn client side event 
        preventUnnetworkedEnity = true, -- Can make false ban with script (like cardealer)
        detectOwner = false, -- Can make false ban with script
        detectResource = true, -- Just wl resource in ResourceWhitelisted
        maxVehicleCheckDistance = 50,
        checkInterval = 15,
        maxRetries = 5,
        resourceWhitelisted = {
            ["monitor"] = true,
            ["es_extended"] = GetResourceState('es_extended') ~= 'missing',
            ["qbx_core"] = GetResourceState('qbx_core') ~= 'missing',
            ["qb-core"] = GetResourceState('qb-core') ~= 'missing',
            ["ox_lib"] = GetResourceState('ox_lib') ~= 'missing',
            ["esx_vehicleshop"] = GetResourceState('esx_vehicleshop') ~= 'missing',
            ["esx_garages"] = GetResourceState('esx_garages') ~= 'missing',
            ["qb-vehicleshop"] = GetResourceState('qb-vehicleshop') ~= 'missing',
            ["qb-garages"] = GetResourceState('qb-garages') ~= 'missing',
        }
    },

    -- Anti GiveWeapon and others detection |For dist detection Credit: locutor404 (remake by offsey for addon)
    WeaponProtection = {
        enable = true,
        AntiGiveWeapon = { -- /!\ BETA | WORK WITH FRAMEWORK: ESX, QbCore (for moment) and works with inventory (no weapon wheel)
            enable = true,
            relaxed = false,-- determinate if check every shot or no
            ban = true,-- If false, the weapon will just be removed from the hands 
            recordPlayer = true,
        },
        detectPunchDist_1 = true, -- if enabled detect and ban
        detectPunchDist_2 = true, -- if enabled detect and ban
        maxPunchDist = 16.0,
        detectStunGunDist = true, -- if enabled detect and ban
        maxStunGunDist = 13.0
    },

    -- Anti Cheat Explosions Undetected | Crédit: Jona0081
    AntiExplosions = {
        enable = true,
        ban = true,
        recordPlayer = true,
    },

    Bypasses = {
        enable = true, -- master switch
        onClientTrigger = {
            ["jg-advancedgarages:client:open-garage"] = {
                endEvent = "jg-advancedgarages:client:store-vehicle",
                bypass = "BypassVehicleModifier"
            } and GetResourceState('jg-advancedgarages') ~= 'missing' or nil,
            ["jg-dealerships:client:open-showroom"] = {
                endEvent = "__ox_cb_jg-dealerships:server:exit-showroom",
                bypass = { "BypassInvisible", "BypassTeleport", "BypassVehicleModifier" }
            } and GetResourceState('jg-dealerships') ~= 'missing' or nil,
            ["rcore_clothing:onClothingShopOpened"] = {
                endEvent = "rcore_clothing:onClothingShopClosed",
                bypass = "BypassStealOutfit"
            } and GetResourceState('rcore_clothing') ~= 'missing' or nil,
        },

        onServerTrigger = {
            ["lsrp_lunapark:Freefall:attachPlayer"] = {
                endEvent = "lsrp_lunapark:Freefall:detachPlayer",
                bypass = "BypassNoclip",
            } and GetResourceState('rcore_lunapark') ~= 'missing' or nil,
            ["lsrp_lunapark:RollerCoaster:attachPlayer"] = {
                endEvent = "lsrp_lunapark:RollerCoaster:detachPlayer",
                bypass = "BypassNoclip"
            } and GetResourceState('rcore_lunapark') ~= 'missing' or nil,
            ["lsrp_lunapark:Wheel:attachPlayer"] = {
                endEvent = "lsrp_lunapark:Wheel:detachPlayer",
                bypass = "BypassNoclip",
            } and GetResourceState('rcore_lunapark') ~= 'missing' or nil,
            ["rcore_prison:server:prologStarted"] = {
                endEvent = "rcore_prison:server:prologFinished",
                bypass = "BypassStealOutfit"
            } and GetResourceState('rcore_prison') ~= 'missing' or nil,
            ["rtx_themepark:Global:UsingAttractionPlayer"] = {
                endEvent = "rtx_themepark:Global:UsingAttractionPlayer",
                bypass = { "BypassNoclip", "BypassSpoofedWeapons", "BypassBulletproofTires" }
            } and (GetResourceState('rtx_themepark') ~= 'missing' or GetResourceState('rtx_themepark_dlc') ~= 'missing') or nil,
            ["wasabi_police:sendToJail"] = {
                endEvent = false,
                bypass = "BypassTeleport"
            } and GetResourceState('wasabi_police') ~= 'missing' or nil,
        }
    },

    -- Check for a specified time if a player have a model, if true he will be banned/kicked
    BlacklistedModels = {
        enable = true,
        ban = true, --if false player is kicked
        recordPlayer = true,
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
        enableCrahingPrevent = true
    },

    EasyPermissions = {
        enable = true, -- MASTER SWITCH
        -- !! DO NOT ENABLE MORE THAN 1 PERMISSION SYSTEM BELOW AT SAME TIME! Default is ACE

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
            enable = true, -- Group Ace Permissions // ONLY ESX FOR THE MOMENT (Soon QbCore & vRP)
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
    },
}
