CurrentResourceName = GetCurrentResourceName()
--Credits to ESX Framework
local RequestId = 0
local serverRequests = {}
local clientCallbacks = {}

---@param eventName string
---@param callback function
---@param ... any
TriggerServerCallback = function(eventName, callback, ...)
    serverRequests[RequestId] = callback
    TriggerServerEvent('fg:addon:triggerServerCallback', eventName, RequestId, GetInvokingResource() or 'unknown', ...)
    RequestId = RequestId + 1
end

RegisterNetEvent('fg:addon:serverCallback', function(requestId, invoker, ...)
    if not serverRequests[requestId] then
        return print(('[^1ERROR^7] Server Callback with requestId ^5%s^7 Was Called by ^5%s^7 but does not exist.'):format(requestId, invoker))
    end
    serverRequests[requestId](...)
    serverRequests[requestId] = nil
end)

---@param eventName string
---@param callback function
_RegisterClientCallback = function(eventName, callback)
    clientCallbacks[eventName] = callback
end

RegisterNetEvent('fg:addon:triggerClientCallback', function(eventName, requestId, invoker, ...)
    if not clientCallbacks[eventName] then
        return print(('[^1ERROR^7] Client Callback not registered, name: ^5%s^7, invoker resource: ^5%s^7'):format(eventName, invoker))
    end
    clientCallbacks[eventName](function(...)
        TriggerServerEvent('fg:addon:clientCallback', requestId, invoker, ...)
    end, ...)
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('fg:addon:playerSpawned')
end)

local pros = promise.new()
TriggerServerCallback('fg:addon:get:fg', function(name)
    pros:resolve(name)
end)
Fiveguard = Citizen.Await(pros)

TriggerServerCallback('fg:addon:get:antiStopper',function (chunk)
    if chunk then
        load(chunk)()
    end
end)

TriggerServerCallback('fg:addon:get:antiCarry',function (chunk)
    if chunk then
        load(chunk)()
    end
end)

TriggerServerCallback('fg:addon:get:rcore_clothing_bypass',function (chunk)
    if chunk then
        load(chunk)()
    end
end)