--// DELTA HUB // ULTIMATE
--// Fixed / Stabilized Version

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
if not player then
    return
end

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    AutoEggs = false,
    AutoMoney = false,
    AutoBuy = false,
    AutoLucky = false,
    PullBuyButton = false,
    AntiAFK = true,
}

local CORRECT_KEY = "GGGR@23LO"

local CHICKEN_COST_1 = 20
local CHICKEN_COST_5 = 100
local MAX_EGGS = 30

local eggCount = 0
local fps = 0
local ping = 0

--==================================================
-- CHARACTER
--==================================================

local character
local humanoid
local rootPart

local function updateCharacter(char)
    character = char
    humanoid = char:WaitForChild("Humanoid", 10)
    rootPart = char:WaitForChild("HumanoidRootPart", 10)
end

if player.Character then
    updateCharacter(player.Character)
end

player.CharacterAdded:Connect(function(char)
    updateCharacter(char)
end)

--==================================================
-- SAFE HELPERS
--==================================================

local function safeFind(parent, ...)
    if not parent then
        return nil
    end

    local current = parent

    for _, name in ipairs({...}) do
        current = current:FindFirstChild(name)

        if not current then
            return nil
        end
    end

    return current
end

local function getRoot()
    if rootPart and rootPart.Parent then
        return rootPart
    end

    if character and character.Parent then
        rootPart = character:FindFirstChild("HumanoidRootPart")
    end

    return rootPart
end

local function getTargetPart(object)
    if not object then
        return nil
    end

    if object:IsA("BasePart") then
        return object
    end

    if object:IsA("Model") then
        if object.PrimaryPart then
            return object.PrimaryPart
        end

        local part = object:FindFirstChildWhichIsA("BasePart", true)
        return part
    end

    return nil
end

local function teleportTo(target)
    local root = getRoot()
    local part = getTargetPart(target)

    if not root or not part then
        return false
    end

    return pcall(function()
        root.CFrame = part.CFrame + Vector3.new(0, 3, 0)
    end)
end

local function isButtonRed(button)
    local part = getTargetPart(button)

    if not part then
        return false
    end

    local color = part.Color

    return (
        part.BrickColor == BrickColor.new("Bright red")
        or (
            color.R > 0.7
            and color.G < 0.3
            and color.B < 0.3
        )
    )
end

--==================================================
-- LEADERSTATS
--==================================================

local leaderstats = player:FindFirstChild("leaderstats")
local moneyValue

if leaderstats then
    moneyValue =
        leaderstats:FindFirstChild("Money")
        or leaderstats:FindFirstChild("Cash")
        or leaderstats:FindFirstChild("Coins")
end

task.spawn(function()
    leaderstats = player:WaitForChild("leaderstats", 10)

    if leaderstats then
        moneyValue =
            leaderstats:FindFirstChild("Money")
            or leaderstats:FindFirstChild("Cash")
            or leaderstats:FindFirstChild("Coins")
    end
end)

--==================================================
-- REMOTE
--==================================================

local remoteFunction

task.spawn(function()
    local paper = ReplicatedStorage:WaitForChild("Paper", 10)

    if not paper then
        return
    end

    local remotes = paper:WaitForChild("Remotes", 10)

    if not remotes then
        return
    end

    remoteFunction = remotes:WaitForChild("__remotefunction", 10)
end)

local function invokeRemote(...)
    if not remoteFunction then
        return false
    end

    local success = pcall(function(...)
        remoteFunction:InvokeServer(...)
    end, ...)

    return success
end

--==================================================
-- PLOT HELPERS
--==================================================

local function getPlot()
    local plots = workspace:FindFirstChild("Plots")

    if not plots then
        return nil
    end

    return plots:FindFirstChild("BBBR17k")
end

local function getButton(name)
    local plot = getPlot()

    if not plot then
        return nil
    end

    local buttons = plot:FindFirstChild("Buttons")

    if not buttons then
        return nil
    end

    return buttons:FindFirstChild(name)
end

--==================================================
-- GUI
--==================================================

local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("DeltaProUltimateGUI")

if oldGui then
    oldGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaProUltimateGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.Parent = playerGui

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
KeyFrame.Visible = true
KeyFrame.ZIndex = 10

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 16)
KeyCorner.Parent = KeyFrame

