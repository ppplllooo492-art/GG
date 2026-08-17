--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

if not player then
    return
end

--// ANTI IDLE
pcall(function()
    if getconnections then
        for _, connection in pairs(getconnections(player.Idled)) do
            pcall(function()
                connection:Disable()
            end)
        end
    end
end)

player.Idled:Connect(function()
    pcall(function()
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end)

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateFullSystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

--// HELPERS
local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function addStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function makeDraggable(frame, trigger)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    trigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart

            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--// FIND PLAYER PLOT
local function findMyPlot()
    local plots = workspace:FindFirstChild("Plots")

    if not plots then
        return nil
    end

    -- First try sign/name detection
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("Sign")

        if sign then
            local textLabel = sign:FindFirstChild("TextLabel")

            if textLabel and textLabel:IsA("TextLabel") then
                local text = tostring(textLabel.Text)

                if string.find(text, player.Name, 1, true)
                    or string.find(text, player.DisplayName, 1, true) then
                    return plot
                end
            end
        end
    end

    -- Fallback: first plot containing Buttons
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:FindFirstChild("Buttons") then
            return plot
        end
    end

    return nil
end

--// KEY FRAME
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 360, 0, 220)
KeyFrame.Position = UDim2.new(0.5, -180, 0.5, -110)
KeyFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = ScreenGui

addCorner(KeyFrame, 16)

local keyStroke = addStroke(
    KeyFrame,
    Color3.fromRGB(255, 0, 100),
    2
)

makeDraggable(KeyFrame, KeyFrame)

-- Animated key border
task.spawn(function()
    while KeyFrame.Parent do
        for h = 0, 1, 0.01 do
            if not KeyFrame.Parent then
                break
            end

            keyStroke.Color = Color3.fromHSV(h, 1, 1)
            task.wait(0.03)
        end
    end
end)

--// KEY TITLE
local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "ULTIMATE FULL SYSTEM"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 18
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

--// KEY INPUT
local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 280, 0, 42)
KeyInput.Position = UDim2.new(0.5, -140, 0.45, -10)
KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
KeyInput.BorderSizePixel = 0
KeyInput.PlaceholderText = "KEY: GG.GR"
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(0, 255, 200)
KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
KeyInput.TextSize = 14
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = KeyFrame

addCorner(KeyInput, 10)
addStroke(KeyInput, Color3.fromRGB(50, 50, 80), 1.5)

--// UNLOCK BUTTON
local CheckBtn = Instance.new("TextButton")
CheckBtn.Size = UDim2.new(0, 160, 0, 40)
CheckBtn.Position = UDim2.new(0.5, -80, 0.78, -5)
CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
CheckBtn.BorderSizePixel = 0
CheckBtn.Text = "UNLOCK"
CheckBtn.TextColor3 = Color3.fromRGB(15, 15, 22)
CheckBtn.Font = Enum.Font.GothamBold
CheckBtn.TextSize = 13
CheckBtn.Parent = KeyFrame

addCorner(CheckBtn, 12)

--// MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 320)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

addCorner(MainFrame, 16)

local mainStroke = addStroke(
    MainFrame,
    Color3.fromRGB(0, 255, 200),
    2
)

-- Animated main border
task.spawn(function()
    while MainFrame.Parent do
        for h = 0, 1, 0.01 do
            if not MainFrame.Parent then
                break
            end

            mainStroke.Color = Color3.fromHSV(h, 1, 1)
            task.wait(0.02)
        end
    end
end)

--// TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

addCorner(TopBar, 16)
makeDraggable(MainFrame, TopBar)

--// TITLE
local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, -60, 1, 0)
MainTitle.Position = UDim2.new(0, 15, 0, 0)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "FULL WORKING ENGINE"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextSize = 14
MainTitle.Font = Enum.Font.GothamBold
MainTitle.TextXAlignment = Enum.TextXAlignment.Left
MainTitle.Parent = TopBar

--// CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.Parent = TopBar

addCorner(CloseBtn, 8)

CloseBtn.MouseButton1Click:Connect(function()
    if ScreenGui then
        ScreenGui:Destroy()
    end
end)

--// TAB BAR
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 36)
TabBar.Position = UDim2.new(0, 10, 0, 48)
TabBar.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

addCorner(TabBar, 10)

--// CONTENT
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -96)
ContentFrame.Position = UDim2.new(0, 10, 0, 86)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

--// FLAGS
local flags = {
    AutoEgg = false,
    AutoCollect = false,
    AutoDeposit = false,
    AutoBuyChicken = false,
    AutoDiscardLucky = false,
    AutoOpenLucky = false
}

--// TABS
local tabs = {}
local pages = {}
local curTab = nil

