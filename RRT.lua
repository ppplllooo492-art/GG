--// Delta Chicken Farmer
--// Fixed / Reformatted Version

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    rootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

--// Leaderstats
local leaderstats = player:WaitForChild("leaderstats", 5)

local moneyValue = nil

if leaderstats then
    moneyValue =
        leaderstats:FindFirstChild("Money")
        or leaderstats:FindFirstChild("Cash")
        or leaderstats:FindFirstChild("Coins")
end

--// Remote
local remoteFunction

pcall(function()
    remoteFunction =
        ReplicatedStorage
            :WaitForChild("Paper")
            :WaitForChild("Remotes")
            :WaitForChild("__remotefunction")
end)

--// Key
local correctKey = "GGGR@23LO"

--// Config
local config = {
    AutoEggs = false,
    AutoMoney = false,
    AutoBuy = false,
    AutoLucky = false,
    AutoBuy5 = false,
    AntiAFK = true
}

--// Settings
local chickenCost1 = 20
local chickenCost5 = 100
local maxEggs = 30

local eggCount = 0
local fps = 0
local ping = 0

--==================================================
-- Utility Functions
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
    if not targetPart then
        return false
    end

    local root = getRootPart()

    if targetPart:IsA("BasePart") then
        root.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
        return true
    end

    if targetPart:IsA("Model") then
        local primary = targetPart.PrimaryPart

        if primary then
            root.CFrame = primary.CFrame + Vector3.new(0, 3, 0)
            return true
        end

        local part = targetPart:FindFirstChildWhichIsA("BasePart", true)

        if part then
            root.CFrame = part.CFrame + Vector3.new(0, 3, 0)
            return true
        end
    end

    return false
end

local function findBasePart(object)
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
    end

    return object:FindFirstChildWhichIsA("BasePart", true)
end

local function isButtonRed(buttonObject)
    local buttonPart = findBasePart(buttonObject)

    if not buttonPart then
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

local function invokeRemote(...)
    if not remoteFunction then
        return false
    end

    local success = pcall(function()
        remoteFunction:InvokeServer(...)
    end)

    return success
end

local function getPlot()
    local plots = workspace:FindFirstChild("Plots")

    if not plots then
        return nil
    end

    return plots:FindFirstChild("BBBR17k")
end

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaUltimateFarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

--==================================================
-- Key Frame
--==================================================

local KeyFrame = Instance.new("Frame")
local KeyCorner = Instance.new("UICorner")
local KeyTitle = Instance.new("TextLabel")
local KeyTextBox = Instance.new("TextBox")
local KeyTextBoxCorner = Instance.new("UICorner")
local BtnCheckKey = Instance.new("TextButton")
local BtnCheckCorner = Instance.new("UICorner")
local KeyStatus = Instance.new("TextLabel")

KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = ScreenGui
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
KeyFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
KeyFrame.Size = UDim2.new(0, 320, 0, 220)
KeyFrame.Active = true
KeyFrame.Draggable = true

KeyCorner.CornerRadius = UDim.new(0, 14)
KeyCorner.Parent = KeyFrame

KeyTitle.Parent = KeyFrame
KeyTitle.BackgroundTransparency = 1
KeyTitle.Position = UDim2.new(0, 0, 0.08, 0)
KeyTitle.Size = UDim2.new(1, 0, 0, 25)
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.Text = "DELTA KEY SYSTEM"
KeyTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
KeyTitle.TextSize = 20

KeyTextBox.Parent = KeyFrame
KeyTextBox.Position = UDim2.new(0.1, 0, 0.32, 0)
KeyTextBox.Size = UDim2.new(0.8, 0, 0, 40)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
KeyTextBox.Font = Enum.Font.SourceSans
KeyTextBox.PlaceholderText = "Paste Your Key Here..."
KeyTextBox.Text = ""
KeyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTextBox.TextSize = 15

KeyTextBoxCorner.CornerRadius = UDim.new(0, 8)
KeyTextBoxCorner.Parent = KeyTextBox

BtnCheckKey.Parent = KeyFrame
BtnCheckKey.Position = UDim2.new(0.1, 0, 0.58, 0)
BtnCheckKey.Size = UDim2.new(0.8, 0, 0, 40)
BtnCheckKey.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
BtnCheckKey.Font = Enum.Font.SourceSansBold
BtnCheckKey.Text = "Check Key"
BtnCheckKey.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnCheckKey.TextSize = 16

BtnCheckCorner.CornerRadius = UDim.new(0, 8)
BtnCheckCorner.Parent = BtnCheckKey

KeyStatus.Parent = KeyFrame
KeyStatus.BackgroundTransparency = 1
KeyStatus.Position = UDim2.new(0, 0, 0.82, 0)
KeyStatus.Size = UDim2.new(1, 0, 0, 20)
KeyStatus.Font = Enum.Font.SourceSansItalic
KeyStatus.Text = "Please enter valid key to proceed"
KeyStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
KeyStatus.TextSize = 13

--==================================================
-- Main Frame
--==================================================

