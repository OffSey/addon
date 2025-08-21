local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.WeaponProtection
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

local hasInitialWeaponsBeenChecked = false

local WeaponsToCheck = {
    "WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL", "WEAPON_PISTOL50", "WEAPON_SNSPISTOL",
    "WEAPON_CARBINERIFLE", "WEAPON_SPECIALCARBINE", "WEAPON_ADVANCEDRIFLE", "WEAPON_SMG",
    "WEAPON_ASSAULTSMG", "WEAPON_PUMPSHOTGUN", "WEAPON_SAWNOFFSHOTGUN", "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER"
}

AddEventHandler('playerSpawned', function()
    if hasInitialWeaponsBeenChecked then return end
    hasInitialWeaponsBeenChecked = true
    Citizen.Wait(1000)
    local initialWeapons = {}
    local playerPed = PlayerPedId()
    for _, weaponName in ipairs(WeaponsToCheck) do
        local weaponHash = GetHashKey(weaponName)
        if HasPedGotWeapon(playerPed, weaponHash, false) then
            table.insert(initialWeapons, weaponName)
        end
    end
    if #initialWeapons > 0 then
        TriggerServerEvent('fg:addon:registerInitialWeapons', initialWeapons)
    end
end)
