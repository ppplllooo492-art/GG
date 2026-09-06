local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
-- 1. ทำลาย GUI เก่าที่อาจค้างอยู่
-- ==========================================

local oldGui = PlayerGui:FindFirstChild("MamboHub_MainUI")

if oldGui then
    oldGui:Destroy()
end

-- ==========================================
-- 2. สร้าง ScreenGui หลัก
-- ==========================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MamboHub_MainUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- ==========================================
-- 3. Main Frame
-- ==========================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 14, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 180)
MainStroke.Thickness = 1.2
MainStroke.Transparency = 0.4
MainStroke.Parent = MainFrame

-- ==========================================
-- 4. Top Bar
-- ==========================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 20, 29)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 1)
TopLine.Position = UDim2.new(0, 0, 1, -1)
TopLine.BackgroundColor3 = Color3.fromRGB(30, 33, 45)
TopLine.BorderSizePixel = 0
TopLine.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "BHK2_Mambo | ค่ายสคริปต์หลัก"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.RobotoMono
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- ปุ่มปิด

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseButton"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -34, 0, 4)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.Parent = TopBar

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

CloseBtn.MouseEnter:Connect(function()
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
end)

CloseBtn.MouseLeave:Connect(function()
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
end)

-- ==========================================
-- 5. Sidebar
-- ==========================================

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 130, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 17, 24)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(1, -1, 0, 0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(30, 33, 45)
SidebarLine.BorderSizePixel = 0
SidebarLine.Parent = Sidebar

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -6, 1, -10)
TabContainer.Position = UDim2.new(0, 3, 0, 5)
TabContainer.BackgroundTransparency = 1
TabContainer.BorderSizePixel = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.ScrollBarThickness = 0
TabContainer.Parent = Sidebar

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 4)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabContainer

TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabContainer.CanvasSize = UDim2.new(
        0,
        0,
        0,
        TabList.AbsoluteContentSize.Y + 10
    )
end)

-- ==========================================
-- 6. Page Container
-- ==========================================

local PageContainer = Instance.new("Frame")
PageContainer.Name = "PageContainer"
PageContainer.Size = UDim2.new(1, -145, 1, -48)
PageContainer.Position = UDim2.new(0, 140, 0, 43)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

local Pages = {}
local CurrentPage = nil

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")

    page.Name = name .. "_Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 180)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.Parent = PageContainer

    local pageList = Instance.new("UIListLayout")
    pageList.Padding = UDim.new(0, 6)
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    pageList.Parent = page

    pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(
            0,
            0,
            0,
            pageList.AbsoluteContentSize.Y + 5
        )
    end)

    Pages[name] = page

    return page
end

local function SwitchTab(name, button)
    for _, page in pairs(Pages) do
        page.Visible = false
    end

    for _, b in ipairs(TabContainer:GetChildren()) do
        if b:IsA("TextButton") then
            TweenService:Create(
                b,
                TweenInfo.new(0.2),
                {
                    BackgroundColor3 = Color3.fromRGB(20, 21, 30),
                    TextColor3 = Color3.fromRGB(160, 160, 170)
                }
            ):Play()

            local stroke = b:FindFirstChild("BtnStroke")

            if stroke then
                stroke.Enabled = false
            end
        end
    end

    local targetPage = Pages[name]

    if not targetPage then
        return
    end

    targetPage.Visible = true

    TweenService:Create(
        button,
        TweenInfo.new(0.2),
        {
            BackgroundColor3 = Color3.fromRGB(24, 27, 38),
            TextColor3 = Color3.fromRGB(0, 255, 180)
        }
    ):Play()

    local activeStroke = button:FindFirstChild("BtnStroke")

    if activeStroke then
        activeStroke.Enabled = true
    end
end

local function AddTab(name)
    local btn = Instance.new("TextButton")

    btn.Name = name .. "_Tab"
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(20, 21, 30)
    btn.BorderSizePixel = 0
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(160, 160, 170)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = TabContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Name = "BtnStroke"
    btnStroke.Color = Color3.fromRGB(0, 255, 180)
    btnStroke.Thickness = 1
    btnStroke.Enabled = false
    btnStroke.Parent = btn

    local targetPage = CreatePage(name)

    btn.MouseButton1Click:Connect(function()
        SwitchTab(name, btn)
    end)

    if not CurrentPage then
        CurrentPage = name
        SwitchTab(name, btn)
    end

    return targetPage
end

-- ==========================================
-- 7. UI Components
-- ==========================================

