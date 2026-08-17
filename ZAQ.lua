--==================================================
-- SERVICES & LOCAL PLAYER
--==================================================

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--==================================================
-- FLAGS
--==================================================

local flags = {
    AutoEgg = false,
    AutoCollect = false,
    AutoDeposit = false,
    AutoBuyChicken = false,
    AutoDiscardLucky = false,
    AutoOpenLucky = false,

    AntiAfk = false,

    InfJump = false,
    SpeedEnabled = false,
    JumpEnabled = false
}

--==================================================
-- CONFIG
--==================================================

local CORRECT_KEY = "GG.GR"

local customSpeed = 24
local customJump = 50

local PLOT_NAME = "BBBR17k"

--==================================================
-- SAFE HELPERS
--==================================================

local function safeDestroy(object)
    if object then
        pcall(function()
            object:Destroy()
        end)
    end
end

local function getObject(parent, ...)
    local current = parent

    if not current then
        return nil
    end

    for _, name in ipairs({...}) do
        current = current:FindFirstChild(name)

        if not current then
            return nil
        end
    end

    return current
end

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

local function getCharacter()
    local character = player.Character

    if not character then
        return nil, nil, nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")

    return character, humanoid, hrp
end

--==================================================
-- REMOVE OLD GUI
--==================================================

local oldGui

pcall(function()
    oldGui = CoreGui:FindFirstChild("YoutubeStyleHub")
end)

if not oldGui then
    oldGui = PlayerGui:FindFirstChild("YoutubeStyleHub")
end

if oldGui then
    safeDestroy(oldGui)
end

--==================================================
-- CREATE SCREEN GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "YoutubeStyleHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local guiParentSuccess = pcall(function()
    ScreenGui.Parent = CoreGui
end)

if not guiParentSuccess or not ScreenGui.Parent then
    ScreenGui.Parent = PlayerGui
end

--==================================================
-- KEY SYSTEM
--==================================================

local KeyFrame = Instance.new("Frame")

KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 360, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -180, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 10)
KeyCorner.Parent = KeyFrame

-- Key Top

local KeyTop = Instance.new("Frame")

KeyTop.Size = UDim2.new(1, 0, 0, 35)
KeyTop.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
KeyTop.BorderSizePixel = 0
KeyTop.Parent = KeyFrame

local KeyTopCorner = Instance.new("UICorner")
KeyTopCorner.CornerRadius = UDim.new(0, 10)
KeyTopCorner.Parent = KeyTop

-- Key Title

local KeyTitle = Instance.new("TextLabel")

KeyTitle.Size = UDim2.new(1, -20, 1, 0)
KeyTitle.Position = UDim2.new(0, 12, 0, 0)
KeyTitle.Text = "KEY SYSTEM REQUIRED"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 14
KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
KeyTitle.BackgroundTransparency = 1
KeyTitle.Parent = KeyTop

-- Key Box

local KeyBox = Instance.new("TextBox")

KeyBox.Size = UDim2.new(1, -40, 0, 40)
KeyBox.Position = UDim2.new(0, 20, 0, 60)

KeyBox.PlaceholderText = "Enter Key Here..."
KeyBox.Text = ""

KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)

KeyBox.BackgroundColor3 = Color3.fromRGB(28, 28, 38)

KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14

KeyBox.ClearTextOnFocus = false

KeyBox.Parent = KeyFrame

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 6)
KeyBoxCorner.Parent = KeyBox

-- Submit Button

local SubmitBtn = Instance.new("TextButton")

SubmitBtn.Size = UDim2.new(1, -40, 0, 40)
SubmitBtn.Position = UDim2.new(0, 20, 0, 125)

SubmitBtn.Text = "SUBMIT KEY"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

SubmitBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)

SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 14

SubmitBtn.Parent = KeyFrame

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 6)
SubmitCorner.Parent = SubmitBtn

--==================================================
-- MAIN FRAME
--==================================================

local MainFrame = Instance.new("Frame")

MainFrame.Name = "MainFrame"

MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)

MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0

MainFrame.Active = true
MainFrame.Draggable = true

MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

--==================================================
-- TOP BAR
--==================================================

local TopBar = Instance.new("Frame")

TopBar.Size = UDim2.new(1, 0, 0, 45)

TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
TopBar.BorderSizePixel = 0

TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

-- Title

local Title = Instance.new("TextLabel")

Title.Size = UDim2.new(1, -95, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)

Title.Text = "YOUTUBE HUB | CHICKEN FARM"

Title.TextColor3 = Color3.fromRGB(255, 255, 255)

Title.Font = Enum.Font.GothamBold
Title.TextSize = 15

