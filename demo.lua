local ULTIMATE = loadstring(game:HttpGet("https://raw.githubusercontent.com/rasfun/ULTIMATE-Library/main/source.lua"))()

local Window = ULTIMATE:CreateWindow({
   Name = "ULTIMATE | Showcase",
   LoadingTitle = "ULTIMATE UI Library",
   LoadingSubtitle = "Performance & Aesthetics",
   KeySystem = false
})

-- Tab 1: Elements
local Tab1 = Window:CreateTab("Elements")

Tab1:CreateSection("Buttons & Toggles")

Tab1:CreateButton("Normal Button", function()
   print("Button clicked!")
end)

Tab1:CreateToggle("Functional Toggle", true, function(state)
   print("Toggle state:", state)
end)

Tab1:CreateSection("Sliders")

Tab1:CreateSlider("Numeric Slider", 0, 500, 250, function(value)
   print("Slider value:", value)
end)

Tab1:CreateSlider("Precision Slider", 1, 10, 5, function(value)
   print("Precision value:", value)
end)


-- Tab 2: Theme Testing
local Tab2 = Window:CreateTab("Themes")

Tab2:CreateSection("Visual Customization")

Tab2:CreateButton("Switch to Dark (Default)", function()
   print("Theme logic can be added here")
end)

Tab2:CreateButton("Switch to Light", function()
   print("Theme logic can be added here")
end)

Tab2:CreateSection("Layout Test")
for i = 1, 5 do
   Tab2:CreateButton("List Item " .. i, function() end)
end


-- Tab 3: Misc
local Tab3 = Window:CreateTab("Settings")
Tab3:CreateSection("Library Info")
Tab3:CreateButton("Destroy UI", function()
   -- Add destroy logic to source.lua if needed
   print("Destroying...")
end)