local function AddToggle(page, text, default, callback)
    local toggleFrame = Instance.new("Frame")

    toggleFrame.Size = UDim2.new(1, -10, 0, 38)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggleFrame

    local label = Instance.new("TextLabel")

    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local box = Instance.new("TextButton")

    box.Size = UDim2.new(0, 36, 0, 20)
    box.Position = UDim2.new(1, -48, 0.5, -10)
    box.BackgroundColor3 = default
        and Color3.fromRGB(0, 255, 180)
        or Color3.fromRGB(40, 43, 55)

    box.Text = ""
    box.AutoButtonColor = false
    box.Parent = toggleFrame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(1, 0)
    boxCorner.Parent = box

    local circle = Instance.new("Frame")

    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = default
        and UDim2.new(1, -17, 0.5, -7)
        or UDim2.new(0, 3, 0.5, -7)

    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    circle.Parent = box

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    local state = default

    box.MouseButton1Click:Connect(function()
        state = not state

        local targetPos

        if state then
            targetPos = UDim2.new(1, -17, 0.5, -7)
        else
            targetPos = UDim2.new(0, 3, 0.5, -7)
        end

        local targetColor

        if state then
            targetColor = Color3.fromRGB(0, 255, 180)
        else
            targetColor = Color3.fromRGB(40, 43, 55)
        end

        TweenService:Create(
            circle,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {
                Position = targetPos
            }
        ):Play()

        TweenService:Create(
            box,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad),
            {
                BackgroundColor3 = targetColor
            }
        ):Play()

        if callback then
            callback(state)
        end
    end)

    return toggleFrame
end

local function AddButton(page, text, color, callback)
    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = color or Color3.fromRGB(0, 255, 180)

    if color == nil then
        btn.TextColor3 = Color3.fromRGB(15, 15, 20)
    else
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    btn.Text = text
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(
            btn,
            TweenInfo.new(0.15),
            {
                BackgroundTransparency = 0.1
            }
        ):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(
            btn,
            TweenInfo.new(0.15),
            {
                BackgroundTransparency = 0
            }
        ):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)

    return btn
end

-- ==========================================
-- 8. สร้าง Tabs
-- ==========================================

local PageMain = AddTab("หน้าหลัก")
local PagePlayer = AddTab("ผู้เล่น")
local PageESP = AddTab("ESP")
local PageTeleport = AddTab("ดูดของ")
local PageTP = AddTab("TP")
local PageFling = AddTab("Fling")

-- ==========================================
-- 9. หน้าหลัก
-- ==========================================

AddToggle(
    PageMain,
    "เก็บปืนอัตโนมัติ",
    false,
    function(state)
        print("ระบบเก็บปืนอัตโนมัติ:", state)
    end
)

AddButton(
    PageMain,
    "ปืนฆาตกร",
    Color3.fromRGB(219, 68, 85),
    function()
        print("รันปืนฆาตกร")
    end
)

AddButton(
    PageMain,
    "ปืนนายอำเภอ",
    Color3.fromRGB(59, 130, 246),
    function()
        print("รันปืนนายอำเภอ")
    end
)

AddToggle(
    PageMain,
    "กันปลิว",
    false,
    function(state)
        print("ระบบกันปลิว:", state)
    end
)

-- ==========================================
-- 10. ผู้เล่น
-- ==========================================

AddToggle(
    PagePlayer,
    "เดินเร็วพิเศษ (Speed)",
    false,
    function(state)
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = state and 50 or 16
        end
    end
)

AddToggle(
    PagePlayer,
    "กระโดดสูง (Jump)",
    false,
    function(state)
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.JumpPower = state and 100 or 50
        end
    end
)

-- ==========================================
-- 11. ESP
-- ==========================================

AddToggle(
    PageESP,
    "เปิด ESP ผู้เล่นทั้งหมด",
    false,
    function(state)
        print("ESP ผู้เล่น:", state)
    end
)

AddToggle(
    PageESP,
    "เปิด ESP ไอเทมกล่อง",
    false,
    function(state)
        print("ESP ไอเทม:", state)
    end
)

-- ==========================================
-- 12. ดูดของ
-- ==========================================

AddToggle(
    PageTeleport,
    "ดูดเหรียญทองอัตโนมัติ",
    false,
    function(state)
        print("ดูดเหรียญทอง:", state)
    end
)

-- ==========================================
-- 13. TP
-- ==========================================

AddButton(
    PageTP,
    "Teleport ไปหา ฆาตกร",
    Color3.fromRGB(30, 32, 45),
    function()
        print("Teleport ไปหาฆาตกร")
    end
)

AddButton(
    PageTP,
    "Teleport ไปหา นายอำเภอ",
    Color3.fromRGB(30, 32, 45),
    function()
        print("Teleport ไปหานายอำเภอ")
    end
)

-- ==========================================
-- 14. Fling
-- ==========================================

AddToggle(
    PageFling,
    "เปิดใช้งาน Fling รอบตัว",
    false,
    function(state)
        print("Fling:", state)
    end
)

-- ==========================================
-- 15. ระบบลาก GUI
-- ==========================================

local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart

        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

print("MamboHub UI loaded successfully.")
