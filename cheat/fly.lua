-- Ultimate Fly & Noclip Module (Mobile Optimized)
local FlyModule = {
    Enabled = false,
    Speed = 1,
    Noclip = true -- Always on for Premium Fly
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local bodyVelocity, bodyGyro
local heartbeatConn, noclipConn

local function getDirection()
    local dir = Vector3.new(0, 0, 0)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    
    -- PC Controls (WASD + Space/Shift)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

    -- Mobile/Joystick Support: If moving with joystick, use camera look vector to go where looking
    if dir.Magnitude == 0 and hum and hum.MoveDirection.Magnitude > 0 then
        -- This logic makes it so moving the joystick "forward" moves you where your camera is looking
        local moveDir = hum.MoveDirection
        dir = (Camera.CFrame.LookVector * moveDir.Z * -1) + (Camera.CFrame.RightVector * moveDir.X)
        
        -- If just moving forward on mobile, also allow looking up/down to change altitude
        if moveDir.Z ~= 0 or moveDir.X ~= 0 then
            dir = (Camera.CFrame.LookVector * (moveDir.Magnitude))
        end
    end
    
    return dir
end

local function setNoclip(state)
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then 
                        part.CanCollide = false 
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end

function FlyModule:Toggle(value)
    self.Enabled = value
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    if self.Enabled then
        setNoclip(true)
        hum.PlatformStand = true
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Parent = root
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.CFrame = root.CFrame
        bodyGyro.Parent = root
        
        heartbeatConn = RunService.Heartbeat:Connect(function()
            local dir = getDirection()
            bodyVelocity.Velocity = dir * (self.Speed * 50)
            bodyGyro.CFrame = Camera.CFrame
        end)
    else
        setNoclip(false)
        if heartbeatConn then heartbeatConn:Disconnect() heartbeatConn = nil end
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        if hum then hum.PlatformStand = false end
    end
end

function FlyModule:SetSpeed(value)
    self.Speed = value
end

return FlyModule
