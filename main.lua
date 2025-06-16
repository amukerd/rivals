local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local library = loadstring(game:HttpGet("https://raw.github.com/amukerd/rivals/main/lib.lua"))()

local main = library:Load{Name="Rivals",SizeX=600,SizeY=600,Theme="Midnight",Extension="json",Folder="Rivals_Config"}

local tab = main:Tab("Main")

local section = tab:Section{
    Name = "Aimbot",
    Side = "Left"
}

local toggle2 = section:Toggle{
    Name = "Toggle 2",
    Flag = "Toggle 2",
    --Default = true,
    Callback  = function(bool)
        print("Toggle 2 is now " .. (bool and "enabled" or "disabled"))
    end
}

toggle2:Keybind{
    --Default = Enum.KeyCode.A,
    Blacklist = {Enum.UserInputType.MouseButton1},
    Flag = "Toggle 2 Keybind 1",
    Mode = "Toggle", -- mode to nil if u dont want it to toggle the toggle
    Callback = function(key, fromsetting)
        if fromsetting then
            print("Toggle 2 Keybind 1 is now " .. tostring(key))
        else
            print("Toggle 2 Keybind 1 was pressed")
        end
    end
}

local section2 = tab:Section{
    Name = "Visuals",
    Side = "Right"
}

--chams toggle stuff
local playerHighlights = {}
local currentColor = Color3.fromRGB(255, 0, 0)
local toggleEnabled = false
local function addHighlight(player)
if player == LocalPlayer then return end
local character = player.Character or player.CharacterAdded:Wait()
local existing = playerHighlights[player]
if existing then existing:Destroy() end
local highlight = Instance.new("Highlight")
highlight.Adornee = character
highlight.FillColor = currentColor
highlight.OutlineColor = currentColor
highlight.FillTransparency = 0.5
highlight.OutlineTransparency = 0
highlight.Parent = character
playerHighlights[player] = highlight
end
local function removeHighlight(player)
local existing = playerHighlights[player]
if existing then
existing:Destroy()
playerHighlights[player] = nil
end
end
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer then
player.CharacterAdded:Connect(function()
if toggleEnabled then
addHighlight(player)
end
end)
end
end
Players.PlayerAdded:Connect(function(player)
if player == LocalPlayer then return end
player.CharacterAdded:Connect(function()
if toggleEnabled then
addHighlight(player)
end
end)
if toggleEnabled then
addHighlight(player)
end
end)
--chams toggle stuff

local toggle = section2:Toggle{
	Name = "Chams",
	Flag = "Toggle 1",
	Callback = function(state)
		toggleEnabled = state

		for _, player in ipairs(Players:GetPlayers()) do
			if player == LocalPlayer then continue end

			if state then
				addHighlight(player)
			else
				removeHighlight(player)
			end
		end
	end
}

local togglepicker1 = toggle:ColorPicker{
	Default = currentColor,
	Flag = "Toggle 1 Picker 1",
	Callback = function(color)
		currentColor = color

		for _, highlight in pairs(playerHighlights) do
			if highlight and highlight.Parent then
				highlight.FillColor = color
				highlight.OutlineColor = color
			end
		end
	end
}

local toggleEnabled2 = false
local currentColor2 = Color3.fromRGB(255, 0, 0)
local skeletons = {}
local bonePairsR6 = {
{"Head", "Torso"},
{"Torso", "Left Arm"},
{"Torso", "Right Arm"},
{"Torso", "Left Leg"},
{"Torso", "Right Leg"},
}
local bonePairsR15 = {
{"Head", "UpperTorso"},
{"UpperTorso", "LowerTorso"},
{"UpperTorso", "LeftUpperArm"},
{"LeftUpperArm", "LeftLowerArm"},
{"LeftLowerArm", "LeftHand"},
{"UpperTorso", "RightUpperArm"},
{"RightUpperArm", "RightLowerArm"},
{"RightLowerArm", "RightHand"},
{"LowerTorso", "LeftUpperLeg"},
{"LeftUpperLeg", "LeftLowerLeg"},
{"LeftLowerLeg", "LeftFoot"},
{"LowerTorso", "RightUpperLeg"},
{"RightUpperLeg", "RightLowerLeg"},
{"RightLowerLeg", "RightFoot"},
}
local function createLine()
local line = Drawing.new("Line")
line.Thickness = 2.5
line.Transparency = 1
line.Color = currentColor2
line.Visible = true
return line
end
local function makeSkeleton(player)
if player == LocalPlayer then return end
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rigType = humanoid.RigType
local bonePairs = rigType == Enum.HumanoidRigType.R15 and bonePairsR15 or bonePairsR6
local bones = {}
for _, pair in ipairs(bonePairs) do
local line = createLine()
table.insert(bones, {Parts = pair, Line = line})
end
skeletons[player] = {bones = bones}
end
local function removeSkeleton(player)
local data = skeletons[player]
if data and data.bones then
for _, bone in ipairs(data.bones) do
if bone.Line then
bone.Line:Remove()
end
end
skeletons[player] = nil
end
end
Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function()
if toggleEnabled2 then
makeSkeleton(player)
end
end)
end)
Players.PlayerRemoving:Connect(removeSkeleton)
RunService.RenderStepped:Connect(function()
if not toggleEnabled2 then return end
for player, data in pairs(skeletons) do
local char = player.Character
if not char then continue end
for _, bone in ipairs(data.bones) do
local part0 = char:FindFirstChild(bone.Parts[1])
local part1 = char:FindFirstChild(bone.Parts[2])
if not part0 or not part1 then
bone.Line.Visible = false
continue
end
local pos0, onScreen0 = Camera:WorldToViewportPoint(part0.Position)
local pos1, onScreen1 = Camera:WorldToViewportPoint(part1.Position)
if onScreen0 and onScreen1 then
bone.Line.From = Vector2.new(pos0.X, pos0.Y)
bone.Line.To = Vector2.new(pos1.X, pos1.Y)
bone.Line.Visible = true
else
bone.Line.Visible = false
end
end
end
end)

