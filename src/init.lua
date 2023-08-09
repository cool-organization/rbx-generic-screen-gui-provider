--[=[
	Providers screenGuis with a given display order for easy use.

	```lua
	return GenericScreenGuiProvider.new({
	  CLOCK = 5; -- Register layers here
	  BLAH = 8;
	  CHAT = 10;
	})
	```

	In a script that needs a new screen gui, do this:

	```lua
	-- Load your games provider (see above for the registration)
	local screenGuiProvider = require("ScreenGuiProvider")

	-- Yay, you now have a new screen gui
	local screenGui = screenGuiProvider:Get("CLOCK")
	gui.Parent = screenGui
	```

	@class GenericScreenGuiProvider
]=]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Utility = require(script.Utility)

local GenericScreenGuiProvider = {}
GenericScreenGuiProvider.ClassName = "GenericScreenGuiProvider"
GenericScreenGuiProvider.__index = GenericScreenGuiProvider

local function MockScreenGui(self, orderName)
	assert(type(orderName) == "string", "Bad orderName")
	assert(rawget(self, "_mockParent"), "No _mockParent set")

	local displayOrder = self:GetDisplayOrder(orderName)

	local mock = Instance.new("Frame")
	mock.Size = UDim2.fromScale(1, 1)
	mock.BackgroundTransparency = 1
	mock.ZIndex = displayOrder
	mock.Parent = rawget(self, "_mockParent")

	return mock
end

--[=[
	Constructs a new screen gui provider.
	@param orders { [string]: number }
	@return GenericScreenGuiProvider
]=]
function GenericScreenGuiProvider.new(orders)
	assert(type(orders) == "table", "Bad orders")
	return setmetatable({
		DefaultAutoLocalize = false;
		_order = orders;
		_mockParent = nil;
	}, GenericScreenGuiProvider)
end

--[=[
	Returns a new ScreenGui at DisplayOrder specified
	@param orderName string -- Order name of display order
	@return ScreenGui
]=]
function GenericScreenGuiProvider:Get(orderName)
	if not RunService:IsRunning() then
		return MockScreenGui(self, orderName)
	end

	local localPlayer = Players.LocalPlayer
	if not localPlayer then
		error("[GenericScreenGuiProvider] - No localPlayer")
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = Utility.toCamelCase(orderName)
	screenGui.ResetOnSpawn = false
	screenGui.AutoLocalize = self.DefaultAutoLocalize
	screenGui.DisplayOrder = self:GetDisplayOrder(orderName)
	screenGui.Parent = Utility.getPlayerGui()
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	return screenGui
end

--[=[
	Retrieve the display order for a given order.
	@param orderName string -- Order name of display order
	@return number
]=]
function GenericScreenGuiProvider:GetDisplayOrder(orderName)
	assert(type(orderName) == "string", "Bad orderName")
	assert(self._order[orderName], string.format("No DisplayOrder with orderName '%*'", tostring(orderName)))

	return self._order[orderName]
end

--[=[
	Sets up a mock parent for the given target during test mode.
	@param target GuiBase
	@return function -- Cleanup function to reset mock parent
]=]
function GenericScreenGuiProvider:SetupMockParent(target)
	assert(not RunService:IsRunning(), "Bad target")
	assert(target, "Bad target")

	rawset(self, "_mockParent", target)

	return function()
		if rawget(self, "_mockParent") == target then
			rawset(self, "_mockParent", nil)
		end
	end
end

function GenericScreenGuiProvider:__tostring()
	return "GenericScreenGuiProvider"
end

return table.freeze(GenericScreenGuiProvider)
