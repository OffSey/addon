local a1 = GetCurrentResourceName()
if a1 == CurrentResourceName then return end
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
    print(("[^2INFO^0] the module ^5bypassNative^0 by addon is loaded into ^5%s^0 successfully!"):format(tostring(a1)))
    local setEntityCoords = SetEntityCoords
    SetEntityCoords = function (entity, ...)
        local source = NetworkGetEntityOwner(entity)
        local s = pcall(function ()
            exports[Addon]:SafeSetEntityCoords(source, "BypassTeleport", true)
        end)
        if not s then Warn("EasyBypass is disabled") end
        setEntityCoords(entity, ...)
        Citizen.SetTimeout(1000,function ()
            local sb = pcall(function ()
                exports[Addon]:SafeSetEntityCoords(source, "BypassTeleport", false)
        end)
        if not sb then Warn("EasyBypass is disabled") end
        end)
    end
    local setEntityVisible = SetEntityVisible
    SetEntityVisible = function (entity, toogle, ...)
        local source = NetworkGetEntityOwner(entity)
        local s = pcall(function ()
            exports[Addon]:SafeSetEntityVisible(source, "BypassInvisible", not toogle)
        end)
        if not s then Warn("EasyBypass is disabled") end
        return setEntityVisible(entity, toogle, ...)
    end
else
    local setEntityCoords = SetEntityCoords
    SetEntityCoords = function (entity,...)
        local s = pcall(function ()
            return exports[Fiveguard]:ExecuteServerEvent("fg:addon:SetTempPermission:BypassTeleport", true, a1)
        end)
        if not s then TriggerServerEvent("fg:addon:SetTempPermission:BypassTeleport", true, a1) end
        setEntityCoords(entity,...)
        Citizen.SetTimeout(1000,function ()
            local sb = pcall(function ()
                return exports[Fiveguard]:ExecuteServerEvent("fg:addon:SetTempPermission:BypassTeleport", false, a1)
            end)
            if not sb then TriggerServerEvent("fg:addon:SetTempPermission:BypassTeleport", false, a1) end
        end)
    end
    local setVehicleFixed = SetVehicleFixed
    SetVehicleFixed = function (entity)
        local s = pcall(function ()
            return exports[Fiveguard]:ExecuteServerEvent("fg:addon:SetTempPermission:BypassVehicleFixAndGodMode", true, a1)
        end)
        if not s then TriggerServerEvent("fg:addon:SetTempPermission:BypassVehicleFixAndGodMode", true, a1) end
        setVehicleFixed(entity)
        Citizen.SetTimeout(1000,function ()
            local sb = pcall(function ()
                return exports[Fiveguard]:ExecuteServerEvent("fg:addon:SetTempPermission:BypassVehicleFixAndGodMode", false, a1)
            end)
            if not sb then TriggerServerEvent("fg:addon:SetTempPermission:BypassVehicleFixAndGodMode", false, a1) end
        end)
    end
    local setEntityVisible = SetEntityVisible
    SetEntityVisible = function (entity, toogle, ...)
        local s = pcall(function ()
            return exports[Fiveguard]:ExecuteServerEvent("fg:addon:SetTempPermission:BypassInvisible", not toogle, a1)
        end)
        if not s then TriggerServerEvent("fg:addon:SetTempPermission:BypassInvisible", not toogle, a1) end
        return setEntityVisible(entity, toogle,...)
    end
end
