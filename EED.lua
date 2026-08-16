local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    rootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

--==================================================
-- CONFIG
--==================================================

local correctKey = "GGGR@23LO"

local config = {
    AutoEggs = false,
    AutoMoney = false,
    AutoBuy = false,
    AntiAFK = true
}

local chickenCost1 = 20
local chickenCost5 = 100
local maxEggs = 30

local eggCount = 0
local fps = 0
local ping = 0

--==================================================
-- LEADERSTATS
--==================================================

local leaderstats = player:WaitForChild("leaderstats", 5)

local moneyValue

if leaderstats then
    moneyValue =
        leaderstats:FindFirstChild("Money")
        or leaderstats:FindFirstChild("Cash")
        or leaderstats:FindFirstChild("Coins")
end

--==================================================
-- REMOTE
--==================================================

local remoteFunction

pcall(function()
    remoteFunction = ReplicatedStorage
        :WaitForChild("Paper", 5)
        :WaitForChild("Remotes", 5)
        :WaitForChild("__remotefunction", 5)
end)

--==================================================
-- HELPER FUNCTIONS
--==================================================

local function getRootPart()
    if not character or not character.Parent then
        character = player.Character or player.CharacterAdded:Wait()
    end

    if not rootPart or not rootPart.Parent then
        rootPart = character:WaitForChild("HumanoidRootPart")
    end

    return rootPart
end

local function teleportTo(targetPart)
    local root = getRootPart()

    if not root or not targetPart then
        return false
    end

    if targetPart:IsA("BasePart") then
        root.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
        return true
    end

    if targetPart:IsA("Model") then
        local primary = targetPart.PrimaryPart

        if primary and primary:IsA("BasePart") then
            root.CFrame = primary.CFrame + Vector3.new(0, 3, 0)
            return true
        end

        local part = targetPart:FindFirstChildWhichIsA("BasePart")

        if part then
            root.CFrame = part.CFrame + Vector3.new(0, 3, 0)
            return true
        end
    end

    return false
end

local function isButtonRed(buttonPart)
    if not buttonPart or not buttonPart:IsA("BasePart") then
        return false
    end

    local color = buttonPart.Color

    if buttonPart.BrickColor == BrickColor.new("Bright red") then
        return true
    end

    if color.R > 0.7 and color.G < 0.3 and color.B < 0.3 then
        return true
    end

    return false
end

local function getPlot()
    local plots = workspace:FindFirstChild("Plots")

    if not plots then
        return nil
    end

    return plots:FindFirstChild("BBBR17k")
end

local function getButton(buttonName)
    local plot = getPlot()

    if not plot then
        return nil
    end

    local buttons = plot:FindFirstChild("Buttons")

    if not buttons then
        return nil
    end

    return buttons:FindFirstChild(buttonName)
end

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaUltimateFarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

--==================================================
-- KEY FRAME
--==================================================

local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = ScreenGui
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
KeyFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
KeyFrame.Size = UDim2.new(0, 340, 0, 240)
KeyFrame.Active = true
KeyFrame.Draggable = true

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 14)
KeyCorner.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyFrame
KeyTitle.BackgroundTransparency = 1
KeyTitle.Position = UDim2.new(0, 0, 0.08, 0)
KeyTitle.Size = UDim2.new(1, 0, 0, 30)
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.Text = "DELTA KEY SYSTEM"
KeyTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
KeyTitle.TextSize = 22

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Parent = KeyFrame
KeyTextBox.Position = UDim2.new(0.1, 0, 0.32, 0)
KeyTextBox.Size = UDim2.new(0.8, 0, 0, 45)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
KeyTextBox.Font = Enum.Font.SourceSans
KeyTextBox.PlaceholderText = "Paste Your Key Here..."
KeyTextBox.Text = ""
KeyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTextBox.TextSize = 16

local KeyTextBoxCorner = Instance.new("UICorner")
KeyTextBoxCorner.CornerRadius = UDim.new(0, 8)
KeyTextBoxCorner.Parent = KeyTextBox

local BtnCheckKey = Instance.new("TextButton")
BtnCheckKey.Parent = KeyFrame
BtnCheckKey.Position = UDim2.new(0.1, 0, 0.58, 0)
BtnCheckKey.Size = UDim2.new(0.8, 0, 0, 45)
BtnCheckKey.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
BtnCheckKey.Font = Enum.Font.SourceSansBold
BtnCheckKey.Text = "Check Key"
BtnCheckKey.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnCheckKey.TextSize = 18

local BtnCheckCorner = Instance.new("UICorner")
BtnCheckCorner.CornerRadius = UDim.new(0, 8)
BtnCheckCorner.Parent = BtnCheckKey

local KeyStatus = Instance.new("TextLabel")
KeyStatus.Parent = KeyFrame
KeyStatus.BackgroundTransparency = 1
KeyStatus.Position = UDim2.new(0, 0, 0.82, 0)
KeyStatus.Size = UDim2.new(1, 0, 0, 25)
KeyStatus.Font = Enum.Font.SourceSansItalic
KeyStatus.Text = "Please enter valid key to proceed"
KeyStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
KeyStatus.TextSize = 14

