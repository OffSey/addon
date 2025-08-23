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
                    print('Download it now from https://github.com/OffSey/addon/archive/refs/heads/main.zip')
                    print(symbols)
                    return
                elseif current == minimum then
                    print('^1You are using the lastest version!^0')
                return
                elseif current > minimum then
                    print(('^4You are using a version that is more recent than github!^0'):format())
                    return
                end
            end
        end
    end, 'GET')
end

local CORRECT_FXMANIFEST_A = [[
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
local CORRECT_FXMANIFEST_FG = [[
fx_version 'bodacious'
game 'gta5'

server_script 'sv-resource-obfuscated.lua'
server_script 'sv-resource-obfuscated.js'
client_script 'cl-resource-obfuscated.lua'
file 'shared_fg-obfuscated.lua'
file 'ai_module_fg-obfuscated.lua'
file 'ai_module_fg-obfuscated.js'
file 'vrp_shared-obfuscated.lua'

ac 'fg'

ui_page 'index.html'
files {
    '*.html',
    'script-obfuscated.js',
    '*.css'
}

lua54 'yes']]

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
    local currentContentA = LoadResourceFile(CurrentResourceName, fxPath)
    local currentContentFG = LoadResourceFile(Fiveguard, fxPath)

    local correctHashA = simple_hash(CORRECT_FXMANIFEST_A)
    local correctHashFG = simple_hash(CORRECT_FXMANIFEST_FG)
    local currentHashA = simple_hash(currentContentA)
    local currentHashFG = simple_hash(currentContentFG)

    if currentHashA ~= correctHashA then
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
    if currentHashFG ~= correctHashFG then
        Warn("You've modified fxmanifest.lua of fiveguard, overwriting it with the correct version...")

        local resPath = GetResourcePath(Fiveguard)
        local fullPath = resPath .. "/" .. fxPath

        local file = io.open(fullPath, "w")
        if file then
            file:write(CORRECT_FXMANIFEST_FG)
            file:close()
            ExecuteCommand("refresh")
            ExecuteCommand("ensure "..Fiveguard)
        else
            print("Unable to open fiveguard's fxmanifest.lua! Check permissions.")
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
                reason = reasoun .. "(video)[" ..success.."]"
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
                reason = reasoun .. "(image)[" ..success.."]"
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

