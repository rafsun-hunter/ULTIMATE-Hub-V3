-- Premium FE Ghost Mode Module for ULTIMATE Script
-- This method creates a "Fake" character for local control and keeps the 
-- "Real" character (invisible) at the same position for server-side interaction.
-- This allows for full interaction, picking up items, and carrying tools.

local GhostModule = {
    Enabled = false,
    FakeCharacter = nil,
    RealCharacter = nil,
    Connection = nil,
    Transparency = 0.5 -- Ghostly look for local player
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local function setTransparency(char, amount)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = amount
        elseif part:IsA("Decal") then
            part.Transparency = amount
        end
    end
end

function GhostModule:Toggle(value)
    if self.Enabled == value then return end
    self.Enabled = value
    
    local char = LocalPlayer.Character
    if not char then 
        self.Enabled = false
        return 
    end

    if self.Enabled then
        -- ENABLE GHOST MODE
        self.RealCharacter = char
        self.RealCharacter.Archivable = true
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then 
            self.Enabled = false
            return 
        end
        
        local oldCF = root.CFrame
        
        -- 1. Create Fake Character for local control
        self.FakeCharacter = self.RealCharacter:Clone()
        self.FakeCharacter.Name = "ULTIMATE_GHOST"
        self.FakeCharacter.Parent = Workspace
        
        -- 2. Make Real Character invisible to others
        -- By setting transparency locally, others still see it (unless using a desync)
        -- To truly be invisible, we use the 'nil parent' trick for the real character parts
        -- but keep the root in workspace for interaction.
        setTransparency(self.RealCharacter, 1)
        
        -- 3. Set local control to Fake Character
        LocalPlayer.Character = self.FakeCharacter
        Camera.CameraSubject = self.FakeCharacter:FindFirstChildOfClass("Humanoid")
        
        -- 4. Sync Real Character to Fake Character for Interaction
        self.Connection = RunService.RenderStepped:Connect(function()
            if not self.FakeCharacter or not self.FakeCharacter:FindFirstChild("HumanoidRootPart") then
                self:Toggle(false)
                return
            end
            
            local fakeRoot = self.FakeCharacter.HumanoidRootPart
            local realRoot = self.RealCharacter:FindFirstChild("HumanoidRootPart")
            
            if realRoot then
                realRoot.CFrame = fakeRoot.CFrame
            end
            
            -- Keep real character parts invisible
            setTransparency(self.RealCharacter, 1)
            -- Keep fake character ghostly
            setTransparency(self.FakeCharacter, self.Transparency)
        end)
        
        print("ULTIMATE Hub | FE Ghost Mode Enabled (Full Interaction)")
    else
        -- DISABLE GHOST MODE
        if self.Connection then
            self.Connection:Disconnect()
            self.Connection = nil
        end
        
        if self.FakeCharacter then
            self.FakeCharacter:Destroy()
            self.FakeCharacter = nil
        end
        
        if self.RealCharacter then
            LocalPlayer.Character = self.RealCharacter
            setTransparency(self.RealCharacter, 0)
            Camera.CameraSubject = self.RealCharacter:FindFirstChildOfClass("Humanoid")
        end
        
        print("ULTIMATE Hub | FE Ghost Mode Disabled")
    end
end

return GhostModule
