local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

--==================================================
-- ANTI AFK
--==================================================

local successAfk = pcall(function()
    for _, connection in pairs(getconnections(player.Idled)) do
        connection:Disable()
    end
end)

if not successAfk then
    player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaPremiumHub"
ScreenGui.ResetOnSpawn = false

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

--==================================================
-- KEY FRAME
--==================================================

local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 360, 0, 220)
KeyFrame.Position = UDim2.new(0.5, -180, 0.5, -110)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

addCorner(KeyFrame, 12)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 45)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "🔑 DELTA PREMIUM KEY SYSTEM"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 18
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 280, 0, 40)
KeyInput.Position = UDim2.new(0.5, -140, 0.4, -20)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
KeyInput.PlaceholderText = "กรุณาใส่คีย์ที่นี่..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 16
KeyInput.Font = Enum.Font.SourceSans
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = KeyFrame

addCorner(KeyInput, 6)

local CheckBtn = Instance.new("TextButton")
CheckBtn.Size = UDim2.new(0, 140, 0, 40)
CheckBtn.Position = UDim2.new(0.5, -70, 0.7, 5)
CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 110)
CheckBtn.Text = "ตรวจสอบคีย์"
CheckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckBtn.TextSize = 16
CheckBtn.Font = Enum.Font.SourceSansBold
CheckBtn.Parent = KeyFrame

addCorner(CheckBtn, 6)

--==================================================
-- MAIN FRAME
--==================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

addCorner(MainFrame, 15)

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 50)
MainTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
MainTitle.Text = "🚀 DELTA AUTO FARM HUB"
MainTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
MainTitle.TextSize = 20
MainTitle.Font = Enum.Font.SourceSansBold
MainTitle.Parent = MainFrame

addCorner(MainTitle, 15)

--==================================================
-- FLAGS
--==================================================

local flags = {
    AutoEgg = false,
    AutoCollect = false,
    AutoDeposit = false,
    AutoBuyChicken = false,
    AutoDiscardLucky = false
}

local buttonCount = 0

local function createToggle(text, flagName)
    local button = Instance.new("TextButton")

    button.Size = UDim2.new(0, 390, 0, 42)
    button.Position = UDim2.new(
        0.5,
        -195,
        0,
        65 + (buttonCount * 52)
    )

    button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    button.Text = text .. " : OFF"
    button.TextColor3 = Color3.fromRGB(220, 90, 90)
    button.TextSize = 15
    button.Font = Enum.Font.SourceSansBold
    button.Parent = MainFrame

    addCorner(button, 8)

    button.MouseButton1Click:Connect(function()
        flags[flagName] = not flags[flagName]

        if flags[flagName] then
            button.Text = text .. " : ON"
            button.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            button.Text = text .. " : OFF"
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            button.TextColor3 = Color3.fromRGB(220, 90, 90)
        end
    end)

    buttonCount += 1
end

createToggle(
    "ดึงไข่อัตโนมัติ (ยกเว้น Lucky)",
    "AutoEgg"
)

createToggle(
    "ดึงปุ่มเก็บเงิน (Collect Money)",
    "AutoCollect"
)

createToggle(
    "ดึงที่ฝากไข่ (Deposit Hitbox)",
    "AutoDeposit"
)

createToggle(
    "ดึงปุ่มซื้อไก่ x5 (Buy Chickens)",
    "AutoBuyChicken"
)

createToggle(
    "ลบกล่องนำโชคอัตโนมัติ (Discard Lucky)",
    "AutoDiscardLucky"
)

--==================================================
-- ANTI AFK LABEL
--==================================================

local AntiAfkLabel = Instance.new("TextLabel")

AntiAfkLabel.Size = UDim2.new(1, 0, 0, 25)
AntiAfkLabel.Position = UDim2.new(0, 0, 1, -30)
AntiAfkLabel.BackgroundTransparency = 1
AntiAfkLabel.Text = "🛡️ ระบบป้องกันการหลุด (Anti-AFK) เปิดทำงานอยู่ตลอดเวลา"
AntiAfkLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
AntiAfkLabel.TextSize = 12
AntiAfkLabel.Font = Enum.Font.SourceSansItalic
AntiAfkLabel.Parent = MainFrame

