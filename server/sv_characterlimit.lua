local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.LimitCharacterName
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

function isCharacterNameValid(name)
    local nameLength = #name
    if nameLength > Config.CharacterLimit then
        local excess = nameLength - Config.CharacterLimit
        return false, "You have " .. excess .. " extra characters. Limit: " .. Config.CharacterLimit
    end
    return true, ""
end
