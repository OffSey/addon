local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.EasyPermissions
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

if Config.txAdminPermissions.enable or Config.AcePermissions.enable or Config.FrameworkPermissions.enable then
    local PermsTable = {}
    if (IsPrincipalAceAllowed('resource.'..CurrentResourceName,'command.add_ace')) then
        Debug(('The resource ^5%s^0 have permission to manage ACE permissions, good!'):format(CurrentResourceName))
    else
        Error(("%s does not have permission to manage ace permission!\nAdd ^3add_ace resource.%s command allow^1 in your server.cfg"):format(CurrentResourceName,CurrentResourceName))
        return
    end
    if (Config.txAdminPermissions.enable and Config.AcePermissions.enable) or (Config.AcePermissions.enable and Config.FrameworkPermissions.enable) or (Config.txAdminPermissions.enable and Config.FrameworkPermissions.enable) then
        Config.txAdminPermissions.enable = false
        Config.FrameworkPermissions.enable = false
        Config.AcePermissions.enable = true
        Error('Do not use multple permission system at same time!^0\nPermission configored to use ACE')
    end
    ---@param source number|string
    ---@param group string
    ---@param enable boolean
    function SetPermission(source, group, enable)
        Debug('[SetPermission]', source, group, enable, PermsTable[source]?.group)
        if not group or type(group) ~= "string" then return Error('Group not valid or not exist') end
        if group == 'user' then return Debug(("Ignored player: [^5%s^0] ^5%s^0 since he's: ^5%s^0"):format(source, GetPlayerName(source), group)) end
        if source ~= 0 then
            if enable then
                if PermsTable[source] and PermsTable[source]?.group ~= group then
                    local oldGroup = PermsTable[source]?.group
                    ExecuteCommand(("remove_principal player.%s fg.%s"):format(source, oldGroup))
                    PermsTable[source] = nil
                    ExecuteCommand(("add_principal player.%s fg.%s"):format(source, group))
                    PermsTable[source] = { group = group }
                    return Info(("Permissions for player: [^5%s^0] ^5%s^0 was registered with the group ^5%s^0, overriding permissions to ^5%s^0"):format(source, GetPlayerName(source), oldGroup, group))
                elseif PermsTable[source] and PermsTable[source]?.group == group then
                    Warn(("Player: [^5%s^0] ^5%s^0 already have ^5%s^0 group permissions, ignored"):format(source, GetPlayerName(source), group))
                else
                    ExecuteCommand(("add_principal player.%s fg.%s"):format(source, group))
                    PermsTable[source] = { group = group }
                    return Info(("Permissions ^2granted^0 to player: [^5%s^0] ^5%s^0 Group: ^5%s^0"):format(source, GetPlayerName(source), group))
                end
            else
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
    end)
elseif not (Config.txAdminPermissions.enable or Config.AcePermissions.enable or Config.FrameworkPermissions.enable) then
    Config.enable = false
    return
end

if Config.AcePermissions.enable then
    Info('Easy Permissions: using ACE')
    for group, groupConfig in pairs(Config.AcePermissions.groups) do
        local principal = ("group.%s"):format(group)
        local object    = ('has.'..group)
        for i = 1 , #groupConfig do
            if IsPrincipalAceAllowed(('fg.%s'):format(group),groupConfig[i]) then
                Warn(('[ACE Permission] Ignored permission %s for group %s because is already registered'):format(groupConfig[i],group))
            else
                ExecuteCommand(("add_ace fg.%s %s allow"):format(group, groupConfig[i]))
            end
        end
        if not IsPrincipalAceAllowed(principal, object) then
            ExecuteCommand(("add_ace %s %s allow"):format(principal, object))
        end
    end

    AddEventHandler('playerJoining', function()
        if tonumber(source) > 65000 then return end
        for group,_ in pairs(Config.AcePermissions.groups) do
            if IsPlayerAceAllowed(source, 'has.'..group) then
                SetPermission(source, group, true)
                break
            end
        end
    end)

    RegisterNetEvent('fg:addon:playerSpawned', function()
        Debug('[fg:addon:playerSpawned]', source)
        for group, _ in pairs(Config.AcePermissions.groups) do
            if IsPlayerAceAllowed(source, 'has.'..group) then
                SetPermission(source, group, true)
                break
            end
        end
    end)

    AddEventHandler('playerDropped', function()
        Debug('[playerDropped]', source)
        for group,_ in pairs(Config.AcePermissions.groups) do
            if IsPlayerAceAllowed(source, 'has.'..group) then
                SetPermission(source, group, false)
                break
            end
        end
    end)

    AddEventHandler('onResourceStop', function(res)
        if CurrentResourceName ~= res then return end
        for group, groupConfig in pairs(Config.AcePermissions.groups) do
            for i = 1 , #groupConfig do
                ExecuteCommand(("remove_ace fg.%s %s allow"):format(group, groupConfig[i]))
            end
        end
    end)
