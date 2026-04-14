local repo = "https://raw.githubusercontent.com/rafsun-hunter/ULTIMATE-Hub-V3/main/"

print("ULTIMATE Hub | Initializing...")

-- Load Rayfield Library (with fallback)
local function getRayfield()
    local officialUrl = 'https://sirius.menu/rayfield'
    local fallbackUrl = repo .. "source.lua"
    
    local success, source = pcall(game.HttpGet, game, officialUrl)
    if not success or not source or #source < 1000 then
        warn("ULTIMATE Hub | Failed to load from sirius.menu, trying fallback...")
        success, source = pcall(game.HttpGet, game, fallbackUrl)
    end
    
    if not success or not source or #source < 1000 then
        error("ULTIMATE Hub | Critical Error: Could not load Rayfield Library from any source.")
    end
    
    local func, err = loadstring(source)
    if not func then error("ULTIMATE Hub | Rayfield Syntax Error: " .. tostring(err)) end
    
    local ok, lib = pcall(func)
    if not ok then error("ULTIMATE Hub | Rayfield Runtime Error: " .. tostring(lib)) end
    
    return lib
end

local Rayfield = getRayfield()

-- Global Notification Helper
_G.ULTIMATE_NOTIFY = function(msg)
    Rayfield:Notify({
        Title = "ULTIMATE HUB V3",
        Content = msg,
        Duration = 5,
        Image = "rbxassetid://4483362458",
    })
end

local function loadModule(path)
    local success, source = pcall(game.HttpGet, repo .. path)
    if not success then return nil end
    local func, err = loadstring(source)
    if func then
        local success, result = pcall(func)
        if success then return result end
    end
    return nil
end

-- Load Login Module
local Login = loadModule("cheat/login.lua")
local keyFilePath = "UltimateHubV3/Key.txt"

local function saveKey(key)
    if not isfolder("UltimateHubV3") then makefolder("UltimateHubV3") end
    writefile(keyFilePath, key)
end

local function getSavedKey()
    if isfile(keyFilePath) then 
        local key = readfile(keyFilePath)
        if key and #key > 0 then return key end
    end
    return nil
end

local authenticated = false
local savedKey = getSavedKey()

-- Create Window first so we can show notifications
local Window = Rayfield:CreateWindow({
   Name = "ULTIMATE HUB V3 | rafsunboss",
   LoadingTitle = "ULTIMATE Hub V3",
   LoadingSubtitle = "by rafsun-hunter",
   ConfigurationSaving = { Enabled = true, FolderName = "UltimateHubV3", FileName = "Config" },
   KeySystem = false
})

if savedKey and Login then
    print("ULTIMATE Hub | Verifying saved key...")
    _G.ULTIMATE_NOTIFY("Verifying saved key, please wait...")
    if Login:Verify(savedKey) then
        authenticated = true
        _G.ULTIMATE_NOTIFY("Auto-Login Successful!")
    else
        _G.ULTIMATE_NOTIFY("Saved key expired or invalid. Please login again.")
    end
end

if not authenticated and Login then
    local LoginTab = Window:CreateTab("Login", 4483362458)
    LoginTab:CreateSection("Key System")
    
    LoginTab:CreateButton({
        Name = "Get Key (Copy Link)",
        Callback = function()
            local success, link = Login:GetLink()
            if success then
                if setclipboard then setclipboard(link) end
                _G.ULTIMATE_NOTIFY("Key link copied to clipboard!")
            end
        end
    })
    
    local keyInput = savedKey or ""
    LoginTab:CreateInput({
        Name = "Enter Key",
        CurrentValue = savedKey or "",
        PlaceholderText = "Paste key here...",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            keyInput = Text
        end,
    })
    
    LoginTab:CreateButton({
        Name = "Verify & Login",
        Callback = function()
            if not keyInput or keyInput == "" then _G.ULTIMATE_NOTIFY("Please enter a key first.") return end
            
            _G.ULTIMATE_NOTIFY("Verifying key...")
            if Login:Verify(keyInput) then
                saveKey(keyInput)
                _G.ULTIMATE_NOTIFY("Success! Loading Hub...")
                task.wait(1)
                Rayfield:Destroy()
                -- Reload the script to enter the Hub
                loadstring(game:HttpGet(repo .. "main.lua"))()
            end
        end
    })
