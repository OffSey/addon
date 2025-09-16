local resourceName = GetCurrentResourceName()
if resourceName == CurrentResourceName then return end
local Fiveguard = nil
local Addon = nil
do
    local resources = GetNumResources()
    for i = 0, resources - 1 do
        local resource = GetResourceByFindIndex(i)
        local files = GetNumResourceMetadata(resource, "ac")
        for j = 0, files - 1 do
            local x = GetResourceMetadata(resource, "ac", j)
            if x and x:find("fg") then
                Fiveguard = resource
                break
            end
        end
        if Fiveguard then break end
    end
    for i = 0, resources - 1 do
        local resource = GetResourceByFindIndex(i)
        local files = GetNumResourceMetadata(resource, "addon")
        for j = 0, files - 1 do
            local x = GetResourceMetadata(resource, "addon", j)
            if x and x:find("yes") then
                Addon = resource
                break
            end
        end
        if Addon then break end
    end
end

if IsDuplicityVersion() then
    print(("[^2INFO^0] the module ^5bypassNative^0 by addon is loaded into ^5%s^0 successfully!"):format(tostring(resourceName)))
    local setEntityCoords = SetEntityCoords
    local setEntityVisible = SetEntityVisible
    SetEntityCoords = function (...)
        local entity = ...
        local source = NetworkGetEntityOwner(entity)
        if not pcall(function ()
            return exports[Addon]:SafeSetEntityCoords(source, true, resourceName)
        end) then print('[^3WARN^0] EasyBypass is disabled^0') end
        setEntityCoords(...)
        Citizen.SetTimeout(1000,function ()
            if not pcall(function ()
                return exports[Addon]:SafeSetEntityCoords(source, false, resourceName)
            end) then print('[^3WARN^0] EasyBypass is disabled^0') end
        end)
    end
    SetEntityVisible = function (...)
        local entity, toggle = ...
        local source = NetworkGetEntityOwner(entity)
        if not pcall(function ()
            return exports[Addon]:SafeSetEntityVisible(source, not toggle, resourceName)
        end) then print('[^3WARN^0] EasyBypass is disabled^0') end
        setEntityVisible(...)
    end
else
    local setEntityCoords = SetEntityCoords
    local setVehicleFixed = SetVehicleFixed
    local setEntityVisible = SetEntityVisible
    SetEntityCoords = function (...)
        TriggerServerEvent("fg:addon:SetTempPermission:BypassTeleport", true, resourceName)
        setEntityCoords(...)
        Citizen.SetTimeout(1000, function ()
            TriggerServerEvent("fg:addon:SetTempPermission:BypassTeleport", false, resourceName)
        end)
    end
    SetVehicleFixed = function (...)
        TriggerServerEvent("fg:addon:SetTempPermission:BypassVehicleFixAndGodMode", true, resourceName)
        setVehicleFixed(...)
        Citizen.SetTimeout(1000, function ()
            TriggerServerEvent("fg:addon:SetTempPermission:BypassVehicleFixAndGodMode", false, resourceName)
        end)
    end
    SetEntityVisible = function (...)
        local _, toggle = ...
        TriggerServerEvent("fg:addon:SetTempPermission:BypassInvisible", not toggle, resourceName)
        setEntityVisible(...)
    end
end
