-- Unnamed ESP Wrapper for ULTIMATE Script
local ESPModule = {
    Loaded = false,
    Options = nil
}

local repo = "https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua"

function ESPModule:Load()
    if self.Loaded then return end
    
    local success, source = pcall(function()
        return game:HttpGet(repo)
    end)
    
    if success then
        -- Modify source to expose Options table globally
        -- We look for 'local Options = {}' and change it
        local modifiedSource = source:gsub("local Options = setmetatable%(%{}, %{", "getgenv().UnnamedESPOptions = setmetatable({}, {")
        
        -- We also need to expose the function that creates options if needed, 
        -- but usually, the table is enough if we can access the objects.
        
        local func, err = loadstring(modifiedSource)
        if func then
            task.spawn(func)
            self.Loaded = true
            
            -- Wait for the table to be initialized
            local timeout = 5
            local start = tick()
            while not getgenv().UnnamedESPOptions and tick() - start < timeout do
                task.wait(0.1)
            end
            
            self.Options = getgenv().UnnamedESPOptions
            
            -- Hide the default menu by default
            if self.Options and self.Options.MenuOpen then
                self.Options.MenuOpen(false)
            end
        else
            warn("ULTIMATE Hub | Failed to compile Unnamed ESP: " .. tostring(err))
        end
    else
        warn("ULTIMATE Hub | Failed to fetch Unnamed ESP from GitHub")
    end
end

function ESPModule:Toggle(value)
    if not self.Loaded then self:Load() end
    if self.Options and self.Options.Enabled then
        self.Options.Enabled(value)
    end
end

function ESPModule:SetBoxes(value)
    if not self.Loaded then self:Load() end
    if self.Options and self.Options.ShowBoxes then
        self.Options.ShowBoxes(value)
    end
end

function ESPModule:SetNames(value)
    if not self.Loaded then self:Load() end
    if self.Options and self.Options.ShowName then
        self.Options.ShowName(value)
    end
end

function ESPModule:SetTracers(value)
    if not self.Loaded then self:Load() end
    if self.Options and self.Options.ShowTracers then
        self.Options.ShowTracers(value)
    end
end

function ESPModule:SetTeamCheck(value)
    if not self.Loaded then self:Load() end
    if self.Options and self.Options.ShowTeam then
        -- Unnamed ESP 'ShowTeam' true means show teammates, false means hide (Team Check ON)
        self.Options.ShowTeam(not value)
    end
end

-- Extra features from Unnamed ESP
function ESPModule:SetHealth(value)
    if not self.Loaded then self:Load() end
    if self.Options and self.Options.ShowHealth then
        self.Options.ShowHealth(value)
    end
end

function ESPModule:SetDistance(value)
    if not self.Loaded then self:Load() end
    if self.Options and self.Options.ShowDistance then
        self.Options.ShowDistance(value)
    end
end

return ESPModule
