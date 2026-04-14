-- Magic & Invisibility Module
local MagicModule = {
    InvisEnabled = false,
    CharacterConnection = nil
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

function MagicModule:SetInvisibility(state)
    self.InvisEnabled = state
    local character = LocalPlayer.Character
    if not character then return end

    if state then
        -- Client-side Invisibility (Making parts transparent)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                end
            end
        end
        
        -- Start loop to keep parts transparent if they change (e.g. tools)
        self.CharacterConnection = character.DescendantAdded:Connect(function(desc)
            if self.InvisEnabled and (desc:IsA("BasePart") or desc:IsA("Decal")) then
                desc.Transparency = 1
            end
        end)
        
        _G.ULTIMATE_NOTIFY("Invisibility Enabled (Client-Side Visual)")
    else
        -- Disable Invisibility
        if self.CharacterConnection then
            self.CharacterConnection:Disconnect()
            self.CharacterConnection = nil
        end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                end
            end
        end
        
        _G.ULTIMATE_NOTIFY("Invisibility Disabled")
    end
end

-- Separate Hitbox function as it was previously mentioned in Magic section
function MagicModule:SetSize(size)
    self.HitboxSize = size
    -- Logic handled in main loop or separate connection usually
end

function MagicModule:Toggle(state)
    -- This handles the Magic Hitbox toggle from main.lua
end

return MagicModule
