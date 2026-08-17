--// =========================================================
--// Delta Master Auto Farm GUI
--// =========================================================

--// ป้องกัน GUI ซ้ำ
pcall(function()
    local oldGui = game.CoreGui:FindFirstChild("DeltaMasterFarmGui")
    if oldGui then
        oldGui:Destroy()
    end
end)

--// Services
local Players = game:GetService("Players")

--// Player
local player = Players.LocalPlayer

--// =========================================================
--// GUI
--// =========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaMasterFarmGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 240, 0, 220)
Frame.Active = true
Frame.Draggable = true

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = Frame
TitleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleLabel.BorderSizePixel = 0
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Master Auto Farm Menu"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.Parent = Frame
StatusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
StatusLabel.BorderSizePixel = 0
StatusLabel.Position = UDim2.new(0.1, 0, 0.3, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 35)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "สถานะ: ปิดการทำงาน"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.TextSize = 14

local ToggleMasterButton = Instance.new("TextButton")
ToggleMasterButton.Name = "Toggle"
ToggleMasterButton.Parent = Frame
ToggleMasterButton.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
ToggleMasterButton.BorderSizePixel = 0
ToggleMasterButton.Position = UDim2.new(0.1, 0, 0.6, 0)
ToggleMasterButton.Size = UDim2.new(0.8, 0, 0, 45)
ToggleMasterButton.Font = Enum.Font.SourceSansBold
ToggleMasterButton.Text = "เปิดระบบ Auto ทั้งหมด"
ToggleMasterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMasterButton.TextSize = 16
ToggleMasterButton.AutoButtonColor = true

--// =========================================================
--// SETTINGS
--// =========================================================

_G.MasterAuto = false

local EGG_PULL_DELAY = 0.1
local MONEY_DELAY = 30
local DEPOSIT_DELAY = 10
local BUY_CHICKEN_DELAY = 5

--// =========================================================
--// SAFE WAIT FOR OBJECT
--// =========================================================

local function getPath(...)
    local current = game.Workspace

    for _, name in ipairs({...}) do
        if not current then
            return nil
        end

        current = current:FindFirstChild(name)

        if not current then
            return nil
        end
    end

    return current
end

--// =========================================================
--// OBJECT PATHS
--// =========================================================

local plot = getPath("Plots", "BBBR17k")

local moneyButtonPath = nil
local depositHitboxPath = nil
local buyChickensPath = nil
local eggsFolder = nil

if plot then
    moneyButtonPath = getPath(
        "Plots",
        "BBBR17k",
        "Buttons",
        "CollectMoney",
        "Button"
    )

    depositHitboxPath = getPath(
        "Plots",
        "BBBR17k",
        "Buttons",
        "DepositEggs",
        "Hitbox"
    )

    buyChickensPath = getPath(
        "Plots",
        "BBBR17k",
        "Buttons",
        "BuyChickens",
        "Buy5",
        "Button"
    )
end

eggsFolder = getPath(
    "Leaderboards",
    "Eggs"
)

--// =========================================================
--// CHARACTER
--// =========================================================

local function getCharacter()
    local character = player.Character

    if not character then
        character = player.CharacterAdded:Wait()
    end

    return character
end

local function getRootPart()
    local character = getCharacter()

    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

--// =========================================================
--// GET TARGET CFRAME
--// รองรับทั้ง BasePart และ Model
--// =========================================================

local function getTargetCFrame(target)
    if not target then
        return nil
    end

    if target:IsA("BasePart") then
        return target.CFrame
    end

    if target:IsA("Model") then
        return target:GetPivot()
    end

    return nil
end

--// =========================================================
--// TELEPORT
--// =========================================================

local function teleportTo(target)
    if not target then
        return false
    end

    local rootPart = getRootPart()

    if not rootPart then
        return false
    end

    local targetCFrame = getTargetCFrame(target)

    if not targetCFrame then
        return false
    end

    rootPart.CFrame = targetCFrame + Vector3.new(0, 3, 0)

    return true
end

--// =========================================================
--// PULL ALL EGGS
--// =========================================================

local function moveObjectToPlayer(object, targetCFrame)
    if not object then
        return
    end

    pcall(function()
        if object:IsA("BasePart") then
            object.CFrame = targetCFrame

        elseif object:IsA("Model") then
            object:PivotTo(targetCFrame)
        end
    end)
end

local function pullAllEggs()
    if not eggsFolder then
        return
    end

    local rootPart = getRootPart()

    if not rootPart then
        return
    end

    local targetCFrame = rootPart.CFrame

    for _, egg in ipairs(eggsFolder:GetChildren()) do
        moveObjectToPlayer(egg, targetCFrame)
    end
end

--// =========================================================
--// STATUS
--// =========================================================

local function setMasterState(enabled)
    _G.MasterAuto = enabled

    if enabled then
        ToggleMasterButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ToggleMasterButton.Text = "ปิดระบบ Auto ทั้งหมด"

        StatusLabel.Text = "สถานะ: กำลังทำงาน..."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        ToggleMasterButton.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
        ToggleMasterButton.Text = "เปิดระบบ Auto ทั้งหมด"

        StatusLabel.Text = "สถานะ: ปิดการทำงาน"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

--// =========================================================
--// MASTER TOGGLE
--// =========================================================

ToggleMasterButton.MouseButton1Click:Connect(function()
    setMasterState(not _G.MasterAuto)
end)

--// =========================================================
--// AUTO PULL EGGS
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do

        if _G.MasterAuto then
            pullAllEggs()
            task.wait(EGG_PULL_DELAY)
        else
            task.wait(0.5)
        end

    end
end)

--// =========================================================
--// AUTO COLLECT MONEY
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do

        task.wait(MONEY_DELAY)

        if _G.MasterAuto then
            if moneyButtonPath then
                teleportTo(moneyButtonPath)
            end
        end

    end
end)

--// =========================================================
--// AUTO DEPOSIT EGGS
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do

        task.wait(DEPOSIT_DELAY)

        if _G.MasterAuto then
            if depositHitboxPath then
                teleportTo(depositHitboxPath)
            end
        end

    end
end)

--// =========================================================
--// AUTO BUY CHICKENS
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do

        task.wait(BUY_CHICKEN_DELAY)

        if _G.MasterAuto then
            if buyChickensPath then
                teleportTo(buyChickensPath)
            end
        end

    end
end)

--// =========================================================
--// CHARACTER RESPAWN SUPPORT
--// =========================================================

player.CharacterAdded:Connect(function()
    task.wait(1)

    if _G.MasterAuto then
        StatusLabel.Text = "สถานะ: ตัวละครเกิดใหม่ - ระบบทำงานต่อ"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
end)

--// =========================================================
--// DEBUG
--// =========================================================

print("========================================")
print("Delta Master Auto Farm GUI")
print("GUI Loaded Successfully")
print("Egg Folder:", eggsFolder and "Found" or "Not Found")
print("Money Button:", moneyButtonPath and "Found" or "Not Found")
print("Deposit Hitbox:", depositHitboxPath and "Found" or "Not Found")
print("Buy Chickens:", buyChickensPath and "Found" or "Not Found")
print("========================================")
