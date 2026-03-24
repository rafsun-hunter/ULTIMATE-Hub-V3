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

local Tab = Window:CreateTab("Main")

Tab:CreateButton("Test Button", function()
   print("ULTIMATE works!")
end)