--==================================================
-- MAIN FRAME
--==================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

--==================================================
-- TOGGLE BUTTON
--==================================================

local ToggleIconButton = Instance.new("TextButton")
ToggleIconButton.Name = "ToggleIconButton"
ToggleIconButton.Parent = ScreenGui
ToggleIconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleIconButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleIconButton.Size = UDim2.new(0, 50, 0, 50)
ToggleIconButton.Font = Enum.Font.SourceSansBold
ToggleIconButton.Text = "⚙️"
ToggleIconButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleIconButton.TextSize = 28
ToggleIconButton.Active = true
ToggleIconButton.Draggable = true
ToggleIconButton.Visible = false

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 12)
IconCorner.Parent = ToggleIconButton

ToggleIconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--==================================================
-- MAIN GUI LABELS
--==================================================

local DashboardTitle = Instance.new("TextLabel")
DashboardTitle.Parent = MainFrame
DashboardTitle.BackgroundTransparency = 1
DashboardTitle.Position = UDim2.new(0.05, 0, 0.03, 0)
DashboardTitle.Size = UDim2.new(0.9, 0, 0, 40)
DashboardTitle.Font = Enum.Font.SourceSansBold
DashboardTitle.Text = "DELTA CHICKEN FARMER - ULTIMATE"
DashboardTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
DashboardTitle.TextSize = 22
DashboardTitle.TextXAlignment = Enum.TextXAlignment.Left

local StatLabel = Instance.new("TextLabel")
StatLabel.Parent = MainFrame
StatLabel.BackgroundTransparency = 1
StatLabel.Position = UDim2.new(0.05, 0, 0.12, 0)
StatLabel.Size = UDim2.new(0.9, 0, 0, 25)
StatLabel.Font = Enum.Font.SourceSansItalic
StatLabel.Text = "FPS: Checking... | Ping: Checking..."
StatLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
StatLabel.TextSize = 15
StatLabel.TextXAlignment = Enum.TextXAlignment.Left

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.05, 0, 0.18, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "System Status: Standing By..."
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 16
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- BUTTON CREATOR
--==================================================

local function createButton(name, position, text, textSize)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = MainFrame
    button.Position = position
    button.Size = UDim2.new(0.9, 0, 0, 55)
    button.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    button.Font = Enum.Font.SourceSansBold
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = textSize or 18

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    return button
end

local BtnEggs = createButton(
    "BtnEggs",
    UDim2.new(0.05, 0, 0.28, 0),
    "Auto Farm Eggs: OFF",
    18
)

local BtnMoney = createButton(
    "BtnMoney",
    UDim2.new(0.05, 0, 0.43, 0),
    "Auto Collect Money (1 Min): OFF",
    18
)

local BtnBuy = createButton(
    "BtnBuy",
    UDim2.new(0.05, 0, 0.58, 0),
    "AI Smart Buy Chicken (Color-Check): OFF",
    16
)

local BtnAFK = createButton(
    "BtnAFK",
    UDim2.new(0.05, 0, 0.73, 0),
    "100% Anti-AFK Bypass: ACTIVE",
    18
)

BtnAFK.BackgroundColor3 = Color3.fromRGB(50, 180, 50)

--==================================================
-- TOGGLE FUNCTIONS
--==================================================

local function updateEggButton()
    BtnEggs.BackgroundColor3 =
        config.AutoEggs
        and Color3.fromRGB(50, 180, 50)
        or Color3.fromRGB(180, 50, 50)

    BtnEggs.Text =
        config.AutoEggs
        and "Auto Farm Eggs: ON"
        or "Auto Farm Eggs: OFF"
end

local function updateMoneyButton()
    BtnMoney.BackgroundColor3 =
        config.AutoMoney
        and Color3.fromRGB(50, 180, 50)
        or Color3.fromRGB(180, 50, 50)

    BtnMoney.Text =
        config.AutoMoney
        and "Auto Collect Money (1 Min): ON"
        or "Auto Collect Money (1 Min): OFF"
end

local function updateBuyButton()
    BtnBuy.BackgroundColor3 =
        config.AutoBuy
        and Color3.fromRGB(50, 180, 50)
        or Color3.fromRGB(180, 50, 50)

    BtnBuy.Text =
        config.AutoBuy
        and "AI Smart Buy Chicken (Color-Check): ON"
        or "AI Smart Buy Chicken (Color-Check): OFF"
end

BtnEggs.MouseButton1Click:Connect(function()
    config.AutoEggs = not config.AutoEggs
    updateEggButton()
end)

BtnMoney.MouseButton1Click:Connect(function()
    config.AutoMoney = not config.AutoMoney
    updateMoneyButton()
end)

BtnBuy.MouseButton1Click:Connect(function()
    config.AutoBuy = not config.AutoBuy
    updateBuyButton()
end)

--==================================================
-- FPS / PING
--==================================================

