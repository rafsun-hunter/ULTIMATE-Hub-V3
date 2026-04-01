-- Premium FE Invisibility Module for ULTIMATE Script
-- This method uses the HumanoidRootPart replacement trick to hide from others.
local InvisibilityModule = {
    Enabled = false,
    Character = nil,
    RootPart = nil,
    StoredPosition = nil,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

function InvisibilityModule:Toggle(value)
    if self.Enabled == value then return end
    self.Enabled = value
    
    local char = LocalPlayer.Character
    if not char then 
        self.Enabled = false
        return 
    end

    if self.Enabled then
        -- Store character and current position
        self.Character = char
        self.RootPart = char:FindFirstChild("HumanoidRootPart")
        
        if not self.RootPart then
            warn("ULTIMATE Hub | HumanoidRootPart not found for Invisibility")
            self.Enabled = false
            return
        end
        
        self.StoredPosition = self.RootPart.CFrame
        
        -- Process:
        -- 1. Create a platform locally so we don't fall while transitioning
        local platform = Instance.new("Part")
        platform.Size = Vector3.new(10, 1, 10)
        platform.Anchored = true
        platform.CanCollide = true
        platform.Transparency = 1
        platform.CFrame = self.StoredPosition * CFrame.new(0, -3.5, 0)
        platform.Parent = workspace
        
        -- 2. Clone the RootPart
        local newRoot = self.RootPart:Clone()
        
        -- 3. Destroy original (Breaks server replication of your position)
        self.RootPart:Destroy()
        
        -- 4. Set new RootPart
        newRoot.Parent = char
        newRoot.CFrame = self.StoredPosition
        
        -- 5. Restore Humanoid focus
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            workspace.CurrentCamera.CameraSubject = humanoid
        end
        
        -- Cleanup platform
        task.delay(1, function() platform:Destroy() end)
        
        print("ULTIMATE Hub | FE Invisibility Enabled")
    else
        -- Restore: FE Invisibility usually requires a reset to sync back with the server.
        print("ULTIMATE Hub | Invisibility Disabled (Reset to sync with server)")
        
        -- Try to notify the user via print if they don't have a UI notification handler here
        -- The UI handles the notification in main.lua
    end
end

return InvisibilityModule
