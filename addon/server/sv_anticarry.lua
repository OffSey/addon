if Config.AntiCarry then
    local isRecording = false
    local cooldownTime = 10000

    RegisterNetEvent('security:anti_throw')
    AddEventHandler('security:anti_throw', function()
        local src = source
        if isRecording then return end

        isRecording = true
        if Config.RecordPlayer then
            exports[Config.ResourceName]:recordPlayerScreen(src, Config.RecordTime, function(success)
                if success then
                    Debug("Record Succes" .. src)
                    exports[Config.ResourceName]:fg_BanPlayer(src, "Blacklist animation / carry a vehicle or other", true)
                else
                    Debug("Record Error" .. src)
                end

                Citizen.SetTimeout(cooldownTime, function()
                    isRecording = false
                end)
            end, SVConfig.WebhookURLAntiCarry)
        else
            exports[Config.ResourceName]:fg_BanPlayer(src, "Blacklist animation / carry a vehicle or other", true)
            Citizen.SetTimeout(cooldownTime, function()
                isRecording = false
            end)
        end
    end)
else
    RegisterNetEvent('security:anti_throw')
    AddEventHandler('security:anti_throw', function()
        Debug("Anti Carry Disable ban (Dont remove, its debug)")
    end)
end

