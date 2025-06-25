local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.WeaponDetection
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

local MAX_PUNCH_DIST = Config.MaxPunchDist
local MAX_STUNGUN_DIST = Config.MaxStunGunDist
local MAX_EXPLOIT_PUNCH_DIST = Config.MaxExploitPunchDist

if Config.DetectPunchDist then
  AddEventHandler("weaponDamageEvent", function(sender, ev)
      
      if tonumber(ev.weaponType) ~= 2725352035 then 
          return 
      end
  
      local attackerSrc = sender
      local attackerPed = GetPlayerPed(attackerSrc)
  
      if attackerPed == 0 then 
          return 
      end
  
      local victims = ev.hitGlobalIds or { ev.hitGlobalId }
      for _, netId in ipairs(victims) do
          if netId and netId ~= 0 then
              local victimEnt = NetworkGetEntityFromNetworkId(netId)
              if DoesEntityExist(victimEnt) then
                  local d = #( GetEntityCoords(attackerPed) - GetEntityCoords(victimEnt) )
                  if d > MAX_PUNCH_DIST then
                      local victimSrc  = NetworkGetEntityOwner(victimEnt) or 0
                      exports[Fiveguard]:fg_BanPlayer(attackerSrc, "Exploit Punch Distance (1)", true)
                  end
              end
          end
      end
  end)
end

if Config.DetectStunGunDist then
  AddEventHandler("weaponDamageEvent", function(sender, ev)
      local weaponHash = tonumber(ev.weaponType)
      if not weaponHash then return end
  
      if weaponHash ~= 3452007600 then 
          return 
      end
  
      local attackerSrc  = sender
      local attackerPed  = GetPlayerPed(attackerSrc)
  
      if attackerPed == 0 then 
          return 
      end
  
      local victims = ev.hitGlobalIds or { ev.hitGlobalId }
      for _, netId in ipairs(victims) do
          if netId and netId ~= 0 then
              local victimEnt = NetworkGetEntityFromNetworkId(netId)
              if DoesEntityExist(victimEnt) then
                  local d = #(GetEntityCoords(attackerPed) - GetEntityCoords(victimEnt))
                  if d > MAX_STUNGUN_DIST then
                      local victimSrc = NetworkGetEntityOwner(victimEnt) or 0
                      exports[Fiveguard]:fg_BanPlayer(attackerSrc, "Exploit StunGun Distance", true)
                  end
              end
          end
      end
  end)
end

if Config.DetectExploitPunchDist then
  AddEventHandler("weaponDamageEvent", function(sender, ev)
      local weaponHash = tonumber(ev.weaponType)
      local weaponDamage = tonumber(ev.weaponDamage)
  
      if not weaponHash then 
          return 
      end
  
      if weaponHash == 2725352035 and weaponDamage == 0 then
  
          local attackerSrc = sender
          local attackerPed = GetPlayerPed(attackerSrc)
  
          if attackerPed == 0 then 
              return 
          end
  
          local victims = ev.hitGlobalIds or { ev.hitGlobalId }
          for _, netId in ipairs(victims) do
              if netId and netId ~= 0 then
                  local victimEnt = NetworkGetEntityFromNetworkId(netId)
                  if DoesEntityExist(victimEnt) then
                      local dist = #(GetEntityCoords(attackerPed) - GetEntityCoords(victimEnt))
                      if dist > MAX_EXPLOIT_PUNCH_DIST then
                          local victimSrc = NetworkGetEntityOwner(victimEnt) or 0
                          exports[Fiveguard]:fg_BanPlayer(attackerSrc, "Exploit Punch Distance (2)", true)
                      end
                  end
              end
          end
      end
  end)
end


