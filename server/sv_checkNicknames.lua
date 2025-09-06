local data = LoadResourceFile(CurrentResourceName, 'config.lua')
local Config = assert(load(data))()?.CheckNicknames
if not Config?.enable then return end
while not READY do Citizen.Wait(0) end

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function isCharacterNameValid(name)
  local n = #name

  if Config.minNicknameLength and n < Config.minNicknameLength then
    return false, ("Nickname too short. Minimum: %d characters."):format(Config.minNicknameLength)
  end
  if Config.maxNicknameLength and n > Config.maxNicknameLength then
    return false, ("Nickname too long, Maximum: %d characters."):format(Config.maxNicknameLength)
  end
  return true, ""
end

local function isNameValid(name)
  if not Config.allowedPattern then return true, "" end
  if name ~= trim(name) or name:match("^%s+$") then
    return false, "Leading/trailing spaces or only-space nickname are not allowed."
  end
  if not name:match(Config.allowedPattern) then
    return false, "Your nickname contains invalid characters."
  end
  return true, ""
end

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
  deferrals.defer()
  Wait(100)
  local ok, reason = isNameValid(playerName)
  if not ok then
    deferrals.done("Connection refused: " .. reason)
    return
  end
  ok, reason = isCharacterNameValid(playerName)
  if not ok then
    deferrals.done("Connection refused: " .. reason)
    return
  end
  deferrals.done()
end)
