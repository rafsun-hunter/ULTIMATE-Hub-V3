-- Premium 2D Radar Module for ULTIMATE Script
local RadarModule = {
    Enabled = false,
    Radius = 100,
    Range = 200, -- Studs to show on radar
    Position = Vector2.new(200, 200),
    Scale = 1,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local radarBackground = Drawing.new("Circle")
local radarOutline = Drawing.new("Circle")
local localPlayerBlip = Drawing.new("Circle")
local blips = {}

-- Setup Background
radarBackground.Visible = false
radarBackground.Radius = RadarModule.Radius
radarBackground.Color = Color3.fromRGB(20, 20, 20)
radarBackground.Transparency = 0.6
radarBackground.Filled = true

radarOutline.Visible = false
radarOutline.Radius = RadarModule.Radius
radarOutline.Color = Color3.fromRGB(255, 255, 255)
radarOutline.Thickness = 2
radarOutline.Transparency = 0.8

localPlayerBlip.Visible = false
localPlayerBlip.Radius = 3
localPlayerBlip.Color = Color3.fromRGB(255, 255, 255)
localPlayerBlip.Filled = true

local function CreateBlip(player)
    local blip = {
        Point = Drawing.new("Circle"),
        Label = Drawing.new("Text")
    }
    
    blip.Point.Radius = 4
    blip.Point.Filled = true
    blip.Point.Visible = false
    
    blip.Label.Size = 12
    blip.Label.Center = true
    blip.Label.Outline = true
    blip.Label.Color = Color3.fromRGB(255, 255, 255)
    blip.Label.Visible = false
    
    blips[player] = blip
end

local function RemoveBlip(player)
    if blips[player] then
        blips[player].Point:Remove()
        blips[player].Label:Remove()
        blips[player] = nil
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then CreateBlip(player) end
end

Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateBlip(p) end end)
Players.PlayerRemoving:Connect(function(p) RemoveBlip(p) end)

RunService.RenderStepped:Connect(function()
    if RadarModule.Enabled then
        local screenCenter = Vector2.new(Camera.ViewportSize.X - RadarModule.Radius - 50, RadarModule.Radius + 100)
        RadarModule.Position = screenCenter
        
        radarBackground.Position = screenCenter
        radarBackground.Visible = true
        
        radarOutline.Position = screenCenter
        radarOutline.Visible = true
        
        localPlayerBlip.Position = screenCenter
        localPlayerBlip.Visible = true
        
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local myPos = root.Position
        local myCFrame = Camera.CFrame -- Use camera rotation for intuitive radar

        for player, blip in pairs(blips) do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                local relPos = myCFrame:PointToObjectSpace(hrp.Position)
                local distance = relPos.Magnitude
                
                -- Map 3D XZ plane to 2D radar XY plane
                local radarRelPos = Vector2.new(relPos.X, relPos.Z) * (RadarModule.Radius / RadarModule.Range)
                
                -- Clamp to radar circle
                if radarRelPos.Magnitude < RadarModule.Radius then
                    blip.Point.Position = screenCenter + Vector2.new(radarRelPos.X, radarRelPos.Y)
                    blip.Point.Color = player.TeamColor.Color
                    blip.Point.Visible = true
                    
                    blip.Label.Text = string.format("%dm", math.floor(distance))
                    blip.Label.Position = blip.Point.Position + Vector2.new(0, 5)
                    blip.Label.Visible = true
                else
                    blip.Point.Visible = false
                    blip.Label.Visible = false
                end
            else
                blip.Point.Visible = false
                blip.Label.Visible = false
            end
        end
    else
        radarBackground.Visible = false
        radarOutline.Visible = false
        localPlayerBlip.Visible = false
        for _, blip in pairs(blips) do
            blip.Point.Visible = false
            blip.Label.Visible = false
        end
    end
end)

function RadarModule:Toggle(v) self.Enabled = v end
function RadarModule:SetRange(v) self.Range = v end

return RadarModule
