local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.ExportsNative
while not Fiveguard do Wait(0) end
if not Config?.enable then return end


---- SetEntityCoords
-- Exemple: exports["addon"]:FgSetEntityCoords(PlayerPedId(), 200.0, 200.0, 200.0)
if Config.SetEntityCoords then
    function FgSetEntityCoords(entity, x, y, z, alive, deadFlag, ragdollFlag, clearArea)
        TriggerServerEvent("fg:addon:EntityCoords", true)
        Wait(50)
        SetEntityCoords(entity or nil, x or 0.0, y or 0.0, z or 0.0, alive or false, deadFlag or false, ragdollFlag or false, clearArea or false)
        Wait(1000)
        TriggerServerEvent("fg:addon:EntityCoords", false)
    end
    exports("FgSetEntityCoords", FgSetEntityCoords)
end

---- SetEntityVisible
-- Exemple: exports["addon"]:FgSetEntityVisible(PlayerPedId(), true)
if Config.SetEntityVisible then
    function FgSetEntityVisible(entity, toggle)
        if toggle then
            TriggerServerEvent("fg:addon:EntityVisible", true)
        end
        Wait(50)
        SetEntityVisible(entity, toggle, false)
        if not toggle then
            Wait(1000)
            TriggerServerEvent("fg:addon:EntityVisible", false)
        end
    end
    exports("FgSetEntityVisible", FgSetEntityVisible)
end
