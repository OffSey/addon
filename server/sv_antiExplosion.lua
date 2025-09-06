local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiExplosions
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

AddEventHandler("explosionEvent", function(sender, ev)
Debug("[explosionEvent] Received from player: " .. tostring(source) .. "\n" ..
      "  - Type: " .. tostring(ev.explosionType) .. "\n" ..
      "  - Position: x=" .. tostring(ev.x) .. ", y=" .. tostring(ev.y) .. ", z=" .. tostring(ev.z) .. "\n" ..
      "  - Damage Scale: " .. tostring(ev.damageScale) .. "\n" ..
      "  - Audible: " .. tostring(ev.isAudible) .. "\n" ..
      "  - Invisible: " .. tostring(ev.isInvisible) .. "\n" ..
      "  - Camera Shake: " .. tostring(ev.cameraShake) .. "\n" ..
      "  - Owner Net ID: " .. tostring(ev.ownerNetId) .. "\n" ..
      "  - Networked: " .. tostring(ev.isNetworked) .. "\n" ..
      "  - Explosion FX: " .. tostring(ev.explosionFX))

    if Config.preventExplosions and (ev.explosionType == 9 and ev.damageScale == 1 and ev.cameraShake == 1 and ev.isNetworked == nil and ev.explosionFX == nil) then
        CancelEvent()
        return PunishPlayer(sender, Config.ban, "Detected Explosions", Config.banMedia)
    end

    if Config.preventSafeExplosions and (ev.explosionType == 7 and ev.damageScale == 1 and ev.cameraShake >= 0.6 and (ev.ownerNetId == 1 or ev.ownerNetId == 0) and ev.isNetworked == nil and ev.explosionFX == nil) then
        CancelEvent()
        return PunishPlayer(sender, Config.ban, "Detected Safe Explosions", Config.banMedia)
    end

    if Config.preventUnnetworkedExplosions and (ev.explosionType == 7 and ev.f104 == 0) then --thanks to @somis12
        CancelEvent()
        return PunishPlayer(sender, Config.ban, "Detected Unnetworked Explosions", Config.banMedia)
    end
end)
