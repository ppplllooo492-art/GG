--// DELTA HUB // ULTIMATE
--// Fixed / cleaned version

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local config = {
    AutoEggs = false,
    AutoMoney = false,
    AutoBuy = false,
    AutoLucky = false,
    PullBuyButton = false,
    AntiAFK = true
}

local correctKey = "GGGR@23LO"

local chickenCost1 = 20
local chickenCost5 = 100
local maxEggs = 30

local eggCount = 0
local fps = 0

--==================================================
-- CHARACTER
--==================================================

local character
local rootPart
local humanoid

local function setupCharacter(char)
    character = char
    rootPart = char:WaitForChild("HumanoidRootPart", 10)
    humanoid = char:WaitForChild("Humanoid", 10)
end

if player.Character then
    setupCharacter(player.Character)
end

player.CharacterAdded:Connect(function(char)
    setupCharacter(char)
end)

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
-- HELPERS
--==================================================

local function getRootPart()
    if rootPart and rootPart.Parent then
        return rootPart
    end

    local char = player.Character

    if char then
        rootPart = char:FindFirstChild("HumanoidRootPart")
    end

    return rootPart
end

local function teleportTo(target)
    local root = getRootPart()

    if not root or not target then
        return false
    end

    local targetPart

    if target:IsA("BasePart") then
        targetPart = target

    elseif target:IsA("Model") then
        targetPart = target.PrimaryPart
            or target:FindFirstChildWhichIsA("BasePart")

    end

    if targetPart then
        root.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
        return true
    end

    return false
end

local function getChild(parent, ...)
    local current = parent

    for _, name in ipairs({...}) do
        if not current then
            return nil
        end

        current = current:FindFirstChild(name)
    end

    return current
end

local function isButtonRed(button)
    if not button then
        return false
    end

    local part = button

    if button:IsA("Model") then
        part = button.PrimaryPart
            or button:FindFirstChildWhichIsA("BasePart")
    end

    if not part or not part:IsA("BasePart") then
        return false
    end

    local color = part.Color

    if part.BrickColor == BrickColor.new("Bright red") then
        return true
    end

    return color.R > 0.7
        and color.G < 0.3
        and color.B < 0.3
end

local function invokeRemote(...)
    if not remoteFunction then
        return false
    end

    local args = {...}

    local success = pcall(function()
        remoteFunction:InvokeServer(unpack(args))
    end)

    return success
end

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaFixMainGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

--==================================================
-- MAIN FRAME
--==================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -210)
MainFrame.Size = UDim2.new(0, 380, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(
        0,
        Color3.fromRGB(18, 18, 26)
    ),

    ColorSequenceKeypoint.new(
        1,
        Color3.fromRGB(8, 8, 12)
    )
})
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

--==================================================
-- TOGGLE ICON
--==================================================

local ToggleIconButton = Instance.new("TextButton")
ToggleIconButton.Name = "ToggleIconButton"
ToggleIconButton.Parent = ScreenGui
ToggleIconButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ToggleIconButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleIconButton.Size = UDim2.new(0, 45, 0, 45)
ToggleIconButton.Font = Enum.Font.GothamBold
ToggleIconButton.Text = "⚡"
ToggleIconButton.TextColor3 = Color3.fromRGB(255, 204, 0)
ToggleIconButton.TextSize = 22
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
-- TITLE
--==================================================

local DashboardTitle = Instance.new("TextLabel")
DashboardTitle.Parent = MainFrame
DashboardTitle.BackgroundTransparency = 1
DashboardTitle.Position = UDim2.new(0.06, 0, 0.03, 0)
DashboardTitle.Size = UDim2.new(0.88, 0, 0, 30)
DashboardTitle.Font = Enum.Font.GothamBold
DashboardTitle.Text = "DELTA HUB // ULTIMATE"
DashboardTitle.TextColor3 = Color3.fromRGB(255, 204, 0)
DashboardTitle.TextSize = 16
DashboardTitle.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- STATS
--==================================================

local StatLabel = Instance.new("TextLabel")
StatLabel.Parent = MainFrame
StatLabel.BackgroundTransparency = 1
StatLabel.Position = UDim2.new(0.06, 0, 0.10, 0)
StatLabel.Size = UDim2.new(0.88, 0, 0, 18)
StatLabel.Font = Enum.Font.GothamMedium
StatLabel.Text = "FPS: 0 | Ping: 0 ms"
StatLabel.TextColor3 = Color3.fromRGB(0, 229, 255)
StatLabel.TextSize = 11
StatLabel.TextXAlignment = Enum.TextXAlignment.Left

-- FIXED:
-- Enum.Font.GothamStatusLabel -> invalid
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.06, 0, 0.15, 0)
StatusLabel.Size = UDim2.new(0.88, 0, 0, 22)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.Text = "Status: Operational"
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- BUTTON CREATOR
--==================================================