Title.TextXAlignment = Enum.TextXAlignment.Left

Title.BackgroundTransparency = 1
Title.Parent = TopBar

--==================================================
-- CLOSE BUTTON
--==================================================

local CloseBtn = Instance.new("TextButton")

CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)

CloseBtn.Text = "X"

CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)

CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14

CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    safeDestroy(ScreenGui)
end)

--==================================================
-- MINIMIZE BUTTON
--==================================================

local MinimizeBtn = Instance.new("TextButton")

MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -68, 0.5, -14)

MinimizeBtn.Text = "-"

MinimizeBtn.TextColor3 = Color3.fromRGB(255, 204, 102)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)

MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16

MinimizeBtn.Parent = TopBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeBtn

local isMinimized = false

MinimizeBtn.MouseButton1Click:Connect(function()

    isMinimized = not isMinimized

    for _, child in ipairs(MainFrame:GetChildren()) do

        if child ~= TopBar and not child:IsA("UICorner") then
            child.Visible = not isMinimized
        end

    end

    if isMinimized then

        MainFrame.Size = UDim2.new(0, 520, 0, 45)
        MinimizeBtn.Text = "+"

    else

        MainFrame.Size = UDim2.new(0, 520, 0, 340)
        MinimizeBtn.Text = "-"

    end

end)

--==================================================
-- SIDEBAR
--==================================================

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

--==================================================
-- CONTENT AREA
--==================================================

local ContentArea = Instance.new("Frame")

ContentArea.Size = UDim2.new(1, -140, 1, -45)
ContentArea.Position = UDim2.new(0, 140, 0, 45)

ContentArea.BackgroundTransparency = 1

ContentArea.Parent = MainFrame

--==================================================
-- FARM PAGE
--==================================================

local FarmPage = Instance.new("ScrollingFrame")

FarmPage.Size = UDim2.new(1, -12, 1, -12)
FarmPage.Position = UDim2.new(0, 6, 0, 6)

FarmPage.BackgroundTransparency = 1
FarmPage.BorderSizePixel = 0

FarmPage.ScrollBarThickness = 3
FarmPage.CanvasSize = UDim2.new(0, 0, 0, 370)

FarmPage.Visible = true

FarmPage.Parent = ContentArea

local FarmLayout = Instance.new("UIListLayout")

FarmLayout.Padding = UDim.new(0, 8)
FarmLayout.Parent = FarmPage

--==================================================
-- CHARACTER PAGE
--==================================================

local CharPage = Instance.new("ScrollingFrame")

CharPage.Size = UDim2.new(1, -12, 1, -12)
CharPage.Position = UDim2.new(0, 6, 0, 6)

CharPage.BackgroundTransparency = 1
CharPage.BorderSizePixel = 0

CharPage.ScrollBarThickness = 3
CharPage.CanvasSize = UDim2.new(0, 0, 0, 260)

CharPage.Visible = false

CharPage.Parent = ContentArea

local CharLayout = Instance.new("UIListLayout")

CharLayout.Padding = UDim.new(0, 8)
CharLayout.Parent = CharPage

--==================================================
-- SETTINGS PAGE
--==================================================

local SettingPage = Instance.new("ScrollingFrame")

SettingPage.Size = UDim2.new(1, -12, 1, -12)
SettingPage.Position = UDim2.new(0, 6, 0, 6)

SettingPage.BackgroundTransparency = 1
SettingPage.BorderSizePixel = 0

SettingPage.ScrollBarThickness = 3
SettingPage.CanvasSize = UDim2.new(0, 0, 0, 100)

SettingPage.Visible = false

SettingPage.Parent = ContentArea

local SettingLayout = Instance.new("UIListLayout")

SettingLayout.Padding = UDim.new(0, 8)
SettingLayout.Parent = SettingPage

--==================================================
-- TAB BUTTONS
--==================================================

local FarmTabBtn = Instance.new("TextButton")
local CharTabBtn = Instance.new("TextButton")
local SettingTabBtn = Instance.new("TextButton")

local function StyleTabButton(button, text)

    button.Size = UDim2.new(1, -16, 0, 36)

    button.Text = "  " .. text

    button.Font = Enum.Font.GothamMedium
    button.TextSize = 13

    button.TextColor3 = Color3.fromRGB(160, 160, 180)

    button.BackgroundColor3 = Color3.fromRGB(28, 28, 38)

    button.TextXAlignment = Enum.TextXAlignment.Left

    button.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

end

StyleTabButton(FarmTabBtn, "Auto Farm")
StyleTabButton(CharTabBtn, "Character")
StyleTabButton(SettingTabBtn, "Settings")

