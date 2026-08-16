--// DELTA CHICKEN HUB - FIXED VERSION

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

--==================================================
-- CHARACTER
--==================================================

local character
local rootPart

local function updateCharacter(char)
    character = char
    rootPart = char:WaitForChild("HumanoidRootPart", 10)
end

if player.Character then
    updateCharacter(player.Character)
end

player.CharacterAdded:Connect(function(char)
    updateCharacter(char)
end)

--==================================================
-- MONEY
--==================================================

local leaderstats = player:WaitForChild("leaderstats", 10)

local moneyValue

local function findMoney()
    if not leaderstats then
        return nil
    end

    return leaderstats:FindFirstChild("Money")
        or leaderstats:FindFirstChild("Cash")
        or leaderstats:FindFirstChild("Coins")
end

moneyValue = findMoney()

if not moneyValue and leaderstats then
    leaderstats.ChildAdded:Connect(function(child)
        if child.Name == "Money"
            or child.Name == "Cash"
            or child.Name == "Coins" then

            moneyValue = child
        end
    end)
end

--==================================================
-- REMOTE FUNCTION
--==================================================

local remoteFunction

local function findRemote()
    local paper = ReplicatedStorage:FindFirstChild("Paper")

    if not paper then
        return nil
    end

    local remotes = paper:FindFirstChild("Remotes")

    if not remotes then
        return nil
    end

    local remote = remotes:FindFirstChild("__remotefunction")

    if remote and remote:IsA("RemoteFunction") then
        return remote
    end

    return nil
end

remoteFunction = findRemote()

--==================================================
-- CONFIG
--==================================================

local config = {
    AutoEggs = false,
    AutoMoney = false,
    AutoBuy = false
}

local chickenCost1 = 20
local chickenCost5 = 100

local maxEggs = 30
local eggCount = 0

--==================================================
-- TELEPORT
--==================================================

local function teleportTo(target)
    if not rootPart or not rootPart.Parent then
        return false
    end

    if not target then
        return false
    end

    local targetPart

    if target:IsA("BasePart") then
        targetPart = target

    elseif target:IsA("Model") then
        targetPart = target.PrimaryPart
    end

    if not targetPart then
        return false
    end

    rootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)

    return true
end

--==================================================
-- SAFE FIND
--==================================================

local function getObject(...)
    local current = workspace

    for _, name in ipairs({...}) do
        current = current:FindFirstChild(name)

        if not current then
            return nil
        end
    end

    return current
end

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaFarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 310)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "DELTA CHICKEN HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

--==================================================
-- STATUS
--==================================================

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0.05, 0, 0.17, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Status: Idle / Ready"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
StatusLabel.TextSize = 14

--==================================================
-- BUTTON CREATOR
--==================================================

