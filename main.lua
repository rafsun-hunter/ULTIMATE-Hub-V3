local repo = "https://raw.githubusercontent.com/rafsun-hunter/ULTIMATE-Hub-V3/main/"

local function loadModule(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(repo .. path))()
    end)
    if success then return result end
    warn("ULTIMATE Hub | Failed to load module: " .. path)
    return nil
end

-- Initialize UI Library
local ULTIMATE = loadstring(game:HttpGet(repo .. "source.lua"))()

-- Load Modular Cheats
local Fly = loadModule("cheat/fly.lua")
local Aimbot = loadModule("cheat/aimbot.lua")
local ESP = loadModule("cheat/esp.lua")
local Teleport = loadModule("cheat/teleport.lua")
local Magic = loadModule("cheat/magic.lua")

local Window = ULTIMATE:CreateWindow({
   Name = "ULTIMATE HUB V3",
   LoadingTitle = "ULTIMATE Library",
   LoadingSubtitle = "by Sirius & Gemini",
   Logo = "rbxassetid://6031280306",
   KeySystem = false
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", "crosshair")
if Aimbot then
    CombatTab:CreateSection("Aimbot")
    CombatTab:CreateToggle({
       Name = "Enable Aimbot",
       CurrentValue = false,
       Callback = function(Value) Aimbot:Toggle(Value) end,
    })
    CombatTab:CreateSlider({
       Name = "Aimbot FOV",
       Range = {10, 500},
       Increment = 1,
       CurrentValue = 100,
       Callback = function(Value) Aimbot:SetFOV(Value) end,
    })
    CombatTab:CreateToggle({
       Name = "Aimbot Team Check",
       CurrentValue = false,
       Callback = function(Value) Aimbot:SetTeamCheck(Value) end,
    })
end

if Magic then
    CombatTab:CreateSection("Magic (Hitbox)")
    CombatTab:CreateToggle({
       Name = "Enable Magic Hitbox",
       CurrentValue = false,
       Callback = function(Value) Magic:Toggle(Value) end,
    })
    CombatTab:CreateSlider({
       Name = "Hitbox Size",
       Range = {2, 50},
       Increment = 1,
       CurrentValue = 5,
       Callback = function(Value) Magic:SetSize(Value) end,
    })
end

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals", "eye")
if ESP then
    VisualsTab:CreateSection("ESP Settings")
    VisualsTab:CreateToggle({
       Name = "Enable ESP",
       CurrentValue = false,
       Callback = function(Value) ESP:Toggle(Value) end,
    })
    VisualsTab:CreateToggle({
       Name = "ESP Boxes",
       CurrentValue = false,
       Callback = function(Value) ESP:SetBoxes(Value) end,
    })
    VisualsTab:CreateToggle({
       Name = "ESP Names",
       CurrentValue = false,
       Callback = function(Value) ESP:SetNames(Value) end,
    })
    VisualsTab:CreateToggle({
       Name = "ESP Tracers",
       CurrentValue = false,
       Callback = function(Value) ESP:SetTracers(Value) end,
    })
    VisualsTab:CreateToggle({
       Name = "ESP Team Check",
       CurrentValue = false,
       Callback = function(Value) ESP:SetTeamCheck(Value) end,
    })
end

-- Movement Tab
local MovementTab = Window:CreateTab("Movement", "move")
if Fly then
    MovementTab:CreateSection("Flight")
    MovementTab:CreateToggle({
       Name = "Enable Fly",
       CurrentValue = false,
       Callback = function(Value) Fly:Toggle(Value) end,
    })
    MovementTab:CreateSlider({
       Name = "Fly Speed",
       Range = {1, 10},
       Increment = 0.5,
       CurrentValue = 1,
       Callback = function(Value) Fly:SetSpeed(Value) end,
    })
end

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", "map-pin")
if Teleport then
    TeleportTab:CreateSection("Player Teleport")
    local PlayerDropdown = TeleportTab:CreateDropdown({
       Name = "Select Player",
       Options = Teleport:GetPlayerNames(),
       CurrentOption = "",
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

-- Credits
local CreditsTab = Window:CreateTab("Credits", "info")
CreditsTab:CreateSection("Authors")
CreditsTab:CreateLabel("Script by Gemini CLI")
CreditsTab:CreateLabel("UI by Sirius (Rayfield)")
CreditsTab:CreateLabel("Fly Logic: FlyGuiV3")
CreditsTab:CreateLabel("Aimbot: Exunys")
CreditsTab:CreateLabel("ESP: Siper & Mickey")

ULTIMATE:Notify({
   Title = "Script Loaded",
   Content = "ULTIMATE HUB V3 is now live via GitHub!",
   Duration = 5,
   Image = "check-circle",
})