if Config.AntiGiveWeapon then
    local frameworkDetected = ''
    local GetPlayerObject = nil
    local HasWeapon = nil

    weaponHash = {
        [GetHashKey("weapon_dagger")] = "weapon_dagger",
        [GetHashKey("weapon_bat")] = "weapon_bat",
        [GetHashKey("weapon_bottle")] = "weapon_bottle",
        [GetHashKey("weapon_crowbar")] = "weapon_crowbar",
        [GetHashKey("weapon_flashlight")] = "weapon_flashlight",
        [GetHashKey("weapon_golfclub")] = "weapon_golfclub",
        [GetHashKey("weapon_hammer")] = "weapon_hammer",
        [GetHashKey("weapon_hatchet")] = "weapon_hatchet",
        [GetHashKey("weapon_knuckle")] = "weapon_knuckle",
        [GetHashKey("weapon_knife")] = "weapon_knife",
        [GetHashKey("weapon_machete")] = "weapon_machete",
        [GetHashKey("weapon_switchblade")] = "weapon_switchblade",
        [GetHashKey("weapon_nightstick")] = "weapon_nightstick",
        [GetHashKey("weapon_wrench")] = "weapon_wrench",
        [GetHashKey("weapon_battleaxe")] = "weapon_battleaxe",
        [GetHashKey("weapon_poolcue")] = "weapon_poolcue",
        [GetHashKey("weapon_stone_hatchet")] = "weapon_stone_hatchet",
        [GetHashKey("weapon_candycane")] = "weapon_candycane",
        [GetHashKey("weapon_pistol")] = "weapon_pistol",
        [GetHashKey("weapon_pistol_mk2")] = "weapon_pistol_mk2",
        [GetHashKey("weapon_combatpistol")] = "weapon_combatpistol",
        [GetHashKey("weapon_appistol")] = "weapon_appistol",
        [GetHashKey("weapon_stungun")] = "weapon_stungun",
        [GetHashKey("weapon_pistol50")] = "weapon_pistol50",
        [GetHashKey("weapon_snspistol")] = "weapon_snspistol",
        [GetHashKey("weapon_snspistol_mk2")] = "weapon_snspistol_mk2",
        [GetHashKey("weapon_heavypistol")] = "weapon_heavypistol",
        [GetHashKey("weapon_vintagepistol")] = "weapon_vintagepistol",
        [GetHashKey("weapon_flaregun")] = "weapon_flaregun",
        [GetHashKey("weapon_marksmanpistol")] = "weapon_marksmanpistol",
        [GetHashKey("weapon_revolver")] = "weapon_revolver",
        [GetHashKey("weapon_revolver_mk2")] = "weapon_revolver_mk2",
        [GetHashKey("weapon_doubleaction")] = "weapon_doubleaction",
        [GetHashKey("weapon_raypistol")] = "weapon_raypistol",
        [GetHashKey("weapon_ceramicpistol")] = "weapon_ceramicpistol",
        [GetHashKey("weapon_navyrevolver")] = "weapon_navyrevolver",
        [GetHashKey("weapon_gadgetpistol")] = "weapon_gadgetpistol",
        [GetHashKey("weapon_stungun_mp")] = "weapon_stungun_mp",
        [GetHashKey("weapon_pistolxm3")] = "weapon_pistolxm3",
        [GetHashKey("weapon_microsmg")] = "weapon_microsmg",
        [GetHashKey("weapon_smg")] = "weapon_smg",
        [GetHashKey("weapon_smg_mk2")] = "weapon_smg_mk2",
        [GetHashKey("weapon_assaultsmg")] = "weapon_assaultsmg",
        [GetHashKey("weapon_combatpdw")] = "weapon_combatpdw",
        [GetHashKey("weapon_machinepistol")] = "weapon_machinepistol",
        [GetHashKey("weapon_minismg")] = "weapon_minismg",
        [GetHashKey("weapon_raycarbine")] = "weapon_raycarbine",
        [GetHashKey("weapon_tecpistol")] = "weapon_tecpistol",
        [GetHashKey("weapon_pumpshotgun")] = "weapon_pumpshotgun",
        [GetHashKey("weapon_pumpshotgun_mk2")] = "weapon_pumpshotgun_mk2",
        [GetHashKey("weapon_sawnoffshotgun")] = "weapon_sawnoffshotgun",
        [GetHashKey("weapon_assaultshotgun")] = "weapon_assaultshotgun",
        [GetHashKey("weapon_bullpupshotgun")] = "weapon_bullpupshotgun",
        [GetHashKey("weapon_heavyshotgun")] = "weapon_heavyshotgun",
        [GetHashKey("weapon_dbshotgun")] = "weapon_dbshotgun",
        [GetHashKey("weapon_autoshotgun")] = "weapon_autoshotgun",
        [GetHashKey("weapon_combatshotgun")] = "weapon_combatshotgun",
        [GetHashKey("weapon_assaultrifle")] = "weapon_assaultrifle",
        [GetHashKey("weapon_assaultrifle_mk2")] = "weapon_assaultrifle_mk2",
        [GetHashKey("weapon_carbinerifle")] = "weapon_carbinerifle",
        [GetHashKey("weapon_carbinerifle_mk2")] = "weapon_carbinerifle_mk2",
        [GetHashKey("weapon_advancedrifle")] = "weapon_advancedrifle",
        [GetHashKey("weapon_specialcarbine")] = "weapon_specialcarbine",
        [GetHashKey("weapon_specialcarbine_mk2")] = "weapon_specialcarbine_mk2",
        [GetHashKey("weapon_bullpuprifle")] = "weapon_bullpuprifle",
        [GetHashKey("weapon_bullpuprifle_mk2")] = "weapon_bullpuprifle_mk2",
        [GetHashKey("weapon_compactrifle")] = "weapon_compactrifle",
        [GetHashKey("weapon_militaryrifle")] = "weapon_militaryrifle",
        [GetHashKey("weapon_heavyrifle")] = "weapon_heavyrifle",
        [GetHashKey("weapon_tacticalrifle")] = "weapon_tacticalrifle",
        [GetHashKey("weapon_mg")] = "weapon_mg",
        [GetHashKey("weapon_combatmg")] = "weapon_combatmg",
        [GetHashKey("weapon_combatmg_mk2")] = "weapon_combatmg_mk2",
        [GetHashKey("weapon_gusenberg")] = "weapon_gusenberg",
        [GetHashKey("weapon_sniperrifle")] = "weapon_sniperrifle",
        [GetHashKey("weapon_heavysniper")] = "weapon_heavysniper",
        [GetHashKey("weapon_heavysniper_mk2")] = "weapon_heavysniper_mk2",
        [GetHashKey("weapon_marksmanrifle")] = "weapon_marksmanrifle",
        [GetHashKey("weapon_marksmanrifle_mk2")] = "weapon_marksmanrifle_mk2",
        [GetHashKey("weapon_precisionrifle")] = "weapon_precisionrifle",
        [GetHashKey("weapon_rpg")] = "weapon_rpg",
        [GetHashKey("weapon_grenadelauncher")] = "weapon_grenadelauncher",
        [GetHashKey("weapon_grenadelauncher_smoke")] = "weapon_grenadelauncher_smoke",
        [GetHashKey("weapon_minigun")] = "weapon_minigun",
        [GetHashKey("weapon_firework")] = "weapon_firework",
        [GetHashKey("weapon_railgun")] = "weapon_railgun",
        [GetHashKey("weapon_hominglauncher")] = "weapon_hominglauncher",
        [GetHashKey("weapon_compactlauncher")] = "weapon_compactlauncher",
        [GetHashKey("weapon_rayminigun")] = "weapon_rayminigun",
        [GetHashKey("weapon_emplauncher")] = "weapon_emplauncher",
        [GetHashKey("weapon_railgunxm3")] = "weapon_railgunxm3",
        [GetHashKey("weapon_grenade")] = "weapon_grenade",
        [GetHashKey("weapon_bzgas")] = "weapon_bzgas",
        [GetHashKey("weapon_molotov")] = "weapon_molotov",
        [GetHashKey("weapon_stickybomb")] = "weapon_stickybomb",
        [GetHashKey("weapon_proxmine")] = "weapon_proxmine",
        [GetHashKey("weapon_snowball")] = "weapon_snowball",
        [GetHashKey("weapon_pipebomb")] = "weapon_pipebomb",
        [GetHashKey("weapon_ball")] = "weapon_ball",
        [GetHashKey("weapon_smokegrenade")] = "weapon_smokegrenade",
        [GetHashKey("weapon_flare")] = "weapon_flare",
        [GetHashKey("weapon_acidpackage")] = "weapon_acidpackage",
        [GetHashKey("weapon_petrolcan")] = "weapon_petrolcan",
        [GetHashKey("gadget_parachute")] = "gadget_parachute",
        [GetHashKey("weapon_fireextinguisher")] = "weapon_fireextinguisher",
        [GetHashKey("weapon_hazardcan")] = "weapon_hazardcan",
        [GetHashKey("weapon_fertilizercan")] = "weapon_fertilizercan",
    }

    if GetResourceState('es_extended') == 'started' then
        frameworkDetected = 'es_extended'
        ESX = exports.es_extended:getSharedObject()

        GetPlayerObject = function(playerId)
            return ESX.GetPlayerFromId(playerId)
        end

        HasWeapon = function(playerId, weaponName)
            local xPlayer = GetPlayerObject(playerId)
            if not xPlayer then return false end
            local hasItem = xPlayer.hasItem(weaponName, 1)
            return hasItem
        end

    elseif GetResourceState('qbx_core') == 'started' or GetResourceState('qb-core') == 'started' then
        frameworkDetected = GetResourceState('qbx_core') == 'started' and 'qbx_core' or 'qb-core'
        local QBCore = exports[frameworkDetected]:GetCoreObject()

        GetPlayerObject = function(playerId)
            return QBCore.Functions.GetPlayer(playerId)
        end

        HasWeapon = function(playerId, weaponName)
            local Player = GetPlayerObject(playerId)
            if not Player then return false end
            local item = Player.Functions.GetItemByName(weaponName)
            return item and item.amount >= 1
        end
    end

    Debug('Framework For Weapon Detection : ^3'..frameworkDetected..'^0')

    AddEventHandler('weaponDamageEvent', function(sender, data)
        local playerId = sender
        local weapon = data.weaponType
        local weaponName = weaponHash[weapon] or "unknown"
        local playerPedId = GetPlayerPed(playerId)

        if weapon == GetHashKey("WEAPON_UNARMED") then return end
        if weaponName == "unknown" then return end

        local hasWeapon = HasWeapon(playerId, weaponName)

        Debug('AntiGiveWeapon: ' .. (GetPlayerName(playerId) or "unknown") .. ' fired with ' .. weaponName .. ' - ' .. (hasWeapon and "present in inventory" or "missing / spawned"))

        if not hasWeapon then
            if Config.AntiGiveWeaponBan then
                Debug('AntiGiveWeapon: ' .. GetPlayerName(playerId) .. ' was banned for using ' .. weaponName .. ' without having it')
                exports[fiveguardname]:fg_BanPlayer(sender, "Give Weapon Detected (Shot with spawned weapon)", true)
            else
                Debug('AntiGiveWeapon: ' .. GetPlayerName(playerId) .. ' did not have ' .. weaponName .. ', weapon removed')
                RemoveWeaponFromPed(playerPedId, weapon)
            end
            CancelEvent()
        end
    end)

end
