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
    
    -- Attempt to create Image for Head Icon
    pcall(function()
        blip.Icon = Drawing.new("Image")
        blip.Icon.Size = Vector2.new(16, 16)
        blip.Icon.Rounding = 8 -- Make it circular if supported
        blip.Icon.Visible = false
        
        -- Get the player's headshot thumbnail
        -- This uses rbxthumb:// which is standard in many executors now
        local headshotUrl = "rbxthumb://type=HeadShot&id=" .. player.UserId .. "&w=48&h=48"
        
        -- Depending on the executor, this property might be Data or Image
        -- We'll try common implementations
        local success, err = pcall(function()
            if blip.Icon.Data ~= nil then
                blip.Icon.Data = game:HttpGet(headshotUrl)
            elseif blip.Icon.Image ~= nil then
                blip.Icon.Image = headshotUrl
            end
        end)
    end)
    
    blips[player] = blip
end

local function RemoveBlip(player)
    if blips[player] then
        blips[player].Point:Remove()
        blips[player].Label:Remove()
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
        
        local myCFrame = Camera.CFrame -- Use camera rotation for intuitive radar

        for player, blip in pairs(blips) do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                local relPos = myCFrame:PointToObjectSpace(hrp.Position)
                local distance = relPos.Magnitude
                
                -- Map 3D XZ plane to 2D radar XY plane (X is X, Z is Y on 2D)
                local radarRelPos = Vector2.new(relPos.X, relPos.Z) * (RadarModule.Radius / RadarModule.Range)
                
                -- Check if it's within the radar circle
                if radarRelPos.Magnitude < RadarModule.Radius then
                    local finalPos = screenCenter + Vector2.new(radarRelPos.X, radarRelPos.Y)
                    
                    if RadarModule.ShowIcons and blip.Icon then
                        blip.Icon.Position = finalPos - (blip.Icon.Size / 2)
                        blip.Icon.Visible = true
                        blip.Point.Visible = false -- Hide the circle if we have an icon
                    else
                        blip.Point.Position = finalPos
                        blip.Point.Color = player.TeamColor.Color
                        blip.Point.Visible = true
                    end
                    
                    blip.Label.Text = string.format("%dm", math.floor(distance))
                    blip.Label.Position = finalPos + Vector2.new(0, 8)
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
