-- Magic & Invisibility Module
local MagicModule = {
    InvisEnabled = false,
    HitboxEnabled = false,
    HitboxSize = 5,
    CharacterConnection = nil
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Character Invisibility (Client-Side)
function MagicModule:SetInvisibility(state)
    self.InvisEnabled = state
    local character = LocalPlayer.Character
    if not character then return end

    if state then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if part.Name ~= "HumanoidRootPart" then part.Transparency = 1 end
            end
        end
        self.CharacterConnection = character.DescendantAdded:Connect(function(desc)
            if self.InvisEnabled and (desc:IsA("BasePart") or desc:IsA("Decal")) then
                desc.Transparency = 1
            end
        end)
    else
        if self.CharacterConnection then self.CharacterConnection:Disconnect() end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if part.Name ~= "HumanoidRootPart" then part.Transparency = 0 end
            end
        end
    end
end

-- Magic Hitbox (Expands parts for easier hitting)
function MagicModule:SetSize(size)
    self.HitboxSize = size
end

function MagicModule:ToggleHitbox(state)
    self.HitboxEnabled = state
    if state then
        task.spawn(function()
            while self.HitboxEnabled do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = player.Character.HumanoidRootPart
                        hrp.Size = Vector3.new(self.HitboxSize, self.HitboxSize, self.HitboxSize)
                        hrp.Transparency = 0.7
                        hrp.BrickColor = BrickColor.new("Really blue")
                        hrp.CanCollide = false
                    end
                end
                task.wait(0.5)
            end
            -- Reset when disabled
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    player.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end)
    end
end

return MagicModule
