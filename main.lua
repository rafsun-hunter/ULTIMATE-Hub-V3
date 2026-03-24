local ULTIMATE = loadstring(game:HttpGet("https://raw.githubusercontent.com/rasfun/ULTIMATE-Library/main/source.lua"))()

local Window = ULTIMATE:CreateWindow({
   Name = "ULTIMATE Hub",
   LoadingTitle = "ULTIMATE Library",
   LoadingSubtitle = "by Sirius & Gemini",
   KeySystem = false,
   KeySettings = {
      Title = "Key System",
      Note = "Join Discord for Key",
      Key = "Hello"
   }
})

local Tab = Window:CreateTab("Combat")

Tab:CreateSection("Aimbot Settings")

Tab:CreateToggle("Enable Aimbot", false, function(state)
   print("Aimbot:", state)
end)

Tab:CreateSlider("Aimbot Smoothness", 1, 100, 20, function(value)
   print("Smoothness:", value)
end)

Tab:CreateButton("Reset Settings", function()
   print("Settings Reset")
end)

local Tab2 = Window:CreateTab("Visuals")
Tab2:CreateSection("ESP Options")
Tab2:CreateToggle("Show Boxes", true, function(state)
   print("Boxes:", state)
end)
Tab2:CreateToggle("Show Names", false, function(state)
   print("Names:", state)
end)