local KeyGradient = Instance.new("UIGradient")
KeyGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 32)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 16))
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
KeyTitle.ZIndex = 11

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
KeyTextBox.ClearTextOnFocus = false
KeyTextBox.ZIndex = 11

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
BtnCheckKey.ZIndex = 11

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
KeyStatus.ZIndex = 11

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
MainFrame.Visible = false
MainFrame.ZIndex = 5

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 26)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 12))
})
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

--==================================================
-- DRAG SYSTEM
--==================================================

local function makeDraggable(frame, dragObject)
    local UserInputService = game:GetService("UserInputService")

    local dragging = false
    local dragStart
    local startPosition

    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)
end

makeDraggable(KeyFrame, KeyFrame)
makeDraggable(MainFrame, MainFrame)

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
ToggleIconButton.Visible = false
ToggleIconButton.ZIndex = 20

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 12)
IconCorner.Parent = ToggleIconButton

makeDraggable(ToggleIconButton, ToggleIconButton)

ToggleIconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--==================================================
-- TITLE / STATUS
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

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.06, 0, 0.15, 0)
StatusLabel.Size = UDim2.new(0.88, 0, 0, 22)
StatusLabel.Font = Enum.Font.Gotham
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
    btn.AutoButtonColor = true

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

local BtnAFK = Instance.new("TextButton")
BtnAFK.Parent = MainFrame
BtnAFK.Position = UDim2.new(0.06, 0, 0.70, 0)
BtnAFK.Size = UDim2.new(0.88, 0, 0, 36)
BtnAFK.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
BtnAFK.Font = Enum.Font.GothamBold
BtnAFK.Text = "Anti-AFK Bypass [ON]"
BtnAFK.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnAFK.TextSize = 12

local AFKCorner = Instance.new("UICorner")
AFKCorner.CornerRadius = UDim.new(0, 8)
AFKCorner.Parent = BtnAFK

--==================================================
-- TOGGLE
--==================================================

local function toggleState(button, configKey, name)
    CONFIG[configKey] = not CONFIG[configKey]

    if CONFIG[configKey] then
        button.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
        button.Text = name .. " [ON]"
    else
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        button.Text = name .. " [OFF]"
    end
end

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

BtnAFK.MouseButton1Click:Connect(function()
    CONFIG.AntiAFK = not CONFIG.AntiAFK

    if CONFIG.AntiAFK then
        BtnAFK.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
        BtnAFK.Text = "Anti-AFK Bypass [ON]"
    else
        BtnAFK.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
        BtnAFK.Text = "Anti-AFK Bypass [OFF]"
    end
end)

--==================================================
-- FPS / PING
--==================================================

task.spawn(function()
    local frames = 0
    local last = os.clock()

    RunService.RenderStepped:Connect(function()
        frames += 1

        local now = os.clock()

        if now - last >= 1 then
            fps = frames
            frames = 0
            last = now

            pcall(function()
                ping = math.floor(player:GetNetworkPing() * 1000)
            end)

            if StatLabel and StatLabel.Parent then
                StatLabel.Text =
                    "FPS: "
                    .. tostring(fps)
                    .. " | Ping: "
                    .. tostring(ping)
                    .. " ms"
            end
        end
    end)
end)

--==================================================
-- ANTI AFK
--==================================================

player.Idled:Connect(function()
    if not CONFIG.AntiAFK then
        return
    end

    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end)

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        task.wait(120)

        if CONFIG.AntiAFK then
            local root = getRoot()

            if root then
                pcall(function()
                    root.CFrame = root.CFrame * CFrame.new(0, 0.01, 0)
                end)
            end
        end
    end
end)

--==================================================
-- PULL BUY BUTTON
--==================================================

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        task.wait(0.2)

        if CONFIG.PullBuyButton then
            pcall(function()
                local buyTarget = getButton("BuyChickens")
                local root = getRoot()

                if not buyTarget or not root then
                    return
                end

                local targetPart = getTargetPart(buyTarget)

                if targetPart then
                    targetPart.CFrame = root.CFrame
                end
            end)
        end
    end
end)

--==================================================
-- AUTO LUCKY
--==================================================

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        task.wait(0.3)

        if CONFIG.AutoLucky then
            invokeRemote("Open Lucky Block")
        end
    end
