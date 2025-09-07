local resourceName = GetCurrentResourceName()
if resourceName == CurrentResourceName then return end

if IsDuplicityVersion() then
    print(("[^2INFO^0] the module ^5xss^0 by addon is loaded into ^5%s^0 successfully!"):format(tostring(resourceName)))

    local _RegisterNetEvent     = RegisterNetEvent
    local _RegisterServerEvent  = RegisterServerEvent
    local _AddEventHandler      = AddEventHandler

    local function escape_html(s)
        if not s:find("[%z\1-\8\11\12\14-\31\127]") and not s:find("[&<>'\"]") then
            return s
        end
        return s:gsub("[%z\1-\8\11\12\14-\31\127]", ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"):gsub("'", "&#39;")
    end
    local function sanitize_deep(v, seen)
        if type(seen) ~= "table" then seen = setmetatable({}, { __mode = "k" }) end
        local t = type(v)
        if t == "string" then return escape_html(v)
        elseif t == "table" then
            if getmetatable(v) ~= nil then return v end
            local cached = seen[v]
            if cached then return cached end
            local out = {}
            seen[v] = out
            for k, val in pairs(v) do
                out[k] = sanitize_deep(val, seen)
            end
            return out
        else
            return v
        end
    end
    RegisterNetEvent = function(name, cb)
        if type(cb) ~= "function" then
            return _RegisterNetEvent(name, cb)
        end
        return _RegisterNetEvent(name, function(...)
            local argc = select("#", ...)
            if argc == 0 then
                return cb(...)
            end
            local sanitized = {}
            for i = 1, argc do
                sanitized[i] = sanitize_deep(select(i, ...))
            end
            return cb(table.unpack(sanitized, 1, argc))
        end)
    end
    RegisterServerEvent = function(name, cb)
        if type(cb) ~= "function" then
            return _RegisterServerEvent(name, cb)
        end
        return _RegisterServerEvent(name, function(...)
            local argc = select("#", ...)
            if argc == 0 then
                return cb(...)
            end
            local sanitized = {}
            for i = 1, argc do
                sanitized[i] = sanitize_deep(select(i, ...))
            end
            return cb(table.unpack(sanitized, 1, argc))
        end)
    end
    AddEventHandler = function(name, cb)
        if type(cb) ~= "function" then
            return _AddEventHandler(name, cb)
        end
        return _AddEventHandler(name, function(...)
            local argc = select("#", ...)
            if argc == 0 then
                return cb(...)
            end
            local sanitized = {}
            for i = 1, argc do
                sanitized[i] = sanitize_deep(select(i, ...))
            end
            return cb(table.unpack(sanitized, 1, argc))
        end)
    end
end
