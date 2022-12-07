--V1 // ARTICLIZE

local UserInputHandler = {}
UserInputHandler.__index = UserInputHandler


function UserInputHandler.GetEnumFromInputObject(InputObject)
	return InputObject.KeyCode ~= Enum.KeyCode.Unknown and InputObject.KeyCode 
		or InputObject.UserInputType ~= Enum.UserInputType.None and InputObject.UserInputType
end

function UserInputHandler.GetEnumName(Enum)
	return type(Enum) == "string" and Enum or Enum.Name
end


UserInputHandler.EnumRegistry = {}

function UserInputHandler.UpdateEnumRegistry(InputObject)
	local Enum = UserInputHandler.GetEnumFromInputObject(InputObject)
	local EnumName = UserInputHandler.GetEnumName(Enum)
	
	UserInputHandler.EnumRegistry[EnumName] = InputObject.UserInputState == Enum.UserInputState.Begin and tick() or nil
end

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(UserInputHandler.UpdateEnumRegistry)
UserInputService.InputEnded:Connect(UserInputHandler.UpdateEnumRegistry)


function UserInputHandler.IsEnumInRegistry(Enum)
	return UserInputHandler.EnumRegistry[Enum] and true
end

function UserInputHandler.IsEnumPatternInRegistry(EnumPattern)
	local TickLast = 0
	
	for _, Enum in ipairs(EnumPattern) do
		local EnumName = UserInputHandler.GetEnumName(Enum)
		local Tick = UserInputHandler.EnumRegistry[EnumName]
		if Tick < TickLast then
			return false
		end
		TickLast = Tick
	end
	return true
end


return UserInputHandler