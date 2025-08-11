-- ALOX_Addons.lua (Editable)
-- Example usage: add tabs and UI into the already-built ALOX UI

-- Simple example: add a Farm tab with a button and toggle
local farmTab = _G.ALOX_CreateTab("Farm", 6031075931)

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 30)
btn.Position = UDim2.new(0, 10, 0, 10)
btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Text = "Start Farming"
btn.Parent = farmTab
btn.MouseButton1Click:Connect(function()
	_G.addLog("Start Farming clicked")
end)

-- Example toggle (manual)
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 200, 0, 30)
toggle.Position = UDim2.new(0, 10, 0, 50)
toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.Text = "Auto Collect: OFF"
toggle.Parent = farmTab
local toggled = false
toggle.MouseButton1Click:Connect(function()
	toggled = not toggled
	toggle.Text = "Auto Collect: " .. (toggled and "ON" or "OFF")
	_G.addLog("Auto Collect set to " .. tostring(toggled))
end)
