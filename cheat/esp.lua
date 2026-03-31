-- Premium ESP Module for ULTIMATE Script
local ESPModule = {
    Enabled = false,
    Boxes = false,
    Names = false,
    Health = false,
    Tracers = false,
    TeamCheck = false,
    PlayerCount = true
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local espCache = {}
local playerCountText = Drawing.new("Text")
playerCountText.Visible = false
playerCountText.Center = true
playerCountText.Outline = true
playerCountText.Font = 2
playerCountText.Size = 18
playerCountText.Color = Color3.fromRGB(255, 255, 255)
playerCountText.Position = Vector2.new(Camera.ViewportSize.X / 2, 30)

local function CreateESP(player)
    local objects = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
        TracerOutline = Drawing.new("Line"),
        HealthBar = Drawing.new("Square"),
        HealthBarOutline = Drawing.new("Square"),
        HealthText = Drawing.new("Text")
    }
    
    -- Setup Box
    objects.Box.Thickness = 1
    objects.Box.Color = Color3.fromRGB(255, 255, 255)
    objects.BoxOutline.Thickness = 3
    objects.BoxOutline.Color = Color3.fromRGB(0, 0, 0)
    
    -- Setup Name
    objects.Name.Center = true
    objects.Name.Outline = true
    objects.Name.Size = 13
    objects.Name.Font = 2
    
    -- Setup Tracer
    objects.Tracer.Thickness = 1
    objects.TracerOutline.Thickness = 3
    objects.TracerOutline.Color = Color3.fromRGB(0, 0, 0)
    
    -- Setup Health
    objects.HealthBar.Filled = true
    objects.HealthBarOutline.Filled = true
    objects.HealthBarOutline.Color = Color3.fromRGB(0, 0, 0)
    objects.HealthText.Size = 12
    objects.HealthText.Outline = true
    objects.HealthText.Font = 2
    
    espCache[player] = objects
end

local function RemoveESP(player)
    if espCache[player] then
        for _, obj in pairs(espCache[player]) do obj:Remove() end
        espCache[player] = nil
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then CreateESP(player) end
end

Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESP(p) end end)
Players.PlayerRemoving:Connect(function(p) RemoveESP(p) end)

RunService.RenderStepped:Connect(function()
    if ESPModule.Enabled then
        if ESPModule.PlayerCount then
            playerCountText.Visible = true
            playerCountText.Text = "Total Players: " .. #Players:GetPlayers()
            playerCountText.Position = Vector2.new(Camera.ViewportSize.X / 2, 40)
        else
            playerCountText.Visible = false
        end

        for player, objects in pairs(espCache) do
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if char and hum and hrp and hum.Health > 0 then
                if ESPModule.TeamCheck and player.Team == LocalPlayer.Team then
                    for _, obj in pairs(objects) do obj.Visible = false end
                    continue
                end

                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    -- Calculate dynamic box size
                    local headPos = Camera:WorldToViewportPoint(char:FindFirstChild("Head").Position + Vector3.new(0, 0.5, 0))
                    local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    local boxHeight = math.abs(headPos.Y - legPos.Y)
                    local boxWidth = boxHeight / 1.5
                    local boxX = screenPos.X - boxWidth / 2
                    local boxY = screenPos.Y - boxHeight / 2

                    -- Visual Color (Team or Health-based)
                    local color = ESPModule.TeamCheck and player.TeamColor.Color or Color3.fromRGB(255, 255, 255)

                    -- Boxes
                    if ESPModule.Boxes then
                        objects.BoxOutline.Size = Vector2.new(boxWidth, boxHeight)
                        objects.BoxOutline.Position = Vector2.new(boxX, boxY)
                        objects.BoxOutline.Visible = true
                        
                        objects.Box.Size = Vector2.new(boxWidth, boxHeight)
                        objects.Box.Position = Vector2.new(boxX, boxY)
                        objects.Box.Color = color
                        objects.Box.Visible = true
                    else
                        objects.Box.Visible = false
                        objects.BoxOutline.Visible = false
                    end

                    -- Names
                    if ESPModule.Names then
                        objects.Name.Text = player.Name
                        objects.Name.Position = Vector2.new(screenPos.X, boxY - 15)
                        objects.Name.Visible = true
                    else
                        objects.Name.Visible = false
                    end

                    -- Health Bar
                    if ESPModule.Health then
                        local hpPercent = hum.Health / hum.MaxHealth
                        local hpColor = Color3.fromHSV(hpPercent / 3, 1, 1)
                        local barHeight = boxHeight * hpPercent
                        
                        objects.HealthBarOutline.Size = Vector2.new(4, boxHeight + 2)
                        objects.HealthBarOutline.Position = Vector2.new(boxX - 6, boxY - 1)
                        objects.HealthBarOutline.Visible = true
                        
                        objects.HealthBar.Size = Vector2.new(2, barHeight)
                        objects.HealthBar.Position = Vector2.new(boxX - 5, boxY + (boxHeight - barHeight))
                        objects.HealthBar.Color = hpColor
                        objects.HealthBar.Visible = true
                        
                        objects.HealthText.Text = tostring(math.floor(hum.Health))
                        objects.HealthText.Position = Vector2.new(boxX - 25, boxY + (boxHeight - barHeight) - 5)
                        objects.HealthText.Color = hpColor
                        objects.HealthText.Visible = true
                    else
                        objects.HealthBar.Visible = false
                        objects.HealthBarOutline.Visible = false
                        objects.HealthText.Visible = false
                    end

                    -- Tracers
                    if ESPModule.Tracers then
                        objects.TracerOutline.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        objects.TracerOutline.To = Vector2.new(screenPos.X, screenPos.Y)
                        objects.TracerOutline.Visible = true
                        
                        objects.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        objects.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                        objects.Tracer.Color = color
                        objects.Tracer.Visible = true
                    else
                        objects.Tracer.Visible = false
                        objects.TracerOutline.Visible = false
                    end
                else
                    for _, obj in pairs(objects) do obj.Visible = false end
                end
            else
                for _, obj in pairs(objects) do obj.Visible = false end
            end
        end
    else
        playerCountText.Visible = false
        for _, objects in pairs(espCache) do
            for _, obj in pairs(objects) do obj.Visible = false end
        end
    end
end)

function ESPModule:Toggle(v) self.Enabled = v end
function ESPModule:SetBoxes(v) self.Boxes = v end
function ESPModule:SetNames(v) self.Names = v end
function ESPModule:SetHealth(v) self.Health = v end
function ESPModule:SetTracers(v) self.Tracers = v end
function ESPModule:SetTeamCheck(v) self.TeamCheck = v end
function ESPModule:SetPlayerCount(v) self.PlayerCount = v end

return ESPModule
