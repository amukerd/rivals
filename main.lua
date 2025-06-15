local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function addHighlight(player)
	if player == LocalPlayer then return end

	local character = player.Character or player.CharacterAdded:Wait()

	local existingHighlight = character:FindFirstChildOfClass("Highlight")
	if existingHighlight then
		existingHighlight:Destroy()
	end

	local highlight = Instance.new("Highlight")
	highlight.Adornee = character
	highlight.FillColor = Color3.fromRGB(0, 0, 255)
	highlight.FillTransparency = 0.5
	highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
	highlight.OutlineTransparency = 0
	highlight.Parent = character
end

--for _, player in pairs(Players:GetPlayers()) do
--	addHighlight(player)
--end

Players.PlayerAdded:Connect(function(player)
	addHighlight(player)
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		addHighlight(player)
	end)
end)
