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
    print('[^3WARNING^0]', ...,'^0')
end

---@param ... any
function Info(...)
    print('[^2INFO^0]', ...,'^0')
end

---@return string | nil
local function getFiveguardName()
    local resources = GetNumResources()
    for i = 0, resources - 1 do
        local resource = GetResourceByFindIndex(i)
        local files = GetNumResourceMetadata(resource, 'ac')
        for j = 0, files, 1 do
            local x = GetResourceMetadata(resource, 'ac', j)
            if x ~= nil then
                if string.find(x, "fg") then
                    return resource
                end
            end
        end
    end
end

Fiveguard = getFiveguardName()

if not Fiveguard then
    local attempts = 0
    while attempts < 20 do
        if Fiveguard then
            break
        else
            getFiveguardName()
            attempts += 1
        end
        Wait(100)
    end
    for _, cfg in pairs(Config) do
        if type(cfg) == "table" then
            if cfg.enable then
                cfg.enable = false
            end
        end
    end
    Error('This is an addon for fiveguard, seems like you dont have it, purchase it now on https://fiveguard.net/#pricing')
else
    local attempts = 1
    Debug('Fiveguard is: ^3'..Fiveguard..'^0')
    SetConvar('ac', Fiveguard)
    ::recheckFG::
    if GetResourceState(Fiveguard) == 'started' then
        Info('Fiveguard linked ^2successfully^0!')
    else
        StartResource(Fiveguard)
        Error('Seems like you didn\'t start ^3'..Fiveguard..'^1 before this resource\nMake sure to start ^3'..Fiveguard..'^1 as first resource in your server.cfg for better compatibility with your scripts!')
        Info('Trying to start ^3'..Fiveguard..'^0 (attempt: '..attempts..')^0')
        attempts += 1
        if attempts < 3 then goto recheckFG end
        for _, cfg in pairs(Config) do
            if type(cfg) == "table" then
                if cfg.enable then
                    cfg.enable = false
                end
            end
        end
        Error('Failed to start ^3'..Fiveguard..'^1 (attempts: '..attempts..')')
    end
end

if Config.txAdminPermissions.enable or Config.AcePermissions.enable or Config.FrameworkPermissions.enable then
    local PermsTable = {}
    if IsPrincipalAceAllowed(CurrentResourceName,'fg_addon') then
        Debug(CurrentResourceName..' already have perms')
    else
        ExecuteCommand("add_ace fg.addon command allow")
        ExecuteCommand(("add_principal resource.%s fg.addon"):format(CurrentResourceName))
    end
    if (Config.txAdminPermissions.enable and Config.AcePermissions.enable) or (Config.AcePermissions.enable and Config.FrameworkPermissions.enable) or (Config.txAdminPermissions.enable and Config.FrameworkPermissions.enable) then
        Config.txAdminPermissions.enable = false
        Config.FrameworkPermissions.enable = false
        Config.AcePermissions.enable = true
        Error('Do not use multple permission system at same time!^0\nPermission configored to use ACE')
        PermsReady = true
    else
        PermsReady = true
    end
    ---@param source number|string
    ---@param group string
    ---@param enable boolean
    function SetPermission(source, group, enable)
        Debug('[SetPermission]', source, group, enable, PermsTable[source]?.group)
        if not group or type(group) ~= "string" then return Error('Group not valid or not exist') end
        if group == 'user' then return Debug(("Ignored player: [^5%s^0] ^5%s^0 since he's: ^5%s^0"):format(source, GetPlayerName(source), group)) end
        -- local identifier = GetPlayerIdentifier(source, 0) or PermsTable[source]?.identifier
        Debug('[SetPermission]', json.encode(PermsTable[source], {indent=true}))
        if source ~= 0 then
            if enable then
                -- if IsPlayerAceAllowed(source, group) then --removed since cfx break logic
                --     return Warn(("Player: [^5%s^0] ^5%s^0 already have permissions for fg.^5%s^0, ignored"):format(source, GetPlayerName(source), group))
                -- end
                if PermsTable[source] and PermsTable[source]?.group ~= group then
                    local oldGroup = PermsTable[source]?.group
                    ExecuteCommand(("remove_principal player.%s fg.%s"):format(source, oldGroup))
                    PermsTable[source] = nil
                    ExecuteCommand(("add_principal player.%s fg.%s"):format(source, group))
                    PermsTable[source] = { group = group }
                    return Info(("Permissions for player: [^5%s^0] ^5%s^0 was registered with the group ^5%s^0, overriding permissions to ^5%s^0"):format(source, GetPlayerName(source), oldGroup, group))
                elseif PermsTable[source] and PermsTable[source]?.group == group then
                    Warn(("Player: [^5%s^0] ^5%s^0 already have permissions for fg.^5%s^0, ignored"):format(source, GetPlayerName(source), group))
                else
                    ExecuteCommand(("add_principal player.%s fg.%s"):format(source, group))
                    PermsTable[source] = { group = group }
                    return Info(("Permissions ^2granted^0 to player: [^5%s^0] ^5%s^0 Group: ^5%s^0"):format(source, GetPlayerName(source), group))
                end
            else
                -- if not IsPlayerAceAllowed(source, group) then --removed since cfx break logic
                --     return Warn(("Player: [^5%s^0] ^5%s^0 already don't have permissions for fg.^5%s^0, ignored"):format(source, GetPlayerName(source), group))
                -- end
                ExecuteCommand(("remove_principal player.%s fg.%s"):format(source, group))
                PermsTable[source] = nil
                return Debug(("Permissions ^1removed^0 from player: [^5%s^0] ^5%s^0 Group: ^5%s^0"):format(source, GetPlayerName(source), group))
            end
        else
            return Error(("Invalid player: [^5%s^0] ^5%s^0"):format(source, GetPlayerName(source)))
        end
    end
    AddEventHandler('onResourceStop', function(res)
        if CurrentResourceName ~= res then return end
        for source, v in pairs(PermsTable) do
            if PermsTable[source]?.group then
                ExecuteCommand(("remove_principal player.%s fg.%s"):format(source, v.group))
                PermsTable[source] = nil
            end
        end
        ExecuteCommand(("remove_principal resource.%s fg.addon"):format(CurrentResourceName))
        ExecuteCommand("remove_ace fg.addon command allow")
    end)
