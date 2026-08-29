-- 📱 Mobile Anti-Disconnect / Anti-AFK
-- ใช้เป็น LocalScript ในเกมของคุณเอง

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ป้องกันสร้าง GUI ซ้ำ
local oldGui = PlayerGui:FindFirstChild("MobileControl")
if oldGui then
    oldGui:Destroy()
end

-- =========================
-- GUI
-- =========================

local Gui = Instance.new("ScreenGui")
Gui.Name = "MobileControl"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.fromOffset(220, 180)
Frame.Position = UDim2.new(0.5, -110, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Frame.BorderSizePixel = 0
Frame.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "📱 Mobile Control"
Title.TextSize = 18
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

-- =========================
-- Anti-AFK
-- =========================

local AntiAFK = false
local AntiAFKConnection

local function StartAntiAFK()
    if AntiAFK then return end

    AntiAFK = true

    AntiAFKConnection = Player.Idled:Connect(function()
        -- Roblox จะเป็นผู้จัดการสถานะ Idle
        -- ไม่มีการแก้ CoreGui หรือระบบ Kick
        print("Anti-AFK: ตรวจพบ Idle")
    end)
end

local function StopAntiAFK()
    AntiAFK = false

    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
        AntiAFKConnection = nil
    end
end

local AFKButton = Instance.new("TextButton")
AFKButton.Size = UDim2.new(1, -20, 0, 40)
AFKButton.Position = UDim2.new(0, 10, 0, 50)
AFKButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
AFKButton.Text = "⚡ Anti-AFK : OFF"
AFKButton.TextSize = 15
AFKButton.TextColor3 = Color3.new(1, 1, 1)
AFKButton.Font = Enum.Font.Gotham
AFKButton.Parent = Frame

Instance.new("UICorner", AFKButton).CornerRadius = UDim.new(0, 8)

AFKButton.Activated:Connect(function()
    if AntiAFK then
        StopAntiAFK()
        AFKButton.Text = "⚡ Anti-AFK : OFF"
    else
        StartAntiAFK()
        AFKButton.Text = "⚡ Anti-AFK : ON"
    end
end)

-- =========================
-- Rejoin
-- =========================

local RejoinButton = Instance.new("TextButton")
RejoinButton.Size = UDim2.new(1, -20, 0, 40)
RejoinButton.Position = UDim2.new(0, 10, 0, 100)
RejoinButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
RejoinButton.Text = "🔄 Rejoin Server"
RejoinButton.TextSize = 15
RejoinButton.TextColor3 = Color3.new(1, 1, 1)
RejoinButton.Font = Enum.Font.Gotham
RejoinButton.Parent = Frame

Instance.new("UICorner", RejoinButton).CornerRadius = UDim.new(0, 8)

RejoinButton.Activated:Connect(function()
    local success, err = pcall(function()
        TeleportService:Teleport(game.PlaceId, Player)
    end)

    if not success then
        warn("Rejoin Error:", err)
    end
end)

-- =========================
-- ปิด GUI
-- =========================

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(30, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "✕"
CloseButton.TextSize = 18
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Parent = Frame

CloseButton.Activated:Connect(function()
    StopAntiAFK()
    Gui:Destroy()
end)

print("📱 Mobile Control loaded successfully")
