-- Teleport Module for ULTIMATE Script
local TeleportModule = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function TeleportModule:ToPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end
end

function TeleportModule:ToCFrame(cframe)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = cframe
    end
end

function TeleportModule:GetPlayerNames()
    local names = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

return TeleportModule
