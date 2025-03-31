local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.CheckNicknames
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

local function isCharacterNameValid(name)
    local nameLength = #name
    if nameLength > Config.maxNicknameLenght then
        local excess = nameLength - Config.maxNicknameLenght
        return false, "You have " .. excess .. " extra characters. Limit: " .. Config.CharacterLimit
    end
    return true, ""
end

local function isNameValid(name)
    for i = 1, #name do
        local char = name:sub(i, i)
        local found = false
        for _, validChar in ipairs(Config.allowedCharacters) do
            if char == validChar then
                found = true
                break
            end
        end
        if not found then
            return false, "Your name contains invalid characters."
        end
    end
    return true, ""
end

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    deferrals.defer()
    Wait(100)
    if Config.allowedCharacters then
        local isValid, reason = isNameValid(playerName)
        if not isValid then
            deferrals.done("[fiveguard] Connection refused: " .. reason)
            return
        end
    end
    if Config.maxNicknameLenght then
        local isValid, reason = isCharacterNameValid(playerName)
        if not isValid then
            deferrals.done("[fiveguard] Connection refused: " .. reason)
            return
        end
    end
    deferrals.done()
end)
