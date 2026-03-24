local ULTIMATE = loadstring(game:HttpGet("https://raw.githubusercontent.com/rasfun/ULTIMATE-Library/main/source.lua"))()

local Window = ULTIMATE:CreateWindow({
   Name = "ULTIMATE Hub",
   LoadingTitle = "ULTIMATE Library",
   LoadingSubtitle = "by Sirius & Gemini",
   Logo = "rbxassetid://6031280306", -- Change this to your image ID
   KeySystem = false,
   KeySettings = {
      Title = "Key System",
      Note = "Join Discord for Key",
      Key = "Hello"
   }
})

local Tab = Window:CreateTab("Combat", "crosshair") -- Lucide icon support!

local Section = Tab:CreateSection("Aimbot Settings")

local Toggle = Tab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
      print("Aimbot:", Value)
   end,
})

local Slider = Tab:CreateSlider({
   Name = "Smoothness",
   Range = {1, 100},
   Increment = 1,
   Suffix = "ms",
   CurrentValue = 20,
   Flag = "AimbotSmooth",
   Callback = function(Value)
      print("Smoothness:", Value)
   end,
})

local Button = Tab:CreateButton({
   Name = "Destroy UI",
   Callback = function()
      ULTIMATE:Destroy()
   end,
})

local Tab2 = Window:CreateTab("Sense ESP", "eye")
Tab2:CreateSection("ESP Control")
Tab2:CreateButton({
   Name = "Load Sense ESP",
   Callback = function()
      loadstring(game:HttpGet('https://sirius.menu/sense'))()
      print("Sense Loaded!")
   end,
})