elseif Config.FrameworkPermissions.enable then
    local out = ''
    for group, groupConfig in pairs(Config.FrameworkPermissions.groups) do
        for i = 1 , #groupConfig do
            if IsPrincipalAceAllowed(('fg.%s'):format(group),groupConfig[i]) then
                out = out..'\n\tIgnored permission "'..groupConfig[i]..'" for group "'..group..'". Already Registered!'
            else
                ExecuteCommand(("add_ace fg.%s %s allow"):format(group, groupConfig[i]))
            end
        end
    end
    if string.len(out) > 10 then Error(out) end
    local checkResource = function (res)
        local rs = GetResourceState(res)
        return rs == "started" or rs == "starting"
    end
    local frameworkDetected = ''
    if not Config.FrameworkPermissions.customFramework.enable then
        if checkResource('es_extended') then
            frameworkDetected = 'ESX'
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
        elseif checkResource('qbx_core') then
            frameworkDetected = 'QBox'
            AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
                Debug('[QBCore:Server:PlayerLoaded]',GetInvokingResource(),Player.PlayerData.source)
                if GetInvokingResource() ~= 'qbx_core' then return Warn(source,'tried to exploit QBCore:Server:PlayerLoaded') end
                for group,_ in pairs(Config.FrameworkPermissions.groups) do
                    if IsPlayerAceAllowed(Player.PlayerData.source, group) then
                        SetPermission(Player.PlayerData.source, group, true)
                        break
                    end
                end
            end)
            RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(source)
                Debug('[QBCore:Server:OnPlayerUnload]',GetInvokingResource(),source)
                if GetInvokingResource() ~= 'qbx_core' then return Warn(source,'tried to exploit QBCore:Server:OnPlayerUnload') end
                for group,_ in pairs(Config.FrameworkPermissions.groups) do
                    if IsPlayerAceAllowed(source, group) then
                        SetPermission(source, group, false)
                        break
                    end
                end
            end)
            AddEventHandler('QBCore:Server:OnPermissionUpdate', function(source)
                Debug('[QBCore:Server:OnPermissionUpdate]',GetInvokingResource(),source)
                if GetInvokingResource() ~= 'qbx_core' then return Warn(source,'tried to exploit QBCore:Server:OnPermissionUpdate') end
                for group,_ in pairs(Config.FrameworkPermissions.groups) do
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
                for group,_ in pairs(Config.FrameworkPermissions.groups) do
                    if IsPlayerAceAllowed(source, group) then
                        SetPermission(source, group, true)
                    elseif not IsPlayerAceAllowed(source, group) then
                        SetPermission(source, group, false)
                    end
                end
            end)
        elseif checkResource('qb-core') then
            frameworkDetected = 'QBCore'
            if not IsPrincipalAceAllowed('qbcore.god','group.admin') then
                ExecuteCommand('add_principal qbcore.god group.admin')
            end
            AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
                Debug('[QBCore:Server:PlayerLoaded]',GetInvokingResource(),Player.PlayerData.source)
                if GetInvokingResource() ~= 'qb-core' then return Warn(source,'tried to exploit QBCore:Server:PlayerLoaded') end
                for group,_ in pairs(Config.FrameworkPermissions.groups) do
                    if IsPlayerAceAllowed(Player.PlayerData.source, group) then
                        SetPermission(Player.PlayerData.source, group, true)
                        break
                    end
                end
            end)
            AddEventHandler('QBCore:Server:OnPlayerUnload', function(source)
                Debug('[QBCore:Server:OnPlayerUnload]',GetInvokingResource(),source)
                if GetInvokingResource() ~= 'qb-core' then return Warn(source,'tried to exploit QBCore:Server:OnPlayerUnload') end
                for group,_ in pairs(Config.FrameworkPermissions.groups) do
                    if IsPlayerAceAllowed(source, group) then
                        SetPermission(source, group, false)
                        break
                    end
                end
            end)
            AddEventHandler('QBCore:Server:PlayerDropped', function(Player)
                Debug('[QBCore:Server:PlayerDropped]',GetInvokingResource(),Player.PlayerData.source)
                if GetInvokingResource() ~= 'qb-core' then return Warn(Player.PlayerData.source,'tried to exploit QBCore:Server:PlayerDropped') end
                for group,_ in pairs(Config.FrameworkPermissions.groups) do
                    if IsPlayerAceAllowed(Player.PlayerData.source, group) then
                        SetPermission(Player.PlayerData.source, group, false)
                        break
                    end
                end
            end)
        elseif checkResource('vrp') then
            frameworkDetected = 'vRP'
            local chunk, vRP = LoadResourceFile('vrp','lib/utils.lua')
            if chunk then
                load(chunk)()
                ---@diagnostic disable-next-line: deprecated
                local Proxy = module("vrp", "lib/Proxy")
                ---@diagnostic disable-next-line: undefined-field, need-check-nil
                vRP = Proxy.getInterface("vRP")
            end
            AddEventHandler("vRP:playerJoin",function(user_id, playerId, name, tmpdata)
                Debug('[vRP:playerJoin]',GetInvokingResource(),user_id, playerId, name, tmpdata)
                if GetInvokingResource() ~= 'vrp' then return Warn(source,'tried to exploit vRP:playerJoin') end
                for group, _ in pairs(Config.FrameworkPermissions.groups) do
                    ---@diagnostic disable-next-line: undefined-field, need-check-nil
                    if vRP.hasGroup(user_id, group) then
                        SetPermission(playerId, group, true)
                        break
                    end
                end
            end)
            AddEventHandler("vRP:playerJoinGroup", function(user_id, group, gtype)
                Debug('[vRP:playerJoinGroup]',GetInvokingResource(),user_id, group, gtype)
                if GetInvokingResource() ~= 'vrp' then return Warn(source,'tried to exploit vRP:playerJoinGroup') end
                for group, _ in pairs(Config.FrameworkPermissions.groups) do
                    ---@diagnostic disable-next-line: undefined-field, need-check-nil
                    if vRP.hasGroup(user_id, group) then
                        ---@diagnostic disable-next-line: undefined-field, need-check-nil
                        local playerId = vRP.getUserSource(user_id)
                        SetPermission(playerId, group, true)
                        break
                    end
                end
            end)
            AddEventHandler("vRP:playerLeaveGroup", function(user_id, group, gtype)
                Debug('[vRP:playerLeaveGroup]',GetInvokingResource(),user_id, group, gtype)
                if GetInvokingResource() ~= 'vrp' then return Warn(source,'tried to exploit vRP:playerLeaveGroup') end
                for group, _ in pairs(Config.FrameworkPermissions.groups) do
                    ---@diagnostic disable-next-line: undefined-field, need-check-nil
                    if vRP.hasGroup(user_id, group) then
                        ---@diagnostic disable-next-line: undefined-field, need-check-nil
                        local playerId = vRP.getUserSource(user_id)
                        SetPermission(playerId, group, false)
                        break
                    end
                end
            end)
            AddEventHandler("vRP:playerLeave", function(user_id, playerId)
                Debug('[vRP:playerLeave]',GetInvokingResource(),user_id, playerId)
                if GetInvokingResource() ~= 'vrp' then return Warn(source,'tried to exploit vRP:playerLeave') end
                for group, _ in pairs(Config.FrameworkPermissions.groups) do
                    ---@diagnostic disable-next-line: undefined-field, need-check-nil
                    if vRP.hasGroup(user_id, group) then
                        SetPermission(playerId, group, false)
                        break
                    end
                end
            end)
        else
            Error('Framework not detected\nIf u have a custom framework anble customFramework and configure it in the config.lua file.')
        end
    else
        AddEventHandler(tostring(Config.FrameworkPermissions.customEvent),function(playerId,group,allow)
            frameworkDetected = GetInvokingResource()
            Debug('[customEvent]', GetInvokingResource())
            if Config.FrameworkPermissions.invokerResource and Config.FrameworkPermissions.invokerResource:len() > 4 then
                if GetInvokingResource() ~= Config.FrameworkPermissions.invokerResource then return Warn(source,'tried to exploit '..Config.customEvent) end
            else
                Warn('Make sure to config "Config.FrameworkPermissions.invokerResource" for you custom framework, without it the event can be exploitable by cheaters!')
            end
            if not (playerId and group and allow) then
                return Error('[Framework Permission] Bad config for custom framework')
            end
            SetPermission(playerId, group, allow)
        end)
    end
    Info('Easy Permissions: using framework permissions with: ^3'..frameworkDetected..'^0')

    AddEventHandler('onResourceStop', function(res)
        if (CurrentResourceName ~= res) then return end
        for group, groupConfig in pairs(Config.FrameworkPermissions.groups) do
            for i = 1 , #groupConfig do
                ExecuteCommand(("remove_ace fg.%s %s allow"):format(group, groupConfig[i]))
            end
        end
        if frameworkDetected == 'QBCore' then
            ExecuteCommand('remove_principal qbcore.god group.admin')
        end
    end)
    AddEventHandler('onResourceStop', function(res)
        if  (res ~= frameworkDetected) then return end
        for group, groupConfig in pairs(Config.FrameworkPermissions.groups) do
            for i = 1 , #groupConfig do
                ExecuteCommand(("remove_ace fg.%s %s allow"):format(group, groupConfig[i]))
            end
        end
        if frameworkDetected == 'QBCore' then
            ExecuteCommand('remove_principal qbcore.god group.admin')
        end
    end)
