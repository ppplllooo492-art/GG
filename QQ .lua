--// DELTA CHICKEN HUB - Fixed Version
--// LocalScript / Executor Script

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

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
-- CONFIG
--==================================================

local config = {
    AutoEggs = false,
    AutoMoney = false,
    AutoBuy = false
}

local chickenCost = 100
local maxEggs = 30

local eggCount = 0

--==================================================
-- MONEY
--==================================================

local moneyValue = nil

local function findMoney()
    local leaderstats = player:FindFirstChild("leaderstats")

    if not leaderstats then
        return nil
    end

    return leaderstats:FindFirstChild("Money")
        or leaderstats:FindFirstChild("Cash")
        or leaderstats:FindFirstChild("Coins")
end

moneyValue = findMoney()

task.spawn(function()
    while task.wait(2) do
        if not moneyValue or not moneyValue.Parent then
            moneyValue = findMoney()
        end
    end
end)

--==================================================
-- SAFE FIND
--==================================================

local function findChild(parent, name)
    if not parent then
        return nil
    end

    return parent:FindFirstChild(name)
end

local function findDescendant(name)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == name then
            return obj
        end
    end

    return nil
end

--==================================================
-- GET TARGET PART
--==================================================

local function getTargetPart(target)
    if not target then
        return nil
    end

    if target:IsA("BasePart") then
        return target
    end

    if target:IsA("Model") then
        if target.PrimaryPart then
            return target.PrimaryPart
        end

        local part = target:FindFirstChildWhichIsA("BasePart", true)

        if part then
            return part
        end
    end

    return nil
end

--==================================================
-- SAFE TELEPORT
--==================================================

local function teleportTo(target)
    if not rootPart or not rootPart.Parent then
        return false
    end

    local part = getTargetPart(target)

    if not part then
        return false
    end

    local success = pcall(function()
        rootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
    end)

    return success
end

--==================================================
-- FIND PLOT
--==================================================

local function getPlot()
    local plots = workspace:FindFirstChild("Plots")

    if not plots then
        return nil
    end

    -- พยายามหา plot ชื่อเดิมก่อน
    local plot = plots:FindFirstChild("BBBR17k")

    if plot then
        return plot
    end

    -- ถ้าไม่มี ให้ลองหา Plot ที่เกี่ยวข้องกับผู้เล่น
    for _, obj in ipairs(plots:GetChildren()) do
        if obj:IsA("Model") then
            local owner = obj:FindFirstChild("Owner")
                or obj:FindFirstChild("Player")
                or obj:FindFirstChild("OwnerName")

            if owner then
                local value = owner.Value

                if value == player or value == player.Name then
                    return obj
                end
            end
        end
    end

    return nil
end

--==================================================
-- FIND BUTTON
--==================================================

local function findPlotButton(buttonName)
    local plot = getPlot()

    if not plot then
        return nil
    end

    return plot:FindFirstChild(buttonName, true)
end

--==================================================
-- GUI
--==================================================

pcall(function()
    local oldGui = CoreGui:FindFirstChild("DeltaFarmGUI")

    if oldGui then
        oldGui:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaFarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 310)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

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

local function setStatus(text)
    if StatusLabel and StatusLabel.Parent then
        StatusLabel.Text = "Status: " .. text
    end
end

--==================================================
-- CREATE BUTTON
--==================================================

