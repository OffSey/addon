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
        for j = 1, #Config.blacklist do
            local blockedModel = Config.blacklist[j]
            if model == GetHashKey(blockedModel) then
                if Config.ban then
                    BanPlayer(source, "Blacklisted model detected: " .. blockedModel, Config.recordPlayer)
                else
                    ---@diagnostic disable-next-line: param-type-mismatch
                    DropPlayer(source,"[FIVEGUARD.NET] You have been kicked")
                    ---@diagnostic disable-next-line: param-type-mismatch
                    Info(("Player: [^5%s^0] ^5%s^0 was kicked for using a blacklisted model: ^3" .. blockedModel):format(source, GetPlayerName(source)))
                end
                break
            end
        end
    end
    Citizen.SetTimeout(Config.checkInterval*1000, checkModel)
end
checkModel()

if Config.enableCrahingPrevent then
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
