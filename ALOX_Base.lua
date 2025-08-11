--// ALOX Hub - Base UI (with Player Info + Logs)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ALOX_Hub"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 20)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -170, 1, 0)
ContentFrame.Position = UDim2.new(0, 170, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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
ExitButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

-- Tabs
local Tabs = {
	{"Main", 6031071050},
	{"Farm", 6031075931},
	{"Raid", 5858633973},
	{"Misc", 12120687783},
	{"Settings", 6031075938}
}
local TabButtons, TabContents = {}, {}

local function createTabButton(name, iconId, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 138, 0, 34)
	btn.Position = UDim2.new(0, 10, 0, 70 + (order * 38))
	btn.Text = ""
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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

	btn.MouseButton1Click:Connect(function()
		for tabName, content in pairs(TabContents) do
			content.Visible = (tabName == name)
			TabButtons[tabName].BackgroundColor3 = (tabName == name) and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
		end
	end)

	TabButtons[name] = btn
end

local function createContentFrame(name)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -20, 1, -20)
	frame.Position = UDim2.new(0, 10, 0, 10)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Parent = ContentFrame
	TabContents[name] = frame
end

for i, data in ipairs(Tabs) do
	createTabButton(data[1], data[2], i)
	createContentFrame(data[1])
end

TabContents["Main"].Visible = true
TabButtons["Main"].BackgroundColor3 = Color3.fromRGB(70, 70, 70)

-- Main Tab Info + Logs
local frame = TabContents["Main"]

local function createInfoLine(yPos, labelText)
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0, 300, 0, 20)
	textLabel.Position = UDim2.new(0, 0, 0, yPos)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = labelText
	textLabel.Font = Enum.Font.Gotham
	textLabel.TextSize = 14
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Parent = frame
	return textLabel
end

local nameLabel = createInfoLine(0, "Name: " .. LocalPlayer.Name)
local idLabel = createInfoLine(20, "UserId: " .. LocalPlayer.UserId)
local placeLabel = createInfoLine(40, "PlaceId: " .. game.PlaceId)
local moneyLabel = createInfoLine(60, "Money: Loading...")

task.spawn(function()
	while true do
		nameLabel.Text = "Name: " .. LocalPlayer.Name
		idLabel.Text = "UserId: " .. LocalPlayer.UserId
		placeLabel.Text = "PlaceId: " .. game.PlaceId

		local currencies = {}
		if LocalPlayer:FindFirstChild("leaderstats") then
			for _, stat in pairs(LocalPlayer.leaderstats:GetChildren()) do
				table.insert(currencies, stat.Name .. ": " .. stat.Value)
			end
		end
		moneyLabel.Text = (#currencies > 0) and ("Money: " .. table.concat(currencies, " | ")) or "Money: N/A"

		task.wait(1)
	end
end)

-- Logs box
local logBox = Instance.new("ScrollingFrame")
logBox.Size = UDim2.new(0, 400, 0, 200)
logBox.Position = UDim2.new(0, 0, 0, 90)
logBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
logBox.ScrollBarThickness = 6
logBox.Parent = frame
Instance.new("UICorner", logBox).CornerRadius = UDim.new(0, 8)
local logList = Instance.new("UIListLayout", logBox)
logList.Padding = UDim.new(0, 2)

function _G.addLog(msg)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -10, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.Text = msg
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 14
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = logBox
end

_G.addLog("Hub loaded successfully.")

-- Toggle with RightShift
UIS.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
