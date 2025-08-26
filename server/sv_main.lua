local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()
READY = false
while not Fiveguard do Citizen.Wait(0) end

local function checkResourceNames()
    local forbiddenPatterns = {
    "fg",
    "ac",
    "anticheat",
    "fiveguard",
    "security",
    "guard",
    }
    local resourceName = string.lower(CurrentResourceName)
    for i = 1, #forbiddenPatterns do
        local pattern = string.lower(forbiddenPatterns[i])
        if string.find(resourceName, pattern) then
            Error("The resource '" .. resourceName .. "' contains a forbidden pattern: '" .. pattern .. "'. Please change its name.")
        end
    end
end

local function checkVersion()
    local function parseVersion(s)
        if not s then return nil end
        local maj, min, pat = s:match("(%d+)%.(%d+)%.?(%d*)")
        if not maj or not min then return nil end
        if pat == "" then pat = "0" end
        return tonumber(maj), tonumber(min), tonumber(pat)
    end
    local function tupleCompare(a1, a2, a3, b1, b2, b3)
        if a1 ~= b1 then return (a1 < b1) and -1 or 1 end
        if a2 ~= b2 then return (a2 < b2) and -1 or 1 end
        if a3 ~= b3 then return (a3 < b3) and -1 or 1 end
        return 0
    end
    local resource = GetCurrentResourceName()
    local currentVersionRaw = GetResourceMetadata(resource, 'version', 0)
    local cMaj, cMin, cPat = parseVersion(currentVersionRaw)
    if not cMaj then
        return Error(("Unable to determine current resource version for '%s' (got '%s')"):format(resource, tostring(currentVersionRaw)))
    end
    local currentVersion = ("%d.%d.%d"):format(cMaj, cMin, cPat)
    PerformHttpRequest('https://raw.githubusercontent.com/OffSey/OffSey_AssetsVersions/master/addon.txt', function(error, result, headers)
        if error ~= 200 then
            return Error(('Version check failed, Error: %s'):format(error))
        end
        local response = json.decode(result)
        local latestRaw = response and response.version
        local lMaj, lMin, lPat = parseVersion(latestRaw)
        if not lMaj then
            return Error(("Invalid latest version in response: '%s'"):format(tostring(latestRaw)))
        end
        local latestVersion = ("%d.%d.%d"):format(lMaj, lMin, lPat)
        local cmp = tupleCompare(cMaj, cMin, cPat, lMaj, lMin, lPat)
        if cmp < 0 then
            local symbols = '^9' .. string.rep('=', 26 + #'Fiveguard Addon') .. '^0'
            print(symbols)
            print(('New update available! ^0\nCurrent Version: ^1%s^0.\nNew Version: ^2%s^0.\nNote of changes:\n^5%s^0.'):format(currentVersion, latestVersion, response.news or '—'))
            print('Download it now from https://github.com/OffSey/addon/archive/refs/heads/main.zip')
            print(symbols)
            return
        elseif cmp == 0 then
            Info('You are using the latest version!')
            return
        else
            Warn('You are using a version that is more recent than github!')
            return
        end
    end, 'GET')
end


local CORRECT_FXMANIFEST = [[
fx_version 'cerulean'
game 'gta5'
version "1.5"
lua54 'yes'
author 'Offsey & Jeakels discord.gg/fiveguard'
description 'Addon pack for fiveguard'

data_file "DLC_ITYP_REQUEST" "stream/mads_no_exp_pumps.ytyp"

shared_script 'shared.lua'

server_scripts {
    'server/sv_resourceManager.js',
    'server/sv_main.lua',
    'server/sv_antiCarry.lua',
    'server/sv_antiExplosion.lua',
    'server/sv_antiPedManipulation.lua',
    'server/sv_antiStopper.lua',
    'server/sv_backlistModels.lua',
    'server/sv_bypass.lua',
    'server/sv_checkNicknames.lua',
    'server/sv_easyPermissions.lua',
    'server/sv_heartBeat.lua',
    'server/sv_nativePermissions.lua',
    'server/sv_vehicleProtection.lua',
    'server/sv_weaponProtection.lua',
}

client_scripts {
    'client/cl_main.lua',
    'client/cl_antiCarry.lua',
    'client/cl_antiPedManipulation.lua',
    'client/cl_antiSafeSpawn.lua',
    'client/cl_antiStopper.lua',
    'client/cl_bypass.lua',
    'client/cl_heartBeat.lua',
    'client/cl_vehicleProtection.lua',
    'client/cl_weaponProtection.lua',
}

file 'config.lua'
file 'xss.lua'
file 'bypassNative.lua'
]]

local function checkAndFixFxmanifest()
    local function simple_hash(s)
        if not s then return nil end
        local h1, h2 = 0, 0
        for i = 1, #s do
            local b = s:byte(i)
            h1 = (h1 + b) % 0x100000000
            h2 = (h2 * 31 + b) % 0x100000000
        end
        return string.format("%08x%08x", h1, h2)
    end
    local fxPath = "fxmanifest.lua"
    local currentContent = LoadResourceFile(CurrentResourceName, fxPath)

    local correctHash = simple_hash(CORRECT_FXMANIFEST)
    local currentHash = simple_hash(currentContent)

    if currentHash ~= correctHash then
        Warn("You've modified fxmanifest.lua, overwriting it with the correct version...")

        local resPath = GetResourcePath(CurrentResourceName)
        local fullPath = resPath .. "/" .. fxPath

        local file = io.open(fullPath, "w")
        if file then
            file:write(CORRECT_FXMANIFEST)
            file:close()
            Info("fxmanifest.lua successfully restored, restart "..CurrentResourceName.." to start!")
            ExecuteCommand("refresh")
        else
            print("Unable to open fxmanifest.lua! Check permissions.")
        end
        return true
    end
    return false
end
local isRecording = {}

function PunishPlayer(source, ban, reason, mediaType)
    Debug(source, reason, mediaType)
    if not ban then return DropPlayer(source,"[FIVEGUARD.NET] You have been kicked") end
    if tostring(mediaType) == "video" then
        if isRecording[source] then Debug(("Ignoring player ban since it's getting banned"):format())return end
        isRecording[source] = true
        if Config.CustomWebhookURL and string.len(Config.CustomWebhookURL) < 80 then
            Config.CustomWebhookURL = nil
        end
        exports[Fiveguard]:recordPlayerScreen(source, Config.RecordTime*1000, function(success)
            if success then
                reason = reasoun .. "(video)[" ..tostring(success).."]"
                Debug("[fiveguard] Record Success" .. source)
                exports[Fiveguard]:fg_BanPlayer(source, reason, true)
            else
                Error("[fiveguard] Record Error" .. source)
                exports[Fiveguard]:fg_BanPlayer(source, reason, true)
            end
        end, Config.CustomWebhookURL)
        Citizen.SetTimeout(Config.RecordTime*1000+100, function()
            isRecording[source] = nil
        end)
    elseif tostring(mediaType) == "image" then
        exports[Fiveguard]:screenshotPlayer(source, function(success)
            if success then
                reason = reasoun .. "(image)[" ..tostring(success).."]"
                Debug("[fiveguard] Screenshot Success" .. source)
                exports[Fiveguard]:fg_BanPlayer(source, reason, true)
            else
                Error("[fiveguard] Screenshot Error" .. source)
                exports[Fiveguard]:fg_BanPlayer(source, reason, true)
            end
        end, Config.CustomWebhookURL)
    else
        exports[Fiveguard]:fg_BanPlayer(source, reason, true)
    end
end
AddEventHandler('playerDropped', function()
    isRecording[source] = nil
end)

Citizen.CreateThread(function()
    if checkAndFixFxmanifest() then
        READY = false
        return
    end
    print(([[
                                          dddddddd            dddddddd                                   
               AAA                        d::::::d            d::::::d                                   
              A:::A                       d::::::d            d::::::d                                   
             A:::::A                      d::::::d            d::::::d                                   
            A:::::::A                     d:::::d             d:::::d                                    
           A:::::::::A            ddddddddd:::::d     ddddddddd:::::d    ooooooooooo   nnnn  nnnnnnnn    
          A:::::A:::::A         dd::::::::::::::d   dd::::::::::::::d  oo:::::::::::oo n:::nn::::::::nn  
         A:::::A A:::::A       d::::::::::::::::d  d::::::::::::::::d o:::::::::::::::on::::::::::::::nn 
        A:::::A   A:::::A     d:::::::ddddd:::::d d:::::::ddddd:::::d o:::::ooooo:::::onn:::::::::::::::n
       A:::::A     A:::::A    d::::::d    d:::::d d::::::d    d:::::d o::::o     o::::o  n:::::nnnn:::::n
      A:::::AAAAAAAAA:::::A   d:::::d     d:::::d d:::::d     d:::::d o::::o     o::::o  n::::n    n::::n
     A:::::::::::::::::::::A  d:::::d     d:::::d d:::::d     d:::::d o::::o     o::::o  n::::n    n::::n
    A:::::AAAAAAAAAAAAA:::::A d:::::d     d:::::d d:::::d     d:::::d o::::o     o::::o  n::::n    n::::n
   A:::::A             A:::::Ad::::::ddddd::::::ddd::::::ddddd::::::ddo:::::ooooo:::::o  n::::n    n::::n
  A:::::A               A:::::Ad:::::::::::::::::d d:::::::::::::::::do:::::::::::::::o  n::::n    n::::n
 A:::::A                 A:::::Ad:::::::::ddd::::d  d:::::::::ddd::::d oo:::::::::::oo   n::::n    n::::n
AAAAAAA                   AAAAAAAddddddddd   ddddd   ddddddddd   ddddd   ooooooooooo     nnnnnn    nnnnnn
version %s                                   By OffSey, Jeakels and contributors. Powered by ^3five^0guard]]):format(GetResourceMetadata(CurrentResourceName, "version", 0)))
    local string = '\n|======== Fiveguard Addon ========|'
    for key, value in pairs(Config) do
        if type(value) == "table" then
            if value.enable then
                string = ('%s\n| %s ^2enabled^0  |'):format(string, key:len()<=13 and key ..'\t\t' or key .. '\t')
            else
                string = ('%s\n| %s ^1disabled^0 |'):format(string, key:len()<=13 and key ..'\t\t' or key .. '\t')
            end
        end
    end
    string = string .. '\n|=================================|'
    checkResourceNames()
    if Config.CheckUpdates then
        Citizen.SetTimeout(2000, checkVersion)
    end
    string = string ..'\n'
    local attempts = 1
    Debug('Fiveguard is: ^3'..Fiveguard..'^0')
    SetConvar('ac', Fiveguard)
    ::recheckFG::
    if GetResourceState(Fiveguard) == 'started' then
        READY = true
        Info('Fiveguard linked ^2successfully^0!')
        print(string)
    else
        StartResource(Fiveguard)
        Error('Seems like you didn\'t start ^3'..Fiveguard..'^1 before this resource\nMake sure to start ^3'..Fiveguard..'^1 as first resource in your server.cfg for better compatibility with your scripts!')
        Info('Trying to start ^3'..Fiveguard..'^0 (attempt: '..attempts..')^0')
        attempts += 1
        if attempts < 3 then goto recheckFG end
        Error(('Failed to start ^3%s^1 (attempts: %s)'):format(Fiveguard,attempts))
        for _, cfg in pairs(Config) do
            if type(cfg) == "table" then
                if cfg.enable then
                    cfg.enable = false
                    READY = false
                end
            end
        end
    end
end)

