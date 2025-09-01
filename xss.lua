local a1 = GetCurrentResourceName()
if a1 == CurrentResourceName then return end
----------------------------   
--          BETA          --
----------------------------
if IsDuplicityVersion() then
    print("[^2INFO^0] the module ^5xss^0 by addon is loaded into "..tostring(a1).." successfully!")
    local _registerNetEvent = RegisterNetEvent
    local _addEventHandler = AddEventHandler
    local function sanitizer(...)
        local nowcleandata = {}
        for _, input in ipairs({...}) do
            local sanitizepaylodsz = input
            if type(imput) == "string" then
                sanitizepaylodsz = string.gsub(input, "<meta.-/>", "")
                sanitizepaylodsz = string.gsub(sanitizepaylodsz, "<script.-</script>", "")
                sanitizepaylodsz = string.gsub(sanitizepaylodsz, "<.*?>", "")
            end
            table.insert(nowcleandata, sanitizepaylodsz)
        end
        return nowcleandata
    end
    RegisterNetEvent = function (name, ...)
        local nowcleandata = sanitizer(...)
        return _registerNetEvent(name, table.unpack(nowcleandata))
    end
    RegisterServerEvent = function (name, ...)
        local nowcleandata = sanitizer(...)
        return _registerNetEvent(name, table.unpack(nowcleandata))
    end
    AddEventHandler = function (name, ...)
        local nowcleandata = sanitizer(...)
        return _addEventHandler(name, table.unpack(nowcleandata))
    end
end
