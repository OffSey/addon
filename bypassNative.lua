local a1 = GetCurrentResourceName()
if a1 == CurrentResourceName then return end
print("addon loaded into "..a1)
if IsDuplicityVersion() then
    local setEntityCoords = SetEntityCoords
    SetEntityCoords = function (entity,...)
        print('SV>>SetEntityCoords',entity,...)
        local source = NetworkGetEntityOwner(entity)
        exports[Fiveguard]:SetTempPermission(source,"Client","BypassTeleport",true)
        setEntityCoords(entity,...)
        Citizen.SetTimeout(100,function ()
            exports[Fiveguard]:SetTempPermission(source,"Client","BypassTeleport",false)
        end)
        return
    end
    local setEntityVisible = SetEntityVisible
    SetEntityVisible = function (entity,toogle,...)
        print('SV>>SetEntityVisible',entity,toogle,...)
        local source = NetworkGetEntityOwner(entity)
        exports[Fiveguard]:SetTempPermission(source,"Client","BypassInvisible",not toogle)
        return setEntityVisible(entity,toogle,...)
    end
else
    local setEntityCoords = SetEntityCoords
    SetEntityCoords = function (entity,...)
        print('CL>>SetEntityCoords',entity,...)
        TriggerServerEvent("fg:addon:SetTempPermission:BypassTeleport",true,a1)
        setEntityCoords(entity,...)
        Citizen.SetTimeout(1000,function ()
            TriggerServerEvent("fg:addon:SetTempPermission:BypassTeleport",false,a1)
        end)
        return
    end
    local setEntityVisible = SetEntityVisible
    SetEntityVisible = function (entity,toogle,...)
        print('CL>>SetEntityVisible',entity,toogle,...)
        TriggerServerEvent("fg:addon:SetTempPermission:BypassInvisible",not toogle,a1)
        return setEntityVisible(entity,toogle,...)
    end
end