local function createTab(name, order)
    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(0, 142, 1, -6)
    btn.Position = UDim2.new(
        0,
        4 + ((order - 1) * 146),
        0,
        3
    )

    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(140, 140, 160)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabBar

    addCorner(btn, 8)

    local pg = Instance.new("ScrollingFrame")

    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency = 1
    pg.BorderSizePixel = 0
    pg.Visible = false
    pg.AutomaticCanvasSize = Enum.AutomaticSize.Y
    pg.CanvasSize = UDim2.new(0, 0, 0, 0)
    pg.ScrollBarThickness = 2
    pg.Parent = ContentFrame

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = pg

    tabs[name] = btn
    pages[name] = pg

    btn.MouseButton1Click:Connect(function()
        for _, page in pairs(pages) do
            page.Visible = false
        end

        for _, tab in pairs(tabs) do
            tab.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            tab.TextColor3 = Color3.fromRGB(140, 140, 160)
        end

        pg.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(85, 0, 180)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)

        curTab = name
    end)

    if not curTab then
        curTab = name
        pg.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(85, 0, 180)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    return pg
end

local farmPage = createTab("FARM", 1)
local itemPage = createTab("ITEMS", 2)
local infoPage = createTab("INFO", 3)

--// TOGGLE CREATOR
local function createToggle(page, text, flagName)
    local container = Instance.new("Frame")

    container.Size = UDim2.new(1, -4, 0, 40)
    container.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    container.BorderSizePixel = 0
    container.Parent = page

    addCorner(container, 8)
    addStroke(container, Color3.fromRGB(40, 40, 60), 1)

    local label = Instance.new("TextLabel")

    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 245)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggle = Instance.new("TextButton")

    toggle.Size = UDim2.new(0, 46, 0, 22)
    toggle.Position = UDim2.new(1, -58, 0.5, -11)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = container

    addCorner(toggle, 11)

    local circle = Instance.new("Frame")

    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 3, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
    circle.BorderSizePixel = 0
    circle.Parent = toggle

    addCorner(circle, 8)

    toggle.MouseButton1Click:Connect(function()
        flags[flagName] = not flags[flagName]

        if flags[flagName] then
            toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 120)

            circle:TweenPosition(
                UDim2.new(1, -19, 0.5, -8),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Elastic,
                0.45,
                true
            )

            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)

            circle:TweenPosition(
                UDim2.new(0, 3, 0.5, -8),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Elastic,
                0.45,
                true
            )

            circle.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
        end
    end)

    return container
end

--// FARM
createToggle(
    farmPage,
    "Auto Bring Eggs",
    "AutoEgg"
)

createToggle(
    farmPage,
    "Auto Collect Money",
    "AutoCollect"
)

createToggle(
    farmPage,
    "Auto Deposit Eggs",
    "AutoDeposit"
)

createToggle(
    farmPage,
    "Auto Buy Chickens x5",
    "AutoBuyChicken"
)

--// ITEMS
createToggle(
    itemPage,
    "Auto Discard Lucky Block",
    "AutoDiscardLucky"
)

createToggle(
    itemPage,
    "Auto Open Lucky Block",
    "AutoOpenLucky"
)

--// INFO
local InfoLbl = Instance.new("TextLabel")

InfoLbl.Size = UDim2.new(1, -4, 0, 100)
InfoLbl.BackgroundTransparency = 1
InfoLbl.Text =
    "ENGINE: FULLY ACTIVE\n\n" ..
    "Version: 1.0\n" ..
    "Status: Ready\n\n" ..
    "Use the FARM and ITEMS tabs to control features."

InfoLbl.TextColor3 = Color3.fromRGB(0, 255, 255)
InfoLbl.TextSize = 10
InfoLbl.Font = Enum.Font.GothamBold
InfoLbl.TextXAlignment = Enum.TextXAlignment.Left
InfoLbl.TextYAlignment = Enum.TextYAlignment.Top
InfoLbl.Parent = infoPage

--// UNLOCK
CheckBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "GG.GR" then
        KeyFrame.Visible = false
        MainFrame.Visible = true

        task.wait()

        if KeyFrame then
            KeyFrame:Destroy()
        end
    else
        CheckBtn.Text = "INVALID!"
        CheckBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 80)

        task.wait(1.5)

        if CheckBtn.Parent then
            CheckBtn.Text = "UNLOCK"
            CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
        end
    end
end)

--// HELPER: MOVE BASEPART
local function movePartToPlayer(part, hrp, offset)
    if not part or not part:IsA("BasePart") then
        return
    end

    if not hrp or not hrp.Parent then
        return
    end

    pcall(function()
        part.CFrame = hrp.CFrame + (offset or Vector3.new(0, -1, 0))
    end)
end

