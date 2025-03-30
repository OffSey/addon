local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.WhitelistStringsName
while not Fiveguard do Wait(0) end
if GetResourceState(Fiveguard) ~= 'started' then return end
if not Config?.enable then return end

function isNameValid(name)
    for i = 1, #name do
        local char = name:sub(i, i)
        local found = false
        for _, validChar in ipairs(Config.WhiteListStringsName) do
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