local function createButton(name, text, yPosition)
    local button = Instance.new("TextButton")

    button.Name = name
    button.Parent = MainFrame
    button.Position = UDim2.new(0.08, 0, yPosition, 0)
    button.Size = UDim2.new(0.84, 0, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    button.Font = Enum.Font.SourceSansBold
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.AutoButtonColor = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    return button
end

local BtnEggs = createButton(
    "BtnEggs",
    "Auto Eggs: OFF",
    0.32
)

local BtnMoney = createButton(
    "BtnMoney",
    "Auto Collect Money: OFF",
    0.52
)

local BtnBuy = createButton(
    "BtnBuy",
    "Auto Buy Chicken: OFF",
    0.72
)

--==================================================
-- BUTTON COLOR
--==================================================

local function updateButton(button, enabled, onText, offText)
    if enabled then
        button.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        button.Text = onText
    else
        button.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        button.Text = offText
    end
end

--==================================================
-- AUTO EGGS TOGGLE
--==================================================

BtnEggs.MouseButton1Click:Connect(function()

    config.AutoEggs = not config.AutoEggs

    updateButton(
        BtnEggs,
        config.AutoEggs,
        "Auto Eggs: ON",
        "Auto Eggs: OFF"
    )

    if config.AutoEggs then
        setStatus("Egg Farming ON")
    else
        setStatus("Egg Farming OFF")
    end
end)

--==================================================
-- AUTO MONEY TOGGLE
--==================================================

BtnMoney.MouseButton1Click:Connect(function()

    config.AutoMoney = not config.AutoMoney

    updateButton(
        BtnMoney,
        config.AutoMoney,
        "Auto Collect Money: ON",
        "Auto Collect Money: OFF"
    )

    if config.AutoMoney then
        setStatus("Money Collection ON")
    else
        setStatus("Money Collection OFF")
    end
end)

--==================================================
-- AUTO BUY TOGGLE
--==================================================

BtnBuy.MouseButton1Click:Connect(function()

    config.AutoBuy = not config.AutoBuy

    updateButton(
        BtnBuy,
        config.AutoBuy,
        "Auto Buy Chicken: ON",
        "Auto Buy Chicken: OFF"
    )

    if config.AutoBuy then
        setStatus("Auto Buy ON")
    else
        setStatus("Auto Buy OFF")
    end
end)

--==================================================
-- AUTO EGGS
--==================================================

task.spawn(function()

    while task.wait(0.5) do

        if config.AutoEggs then

            local eggsFolder = workspace:FindFirstChild("Eggs")

            if eggsFolder then

                setStatus("Farming Eggs...")

                for _, egg in ipairs(eggsFolder:GetChildren()) do

                    if not config.AutoEggs then
                        break
                    end

                    local target = getTargetPart(egg)

                    if target then

                        local success = teleportTo(target)

                        if success then

                            eggCount += 1

                            task.wait(0.35)

                            -- ครบจำนวนแล้วไปฝาก
                            if eggCount >= maxEggs then

                                setStatus("Depositing Eggs...")

                                local deposit = findPlotButton("DepositEggs")

                                if deposit then
                                    teleportTo(deposit)
                                    task.wait(1.2)
                                else
                                    setStatus("DepositEggs not found")
                                    task.wait(1)
                                end

                                eggCount = 0
                            end
                        end
                    end
                end

            else
                setStatus("Eggs folder not found")
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

            setStatus("Waiting for collection...")

            -- รอ 60 วินาที แต่สามารถปิดระบบได้ระหว่างรอ
            for i = 1, 60 do

                if not config.AutoMoney then
                    break
                end

                task.wait(1)
            end

            if config.AutoMoney then

                setStatus("Collecting Money...")

                local collectButton = findPlotButton("CollectMoney")

                if collectButton then
                    teleportTo(collectButton)
                    task.wait(1.5)
                else
                    setStatus("CollectMoney not found")
                    task.wait(1)
                end
            end
        end
    end
end)

--==================================================
-- AUTO BUY CHICKEN
--==================================================

task.spawn(function()

    while task.wait(2) do

        if config.AutoBuy then

            moneyValue = moneyValue or findMoney()

            if moneyValue and moneyValue.Parent then

                local currentMoney = tonumber(moneyValue.Value) or 0

                if currentMoney >= chickenCost then

                    setStatus("Buying Chicken...")

                    local buyButton = findPlotButton("BuyChickens")

                    if buyButton then

                        teleportTo(buyButton)

                        task.wait(1.5)

                    else
                        setStatus("BuyChickens not found")
                        task.wait(1)
                    end
                end
            end
        end
    end
end)

--==================================================
-- GUI CLOSE ON SCRIPT RELOAD
--==================================================

ScreenGui.AncestryChanged:Connect(function(_, parent)

    if not parent then

        config.AutoEggs = false
        config.AutoMoney = false
        config.AutoBuy = false

    end
end)

--==================================================
-- READY
--==================================================

setStatus("Ready")

print("====================================")
print(" DELTA CHICKEN HUB")
print(" Fixed Version Loaded Successfully")
print("====================================")
