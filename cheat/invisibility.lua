-- Premium FE Void Invisibility Module for ULTIMATE Script
-- This method teleports character parts (Head, Torso, Arms, Legs) to a 
-- remote location while keeping the HumanoidRootPart local.
-- This ensures you are invisible to others while maintaining full 
-- interaction support (picking up items, carrying tools).

local InvisibilityModule = {
    Enabled = false,
    StoredParts = {},
    VoidPosition = Vector3.new(0, 10000, 0), -- High in the sky
    Transparency = 0.5, -- Local ghost effect
    Connection = nil
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function setTransparency(char, amount)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = amount
        elseif part:IsA("Decal") then
            part.Transparency = amount
        end
    end
end

function InvisibilityModule:Toggle(value)
    if self.Enabled == value then return end
    self.Enabled = value
    
    local char = LocalPlayer.Character
    if not char then 
        self.Enabled = false
        return 
    end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then 
        self.Enabled = false
        return 
    end

    if self.Enabled then
        -- ENABLE INVISIBILITY
        -- We don't destroy parts, we just move them away from the root locally.
        -- On the server, since the joints (Welds/Motor6Ds) are still active,
        -- but the parts are offset, it often breaks replication for other clients.
        
        self.Connection = RunService.RenderStepped:Connect(function()
            if not self.Enabled or not char or not root then 
                if self.Connection then self.Connection:Disconnect() end
                return 
            end
            
            -- Keep parts in the void locally
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = false
                    -- Offset parts to void
                    part.CFrame = CFrame.new(self.VoidPosition)
                end
            end
            
            -- Local Ghost Effect (so you can see where you are)
            -- We create a local ghost if needed, but for now just use transparency
            setTransparency(char, self.Transparency)
        end)
        
        print("ULTIMATE Hub | FE Void Invisibility Enabled (Full Interaction)")
    else
        -- DISABLE INVISIBILITY
        if self.Connection then
            self.Connection:Disconnect()
            self.Connection = nil
        end
        
        -- Restore parts to their natural positions relative to root
        -- Most Roblox joints will auto-snap back when CFrame overrides stop
        setTransparency(char, 0)
        
        -- Force a character refresh/small move to snap parts back
        root.CFrame = root.CFrame * CFrame.new(0, 0.1, 0)
        
        print("ULTIMATE Hub | FE Void Invisibility Disabled")
    end
end

return InvisibilityModule
