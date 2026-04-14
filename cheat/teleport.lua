-- Advanced Waypoint & Teleport Module
local TeleportModule = {}

-- Persistent storage (survives script reloads and character deaths)
_G.ULTIMATE_WAYPOINTS = _G.ULTIMATE_WAYPOINTS or {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Save current position
function TeleportModule:SavePosition(name)
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        local posName = name or ("Position_" .. (table.find(_G.ULTIMATE_WAYPOINTS, nil) or #_G.ULTIMATE_WAYPOINTS + 1))
        _G.ULTIMATE_WAYPOINTS[posName] = hrp.CFrame
        return true, posName
    end
    return false, "Character not found"
end

-- Teleport to saved position
function TeleportModule:ToWaypoint(name)
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local targetCFrame = _G.ULTIMATE_WAYPOINTS[name]
    
    if hrp and targetCFrame then
        hrp.CFrame = targetCFrame
        return true
    end
    return false
end

-- Rename position
function TeleportModule:RenameWaypoint(oldName, newName)
    if _G.ULTIMATE_WAYPOINTS[oldName] and newName and newName ~= "" then
        local cframe = _G.ULTIMATE_WAYPOINTS[oldName]
        _G.ULTIMATE_WAYPOINTS[oldName] = nil
        _G.ULTIMATE_WAYPOINTS[newName] = cframe
        return true
    end
    return false
end

-- Delete position
function TeleportModule:DeleteWaypoint(name)
    if _G.ULTIMATE_WAYPOINTS[name] then
        _G.ULTIMATE_WAYPOINTS[name] = nil
        return true
    end
    return false
end

-- Get list of names for UI dropdown
function TeleportModule:GetWaypointNames()
    local names = {}
    for name, _ in pairs(_G.ULTIMATE_WAYPOINTS) do
        table.insert(names, name)
    end
    return names
end

-- Existing function for player teleports
function TeleportModule:GetPlayerNames()
    local names = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

function TeleportModule:ToPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
        hrp.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end

return TeleportModule
