local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.WeaponProtection
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end
local coolDown = {}
local weaponHash <const> = {
    [GetHashKey("WEAPON_SPECIALCARBINE_MK2")] = "WEAPON_SPECIALCARBINE_MK2",
    [GetHashKey("WEAPON_PUMPSHOTGUN")] = "WEAPON_PUMPSHOTGUN",
    [GetHashKey("WEAPON_PISTOL_MK2")] = "WEAPON_PISTOL_MK2",
    [GetHashKey("WEAPON_RAYMINIGUN")] = "WEAPON_RAYMINIGUN",
    [GetHashKey("WEAPON_DAGGER")] = "WEAPON_DAGGER",
    [GetHashKey("WEAPON_BOTTLE")] = "WEAPON_BOTTLE",
    [GetHashKey("WEAPON_EMPLAUNCHER")] = "WEAPON_EMPLAUNCHER",
    [GetHashKey("WEAPON_PISTOL")] = "WEAPON_PISTOL",
    [GetHashKey("WEAPON_STONE_HATCHET")] = "WEAPON_STONE_HATCHET",
    [GetHashKey("WEAPON_PISTOL50")] = "WEAPON_PISTOL50",
    [GetHashKey("WEAPON_KNIFE")] = "WEAPON_KNIFE",
    [GetHashKey("WEAPON_PRECISIONRIFLE")] = "WEAPON_PRECISIONRIFLE",
    [GetHashKey("WEAPON_SNSPISTOL")] = "WEAPON_SNSPISTOL",
    [GetHashKey("WEAPON_FLAREGUN")] = "WEAPON_FLAREGUN",
    [GetHashKey("WEAPON_RAYPISTOL")] = "WEAPON_RAYPISTOL",
    [GetHashKey("WEAPON_GRENADE")] = "WEAPON_GRENADE",
    [GetHashKey("WEAPON_NIGHTSTICK")] = "WEAPON_NIGHTSTICK",
    [GetHashKey("WEAPON_FERTILIZERCAN")] = "WEAPON_FERTILIZERCAN",
    [GetHashKey("WEAPON_COMBATPISTOL")] = "WEAPON_COMBATPISTOL",
    [GetHashKey("WEAPON_PISTOLXM3")] = "WEAPON_PISTOLXM3",
    [GetHashKey("WEAPON_PUMPSHOTGUN_MK2")] = "WEAPON_PUMPSHOTGUN_MK2",
    [GetHashKey("WEAPON_SNIPERRIFLE")] = "WEAPON_SNIPERRIFLE",
    [GetHashKey("WEAPON_ACIDPACKAGE")] = "WEAPON_ACIDPACKAGE",
    [GetHashKey("WEAPON_HAZARDCAN")] = "WEAPON_HAZARDCAN",
    [GetHashKey("WEAPON_MACHETE")] = "WEAPON_MACHETE",
    [GetHashKey("WEAPON_STUNGUN_MP")] = "WEAPON_STUNGUN_MP",
    [GetHashKey("WEAPON_SPECIALCARBINE")] = "WEAPON_SPECIALCARBINE",
    [GetHashKey("WEAPON_FLASHLIGHT")] = "WEAPON_FLASHLIGHT",
    [GetHashKey("WEAPON_CERAMICPISTOL")] = "WEAPON_CERAMICPISTOL",
    [GetHashKey("WEAPON_APPISTOL")] = "WEAPON_APPISTOL",
    [GetHashKey("WEAPON_REVOLVER")] = "WEAPON_REVOLVER",
    [GetHashKey("GADGET_PARACHUTE")] = "GADGET_PARACHUTE",
    [GetHashKey("WEAPON_PETROLCAN")] = "WEAPON_PETROLCAN",
    [GetHashKey("WEAPON_BZGAS")] = "WEAPON_BZGAS",
    [GetHashKey("WEAPON_CARBINERIFLE")] = "WEAPON_CARBINERIFLE",
    [GetHashKey("WEAPON_COMBATMG_MK2")] = "WEAPON_COMBATMG_MK2",
    [GetHashKey("WEAPON_SWITCHBLADE")] = "WEAPON_SWITCHBLADE",
    [GetHashKey("WEAPON_COMPACTLAUNCHER")] = "WEAPON_COMPACTLAUNCHER",
    [GetHashKey("WEAPON_BALL")] = "WEAPON_BALL",
    [GetHashKey("WEAPON_SMG_MK2")] = "WEAPON_SMG_MK2",
    [GetHashKey("WEAPON_PIPEBOMB")] = "WEAPON_PIPEBOMB",
    [GetHashKey("WEAPON_MOLOTOV")] = "WEAPON_MOLOTOV",
    [GetHashKey("WEAPON_ASSAULTSHOTGUN")] = "WEAPON_ASSAULTSHOTGUN",
    [GetHashKey("WEAPON_PROXMINE")] = "WEAPON_PROXMINE",
    [GetHashKey("WEAPON_HEAVYSNIPER")] = "WEAPON_HEAVYSNIPER",
    [GetHashKey("WEAPON_SAWNOFFSHOTGUN")] = "WEAPON_SAWNOFFSHOTGUN",
    [GetHashKey("WEAPON_MARKSMANPISTOL")] = "WEAPON_MARKSMANPISTOL",
    [GetHashKey("WEAPON_ASSAULTSMG")] = "WEAPON_ASSAULTSMG",
    [GetHashKey("WEAPON_RAILGUNXM3")] = "WEAPON_RAILGUNXM3",
    [GetHashKey("WEAPON_SMOKEGRENADE")] = "WEAPON_SMOKEGRENADE",
    [GetHashKey("WEAPON_BULLPUPSHOTGUN")] = "WEAPON_BULLPUPSHOTGUN",
    [GetHashKey("WEAPON_HAMMER")] = "WEAPON_HAMMER",
    [GetHashKey("WEAPON_HOMINGLAUNCHER")] = "WEAPON_HOMINGLAUNCHER",
    [GetHashKey("WEAPON_RAILGUN")] = "WEAPON_RAILGUN",
    [GetHashKey("WEAPON_CARBINERIFLE_MK2")] = "WEAPON_CARBINERIFLE_MK2",
    [GetHashKey("WEAPON_POOLCUE")] = "WEAPON_POOLCUE",
    [GetHashKey("WEAPON_GRENADELAUNCHER_SMOKE")] = "WEAPON_GRENADELAUNCHER_SMOKE",
    [GetHashKey("WEAPON_COMBATSHOTGUN")] = "WEAPON_COMBATSHOTGUN",
    [GetHashKey("WEAPON_MINIGUN")] = "WEAPON_MINIGUN",
    [GetHashKey("WEAPON_BATTLEAXE")] = "WEAPON_BATTLEAXE",
    [GetHashKey("WEAPON_GRENADELAUNCHER")] = "WEAPON_GRENADELAUNCHER",
    [GetHashKey("WEAPON_ADVANCEDRIFLE")] = "WEAPON_ADVANCEDRIFLE",
    [GetHashKey("WEAPON_SMG")] = "WEAPON_SMG",
    [GetHashKey("WEAPON_RPG")] = "WEAPON_RPG",
    [GetHashKey("WEAPON_REVOLVER_MK2")] = "WEAPON_REVOLVER_MK2",
    [GetHashKey("WEAPON_HEAVYPISTOL")] = "WEAPON_HEAVYPISTOL",
    [GetHashKey("WEAPON_MARKSMANRIFLE_MK2")] = "WEAPON_MARKSMANRIFLE_MK2",
    [GetHashKey("WEAPON_WRENCH")] = "WEAPON_WRENCH",
    [GetHashKey("WEAPON_MARKSMANRIFLE")] = "WEAPON_MARKSMANRIFLE",
    [GetHashKey("WEAPON_VINTAGEPISTOL")] = "WEAPON_VINTAGEPISTOL",
    [GetHashKey("WEAPON_MACHINEPISTOL")] = "WEAPON_MACHINEPISTOL",
    [GetHashKey("WEAPON_DOUBLEACTION")] = "WEAPON_DOUBLEACTION",
    [GetHashKey("WEAPON_HEAVYSNIPER_MK2")] = "WEAPON_HEAVYSNIPER_MK2",
    [GetHashKey("WEAPON_BULLPUPRIFLE")] = "WEAPON_BULLPUPRIFLE",
    [GetHashKey("WEAPON_COMBATPDW")] = "WEAPON_COMBATPDW",
    [GetHashKey("WEAPON_COMBATMG")] = "WEAPON_COMBATMG",
    [GetHashKey("WEAPON_MG")] = "WEAPON_MG",
    [GetHashKey("WEAPON_GUSENBERG")] = "WEAPON_GUSENBERG",
    [GetHashKey("WEAPON_STUNGUN")] = "WEAPON_STUNGUN",
    [GetHashKey("WEAPON_MINISMG")] = "WEAPON_MINISMG",
    [GetHashKey("WEAPON_HEAVYRIFLE")] = "WEAPON_HEAVYRIFLE",
    [GetHashKey("WEAPON_HEAVYSHOTGUN")] = "WEAPON_HEAVYSHOTGUN",
    [GetHashKey("WEAPON_COMPACTRIFLE")] = "WEAPON_COMPACTRIFLE",
    [GetHashKey("WEAPON_ASSAULTRIFLE")] = "WEAPON_ASSAULTRIFLE",
    [GetHashKey("WEAPON_NAVYREVOLVER")] = "WEAPON_NAVYREVOLVER",
    [GetHashKey("WEAPON_FIREWORK")] = "WEAPON_FIREWORK",
    [GetHashKey("WEAPON_FLARE")] = "WEAPON_FLARE",
    [GetHashKey("WEAPON_ASSAULTRIFLE_MK2")] = "WEAPON_ASSAULTRIFLE_MK2",
    [GetHashKey("WEAPON_SNSPISTOL_MK2")] = "WEAPON_SNSPISTOL_MK2",
    [GetHashKey("WEAPON_HATCHET")] = "WEAPON_HATCHET",
    [GetHashKey("WEAPON_BULLPUPRIFLE_MK2")] = "WEAPON_BULLPUPRIFLE_MK2",
    [GetHashKey("WEAPON_MICROSMG")] = "WEAPON_MICROSMG",
    [GetHashKey("WEAPON_CANDYCANE")] = "WEAPON_CANDYCANE",
    [GetHashKey("WEAPON_AUTOSHOTGUN")] = "WEAPON_AUTOSHOTGUN",
    [GetHashKey("WEAPON_TECPISTOL")] = "WEAPON_TECPISTOL",
    [GetHashKey("WEAPON_BAT")] = "WEAPON_BAT",
    [GetHashKey("WEAPON_DBSHOTGUN")] = "WEAPON_DBSHOTGUN",
    [GetHashKey("WEAPON_MILITARYRIFLE")] = "WEAPON_MILITARYRIFLE",
    [GetHashKey("WEAPON_KNUCKLE")] = "WEAPON_KNUCKLE",
    [GetHashKey("WEAPON_SNOWBALL")] = "WEAPON_SNOWBALL",
    [GetHashKey("WEAPON_RAYCARBINE")] = "WEAPON_RAYCARBINE",
    [GetHashKey("WEAPON_TACTICALRIFLE")] = "WEAPON_TACTICALRIFLE",
    [GetHashKey("WEAPON_FIREEXTINGUISHER")] = "WEAPON_FIREEXTINGUISHER",
    [GetHashKey("WEAPON_GADGETPISTOL")] = "WEAPON_GADGETPISTOL",
    [GetHashKey("WEAPON_STICKYBOMB")] = "WEAPON_STICKYBOMB",
    [GetHashKey("WEAPON_GOLFCLUB")] = "WEAPON_GOLFCLUB",
    [GetHashKey("WEAPON_CROWBAR")] = "WEAPON_CROWBAR",
    [GetHashKey("WEAPON_UNARMED")] = "WEAPON_UNARMED"
}

