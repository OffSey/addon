local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.BlacklistedModels
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

local function checkModel()
    local players = GetPlayers()
    for i = 1, #players do
        local source = tonumber(players[i])
        ---@diagnostic disable-next-line: param-type-mismatch
        local model = GetEntityModel(GetPlayerPed(source))
        if model and Config.blacklist[model] == true then
            PunishPlayer(source, Config.ban, ("Blacklisted model detected: %s"):format(blockedModel), Config.banMedia)
            break
        end
    end
    Citizen.SetTimeout(Config.checkInterval*1000, checkModel)
end
checkModel()

if Config.preventCrashPlayer then
    AddEventHandler('entityCreating', function(entity)
        local src = NetworkGetEntityOwner(entity)
        local modelprop = GetEntityModel(entity)
        if modelprop == 1885233650 or modelprop == 310817095 or modelprop == 1193010354 then
            Info(src, "Prevented from crashing lumia", modelprop)
            CancelEvent()
        end
    end)
end

-- RegisterCommand("checkmodel", function(source, args)
--     local target = tonumber(args[1])
--     if target then checkModel(target) end
-- end, true)
