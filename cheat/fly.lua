local FlyModule = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local flying = false
local speed = 1
local bodyGyro, bodyVelocity
local heartbeatConnection

function FlyModule:Toggle(value)
    flying = value
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid then return end

    if flying then
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.cframe = rootPart.CFrame
        bodyGyro.Parent = rootPart

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.velocity = Vector3.new(0, 0, 0)
        bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Parent = rootPart

        humanoid.PlatformStand = true

        heartbeatConnection = RunService.Heartbeat:Connect(function()
            local direction = Vector3.new(0, 0, 0)
            
            -- PC Controls
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0, 1, 0) end

            -- Mobile/Auto-Forward (If moving)
            if direction.Magnitude == 0 and humanoid.MoveDirection.Magnitude > 0 then
                direction = humanoid.MoveDirection
            end

            bodyVelocity.Velocity = direction * (speed * 50)
            bodyGyro.CFrame = Camera.CFrame
        end)
    else
        if heartbeatConnection then heartbeatConnection:Disconnect() heartbeatConnection = nil end
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        humanoid.PlatformStand = false
    end
end

function FlyModule:SetSpeed(value)
    speed = value
end

return FlyModule
