# 🎯 Roblox Aimbot GUI with Aimlock + Smooth Aiming + FOV

A feature-rich Aimbot script for Roblox that includes:

- Toggleable Aimlock system  
- Smooth mouse-based aiming  
- FOV circle centered on the screen  
- Aim part selector (Head / Torso)  
- Adjustable smoothness and FOV radius via UI  
- Supports prediction and team check toggle  
- Visibility toggle for FOV circle  

> Developed for **Mouse Right-Click Locking** and smooth real-time aiming for PvP gameplay.

---

## 🔧 Features

| Feature        | Description                                                   |
|----------------|---------------------------------------------------------------|
| 🎯 Aimlock     | Locks aim to the nearest visible player in FOV circle         |
| 🟢 Smooth Aim  | Adjust how smooth/fast the camera moves toward target         |
| 🟢 FOV Circle  | Visual circle centered on screen that controls aim range      |
| 🔘 GUI         | Toggle Aimlock, choose Aim Part (Head/Torso), adjust sliders  |
| 🎮 Input       | Uses **Mouse Right-Click** to lock and aim                    |

---

## 🧠 How It Works

- **Right-click** (`MouseButton2`) to lock onto the closest player inside the circular FOV.
- FOV is centered at screen center (crosshair position).
- Targeting auto-predicts the player movement using `HumanoidRootPart.Velocity`.
- The camera uses `CFrame:Lerp()` for smooth movement.
- Sliders allow in-game tuning of:
  - **Smoothness**
  - **FOV Radius**
- The script skips teammates if `TeamCheck` is enabled.

---

## 🖥️ UI Components

- **Aimlock Toggle**: Enable or disable Aimlock feature.
- **Aim Part Toggle**: Switch between `"Head"` and `"HumanoidRootPart"` (Torso).
- **Smoothness Slider**: Control how fast the camera adjusts toward the target.
- **FOV Radius Slider**: Increase or decrease the lock-on range.

---

## ⚙️ Installation / Usage

1. Paste the script into your **LocalScript** in **StarterPlayerScripts**.
2. Run your Roblox game.
3. A GUI panel will appear on the left side of the screen.
4. Press **Right Mouse Button** to activate Aimlock when enabled.
5. Adjust settings on the fly.

---

## 🛡️ Important Notes

- This is a **client-side** script and only affects your camera.
- Aimbot does not fire or damage players, it only aims for you.
- This script is for educational, sandbox, or testing environments.

---

## 🔧 Configurable Settings

```lua
_G.TeamCheck = false          -- true = don’t aim at teammates
_G.AimPart = "Head"           -- "Head" or "HumanoidRootPart"
_G.Smoothness = 0.05          -- Lower = faster aim
_G.CircleRadius = 180         -- FOV range
_G.CircleColor = Color3.fromRGB(50, 255, 50) -- FOV circle color
```

---

## 💬 Support

If you want to add features like:
- Auto-fire when aiming
- Lock-on button remap
- Different FOV styles  
Let me know and I can help update the script!

---