elseif Config.txAdminPermissions.enable then
    if GetResourceState('monitor') ~= 'started' then return Error('[txAdmin Permission] You can not use this permission without txAdmin in your server!') end
    Info('Easy Permissions: using txAdmin Permissions')
    for i = 1, #Config.txAdminPermissions.fgPermissions do
        if IsPrincipalAceAllowed('fg.txadmin', Config.txAdminPermissions.fgPermissions[i]) then
            Warn(('[txAdmin Permissions] Ignored permission %s for group fg.txadmin because is already registered'):format(Config.fgPermissions[i]))
        else
            ExecuteCommand(("add_ace fg.txadmin %s allow"):format(Config.txAdminPermissions.fgPermissions[i]))
        end
    end
    AddEventHandler("txAdmin:events:adminAuth", function(data)
        Debug('[txAdmin:events:adminAuth]', json.encode(data, {indent=true}))
        if not data then return end
        if data.netid >= 1 then
            SetPermission(data.netid, 'txadmin', data?.isAdmin)
        else
            Info('txAdmin sent a broadcast reauth')
            local targets = GetPlayers()
            for i = 1, #targets do
                SetPermission(targets[i], 'txadmin', data?.isAdmin)
            end
        end
    end)
    AddEventHandler('onResourceStop', function(res)
        if res ~= CurrentResourceName then return end
        for i = 1, #Config.txAdminPermissions.fgPermissions do
            ExecuteCommand(("remove_ace fg.txadmin %s allow"):format(Config.txAdminPermissions.fgPermissions[i]))
        end
    end)
    AddEventHandler('onResourceStop', function(res)
        if res ~= 'monitor' then return end
        for i = 1, #Config.txAdminPermissions.fgPermissions do
            ExecuteCommand(("remove_ace fg.txadmin %s allow"):format(Config.txAdminPermissions.fgPermissions[i]))
        end
    end)
end