local function createButton(posY, text)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Position = UDim2.new(0.06, 0, posY, 0)
    btn.Size = UDim2.new(0.88, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(230, 230, 250)
    btn.TextSize = 12

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    return btn
end

local BtnEggs = createButton(0.23, "Auto Farm Eggs")
local BtnMoney = createButton(0.32, "Auto Collect Money")
local BtnBuy = createButton(0.41, "AI Smart Buy Chicken")
local BtnLucky = createButton(0.50, "Auto Open Lucky Block")
local BtnPull = createButton(0.59, "Pull BuyChicken to Me")

local function toggleState(btn, configKey, name)
    config[configKey] = not config[configKey]

    if config[configKey] then
        btn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
        btn.Text = name .. " [ON]"
    else
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        btn.Text = name .. " [OFF]"
    end
end

--==================================================
-- KEY FRAME
--==================================================

local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = ScreenGui
KeyFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -115)
KeyFrame.Size = UDim2.new(0, 320, 0, 230)
KeyFrame.Active = true
KeyFrame.Draggable = true

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 16)
KeyCorner.Parent = KeyFrame

local KeyGradient = Instance.new("UIGradient")
KeyGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(
        0,
        Color3.fromRGB(24, 24, 32)
    ),

    ColorSequenceKeypoint.new(
        1,
        Color3.fromRGB(12, 12, 16)
    )
})
KeyGradient.Rotation = 45
KeyGradient.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyFrame
KeyTitle.BackgroundTransparency = 1
KeyTitle.Position = UDim2.new(0, 0, 0.08, 0)
KeyTitle.Size = UDim2.new(1, 0, 0, 30)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Text = "SECURE ACCESS"
KeyTitle.TextColor3 = Color3.fromRGB(255, 204, 0)
KeyTitle.TextSize = 20

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Parent = KeyFrame
KeyTextBox.Position = UDim2.new(0.1, 0, 0.32, 0)
KeyTextBox.Size = UDim2.new(0.8, 0, 0, 45)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
KeyTextBox.Font = Enum.Font.Gotham
KeyTextBox.PlaceholderText = "Enter Activation Key..."
KeyTextBox.Text = ""
KeyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTextBox.TextSize = 14

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 10)
KeyBoxCorner.Parent = KeyTextBox

local BtnCheckKey = Instance.new("TextButton")
BtnCheckKey.Parent = KeyFrame
BtnCheckKey.Position = UDim2.new(0.1, 0, 0.58, 0)
BtnCheckKey.Size = UDim2.new(0.8, 0, 0, 42)
BtnCheckKey.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
BtnCheckKey.Font = Enum.Font.GothamBold
BtnCheckKey.Text = "VERIFY KEY"
BtnCheckKey.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnCheckKey.TextSize = 15

local BtnCheckCorner = Instance.new("UICorner")
BtnCheckCorner.CornerRadius = UDim.new(0, 10)
BtnCheckCorner.Parent = BtnCheckKey

local KeyStatus = Instance.new("TextLabel")
KeyStatus.Parent = KeyFrame
KeyStatus.BackgroundTransparency = 1
KeyStatus.Position = UDim2.new(0, 0, 0.82, 0)
KeyStatus.Size = UDim2.new(1, 0, 0, 25)
KeyStatus.Font = Enum.Font.GothamItalic
KeyStatus.Text = "Awaiting authorization..."
KeyStatus.TextColor3 = Color3.fromRGB(140, 140, 160)
KeyStatus.TextSize = 12

--==================================================
-- BUTTON EVENTS
--==================================================

BtnEggs.MouseButton1Click:Connect(function()
    toggleState(BtnEggs, "AutoEggs", "Auto Farm Eggs")
end)

BtnMoney.MouseButton1Click:Connect(function()
    toggleState(BtnMoney, "AutoMoney", "Auto Collect Money")
end)

BtnBuy.MouseButton1Click:Connect(function()
    toggleState(BtnBuy, "AutoBuy", "AI Smart Buy Chicken")
end)

BtnLucky.MouseButton1Click:Connect(function()
    toggleState(BtnLucky, "AutoLucky", "Auto Open Lucky Block")
end)

BtnPull.MouseButton1Click:Connect(function()
    toggleState(BtnPull, "PullBuyButton", "Pull BuyChicken to Me")
end)

--==================================================
-- FPS / PING
--==================================================

