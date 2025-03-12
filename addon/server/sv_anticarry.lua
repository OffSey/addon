local data = LoadResourceFile(CurrentResourceName,'config.lua')
local Config = assert(load(data))()?.AntiCarry
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end
local isRecording = false
local cooldownTime = 10000

RegisterNetEvent('fg:addon:antiThrow')
AddEventHandler('fg:addon:antiThrow', function()
    if isRecording then return end

    isRecording = true
    ::noRecord::
    if Config.recordPlayer then
        if string.len(Config.webhookURL) < 80 then
            Config.recordPlayer = false
            Error('Invalid discord webhook, player banned without record and Config.recordPlayer was disabled')
            goto noRecord
        end
        exports[Fiveguard]:recordPlayerScreen(source, Config.RecordTime, function(success)
            if success then
                Debug("[AntiCarry] Record Succes" .. source)
                exports[Fiveguard]:fg_BanPlayer(source, "Blacklist animation / carry a vehicle or other", true)
            else
                Error("[AntiCarry] Record Error" .. source)
            end

            Citizen.SetTimeout(cooldownTime, function()
                isRecording = false
            end)
        end, Config.webhookURL)
    else
        exports[Fiveguard]:fg_BanPlayer(source, "Blacklist animation / carry a vehicle or other", true)
        Citizen.SetTimeout(cooldownTime, function()
            isRecording = false
        end)
    end
end)
