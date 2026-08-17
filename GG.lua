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
    JumpEnabled = false,
}

local CORRECT_KEY = "GG.GR"

local customSpeed = 24
local customJump = 50

--==================================================
-- CLEAN OLD GUI
--==================================================

local existingGui =
    CoreGui:FindFirstChild("YoutubeStyleHub")
    or PlayerGui:FindFirstChild("YoutubeStyleHub")

if existingGui then
    existingGui:Destroy()
end

--==================================================
-- HELPER FUNCTIONS
--==================================================

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
    return player.Character
end

local function getHumanoid()
    local character = getCharacter()

    if not character then
        return nil
    end

    return character:FindFirstChildOfClass("Humanoid")
end

local function getRootPart()
    local character = getCharacter()

    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

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

    -- Executor environments that support getconnections()
    local success = pcall(function()
        if typeof(getconnections) == "function" then
            for _, connection in ipairs(getconnections(player.Idled)) do
                pcall(function()
                    connection:Disable()
                end)
            end
        else
            error("getconnections unavailable")
        end
    end)

    -- Fallback for environments without getconnections()
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
-- CREATE SCREEN GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YoutubeStyleHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local guiParent = PlayerGui

pcall(function()
    ScreenGui.Parent = CoreGui

    if not ScreenGui.Parent then
        ScreenGui.Parent = PlayerGui
    end
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = guiParent
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

-- Key top

local KeyTop = Instance.new("Frame")
KeyTop.Size = UDim2.new(1, 0, 0, 35)
KeyTop.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
KeyTop.BorderSizePixel = 0
KeyTop.Parent = KeyFrame

local KeyTopCorner = Instance.new("UICorner")
KeyTopCorner.CornerRadius = UDim.new(0, 10)
KeyTopCorner.Parent = KeyTop

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, -20, 1, 0)
KeyTitle.Position = UDim2.new(0, 12, 0, 0)
KeyTitle.Text = "🔑 KEY SYSTEM REQUIRED"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 14
KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
KeyTitle.BackgroundTransparency = 1
KeyTitle.Parent = KeyTop

-- Key textbox

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

-- Submit

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

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -95, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.Text = "⚡ YOUTUBE HUB | CHICKEN FARM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- Close button

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
    ScreenGui:Destroy()
end)

-- Minimize button

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
        if child ~= TopBar
            and not child:IsA("UICorner") then

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
-- PAGES
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

local function StyleTabButton(btn, text)
    btn.Size = UDim2.new(1, -16, 0, 36)
    btn.Text = "  " .. text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(160, 160, 180)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
end

StyleTabButton(FarmTabBtn, "🌾 Auto Farm")
StyleTabButton(CharTabBtn, "🏃 Character")
StyleTabButton(SettingTabBtn, "⚙️ Settings")

--==================================================
-- TAB SWITCHING
--==================================================

local function SwitchPage(activePage, activeBtn)
    FarmPage.Visible = activePage == FarmPage
    CharPage.Visible = activePage == CharPage
    SettingPage.Visible = activePage == SettingPage

    local buttons = {
        FarmTabBtn,
        CharTabBtn,
        SettingTabBtn
    }

    for _, btn in ipairs(buttons) do
        btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        btn.TextColor3 = Color3.fromRGB(160, 160, 180)
    end

    activeBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    activeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
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

    local TglBtn = Instance.new("TextButton")
    TglBtn.Size = UDim2.new(0, 44, 0, 22)
    TglBtn.Position = UDim2.new(1, -52, 0.5, -11)
    TglBtn.Text = ""
    TglBtn.AutoButtonColor = false
    TglBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    TglBtn.Parent = Row

    local TglCorner = Instance.new("UICorner")
    TglCorner.CornerRadius = UDim.new(0, 11)
    TglCorner.Parent = TglBtn

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
            SetAntiAFK(not flags.AntiAfk)
        else
            flags[flagKey] = not flags[flagKey]
        end

        UpdateUI(flags[flagKey])
    end)

    UpdateUI(flags[flagKey])
end

--==================================================
-- CREATE TOGGLES
--==================================================

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

CreateToggle(
    FarmPage,
    "AutoOpenLucky",
    "🎁 เปิด Lucky Block ออโต้"
)

CreateToggle(
    CharPage,
    "SpeedEnabled",
    "⚡ เปิดวิ่งเร็ว (WalkSpeed)"
)

CreateToggle(
    CharPage,
    "JumpEnabled",
    "🦘 เปิดกระโดดสูง (JumpPower)"
)

CreateToggle(
    CharPage,
    "InfJump",
    "🚀 กระโดดไม่จำกัด (Infinite Jump)"
)

CreateToggle(
    SettingPage,
    "AntiAfk",
    "💤 ป้องกันหลุด (Anti-AFK)"
)

--==================================================
-- KEY VERIFICATION
--==================================================

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CORRECT_KEY then
        KeyFrame:Destroy()
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

        TweenService:Create(
            KeyBox,
            TweenInfo.new(0.2),
            {
                BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            }
        ):Play()
    end
end)

--==================================================
-- CHARACTER MODS
--==================================================

UserInputService.JumpRequest:Connect(function()
    if not flags.InfJump then
        return
    end

    local humanoid = getHumanoid()

    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        local humanoid = getHumanoid()

        if humanoid then
            if flags.SpeedEnabled then
                humanoid.WalkSpeed = customSpeed
            end

            if flags.JumpEnabled then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = customJump
            end
        end
    end
end)

--==================================================
-- AUTO FARM LOOP
--==================================================

task.spawn(function()
    while task.wait(0.4) do
        local hrp = getRootPart()

        if not hrp then
            continue
        end

        --==================================================
        -- AUTO EGG
        --==================================================

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

        --==================================================
        -- GET PLAYER PLOT
        --==================================================

        local plots = workspace:FindFirstChild("Plots")
        local plot = plots and plots:FindFirstChild("BBBR17k")

        --==================================================
        -- AUTO COLLECT
        --==================================================

        if flags.AutoCollect and plot then
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

        --==================================================
        -- AUTO DEPOSIT
        --==================================================

        if flags.AutoDeposit and plot then
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

        --==================================================
        -- AUTO BUY CHICKEN
        --==================================================

        if flags.AutoBuyChicken and plot then
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
-- RESET CHARACTER SETTINGS AFTER RESPAWN
--==================================================

player.CharacterAdded:Connect(function(character)
    task.wait(1)

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    if flags.SpeedEnabled then
        humanoid.WalkSpeed = customSpeed
    end

    if flags.JumpEnabled then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = customJump
    end
end)
