# 🚀 ULTIMATE Hub V3

**ULTIMATE Hub V3** is a high-performance, modern, and modular Roblox UI library built for speed, aesthetics, and reliability. 

This version introduces a modular structure, separating cheat logic (Fly, Aimbot, ESP, Teleport, Magic) from the main interface for better maintainability and performance.

---

## ✨ Features

- **Combat:** Smooth Aimbot with FOV circle and Team Check, Magic Hitbox Expander.
- **Visuals:** Advanced ESP with Boxes, Names, Tracers, and Team Check.
- **Movement:** Fly script with adjustable speed and directional control.
- **Teleport:** Player teleportation with a refreshing player list.
- **UI:** Powered by a customized Rayfield Interface Suite.

---

## 🛠️ How to Use

To load the ULTIMATE Hub V3, use the following `loadstring` in your executor:

```lua
-- Ensure you have the file structure or use a web-based loader
loadstring(game:HttpGet("https://raw.githubusercontent.com/rafsun-hunter/ULTIMATE-Hub-V3/main/main.lua"))()
```

*Note: This script requires the `cheat/` folder modules to be present or correctly linked.*

---

## 📂 Project Structure

- `main.lua`: The entry point and UI configuration.
- `source.lua`: The customized Rayfield Library source.
- `cheat/`:
    - `aimbot.lua`: Aimbot logic.
    - `esp.lua`: ESP logic.
    - `fly.lua`: Flight logic (FlyGuiV3 adapted).
    - `teleport.lua`: Teleportation functions.
    - `magic.lua`: Hitbox expansion magic.

---

## 🙌 Credits

- **Sirius/Rayfield:** Foundational UI concepts.
- **rafsun-hunter:** Creator and Developer.
- **Gemini CLI:** AI Co-developer and Modular Architecture.
- **Exunys:** Aimbot logic.
- **Siper & Mickey:** ESP base.
- **XNEO:** Fly logic inspiration.

---

## 📜 License
This project is for educational and personal use. Please respect the original creators' work.
