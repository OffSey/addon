local a1 = GetCurrentResourceName()
if a1 == CurrentResourceName then return end
if IsDuplicityVersion() then
    print("[^2INFO^0] the module ^5bypassNative^0 by addon is loaded into "..tostring(a1).." successfully!")
    local setEntityCoords = SetEntityCoords
    SetEntityCoords = function (entity,...)
        local source = NetworkGetEntityOwner(entity)
        exports[Fiveguard]:SetTempPermission(source,"Client","BypassTeleport",true)
        setEntityCoords(entity,...)
        Citizen.SetTimeout(100,function ()
            exports[Fiveguard]:SetTempPermission(source,"Client","BypassTeleport",false)
        end)
    end
    local setEntityVisible = SetEntityVisible
    SetEntityVisible = function (entity,toogle,...)
        local source = NetworkGetEntityOwner(entity)
        exports[Fiveguard]:SetTempPermission(source,"Client","BypassInvisible",not toogle)
        return setEntityVisible(entity,toogle,...)
    end
else
    local setEntityCoords = SetEntityCoords
    SetEntityCoords = function (entity,...)
        local s = pcall(function ()
            return exports[Fiveguard]:ExecuteServerEvent("fg:addon:SetTempPermission:BypassTeleport",true,a1)
        end)
        if not s then TriggerServerEvent("fg:addon:SetTempPermission:BypassTeleport",true,a1) end
        setEntityCoords(entity,...)
        Citizen.SetTimeout(1000,function ()
            local sb = pcall(function ()
                return exports[Fiveguard]:ExecuteServerEvent("fg:addon:SetTempPermission:BypassTeleport",false,a1)
            end)
            if not sb then TriggerServerEvent("fg:addon:SetTempPermission:BypassTeleport",false,a1) end
        end)
    end
    local setEntityVisible = SetEntityVisible
    SetEntityVisible = function (entity,toogle,...)
        local s = pcall(function ()
            return exports[Fiveguard]:ExecuteServerEvent("fg:addon:SetTempPermission:BypassInvisible",not toogle,a1)
        end)
        if not s then TriggerServerEvent("fg:addon:SetTempPermission:BypassInvisible",not toogle,a1) end
        return setEntityVisible(entity,toogle,...)
    end
end
