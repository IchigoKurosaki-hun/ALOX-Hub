--// ALOX Hub with User Avatar in Sidebar + Classic Grey Theme + Icons + Exit Button + Toggle + All Currency Detection

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
local TitleGradient = Instance.new("UIGradient", Title)
TitleGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 180)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 220))
}
TitleGradient.Rotation = 90

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

-- Tabs (we expose creation functions to _G so Addons can add tabs)
local Tabs = {
	{"Main", 6031071050},
	{"Farm", 6031075931},
	{"Raid", 5858633973},
	{"Misc", 12120687783},
	{"Settings", 6031075938}
}
_G.ALOX_Tabs = {}
_G.ALOX_TabContents = {}

local function createTabButtonInternal(name, iconId, order)
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

	return btn
end

function _G.ALOX_CreateTab(name, iconId)
	-- position based on number of existing tabs
	local order = 0
	for _ in pairs(_G.ALOX_Tabs) do order = order + 1 end

	local btn = createTabButtonInternal(name, iconId, order)
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
		_G.addLog("Tab switched: "..name)
	end)

	_G.ALOX_Tabs[name] = btn
	_G.ALOX_TabContents[name] = frame

	-- attach to sidebar UI hierarchy so visuals show
	btn.Parent = Sidebar

	return frame
end

-- Create initial tabs from list (to match layout and order)
for i, data in ipairs(Tabs) do
	_G.ALOX_CreateTab(data[1], data[2])
end

-- show main tab by default
if _G.ALOX_TabContents["Main"] then
	_G.ALOX_TabContents["Main"].Visible = true
	_G.ALOX_Tabs["Main"].BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end

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
-- set avatar (safe)
local ok, thumb = pcall(function()
	return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)
if ok and thumb then
	avatarImage.Image = thumb
end

-- =====================================================
-- MAIN TAB CONTENT (kept like your original version)
-- =====================================================
do
	local frame = _G.ALOX_TabContents["Main"]
	-- container for small info frames (keeps the original layout)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0, 369, 0, 95)
	container.BackgroundTransparency = 1
	container.Parent = frame

	local listLayout = Instance.new("UIListLayout", container)
	listLayout.Padding = UDim.new(0, 4)

	local function createSmallInfoFrame(parent, title, value, iconId)
		local f = Instance.new("Frame")
		f.Size = UDim2.new(1, -10, 0, 30)
		f.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		f.BorderSizePixel = 0
		f.Parent = parent
		Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

		local icon = Instance.new("ImageLabel")
		icon.Size = UDim2.new(0, 20, 0, 20)
		icon.Position = UDim2.new(0, 5, 0.5, -10)
		icon.BackgroundTransparency = 1
		icon.Image = "rbxassetid://" .. iconId
		icon.Parent = f

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Size = UDim2.new(0.4, 0, 1, 0)
		titleLabel.Position = UDim2.new(0, 30, 0, 0)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = title
		titleLabel.Font = Enum.Font.SourceSansBold
		titleLabel.TextSize = 14
		titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.Parent = f

		local valueLabel = Instance.new("TextLabel")
		valueLabel.Size = UDim2.new(0.5, -5, 1, 0)
		valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
		valueLabel.BackgroundTransparency = 1
		valueLabel.Text = value
		valueLabel.Font = Enum.Font.SourceSans
		valueLabel.TextSize = 14
		valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		valueLabel.TextXAlignment = Enum.TextXAlignment.Left
		valueLabel.Parent = f

		return valueLabel
	end

	local nameLabel = createSmallInfoFrame(container, "Name:", LocalPlayer.Name, "6031068421")
	local idLabel = createSmallInfoFrame(container, "UserId:", tostring(LocalPlayer.UserId), "6031229364")
	local moneyLabel = createSmallInfoFrame(container, "Money:", "Loading...", "6023426926")
	local placeLabel = createSmallInfoFrame(container, "PlaceId:", tostring(game.PlaceId), "6022668888")

	-- logs ScrollingFrame (matches original size/position)
	local logBox = Instance.new("ScrollingFrame")
	logBox.Size = UDim2.new(0, 369, 0, 235)
	logBox.Position = UDim2.new(0, 0, 0, 134)
	logBox.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
	logBox.ScrollBarThickness = 6
	logBox.Parent = frame
	Instance.new("UICorner", logBox).CornerRadius = UDim.new(0, 10)
	local logList = Instance.new("UIListLayout", logBox)
	logList.Padding = UDim.new(0, 4)

	-- addLog global function so addons can call it
	function _G.addLog(msg)
		if not msg then return end
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, -10, 0, 20)
		lbl.BackgroundTransparency = 1
		lbl.Text = tostring(msg)
		lbl.Font = Enum.Font.Gotham
		lbl.TextSize = 16
		lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Parent = logBox
		-- auto-scroll to bottom
		logBox.CanvasPosition = Vector2.new(0, math.huge)
	end

	-- currency & info update loop
	task.spawn(function()
		local lastCurrencies = ""
		while true do
			-- name & id & place
			pcall(function()
				nameLabel.Text = LocalPlayer.Name
				idLabel.Text = tostring(LocalPlayer.UserId)
				placeLabel.Text = tostring(game.PlaceId)
			end)

			-- detect all leaderstats types
			local currencies = {}
			pcall(function()
				if LocalPlayer:FindFirstChild("leaderstats") then
					for _, stat in pairs(LocalPlayer.leaderstats:GetChildren()) do
						if stat:IsA("IntValue") or stat:IsA("NumberValue") or stat:IsA("StringValue") then
							table.insert(currencies, stat.Name .. ": " .. tostring(stat.Value))
						end
					end
				end
			end)

			local currencyText = (#currencies > 0) and table.concat(currencies, " | ") or "N/A"
			if currencyText ~= lastCurrencies then
				moneyLabel.Text = currencyText
				_G.addLog("Currency updated: " .. currencyText)
				lastCurrencies = currencyText
			end

			task.wait(1)
		end
	end)

	_G.addLog("Hub loaded successfully.")
end

-- Right Shift Toggle
UIS.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
		_G.addLog("Hub visibility toggled: " .. tostring(MainFrame.Visible))
	end
end)
