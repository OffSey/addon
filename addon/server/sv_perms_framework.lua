---@diagnostic disable: undefined-field, need-check-nil
local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.FrameworkPermissions
while not Fiveguard do Wait(0) end
while not PermsReady do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

local string = ''
for group, groupConfig in pairs(Config.groups) do
    for i = 1 , #groupConfig do
        if IsPrincipalAceAllowed(('fg.%s'):format(group),groupConfig[i]) then
            string = string..'\n\tIgnored permission "'..groupConfig[i]..'" for group "'..group..'". Already Registered!'
        else
            ExecuteCommand(("add_ace fg.%s %s allow"):format(group, groupConfig[i]))
        end
    end
end
if string.len(string) > 10 then Error(string) end

local frameworkDetected = ''
if not Config.customFramework.enable then
    if GetResourceState('es_extended') == 'started' then
        frameworkDetected = 'es_extended'
        local ESX = exports.es_extended:getSharedObject()
        AddEventHandler('esx:playerLoaded', function(source, xPlayer)
            Debug('[esx:playerLoaded]',GetInvokingResource(),source, xPlayer)
            if GetInvokingResource() ~= 'es_extended' then return Warn(source,'tried to exploit esx:playerLoaded') end
            local fgGroup = xPlayer.getGroup()
            SetPermission(source, fgGroup, true)
        end)
        AddEventHandler('esx:playerDropped', function(playerId, reason)
            Debug('[esx:playerDropped]',GetInvokingResource(),playerId, reason)
            if GetInvokingResource() ~= 'es_extended' then return Warn(source,'tried to exploit esx:playerDropped') end
            local xPlayer = ESX.GetPlayerFromId(playerId)
            local fgGroup = xPlayer.getGroup()
            SetPermission(playerId, fgGroup, false)
          end)
        AddEventHandler("esx:setGroup",function(playerId, group, lastGroup)
            Debug('[esx:setGroup]',GetInvokingResource(),playerId, group, lastGroup)
            if GetInvokingResource() ~= 'es_extended' then return Warn(source,'tried to exploit esx:setGroup') end
            SetPermission(playerId, lastGroup, false)
            SetPermission(playerId, group, true)
        end)
    elseif GetResourceState('qbx_core') == 'started' then
        frameworkDetected = 'qbx_core'
        -- RegisterNetEvent('QBCore:Server:OnPlayerLoaded',function(source)
        --     Debug('[QBCore:Server:OnPlayerLoaded]',GetInvokingResource(),source)
        --     if GetInvokingResource() ~= 'qbx_core' then return Warn(source,'tried to exploit QBCore:Server:OnPlayerLoaded') end
        --     for group,_ in pairs(Config.groups) do
        --         if IsPlayerAceAllowed(source, group) then
        --             SetPermission(source, group, true)
        --             break
        --         end
        --     end
        -- end)
        AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
            Debug('[QBCore:Server:PlayerLoaded]',GetInvokingResource(),Player.PlayerData.source)
            if GetInvokingResource() ~= 'qbx_core' then return Warn(source,'tried to exploit QBCore:Server:PlayerLoaded') end
            for group,_ in pairs(Config.groups) do
                if IsPlayerAceAllowed(Player.PlayerData.source, group) then
                    SetPermission(Player.PlayerData.source, group, true)
                    break
                -- else
                --     Debug('[QBCore:Server:PlayerLoaded] Group not found ', group)
                end
            end
        end)
        RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(source)
            Debug('[QBCore:Server:OnPlayerUnload]',GetInvokingResource(),source)
            if GetInvokingResource() ~= 'qbx_core' then return Warn(source,'tried to exploit QBCore:Server:OnPlayerUnload') end
            for group,_ in pairs(Config.groups) do
                if IsPlayerAceAllowed(source, group) then
                    SetPermission(source, group, false)
                    break
                end
            end
        end)
        AddEventHandler('QBCore:Server:OnPermissionUpdate', function(source)
            Debug('[QBCore:Server:OnPermissionUpdate]',GetInvokingResource(),source)
            if GetInvokingResource() ~= 'qbx_core' then return Warn(source,'tried to exploit QBCore:Server:OnPermissionUpdate') end
            for group,_ in pairs(Config.groups) do
                if IsPlayerAceAllowed(source, group) then
                    SetPermission(source, group, true)
                else
                    SetPermission(source, group, false)
                end
            end
        end)
        AddEventHandler('qbx_core:server:onGroupUpdate', function(source, groupName, groupGrade)
            Debug('[qbx_core:server:onGroupUpdate]',GetInvokingResource(),source, groupName, groupGrade)
            if GetInvokingResource() ~= 'qbx_core' then return Warn(source,'tried to exploit qbx_core:server:onGroupUpdate') end
            for group,_ in pairs(Config.groups) do
                if IsPlayerAceAllowed(source, group) then
                    SetPermission(source, group, true)
                elseif not IsPlayerAceAllowed(source, group) then
                    SetPermission(source, group, false)
                end
            end
        end)
    elseif GetResourceState('qb-core') == 'started' then
        frameworkDetected = 'qb-core'
        if not IsPrincipalAceAllowed('qbcore.god','group.admin') then
            ExecuteCommand('add_principal qbcore.god group.admin')
        end
        AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
            Debug('[QBCore:Server:PlayerLoaded]',GetInvokingResource(),Player.PlayerData.source)
            if GetInvokingResource() ~= 'qb-core' then return Warn(source,'tried to exploit QBCore:Server:PlayerLoaded') end
            for group,_ in pairs(Config.groups) do
                if IsPlayerAceAllowed(Player.PlayerData.source, group) then
                    SetPermission(Player.PlayerData.source, group, true)
                    break
                -- else
                --     Debug('[QBCore:Server:PlayerLoaded] Group not found ', group)
                end
            end
        end)
        AddEventHandler('QBCore:Server:OnPlayerUnload', function()
            Debug('[QBCore:Server:OnPlayerUnload]',GetInvokingResource(),source)
            if GetInvokingResource() ~= 'qb-core' then return Warn(source,'tried to exploit QBCore:Server:OnPlayerUnload') end
            for group,_ in pairs(Config.groups) do
                if IsPlayerAceAllowed(source, group) then
                    SetPermission(source, group, false)
                    break
                end
            end
        end)
    elseif GetResourceState('vrp') == 'started' then
        frameworkDetected = 'vrp'
        local chunk, vRP = LoadResourceFile('vrp','lib/utils.lua')
        if chunk then
            load(chunk)()
            ---@diagnostic disable-next-line: deprecated
            local Proxy = module("vrp", "lib/Proxy")
            vRP = Proxy.getInterface("vRP")
        end
        AddEventHandler("vRP:playerJoin",function(user_id, playerId, name, tmpdata)
            Debug('[vRP:playerJoin]',GetInvokingResource(),user_id, playerId, name, tmpdata)
            if GetInvokingResource() ~= 'vrp' then return Warn(source,'tried to exploit vRP:playerJoin') end
            for group, _ in pairs(Config.groups) do
                if vRP.hasGroup(user_id, group) then
                    SetPermission(playerId, group, true)
                    break
                end
            end
        end)
        AddEventHandler("vRP:playerJoinGroup", function(user_id, group, gtype)
            Debug('[vRP:playerJoinGroup]',GetInvokingResource(),user_id, group, gtype)
            if GetInvokingResource() ~= 'vrp' then return Warn(source,'tried to exploit vRP:playerJoinGroup') end
            for group, _ in pairs(Config.groups) do
                if vRP.hasGroup(user_id, group) then
                    local playerId = vRP.getUserSource(user_id)
                    SetPermission(playerId, group, true)
                    break
                end
            end
        end)
        AddEventHandler("vRP:playerLeaveGroup", function(user_id, group, gtype)
            Debug('[vRP:playerLeaveGroup]',GetInvokingResource(),user_id, group, gtype)
            if GetInvokingResource() ~= 'vrp' then return Warn(source,'tried to exploit vRP:playerLeaveGroup') end
            for group, _ in pairs(Config.groups) do
                if vRP.hasGroup(user_id, group) then
                    local playerId = vRP.getUserSource(user_id)
                    SetPermission(playerId, group, false)
                    break
                end
            end
        end)
        AddEventHandler("vRP:playerLeave", function(user_id, playerId)
            Debug('[vRP:playerLeave]',GetInvokingResource(),user_id, playerId)
            if GetInvokingResource() ~= 'vrp' then return Warn(source,'tried to exploit vRP:playerLeave') end
            for group, _ in pairs(Config.groups) do
                ---@diagnostic disable-next-line: undefined-field
                if vRP.hasGroup(user_id, group) then
                    SetPermission(playerId, group, false)
                    break
                end
            end
        end)
    else
        Error('Framework not detected, make sure to start this script after your framework!\nIf u have a custom framework configure it in the config.lua file.')
    end
