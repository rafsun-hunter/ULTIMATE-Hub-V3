-- Run Module for ULTIMATE Script
local RunModule = {
    Enabled = false,
    WalkSpeed = 16
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Persistent WalkSpeed Logic
RunService.Stepped:Connect(function()
    if RunModule.Enabled then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = RunModule.WalkSpeed
        end
    end
end)

function RunModule:Toggle(value)
    self.Enabled = value
    if not value then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16 -- Reset to default
        end
    end
end

function RunModule:SetSpeed(value)
    self.WalkSpeed = value
end

-- Handle character respawn to re-apply WalkSpeed
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if humanoid and RunModule.Enabled then
        humanoid.WalkSpeed = RunModule.WalkSpeed
    end
end)

return RunModule
