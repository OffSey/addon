local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.WeaponProtection
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

---@param sender string
---@param ev table
---@param expectedHash number
---@param maxDist number
---@param reason string
---@param extraCond fun(ev: table): boolean
local function CheckWeaponDistance(sender, ev, expectedHash, maxDist, reason, extraCond)
    local weaponHash = tonumber(ev.weaponType)
    if not weaponHash or weaponHash ~= expectedHash then return end
    if extraCond and not extraCond(ev) then return end

    local maxDist2 = maxDist*maxDist
    local attackerPed = GetPlayerPed(sender)
    if attackerPed == 0 then return end

    local attackerCoords = GetEntityCoords(attackerPed)
    local victims = ev.hitGlobalIds or { ev.hitGlobalId }

    for _, netId in ipairs(victims) do
        if netId and netId ~= 0 then
            local victimEnt = NetworkGetEntityFromNetworkId(netId)
            local victimCoords = GetEntityCoords(victimEnt)
            if DoesEntityExist(victimEnt) then
                if Vdist2(attackerCoords.x,attackerCoords.y,attackerCoords.z, victimCoords.x,victimCoords.y,victimCoords.z) > maxDist2 then
                    BanPlayer(sender, reason, false)
                end
            end
        end
    end
end

if Config.detectPunchDist_1 then
    AddEventHandler("weaponDamageEvent", function(sender, ev)
        ---@diagnostic disable-next-line: missing-parameter
        CheckWeaponDistance(sender, ev, 2725352035, Config.maxPunchDist, "Punch Distance Exceeded (1)")
    end)
end

if Config.detectPunchDist_2 then
    AddEventHandler("weaponDamageEvent", function(sender, ev)
        CheckWeaponDistance(sender, ev, 2725352035, Config.maxPunchDist, "Punch Distance Exceeded (2)", function(r)
            return r.weaponDamage == 0
        end)
    end)
end

if Config.detectStunGunDist then
    AddEventHandler("weaponDamageEvent", function(sender, ev)
        ---@diagnostic disable-next-line: missing-parameter
        CheckWeaponDistance(sender, ev, 3452007600, Config.maxStunGunDist, "StunGun Distance Exceeded")
    end)
end

