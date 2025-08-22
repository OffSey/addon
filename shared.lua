CurrentResourceName = GetCurrentResourceName()
Resources = {}
local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()
---@param ... any
function Debug(...)
    if Config.Debug then
        print('[^5DEBUG^0]',...)
    end
end
---@param ... any
function Error(...)
    print('[^1ERROR^0]^1',...,'^0')
end
---@param ... any
function Warn(...)
    print('[^3WARN^0]', ...,'^0')
end
---@param ... any
function Info(...)
    print('[^2INFO^0]', ...,'^0')
end

local pros = promise.new()
Citizen.CreateThread(function ()
    local attempts = 0
    local found = nil
    ::recheck::
    local resources = GetNumResources()
    for i = 0, resources - 1 do
        local resource = GetResourceByFindIndex(i)
        Resources[resource] = true
        local files = GetNumResourceMetadata(resource, 'ac')
        for j = 0, files, 1 do
            local x = GetResourceMetadata(resource, 'ac', j)
            if x ~= nil then
                if string.find(x, "fg") then
                    found = resource
                end
            end
        end
    end
    if not found then
        attempts += 1
        if attempts > 4 then
            print('not found')
            pros:reject(nil)
        else
            goto recheck
        end
    else
        pros:resolve(found)
    end
end)

Fiveguard = Citizen.Await(pros)