else
    -- Main Hub Logic starts here
    print("ULTIMATE Hub | Loading modules...")

    -- Load Feature Modules
    local Fly = loadModule("cheat/fly.lua")
    local Aimbot = loadModule("cheat/aimbot.lua")
    local ESP = loadModule("cheat/esp.lua")
    local Teleport = loadModule("cheat/teleport.lua")
    local Magic = loadModule("cheat/magic.lua")
    local Jump = loadModule("cheat/jump.lua")
    local Radar = loadModule("cheat/radar.lua")
    local Run = loadModule("cheat/run.lua")
    local Invisibility = loadModule("cheat/invisibility.lua")
    local Stamina = loadModule("cheat/stamina.lua")
    local AutoFarm = loadModule("cheat/autofarm.lua")

    -- Combat Tab
    local CombatTab = Window:CreateTab("Combat", 4483362458)
    if Aimbot then
        CombatTab:CreateSection("Aimbot")
        CombatTab:CreateToggle({ Name = "Enable Aimbot", CurrentValue = false, Flag = "AimbotToggle", Callback = function(Value) Aimbot:Toggle(Value) end })
        CombatTab:CreateToggle({ Name = "Auto-Lock (Mobile Friendly)", CurrentValue = false, Flag = "AimbotAutoLock", Callback = function(Value) Aimbot:SetAutoLock(Value) end })
        CombatTab:CreateSlider({ Name = "Aimbot FOV", Range = {10, 500}, Increment = 1, Suffix = "Radius", CurrentValue = 100, Flag = "AimbotFOV", Callback = function(Value) Aimbot:SetFOV(Value) end })
    end
    if Magic then
        CombatTab:CreateSection("Magic & Invisibility")
        CombatTab:CreateToggle({ 
            Name = "Enable Magic Hitbox", 
            CurrentValue = false, 
            Flag = "MagicToggle", 
            Callback = function(Value) Magic:Toggle(Value) end 
        })
        CombatTab:CreateSlider({ 
            Name = "Hitbox Size", 
            Range = {2, 50}, 
            Increment = 1, 
            Suffix = "Studs", 
            CurrentValue = 5, 
            Flag = "HitboxSize", 
            Callback = function(Value) Magic:SetSize(Value) end 
        })
        CombatTab:CreateToggle({
            Name = "Character Invisibility",
            CurrentValue = false,
            Flag = "InvisToggle",
            Callback = function(Value) Magic:SetInvisibility(Value) end
        })
    end

    -- Visuals Tab
    local VisualsTab = Window:CreateTab("Visuals", 4483345998)
    if ESP then
        VisualsTab:CreateSection("Premium ESP")
        VisualsTab:CreateToggle({ Name = "Enable ESP", CurrentValue = false, Flag = "ESPToggle", Callback = function(Value) ESP:Toggle(Value) end })
        VisualsTab:CreateToggle({ Name = "Player Count (Top)", CurrentValue = true, Flag = "ESPPlayerCount", Callback = function(Value) ESP:SetPlayerCount(Value) end })
        VisualsTab:CreateToggle({ Name = "ESP Boxes (Outlined)", CurrentValue = false, Flag = "ESPBoxes", Callback = function(Value) ESP:SetBoxes(Value) end })
        VisualsTab:CreateToggle({ Name = "ESP Box Fill", CurrentValue = false, Flag = "ESPBoxFill", Callback = function(Value) ESP:SetBoxFill(Value) end })
        VisualsTab:CreateToggle({ Name = "Character Glow (Chams)", CurrentValue = false, Flag = "ESPGlow", Callback = function(Value) ESP:SetGlow(Value) end })
        VisualsTab:CreateToggle({ Name = "ESP Names (Outlined)", CurrentValue = false, Flag = "ESPNames", Callback = function(Value) ESP:SetNames(Value) end })
        VisualsTab:CreateToggle({ Name = "ESP Health (Bar + Text)", CurrentValue = false, Flag = "ESPHealth", Callback = function(Value) ESP:SetHealth(Value) end })
        VisualsTab:CreateToggle({ Name = "ESP Tracers (Outlined)", CurrentValue = false, Flag = "ESPTracers", Callback = function(Value) ESP:SetTracers(Value) end })
        VisualsTab:CreateToggle({ Name = "ESP Team Check", CurrentValue = false, Flag = "ESPTeamCheck", Callback = function(Value) ESP:SetTeamCheck(Value) end })
    end
    if Radar then
        VisualsTab:CreateSection("2D Radar")
        VisualsTab:CreateToggle({ Name = "Enable 2D Radar", CurrentValue = false, Flag = "RadarToggle", Callback = function(Value) Radar:Toggle(Value) end })
        VisualsTab:CreateSlider({ Name = "Radar Range", Range = {50, 1000}, Increment = 10, Suffix = "Studs", CurrentValue = 200, Flag = "RadarRange", Callback = function(Value) Radar:SetRange(Value) end })
        VisualsTab:CreateToggle({ Name = "Show Radar Icons", CurrentValue = true, Flag = "RadarIcons", Callback = function(Value) Radar:ToggleIcons(Value) end })
    end

    -- Movement Tab
    local MovementTab = Window:CreateTab("Movement", 4483362135)
    if Fly then
        MovementTab:CreateSection("Premium Flight")
        MovementTab:CreateToggle({ Name = "Enable Fly", CurrentValue = false, Flag = "FlyToggle", Callback = function(Value) Fly:Toggle(Value) end })
        MovementTab:CreateSlider({ Name = "Fly Speed", Range = {1, 10}, Increment = 0.5, Suffix = "x", CurrentValue = 1, Flag = "FlySpeed", Callback = function(Value) Fly:SetSpeed(Value) end })
    end
    if Run then
        MovementTab:CreateSection("Speed Hacks")
        MovementTab:CreateToggle({ Name = "Fast Run", CurrentValue = false, Flag = "FastRun", Callback = function(Value) Run:Toggle(Value) end })
        MovementTab:CreateSlider({ Name = "Walk Speed", Range = {1, 1000}, Increment = 1, Suffix = "Speed", CurrentValue = 16, Flag = "WalkSpeed", Callback = function(Value) Run:SetSpeed(Value) end })
    end
    if Jump then
        MovementTab:CreateSection("Jump Hacks")
        MovementTab:CreateToggle({ Name = "Air Jump (Infinite)", CurrentValue = false, Flag = "AirJump", Callback = function(Value) Jump:ToggleAirJump(Value) end })
        MovementTab:CreateSlider({ Name = "Jump Power", Range = {1, 2000}, Increment = 1, Suffix = "Power", CurrentValue = 50, Flag = "JumpPower", Callback = function(Value) Jump:SetJumpPower(Value) end })
    end

    -- Auto-Farm Tab
    local AutoFarmTab = Window:CreateTab("Auto-Farm", 4483362458)
    if AutoFarm then
        AutoFarmTab:CreateSection("Universal Farm")
        AutoFarmTab:CreateToggle({
           Name = "Auto Clicker",
           CurrentValue = false,
           Flag = "AutoClicker",
           Callback = function(Value) AutoFarm:ToggleAutoClick(Value) end,
        })
        AutoFarmTab:CreateToggle({
           Name = "Auto Collect Nearby Items",
           CurrentValue = false,
           Flag = "AutoCollect",
           Callback = function(Value) AutoFarm:ToggleAutoCollect(Value) end,
        })
        AutoFarmTab:CreateSlider({
           Name = "Collection Range",
           Range = {10, 500},
           Increment = 10,
           Suffix = "Studs",
           CurrentValue = 50,
           Flag = "FarmRange",
           Callback = function(Value) AutoFarm:SetRange(Value) end,
        })
        AutoFarmTab:CreateInput({
           Name = "Target Item Name",
           PlaceholderText = "Empty = All Items",
           RemoveTextAfterFocusLost = false,
           Callback = function(Text) AutoFarm:SetTarget(Text) end,
        })
    end

    -- Teleport Tab
    local TeleportTab = Window:CreateTab("Teleport", 4483345998)
    if Teleport then
        TeleportTab:CreateSection("Player Teleport")
        local PlayerDropdown = TeleportTab:CreateDropdown({
           Name = "Select Player",
           Options = Teleport:GetPlayerNames(),
           CurrentOption = "",
           Flag = "TeleportDropdown",
           Callback = function(Option) Teleport:ToPlayer(Option[1]) end,
        })
        TeleportTab:CreateButton({ Name = "Refresh Player List", Callback = function() PlayerDropdown:Set(Teleport:GetPlayerNames()) end })
        
        TeleportTab:CreateSection("Waypoint System")
        
        local waypointName = ""
        TeleportTab:CreateInput({
            Name = "Waypoint Name",
            PlaceholderText = "e.g. Home, Shop...",
            RemoveTextAfterFocusLost = false,
            Callback = function(Text) waypointName = Text end
        })
        
        local WaypointDropdown
        
        TeleportTab:CreateButton({
            Name = "Save Current Position",
            Callback = function()
                local success, actualName = Teleport:SavePosition(waypointName ~= "" and waypointName or nil)
                if success then
                    _G.ULTIMATE_NOTIFY("Saved position as: " .. actualName)
                    if WaypointDropdown then WaypointDropdown:Set(Teleport:GetWaypointNames()) end
                end
            end
        })
        
        WaypointDropdown = TeleportTab:CreateDropdown({
            Name = "Saved Waypoints",
            Options = Teleport:GetWaypointNames(),
            CurrentOption = "",
            Flag = "WaypointDropdown",
            Callback = function(Option) 
                if Option[1] then Teleport:ToWaypoint(Option[1]) end
            end
        })
        
        local newRename = ""
        TeleportTab:CreateInput({
            Name = "Rename To...",
            PlaceholderText = "Enter new name...",
            RemoveTextAfterFocusLost = false,
            Callback = function(Text) newRename = Text end
        })
        
        TeleportTab:CreateButton({
            Name = "Apply Rename",
            Callback = function()
                local current = WaypointDropdown.CurrentOption[1]
                if current and newRename ~= "" then
                    if Teleport:RenameWaypoint(current, newRename) then
                        _G.ULTIMATE_NOTIFY("Renamed " .. current .. " to " .. newRename)
                        WaypointDropdown:Set(Teleport:GetWaypointNames())
                    end
                end
            end
        })
        
        TeleportTab:CreateButton({
            Name = "Delete Selected Waypoint",
            Callback = function()
                local current = WaypointDropdown.CurrentOption[1]
                if current then
                    Teleport:DeleteWaypoint(current)
                    _G.ULTIMATE_NOTIFY("Deleted waypoint: " .. current)
                    WaypointDropdown:Set(Teleport:GetWaypointNames())
                end
            end
        })
    end

    -- Misc Tab
    local MiscTab = Window:CreateTab("Misc", 4483362458)
    MiscTab:CreateSection("Character")
    if Invisibility then
        MiscTab:CreateToggle({
           Name = "FE Invisibility (Undetected)",
           CurrentValue = false,
           Flag = "InvisibilityToggle",
           Callback = function(Value)
              Invisibility:Toggle(Value)
              if not Value then _G.ULTIMATE_NOTIFY("Note: You may need to Reset to become visible to others again.") end
           end,
        })
    end
    if Stamina then
        MiscTab:CreateToggle({
           Name = "Infinite Stamina/Energy",
           CurrentValue = false,
           Flag = "InfStamina",
           Callback = function(Value) Stamina:Toggle(Value) end,
        })
    end

    MiscTab:CreateSection("Server")
    MiscTab:CreateButton({
       Name = "Rejoin Game",
       Callback = function()
          local ts = game:GetService("TeleportService")
          local p = game:GetService("Players").LocalPlayer
          ts:Teleport(game.PlaceId, p)
       end,
    })

    print("ULTIMATE Hub | Finished Loading")
    _G.ULTIMATE_NOTIFY("Welcome to ULTIMATE HUB V3 | rafsunboss.")
end
