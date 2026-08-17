--==================================================--
-- SERVICES & LOCAL PLAYER
--==================================================--

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--==================================================--
-- FLAGS
--==================================================--

local flags = {
    AutoEgg = false,
    AutoCollect = false,
    AutoDeposit = false,
    AutoBuyChicken = false,
    AutoDiscardLucky = false,
    AntiAfk = false
}

--==================================================--
-- ANTI AFK
--==================================================--

local antiAfkConnection

local function SetAntiAFK(state)
    flags.AntiAfk = state

    -- ล้าง Connection เดิมก่อน
    if antiAfkConnection then
        pcall(function()
            antiAfkConnection:Disconnect()
        end)
        antiAfkConnection = nil
    end

    if not state then
        return
    end

    -- พยายาม Disable Idled connections เดิม
    local success = pcall(function()
        local connections = getconnections(player.Idled)

        for _, connection in ipairs(connections) do
            pcall(function()
                connection:Disable()
            end)
        end
    end)

    -- ถ้า getconnections ใช้งานไม่ได้ ให้ใช้วิธี VirtualUser
    if not success then
        antiAfkConnection = player.Idled:Connect(function()
            if not flags.AntiAfk then
                return
            end

            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
        end)
    end
end

--==================================================--
-- HELPER FUNCTIONS
--==================================================--

local function moveObjectTo(object, targetCFrame)
    if not object or not object.Parent then
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

local function getPlot()
    local plots = workspace:FindFirstChild("Plots")

    if not plots then
        return nil
    end

    return plots:FindFirstChild("BBBR17k")
end

--==================================================--
-- REMOVE OLD GUI
--==================================================--

local existingGui

pcall(function()
    existingGui = CoreGui:FindFirstChild("YoutubeStyleHub")
end)

if not existingGui then
    existingGui = PlayerGui:FindFirstChild("YoutubeStyleHub")
end

if existingGui then
    existingGui:Destroy()
end

--==================================================--
-- CREATE SCREEN GUI
--==================================================--

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YoutubeStyleHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local guiParent

pcall(function()
    guiParent = CoreGui
end)

if guiParent then
    ScreenGui.Parent = guiParent
else
    ScreenGui.Parent = PlayerGui
end

--==================================================--
-- MAIN FRAME
--==================================================--

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

--==================================================--
-- TOP BAR
--==================================================--

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.Text = "⚡ YOUTUBE HUB | CHICKEN FARM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

--==================================================--
-- CLOSE BUTTON
--==================================================--

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    flags.AutoEgg = false
    flags.AutoCollect = false
    flags.AutoDeposit = false
    flags.AutoBuyChicken = false
    flags.AutoDiscardLucky = false

    SetAntiAFK(false)

    if ScreenGui then
        ScreenGui:Destroy()
    end
end)

--==================================================--
-- SIDEBAR
--==================================================--

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 6)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarList.VerticalAlignment = Enum.VerticalAlignment.Top
SidebarList.Parent = Sidebar

--==================================================--
-- CONTENT AREA
--==================================================--

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -140, 1, -45)
ContentArea.Position = UDim2.new(0, 140, 0, 45)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

--==================================================--
-- FARM PAGE
--==================================================--

local FarmPage = Instance.new("ScrollingFrame")
FarmPage.Size = UDim2.new(1, -12, 1, -12)
FarmPage.Position = UDim2.new(0, 6, 0, 6)
FarmPage.BackgroundTransparency = 1
FarmPage.BorderSizePixel = 0
FarmPage.ScrollBarThickness = 3
FarmPage.CanvasSize = UDim2.new(0, 0, 0, 310)
FarmPage.Visible = true
FarmPage.Parent = ContentArea

local FarmLayout = Instance.new("UIListLayout")
FarmLayout.Padding = UDim.new(0, 8)
FarmLayout.Parent = FarmPage

--==================================================--
-- SETTINGS PAGE
--==================================================--

local SettingPage = Instance.new("ScrollingFrame")
SettingPage.Size = UDim2.new(1, -12, 1, -12)
SettingPage.Position = UDim2.new(0, 6, 0, 6)
SettingPage.BackgroundTransparency = 1
SettingPage.BorderSizePixel = 0
SettingPage.ScrollBarThickness = 3
SettingPage.CanvasSize = UDim2.new(0, 0, 0, 200)
SettingPage.Visible = false
SettingPage.Parent = ContentArea

local SettingLayout = Instance.new("UIListLayout")
SettingLayout.Padding = UDim.new(0, 8)
SettingLayout.Parent = SettingPage

--==================================================--
-- TAB BUTTONS
--==================================================--

local FarmTabBtn = Instance.new("TextButton")
local SettingTabBtn = Instance.new("TextButton")

local function StyleTabButton(button, text)
    button.Size = UDim2.new(1, -16, 0, 36)
    button.Text = "  " .. text
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 13
    button.TextColor3 = Color3.fromRGB(160, 160, 180)
    button.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.BorderSizePixel = 0
    button.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
end

StyleTabButton(FarmTabBtn, "🌾 Auto Farm")
StyleTabButton(SettingTabBtn, "⚙️ Settings")

