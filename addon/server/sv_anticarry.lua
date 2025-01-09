if Config.AntiCarry then
    print("Debug: Anti-Carry: "..tostring(Config.AntiCarry))
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
                    print("Record Succes" .. src)
                    exports[Config.ResourceName]:fg_BanPlayer(src, "Blacklist animation / carry a vehicle or other", true)
                else
                    print("Record Error" .. src)
                end

                Citizen.SetTimeout(cooldownTime, function()
                    isRecording = false
                end)
            end, Config.WebhookURL)
        else
            exports[Config.ResourceName]:fg_BanPlayer(src, "Blacklist animation / carry a vehicle or other", true)
            Citizen.SetTimeout(cooldownTime, function()
                isRecording = false
            end)
        end
    end)
else
    print("Debug: Anti-Carry: "..tostring(Config.AntiCarry))
    RegisterNetEvent('security:anti_throw')
    AddEventHandler('security:anti_throw', function()
        print("Anti Carry Disable ban (Dont remove, its debug)")
    end)
end

