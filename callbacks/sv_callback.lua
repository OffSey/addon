CurrentResourceName = GetCurrentResourceName()
--Credits to ESX Framework
local serverCallbacks = {}
local clientRequests = {}
local RequestId = 0

---@param eventName string
---@param callback function
RegisterServerCallback = function(eventName, callback)
    serverCallbacks[eventName] = callback
end

RegisterNetEvent('fg:addon:triggerServerCallback', function(eventName, requestId, invoker, ...)
    if not serverCallbacks[eventName] then
        return print(('[^1ERROR^7] Server Callback not registered, name: ^5%s^7, invoker resource: ^5%s^7'):format(eventName, invoker))
    end
    local source = source
    serverCallbacks[eventName](source, function(...)
        TriggerClientEvent('fg:addon:serverCallback', source, requestId, invoker, ...)
    end, ...)
end)

---@param player number
---@param eventName string
---@param callback function
---@param ... any
TriggerClientCallback = function(player, eventName, callback, ...)
    clientRequests[RequestId] = callback
    TriggerClientEvent('fg:addon:triggerClientCallback', player, eventName, RequestId, GetInvokingResource() or 'unknown', ...)
    RequestId = RequestId + 1
end

RegisterNetEvent('fg:addon:clientCallback', function(requestId, invoker, ...)
    if not clientRequests[requestId] then
        return print(('[^1ERROR^7] Client Callback with requestId ^5%s^7 Was Called by ^5%s^7 but does not exist.'):format(requestId, invoker))
    end
    clientRequests[requestId](...)
    clientRequests[requestId] = nil
end)

RegisterServerCallback('fg:addon:get:fg',function(source,cb)
    while not Fiveguard do Citizen.Wait(0) end
    cb(Fiveguard)
end)

RegisterServerCallback('fg:addon:get:antiStopper',function(source,cb)
    local data = LoadResourceFile(CurrentResourceName,'client/cl_antistopper.lua')
    cb(data)
end)

RegisterServerCallback('fg:addon:get:antiCarry',function(source,cb)
    local data = LoadResourceFile(CurrentResourceName,'client/cl_anticarry.lua')
    cb(data)
end)

RegisterServerCallback('fg:addon:get:rcore_clothing_bypass',function (source,cb)
    local data = LoadResourceFile(CurrentResourceName,'client/cl_rcore_clothing.lua')
    cb(data)
end)

RegisterServerCallback('fg:addon:get:heartbeat',function (source,cb)
    local data = LoadResourceFile(CurrentResourceName,'client/cl_hearbeat.lua')
    cb(data)
end)

RegisterServerCallback('fg:addon:get:antiFreecam', function(source,cb)
    local data = LoadResourceFile(CurrentResourceName,'client/cl_antifreecam.lua')
    cb(data)
end)