---@param sender string
---@param ev table
---@param expectedHash number
---@param maxDist number
---@param reason string
---@param extraCond? fun(ev: table): boolean
local function CheckWeaponDistance(sender, ev, expectedHash, maxDist, reason, extraCond)
    local weaponHash = tonumber(ev.weaponType)
    if not weaponHash or weaponHash ~= expectedHash then return end
    if extraCond and not extraCond(ev) then return end

    local attackerPed = GetPlayerPed(sender)
    if attackerPed == 0 then return end

    local attackerCoords = GetEntityCoords(attackerPed)
    local victims = ev.hitGlobalIds or { ev.hitGlobalId }

    for _, netId in ipairs(victims) do
        if netId and netId ~= 0 then
            local victimEnt = NetworkGetEntityFromNetworkId(netId)
            local victimCoords = GetEntityCoords(victimEnt)
            if DoesEntityExist(victimEnt) then
                if #(attackerCoords - victimCoords) > maxDist then
                    CancelEvent()
                    PunishPlayer(sender, true, reason, false)
                end
            end
        end
    end
end


if Config.AntiDistanceDamage.punch.enable then
    AddEventHandler("weaponDamageEvent", function(sender, ev)
        CheckWeaponDistance(sender, ev, 2725352035, Config.AntiDistanceDamage.punch.maxDistance, "Punch Distance Exceeded (1)")
        CheckWeaponDistance(sender, ev, 2725352035, Config.AntiDistanceDamage.punch.maxDistance, "Punch Distance Exceeded (2)", function(r)
            return r.weaponDamage == 0
        end)
    end)
