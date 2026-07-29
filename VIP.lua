local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local StepEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StepTaken")
local AutoStep = false
local AutoFarm = false
local Speed = 0.01
local StepAmount = 9999999999999
local AddAmount = 9999999999999
local targetCFrame = CFrame.new(-5.63876893e-06, 3.5, -9076, 0, 0, 1, 0, 1, -0, -1, 0, 0)
local targetColor = Color3.fromRGB(150, 154, 167) 
local returnButtons = workspace:WaitForChild("ReturnButtons") 
if player.PlayerGui:FindFirstChild("DeltaPremiumGui") then player.PlayerGui.DeltaPremiumGui:Destroy() end
local Gui = Instance.new("ScreenGui")
Gui.Name = "DeltaPremiumGui"
Gui.ResetOnSpawn = false
Gui.Parent = player.PlayerGui
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0, 20, 0.3, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(142, 68, 173)
ToggleBtn.Text = "Menu"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.TextSize = 16
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Gui
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 30)
ToggleCorner.Parent = ToggleBtn
local Window = Instance.new("Frame")
Window.Size = UDim2.new(0, 360, 0, 380)
Window.Position = UDim2.new(0.5, -180, 0.5, -190)
Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Window.Visible = false
Window.ClipsDescendants = true
Window.Parent = Gui
local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 12)
WindowCorner.Parent = Window
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Header.Parent = Window
local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "DELTA HUB | PREMIUM STAGE"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.Parent = Window
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
local function StyleToggleButton(button, state)
    if state then
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(46, 204, 113)}):Play()
    else
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(192, 57, 43)}):Play()
    end
end
local DisplayBox = Instance.new("TextLabel")
DisplayBox.Size = UDim2.new(1, 0, 0, 45)
DisplayBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
DisplayBox.TextColor3 = Color3.fromRGB(230, 230, 230)
DisplayBox.Font = Enum.Font.GothamMedium
DisplayBox.TextSize = 14
DisplayBox.Parent = Container
Instance.new("UICorner", DisplayBox).CornerRadius = UDim.new(0, 6)
local function UpdateText()
    DisplayBox.Text = "  📊 Current Step: " .. tostring(StepAmount) .. " | Speed: " .. tostring(Speed) .. "s"
end
UpdateText()
local AutoStepBtn = Instance.new("TextButton")
AutoStepBtn.Size = UDim2.new(1, 0, 0, 45)
AutoStepBtn.Text = "🔘 AUTO STEP: OFF"
AutoStepBtn.TextColor3 = Color3.new(1, 1, 1)
AutoStepBtn.Font = Enum.Font.GothamBold
AutoStepBtn.TextSize = 14
AutoStepBtn.Parent = Container
Instance.new("UICorner", AutoStepBtn).CornerRadius = UDim.new(0, 6)
StyleToggleButton(AutoStepBtn, AutoStep)
local AdjustFrame = Instance.new("Frame")
AdjustFrame.Size = UDim2.new(1, 0, 0, 40)
AdjustFrame.BackgroundTransparency = 1
AdjustFrame.Parent = Container
local PlusBtn = Instance.new("TextButton")
PlusBtn.Size = UDim2.new(0.48, 0, 1, 0)
PlusBtn.Position = UDim2.new(0, 0, 0, 0)
PlusBtn.BackgroundColor3 = Color3.fromRGB(41, 128, 185)
PlusBtn.Text = "➕ ADD STEP"
PlusBtn.TextColor3 = Color3.new(1, 1, 1)
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.TextSize = 13
PlusBtn.Parent = AdjustFrame
Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 6)
local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0.48, 0, 1, 0)
MinusBtn.Position = UDim2.new(0.52, 0, 0, 0)
MinusBtn.BackgroundColor3 = Color3.fromRGB(230, 126, 34)
MinusBtn.Text = "➖ MINUS STEP"
MinusBtn.TextColor3 = Color3.new(1, 1, 1)
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.TextSize = 13
MinusBtn.Parent = AdjustFrame
Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 6)
local InputAmountBox = Instance.new("TextBox")
InputAmountBox.Size = UDim2.new(1, 0, 0, 40)
InputAmountBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
InputAmountBox.Text = tostring(AddAmount)
InputAmountBox.PlaceholderText = "กรอกจำนวนก้าวที่จะ เพิ่ม/ลด..."
InputAmountBox.TextColor3 = Color3.fromRGB(200, 200, 200)
InputAmountBox.Font = Enum.Font.Gotham
InputAmountBox.TextSize = 13
InputAmountBox.Parent = Container
Instance.new("UICorner", InputAmountBox).CornerRadius = UDim.new(0, 6)
local AutoFarmBtn = Instance.new("TextButton")
AutoFarmBtn.Size = UDim2.new(1, 0, 0, 45)
AutoFarmBtn.Text = "⚡ AUTO FARM (TELEPORT): OFF"
AutoFarmBtn.TextColor3 = Color3.new(1, 1, 1)
AutoFarmBtn.Font = Enum.Font.GothamBold
AutoFarmBtn.TextSize = 14
AutoFarmBtn.Parent = Container
Instance.new("UICorner", AutoFarmBtn).CornerRadius = UDim.new(0, 6)
StyleToggleButton(AutoFarmBtn, AutoFarm)
ToggleBtn.MouseButton1Click:Connect(function()
    Window.Visible = not Window.Visible
    ToggleBtn.Text = Window.Visible and "Close" or "Menu"
end)
PlusBtn.MouseButton1Click:Connect(function()
    StepAmount = StepAmount + AddAmount
    UpdateText()
end)
MinusBtn.MouseButton1Click:Connect(function()
    StepAmount = math.max(1, StepAmount - AddAmount)
    UpdateText()
end)
InputAmountBox.FocusLost:Connect(function()
    local val = tonumber(InputAmountBox.Text)
    if val then AddAmount = val else InputAmountBox.Text = tostring(AddAmount) end
end)
AutoStepBtn.MouseButton1Click:Connect(function()
    AutoStep = not AutoStep
    AutoStepBtn.Text = AutoStep and "🔘 AUTO STEP: ON" or "🔘 AUTO STEP: OFF"
    StyleToggleButton(AutoStepBtn, AutoStep)
end)
AutoFarmBtn.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    AutoFarmBtn.Text = AutoFarm and "⚡ AUTO FARM (TELEPORT): ON" or "⚡ AUTO FARM (TELEPORT): OFF"
    StyleToggleButton(AutoFarmBtn, AutoFarm)
end)
task.spawn(function()
    while true do
        if AutoStep then
            pcall(function()
                StepEvent:FireServer(StepAmount, false)
            end)
        end
        task.wait(Speed)
    end
end)
task.spawn(function()
    while true do
        if AutoStep then
            StepAmount = StepAmount + AddAmount
            UpdateText()
        end
        task.wait(0.1)
    end
end)
task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoFarm then
            pcall(function()
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = character.HumanoidRootPart
                    rootPart.CFrame = targetCFrame
                    if returnButtons then
                        if returnButtons:IsA("BasePart") and returnButtons.Color == targetColor then
                            local detector = returnButtons:FindFirstChildOfClass("ClickDetector")
                            if detector then fireclickdetector(detector) end
                            local prompt = returnButtons:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then fireproximityprompt(prompt) end
                        end
                    end
                end
            end)
        end
    end
end)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Window.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)
