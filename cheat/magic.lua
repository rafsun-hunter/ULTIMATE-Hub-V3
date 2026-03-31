-- Magic Module (Hitbox Expander) for ULTIMATE Script
local MagicModule = {
    Enabled = false,
    Size = 5,
    Transparency = 0.5,
    TeamCheck = false,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

RunService.RenderStepped:Connect(function()
    if MagicModule.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if MagicModule.TeamCheck and player.Team == LocalPlayer.Team then continue end
                
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = Vector3.new(MagicModule.Size, MagicModule.Size, MagicModule.Size)
                hrp.Transparency = MagicModule.Transparency
                hrp.CanCollide = false
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
                hrp.CanCollide = true
            end
        end
    end
end)

function MagicModule:Toggle(value)
    self.Enabled = value
end

function MagicModule:SetSize(value)
    self.Size = value
end

function MagicModule:SetTransparency(value)
    self.Transparency = value
end

function MagicModule:SetTeamCheck(value)
    self.TeamCheck = value
end

return MagicModule
