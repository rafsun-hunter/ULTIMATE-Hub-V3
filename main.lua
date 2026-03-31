local repo = "https://raw.githubusercontent.com/rafsun-hunter/ULTIMATE-Hub-V3/main/"

-- Load official Rayfield Library from Sirius
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local function loadModule(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(repo .. path))()
    end)
    if success then return result end
    warn("ULTIMATE Hub | Failed to load module: " .. path)
    return nil
end

-- Load Modular Cheats
local Fly = loadModule("cheat/fly.lua")
local Aimbot = loadModule("cheat/aimbot.lua")
local ESP = loadModule("cheat/esp.lua")
local Teleport = loadModule("cheat/teleport.lua")
local Magic = loadModule("cheat/magic.lua")

local Window = Rayfield:CreateWindow({
   Name = "ULTIMATE HUB V3",
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "UltimateHubV3",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "sirius",
      RememberJoins = true
   },
   KeySystem = false
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", 4483362458) -- Crosshair Icon
if Aimbot then
    CombatTab:CreateSection("Aimbot")
    CombatTab:CreateToggle({
       Name = "Enable Aimbot",
       CurrentValue = false,
       Flag = "AimbotToggle",
       Callback = function(Value) Aimbot:Toggle(Value) end,
    })
    CombatTab:CreateToggle({
       Name = "Auto-Lock (Mobile Friendly)",
       CurrentValue = false,
       Flag = "AimbotAutoLock",
       Callback = function(Value) Aimbot:SetAutoLock(Value) end,
    })
    CombatTab:CreateSlider({
       Name = "Aimbot FOV",
       Range = {10, 500},
       Increment = 1,
       Suffix = "Radius",
       CurrentValue = 100,
       Flag = "AimbotFOV",
       Callback = function(Value) Aimbot:SetFOV(Value) end,
    })
end

if Magic then
    CombatTab:CreateSection("Magic (Hitbox)")
    CombatTab:CreateToggle({
       Name = "Enable Magic Hitbox",
       CurrentValue = false,
       Flag = "MagicToggle",
       Callback = function(Value) Magic:Toggle(Value) end,
    })
    CombatTab:CreateSlider({
       Name = "Hitbox Size",
       Range = {2, 50},
       Increment = 1,
       Suffix = "Studs",
       CurrentValue = 5,
       Flag = "HitboxSize",
       Callback = function(Value) Magic:SetSize(Value) end,
    })
end

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals", 4483345998) -- Eye Icon
if ESP then
    VisualsTab:CreateSection("ESP Settings")
    VisualsTab:CreateToggle({
       Name = "Enable ESP",
       CurrentValue = false,
       Flag = "ESPToggle",
       Callback = function(Value) ESP:Toggle(Value) end,
    })
    VisualsTab:CreateToggle({
       Name = "ESP Boxes",
       CurrentValue = false,
       Flag = "ESPBoxes",
       Callback = function(Value) ESP:SetBoxes(Value) end,
    })
    VisualsTab:CreateToggle({
       Name = "ESP Names",
       CurrentValue = false,
       Flag = "ESPNames",
       Callback = function(Value) ESP:SetNames(Value) end,
    })
    VisualsTab:CreateToggle({
       Name = "ESP Tracers",
       CurrentValue = false,
       Flag = "ESPTracers",
       Callback = function(Value) ESP:SetTracers(Value) end,
    })
end

-- Movement Tab
local MovementTab = Window:CreateTab("Movement", 4483362135) -- Move Icon
if Fly then
    MovementTab:CreateSection("Flight")
    MovementTab:CreateToggle({
       Name = "Enable Fly",
       CurrentValue = false,
       Flag = "FlyToggle",
       Callback = function(Value) Fly:Toggle(Value) end,
    })
    MovementTab:CreateSlider({
       Name = "Fly Speed",
       Range = {1, 10},
       Increment = 0.5,
       Suffix = "x",
       CurrentValue = 1,
       Flag = "FlySpeed",
       Callback = function(Value) Fly:SetSpeed(Value) end,
    })
end

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 4483345998) -- Pin Icon
if Teleport then
    TeleportTab:CreateSection("Player Teleport")
    local PlayerDropdown = TeleportTab:CreateDropdown({
       Name = "Select Player",
       Options = Teleport:GetPlayerNames(),
       CurrentOption = "",
       Flag = "TeleportDropdown",
       Callback = function(Option)
          Teleport:ToPlayer(Option[1])
       end,
    })

    TeleportTab:CreateButton({
       Name = "Refresh Player List",
       Callback = function()
          PlayerDropdown:Set(Teleport:GetPlayerNames())
       end,
    })
end

Rayfield:Notify({
   Title = "ULTIMATE HUB V3",
   Content = "Successfully loaded with Sirius Rayfield UI!",
   Duration = 5,
   Image = 4483362458,
})