local toggle2 = section2:Toggle{
	Name = "Skeleton",
	Flag = "Toggle 2",
	Callback = function(state)
		toggleEnabled2 = state
	
		if toggleEnabled2 then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					makeSkeleton(player)
				end
			end
		else
			for player in pairs(skeletons) do
				removeSkeleton(player)
			end
		end
	end
}

local togglepicker2 = toggle2:ColorPicker{
	Default = currentColor2,
	Flag = "Toggle 2 Picker 2",
	Callback = function(color)
		currentColor2 = color

		for _, skeleton in pairs(skeletons) do
			for _, bone in ipairs(skeleton.bones) do
				if bone.Line then
					bone.Line.Color = currentColor2
				end
			end
		end
	end
}

local BOX_THICKNESS = 2
local BOX_SIZE = Vector3.new(2.1, 3.1, 0)
local currentColor3 = Color3.fromRGB(255, 0, 0)
local boxes = {}
local function createBox()
local box = {}
for i = 1, 4 do
local line = Drawing.new("Line")
line.Color = currentColor3
line.Thickness = BOX_THICKNESS
line.Transparency = 1
line.Visible = true
box[i] = line
end
return box
end
local function updateBox(box, topLeft, topRight, bottomRight, bottomLeft)
box[1].From = topLeft
box[1].To = topRight
box[2].From = topRight
box[2].To = bottomRight
box[3].From = bottomRight
box[3].To = bottomLeft
box[4].From = bottomLeft
box[4].To = topLeft
for _, line in ipairs(box) do
line.Visible = true
end
end
local function hideBox(box)
for _, line in ipairs(box) do
line.Visible = false
end
end
local function removeBox(player)
if boxes[player] then
for _, line in ipairs(boxes[player]) do
line:Remove()
end
boxes[player] = nil
end
end
Players.PlayerRemoving:Connect(removeBox)
RunService.RenderStepped:Connect(function()
if not toggleEnabled3 then return end
for _, player in ipairs(Players:GetPlayers()) do
if player == LocalPlayer then continue end
local character = player.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
if not root then
if boxes[player] then hideBox(boxes[player]) end
continue
end
if not boxes[player] then
boxes[player] = createBox()
end
local cframe = root.CFrame
local size = BOX_SIZE
local points3D = {
cframe * Vector3.new(-size.X, size.Y, 0),
cframe * Vector3.new(size.X, size.Y, 0),
cframe * Vector3.new(size.X, -size.Y, 0),
cframe * Vector3.new(-size.X, -size.Y, 0)
}
local points2D = {}
local onScreen = true
for i, point in ipairs(points3D) do
local screenPos, visible = Camera:WorldToViewportPoint(point)
if not visible then
onScreen = false
break
end
points2D[i] = Vector2.new(screenPos.X, screenPos.Y)
end
if onScreen then
updateBox(boxes[player], points2D[1], points2D[2], points2D[3], points2D[4])
else
hideBox(boxes[player])
end
end
end)

local toggle3 = section2:Toggle{
	Name = "Box",
	Flag = "Toggle 3",
	Callback = function(state)
		toggleEnabled3 = state

		if not toggleEnabled3 then
			for player, box in pairs(boxes) do
				hideBox(box)
			end
		end
	end
}

local togglepicker3 = toggle3:ColorPicker{
	Default = currentColor3,
	Flag = "Toggle 3 Picker",
	Callback = function(color)
		currentColor3 = color

		for _, box in pairs(boxes) do
			for _, line in ipairs(box) do
				line.Color = currentColor3
			end
		end
	end
}







































--library:SaveConfig("config", true) -- universal config
--library:SaveConfig("config") -- game specific config
--library:DeleteConfig("config", true) -- universal config
--library:DeleteConfig("config") -- game specific config
--library:GetConfigs(true) -- return universal and game specific configs (table)
--library:GetConfigs() -- return game specific configs (table)
--library:LoadConfig("config", true) -- load universal config
--library:LoadConfig("config") -- load game specific config

local configs = main:Tab("UI Configuration")

