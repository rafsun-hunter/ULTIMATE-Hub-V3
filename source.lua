--[[
    ULTIMATE UI Library
    Developed for high performance and sleek aesthetics.
]]

local ULTIMATE = {
    Themes = {
        Default = {
            MainColor = Color3.fromRGB(30, 30, 30),
            AccentColor = Color3.fromRGB(0, 122, 255),
            BackgroundColor = Color3.fromRGB(20, 20, 20),
            TextColor = Color3.fromRGB(255, 255, 255),
            SecondaryTextColor = Color3.fromRGB(200, 200, 200),
            ElementColor = Color3.fromRGB(40, 40, 40),
            StrokeColor = Color3.fromRGB(50, 50, 50),
        }
    }
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local function Tween(obj, info, goal)
    local tween = TweenService:Create(obj, TweenInfo.new(unpack(info)), goal)
    tween:Play()
    return tween
end

function ULTIMATE:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "ULTIMATE"
    local LoadingTitle = config.LoadingTitle or "ULTIMATE Library"
    local LoadingSubtitle = config.LoadingSubtitle or "Loading..."
    local KeySystem = config.KeySystem or false
    local KeySettings = config.KeySettings or {}

    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ULTIMATE_UI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = CoreGui
    end

    -- Loading System
    local function StartLoading()
        local LoadingFrame = Instance.new("Frame")
        LoadingFrame.Name = "LoadingFrame"
        LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
        LoadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        LoadingFrame.BackgroundTransparency = 0
        LoadingFrame.Parent = ScreenGui

        local Logo = Instance.new("ImageLabel")
        Logo.Name = "Logo"
        Logo.Size = UDim2.new(0, 100, 0, 100)
        Logo.Position = UDim2.new(0.5, -50, 0.45, -50)
        Logo.BackgroundTransparency = 1
        Logo.Image = config.Logo or "rbxassetid://6031280306" -- Default placeholder
        Logo.ImageTransparency = 1
        Logo.Parent = LoadingFrame

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(0, 400, 0, 30)
        Title.Position = UDim2.new(0.5, -200, 0.6, 0)
        Title.BackgroundTransparency = 1
        Title.Text = LoadingTitle:upper()
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 24
        Title.Font = Enum.Font.GothamBold
        Title.TextTransparency = 1
        Title.Parent = LoadingFrame

        local Subtitle = Instance.new("TextLabel")
        Subtitle.Size = UDim2.new(0, 400, 0, 20)
        Subtitle.Position = UDim2.new(0.5, -200, 0.65, 0)
        Subtitle.BackgroundTransparency = 1
        Subtitle.Text = LoadingSubtitle
        Subtitle.TextColor3 = ULTIMATE.Themes.Default.SecondaryTextColor
        Subtitle.TextSize = 14
        Subtitle.Font = Enum.Font.Gotham
        Subtitle.TextTransparency = 1
        Subtitle.Parent = LoadingFrame

        -- Animation Sequence
        Tween(Logo, {1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out}, {ImageTransparency = 0, Size = UDim2.new(0, 120, 0, 120), Position = UDim2.new(0.5, -60, 0.45, -60)})
        task.wait(0.5)
        Tween(Title, {0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out}, {TextTransparency = 0, Position = UDim2.new(0.5, -200, 0.58, 0)})
        task.wait(0.2)
        Tween(Subtitle, {0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out}, {TextTransparency = 0, Position = UDim2.new(0.5, -200, 0.63, 0)})

        -- Breathing Effect
        local breathing = true
        task.spawn(function()
            while breathing do
                Tween(Logo, {1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut}, {Size = UDim2.new(0, 110, 0, 110), Position = UDim2.new(0.5, -55, 0.45, -55)})
                task.wait(1.5)
                Tween(Logo, {1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut}, {Size = UDim2.new(0, 120, 0, 120), Position = UDim2.new(0.5, -60, 0.45, -60)})
                task.wait(1.5)
            end
        end)

        task.wait(3)
        breathing = false

        -- Fade Out
        Tween(Logo, {0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.In}, {ImageTransparency = 1, Size = UDim2.new(0, 100, 0, 100), Position = UDim2.new(0.5, -50, 0.45, -50)})
        Tween(Title, {0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.In}, {TextTransparency = 1})
        Tween(Subtitle, {0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.In}, {TextTransparency = 1})
        task.wait(0.5)
        Tween(LoadingFrame, {0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.In}, {BackgroundTransparency = 1})
        task.wait(0.8)
        LoadingFrame:Destroy()
    end

    -- Key System
    local function CheckKey()
        if not KeySystem then return true end
        
        local KeyVerified = false
        local KeyPrompt = Instance.new("Frame")
        KeyPrompt.Name = "KeyPrompt"
        KeyPrompt.Size = UDim2.new(0, 400, 0, 200)
        KeyPrompt.Position = UDim2.new(0.5, -200, 0.5, -100)
        KeyPrompt.BackgroundColor3 = ULTIMATE.Themes.Default.BackgroundColor
        KeyPrompt.Parent = ScreenGui

        local KeyCorner = Instance.new("UICorner")
        KeyCorner.CornerRadius = UDim.new(0, 8)
        KeyCorner.Parent = KeyPrompt

        local KeyStroke = Instance.new("UIStroke")
        KeyStroke.Color = ULTIMATE.Themes.Default.AccentColor
        KeyStroke.Thickness = 2
        KeyStroke.Parent = KeyPrompt

        local KeyTitle = Instance.new("TextLabel")
        KeyTitle.Size = UDim2.new(1, 0, 0, 50)
        KeyTitle.BackgroundTransparency = 1
        KeyTitle.Text = KeySettings.Title or "Key System"
        KeyTitle.TextColor3 = ULTIMATE.Themes.Default.TextColor
        KeyTitle.TextSize = 20
        KeyTitle.Font = Enum.Font.GothamBold
        KeyTitle.Parent = KeyPrompt

        local KeyInput = Instance.new("TextBox")
        KeyInput.Size = UDim2.new(0, 300, 0, 40)
        KeyInput.Position = UDim2.new(0.5, -150, 0.4, 0)
        KeyInput.BackgroundColor3 = ULTIMATE.Themes.Default.ElementColor
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Enter Key..."
        KeyInput.TextColor3 = ULTIMATE.Themes.Default.TextColor
        KeyInput.Font = Enum.Font.Gotham
        KeyInput.TextSize = 14
        KeyInput.Parent = KeyPrompt

        local KeyInputCorner = Instance.new("UICorner")
        KeyInputCorner.CornerRadius = UDim.new(0, 6)
        KeyInputCorner.Parent = KeyInput

        local VerifyButton = Instance.new("TextButton")
        VerifyButton.Size = UDim2.new(0, 140, 0, 40)
        VerifyButton.Position = UDim2.new(0.5, -150, 0.7, 0)
        VerifyButton.BackgroundColor3 = ULTIMATE.Themes.Default.AccentColor
        VerifyButton.Text = "Verify"
        VerifyButton.TextColor3 = ULTIMATE.Themes.Default.TextColor
        VerifyButton.Font = Enum.Font.GothamBold
        VerifyButton.TextSize = 14
        VerifyButton.Parent = KeyPrompt

        local VerifyCorner = Instance.new("UICorner")
        VerifyCorner.CornerRadius = UDim.new(0, 6)
        VerifyCorner.Parent = VerifyButton

        local GetKeyButton = Instance.new("TextButton")
        GetKeyButton.Size = UDim2.new(0, 140, 0, 40)
        GetKeyButton.Position = UDim2.new(0.5, 10, 0.7, 0)
        GetKeyButton.BackgroundColor3 = ULTIMATE.Themes.Default.ElementColor
        GetKeyButton.Text = "Get Key"
        GetKeyButton.TextColor3 = ULTIMATE.Themes.Default.TextColor
        GetKeyButton.Font = Enum.Font.GothamBold
        GetKeyButton.TextSize = 14
        GetKeyButton.Parent = KeyPrompt

        local GetKeyCorner = Instance.new("UICorner")
        GetKeyCorner.CornerRadius = UDim.new(0, 6)
        GetKeyCorner.Parent = GetKeyButton

        VerifyButton.MouseButton1Click:Connect(function()
            local input = KeyInput.Text
            local keys = KeySettings.Key
            if type(keys) == "string" then keys = {keys} end
            
            for _, k in pairs(keys) do
                if input == k then
                    KeyVerified = true
                    KeyPrompt:Destroy()
                    break
                end
            end
            if not KeyVerified then
                KeyInput.Text = ""
                KeyInput.PlaceholderText = "Invalid Key!"
                task.wait(1)
                KeyInput.PlaceholderText = "Enter Key..."
            end
        end)

        GetKeyButton.MouseButton1Click:Connect(function()
            if KeySettings.Note then
                setclipboard(KeySettings.Note)
                GetKeyButton.Text = "Link Copied!"
                task.wait(1)
                GetKeyButton.Text = "Get Key"
            end
        end)

        repeat task.wait() until KeyVerified
        return true
    end

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = ULTIMATE.Themes.Default.BackgroundColor
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Visible = false
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = ULTIMATE.Themes.Default.StrokeColor
    MainStroke.Thickness = 1
    MainStroke.Parent = Main

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = ULTIMATE.Themes.Default.MainColor
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar

    local SidebarLine = Instance.new("Frame")
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, 0, 0, 0)
    SidebarLine.BackgroundColor3 = ULTIMATE.Themes.Default.StrokeColor
    SidebarLine.BorderSizePixel = 0
    SidebarLine.Parent = Sidebar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 50)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = WindowName
    TitleLabel.TextColor3 = ULTIMATE.Themes.Default.TextColor
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Parent = Sidebar

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -150, 1, 0)
    Container.Position = UDim2.new(0, 150, 0, 0)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local TabButtons = Instance.new("ScrollingFrame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, 0, 1, -60)
    TabButtons.Position = UDim2.new(0, 0, 0, 55)
    TabButtons.BackgroundTransparency = 1
    TabButtons.ScrollBarThickness = 0
    TabButtons.Parent = Sidebar

    local TabButtonsLayout = Instance.new("UIListLayout")
    TabButtonsLayout.Padding = UDim.new(0, 5)
    TabButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabButtonsLayout.Parent = TabButtons

    local function makeDraggable(obj)
        local dragging, dragInput, dragStart, startPos
        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        obj.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    makeDraggable(Sidebar)

    local function ShowMain()
        Main.Visible = true
        Main.Size = UDim2.new(0, 0, 0, 0)
        Tween(Main, {0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.new(0, 500, 0, 350)})
    end

    if CheckKey() then
        StartLoading()
        ShowMain()
    end

    local Window = {}
    local Tabs = {}
    local FirstTab = true

    function Window:CreateTab(name, icon)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name.."_TabButton"
        TabButton.Size = UDim2.new(0, 130, 0, 35)
        TabButton.BackgroundColor3 = ULTIMATE.Themes.Default.ElementColor
        TabButton.Text = name
        TabButton.TextColor3 = ULTIMATE.Themes.Default.SecondaryTextColor
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabButtons

        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name.."_TabContent"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = ULTIMATE.Themes.Default.AccentColor
        TabContent.Parent = Container

        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Padding = UDim.new(0, 8)
        TabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabContentLayout.Parent = TabContent

        local TabContentPadding = Instance.new("UIPadding")
        TabContentPadding.PaddingTop = UDim.new(0, 10)
        TabContentPadding.Parent = TabContent

        if FirstTab then
            TabContent.Visible = true
            TabButton.TextColor3 = ULTIMATE.Themes.Default.TextColor
            TabButton.BackgroundColor3 = ULTIMATE.Themes.Default.AccentColor
            FirstTab = false
        end

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Content.Visible = false
                t.Button.TextColor3 = ULTIMATE.Themes.Default.SecondaryTextColor
                t.Button.BackgroundColor3 = ULTIMATE.Themes.Default.ElementColor
            end
            TabContent.Visible = true
            TabButton.TextColor3 = ULTIMATE.Themes.Default.TextColor
            Tween(TabButton, {0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {BackgroundColor3 = ULTIMATE.Themes.Default.AccentColor})
        end)

        table.insert(Tabs, {Button = TabButton, Content = TabContent})

        local Tab = {}
        
        function Tab:CreateSection(name)
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = name.."_Section"
            SectionTitle.Size = UDim2.new(0, 320, 0, 20)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = name:upper()
            SectionTitle.TextColor3 = ULTIMATE.Themes.Default.AccentColor
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextSize = 12
            SectionTitle.TextXAlignment = Enum.HorizontalAlignment.Left
            SectionTitle.Parent = TabContent

            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.PaddingLeft = UDim.new(0, 5)
            SectionPadding.Parent = SectionTitle
        end

        function Tab:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Name = name.."_Button"
            Button.Size = UDim2.new(0, 320, 0, 38)
            Button.BackgroundColor3 = ULTIMATE.Themes.Default.ElementColor
            Button.Text = name
            Button.TextColor3 = ULTIMATE.Themes.Default.TextColor
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.AutoButtonColor = false
            Button.Parent = TabContent

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button

            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = ULTIMATE.Themes.Default.StrokeColor
            ButtonStroke.Thickness = 1
            ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            ButtonStroke.Parent = Button

            Button.MouseEnter:Connect(function()
                Tween(Button, {0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
                Tween(ButtonStroke, {0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Color = ULTIMATE.Themes.Default.AccentColor})
            end)

            Button.MouseLeave:Connect(function()
                Tween(Button, {0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {BackgroundColor3 = ULTIMATE.Themes.Default.ElementColor})
                Tween(ButtonStroke, {0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Color = ULTIMATE.Themes.Default.StrokeColor})
            end)

            Button.MouseButton1Click:Connect(function()
                Tween(Button, {0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = UDim2.new(0, 315, 0, 36)})
                task.wait(0.1)
                Tween(Button, {0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = UDim2.new(0, 320, 0, 38)})
                callback()
            end)
            return Button
        end

        function Tab:CreateToggle(name, default, callback)
            local Toggled = default or false
            local Toggle = Instance.new("TextButton")
            Toggle.Name = name.."_Toggle"
            Toggle.Size = UDim2.new(0, 320, 0, 38)
            Toggle.BackgroundColor3 = ULTIMATE.Themes.Default.ElementColor
            Toggle.Text = name
            Toggle.TextColor3 = ULTIMATE.Themes.Default.TextColor
            Toggle.Font = Enum.Font.Gotham
            Toggle.TextSize = 14
            Toggle.TextXAlignment = Enum.TextXAlignment.Left
            Toggle.AutoButtonColor = false
            Toggle.Parent = TabContent

            local TogglePadding = Instance.new("UIPadding")
            TogglePadding.PaddingLeft = UDim.new(0, 15)
            TogglePadding.Parent = Toggle

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = Toggle

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 40, 0, 20)
            Box.Position = UDim2.new(1, -55, 0.5, -10)
            Box.BackgroundColor3 = Toggled and ULTIMATE.Themes.Default.AccentColor or Color3.fromRGB(60, 60, 60)
            Box.Parent = Toggle

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(1, 0)
            BoxCorner.Parent = Box

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Parent = Box

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = Circle

            Toggle.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Tween(Box, {0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {BackgroundColor3 = Toggled and ULTIMATE.Themes.Default.AccentColor or Color3.fromRGB(60, 60, 60)})
                Tween(Circle, {0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                callback(Toggled)
            end)
            return Toggle
        end

        function Tab:CreateSlider(name, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Name = name.."_Slider"
            Slider.Size = UDim2.new(0, 320, 0, 50)
            Slider.BackgroundColor3 = ULTIMATE.Themes.Default.ElementColor
            Slider.Parent = TabContent

            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = Slider

            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Size = UDim2.new(1, -20, 0, 25)
            SliderTitle.Position = UDim2.new(0, 10, 0, 0)
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Text = name
            SliderTitle.TextColor3 = ULTIMATE.Themes.Default.TextColor
            SliderTitle.Font = Enum.Font.Gotham
            SliderTitle.TextSize = 14
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            SliderTitle.Parent = Slider

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 50, 0, 25)
            ValueLabel.Position = UDim2.new(1, -60, 0, 0)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(default or min)
            ValueLabel.TextColor3 = ULTIMATE.Themes.Default.SecondaryTextColor
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = Slider

            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 4)
            SliderBar.Position = UDim2.new(0, 10, 0.7, 0)
            SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = Slider

            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar

            local Fill = Instance.new("Frame")
            local initialFill = (default - min) / (max - min)
            Fill.Size = UDim2.new(initialFill, 0, 1, 0)
            Fill.BackgroundColor3 = ULTIMATE.Themes.Default.AccentColor
            Fill.BorderSizePixel = 0
            Fill.Parent = SliderBar

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local dragging = false
            local function update(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                local val = math.floor(min + (max - min) * pos)
                ValueLabel.Text = tostring(val)
                callback(val)
            end

            Slider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)
            return Slider
        end
        return Tab
    end

    return Window
end

return ULTIMATE