--==================================================--
-- TAB SWITCH
--==================================================--

local function SwitchPage(activePage, activeButton)
    FarmPage.Visible = activePage == FarmPage
    SettingPage.Visible = activePage == SettingPage

    FarmTabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    FarmTabBtn.TextColor3 = Color3.fromRGB(160, 160, 180)

    SettingTabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    SettingTabBtn.TextColor3 = Color3.fromRGB(160, 160, 180)

    activeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    activeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
end

FarmTabBtn.MouseButton1Click:Connect(function()
    SwitchPage(FarmPage, FarmTabBtn)
end)

SettingTabBtn.MouseButton1Click:Connect(function()
    SwitchPage(SettingPage, SettingTabBtn)
end)

SwitchPage(FarmPage, FarmTabBtn)

--==================================================--
-- TOGGLE CREATOR
--==================================================--

local function CreateToggle(parentPage, flagKey, labelText)

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -6, 0, 42)
    Row.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    Row.BorderSizePixel = 0
    Row.Parent = parentPage

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 6)
    RowCorner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -65, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Text = labelText

    -- FIX:
    -- Enum.Font.GothamLabel ไม่มีอยู่จริง
    Label.Font = Enum.Font.Gotham

    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Row

    local TglBtn = Instance.new("TextButton")
    TglBtn.Size = UDim2.new(0, 44, 0, 22)
    TglBtn.Position = UDim2.new(1, -52, 0.5, -11)
    TglBtn.Text = ""
    TglBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    TglBtn.BorderSizePixel = 0
    TglBtn.Parent = Row

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 11)
    ToggleCorner.Parent = TglBtn

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 3, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.Parent = TglBtn

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local function UpdateUI(state)

        if state then

            TweenService:Create(
                TglBtn,
                TweenInfo.new(0.2),
                {
                    BackgroundColor3 = Color3.fromRGB(46, 204, 113)
                }
            ):Play()

            TweenService:Create(
                Circle,
                TweenInfo.new(0.2),
                {
                    Position = UDim2.new(1, -19, 0.5, -8)
                }
            ):Play()

        else

            TweenService:Create(
                TglBtn,
                TweenInfo.new(0.2),
                {
                    BackgroundColor3 = Color3.fromRGB(231, 76, 60)
                }
            ):Play()

            TweenService:Create(
                Circle,
                TweenInfo.new(0.2),
                {
                    Position = UDim2.new(0, 3, 0.5, -8)
                }
            ):Play()

        end
    end

    TglBtn.MouseButton1Click:Connect(function()

        if flagKey == "AntiAfk" then

            flags.AntiAfk = not flags.AntiAfk

            SetAntiAFK(flags.AntiAfk)

            UpdateUI(flags.AntiAfk)

        else

            flags[flagKey] = not flags[flagKey]

            UpdateUI(flags[flagKey])

        end

    end)

    UpdateUI(
        flagKey == "AntiAfk"
        and flags.AntiAfk
        or flags[flagKey]
    )
end

--==================================================--
-- FARM TOGGLES
--==================================================--

CreateToggle(
    FarmPage,
    "AutoEgg",
    "🥚 เก็บไข่อัตโนมัติ (ข้าม Lucky)"
)

CreateToggle(
    FarmPage,
    "AutoCollect",
    "💰 เก็บเงินอัตโนมัติ"
)

CreateToggle(
    FarmPage,
    "AutoDeposit",
    "📥 ส่งไข่อัตโนมัติ"
)

CreateToggle(
    FarmPage,
    "AutoBuyChicken",
    "🐔 ซื้อไก่อัตโนมัติ (ทีละ 5)"
)

CreateToggle(
    FarmPage,
    "AutoDiscardLucky",
    "📦 ทิ้ง Lucky Block"
)

--==================================================--
-- SETTINGS TOGGLES
--==================================================--

CreateToggle(
    SettingPage,
    "AntiAfk",
    "💤 ป้องกันหลุด (Anti-AFK)"
)

--==================================================--
-- AUTO FARM LOOP
--==================================================--

task.spawn(function()

    while task.wait(0.4) do

        -- ถ้า GUI ถูกลบ สามารถหยุดระบบได้
        if not ScreenGui or not ScreenGui.Parent then
            break
        end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if not hrp then
            continue
        end

        --================================================--
        -- AUTO EGG
        --================================================--

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

        --================================================--
        -- GET PLOT
        --================================================--

        local plot = getPlot()

        if plot then

            --================================================--
            -- AUTO COLLECT
            --================================================--

            if flags.AutoCollect then

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

            --================================================--
            -- AUTO DEPOSIT
            --================================================--

            if flags.AutoDeposit then

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

            --================================================--
            -- AUTO BUY CHICKEN
            --================================================--

            if flags.AutoBuyChicken then

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

        --================================================--
        -- AUTO DISCARD LUCKY BLOCK
        --================================================--

        if flags.AutoDiscardLucky then

            pcall(function()

                local ReplicatedStorage =
                    game:GetService("ReplicatedStorage")

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

                local remoteEvent =
                    remotes:FindFirstChild("__remoteevent")

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
