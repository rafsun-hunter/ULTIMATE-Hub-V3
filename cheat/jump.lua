-- Premium Jump Module for ULTIMATE Script
local JumpModule = {
    AirJump = false,
    JumpPower = 50
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Air Jump Logic (Infinite Jump)
UserInputService.JumpRequest:Connect(function()
    if JumpModule.AirJump then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Use ChangeState but with a small delay to prevent Android UI glitches
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

function JumpModule:ToggleAirJump(value)
    self.AirJump = value
end

function JumpModule:SetJumpPower(value)
    self.JumpPower = value
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = value
    end
end

-- Re-apply on respawn
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = JumpModule.JumpPower
    end
end)

return JumpModule