local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.3, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 360, 0, 410)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false

UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

--==================================================
-- Toggle Icon
--==================================================

local ToggleIconButton = Instance.new("TextButton")
local IconCorner = Instance.new("UICorner")

ToggleIconButton.Name = "ToggleIconButton"
ToggleIconButton.Parent = ScreenGui
ToggleIconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleIconButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleIconButton.Size = UDim2.new(0, 45, 0, 45)
ToggleIconButton.Font = Enum.Font.SourceSansBold
ToggleIconButton.Text = "⚙️"
ToggleIconButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleIconButton.TextSize = 24
ToggleIconButton.Active = true
ToggleIconButton.Draggable = true
ToggleIconButton.Visible = false

IconCorner.CornerRadius = UDim.new(0, 10)
IconCorner.Parent = ToggleIconButton

ToggleIconButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

--==================================================
-- Dashboard
--==================================================

local DashboardTitle = Instance.new("TextLabel")

DashboardTitle.Parent = MainFrame
DashboardTitle.BackgroundTransparency = 1
DashboardTitle.Position = UDim2.new(0.05, 0, 0.02, 0)
DashboardTitle.Size = UDim2.new(0.9, 0, 0, 28)
DashboardTitle.Font = Enum.Font.SourceSansBold
DashboardTitle.Text = "DELTA CHICKEN FARMER - COMPACT"
DashboardTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
DashboardTitle.TextSize = 18
DashboardTitle.TextXAlignment = Enum.TextXAlignment.Left

local StatLabel = Instance.new("TextLabel")

StatLabel.Parent = MainFrame
StatLabel.BackgroundTransparency = 1
StatLabel.Position = UDim2.new(0.05, 0, 0.09, 0)
StatLabel.Size = UDim2.new(0.9, 0, 0, 18)
StatLabel.Font = Enum.Font.SourceSansItalic
StatLabel.Text = "FPS: Checking... | Ping: Checking..."
StatLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
StatLabel.TextSize = 12
StatLabel.TextXAlignment = Enum.TextXAlignment.Left

local StatusLabel = Instance.new("TextLabel")

StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.05, 0, 0.14, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 22)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 13
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- Button Creator
--==================================================

local function createButton(posY, text)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")

    btn.Parent = MainFrame
    btn.Position = UDim2.new(0.05, 0, posY, 0)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13

    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    return btn
end

local BtnEggs = createButton(0.21, "Auto Farm Eggs")
local BtnMoney = createButton(0.31, "Auto Collect Money")
local BtnBuy = createButton(0.41, "AI Smart Buy Chicken")
local BtnLucky = createButton(0.51, "Auto Open Lucky Block")
local BtnBuy5 = createButton(0.61, "Auto Wait Buy5 (30s Loop)")

--==================================================
-- Anti AFK Button
--==================================================

local BtnAFK = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")

BtnAFK.Parent = MainFrame
BtnAFK.Position = UDim2.new(0.05, 0, 0.73, 0)
BtnAFK.Size = UDim2.new(0.9, 0, 0, 35)
BtnAFK.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
BtnAFK.Font = Enum.Font.SourceSansBold
BtnAFK.Text = "100% Anti-AFK Bypass: ACTIVE"
BtnAFK.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnAFK.TextSize = 14

UICorner_4.CornerRadius = UDim.new(0, 6)
UICorner_4.Parent = BtnAFK

--==================================================
-- Toggle State
--==================================================

local function toggleState(btn, configKey, name)
    config[configKey] = not config[configKey]

    if config[configKey] then
        btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        btn.Text = name .. ": ON"
    else
        btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        btn.Text = name .. ": OFF"
    end
end

--==================================================
-- Main Farm Scripts
--==================================================

