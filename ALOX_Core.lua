-- ALOX_Core.lua

local function safeLoad(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok then
        return loadstring(res)()
    else
        warn("[ALOX Hub] Failed to fetch: "..url)
    end
end

-- Load UI
safeLoad("https://raw.githubusercontent.com/IchigoKurosaki-hun/ALOX-Hub/main/ALOX_Base.lua")

-- Load Editable Addons
safeLoad("https://raw.githubusercontent.com/IchigoKurosaki-hun/ALOX-Hub/main/ALOX_Addons.lua")
