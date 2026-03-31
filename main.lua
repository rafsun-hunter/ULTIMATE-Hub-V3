local ULTIMATE = loadstring(readfile("/storage/emulated/0/script /ROBLOX/develop /ULTIMATE/source.lua"))()

-- Load Modules
local Fly = loadstring(readfile("/storage/emulated/0/script /ROBLOX/develop /ULTIMATE/cheat/fly.lua"))()
local Aimbot = loadstring(readfile("/storage/emulated/0/script /ROBLOX/develop /ULTIMATE/cheat/aimbot.lua"))()
local ESP = loadstring(readfile("/storage/emulated/0/script /ROBLOX/develop /ULTIMATE/cheat/esp.lua"))()
local Teleport = loadstring(readfile("/storage/emulated/0/script /ROBLOX/develop /ULTIMATE/cheat/teleport.lua"))()
local Magic = loadstring(readfile("/storage/emulated/0/script /ROBLOX/develop /ULTIMATE/cheat/magic.lua"))()

local Window = ULTIMATE:CreateWindow({
   Name = "ULTIMATE HUB V3",
   LoadingTitle = "ULTIMATE Library",
   LoadingSubtitle = "by Sirius & Gemini",
   Logo = "rbxassetid://6031280306",
   KeySystem = false
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", "crosshair")
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

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals", "eye")
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

-- Movement Tab
local MovementTab = Window:CreateTab("Movement", "move")
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

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", "map-pin")
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
   Content = "ULTIMATE HUB V3 is now active!",
   Duration = 5,
   Image = "check-circle",
})
