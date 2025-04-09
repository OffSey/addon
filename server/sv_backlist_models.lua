local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.BlacklistedModels
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

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
                    exports[Fiveguard]:fg_BanPlayer(source, "Forbidden model detected: " .. blockedModel, true)
                else
                    ---@diagnostic disable-next-line: param-type-mismatch
                    DropPlayer(source,'[Fiveguard Addon] Forbidden model detected: ' .. blockedModel)
                    ---@diagnostic disable-next-line: param-type-mismatch
                    Info(("Player: [^5%s^0] ^5%s^0 was kicked for using a blacklisted model: ^3" .. blockedModel):format(source, GetPlayerName(source)))
                end
                break
            end
        end
    end
    Citizen.SetTimeout(Config.checkInterval*1000, checkModel)
end
Citizen.SetTimeout(Config.checkInterval*1000, checkModel)

if Config.EnableCrahingPrevent then
    AddEventHandler('entityCreating', function(entity)
    local src = NetworkGetEntityOwner(entity)
    local modelprop = GetEntityModel(entity)
    if modelprop == 1885233650 or modelprop == 310817095 then
        Info(src, "Prevented from crashing lumia", modelprop)
        CancelEvent()
    end
end)

-- RegisterCommand("checkmodel", function(source, args)
--     local target = tonumber(args[1])
--     if target then checkModel(target) end
-- end, true)
