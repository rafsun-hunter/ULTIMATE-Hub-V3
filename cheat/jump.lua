-- Jump Module for ULTIMATE Script
local JumpModule = {
    InfiniteJump = false,
    JumpPower = 50
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Infinite Jump Logic
UserInputService.JumpRequest:Connect(function()
    if JumpModule.InfiniteJump then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
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
        humanoid.UseJumpPower = true
        humanoid.JumpPower = value
    end
end

-- Handle character respawn to re-apply JumpPower
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = JumpModule.JumpPower
    end
end)

return JumpModule