--// HELPER: MOVE MODEL
local function moveModelToPlayer(model, hrp, offset)
    if not model or not model:IsA("Model") then
        return
    end

    if not hrp or not hrp.Parent then
        return
    end

    local targetCFrame = hrp.CFrame + (offset or Vector3.new(0, 2, 0))

    pcall(function()
        if model.PrimaryPart then
            model:SetPrimaryPartCFrame(targetCFrame)
            return
        end

        local pivotPart = model:FindFirstChildWhichIsA("BasePart", true)

        if pivotPart then
            model:PivotTo(targetCFrame)
        end
    end)
end

--// AUTO SYSTEM
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.2)

        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")

        if not hrp then
            continue
        end

        local plot = findMyPlot()

        --==================================================
        -- AUTO EGG
        --==================================================
        if flags.AutoEgg then
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    local lowerName = string.lower(obj.Name)

                    if string.find(lowerName, "egg", 1, true)
                        and not string.find(lowerName, "lucky", 1, true) then

                        if obj:IsA("BasePart") then
                            movePartToPlayer(
                                obj,
                                hrp,
                                Vector3.new(0, 2, 0)
                            )

                        elseif obj:IsA("Model") then
                            moveModelToPlayer(
                                obj,
                                hrp,
                                Vector3.new(0, 2, 0)
                            )
                        end
                    end
                end
            end)
        end

        --==================================================
        -- PLOT SYSTEMS
        --==================================================
        if plot then
            local buttons = plot:FindFirstChild("Buttons")

            if buttons then

                --==========================================
                -- AUTO COLLECT
                --==========================================
                if flags.AutoCollect then
                    pcall(function()
                        local collect =
                            buttons:FindFirstChild("CollectMoney")

                        if collect then
                            local button =
                                collect:FindFirstChild("Button")
                                or collect:FindFirstChildWhichIsA(
                                    "BasePart",
                                    true
                                )

                            if button and button:IsA("BasePart") then
                                movePartToPlayer(
                                    button,
                                    hrp,
                                    Vector3.new(0, -1, 0)
                                )
                            end
                        end
                    end)
                end

                --==========================================
                -- AUTO DEPOSIT
                --==========================================
                if flags.AutoDeposit then
                    pcall(function()
                        local deposit =
                            buttons:FindFirstChild("DepositEggs")

                        if deposit then
                            local hitbox =
                                deposit:FindFirstChild("Hitbox")
                                or deposit:FindFirstChildWhichIsA(
                                    "BasePart",
                                    true
                                )

                            if hitbox and hitbox:IsA("BasePart") then
                                movePartToPlayer(
                                    hitbox,
                                    hrp,
                                    Vector3.new(0, -1, 0)
                                )
                            end
                        end
                    end)
                end

                --==========================================
                -- AUTO BUY CHICKENS
                --==========================================
                if flags.AutoBuyChicken then
                    pcall(function()
                        local buy =
                            buttons:FindFirstChild("BuyChickens")

                        if buy then
                            local buy5 =
                                buy:FindFirstChild("Buy5")

                            if buy5 then
                                local button =
                                    buy5:FindFirstChild("Button")
                                    or buy5:FindFirstChildWhichIsA(
                                        "BasePart",
                                        true
                                    )

                                if button and button:IsA("BasePart") then
                                    movePartToPlayer(
                                        button,
                                        hrp,
                                        Vector3.new(0, -1, 0)
                                    )
                                end
                            end
                        end
                    end)
                end
            end
        end

        --==================================================
        -- LUCKY BLOCK
        --==================================================
        pcall(function()
            local paper =
                ReplicatedStorage:FindFirstChild("Paper")

            if not paper then
                return
            end

            local remotes =
                paper:FindFirstChild("Remotes")

            if not remotes then
                return
            end

            -- Auto Discard
            if flags.AutoDiscardLucky then
                local remoteEvent =
                    remotes:FindFirstChild("__remoteevent")

                if remoteEvent and remoteEvent:IsA("RemoteEvent") then
                    pcall(function()
                        remoteEvent:FireServer(
                            "Discard Lucky Block"
                        )
                    end)
                end
            end

            -- Auto Open
            if flags.AutoOpenLucky then
                local remoteFunction =
                    remotes:FindFirstChild("__remotefunction")

                if remoteFunction
                    and remoteFunction:IsA("RemoteFunction") then

                    pcall(function()
                        remoteFunction:InvokeServer(
                            "Open Lucky Block"
                        )
                    end)
                end
            end
        end)
    end
end)

--// CLEANUP
ScreenGui.AncestryChanged:Connect(function(_, parent)
    if parent == nil then
        flags.AutoEgg = false
        flags.AutoCollect = false
        flags.AutoDeposit = false
        flags.AutoBuyChicken = false
        flags.AutoDiscardLucky = false
        flags.AutoOpenLucky = false
    end
end)