end
if Config.AntiDistanceDamage.stungun.enable then
    AddEventHandler("weaponDamageEvent", function(sender, ev)
        CheckWeaponDistance(sender, ev, 3452007600, Config.AntiDistanceDamage.stungun.maxDistance, "StunGun Distance Exceeded")
    end)
end
if Config.AntiGiveWeapon.enable then
    local frameworkDetected,HasWeapon
    
    local checkResource = function (res)
        local rs = GetResourceState(res)
        return rs == "started" or rs == "starting"
    end
    if not frameworkDetected and checkResource('es_extended') then
        frameworkDetected = 'ESX'
        local ESX = exports.es_extended:getSharedObject()
        HasWeapon = function(source, weaponName)
            local xPlayer = ESX.GetPlayerFromId(source)
            if not xPlayer then
                Warn(("Player %s is not loaded"):format(GetPlayerName(source)))
                return
            end
            return xPlayer.hasItem(weaponName).count >= 1
        end
    elseif not frameworkDetected and checkResource('qbx_core') then
        frameworkDetected = 'QBox'
        HasWeapon = function(source, weaponName)
            local Player = exports.qbx_core:GetPlayer(source)
            if not Player then
                Warn(("Player %s is not loaded"):format(GetPlayerName(source)))
                return
            end
            return Player.PlayerData.items?[weaponName]?.amount >= 1
        end
    elseif not frameworkDetected and checkResource('qb-core') then
        frameworkDetected = 'QBCore'
        local QBCore = exports['qb-core']:GetCoreObject()
        HasWeapon = function(source, weaponName)
            local Player = QBCore.Functions.GetPlayer(source)
            if not Player then
                Warn(("Player %s is not loaded"):format(GetPlayerName(source)))
                return
            end
            return Player.Functions.GetItemByName(weaponName) and true or false
        end
    elseif not frameworkDetected and checkResource('vrp') then
        frameworkDetected = 'vRP'
        local fileCode = LoadResourceFile('vrp','lib/utils.lua')
        assert(load(fileCode,'@@vrp/lib/utils.lua','t'))()
        ---@diagnostic disable-next-line: deprecated
        local Proxy = module("vrp", "lib/Proxy")
        ---@diagnostic disable-next-line: undefined-field, need-check-nil, lowercase-global
        local vRP = Proxy.getInterface("vRP")
        HasWeapon = function(source, weaponName) --todo: check if work on most vrp versions
            local user_id = vRP.getUserId(source)
            if user_id then return vRP.getInventoryItemAmount(user_id, weaponName) > 0 end
            Error(("Incompatible vRP version, disable AntiGiveWeapon in addon's config"):format(source))
        end
    else
        local PlayerWeapons = {}
        local isRegistered = {}
        AddEventHandler('playerJoining', function()
            PlayerWeapons[source] = {}
        end)
        AddEventHandler('playerDropped', function()
            PlayerWeapons[source] = nil
            isRegistered[source] = nil
        end)
        RegisterNetEvent('fg:addon:registerInitialWeapons', function(initialWeapons)
            if isRegistered[source] then
                PunishPlayer(source, true, "Tried to re-register his weapons", "image")
             end
            if not PlayerWeapons[source] then PlayerWeapons[source] = {} end
            for _, weaponName in ipairs(initialWeapons) do
                print(string.format("Registered starting weapon '%s' for player %s", weaponName, GetPlayerName(tostring(source))))
                PlayerWeapons[source][weaponName] = true
            end
        end)
        exports("giveWeapon", function(targetId, weaponName)
            if not PlayerWeapons[targetId] then PlayerWeapons[targetId] = {} end
            PlayerWeapons[targetId][weaponName] = true
            local targetPedId = GetPlayerPed(targetId)
            GiveWeaponToPed(targetPedId, weaponName,0,false,false)
        end)
        exports("removeWeapon", function(targetId, weaponName)
            if PlayerWeapons[targetId] then
                PlayerWeapons[targetId][weaponName] = nil
            end
            local targetPedId = GetPlayerPed(targetId)
            RemoveWeaponFromPed(targetPedId,  weaponName)
        end)
        HasWeapon = function (source, weaponName)
            if PlayerWeapons[source] and PlayerWeapons[source][weaponName] then
                return true
            end
            return false
        end
    end
    if frameworkDetected then Debug(("Framework For Weapon Detection: ^3%s^0"):format(frameworkDetected)) end
    AddEventHandler('weaponDamageEvent', function(sender, ev)
        local weaponName = weaponHash[ev.weaponType]
        if not weaponName or (weaponName and weaponName == "WEAPON_UNARMED") or ev.damageType ~= 3 then return end
        if Config.AntiGiveWeapon.relaxed then
            local now = GetGameTimer()
            if coolDown[sender] and now < coolDown[sender] then return end
            coolDown[sender] = now + 3000
        end
        local hasWeapon = HasWeapon(sender, weaponName)
        Debug(("AntiGiveWeapon: %s shot with %s that's %s"):format(GetPlayerName(sender) or "unknown", weaponName, (hasWeapon == true and "^2present^0 " or "^1missing^0 ").."in inventory"))
        if hasWeapon == false then
            CancelEvent()
            if Config.AntiGiveWeapon.ban then
                PunishPlayer(sender, Config.AntiGiveWeapon.ban, ("Give Weapon Detected (Shot with: %s)"):format(weaponName), Config.AntiGiveWeapon.banMedia)
            else
                local playerPedId = GetPlayerPed(sender)
                RemoveWeaponFromPed(playerPedId, ev.weaponType)
            end
        end
    end)
