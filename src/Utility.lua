--!strict

local Players = game:GetService("Players")

local Utility = {}

function Utility.getPlayerGui()
	local localPlayer = Players.LocalPlayer
	if not localPlayer then
		error("No localPlayer")
	end

	return localPlayer:FindFirstChildOfClass("PlayerGui") or error("No PlayerGui")
end

function Utility.toCamelCase(value: string)
	value = string.lower(value)
	value = string.gsub(value, "[ _](%a)", string.upper)
	value = string.gsub(value, "^%a", string.upper)
	value = string.gsub(value, "%p", "")

	return value
end

return table.freeze(Utility)
