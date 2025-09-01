return {
    Debug = false,
    CheckUpdates = true, -- RECOMMENDED Enable this to be notified when an update is available!
    -- custom storage for video or images, if not configured will be used the default screenshot webhook url on your fiveguard config
    CustomWebhookURL = "https://discord.com/api/webhooks/URL", -- Discord webhook URL to store video or images
    RecordTime = 5, -- in seconds
    -- prevent cheaters to stop client side of this resource
    Heartbeat = {
        enable = true,
        timeOut = 45,    -- Timeout (seconds) after which a player is considered missing
        threadTime = 5,  -- Interval between heartbeats (seconds)
        graceMisses = 3, -- How many consecutive misses are tolerated before punishment
        jitter = 0.20,   -- Jitter percentage for heartbeat interval
        ban = true       -- If false player will be kicked
    },
    -- prevent cheaters to take and launch vehicles
    AntiThrow = {
        enable = true,
        ban = true,         -- If false player will be kicked
        banMedia = "image", -- "video" or "video" or "false"
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

    CheckNicknames = {
        enable = false,
        minNicknameLength = 3,  -- Minimum lenght of palyer nicknames, set false to disable
        maxNicknameLength = 25, -- Maximum lenght of palyer nicknames, set false to disable
        allowedPattern = "^[A-Za-z0-9_.%-%s]+$" -- Allowed characters, set false to disable
    },
    -- Detect if someone try to stop fiveguard
    AntiStopper = {
        enable = true,
        ban = true,         -- If false player will be kicked
        checkInterval = 5   -- interval in seconds
    },

    AntiPedManipulation = { -- Credit: @somis12
        enable = not GetConvarBool("onesync_population", true),
        maxBucketUsed = 15000,
        ban = true -- If false player will be kicked
    },

    VehicleProtection = { -- Credit: @jona0081 for some detections included here
        enable = true,
        ban = true,         -- Ban (false = delete vehicle only)
        banMedia = "image", -- "image" or "video" or "false"
        detectNPC = false,  -- Can spawn client side event 
        cleanNotOwnedVehicles = false,
        preventSafeSpawn = {
            enable = true,
            whitelistedCoords = {
                { coords = vec3(-47.500000, -1097.199951, 25.400000), radius = 2.0 }
            },
        },
        preventLaunchPlayer = false,    -- !!Can make false ban
        preventGlitchVehicle = true,
        preventInvalidOwner = false,    -- !!Can make false ban
        preventNilResources = false,    -- !!Can make false ban
        preventUnNetworkedEnity = false,-- !!Can make false ban
        maxVehicleCheckDistance = 50,
        checkInterval = 5,
        maxRetries = 5,
        preventUnauthorizedResource = {
            enable = false, -- If enabled, whitelist your resources below
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
    },

    WeaponProtection = {
        enable = true,
        AntiGiveWeapon = { -- Credit: @locutor404 & @somis12
            enable = true,
            relaxed = false,    -- determinate if check every shot or no
            ban = true,         -- (false = weapon removed only)
            banMedia = "image"  -- "image" or "video" or "false"
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
        },
        AntiGiveWeaponToPed = {
            enable = true,
            ban = true
        },
        AntiRemoveWeaponFromPed = {
            enable = true,
            ban = true
        }
    },

    AntiExplosions = { -- Crédit: @jona0081
        enable = true,
        preventExplosions = true,
        preventSafeExplosions = false,
        preventUnnetworkedExplosions = true,
        ban = true, -- If false player will be kicked
        banMedia = "image" -- "image" or "video" or "false"
    },

    BlacklistedModels = {
        enable = true,
        ban = true,-- If false player will be kicked
        banMedia = "image", -- "image" or "video" or "false"
        checkInterval = 10, --in seconds
        blacklist = { -- a list of ped/animal models that player can't use
            [GetHashKey("a_c_fish")] = true,
            [GetHashKey('a_c_boar')] = true,
            [GetHashKey('a_c_boar_02')] = true,
            [GetHashKey('a_c_cat_01')] = true,
            [GetHashKey('a_c_chickenhawk')] = true,
            [GetHashKey('a_c_chimp')] = true,
            [GetHashKey('a_c_chimp_02')] = true,
            [GetHashKey('a_c_chop')] = true,
            [GetHashKey('a_c_cormorant')] = true,
            [GetHashKey('a_c_cow')] = true,
            [GetHashKey('a_c_coyote')] = true,
            [GetHashKey('a_c_crow')] = true,
            [GetHashKey('a_c_deer')] = true,
            [GetHashKey('a_c_dolphin')] = true,
            [GetHashKey('a_c_hen')] = true,
            [GetHashKey('a_c_humpback')] = true,
            [GetHashKey('a_c_husky')] = true,
            [GetHashKey('a_c_killerwhale')] = true,
            [GetHashKey('a_c_mtlion')] = true,
            [GetHashKey('a_c_pig')] = true,
            [GetHashKey('a_c_pigeon')] = true,
            [GetHashKey('a_c_poodle')] = true,
            [GetHashKey('a_c_pug')] = true,
            [GetHashKey('a_c_rabbit_01')] = true,
            [GetHashKey('a_c_rat')] = true,
            [GetHashKey('a_c_retriever')] = true,
            [GetHashKey('a_c_rhesus')] = true,
            [GetHashKey('a_c_rottweiler')] = true,
            [GetHashKey('a_c_rottweiler_02')] = true,
            [GetHashKey('a_c_sharkhammer')] = true,
            [GetHashKey('a_c_sharktiger')] = true,
            [GetHashKey('a_c_shepherd')] = true,
            [GetHashKey('a_c_stingray')] = true,
            [GetHashKey('a_c_westy')] = true
        },
        enableCrahingPrevent = true
    },

    Bypasses = {
        enable = true, -- master switch
        onClientTrigger = {
            --[[ ["put:here:the:event:to:get:bypass"] = {
                enable = true or false,

                --if the event is different:
                endEvent = "put:here:the:event:to:remove:bypass",
                --if the event is the same (first arg must be boolean):
                endEvent = "put:here:the:event:to:get:bypass",
                --if there's no END event (it will bypass for 5 seconds):
                endEvent = false,
                
                bypass = "bypassName" or {"bypass","names"}
            }, ]]
            ["jg-advancedgarages:client:open-garage"] = {
                enable = GetResourceState("jg-advancedgarages") ~= "missing",
                endEvent = "jg-advancedgarages:client:store-vehicle",
                bypass = "BypassVehicleModifier"
            },
            ["jg-dealerships:client:open-showroom"] = {
                enable = GetResourceState("jg-dealerships") ~= "missing",
                endEvent = "__ox_cb_jg-dealerships:server:exit-showroom",
                bypass = { "BypassInvisible", "BypassTeleport", "BypassVehicleModifier" }
            },
            ["rcore_clothing:onClothingShopOpened"] = {
                enable = GetResourceState("rcore_clothing") ~= "missing",
                endEvent = "rcore_clothing:onClothingShopClosed",
                bypass = "BypassStealOutfit"
            },
            ["ik-jobgarage:openUI"] = {
                enable = GetResourceState("ik-jobgarage") ~= "missing",
                endEvent = "ik-jobgarage:server:SaveCarData",
                bypass = "BypassInvisible"
            },
            ["prison:client:Enter"] = {
                enable = GetResourceState("qb-prison") ~= "missing",
                endEvent = false,
                bypass = "BypassTeleport"
            },
            ["prison:client:UnjailPerson"] = {
                enable = GetResourceState("qb-prison") ~= "missing",
                endEvent = false,
                bypass = "BypassTeleport"
            },
            ["prison:client:Leave"] = {
                enable = GetResourceState("qb-prison") ~= "missing",
                endEvent = false,
                bypass = "BypassTeleport"
            }
        },

        onServerTrigger = {
            --[[ ["put:here:the:event:to:get:bypass"] = {
                enable = true or false,

                --if the event is different:
                endEvent = "put:here:the:event:to:remove:bypass",
                --if the event is the same (first arg must be boolean):
                endEvent = "put:here:the:event:to:get:bypass",
                --if there's no END event (it will bypass for 5 seconds):
                endEvent = false,
                
                bypass = "bypassName" or {"bypass","names"}
            }, ]]
            ["lsrp_lunapark:Freefall:attachPlayer"] = {
                enable = GetResourceState("lsrp_lunapark") ~= "missing",
                endEvent = "lsrp_lunapark:Freefall:detachPlayer",
                bypass = "BypassNoclip",
            },
            ["lsrp_lunapark:RollerCoaster:attachPlayer"] = {
                enable = GetResourceState("lsrp_lunapark") ~= "missing",
                endEvent = "lsrp_lunapark:RollerCoaster:detachPlayer",
                bypass = "BypassNoclip"
            },
            ["lsrp_lunapark:Wheel:attachPlayer"] = {
                enable = GetResourceState("v") ~= "missing",
                endEvent = "lsrp_lunapark:Wheel:detachPlayer",
                bypass = "BypassNoclip",
            },
            ["rcore_prison:server:prologStarted"] = {
                enable = GetResourceState("rcore_prison") ~= "missing",
                endEvent = "rcore_prison:server:prologFinished",
                bypass = "BypassStealOutfit"
            },
            ["rtx_themepark:Global:UsingAttractionPlayer"] = {
                enable = GetResourceState("rtx_themepark") ~= "missing",
                endEvent = "rtx_themepark:Global:UsingAttractionPlayer",
                bypass = { "BypassNoclip", "BypassSpoofedWeapons", "BypassBulletproofTires" }
            },
            ["wasabi_police:sendToJail"] = {
                enable = GetResourceState("wasabi_police") ~= "missing",
                endEvent = false,
                bypass = "BypassTeleport"
            }
        }
    },
    -- Allows players to get a bypass directly by native execution on installed resources
    EasyTempBypass = {
        enable = true,

        -- It enable  exports["addon"]:SafeSetEntityCoords(true or false, GetCurrentResourceName())
                    --exports["anticheat-name"]:ExecuteServerEvent("fg:addon:SetTempPermission:BypassTeleport",true or false, GetCurrentResourceName())
        SetEntityCoords = true,
        -- It enable  exports["addon"]:SafeSetEntityCoords(true or false, GetCurrentResourceName())
                    --exports["anticheat-name"]:ExecuteServerEvent("fg:addon:SetTempPermission:BypassInvisible",true or false, GetCurrentResourceName())
        SetEntityVisible = true
    },

    EasyPermissions = {
        enable = false, -- MASTER SWITCH
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
            enable = true,
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
                }
            }
        }
    }
}
