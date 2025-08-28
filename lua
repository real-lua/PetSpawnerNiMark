local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Load Spawner
local Spawner = loadstring(game:HttpGet("https://gitlab.com/darkiedarkie/dark/-/raw/main/Spawner.lua"))()

-- ScreenGui
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "PetSpawnerUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 150)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = false -- custom drag with tween

-- Drag Support
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	local newPos = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
	TweenService:Create(mainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Position = newPos
	}):Play()
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Title Bar
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BorderSizePixel = 0

-- Title
local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -25, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🐾 Pet Spawner"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0, 25, 1, 0)
closeButton.Position = UDim2.new(1, -25, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 16
closeButton.BorderSizePixel = 0

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Pet Name Box
local petNameBox = Instance.new("TextBox", mainFrame)
petNameBox.Size = UDim2.new(1, -20, 0, 25)
petNameBox.Position = UDim2.new(0, 10, 0, 35)
petNameBox.PlaceholderText = "Enter Pet Name"
petNameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
petNameBox.BorderSizePixel = 0
petNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
petNameBox.Text = ""

-- KG Box
local kgBox = Instance.new("TextBox", mainFrame)
kgBox.Size = UDim2.new(0.5, -12, 0, 25)
kgBox.Position = UDim2.new(0, 10, 0, 65)
kgBox.PlaceholderText = "KG"
kgBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
kgBox.BorderSizePixel = 0
kgBox.TextColor3 = Color3.fromRGB(255, 255, 255)
kgBox.Text = ""

-- Age Box
local ageBox = Instance.new("TextBox", mainFrame)
ageBox.Size = UDim2.new(0.5, -12, 0, 25)
ageBox.Position = UDim2.new(0.5, 2, 0, 65)
ageBox.PlaceholderText = "Age"
ageBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ageBox.BorderSizePixel = 0
ageBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ageBox.Text = ""

-- Spawn Button
local spawnButton = Instance.new("TextButton", mainFrame)
spawnButton.Size = UDim2.new(1, -20, 0, 30)
spawnButton.Position = UDim2.new(0, 10, 0, 105)
spawnButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
spawnButton.BorderSizePixel = 0
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.Text = "Spawn Pet"
spawnButton.Font = Enum.Font.SourceSansBold
spawnButton.TextSize = 15

spawnButton.MouseButton1Click:Connect(function()
	local petName = petNameBox.Text
	local kg = tonumber(kgBox.Text) or 1
	local age = tonumber(ageBox.Text) or 1

	if petName ~= "" then
		Spawner.SpawnPet(petName, kg, age)
	end
end)

-- Small credit text
local credit = Instance.new("TextLabel", mainFrame)
credit.Size = UDim2.new(1, 0, 0, 15)
credit.Position = UDim2.new(0, 0, 1, -15)
credit.BackgroundTransparency = 1
credit.Text = "Made by MarkOnTop"
credit.TextColor3 = Color3.fromRGB(200, 200, 200)
credit.Font = Enum.Font.SourceSansItalic
credit.TextSize = 10
credit.TextXAlignment = Enum.TextXAlignment.Center
