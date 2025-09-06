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
Citizen.CreateThread(function()
    local attempts = 0
    local found = nil
    while attempts < 5 and not found do
        local resources = GetNumResources()
        for i = 0, resources - 1 do
            local resource = GetResourceByFindIndex(i)
            Resources[resource] = true
            local files = GetNumResourceMetadata(resource, "ac")
            for j = 0, files - 1 do
                local x = GetResourceMetadata(resource, "ac", j)
                if x:find("fg") then
                    found = resource
                end
            end
        end
        if not found then
            attempts = attempts + 1
            Citizen.Wait(0)
        end
    end
    if found then
        pros:resolve(found)
    else
        pros:reject("Fiveguard not found! Get it on https://discord.gg/gpXNsFe2PE (Fiveguard Italy)")
    end
end)

do
    local success, result = pcall(function()
        return Citizen.Await(pros)
    end)
    if success then
        Fiveguard = result
    else
        Error(result)
    end
end
