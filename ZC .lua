-- =========================================================
-- Delta Mega Menu - Fixed Full Version
-- แก้เฉพาะส่วนที่ทำให้ Error / Runtime Error
-- =========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- =========================================================
-- ล้าง GUI เก่า
-- =========================================================

pcall(function()
    local CoreGui = game:GetService("CoreGui")
    local old = CoreGui:FindFirstChild("DeltaMegaScript")
    if old then
        old:Destroy()
    end
end)

-- =========================================================
-- GUI
-- =========================================================

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ContentScroll = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local DropdownContainer = Instance.new("ScrollingFrame")
local DropdownListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "DeltaMegaScript"

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

MainFrame.Name = "DeltaMegaScript"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 270, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

TitleLabel.Parent = MainFrame
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleLabel.Text = " Delta Mega Menu "
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18

ContentScroll.Parent = MainFrame
ContentScroll.Position = UDim2.new(0, 0, 0, 35)
ContentScroll.Size = UDim2.new(1, 0, 1, -35)
ContentScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 650)
ContentScroll.ScrollBarThickness = 6
ContentScroll.BorderSizePixel = 0

UIListLayout.Parent = ContentScroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

DropdownContainer.Parent = MainFrame
DropdownContainer.Position = UDim2.new(0.05, 0, 0.45, 0)
DropdownContainer.Size = UDim2.new(0.9, 0, 0, 120)
DropdownContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DropdownContainer.Visible = false
DropdownContainer.ZIndex = 10
DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, 450)
DropdownContainer.ScrollBarThickness = 6
DropdownContainer.BorderSizePixel = 0

DropdownListLayout.Parent = DropdownContainer
DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- =========================================================
-- Helper
-- =========================================================

local function getCharacter()
    local character = player.Character

    if not character then
        return nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then
        return nil
    end

    return character, humanoid, root
end

-- =========================================================
-- Header
-- =========================================================

local function createHeader(text)
    local label = Instance.new("TextLabel")

    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    label.Text = "--- " .. text .. " ---"
    label.TextColor3 = Color3.fromRGB(255, 200, 0)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.Parent = ContentScroll

    return label
end

-- =========================================================
-- Button
-- =========================================================

local function createButton(text, onClick)
    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = ContentScroll

    local active = false

    btn.MouseButton1Click:Connect(function()
        active = not active

        if active then
            btn.Text = text .. ": ON"
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            btn.Text = text .. ": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end

        pcall(function()
            onClick(active)
        end)
    end)

    return btn
end

-- =========================================================
-- Slider
-- =========================================================

