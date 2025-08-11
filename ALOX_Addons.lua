-- ALOX_Addons.lua (Editable)

/* Example Usage: */

local farmTab = _G.ALOX_CreateTab("Farm", 6031075931)

farmTab:AddButton({
    Name = "Start Farming",
    Callback = function()
        print("Started farming!")
    end
})

farmTab:AddToggle({
    Name = "Auto Collect",
    Default = false,
    Callback = function(value)
        print("Auto Collect:", value)
    end
})