local function createButton(name, text, position, textSize)
    local button = Instance.new("TextButton")

    button.Name = name
    button.Parent = MainFrame
    button.Position = position
    button.Size = UDim2.new(0.84, 0, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    button.Font = Enum.Font.SourceSansBold
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = textSize or 15
    button.AutoButtonColor = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    return button
end

local BtnEggs = createButton(
    "BtnEggs",
    "Auto Eggs: OFF",
    UDim2.new(0.08, 0, 0.32, 0),
    15
)

local BtnMoney = createButton(
    "BtnMoney",
    "Auto Collect Money: OFF",
    UDim2.new(0.08, 0, 0.52, 0),
    14
)

local BtnBuy = createButton(
    "BtnBuy",
    "Auto Buy Chicken (30s): OFF",
    UDim2.new(0.08, 0, 0.72, 0),
    13
)

--==================================================
-- BUTTON UPDATE
--==================================================

local function updateButton(button, enabled, onText, offText)
    button.BackgroundColor3 = enabled
        and Color3.fromRGB(50, 180, 50)
        or Color3.fromRGB(180, 50, 50)

    button.Text = enabled and onText or offText
end

--==================================================
-- BUTTON EVENTS
--==================================================

BtnEggs.MouseButton1Click:Connect(function()
    config.AutoEggs = not config.AutoEggs

    updateButton(
        BtnEggs,
        config.AutoEggs,
        "Auto Eggs: ON",
        "Auto Eggs: OFF"
    )
end)

BtnMoney.MouseButton1Click:Connect(function()
    config.AutoMoney = not config.AutoMoney

    updateButton(
        BtnMoney,
        config.AutoMoney,
        "Auto Collect Money: ON",
        "Auto Collect Money: OFF"
    )
end)

BtnBuy.MouseButton1Click:Connect(function()
    config.AutoBuy = not config.AutoBuy

    updateButton(
        BtnBuy,
        config.AutoBuy,
        "Auto Buy Chicken (30s): ON",
        "Auto Buy Chicken (30s): OFF"
    )
end)

--==================================================
-- AUTO EGGS
--==================================================

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(0.5)

        if config.AutoEggs then

            StatusLabel.Text = "Status: Farming Eggs..."

            local eggsFolder = workspace:FindFirstChild("Eggs")

            if eggsFolder then

                for _, egg in ipairs(eggsFolder:GetChildren()) do

                    if not config.AutoEggs then
                        break
                    end

                    local target

                    if egg:IsA("BasePart") then
                        target = egg

                    elseif egg:IsA("Model") then
                        target = egg.PrimaryPart
                    end

                    if target and target:IsA("BasePart") then

                        if teleportTo(target) then

                            task.wait(0.35)

                            eggCount += 1

                            if eggCount >= maxEggs then

                                StatusLabel.Text =
                                    "Status: Depositing Eggs..."

                                local deposit =
                                    getObject(
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
            end
        end
    end
end)

--==================================================
-- AUTO MONEY
--==================================================

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(1)

        if config.AutoMoney then

            StatusLabel.Text =
                "Status: Waiting for collection..."

            -- รอทีละ 1 วินาที เพื่อให้กด OFF ได้ทันที
            for i = 1, 60 do

                if not config.AutoMoney then
                    break
                end

                task.wait(1)
            end

            if config.AutoMoney then

                StatusLabel.Text =
                    "Status: Collecting Money!"

                local collectButton =
                    getObject(
                        "Plots",
                        "BBBR17k",
                        "Buttons",
                        "CollectMoney",
                        "Button"
                    )

                if collectButton then
                    teleportTo(collectButton)
                else
                    StatusLabel.Text =
                        "Status: Collect button not found"
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

    while ScreenGui.Parent do

        task.wait(30)

        if config.AutoBuy then

            StatusLabel.Text =
                "Status: Checking & Buying Chickens..."

            -- หาเงินใหม่ทุกครั้ง
            if not moneyValue or not moneyValue.Parent then
                moneyValue = findMoney()
            end

            -- หา RemoteFunction ใหม่ถ้าตัวเดิมหาย
            if not remoteFunction or not remoteFunction.Parent then
                remoteFunction = findRemote()
            end

            if not moneyValue then

                StatusLabel.Text =
                    "Status: Money value not found"

            elseif not remoteFunction then

                StatusLabel.Text =
                    "Status: RemoteFunction not found"

            else

                local success, result = pcall(function()

                    local money = tonumber(moneyValue.Value) or 0

                    -- ซื้อ 5 ตัวก่อน
                    if money >= chickenCost5 then

                        return remoteFunction:InvokeServer(
                            "Buy Chickens",
                            5
                        )

                    -- ถ้าเงินไม่พอ 5 ตัว ให้ซื้อ 1 ตัว
                    elseif money >= chickenCost1 then

                        return remoteFunction:InvokeServer(
                            "Buy Chickens",
                            1
                        )

                    end

                    return nil
                end)

                if success then
                    StatusLabel.Text =
                        "Status: Chicken purchase checked"
                else
                    StatusLabel.Text =
                        "Status: Buy error"
                    warn(
                        "[Delta Chicken Hub] Buy error:",
                        result
                    )
                end
            end

            task.wait(1.5)
        end
    end
end)

--==================================================
-- STARTUP
--==================================================

StatusLabel.Text = "Status: Ready"

print("===================================")
print(" DELTA CHICKEN HUB - FIXED")
print(" Auto Eggs       : Ready")
print(" Auto Money      : Ready")
print(" Auto Buy        : Ready")
print("===================================")
