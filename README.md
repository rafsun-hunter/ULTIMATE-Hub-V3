# 🚀 ULTIMATE UI Library

**ULTIMATE** is a high-performance, modern Roblox UI library built for speed, aesthetics, and reliability. It combines the best features of Rayfield and Sirius into a single, optimized package.

---

## ✨ Showcase & Demo

To instantly **test the look and feel** of the ULTIMATE Library, run this script in your executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/rasfun/ULTIMATE-Library/main/demo.lua"))()
```

---

## 🛠️ Quick Start

To load the library, use the following `loadstring`:

```lua
local ULTIMATE = loadstring(game:HttpGet("https://raw.githubusercontent.com/rasfun/ULTIMATE-Library/main/source.lua"))()
```

---

## 📝 Usage Example

```lua
local ULTIMATE = loadstring(game:HttpGet("https://raw.githubusercontent.com/rasfun/ULTIMATE-Library/main/source.lua"))()

local Window = ULTIMATE:CreateWindow({
   Name = "ULTIMATE Hub",
   LoadingTitle = "ULTIMATE Library",
   LoadingSubtitle = "by Sirius & Gemini",
   KeySystem = true, -- Set to true to use the key system
   KeySettings = {
      Title = "Key System",
      Note = "https://discord.gg/yourinvite", -- Link to get your key
      Key = {"Hello", "SecretKey123"} -- Valid keys
   }
})

local Tab = Window:CreateTab("General")

Tab:CreateButton("Print Hello", function()
   print("Hello from ULTIMATE!")
end)
```

---

## 📚 Documentation

### `ULTIMATE:CreateWindow(config)`
Initializes the UI.
- `Name`: (string) The title of your script.
- `LoadingTitle`: (string) The main text shown on the splash screen.
- `LoadingSubtitle`: (string) The smaller text shown on the splash screen.
- `KeySystem`: (boolean) Whether to enable the key prompt.
- `KeySettings`: (table)
    - `Title`: (string) Key system title.
    - `Note`: (string) Instructions or link to get a key.
    - `Key`: (table or string) Valid keys for access.

### `Window:CreateTab(name)`
Creates a new tab in the sidebar.
- `name`: (string) The label for the tab.

### `Tab:CreateButton(name, callback)`
Adds a button to the tab.
- `name`: (string) The text on the button.
- `callback`: (function) The code to run when the button is clicked.

---

## 🙌 Credits

- **Sirius/Rayfield:** Inspiration and foundational UI concepts.
- **rasfun:** Creator and Developer.
- **Gemini:** Co-developer and Optimization.

---

## 📜 License
This project is for educational and personal use. Please respect the original creators' work.
