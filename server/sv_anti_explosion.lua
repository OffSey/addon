local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiExplosions
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

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

      if ev.explosionType == 9 and ev.damageScale == 1 and ev.cameraShake == 1 and ev.isNetworked == nil and ev.explosionFX == nil then
       Warn('Explosions Susano (or others cheat) detected and deleted')
        CancelEvent()
            if Config.Ban then
              exports[Fiveguard]:fg_BanPlayer(sender, "Detected Susano Explosions", true)
            end
        return
    end   

    if ev.explosionType == 7 and ev.damageScale == 1 and ev.cameraShake >= 0.6 and ev.ownerNetId == 1 and ev.isNetworked == nil and ev.explosionFX == nil then
        CancelEvent()
        Warn('Explosions Safe Susano (or others cheat) detected and deleted')
            if Config.Ban then
              exports[Fiveguard]:fg_BanPlayer(sender, "Detected Susano Safe Explosions", true)
            end
        return
    end

      if ev.explosionType == 7 and ev.damageScale == 1 and ev.cameraShake >= 0.6 and ev.ownerNetId == 0 and ev.isNetworked == nil and ev.explosionFX == nil then
        CancelEvent()
            if Config.Ban then
              exports[Fiveguard]:fg_BanPlayer(sender, "Detected Keyser Explosions", true)
            end
        return
    end
            
end)
