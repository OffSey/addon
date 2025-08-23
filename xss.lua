if CurrentResourceName == GetCurrentResourceName() then return end

if IsDuplicityVersion() then
    print('server')
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

    local _registerNetEvent = RegisterNetEvent
    RegisterNetEvent = function (name, ...)
        -- Debug('RegisterNetEvent',name)
        local nowcleandata = sanitizer(...)
        return _registerNetEvent(name, table.unpack(nowcleandata))
        -- return _registerNetEvent(name, nowcleandata)
    end
    local _addEventHandler = AddEventHandler
    AddEventHandler = function (name, ...)
        -- Debug('AddEventHandler ',name)
        local nowcleandata = sanitizer(...)
        return _addEventHandler(name, table.unpack(nowcleandata))
        -- return _addEventHandler(name, nowcleandata)
    end
end
