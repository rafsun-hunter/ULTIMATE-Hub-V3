-- Universal Invisibility Module for ULTIMATE Script
local InvisibilityModule = {
    Enabled = false,
    StoredCharacter = nil,
    OldParent = nil,
    Connection = nil
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

function InvisibilityModule:Toggle(value)
    self.Enabled = value
    local char = LocalPlayer.Character
    if not char then return end

    if self.Enabled then
        -- Method: Local Character Spoofing
        -- This hides your character from most server-side and client-side entity checks
        self.StoredCharacter = char
        self.OldParent = char.Parent
        
        -- Set character property to nil locally
        LocalPlayer.Character = nil
        
        -- Move real character to a safe location or keep it but hide it
        -- We'll hide it in a folder that many scripts don't check
        char.Parent = game:GetService("Lighting")
        
        -- Keep camera focused on where the character WAS (or a proxy)
        self.Connection = RunService.RenderStepped:Connect(function()
            if self.Enabled then
                Camera.CameraSubject = char:FindFirstChildOfClass("Humanoid")
            end
        end)
        
        print("ULTIMATE Hub | Invisibility Enabled (Character spoofed)")
    else
        -- Restore Character
        if self.StoredCharacter then
            self.StoredCharacter.Parent = self.OldParent or workspace
            LocalPlayer.Character = self.StoredCharacter
            
            if self.Connection then
                self.Connection:Disconnect()
                self.Connection = nil
            end
            
            Camera.CameraSubject = self.StoredCharacter:FindFirstChildOfClass("Humanoid")
        end
        print("ULTIMATE Hub | Invisibility Disabled")
    end
end

return InvisibilityModule
