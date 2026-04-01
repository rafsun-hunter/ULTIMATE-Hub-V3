-- Improved Run Module for ULTIMATE Script
local RunModule = {
    Enabled = false,
    WalkSpeed = 16,
    Bypass = false -- CFrame Bypass for restricted games
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Persistent movement logic
RunService.Stepped:Connect(function()
    if RunModule.Enabled then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and hrp then
            if RunModule.Bypass then
                -- Method: CFrame Manipulation (Bypasses WalkSpeed resets)
                if humanoid.MoveDirection.Magnitude > 0 then
                    -- Move character forward manually based on WalkSpeed
                    -- (WalkSpeed / 100) is a rough multiplier for per-step movement
                    hrp.CFrame = hrp.CFrame + (humanoid.MoveDirection * (RunModule.WalkSpeed / 150))
                end
                -- Keep speed normal to avoid detection while bypassing
                humanoid.WalkSpeed = 16
            else
                -- Standard Method: Constant Property Setting
                humanoid.WalkSpeed = RunModule.WalkSpeed
            end
        end
    end
end)

function RunModule:Toggle(value)
    self.Enabled = value
    if not value then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16 -- Reset
        end
    end
end

function RunModule:SetSpeed(value)
    self.WalkSpeed = value
end

function RunModule:ToggleBypass(value)
    self.Bypass = value
end

-- Handle character respawn
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if humanoid and RunModule.Enabled and not RunModule.Bypass then
        humanoid.WalkSpeed = RunModule.WalkSpeed
    end
end)

return RunModule