if Config.AntiGiveWeapon then
    local frameworkDetected
    local weaponHash <const> = {
        [-1768145561] = "WEAPON_SPECIALCARBINE_MK2",
        [487013001] = "WEAPON_PUMPSHOTGUN",
        [-1075685676] = "WEAPON_PISTOL_MK2",
        [-1238556825] = "WEAPON_RAYMINIGUN",
        [-1834847097] = "WEAPON_DAGGER",
        [-102323637] = "WEAPON_BOTTLE",
        [-618237638] = "WEAPON_EMPLAUNCHER",
        [453432689] = "WEAPON_PISTOL",
        [940833800] = "WEAPON_STONE_HATCHET",
        [-1716589765] = "WEAPON_PISTOL50",
        [-1716189206] = "WEAPON_KNIFE",
        [1853742572] = "WEAPON_PRECISIONRIFLE",
        [-1076751822] = "WEAPON_SNSPISTOL",
        [1198879012] = "WEAPON_FLAREGUN",
        [-1355376991] = "WEAPON_RAYPISTOL",
        [-1813897027] = "WEAPON_GRENADE",
        [1737195953] = "WEAPON_NIGHTSTICK",
        [406929569] = "WEAPON_FERTILIZERCAN",
        [1593441988] = "WEAPON_COMBATPISTOL",
        [465894841] = "WEAPON_PISTOLXM3",
        [1432025498] = "WEAPON_PUMPSHOTGUN_MK2",
        [100416529] = "WEAPON_SNIPERRIFLE",
        [-135142818] = "WEAPON_ACIDPACKAGE",
        [-1168940174] = "WEAPON_HAZARDCAN",
        [-581044007] = "WEAPON_MACHETE",
        [1171102963] = "WEAPON_STUNGUN_MP",
        [-1063057011] = "WEAPON_SPECIALCARBINE",
        [-1951375401] = "WEAPON_FLASHLIGHT",
        [727643628] = "WEAPON_CERAMICPISTOL",
        [584646201] = "WEAPON_APPISTOL",
        [-1045183535] = "WEAPON_REVOLVER",
        [-72657034] = "GADGET_PARACHUTE",
        [883325847] = "WEAPON_PETROLCAN",
        [-1600701090] = "WEAPON_BZGAS",
        [-2084633992] = "WEAPON_CARBINERIFLE",
        [-608341376] = "WEAPON_COMBATMG_MK2",
        [-538741184] = "WEAPON_SWITCHBLADE",
        [125959754] = "WEAPON_COMPACTLAUNCHER",
        [600439132] = "WEAPON_BALL",
        [2024373456] = "WEAPON_SMG_MK2",
        [-1169823560] = "WEAPON_PIPEBOMB",
        [615608432] = "WEAPON_MOLOTOV",
        [-494615257] = "WEAPON_ASSAULTSHOTGUN",
        [-1420407917] = "WEAPON_PROXMINE",
        [205991906] = "WEAPON_HEAVYSNIPER",
        [2017895192] = "WEAPON_SAWNOFFSHOTGUN",
        [-598887786] = "WEAPON_MARKSMANPISTOL",
        [-270015777] = "WEAPON_ASSAULTSMG",
        [-22923932] = "WEAPON_RAILGUNXM3",
        [-37975472] = "WEAPON_SMOKEGRENADE",
        [-1654528753] = "WEAPON_BULLPUPSHOTGUN",
        [1317494643] = "WEAPON_HAMMER",
        [1672152130] = "WEAPON_HOMINGLAUNCHER",
        [1834241177] = "WEAPON_RAILGUN",
        [-86904375] = "WEAPON_CARBINERIFLE_MK2",
        [-1810795771] = "WEAPON_POOLCUE",
        [1305664598] = "WEAPON_GRENADELAUNCHER_SMOKE",
        [94989220] = "WEAPON_COMBATSHOTGUN",
        [1119849093] = "WEAPON_MINIGUN",
        [-853065399] = "WEAPON_BATTLEAXE",
        [-1568386805] = "WEAPON_GRENADELAUNCHER",
        [-1357824103] = "WEAPON_ADVANCEDRIFLE",
        [736523883] = "WEAPON_SMG",
        [-1312131151] = "WEAPON_RPG",
        [-879347409] = "WEAPON_REVOLVER_MK2",
        [-771403250] = "WEAPON_HEAVYPISTOL",
        [1785463520] = "WEAPON_MARKSMANRIFLE_MK2",
        [419712736] = "WEAPON_WRENCH",
        [-952879014] = "WEAPON_MARKSMANRIFLE",
        [137902532] = "WEAPON_VINTAGEPISTOL",
        [-619010992] = "WEAPON_MACHINEPISTOL",
        [-1746263880] = "WEAPON_DOUBLEACTION",
        [177293209] = "WEAPON_HEAVYSNIPER_MK2",
        [2132975508] = "WEAPON_BULLPUPRIFLE",
        [171789620] = "WEAPON_COMBATPDW",
        [2144741730] = "WEAPON_COMBATMG",
        [-1660422300] = "WEAPON_MG",
        [1627465347] = "WEAPON_GUSENBERG",
        [911657153] = "WEAPON_STUNGUN",
        [-1121678507] = "WEAPON_MINISMG",
        [-947031628] = "WEAPON_HEAVYRIFLE",
        [984333226] = "WEAPON_HEAVYSHOTGUN",
        [1649403952] = "WEAPON_COMPACTRIFLE",
        [-1074790547] = "WEAPON_ASSAULTRIFLE",
        [-1853920116] = "WEAPON_NAVYREVOLVER",
        [2138347493] = "WEAPON_FIREWORK",
        [1233104067] = "WEAPON_FLARE",
        [961495388] = "WEAPON_ASSAULTRIFLE_MK2",
        [-2009644972] = "WEAPON_SNSPISTOL_MK2",
        [-102973651] = "WEAPON_HATCHET",
        [-2066285827] = "WEAPON_BULLPUPRIFLE_MK2",
        [324215364] = "WEAPON_MICROSMG",
        [1703483498] = "WEAPON_CANDYCANE",
        [317205821] = "WEAPON_AUTOSHOTGUN",
        [350597077] = "WEAPON_TECPISTOL",
        [-1786099057] = "WEAPON_BAT",
        [-275439685] = "WEAPON_DBSHOTGUN",
        [-1658906650] = "WEAPON_MILITARYRIFLE",
        [-656458692] = "WEAPON_KNUCKLE",
        [126349499] = "WEAPON_SNOWBALL",
        [1198256469] = "WEAPON_RAYCARBINE",
        [-774507221] = "WEAPON_TACTICALRIFLE",
        [101631238] = "WEAPON_FIREEXTINGUISHER",
        [1470379660] = "WEAPON_GADGETPISTOL",
        [741814745] = "WEAPON_STICKYBOMB",
        [1141786504] = "WEAPON_GOLFCLUB",
        [-2067956739] = "WEAPON_CROWBAR"
    }

    local function toUnsigned32(n)
        return (n < 0) and (n + 4294967296) or n
    end

    local HasWeapon = function() return false end
    if GetResourceState('ox_inventory') == 'started' then
        HasWeapon = function(playerId, weaponName)
            return exports.ox_inventory:GetItemCount(playerId, weaponName) > 0
        end
    elseif GetResourceState('es_extended') == 'started' then
        frameworkDetected = 'es_extended'
        local ESX = exports.es_extended:getSharedObject()
        HasWeapon = function(playerId, weaponName)
            local xPlayer = ESX.GetPlayerFromId(playerId)
            return xPlayer and xPlayer.hasItem(weaponName, 1)
        end
    elseif GetResourceState('qbx_core') == 'started' then
        frameworkDetected = 'qbx_core'
        HasWeapon = function(playerId, weaponName)
            local Player = exports.qbx_core:GetPlayer(playerId)
            return Player and Player.PlayerData.items?[weaponName]?.amount >= 1
        end
    elseif GetResourceState('qb-core') == 'started' then
        frameworkDetected = 'qb-core'
        local QBCore = exports['qb-core']:GetCoreObject()
        HasWeapon = function(playerId, weaponName)
            local Player = QBCore.Functions.GetPlayer(playerId)
            return Player and Player.Functions.GetItemByName(weaponName)
        end
    end

    if frameworkDetected then Debug('Framework For Weapon Detection : ^3' .. frameworkDetected .. '^0') end

    AddEventHandler('weaponDamageEvent', function(sender, ev)
        if ev.weaponType == GetHashKey("WEAPON_UNARMED") or ev.damageType ~= 3 then return end
        local weaponName = weaponHash[ev.weaponType]
        if not weaponName then return end

        if Config.AntiGiveWeapon.relaxed then
            local now = GetGameTimer()
            if serv_cooldown2[sender] and now < serv_cooldown2[sender] then
                return
            end
            serv_cooldown2[sender] = now + 3000
        end

        local playerPedId = GetPlayerPed(sender)
        local hasWeapon = HasWeapon(sender, weaponName)

        Debug(('AntiGiveWeapon: %s fired with %s - %s'):format(GetPlayerName(sender) or "unknown", weaponName, hasWeapon and "present in inventory" or "missing / spawned"))

        if not hasWeapon then
            CancelEvent()
            if Config.AntiGiveWeapon.ban then
                Debug(('AntiGiveWeapon: %s was banned for using %s without having it'):format(GetPlayerName(sender), weaponName))
                BanPlayer(sender, "Give Weapon Detected (Shot with spawned weapon)", Config.AntiGiveWeapon.recordPlayer)
            else
                Debug(('AntiGiveWeapon: %s did not have %s, weapon removed'):format(GetPlayerName(sender), weaponName))
                RemoveWeaponFromPed(playerPedId, ev.weaponType)
            end
        end
    end)
end