--==================================================
-- TAB SWITCH
--==================================================

local function SwitchPage(activePage, activeButton)

    FarmPage.Visible = activePage == FarmPage
    CharPage.Visible = activePage == CharPage
    SettingPage.Visible = activePage == SettingPage

    FarmTabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    FarmTabBtn.TextColor3 = Color3.fromRGB(160, 160, 180)

    CharTabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    CharTabBtn.TextColor3 = Color3.fromRGB(160, 160, 180)

    SettingTabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    SettingTabBtn.TextColor3 = Color3.fromRGB(160, 160, 180)

    activeButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    activeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

end

FarmTabBtn.MouseButton1Click:Connect(function()
    SwitchPage(FarmPage, FarmTabBtn)
end)

CharTabBtn.MouseButton1Click:Connect(function()
    SwitchPage(CharPage, CharTabBtn)
end)

SettingTabBtn.MouseButton1Click:Connect(function()
    SwitchPage(SettingPage, SettingTabBtn)
end)

SwitchPage(FarmPage, FarmTabBtn)

--==================================================
-- KEY VERIFICATION
--==================================================

SubmitBtn.MouseButton1Click:Connect(function()

    local enteredKey = tostring(KeyBox.Text)

    if enteredKey == CORRECT_KEY then

        safeDestroy(KeyFrame)

        MainFrame.Visible = true

    else

        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Wrong Key! Try Again"

        TweenService:Create(
            KeyBox,
            TweenInfo.new(0.1),
            {
                BackgroundColor3 = Color3.fromRGB(231, 76, 60)
            }
        ):Play()

        task.wait(0.3)

        if KeyBox and KeyBox.Parent then

            TweenService:Create(
                KeyBox,
                TweenInfo.new(0.2),
                {
                    BackgroundColor3 = Color3.fromRGB(28, 28, 38)
                }
            ):Play()

        end

    end

end)

--==================================================
-- ANTI AFK
--==================================================

local antiAfkConnection

local function SetAntiAFK(state)

    flags.AntiAfk = state

    if antiAfkConnection then
        pcall(function()
            antiAfkConnection:Disconnect()
        end)

        antiAfkConnection = nil
    end

    if not state then
        return
    end

    -- ใช้ getconnections ถ้า executor รองรับ
    local success = pcall(function()

        for _, connection in pairs(getconnections(player.Idled)) do
            connection:Disable()
        end

    end)

    -- Fallback สำหรับกรณีที่ getconnections ใช้งานไม่ได้
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

--==================================================
-- TOGGLE CREATOR
--==================================================

local function CreateToggle(parentPage, flagKey, labelText)

    local Row = Instance.new("Frame")

    Row.Size = UDim2.new(1, -6, 0, 42)

    Row.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    Row.BorderSizePixel = 0

    Row.Parent = parentPage

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 6)
    RowCorner.Parent = Row

    -- Label

    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(1, -65, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)

    Label.Text = labelText

    Label.Font = Enum.Font.Gotham
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 13

    Label.TextXAlignment = Enum.TextXAlignment.Left

    Label.BackgroundTransparency = 1

    Label.Parent = Row

    -- Toggle Button

    local TglBtn = Instance.new("TextButton")

    TglBtn.Size = UDim2.new(0, 44, 0, 22)
    TglBtn.Position = UDim2.new(1, -52, 0.5, -11)

    TglBtn.Text = ""

    TglBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)

    TglBtn.Parent = Row

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 11)
    ToggleCorner.Parent = TglBtn

    -- Circle

    local Circle = Instance.new("Frame")

    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 3, 0.5, -8)

    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    Circle.Parent = TglBtn

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    -- UI update

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

    -- Click

    TglBtn.MouseButton1Click:Connect(function()

        if flagKey == "AntiAfk" then

            SetAntiAFK(not flags.AntiAfk)

            UpdateUI(flags.AntiAfk)

        else

            flags[flagKey] = not flags[flagKey]

            UpdateUI(flags[flagKey])

        end

    end)

    UpdateUI(flags[flagKey])

end

--==================================================
-- CREATE TOGGLES
--==================================================

CreateToggle(
    FarmPage,
    "AutoEgg",
    "เก็บไข่อัตโนมัติ (ข้าม Lucky)"
)

CreateToggle(
    FarmPage,
    "AutoCollect",
    "เก็บเงินอัตโนมัติ"
)

CreateToggle(
    FarmPage,
    "AutoDeposit",
    "ส่งไข่อัตโนมัติ"
)

CreateToggle(
    FarmPage,
    "AutoBuyChicken",
    "ซื้อไก่อัตโนมัติ (ทีละ 5)"
)