local function createSlider(labelPrefix, min, max, default, onChanged)
    local frame = Instance.new("Frame")

    frame.Size = UDim2.new(0.9, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = ContentScroll

    local label = Instance.new("TextLabel")

    label.Size = UDim2.new(1, 0, 0, 15)
    label.BackgroundTransparency = 1
    label.Text = labelPrefix .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Font = Enum.Font.SourceSans
    label.Parent = frame

    local sliderBg = Instance.new("Frame")

    sliderBg.Size = UDim2.new(1, 0, 0, 15)
    sliderBg.Position = UDim2.new(0, 0, 0, 20)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame

    local sliderBtn = Instance.new("TextButton")

    local startPerc = 0

    if max ~= min then
        startPerc = (default - min) / (max - min)
    end

    startPerc = math.clamp(startPerc, 0, 1)

    sliderBtn.Size = UDim2.new(0.1, 0, 1, 0)
    sliderBtn.Position = UDim2.new(
        math.clamp(startPerc - 0.05, 0, 0.9),
        0,
        0,
        0
    )
    sliderBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBg

    local dragging = false

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            local mouseX = input.Position.X
            local bgX = sliderBg.AbsolutePosition.X
            local bgWidth = sliderBg.AbsoluteSize.X

            if bgWidth <= 0 then
                return
            end

            local percentage = math.clamp(
                (mouseX - bgX) / bgWidth,
                0,
                1
            )

            sliderBtn.Position = UDim2.new(
                math.clamp(percentage - 0.05, 0, 0.9),
                0,
                0,
                0
            )

            local val = min + (percentage * (max - min))
            val = math.round(val * 10) / 10

            label.Text = labelPrefix .. ": " .. tostring(val)

            pcall(function()
                onChanged(val)
            end)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    return frame
end

-- =========================================================
-- Global Settings
-- =========================================================

_G.AutoWinActive = false
_G.AutoRebirthActive = false
_G.AutoBuyActive = false
_G.AutoCharmActive = false
_G.InfiniteJumpActive = false

_G.SelectedStage = "Auto"

_G.WarpDelay = 0.5
_G.CharmDelay = 1.0

_G.WalkSpeedVal = 16
_G.JumpPowerVal = 50

-- =========================================================
-- Leaderstats
-- =========================================================

local leaderboard = player:WaitForChild("leaderstats", 5)

-- =========================================================
-- Stage
-- =========================================================

local function getStageButton(stageNum)

    local map = workspace:FindFirstChild("Map")

    if not map then
        return nil
    end

    local world1 = map:FindFirstChild("World1")

    if not world1 then
        return nil
    end

    local stages = world1:FindFirstChild("Stages")

    if not stages then
        return nil
    end

    local stage = stages:FindFirstChild("Stage" .. tostring(stageNum))

    if not stage then
        return nil
    end

    if stageNum == 1 then

        local main = stage:FindFirstChild("Main")

        if main then
            local stageEnd = main:FindFirstChild("StageEnd")

            if stageEnd then
                local button = stageEnd:FindFirstChild("Button")

                if button then
                    return button
                end
            end
        end

    else

        local normalWin = stage:FindFirstChild("NormalWin")

        if normalWin then
            local button = normalWin:FindFirstChild("Button")

            if button then
                return button
            end
        end
    end

    return nil
end

-- =========================================================
-- Treadmill
-- =========================================================

local function getTreadmillPart(name)

    local map = workspace:FindFirstChild("Map")

    if not map then
        return nil
    end

    local world1 = map:FindFirstChild("World1")

    if not world1 then
        return nil
    end

    local stages = world1:FindFirstChild("Stages")

    if not stages then
        return nil
    end

    if name == "Basic" then

        local stage1 = stages:FindFirstChild("Stage1")

        if stage1 then
            local treadmill = stage1:FindFirstChild("TreadmillBasic")

            if treadmill then
                return treadmill:FindFirstChild("Basic")
            end
        end

    elseif name == "Golden" then

        local stage1 = stages:FindFirstChild("Stage1")

        if stage1 then
            local treadmill = stage1:FindFirstChild("TreadmillGold")

            if treadmill then
                return treadmill:FindFirstChild("Golden")
            end
        end

    else

        local spawn = stages:FindFirstChild("Spawn")

        if not spawn then
            return nil
        end

        local tm = spawn:FindFirstChild("Treadmills")

        if not tm then
            return nil
        end

        if name == "Galaxy" then
            local obj = tm:FindFirstChild("TreadmillGalaxy")
            return obj and obj:FindFirstChild("Galaxy")

        elseif name == "Void" then
            local obj = tm:FindFirstChild("TreadmillVoid")
            return obj and obj:FindFirstChild("Void")

        elseif name == "Celestial" then
            local obj = tm:FindFirstChild("TreadmillCelestial")
            return obj and obj:FindFirstChild("Celestial")

        elseif name == "Diamond" then
            local obj = tm:FindFirstChild("TreadmillDiamond")
            return obj and obj:FindFirstChild("Diamond")

        elseif name == "Reward" then
            local obj = tm:FindFirstChild("TreadmillPlaytime")
            return obj and obj:FindFirstChild("Reward")
        end
    end

    return nil
end

-- =========================================================
-- Player Stat
-- =========================================================

local function getPlayerStat(statName)

    if not leaderboard then
        return 0
    end

    local stat = leaderboard:FindFirstChild(statName)

    if not stat then
        return 0
    end

    local value = stat.Value

    if typeof(value) == "number" then
        return value
    end

    local converted = tonumber(value)

    return converted or 0
end

-- =========================================================
-- Check / Buy
-- =========================================================

local function checkAndBuy(button)

    if not button then
        return
    end

    if not button:IsA("BasePart") then
        return
    end

    local character, humanoid, root = getCharacter()

    if not character or not humanoid or not root then
        return
    end

    local priceValue =
        button:FindFirstChild("Price")
        or button:FindFirstChild("Cost")

    local currencyValue =
        button:FindFirstChild("Currency")
        or button:FindFirstChild("Type")

    if not priceValue then
        return
    end

    local price = tonumber(priceValue.Value)

    if not price then
        return
    end

    local currencyName = "Coins"

    if currencyValue then
        currencyName = tostring(currencyValue.Value)
    end

    local playerMoney = getPlayerStat(currencyName)

    if playerMoney >= price then

        local currentCFrame = root.CFrame

        pcall(function()
            root.CFrame = button.CFrame
            task.wait(0.1)
            root.CFrame = currentCFrame
        end)
    end
end

-- =========================================================
-- GUI - Farm
-- =========================================================

createHeader("Farm Functions")

createButton("Auto Win / Treadmill", function(val)
    _G.AutoWinActive = val
end)

-- Dropdown Button
local dropBtn = Instance.new("TextButton")

dropBtn.Size = UDim2.new(0.9, 0, 0, 35)
dropBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropBtn.Text = "Target: Auto (Loop 1-9)"
dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- FIX: เดิมเป็น SourceSansBolddropBtn ซึ่งผิด
dropBtn.Font = Enum.Font.SourceSansBold

dropBtn.TextSize = 14
dropBtn.Parent = ContentScroll

createSlider(
    "Warp Speed Delay",
    0.1,
    3.0,
    0.5,
    function(val)
        _G.WarpDelay = val
    end
)

createButton("Auto Rebirth", function(val)
    _G.AutoRebirthActive = val
end)

createButton("Auto Buy Upgrades", function(val)
    _G.AutoBuyActive = val
end)

-- =========================================================
-- Charm
-- =========================================================

createHeader("Charm Functions")

createButton("Auto Buy Charms (Slot 1-3)", function(val)
    _G.AutoCharmActive = val
end)

createSlider(
    "Charm Speed Delay",
    0.1,
    3.0,
    1.0,
    function(val)
        _G.CharmDelay = val
    end
)

-- =========================================================
-- Player
-- =========================================================

createHeader("Player Functions")

createSlider(
    "WalkSpeed Custom",
    16,
    200,
    16,
    function(val)
        _G.WalkSpeedVal = val
    end
)

createSlider(
    "JumpPower Custom",
    50,
    300,
    50,
    function(val)
        _G.JumpPowerVal = val
    end
)

createButton("Infinite Jump", function(val)
    _G.InfiniteJumpActive = val
end)

-- =========================================================
-- Auto Win Loop
-- =========================================================

task.spawn(function()

    while true do

        task.wait(tonumber(_G.WarpDelay) or 0.5)

        if not _G.AutoWinActive then
            continue
        end

        local character, humanoid, root = getCharacter()

        if not character or not humanoid or not root then
            continue
        end

        pcall(function()

            if _G.SelectedStage == "Auto" then

                for i = 1, 9 do

                    if not _G.AutoWinActive then
                        break
                    end

                    local btn = getStageButton(i)

                    if btn and btn:IsA("BasePart") then
                        root.CFrame = btn.CFrame
                        task.wait(0.1)
                    end
                end

            elseif string.sub(tostring(_G.SelectedStage), 1, 3) == "TM_" then

                local treadmillName =
                    string.sub(tostring(_G.SelectedStage), 4)

                local tmPart = getTreadmillPart(treadmillName)

                if tmPart and tmPart:IsA("BasePart") then
                    root.CFrame = tmPart.CFrame
                end

            elseif tonumber(_G.SelectedStage) then

                local btn =
                    getStageButton(tonumber(_G.SelectedStage))

                if btn and btn:IsA("BasePart") then
                    root.CFrame = btn.CFrame
                end
            end

        end)
    end
end)

-- =========================================================
-- Auto Buy
-- =========================================================

task.spawn(function()

    while true do

        task.wait(1)

        if _G.AutoBuyActive then

            pcall(function()

                local character, humanoid, root = getCharacter()

                if not character or not humanoid or not root then
                    return
                end

                local fx = workspace:FindFirstChild("Fx")

                if not fx then
                    return
                end

                for _, child in ipairs(fx:GetChildren()) do

                    local btn

                    if child:IsA("Model") then

                        btn =
                            child:FindFirstChild("Button")
                            or child:FindFirstChild("Touch")
                            or child

                    else
                        btn = child
                    end

                    if btn then
                        checkAndBuy(btn)
                    end
                end
            end)
        end
    end
end)

-- =========================================================
-- Auto Rebirth
-- =========================================================

task.spawn(function()

    while true do

        task.wait(1)

        if _G.AutoRebirthActive then

            pcall(function()

                local remotes =
                    ReplicatedStorage:FindFirstChild("Remotes")

                if not remotes then
                    return
                end

                local rebirth =
                    remotes:FindFirstChild("Rebirth")

                if rebirth and rebirth:IsA("RemoteEvent") then
                    rebirth:FireServer()
                end
            end)
        end
    end
end)

-- =========================================================
-- Auto Charm
-- =========================================================

task.spawn(function()

    while true do

        task.wait(tonumber(_G.CharmDelay) or 1)

        if _G.AutoCharmActive then

            pcall(function()

                local remotes =
                    ReplicatedStorage:FindFirstChild("Remotes")

                if not remotes then
                    return
                end

                local remote =
                    remotes:FindFirstChild("SetPendingCharmSlot")

                if remote and remote:IsA("RemoteEvent") then

                    remote:FireServer(1)
                    task.wait(0.05)

                    remote:FireServer(2)
                    task.wait(0.05)

                    remote:FireServer(3)
                end
            end)
        end
    end
end)

-- =========================================================
-- WalkSpeed / JumpPower
-- =========================================================

task.spawn(function()

    while true do

        task.wait(0.1)

        pcall(function()

            local character, humanoid = getCharacter()

            if humanoid then
                humanoid.WalkSpeed =
                    tonumber(_G.WalkSpeedVal) or 16

                humanoid.JumpPower =
                    tonumber(_G.JumpPowerVal) or 50
            end
        end)
    end
end)

-- =========================================================
-- Infinite Jump
-- =========================================================

UserInputService.JumpRequest:Connect(function()

    if not _G.InfiniteJumpActive then
        return
    end

    pcall(function()

        local character, humanoid = getCharacter()

        if humanoid then
            -- FIX: ใช้ Enum แทน string "Jumping"
            humanoid:ChangeState(
                Enum.HumanoidStateType.Jumping
            )
        end
    end)
end)

-- =========================================================
-- Dropdown Options
-- =========================================================

local function createDropdownOption(text, value)

    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.ZIndex = 11
    btn.Parent = DropdownContainer

    btn.MouseButton1Click:Connect(function()

        _G.SelectedStage = value

        dropBtn.Text = "Target: " .. text

        DropdownContainer.Visible = false
    end)

    return btn
end

createDropdownOption(
    "Auto (Loop 1-9)",
    "Auto"
)

for i = 1, 9 do
    createDropdownOption(
        "Stage " .. tostring(i),
        tostring(i)
    )
end

createDropdownOption(
    "--- ลู่วิ่ง (Treadmills) ---",
    "Header"
)

createDropdownOption(
    "Treadmill Basic",
    "TM_Basic"
)

createDropdownOption(
    "Treadmill Gold",
    "TM_Golden"
)

createDropdownOption(
    "Treadmill Galaxy",
    "TM_Galaxy"
)

createDropdownOption(
    "Treadmill Void",
    "TM_Void"
)

createDropdownOption(
    "Treadmill Celestial",
    "TM_Celestial"
)

createDropdownOption(
    "Treadmill Diamond",
    "TM_Diamond"
)

createDropdownOption(
    "Treadmill Playtime",
    "TM_Reward"
)

-- =========================================================
-- Dropdown Toggle
-- =========================================================

dropBtn.MouseButton1Click:Connect(function()

    DropdownContainer.Visible =
        not DropdownContainer.Visible

end)

-- =========================================================
-- อัปเดต Canvas อัตโนมัติ
-- =========================================================

pcall(function()

    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize")
        :Connect(function()

            ContentScroll.CanvasSize = UDim2.new(
                0,
                0,
                0,
                UIListLayout.AbsoluteContentSize.Y + 20
            )

        end)

    DropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize")
        :Connect(function()

            DropdownContainer.CanvasSize = UDim2.new(
                0,
                0,
                0,
                DropdownListLayout.AbsoluteContentSize.Y + 10
            )

        end)

end)

print("Delta Mega Menu - Fixed Version Loaded")