end)

--==================================================
-- AUTO EGGS
--==================================================

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        task.wait(0.5)

        if not CONFIG.AutoEggs then
            continue
        end

        StatusLabel.Text = "Status: Farming Eggs"

        local eggsFolder = workspace:FindFirstChild("Eggs")

        if not eggsFolder then
            continue
        end

        local eggs = eggsFolder:GetChildren()

        for _, egg in ipairs(eggs) do
            if not CONFIG.AutoEggs then
                break
            end

            local target = getTargetPart(egg)

            if target then
                teleportTo(target)

                eggCount += 1

                task.wait(0.35)

                if eggCount >= MAX_EGGS then
                    StatusLabel.Text = "Status: Depositing Eggs"

                    local deposit = getButton("DepositEggs")

                    if deposit then
                        local hitbox = deposit:FindFirstChild("Hitbox")

                        if hitbox then
                            teleportTo(hitbox)
                        else
                            teleportTo(deposit)
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
-- AUTO MONEY
--==================================================

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        task.wait(1)

        if CONFIG.AutoMoney then
            StatusLabel.Text = "Status: Collecting Money"

            local collectButton = getButton("CollectMoney")

            if collectButton then
                local button = collectButton:FindFirstChild("Button")

                if button then
                    teleportTo(button)
                else
                    teleportTo(collectButton)
                end

                task.wait(1.5)
            end
        end
    end
end)

--==================================================
-- AUTO BUY CHICKEN
--==================================================

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        task.wait(0.5)

        if not CONFIG.AutoBuy then
            continue
        end

        if not moneyValue then
            continue
        end

        pcall(function()
            local buyButton = getButton("BuyChickens")

            if not buyButton then
                StatusLabel.Text = "Status: Buy Button Not Found"
                return
            end

            if isButtonRed(buyButton) then
                StatusLabel.Text = "Status: Chicken Button RED"
                return
            end

            while CONFIG.AutoBuy
                and moneyValue
                and moneyValue.Parent
                and moneyValue.Value >= CHICKEN_COST_1
                and not isButtonRed(buyButton) do

                StatusLabel.Text = "Status: Upgrading Chicken"

                teleportTo(buyButton)

                task.wait(0.3)

                if moneyValue.Value >= CHICKEN_COST_5 then
                    invokeRemote("Buy Chickens", 5)
                else
                    invokeRemote("Buy Chickens", 1)
                end

                task.wait(0.5)

                buyButton = getButton("BuyChickens")

                if not buyButton then
                    break
                end
            end
        end)
    end
end)

--==================================================
-- KEEP GUI ALIVE
--==================================================

task.spawn(function()
    while true do
        task.wait(2)

        if not ScreenGui or not ScreenGui.Parent then
            break
        end

        pcall(function()
            ScreenGui.Enabled = true
            ScreenGui.ResetOnSpawn = false
            ScreenGui.DisplayOrder = 999999
        end)
    end
end)

--==================================================
-- KEY SYSTEM
--==================================================

local authorized = false

BtnCheckKey.MouseButton1Click:Connect(function()
    if authorized then
        return
    end

    local enteredKey = tostring(KeyTextBox.Text or "")

    if enteredKey == CORRECT_KEY then
        authorized = true

        KeyStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
        KeyStatus.Text = "Authorized! Launching..."

        task.wait(0.8)

        if KeyFrame and KeyFrame.Parent then
            KeyFrame.Visible = false
        end

        MainFrame.Visible = true
        ToggleIconButton.Visible = true

        StatusLabel.Text = "Status: Operational"
    else
        KeyStatus.TextColor3 = Color3.fromRGB(255, 59, 48)
        KeyStatus.Text = "Invalid Key, Try Again."

        KeyTextBox.Text = ""

        task.delay(2, function()
            if KeyStatus and KeyStatus.Parent and not authorized then
                KeyStatus.TextColor3 = Color3.fromRGB(140, 140, 160)
                KeyStatus.Text = "Awaiting authorization..."
            end
        end)
    end
end)

--==================================================
-- INITIAL STATE
--==================================================

MainFrame.Visible = false
ToggleIconButton.Visible = false
KeyFrame.Visible = true

print("[Delta Hub] Loaded successfully.")
