-- ALOX_Core.lua
-- Safe loader: loads Base UI and editable addons from your GitHub repo

local function safeLoad(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and type(res) == "string" then
        local fn, err = loadstring(res)
        if fn then
            local ok2, err2 = pcall(fn)
            if not ok2 then
                warn("[ALOX Hub] Error running code from:", url, err2)
            end
        else
            warn("[ALOX Hub] loadstring failed for:", url, err)
        end
    else
        warn("[ALOX Hub] Failed to fetch:", url)
    end
end

-- replace with your repo path if different
local baseURL    = "https://raw.githubusercontent.com/IchigoKurosaki-hun/ALOX-Hub/main/ALOX_Base.lua"
local addonsURL  = "https://raw.githubusercontent.com/IchigoKurosaki-hun/ALOX-Hub/main/ALOX_Addons.lua"

safeLoad(baseURL)   -- builds the UI (locked)
safeLoad(addonsURL) -- applies editable addons
