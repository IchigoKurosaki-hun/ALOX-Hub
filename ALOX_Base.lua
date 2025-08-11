--// ALOX Hub with User Avatar in Sidebar + Classic Grey Theme + Icons + Exit Button + Toggle + All Currency Detection

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ALOX_Hub"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)

-- Dragging
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.BackgroundTransparency = 0.15
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 20)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -170, 1, 0)
ContentFrame.Position = UDim2.new(0, 170, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ContentFrame.BackgroundTransparency = 0.15
ContentFrame.BorderSizePixel = 2
ContentFrame.BorderColor3 = Color3.fromRGB(70, 70, 70)
ContentFrame.Parent = MainFrame
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 20)
Instance.new("UIPadding", ContentFrame).PaddingTop = UDim.new(0, 10)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 65)
Title.Text = "ALOX Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 32
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Parent = Sidebar

-- Exit Button
local ExitButton = Instance.new("TextButton")
ExitButton.Size = UDim2.new(0, 30, 0, 30)
ExitButton.Position = UDim2.new(1, -40, 0, 10)
ExitButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ExitButton.Text = "X"
ExitButton.Font = Enum.Font.GothamBold
ExitButton.TextSize = 18
ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExitButton.Parent = MainFrame
Instance.new("UICorner", ExitButton).CornerRadius = UDim.new(0, 6)

ExitButton.MouseEnter:Connect(function()
	TweenService:Create(ExitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)
ExitButton.MouseLeave:Connect(function()
	TweenService:Create(ExitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
end)
ExitButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

-- Tabs
_G.ALOX_Tabs = {}
_G.ALOX_TabContents = {}

function _G.ALOX_CreateTab(name, iconId)
	local order = #_G.ALOX_Tabs
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 138, 0, 34)
	btn.Position = UDim2.new(0, 10, 0, 70 + (order * 38))
	btn.Text = ""
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 14
	btn.Parent = Sidebar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 20)

	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.new(0, 20, 0, 20)
	icon.Position = UDim2.new(0, 10, 0.5, -10)
	icon.BackgroundTransparency = 1
	icon.Image = "rbxassetid://" .. iconId
	icon.Parent = btn

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -40, 1, 0)
	label.Position = UDim2.new(0, 35, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = btn

	local frame = Instance.new("Frame")
	frame.Name = name .. "_Content"
	frame.Size = UDim2.new(1, -20, 1, -20)
	frame.Position = UDim2.new(0, 10, 0, 10)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Parent = ContentFrame

	btn.MouseButton1Click:Connect(function()
		for tabName, f in pairs(_G.ALOX_TabContents) do
			f.Visible = (tabName == name)
		end
		for tabName, b in pairs(_G.ALOX_Tabs) do
			b.BackgroundColor3 = (tabName == name) and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
		end
	end)

	_G.ALOX_Tabs[name] = btn
	_G.ALOX_TabContents[name] = frame

	return frame
end

-- Default Main tab
local mainTab = _G.ALOX_CreateTab("Main", 6031071050)

-- Example info in Main tab
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -10, 0, 30)
infoLabel.Text = "ALOX Hub Loaded"
infoLabel.TextColor3 = Color3.fromRGB(255,255,255)
infoLabel.BackgroundTransparency = 1
infoLabel.Parent = mainTab

-- Avatar in Sidebar
local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(0, 119, 0, 76)
avatarImage.Position = UDim2.new(0, 20, 1, -100)
avatarImage.BackgroundTransparency = 1
avatarImage.Parent = Sidebar
Instance.new("UICorner", avatarImage).CornerRadius = UDim.new(1, 0)
local avatarOutline = Instance.new("UIStroke", avatarImage)
avatarOutline.Thickness = 2
avatarOutline.Color = Color3.fromRGB(255, 255, 255)
local content, _ = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
avatarImage.Image = content

-- Right Shift Toggle
UIS.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