local function startMainFarmScripts()

    MainFrame.Visible = true
    ToggleIconButton.Visible = true

    -- Button Connections

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

    BtnBuy5.MouseButton1Click:Connect(function()
        toggleState(BtnBuy5, "AutoBuy5", "Auto Wait Buy5 (30s Loop)")
    end)

    --==================================================
    -- FPS / Ping
    --==================================================

    task.spawn(function()
        local lastTime = os.clock()
        local frameCount = 0

        while ScreenGui.Parent do
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
                    "FPS: "
                    .. tostring(fps)
                    .. " | Ping: "
                    .. tostring(ping)
                    .. " ms"

                if ping > 250 then
                    StatLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                elseif ping > 100 then
                    StatLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
                else
                    StatLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
                end
            end

            task.wait()
        end
    end)

    --==================================================
    -- Anti AFK
    --==================================================

    task.spawn(function()

        player.Idled:Connect(function()
            if config.AntiAFK then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0, 0))
                end)
            end
        end)

        while ScreenGui.Parent do
            task.wait(120)

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
    -- Auto Lucky Block
    --==================================================

    task.spawn(function()
        while ScreenGui.Parent do
            task.wait(0.5)

            if config.AutoLucky then
                invokeRemote("Open Lucky Block")
            end
        end
    end)

    --==================================================
    -- Auto Buy5
    --==================================================

    task.spawn(function()
        while ScreenGui.Parent do
            task.wait(0.5)

            if config.AutoBuy5 then

                StatusLabel.Text =
                    "Status: Teleporting to Buy5..."

                local plot = getPlot()

                if plot then
                    local buttons =
                        plot:FindFirstChild("Buttons")

                    if buttons then
                        local buyChickens =
                            buttons:FindFirstChild("BuyChickens")

                        if buyChickens then
                            local buy5 =
                                buyChickens:FindFirstChild("Buy5")

                            if buy5 then
                                local button =
                                    buy5:FindFirstChild("Button")

                                if button then
                                    teleportTo(button)
                                end
                            end
                        end
                    end
                end

                StatusLabel.Text =
                    "Status: Standing at Buy5 (30s)"

                local timer = 30

                while timer > 0 and config.AutoBuy5 do
                    task.wait(1)
                    timer -= 1
                end
            end
        end
    end)

    --==================================================
    -- Auto Eggs
    --==================================================

    task.spawn(function()
        while ScreenGui.Parent do
            task.wait(0.5)

            if config.AutoEggs then

                StatusLabel.Text =
                    "Status: Farming Eggs"

                local eggsFolder =
                    workspace:FindFirstChild("Eggs")

                if eggsFolder then

                    local eggs =
                        eggsFolder:GetChildren()

                    if #eggs > 0 then

                        for _, egg in ipairs(eggs) do

                            if not config.AutoEggs then
                                break
                            end

                            local target = egg

                            if egg:IsA("Model") then
                                target =
                                    egg.PrimaryPart
                                    or egg:FindFirstChildWhichIsA(
                                        "BasePart",
                                        true
                                    )
                            end

                            if target and target:IsA("BasePart") then

                                teleportTo(target)

                                eggCount += 1

                                task.wait(0.35)

                                if eggCount >= maxEggs then

                                    StatusLabel.Text =
                                        "Status: Depositing Eggs"

                                    local plot = getPlot()

                                    if plot then
                                        local buttons =
                                            plot:FindFirstChild("Buttons")

                                        if buttons then
                                            local deposit =
                                                buttons:FindFirstChild(
                                                    "DepositEggs"
                                                )

                                            if deposit then
                                                local hitbox =
                                                    deposit:FindFirstChild(
                                                        "Hitbox"
                                                    )

                                                if hitbox then
                                                    teleportTo(hitbox)
                                                end
                                            end
                                        end
                                    end

                                    task.wait(1.2)

                                    eggCount = 0
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    --==================================================
    -- Auto Money
    --==================================================

    task.spawn(function()
        while ScreenGui.Parent do

            task.wait(1)

            if config.AutoMoney then

                task.wait(60)

                if config.AutoMoney then

                    StatusLabel.Text =
                        "Status: Collecting Money"

                    local plot = getPlot()

                    if plot then

                        local buttons =
                            plot:FindFirstChild("Buttons")

                        if buttons then

                            local collect =
                                buttons:FindFirstChild("CollectMoney")

                            if collect then

                                local button =
                                    collect:FindFirstChild("Button")

                                if button then
                                    teleportTo(button)
                                end
                            end
                        end
                    end

                    task.wait(1.5)
                end
            end
        end
    end)

    --==================================================
    -- Auto Buy Chicken
    --==================================================

    task.spawn(function()

        while ScreenGui.Parent do

            task.wait(1)

            if config.AutoBuy and moneyValue then

                pcall(function()

                    local plot = getPlot()

                    if not plot then
                        return
                    end

                    local buttons =
                        plot:FindFirstChild("Buttons")

                    if not buttons then
                        return
                    end

                    local buyButton =
                        buttons:FindFirstChild("BuyChickens")

                    if not buyButton then
                        return
                    end

                    local red =
                        isButtonRed(buyButton)

                    if red then

                        StatusLabel.Text =
                            "Status: Chicken Button RED"

                        return
                    end

                    if moneyValue.Value < chickenCost1 then

                        StatusLabel.Text =
                            "Status: Not Enough Money"

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
                            invokeRemote(
                                "Buy Chickens",
                                5
                            )
                        else
                            invokeRemote(
                                "Buy Chickens",
                                1
                            )
                        end

                        task.wait(0.5)
                    end
                end)
            end
        end
    end)
end

--==================================================
-- Key Verification
--==================================================

BtnCheckKey.MouseButton1Click:Connect(function()

    if KeyTextBox.Text == correctKey then

        KeyStatus.TextColor3 =
            Color3.fromRGB(0, 255, 0)

        KeyStatus.Text =
            "Key Correct! Loading..."

        task.wait(1)

        KeyFrame:Destroy()

        startMainFarmScripts()

    else

        KeyStatus.TextColor3 =
            Color3.fromRGB(255, 50, 50)

        KeyStatus.Text =
            "Invalid Key! Try again."

        KeyTextBox.Text = ""
    end
end)
