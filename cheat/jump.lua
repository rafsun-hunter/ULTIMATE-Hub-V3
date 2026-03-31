-- Improved Jump Module for ULTIMATE Script (Android Fixed)
local JumpModule = {
    InfiniteJump = false,
    JumpPower = 50
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Fix for Android: Instead of state change, we use Jump property directly
-- JumpRequest works better on PC, but we'll keep it as a fallback
UserInputService.JumpRequest:Connect(function()
    if JumpModule.InfiniteJump then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Setting Jump to true instead of state change avoids hiding the button
            humanoid.Jump = true
        end
    end
end)

function JumpModule:ToggleInfinite(value)
    self.InfiniteJump = value
end

function JumpModule:SetJumpPower(value)
    self.JumpPower = value
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- Ensure UseJumpPower is true to avoid interfering with JumpHeight/Mobile UI
        humanoid.UseJumpPower = true
        humanoid.JumpPower = value
    end
end

-- Handle character respawn
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = JumpModule.JumpPower
    end
end)

return JumpModule