task.spawn(function()
    local frames = 0
    local lastTime = os.clock()

    RunService.RenderStepped:Connect(function()
        frames += 1

        local now = os.clock()

        if now - lastTime >= 1 then
            fps = frames
            frames = 0
            lastTime = now

            local ping = 0

            pcall(function()
                ping = math.floor(player:GetNetworkPing() * 1000)
            end)

            StatLabel.Text =
                "FPS: "
                .. tostring(fps)
                .. " | Ping: "
                .. tostring(ping)
                .. " ms"
        end
    end)
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

--==================================================
-- SMALL MOVEMENT ANTI AFK
--==================================================

task.spawn(function()
    while task.wait(120) do
        if config.AntiAFK then
            local root = getRootPart()

            if root then
                pcall(function()
                    root.CFrame =
                        root.CFrame
                        * CFrame.new(0, 0.01, 0)
                end)
            end
        end
    end
end)

--==================================================
-- PULL BUY BUTTON
--==================================================

task.spawn(function()
    while task.wait(0.2) do
        if config.PullBuyButton then
            pcall(function()
                local root = getRootPart()

                if not root then
                    return
                end

                local buyTarget = getChild(
                    workspace,
                    "Plots",
                    "BBBR17k",
                    "Buttons",
                    "BuyChickens"
                )

                if not buyTarget then
                    return
                end

                if buyTarget:IsA("BasePart") then
                    buyTarget.CFrame = root.CFrame

                elseif buyTarget:IsA("Model") then
                    local primary =
                        buyTarget.PrimaryPart
                        or buyTarget:FindFirstChildWhichIsA("BasePart")

                    if primary then
                        primary.CFrame = root.CFrame
                    end

                else
                    local button =
                        buyTarget:FindFirstChild("Button")

                    if button and button:IsA("BasePart") then
                        button.CFrame = root.CFrame
                    end
                end
            end)
        end
    end
end)

--==================================================
-- AUTO LUCKY
--==================================================

task.spawn(function()
    while task.wait(0.3) do
        if config.AutoLucky then
            invokeRemote("Open Lucky Block")
        end
    end
end)

--==================================================
-- AUTO EGGS
--==================================================

task.spawn(function()
    while task.wait(0.5) do
        if not config.AutoEggs then
            continue
        end

        StatusLabel.Text = "Status: Farming Eggs"

        local eggsFolder =
            workspace:FindFirstChild("Eggs")

        if not eggsFolder then
            continue
        end

        local eggs = eggsFolder:GetChildren()

        for _, egg in ipairs(eggs) do
            if not config.AutoEggs then
                break
            end

            local target

            if egg:IsA("BasePart") then
                target = egg

            elseif egg:IsA("Model") then
                target =
                    egg.PrimaryPart
                    or egg:FindFirstChildWhichIsA("BasePart")
            end

            if target then
                teleportTo(target)

                eggCount += 1

                task.wait(0.35)

                if eggCount >= maxEggs then
                    StatusLabel.Text =
                        "Status: Depositing Eggs"

                    local deposit =
                        getChild(
                            workspace,
                            "Plots",
                            "BBBR17k",
                            "Buttons",
                            "DepositEggs",
                            "Hitbox"
                        )

                    if deposit then
                        teleportTo(deposit)
                    end

                    task.wait(1.2)

                    eggCount = 0
                end
            end
        end
    end
end)

--==================================================
-- AUTO MONEY
--==================================================

task.spawn(function()
    while task.wait(1) do
        if config.AutoMoney then
            task.wait(60)

            if config.AutoMoney then
                StatusLabel.Text =
                    "Status: Collecting Money"

                local collect =
                    getChild(
                        workspace,
                        "Plots",
                        "BBBR17k",
                        "Buttons",
                        "CollectMoney",
                        "Button"
                    )

                if collect then
                    teleportTo(collect)
                    task.wait(1.5)
                end
            end
        end
    end
end)

--==================================================
-- AUTO BUY
--==================================================

task.spawn(function()
    while task.wait(1) do
        if config.AutoBuy and moneyValue then
            pcall(function()
                local buyButton =
                    getChild(
                        workspace,
                        "Plots",
                        "BBBR17k",
                        "Buttons",
                        "BuyChickens"
                    )

                if not buyButton then
                    StatusLabel.Text =
                        "Status: Buy Button Missing"
                    return
                end

                if isButtonRed(buyButton) then
                    StatusLabel.Text =
                        "Status: Chicken Button RED"
                    return
                end

                while
                    config.AutoBuy
                    and moneyValue.Value >= chickenCost1
                    and not isButtonRed(buyButton)
                do
                    StatusLabel.Text =
                        "Status: Upgrading Chicken"

                    teleportTo(buyButton)

                    task.wait(0.3)

                    if moneyValue.Value >= chickenCost5 then
                        invokeRemote("Buy Chickens", 5)
                    else
                        invokeRemote("Buy Chickens", 1)
                    end

                    task.wait(0.5)
                end
            end)
        end
    end
end)

--==================================================
-- KEY VERIFICATION
--==================================================

BtnCheckKey.MouseButton1Click:Connect(function()
    local enteredKey = KeyTextBox.Text

    if enteredKey == correctKey then
        KeyStatus.TextColor3 =
            Color3.fromRGB(0, 255, 0)

        KeyStatus.Text =
            "Authorized! Launching..."

        task.wait(0.5)

        KeyFrame:Destroy()

        MainFrame.Visible = true
        ToggleIconButton.Visible = true
    else
        KeyStatus.TextColor3 =
            Color3.fromRGB(255, 59, 48)

        KeyStatus.Text =
            "Invalid Key, Try Again."

        KeyTextBox.Text = ""
    end
end)