end

local forbiddenPatterns = {
    "fg",
    "ac",
    "anticheat",
    "fiveguard",
    "security",
    "guard",
}

local function checkResourceNames()
    local resourceName = string.lower(CurrentResourceName)
    for i = 1, #forbiddenPatterns do
        local pattern = string.lower(forbiddenPatterns[i])
        if string.find(resourceName, pattern) then
            Error("The resource '" .. resourceName .. "' contains a forbidden pattern: '" .. pattern .. "'. Please change its name.")
        end
    end
end

local function checkVersion()
    local resource = CurrentResourceName
    local currentVersion = GetResourceMetadata(resource, 'version', 0)
	if currentVersion then
		currentVersion = currentVersion:match('%d+%.%d+%.%d+')
	end
	if not currentVersion then return Error(("Unable to determine current resource version for '%s'"):format(resource)) end
    PerformHttpRequest('https://raw.githubusercontent.com/OffSey/OffSey_AssetsVersions/master/addon.txt',function(error, result, headers)
        if error ~= 200 then
            return Error(('Version check failed, Error: %s'):format(error))
        end

        local response = json.decode(result)
        local latestVersion = response.version:match('%d+%.%d+%.%d+')
		if not latestVersion or latestVersion == currentVersion then return end

        local cv = { string.strsplit('.', currentVersion) }
        local lv = { string.strsplit('.', latestVersion) }
        for i = 1, #cv do
            local current, minimum = tonumber(cv[i]), tonumber(lv[i])
            if current ~= minimum then
                if current < minimum then
                    local symbols = '^9'
                    for cd = 1, 26+#'Fiveguard-Addon-Package' do
                        symbols = symbols..'='
                    end
                    symbols = symbols..'^0'
                    print(symbols)
                    print(('New update available! ^0\nCurrent Version: ^1%s^0.\nNew Version: ^2%s^0.\nNote of changes: ^5%s^0.\n\n^5Download it now on the OffSey github^0.'):format(currentVersion,latestVersion,response.news))
                    print(symbols)
                    return
                elseif current == minimum then
                    print('^1You are using the lastest version!^0')
                return
                end
            end
        end
    end, 'GET')
end

Citizen.CreateThread(function()
    if Config.txAdminPermissions.enable or Config.AcePermissions.enable or Config.FrameworkPermissions.enable then
        while not PermsReady do Wait(0) end
    end
    local string = '============= Fiveguard Addon ============='
    for key, value in pairs(Config) do
        if type(value) == "table" then
            if value.enable then
                string = string .. '\n' .. key .. ' is ^2enabled^0'
            else
                string = string .. '\n' .. key .. ' is ^1disabled^0'
            end
        end
    end
    string = string .. '\n==========================================='
    checkResourceNames()
    if Config.CheckUpdates then
        Citizen.SetTimeout(2000, checkVersion)
    end
    print(string)
end)
