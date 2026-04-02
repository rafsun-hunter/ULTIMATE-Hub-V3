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

-- Global Notification Helper for Login Module
_G.ULTIMATE_NOTIFY = function(msg)
    Rayfield:Notify({
        Title = "ULTIMATE HUB V3",
        Content = msg,
        Duration = 5,
        Image = "rbxassetid://4483362458",
    })
end

local function loadModule(path)
    local success, source = pcall(game.HttpGet, game, repo .. path)
    if not success then return nil end
    local func, err = loadstring(source)
    if func then
        local success, result = pcall(func)
        if success then return result end
    end
    return nil
end

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "ULTIMATE HUB V3 | rafsunboss",
   LoadingTitle = "ULTIMATE Hub V3",
   LoadingSubtitle = "by rafsun-hunter",
   ConfigurationSaving = { Enabled = true, FolderName = "UltimateHubV3", FileName = "Config" },
   KeySystem = false
})

-- Login Module
local Login = loadModule("cheat/login.lua")

-- Hub Initialization Function (Called after Login)
local function InitializeHub()
    print("ULTIMATE Hub | Access Granted. Loading modules...")
    
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

    -- Combat Tab
    local CombatTab = Window:CreateTab("Combat", 4483362458)
    if Aimbot then
        CombatTab:CreateSection("Aimbot")
        CombatTab:CreateToggle({ Name = "Enable Aimbot", CurrentValue = false, Flag = "AimbotToggle", Callback = function(Value) Aimbot:Toggle(Value) end })
        CombatTab:CreateToggle({ Name = "Auto-Lock (Mobile Friendly)", CurrentValue = false, Flag = "AimbotAutoLock", Callback = function(Value) Aimbot:SetAutoLock(Value) end })
        CombatTab:CreateSlider({ Name = "Aimbot FOV", Range = {10, 500}, Increment = 1, Suffix = "Radius", CurrentValue = 100, Flag = "AimbotFOV", Callback = function(Value) Aimbot:SetFOV(Value) end })
    end
    if Magic then
        CombatTab:CreateSection("Magic (Hitbox)")
        CombatTab:CreateToggle({ Name = "Enable Magic Hitbox", CurrentValue = false, Flag = "MagicToggle", Callback = function(Value) Magic:Toggle(Value) end })
        CombatTab:CreateSlider({ Name = "Hitbox Size", Range = {2, 50}, Increment = 1, Suffix = "Studs", CurrentValue = 5, Flag = "HitboxSize", Callback = function(Value) Magic:SetSize(Value) end })
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
    end

    -- Misc Tab
    local MiscTab = Window:CreateTab("Misc", 4483362458)
    if Invisibility then
        MiscTab:CreateSection("Character")
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
    MiscTab:CreateSection("Server")
    MiscTab:CreateButton({
       Name = "Rejoin Game",
       Callback = function()
          local ts = game:GetService("TeleportService")
          local p = game:GetService("Players").LocalPlayer
          ts:Teleport(game.PlaceId, p)
       end,
    })

    print("ULTIMATE Hub | Finished Loading Features")
end

-- Login Tab (Only tab visible initially)
local LoginTab = Window:CreateTab("Login", 4483362458)
LoginTab:CreateSection("Key System")
local KeyInput = ""
LoginTab:CreateInput({
   Name = "Enter Key",
   PlaceholderText = "Paste key here...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) KeyInput = Text end,
})

local isLoggedIn = false
LoginTab:CreateButton({
   Name = "Login / Verify",
   Callback = function()
      if isLoggedIn then 
         _G.ULTIMATE_NOTIFY("Already logged in!")
         return 
      end
      if Login then
         local success = Login:Verify(KeyInput)
         if success then
            isLoggedIn = true
            _G.ULTIMATE_NOTIFY("Access Granted! Welcome, rafsunboss.")
            InitializeHub()
         end
      end
   end,
})

LoginTab:CreateButton({
   Name = "Get Key (Copy Link)",
   Callback = function()
      if Login then
         local success, link = Login:GetLink()
         if success then
            setclipboard(link)
            _G.ULTIMATE_NOTIFY("Key link copied to clipboard!")
         end
      end
   end,
})

print("ULTIMATE Hub | Ready for Login")
_G.ULTIMATE_NOTIFY("Welcome to ULTIMATE HUB V3 | rafsunboss. Please login to access features.")
