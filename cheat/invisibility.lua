-- Premium FE Invisibility Module (Advanced Seat Method) for ULTIMATE Script
-- This method exploits seat replication to hide you from others.
-- Includes a "Proxy Touch" loop to fix the item pickup issue.

local InvisibilityModule = {
    Enabled = false,
    CurrentSeat = nil,
    StagingPos = Vector3.new(0, 5000, 0),
    Transparency = 0.5,
    Connections = {}
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function setCharacterTransparency(char, amount)
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
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if not (root and torso and hum) then
        warn("ULTIMATE Hub | Required character parts missing for Invisibility")
        self.Enabled = false
        return
    end

    if self.Enabled then
        -- ENABLE
        if self.CurrentSeat then self.CurrentSeat:Destroy() end
        
        local originalCFrame = root.CFrame
        
        -- 1. Create Local Seat
        self.CurrentSeat = Instance.new("Seat")
        self.CurrentSeat.Name = "ULTIMATE_InvisSeat"
        self.CurrentSeat.Transparency = 1
        self.CurrentSeat.CanCollide = false
        self.CurrentSeat.Anchored = false
        self.CurrentSeat.CFrame = originalCFrame
        self.CurrentSeat.Parent = workspace
        
        -- 2. Weld Torso to Seat (Physics Exploit)
        local weld = Instance.new("Weld")
        weld.Name = "ULTIMATE_InvisWeld"
        weld.Part0 = self.CurrentSeat
        weld.Part1 = torso
        weld.C0 = CFrame.new(0, 0, 0)
        weld.Parent = self.CurrentSeat
        
        -- 3. Move character to staging briefly to force replication break
        root.CFrame = CFrame.new(self.StagingPos)
        task.wait(0.15)
        
        -- 4. Move Seat (and character) back to original spot
        self.CurrentSeat.CFrame = originalCFrame
        
        -- 5. Visuals (Local Only)
        setCharacterTransparency(char, self.Transparency)
        
        -- 6. ITEM PICKUP FIX (Proxy Touch)
        -- Since sitting can disable Touched, we manually check for items
        self.Connections.Pickup = RunService.Heartbeat:Connect(function()
            if not self.Enabled then return end
            for _, item in pairs(workspace:GetChildren()) do
                -- Check for tools or items with a handle
                if item:IsA("BackpackItem") or item:FindFirstChild("Handle") then
                    local handle = item:FindFirstChild("Handle") or item
                    if handle:IsA("BasePart") and (root.Position - handle.Position).Magnitude < 6 then
                        -- Use firetouchinterest if available, else try physical touch
                        if firetouchinterest then
                            firetouchinterest(root, handle, 0)
                            task.wait()
                            firetouchinterest(root, handle, 1)
                        else
                            -- Fallback: Move handle to us briefly
                            handle.CFrame = root.CFrame
                        end
                    end
                end
            end
        end)
        
        print("ULTIMATE Hub | FE Invisibility (Seat Method + Pickup Fix) Enabled")
    else
        -- DISABLE
        for _, conn in pairs(self.Connections) do conn:Disconnect() end
        self.Connections = {}
        
        if self.CurrentSeat then
            self.CurrentSeat:Destroy()
            self.CurrentSeat = nil
        end
        
        setCharacterTransparency(char, 0)
        root.CFrame = root.CFrame * CFrame.new(0, 0.1, 0)
        
        print("ULTIMATE Hub | FE Invisibility Disabled")
    end
end

return InvisibilityModule