end

if Config.AntiGiveWeaponToPed.enable then
    AddEventHandler("giveWeaponEvent",function (sender,ddata)
        Debug(json.encode(ddata,{indent=true}))
        PunishPlayer(sender,Config.AntiGiveWeaponToPed.ban,("Tried to Add %s to player %s"):format(weaponHash[ddata.weaponType],NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(ddata.pedId))),false)
        CancelEvent()
    end)
end

if Config.AntiRemoveWeaponFromPed.enable then
    AddEventHandler("removeWeaponEvent",function (sender,ddata)
        Debug(json.encode(ddata,{indent=true}))
        PunishPlayer(sender,Config.AntiRemoveWeaponFromPed.ban,("Tried to remove %s from player %s"):format(weaponHash[ddata.weaponType],NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(ddata.pedId))),false)
        CancelEvent()
    end)
    AddEventHandler("removeAllWeaponsEvent",function (sender,ddata)
        Debug(json.encode(ddata,{indent=true}))
        PunishPlayer(sender,Config.AntiRemoveWeaponFromPed.ban,("Tried to remove all weapons from player %s"):format(weaponHash[ddata.weaponType],NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(ddata.pedId))),false)
        CancelEvent()
    end)
end

if Config.AntiGiveWeapon.relaxed then
    AddEventHandler("playerDropped", function ()
        if coolDown[source] then
            coolDown[source] = nil
        end
    end)
end
