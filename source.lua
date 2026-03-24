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
        LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        LoadingFrame.BackgroundTransparency = 1
        LoadingFrame.Parent = ScreenGui

        local Blur = Instance.new("BlurEffect")
        Blur.Size = 0
        Blur.Parent = game:GetService("Lighting")

        Tween(LoadingFrame, {0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {BackgroundTransparency = 0.2})
        Tween(Blur, {0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = 20})

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(0, 400, 0, 50)
        Title.Position = UDim2.new(0.5, -200, 0.45, -25)
        Title.BackgroundTransparency = 1
        Title.Text = LoadingTitle
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 30
        Title.Font = Enum.Font.GothamBold
        Title.TextTransparency = 1
        Title.Parent = LoadingFrame

        local Subtitle = Instance.new("TextLabel")
        Subtitle.Size = UDim2.new(0, 400, 0, 30)
        Subtitle.Position = UDim2.new(0.5, -200, 0.5, 10)
        Subtitle.BackgroundTransparency = 1
        Subtitle.Text = LoadingSubtitle
        Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
        Subtitle.TextSize = 18
        Subtitle.Font = Enum.Font.Gotham
        Subtitle.TextTransparency = 1
        Subtitle.Parent = LoadingFrame

        Tween(Title, {0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {TextTransparency = 0})
        task.wait(0.2)
        Tween(Subtitle, {0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {TextTransparency = 0})

        task.wait(1.5)

        Tween(Title, {0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In}, {TextTransparency = 1})
        Tween(Subtitle, {0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In}, {TextTransparency = 1})
        task.wait(0.3)
        Tween(LoadingFrame, {0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In}, {BackgroundTransparency = 1})
        Tween(Blur, {0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In}, {Size = 0})
        task.wait(0.5)
        LoadingFrame:Destroy()
        Blur:Destroy()
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
        function Tab:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0, 320, 0, 40)
            Button.BackgroundColor3 = ULTIMATE.Themes.Default.ElementColor
            Button.Text = name
            Button.TextColor3 = ULTIMATE.Themes.Default.TextColor
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.AutoButtonColor = true
            Button.Parent = TabContent

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button

            Button.MouseButton1Click:Connect(function()
                callback()
            end)
            return Button
        end
        return Tab
    end

    return Window
end

return ULTIMATE