local configsection = configs:Section{Name = "Configs", Side = "Left"}

local configlist = configsection:Dropdown{
    Name = "Configs",
    Content = library:GetConfigs(),
    Flag = "Config Dropdown"
}

library:ConfigIgnore("Config Dropdown")

local loadconfig = configsection:Button{
    Name = "Load Config",
    Callback = function()
        library:LoadConfig(library.flags["Config Dropdown"])
    end
}

local delconfig = configsection:Button{
    Name = "Delete Config",
    Callback = function()
        library:DeleteConfig(library.flags["Config Dropdown"])
        configlist:Refresh(library:GetConfigs())
    end
}


local configbox = configsection:Box{
    Name = "Config Name",
    Placeholder = "Config Name",
    Flag = "Config Name"
}

library:ConfigIgnore("Config Name")

local save = configsection:Button{
    Name = "Save Config",
    Callback = function()
        library:SaveConfig(library.flags["Config Dropdown"] or library.flags["Config Name"])
        configlist:Refresh(library:GetConfigs())
    end
}

local keybindsection = configs:Section{Name = "UI Keybinds", Side = "Left"}

keybindsection:Keybind{
    Name = "Toggle UI",
    Flag = "UI Toggle",
    Default = Enum.KeyCode.KeypadZero,
    Blacklist = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3},
    Callback = function(_, fromsetting)
        if not fromsetting then
            library:Close()
        end
    end
}

keybindsection:Keybind{
    Name = "Destroy UI",
    Flag = "Unload UI",
    Default = Enum.KeyCode.Delete,
    Blacklist = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3},
    Callback = function(_, fromsetting)
        if not fromsetting then
            library:Unload()
        end
    end
}

--Theme Shit
local a={}local b=configs:Section{Name="Custom Theme",Side="Right"}a["Accent"]=b:ColorPicker{Name="Accent",Default=library.theme["Accent"],Flag="Accent",Callback=function(c)library:ChangeThemeOption("Accent",c)end}library:ConfigIgnore("Accent")a["Window Background"]=b:ColorPicker{Name="Window Background",Default=library.theme["Window Background"],Flag="Window Background",Callback=function(c)library:ChangeThemeOption("Window Background",c)end}library:ConfigIgnore("Window Background")a["Window Border"]=b:ColorPicker{Name="Window Border",Default=library.theme["Window Border"],Flag="Window Border",Callback=function(c)library:ChangeThemeOption("Window Border",c)end}library:ConfigIgnore("Window Border")a["Tab Background"]=b:ColorPicker{Name="Tab Background",Default=library.theme["Tab Background"],Flag="Tab Background",Callback=function(c)library:ChangeThemeOption("Tab Background",c)end}library:ConfigIgnore("Tab Background")a["Tab Border"]=b:ColorPicker{Name="Tab Border",Default=library.theme["Tab Border"],Flag="Tab Border",Callback=function(c)library:ChangeThemeOption("Tab Border",c)end}library:ConfigIgnore("Tab Border")a["Tab Toggle Background"]=b:ColorPicker{Name="Tab Toggle Background",Default=library.theme["Tab Toggle Background"],Flag="Tab Toggle Background",Callback=function(c)library:ChangeThemeOption("Tab Toggle Background",c)end}library:ConfigIgnore("Tab Toggle Background")a["Section Background"]=b:ColorPicker{Name="Section Background",Default=library.theme["Section Background"],Flag="Section Background",Callback=function(c)library:ChangeThemeOption("Section Background",c)end}library:ConfigIgnore("Section Background")a["Section Border"]=b:ColorPicker{Name="Section Border",Default=library.theme["Section Border"],Flag="Section Border",Callback=function(c)library:ChangeThemeOption("Section Border",c)end}library:ConfigIgnore("Section Border")a["Text"]=b:ColorPicker{Name="Text",Default=library.theme["Text"],Flag="Text",Callback=function(c)library:ChangeThemeOption("Text",c)end}library:ConfigIgnore("Text")a["Disabled Text"]=b:ColorPicker{Name="Disabled Text",Default=library.theme["Disabled Text"],Flag="Disabled Text",Callback=function(c)library:ChangeThemeOption("Disabled Text",c)end}library:ConfigIgnore("Disabled Text")a["Object Background"]=b:ColorPicker{Name="Object Background",Default=library.theme["Object Background"],Flag="Object Background",Callback=function(c)library:ChangeThemeOption("Object Background",c)end}library:ConfigIgnore("Object Background")a["Object Border"]=b:ColorPicker{Name="Object Border",Default=library.theme["Object Border"],Flag="Object Border",Callback=function(c)library:ChangeThemeOption("Object Border",c)end}library:ConfigIgnore("Object Border")a["Dropdown Option Background"]=b:ColorPicker{Name="Dropdown Option Background",Default=library.theme["Dropdown Option Background"],Flag="Dropdown Option Background",Callback=function(c)library:ChangeThemeOption("Dropdown Option Background",c)end}library:ConfigIgnore("Dropdown Option Background")
--Theme Shit 