task.spawn(function()
    local lastTime = os.clock()
    local frameCount = 0

    while task.wait() do
        frameCount += 1

        local currentTime = os.clock()

        if currentTime - lastTime >= 1 then
            fps = frameCount
            frameCount = 0
            lastTime = currentTime

            pcall(function()
                ping = math.floor(player:GetNetworkPing() * 1000)
            end)

            StatLabel.Text =
                "FPS: " .. tostring(fps) ..
                " | Ping: " .. tostring(ping) .. " ms"

            if ping > 250 then
                StatLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            elseif ping > 100 then
                StatLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
            else
                StatLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
            end
        end
    end
end)

--==================================================
-- ANTI AFK
--==================================================

player.Idled:Connect(function()
    if not config.AntiAFK then
        return
    end

    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end)

task.spawn(function()
    while task.wait(120) do
        if config.AntiAFK then
            local root = getRootPart()

            if root then
                pcall(function()
                    root.CFrame =
                        root.CFrame * CFrame.new(0, 0.01, 0)

                    task.wait(0.1)

                    root.CFrame =
                        root.CFrame * CFrame.new(0, -0.01, 0)
                end)
            end
        end
    end
end)

--==================================================
-- AUTO FARM EGGS
--==================================================

task.spawn(function()
    while task.wait(0.5) do
        if not config.AutoEggs then
            continue
        end

        StatusLabel.Text = "System Status: Farming Eggs..."

        local eggsFolder = workspace:FindFirstChild("Eggs")

        if not eggsFolder then
            StatusLabel.Text = "System Status: Eggs folder not found."
            continue
        end

        for _, egg in ipairs(eggsFolder:GetChildren()) do
            if not config.AutoEggs then
                break
            end

            local target = nil

            if egg:IsA("Model") then
                target = egg.PrimaryPart

                if not target then
                    target = egg:FindFirstChildWhichIsA("BasePart")
                end
            elseif egg:IsA("BasePart") then
                target = egg
            end

            if target then
                teleportTo(target)

                eggCount += 1

                task.wait(0.35)

                if eggCount >= maxEggs then
                    StatusLabel.Text =
                        "System Status: Depositing Eggs..."

                    local depositButton = getButton("DepositEggs")

                    if depositButton then
                        local hitbox =
                            depositButton:FindFirstChild("Hitbox")

                        if hitbox then
                            teleportTo(hitbox)
                        else
                            teleportTo(depositButton)
                        end
                    end

                    task.wait(1.2)

                    eggCount = 0
                end
            end
        end
    end
end)

--==================================================
-- AUTO COLLECT MONEY
--==================================================

task.spawn(function()
    while task.wait(1) do
        if config.AutoMoney then
            StatusLabel.Text =
                "System Status: Waiting for money..."

            task.wait(60)

            if config.AutoMoney then
                StatusLabel.Text =
                    "System Status: Collecting Money!"

                local collectButton =
                    getButton("CollectMoney")

                if collectButton then
                    local buttonPart =
                        collectButton:FindFirstChild("Button")

                    if buttonPart then
                        teleportTo(buttonPart)
                    else
                        teleportTo(collectButton)
                    end
                end

                task.wait(1.5)
            end
        end
    end
end)

--==================================================
-- AUTO BUY CHICKENS
--==================================================

task.spawn(function()
    while task.wait(1) do
        if not config.AutoBuy then
            continue
        end

        if not moneyValue then
            StatusLabel.Text =
                "System Status: Money value not found."

            continue
        end

        local buyButton = getButton("BuyChickens")

        if not buyButton then
            StatusLabel.Text =
                "System Status: BuyChickens button not found."

            continue
        end

        pcall(function()
            if isButtonRed(buyButton) then
                StatusLabel.Text =
                    "System Status: Chicken Button RED. Idle Task Enabled."

                return
            end

            if moneyValue.Value < chickenCost1 then
                StatusLabel.Text =
                    "System Status: Not enough money."

                return
            end

            while config.AutoBuy
                and moneyValue.Value >= chickenCost1
                and not isButtonRed(buyButton) do

                StatusLabel.Text =
                    "System Status: Button GREEN! Upgrading..."

                teleportTo(buyButton)

                task.wait(0.3)

                if not remoteFunction then
                    StatusLabel.Text =
                        "System Status: RemoteFunction not found."

                    break
                end

                if moneyValue.Value >= chickenCost5 then
                    remoteFunction:InvokeServer(
                        "Buy Chickens",
                        5
                    )
                else
                    remoteFunction:InvokeServer(
                        "Buy Chickens",
                        1
                    )
                end

                task.wait(0.5)
            end
        end)
    end
end)

--==================================================
-- KEY CHECK
--==================================================

BtnCheckKey.MouseButton1Click:Connect(function()
    local enteredKey = KeyTextBox.Text

    if enteredKey == correctKey then
        KeyStatus.TextColor3 =
            Color3.fromRGB(0, 255, 0)

        KeyStatus.Text =
            "Key Correct! Loading script..."

        task.wait(1)

        KeyFrame:Destroy()

        MainFrame.Visible = true
        ToggleIconButton.Visible = true

        StatusLabel.Text =
            "System Status: Ready."
    else
        KeyStatus.TextColor3 =
            Color3.fromRGB(255, 50, 50)

        KeyStatus.Text =
            "Invalid Key! Please try again."

        KeyTextBox.Text = ""
    end
end)
