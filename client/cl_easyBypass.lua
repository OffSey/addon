local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.EasyBypass
if not Config.enable then return end
while not READY do Citizen.Wait(0) end
local R_EVENTS = {}

local setAutoBypass = function(se, ee, bp, useBooleanArg)
    if not se or not bp then return end
    if R_EVENTS[se] then return Warn(('Event %s is already registered'):format(se)) end
    if ee then
        R_EVENTS[se] = AddEventHandler(se, function()
            TriggerServerEvent(('fg:addon:%s'):format(se))
        end)
        if R_EVENTS[ee] then return Warn(('Event %s is already registered'):format(ee)) end
        R_EVENTS[ee] = AddEventHandler(ee, function()
            TriggerServerEvent(('fg:addon:%s'):format(ee))
        end)
    else
        if useBooleanArg then
            R_EVENTS[se] = AddEventHandler(se, function(bol)
                TriggerServerEvent(('fg:addon:%s'):format(se), bol)
            end)
        else
            R_EVENTS[se] = AddEventHandler(se, function()
                TriggerServerEvent(('fg:addon:%s'):format(se))
                Citizen.Wait(5000)
                TriggerServerEvent(('fg:addon:%s'):format(ee))
            end)
        end
    end
end

do
    for startEvent, value in pairs(Config.onClientTrigger) do
        if type(value) ~= "table" then return Error("Can't load bypasses config") end
        if not value.enable then goto continue end
        if value.endEvent == false then
            setAutoBypass(startEvent, nil, value.bypass, false)
        elseif startEvent == value.endEvent then
            setAutoBypass(startEvent, nil, value.bypass, true)
        else
            setAutoBypass(startEvent, value.endEvent, value.bypass)
        end
        ::continue::
    end
end

AddEventHandler('onResourceStop', function(res)
    if CurrentResourceName ~= res then return end
    for _, value in pairs(R_EVENTS) do
        if value then
            RemoveEventHandler(value)
        end
    end
end)