CreateToggle(
    FarmPage,
    "AutoDiscardLucky",
    "ทิ้ง Lucky Block"
)

CreateToggle(
    FarmPage,
    "AutoOpenLucky",
    "เปิด Lucky Block ออโต้"
)

CreateToggle(
    CharPage,
    "SpeedEnabled",
    "เปิดวิ่งเร็ว (WalkSpeed)"
)

CreateToggle(
    CharPage,
    "JumpEnabled",
    "เปิดกระโดดสูง (JumpPower)"
)

CreateToggle(
    CharPage,
    "InfJump",
    "กระโดดไม่จำกัด (Infinite Jump)"
)

CreateToggle(
    SettingPage,
    "AntiAfk",
    "ป้องกันหลุด (Anti-AFK)"
)

--==================================================
-- INFINITE JUMP
--==================================================

UserInputService.JumpRequest:Connect(function()

    if not flags.InfJump then
        return
    end

    local character, humanoid = getCharacter()

    if humanoid then

        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)

    end

end)

--==================================================
-- CHARACTER MODS
--==================================================

task.spawn(function()

    while task.wait(0.2) do

        local character, humanoid = getCharacter()

        if humanoid then

            if flags.SpeedEnabled then

                pcall(function()
                    humanoid.WalkSpeed = customSpeed
                end)

            end

            if flags.JumpEnabled then

                pcall(function()

                    humanoid.UseJumpPower = true
                    humanoid.JumpPower = customJump

                end)

            end

        end

    end

end)

--==================================================
-- AUTO FARM LOOP
--==================================================

task.spawn(function()

    while task.wait(0.4) do

        local character, humanoid, hrp = getCharacter()

        if not character or not hrp then
            continue
        end

        --==================================================
        -- AUTO EGG
        --==================================================

        if flags.AutoEgg then

            pcall(function()

                local eggsFolder = workspace:FindFirstChild("Eggs")

                if not eggsFolder then
                    return
                end

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

            end)

        end

        --==================================================
        -- AUTO COLLECT MONEY
        --==================================================

        if flags.AutoCollect then

            pcall(function()

                local plots = workspace:FindFirstChild("Plots")

                if not plots then
                    return
                end

                local plot = plots:FindFirstChild(PLOT_NAME)

                if not plot then
                    return
                end

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

            end)

        end

        --==================================================
        -- AUTO DEPOSIT
        --==================================================

        if flags.AutoDeposit then

            pcall(function()

                local plots = workspace:FindFirstChild("Plots")

                if not plots then
                    return
                end

                local plot = plots:FindFirstChild(PLOT_NAME)

                if not plot then
                    return
                end

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

            end)

        end

        --==================================================
        -- AUTO BUY CHICKEN
        --==================================================

        if flags.AutoBuyChicken then

            pcall(function()

                local plots = workspace:FindFirstChild("Plots")

                if not plots then
                    return
                end

                local plot = plots:FindFirstChild(PLOT_NAME)

                if not plot then
                    return
                end

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

            end)

        end

        --==================================================
        -- AUTO DISCARD LUCKY
        --==================================================

        if flags.AutoDiscardLucky then

            pcall(function()

                local paper = ReplicatedStorage:FindFirstChild("Paper")

                if not paper then
                    return
                end

                local remotes = paper:FindFirstChild("Remotes")

                if not remotes then
                    return
                end

                local remoteEvent =
                    remotes:FindFirstChild("__remoteevent")

                if remoteEvent and remoteEvent:IsA("RemoteEvent") then

                    remoteEvent:FireServer(
                        "Discard Lucky Block"
                    )

                end

            end)

        end

        --==================================================
        -- AUTO OPEN LUCKY
        --==================================================

        if flags.AutoOpenLucky then

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

                local remoteFunc =
                    remotes:FindFirstChild("__remotefunction")

                if remoteFunc and remoteFunc:IsA("RemoteFunction") then

                    remoteFunc:InvokeServer(
                        "Open Lucky Block"
                    )

                end

            end)

        end

    end

end)

--==================================================
-- CHARACTER RESPAWN HANDLING
--==================================================

player.CharacterAdded:Connect(function(character)

    task.wait(1)

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    if flags.SpeedEnabled then

        pcall(function()
            humanoid.WalkSpeed = customSpeed
        end)

    end

    if flags.JumpEnabled then

        pcall(function()

            humanoid.UseJumpPower = true
            humanoid.JumpPower = customJump

        end)

    end

end)

--==================================================
-- INITIALIZE
--==================================================

print("YoutubeStyleHub loaded successfully.")
print("Key: " .. CORRECT_KEY)
