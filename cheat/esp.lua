-- Simple ESP Module for ULTIMATE Script
local ESPModule = {
    Enabled = false,
    Boxes = false,
    Names = false,
    Tracers = false,
    TeamCheck = false,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local espTable = {}

local function CreateESP(player)
    local espObj = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
    }
    
    espObj.Box.Visible = false
    espObj.Box.Thickness = 1
    espObj.Box.Color = Color3.fromRGB(255, 0, 0)
    
    espObj.Name.Visible = false
    espObj.Name.Center = true
    espObj.Name.Outline = true
    espObj.Name.Size = 13
    espObj.Name.Color = Color3.fromRGB(255, 255, 255)
    
    espObj.Tracer.Visible = false
    espObj.Tracer.Thickness = 1
    espObj.Tracer.Color = Color3.fromRGB(255, 0, 0)
    
    espTable[player] = espObj
end

local function RemoveESP(player)
    if espTable[player] then
        espTable[player].Box:Remove()
        espTable[player].Name:Remove()
        espTable[player].Tracer:Remove()
        espTable[player] = nil
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

RunService.RenderStepped:Connect(function()
    if ESPModule.Enabled then
        for player, espObj in pairs(espTable) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                if ESPModule.TeamCheck and player.Team == LocalPlayer.Team then
                    espObj.Box.Visible = false
                    espObj.Name.Visible = false
                    espObj.Tracer.Visible = false
                    continue
                end
                
                local hrp = player.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                if onScreen then
                    if ESPModule.Boxes then
                        local size = (Camera:WorldToViewportPoint(hrp.Position + Vector3.new(2, 3, 0)).Y - Camera:WorldToViewportPoint(hrp.Position - Vector3.new(2, 3, 0)).Y)
                        espObj.Box.Size = Vector2.new(math.abs(size), math.abs(size))
                        espObj.Box.Position = Vector2.new(screenPos.X - espObj.Box.Size.X / 2, screenPos.Y - espObj.Box.Size.Y / 2)
                        espObj.Box.Visible = true
                    else
                        espObj.Box.Visible = false
                    end
                    
                    if ESPModule.Names then
                        espObj.Name.Text = player.Name
                        espObj.Name.Position = Vector2.new(screenPos.X, screenPos.Y - (espObj.Box.Size.Y / 2) - 15)
                        espObj.Name.Visible = true
                    else
                        espObj.Name.Visible = false
                    end
                    
                    if ESPModule.Tracers then
                        espObj.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        espObj.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                        espObj.Tracer.Visible = true
                    else
                        espObj.Tracer.Visible = false
                    end
                else
                    espObj.Box.Visible = false
                    espObj.Name.Visible = false
                    espObj.Tracer.Visible = false
                end
            else
                espObj.Box.Visible = false
                espObj.Name.Visible = false
                espObj.Tracer.Visible = false
            end
        end
    else
        for _, espObj in pairs(espTable) do
            espObj.Box.Visible = false
            espObj.Name.Visible = false
            espObj.Tracer.Visible = false
        end
    end
end)

function ESPModule:Toggle(value)
    self.Enabled = value
end

function ESPModule:SetBoxes(value)
    self.Boxes = value
end

function ESPModule:SetNames(value)
    self.Names = value
end

function ESPModule:SetTracers(value)
    self.Tracers = value
end

function ESPModule:SetTeamCheck(value)
    self.TeamCheck = value
end

return ESPModule
