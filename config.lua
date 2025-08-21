return {
    Debug = true,
    CheckUpdates = false, --RECOMMENDED Enable this to be notified when an update is available!
    -- custom storage for video or images, if not configured will be used the default screenshot webhook url on your fiveguard config
    CustomWebhookURL = "https://discord.com/api/webhooks/URL", -- Discord webhook URL to store video or images
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
        banMedia = "video", -- ("video" or "image" or false) | send a defined media in your whebhook before player get banned
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
    -- Allows players to get a bypass directly by native execution
    ExportsNative = {
        enable = true,
        SetEntityCoords = true, -- It enable also 'exports["addon"]:SafeSetEntityCoords' if needed
        SetEntityVisible = true -- It enable also 'exports["addon"]:SafeSetEntityVisible' if needed
    },

    AntiPedManipulation = {
        enable = not GetConvarBool("onesync_population", true),
        maxBucketUsed = 15000,
        ban = true
    },

    AntiSafeSpawn = {
        enable = true,
        whitelistedZones = { -- Add here all the coords of where vehicle gets spawned with "EntityCreation" (e.g. cardealer showroom) to avoid false vehicle deletion
            { coords =  vec3(-47.500000, -1097.199951, 25.400000), radius = 2.0 }
        }
    },

    -- Anti Vehicle Spawner | Crédit: Jona0081
    AntiSpawnVehicle = {
        enable = true,
        ban = true, -- Ban (false = delete vehicle only)
        banMedia = "image",
        detectNPC = false,              -- Can spawn client side event 
        preventInvalidOwner = false,    -- !!Can make false ban
        preventNilResources = false,    -- !!Can make false ban
        preventUnNetworkedEnity = false,-- !!Can make false ban
        preventUnauthorizedResource = true, -- Just wl resource in ResourceWhitelisted
        maxVehicleCheckDistance = 50,
        checkInterval = 5,
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
            ["qb-garages"] = GetResourceState('qb-garages') ~= 'missing'
        }
    },
    -- Anti GiveWeapon and others detection |For dist detection Credit: locutor404 (remake by offsey for addon)
    WeaponProtection = {
        enable = true,
        AntiGiveWeapon = {
            enable = true,
            relaxed = false,-- determinate if check every shot or no
            ban = true,     -- (false = weapon removed only)
            banMedia = "image"
        },
        AntiDistanceDamage = {
            punch = {
                enable = true,
                maxDistance = 16
            },
            stungun = {
                enable = true,
                maxDistance = 13
            }
        }
    },
    -- Anti Cheat Explosions Undetected | Crédit: Jona0081
    AntiExplosions = {
        enable = true,
        ban = true, -- (false = kick)
        banMedia = "image"
    },

    Bypasses = {
        enable = true, -- master switch
        onClientTrigger = {
            ["jg-advancedgarages:client:open-garage"] = {
                endEvent = "jg-advancedgarages:client:store-vehicle",
                bypass = "BypassVehicleModifier"
            },
            ["jg-dealerships:client:open-showroom"] = {
                endEvent = "__ox_cb_jg-dealerships:server:exit-showroom",
                bypass = { "BypassInvisible", "BypassTeleport", "BypassVehicleModifier" }
            },
            ["rcore_clothing:onClothingShopOpened"] = {
                endEvent = "rcore_clothing:onClothingShopClosed",
                bypass = "BypassStealOutfit"
            }
        },

        onServerTrigger = {
            ["lsrp_lunapark:Freefall:attachPlayer"] = {
                endEvent = "lsrp_lunapark:Freefall:detachPlayer",
                bypass = "BypassNoclip",
            },
            ["lsrp_lunapark:RollerCoaster:attachPlayer"] = {
                endEvent = "lsrp_lunapark:RollerCoaster:detachPlayer",
                bypass = "BypassNoclip"
            },
            ["lsrp_lunapark:Wheel:attachPlayer"] = {
                endEvent = "lsrp_lunapark:Wheel:detachPlayer",
                bypass = "BypassNoclip",
            },
            ["rcore_prison:server:prologStarted"] = {
                endEvent = "rcore_prison:server:prologFinished",
                bypass = "BypassStealOutfit"
            },
            ["rtx_themepark:Global:UsingAttractionPlayer"] = {
                endEvent = "rtx_themepark:Global:UsingAttractionPlayer",
                bypass = { "BypassNoclip", "BypassSpoofedWeapons", "BypassBulletproofTires" }
            },
            ["wasabi_police:sendToJail"] = {
                endEvent = false,
                bypass = "BypassTeleport"
            }
        }
    },
    -- Check for a specified time if a player have a model, if true he will be banned/kicked
    BlacklistedModels = {
        enable = true,
        ban = true, -- (false = kick)
        banMedia = "image",
        checkInterval = 10, --in seconds
        blacklist = { -- a list of ped/animal models that player can't use
            "a_c_fish",
            'A_C_Boar',
            'A_C_Boar_02',
            'A_C_Cat_01',
            'A_C_Chickenhawk',
            'A_C_Chimp',
            'A_C_Chimp_02',
            'A_C_HumpBack'
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
                invokerResource = '' -- name of the resource that's triggers the event (security check)
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
                }
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
                }
            }
        }
    }
}
