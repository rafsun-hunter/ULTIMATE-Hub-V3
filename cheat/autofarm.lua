-- Universal Auto-Farm Module for ULTIMATE Script
local AutoFarmModule = {
    AutoClickEnabled = false,
    AutoCollectEnabled = false,
    TargetName = "",
    Range = 50,
    ClickDelay = 0.1,
    Connections = {}
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

function AutoFarmModule:ToggleAutoClick(value)
    self.AutoClickEnabled = value
    if value then
        task.spawn(function()
            while self.AutoClickEnabled do
                -- Simulate Left Click
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(0, 0))
                task.wait(self.ClickDelay)
            end
        end)
    end
end

function AutoFarmModule:ToggleAutoCollect(value)
    self.AutoCollectEnabled = value
    if value then
        self.Connections.Collect = RunService.Heartbeat:Connect(function()
            if not self.AutoCollectEnabled then return end
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            for _, v in pairs(workspace:GetDescendants()) do
                -- Look for items to collect based on name or presence of TouchTransmitter
                if v:IsA("TouchTransmitter") and v.Parent then
                    local part = v.Parent
                    if part:IsA("BasePart") then
                        if (root.Position - part.Position).Magnitude < self.Range then
                            -- Check if target name matches (if specified)
                            if self.TargetName == "" or part.Name:lower():find(self.TargetName:lower()) then
                                -- Fire touch
                                firetouchinterest(root, part, 0)
                                firetouchinterest(root, part, 1)
                            end
                        end
                    end
                end
            end
        end)
    else
        if self.Connections.Collect then
            self.Connections.Collect:Disconnect()
            self.Connections.Collect = nil
        end
    end
end

function AutoFarmModule:SetTarget(name)
    self.TargetName = name
end

function AutoFarmModule:SetRange(value)
    self.Range = value
end

return AutoFarmModule
