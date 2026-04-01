-- Premium 2D Radar Module with Head Icons for ULTIMATE Script
local RadarModule = {
    Enabled = false,
    Radius = 100,
    Range = 200, -- Studs to show on radar
    Position = Vector2.new(200, 200),
    ShowIcons = true -- Show player head icons
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
        Label = Drawing.new("Text"),
        Icon = nil
    }
    
    blip.Point.Radius = 5
    blip.Point.Filled = true
    blip.Point.Visible = false
    
    blip.Label.Size = 12
    blip.Label.Center = true
    blip.Label.Outline = true
    blip.Label.Color = Color3.fromRGB(255, 255, 255)
    blip.Label.Visible = false
    
    -- Check for Image support (Extension)
    local hasImageSupport, imageObj = pcall(function() return Drawing.new("Image") end)
    if hasImageSupport and imageObj then
        blip.Icon = imageObj
        blip.Icon.Size = Vector2.new(20, 20)
        blip.Icon.Rounding = 10 
        blip.Icon.Visible = false
        
        task.spawn(function()
            local headshotUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=48&height=48&format=png"
            local success, data = pcall(function() return game:HttpGet(headshotUrl) end)
            if success and blip.Icon then
                blip.Icon.Data = data
            end
        end)
    end
    
    blips[player] = blip
end

local function RemoveBlip(player)
    if blips[player] then
        if blips[player].Point then blips[player].Point:Remove() end
        if blips[player].Label then blips[player].Label:Remove() end
        if blips[player].Icon then blips[player].Icon:Remove() end
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
        
        local myCFrame = Camera.CFrame 

        for player, blip in pairs(blips) do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                local relPos = myCFrame:PointToObjectSpace(hrp.Position)
                local distance = relPos.Magnitude
                local radarRelPos = Vector2.new(relPos.X, relPos.Z) * (RadarModule.Radius / RadarModule.Range)
                
                if radarRelPos.Magnitude < RadarModule.Radius then
                    local finalPos = screenCenter + Vector2.new(radarRelPos.X, radarRelPos.Y)
                    
                    if RadarModule.ShowIcons and blip.Icon then
                        blip.Icon.Position = finalPos - (blip.Icon.Size / 2)
                        blip.Icon.Visible = true
                        blip.Point.Visible = false
                    else
                        blip.Point.Position = finalPos
                        blip.Point.Color = player.TeamColor.Color
                        blip.Point.Visible = true
                        if blip.Icon then blip.Icon.Visible = false end
                    end
                    
                    blip.Label.Text = string.format("%dm", math.floor(distance))
                    blip.Label.Position = finalPos + Vector2.new(0, 10)
                    blip.Label.Visible = true
                else
                    blip.Point.Visible = false
                    blip.Label.Visible = false
                    if blip.Icon then blip.Icon.Visible = false end
                end
            else
                blip.Point.Visible = false
                blip.Label.Visible = false
                if blip.Icon then blip.Icon.Visible = false end
            end
        end
    else
        radarBackground.Visible = false
        radarOutline.Visible = false
        localPlayerBlip.Visible = false
        for _, blip in pairs(blips) do
            blip.Point.Visible = false
            blip.Label.Visible = false
            if blip.Icon then blip.Icon.Visible = false end
        end
    end
end)

function RadarModule:Toggle(v) self.Enabled = v end
function RadarModule:SetRange(v) self.Range = v end
function RadarModule:ToggleIcons(v) self.ShowIcons = v end

return RadarModule
