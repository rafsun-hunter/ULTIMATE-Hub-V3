-- Cross-Platform Aimbot Module
local AimbotModule = {
    Enabled = false,
    AutoLock = false, -- Useful for Mobile
    Settings = {
        TeamCheck = false,
        FOV = 100,
    }
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Radius = AimbotModule.Settings.FOV

local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = AimbotModule.Settings.FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if AimbotModule.Settings.TeamCheck and player.Team == LocalPlayer.Team then continue end

            local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if AimbotModule.Enabled then
        fovCircle.Visible = true
        fovCircle.Radius = AimbotModule.Settings.FOV
        fovCircle.Position = UserInputService:GetMouseLocation()

        -- Trigger: Right Click (PC) OR AutoLock (Mobile)
        local isTriggered = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or AimbotModule.AutoLock
        
        if isTriggered then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            end
        end
    else
        fovCircle.Visible = false
    end
end)

function AimbotModule:Toggle(value) self.Enabled = value end
function AimbotModule:SetAutoLock(value) self.AutoLock = value end
function AimbotModule:SetFOV(value) self.Settings.FOV = value end
function AimbotModule:SetTeamCheck(value) self.Settings.TeamCheck = value end

return AimbotModule