else
    AddEventHandler(tostring(Config.customEvent),function(playerId,group,allow)
        frameworkDetected = GetInvokingResource()
        Debug('[customEvent]', GetInvokingResource())
        if Config.invokerResource and Config.invokerResource:len() > 4 then
            if GetInvokingResource() ~= Config.invokerResource then return Warn(source,'tried to exploit '..Config.customEvent) end
        else
            Warn('Make sure to config "Config.FrameworkPermissions.invokerResource" for you custom framework, without it the event can be exploitable by cheaters!')
        end
        if not (playerId and group and allow) then
            return Error('[Framework Permission] Bad config for custom framework')
        end
        SetPermission(playerId, group, allow)
    end)
end

Debug('Franework is: ^3'..frameworkDetected..'^0')

AddEventHandler('onResourceStop', function(res)
    if (CurrentResourceName ~= res) then return end
    for group, groupConfig in pairs(Config.groups) do
        for i = 1 , #groupConfig do
            ExecuteCommand(("remove_ace fg.%s %s allow"):format(group, groupConfig[i]))
        end
    end
    if frameworkDetected == 'qb' then
        ExecuteCommand('remove_principal qbcore.god group.admin')
    end
end)

AddEventHandler('onResourceStop', function(res)
    if  (res ~= frameworkDetected) then return end
    for group, groupConfig in pairs(Config.groups) do
        for i = 1 , #groupConfig do
            ExecuteCommand(("remove_ace fg.%s %s allow"):format(group, groupConfig[i]))
        end
    end
    if frameworkDetected == 'qb' then
        ExecuteCommand('remove_principal qbcore.god group.admin')
    end
end)

-- AddEventHandler('onResourceStop', function(res)
--     if  (res ~= Fiveguard) then return end
--     for group, groupConfig in pairs(Config.groups) do
--         for i = 1 , #groupConfig do
--             ExecuteCommand(("remove_ace group.%s_fg %s allow"):format(group, groupConfig[i]))
--         end
--     end
-- end)
