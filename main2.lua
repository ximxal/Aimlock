local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Aimbot state
local Aiming = false
local Locking = false
local AimlockEnabled = false
local TargetPlayer = nil

-- Config
local AimPrediction = 0.15
local AimOffset = Vector3.new(0, 0.1, 0)
_G.TeamCheck = false
_G.AimPart = "Head"
_G.CircleSides = 64
_G.CircleColor = Color3.fromRGB(50, 255, 50)
_G.CircleTransparency = 0.4
_G.CircleRadius = 180
_G.CircleFilled = false
_G.CircleVisible = true
_G.CircleThickness = 2
_G.Smoothness = 0.08

-- Drawing circle
local AimCircle = Drawing.new("Circle")
AimCircle.Radius = _G.CircleRadius
AimCircle.Filled = _G.CircleFilled
AimCircle.Color = _G.CircleColor
AimCircle.Visible = _G.CircleVisible
AimCircle.Transparency = _G.CircleTransparency
AimCircle.NumSides = _G.CircleSides
AimCircle.Thickness = _G.CircleThickness

-- GUI Setup
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "AimlockUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, 210)
frame.Position = UDim2.new(0, 20, 0, 300)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 24)
title.Text = "🎯 Aimlock Settings"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(50, 255, 50)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Toggle Aimlock Button
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0, 250, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 30)
toggleBtn.Text = "Aimlock: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
toggleBtn.Font = Enum.Font.Gotham
toggleBtn.TextSize = 14
toggleBtn.MouseButton1Click:Connect(function()
    AimlockEnabled = not AimlockEnabled
    toggleBtn.Text = "Aimlock: " .. (AimlockEnabled and "ON" or "OFF")
end)

-- Aim Part Toggle
local partBtn = Instance.new("TextButton", frame)
partBtn.Size = UDim2.new(0, 250, 0, 30)
partBtn.Position = UDim2.new(0, 10, 0, 70)
partBtn.Text = "Aim Part: Head"
partBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
partBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
partBtn.Font = Enum.Font.Gotham
partBtn.TextSize = 14
partBtn.MouseButton1Click:Connect(function()
    if _G.AimPart == "Head" then
        _G.AimPart = "HumanoidRootPart"
        partBtn.Text = "Aim Part: Torso"
    else
        _G.AimPart = "Head"
        partBtn.Text = "Aim Part: Head"
    end
end)

-- Slider function
local function createSlider(labelText, yPos, min, max, default, callback)
    local label = Instance.new("TextLabel", frame)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.Size = UDim2.new(0, 250, 0, 20)
    label.Text = labelText .. ": " .. default
    label.TextColor3 = Color3.fromRGB(50, 255, 50)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.BackgroundTransparency = 1

    local bg = Instance.new("Frame", frame)
    bg.Size = UDim2.new(0, 250, 0, 10)
    bg.Position = UDim2.new(0, 10, 0, yPos + 20)
    bg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local fill = Instance.new("Frame", bg)
    fill.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

    local handle = Instance.new("TextButton", fill)
    handle.Size = UDim2.new(0, 10, 1.5, 0)
    handle.Position = UDim2.new(1, -5, -0.25, 0)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.BorderSizePixel = 0
    handle.Text = ""

    local dragging = false
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local x = math.clamp(input.Position.X - bg.AbsolutePosition.X, 0, bg.AbsoluteSize.X)
            local percent = x / bg.AbsoluteSize.X
            fill.Size = UDim2.new(percent, 0, 1, 0)
            handle.Position = UDim2.new(1, -5, -0.25, 0)
            local value = tonumber(string.format("%.2f", min + (max - min) * percent))
            label.Text = labelText .. ": " .. value
            callback(value)
        end
    end)
end

-- Create sliders
createSlider("Smoothness", 110, 0.01, 1, _G.Smoothness, function(v)
    _G.Smoothness = v
end)

createSlider("FOV Radius", 160, 50, 500, _G.CircleRadius, function(v)
    _G.CircleRadius = v
    AimCircle.Radius = _G.CircleRadius
end)

-- Lock/unlock mouse
local function LockMouse()
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
end

local function UnlockMouse()
    Aiming = false
    Locking = false
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

-- Find nearest player in FOV
local function FindNearestPlayer()
    local closestPlayer = nil
    local shortestDistance = _G.CircleRadius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local humanoid = char:FindFirstChild("Humanoid")
            local part = char:FindFirstChild(_G.AimPart)

            if humanoid and humanoid.Health > 0 and part then
                if not _G.TeamCheck or player.Team ~= LocalPlayer.Team then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local mouseVec = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        local dist = (mouseVec - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- Aimbot update loop
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()

    -- Update AimCircle to follow the mouse position
    AimCircle.Position = Vector2.new(mousePos.X, mousePos.Y)

    if AimlockEnabled and Aiming and Locking then
        TargetPlayer = FindNearestPlayer()
        if TargetPlayer and TargetPlayer.Character then
            local targetPart = TargetPlayer.Character:FindFirstChild(_G.AimPart) -- ใช้ AimPart ที่เลือก เช่น Head หรือ HumanoidRootPart
            if targetPart then
                -- คำนวณตำแหน่งล่วงหน้าของตัวละคร (considering speed)
                local predictedPos = targetPart.Position + (targetPart.Velocity * AimPrediction) + AimOffset
                local current = Camera.CFrame
                local target = CFrame.lookAt(current.Position, predictedPos)

                -- คำนวณมุมระหว่างมุมมองกล้องและทิศทางที่ต้องการ
                local angleDiff = (current.LookVector:Dot((predictedPos - current.Position).Unit))
                local speedFactor = math.clamp((1 - angleDiff) * 2, _G.Smoothness, 1)

                -- Update Camera CFrame
                Camera.CFrame = current:Lerp(target, speedFactor)
                LockMouse()
            end
        end
    end
end)

-- Input handlers
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Aiming = true
        Locking = true
        LockMouse()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        UnlockMouse()
    end
end)