--==================================================
-- KEY SYSTEM
--==================================================

local CORRECT_KEY = "GG.GR"

CheckBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then

        KeyFrame:Destroy()
        MainFrame.Visible = true

    else

        CheckBtn.Text = "❌ คีย์ไม่ถูกต้อง!"
        CheckBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)

        task.wait(1.5)

        if CheckBtn and CheckBtn.Parent then
            CheckBtn.Text = "ตรวจสอบคีย์"
            CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 110)
        end
    end
end)

--==================================================
-- HELPER
--==================================================

local function moveObjectTo(object, targetCFrame)
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

local function getObject(parent, ...)
    local current = parent

    for _, name in ipairs({...}) do
        if not current then
            return nil
        end

        current = current:FindFirstChild(name)
    end

    return current
end

--==================================================
-- AUTO FARM LOOP
--==================================================

task.spawn(function()

    while task.wait(0.4) do

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if not hrp then
            continue
        end

        --==========================================
        -- AUTO EGG
        --==========================================

        if flags.AutoEgg then

            local eggsFolder = workspace:FindFirstChild("Eggs")

            if eggsFolder then

                for _, egg in ipairs(eggsFolder:GetChildren()) do

                    local nameLower = string.lower(egg.Name)

                    local isLucky =
                        string.find(nameLower, "lucky")
                        or string.find(nameLower, "โชค")

                    if not isLucky then

                        moveObjectTo(
                            egg,
                            hrp.CFrame + Vector3.new(0, 2, 0)
                        )

                    end
                end
            end
        end

        --==========================================
        -- AUTO COLLECT
        --==========================================

        if flags.AutoCollect then

            local plots = workspace:FindFirstChild("Plots")
            local plot = plots and plots:FindFirstChild("BBBR17k")

            if plot then

                local button = getObject(
                    plot,
                    "Buttons",
                    "CollectMoney",
                    "Button"
                )

                if button then

                    moveObjectTo(
                        button,
                        hrp.CFrame + Vector3.new(0, -1, 0)
                    )

                end
            end
        end

        --==========================================
        -- AUTO DEPOSIT
        --==========================================

        if flags.AutoDeposit then

            local plots = workspace:FindFirstChild("Plots")
            local plot = plots and plots:FindFirstChild("BBBR17k")

            if plot then

                local hitbox = getObject(
                    plot,
                    "Buttons",
                    "DepositEggs",
                    "Hitbox"
                )

                if hitbox then

                    moveObjectTo(
                        hitbox,
                        hrp.CFrame + Vector3.new(0, -1, 0)
                    )

                end
            end
        end

        --==========================================
        -- AUTO BUY CHICKENS
        --==========================================

        if flags.AutoBuyChicken then

            local plots = workspace:FindFirstChild("Plots")
            local plot = plots and plots:FindFirstChild("BBBR17k")

            if plot then

                local buyButton = getObject(
                    plot,
                    "Buttons",
                    "BuyChickens",
                    "Buy5",
                    "Button"
                )

                if buyButton then

                    moveObjectTo(
                        buyButton,
                        hrp.CFrame + Vector3.new(0, -1, 0)
                    )

                end
            end
        end

        --==========================================
        -- AUTO DISCARD LUCKY
        --==========================================

        if flags.AutoDiscardLucky then

            pcall(function()

                local replicatedStorage = game:GetService(
                    "ReplicatedStorage"
                )

                local paper = replicatedStorage:FindFirstChild("Paper")

                if not paper then
                    return
                end

                local remotes = paper:FindFirstChild("Remotes")

                if not remotes then
                    return
                end

                local remoteEvent = remotes:FindFirstChild(
                    "__remoteevent"
                )

                if not remoteEvent then
                    return
                end

                remoteEvent:FireServer(
                    "Discard Lucky Block"
                )

            end)
        end
    end
end)
