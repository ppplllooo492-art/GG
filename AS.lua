-- ========================================================================
-- [ SPEED X HUB - NEW BRANDING PREMIUM SCRIPT HUB ]
-- ออกแบบระบบใหม่ทั้งหมดในรูปแบบค่ายสคริปต์ยอดนิยม รองรับตัวรัน Delta
-- ========================================================================

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

local SecureParent = (gethui and gethui()) or PlayerGui

-- สร้างหน้าต่างหลักของค่าย Speed x Hub
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "SpeedXHubGui"
MainGui.ResetOnSpawn = false
MainGui.Parent = SecureParent

-- โครงสร้างกรอบนอกสุดของค่าย (Main Hub Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = MainFrame

-- ขอบนีออนแดงตัดส้ม เพิ่มความแรงตามคอนเซ็ปต์ Speed x
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 30, 60)
mainStroke.Thickness = 2
mainStroke.Parent = MainFrame

local mainStrokeGrad = Instance.new("UIGradient")
mainStrokeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 30, 60)), -- แดงซิ่ง
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 90, 0))   -- ส้มสปอร์ต
})
mainStrokeGrad.Parent = mainStroke

-- ระบบลากหน้าต่างที่เสถียรบนมือถือสำหรับผู้ใช้ Delta
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==========================================
-- SIDEBAR: แถบเมนูด้านซ้ายและชื่อค่าย
-- ==========================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 14)
sidebarCorner.Parent = Sidebar

-- ตัวบังมุมขวาของ Sidebar ไม่ให้กลบความโค้งฝั่งซ้าย
local sideHide = Instance.new("Frame")
sideHide.Size = UDim2.new(0, 20, 1, 0)
sideHide.Position = UDim2.new(1, -20, 0, 0)
sideHide.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
sideHide.BorderSizePixel = 0
sideHide.Parent = Sidebar

-- ชื่อค่ายสคริปต์สุดเท่ "Speed x Hub"
local HubName = Instance.new("TextLabel")
HubName.Size = UDim2.new(1, 0, 0, 50)
HubName.Position = UDim2.new(0, 0, 0, 10)
HubName.BackgroundTransparency = 1
HubName.Text = "SPEED X HUB"
HubName.TextColor3 = Color3.fromRGB(255, 255, 255)
HubName.TextSize = 18
HubName.Font = Enum.Font.GothamBold
HubName.Parent = Sidebar

local nameGrad = Instance.new("UIGradient")
nameGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 200))
})
nameGrad.Parent = HubName

-- บรรจุภัณฑ์ปุ่มแท็บเมนู (Tab Container)
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, -10, 1, -70)
TabContainer.Position = UDim2.new(0, 5, 0, 65)
TabContainer.BackgroundTransparency = 1
TabContainer.BorderSizePixel = 0
TabContainer.ScrollBarThickness = 0
TabContainer.Parent = Sidebar

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = TabContainer

-- ==========================================
-- CONTENT: พื้นที่แสดงฟังก์ชันด้านขวา
-- ==========================================
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -170, 1, -20)
ContentContainer.Position = UDim2.new(0, 170, 0, 10)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- ฟังก์ชันสร้างหน้ารองรับระบบสลับแท็บ (Tab System Creator)
local tabs = {}
local contents = {}
local firstTab = true

local function AddTab(tabName)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 38)
    TabBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    TabBtn.BackgroundTransparency = firstTab and 0 or 1
    TabBtn.Text = tabName
    TabBtn.TextColor3 = firstTab and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 160)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 12
    TabBtn.Parent = TabContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = TabBtn
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Visible = firstTab
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(255, 30, 60)
    Page.Parent = ContentContainer
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.Parent = Page
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            TweenService:Create(t, TweenInfo.new(0.25), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 160)}):Play()
        end
        for _, p in pairs(contents) do
            p.Visible = false
        end
        TweenService:Create(TabBtn, TweenInfo.new(0.25), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        Page.Visible = true
    end)
    
    table.insert(tabs, TabBtn)
    table.insert(contents, Page)
    firstTab = false
    return Page
end

-- ==========================================
-- COMPONENTS: ฟังก์ชันการเพิ่มปุ่มและสวิตช์ในค่าย
-- ==========================================
local function AddButton(page, btnText, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 42)
    Button.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Button.Text = "  " .. btnText
    Button.TextColor3 = Color3.fromRGB(230, 230, 235)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 13
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = page
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = Button
    
    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Color3.fromRGB(40, 40, 50)
    bStroke.Thickness = 1
    bStroke.Parent = Button
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(bStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 30, 60)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 28), TextColor3 = Color3.fromRGB(230, 230, 235)}):Play()
        TweenService:Create(bStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 50)}):Play()
    end)
    
    Button.MouseButton1Click:Connect(callback)
end

local function AddToggle(page, toggleText, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 42)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    ToggleFrame.Parent = page
    
    local tfCorner = Instance.new("UICorner")
    tfCorner.CornerRadius = UDim.new(0, 8)
    tfCorner.Parent = ToggleFrame
    
    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -60, 1, 0)
    tLabel.Position = UDim2.new(0, 12, 0, 0)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = toggleText
    tLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
    tLabel.Font = Enum.Font.GothamMedium
    tLabel.TextSize = 13
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.Parent = ToggleFrame
    
    local ToggleSwitch = Instance.new("TextButton")
    ToggleSwitch.Size = UDim2.new(0, 36, 0, 20)
    ToggleSwitch.Position = UDim2.new(1, -48, 0.5, -10)
    ToggleSwitch.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ToggleSwitch.Text = ""
    ToggleSwitch.Parent = ToggleFrame
    
    local tsCorner = Instance.new("UICorner")
    tsCorner.CornerRadius = UDim.new(1, 0)
    tsCorner.Parent = ToggleSwitch
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 14, 0, 14)
    Circle.Position = UDim2.new(0, 3, 0.5, -7)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.Parent = ToggleSwitch
    
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = Circle
    
    local active = false
    ToggleSwitch.MouseButton1Click:Connect(function()
        active = not active
        if active then
            TweenService:Create(ToggleSwitch, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(255, 30, 60)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.25), {Position = UDim2.new(1, -17, 0.5, -7)}):Play()
        else
            TweenService:Create(ToggleSwitch, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.25), {Position = UDim2.new(0, 3, 0.5, -7)}):Play()
        end
        callback(active)
    end)
end

-- ==========================================
-- 🛠️ เริ่มต้นสร้างหน้าแท็บและปุ่มต่างๆ ในค่าย
-- ==========================================
local MainPage = AddTab("Main Features")
local PlayerPage = AddTab("Player Settings")
local CreditPage = AddTab("Credits")

-- ตัวอย่างปุ่มและสวิตช์ในหน้าหลัก (Main)
AddToggle(MainPage, "Auto Farm (เปิดฟังก์ชันฟาร์ม)", function(state)
    print("Auto Farm status:", state)
end)

AddButton(MainPage, "Teleport to Safe Zone (วาร์ปไปจุดปลอดภัย)", function()
    print("Teleported!")
end)

-- ตัวอย่างในหน้าผู้เล่น (Player)
AddButton(PlayerPage, "Speed Hack (เพิ่มความเร็ว)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    end
end)

-- หน้าผู้พัฒนา (Credits)
AddButton(CreditPage, "Owner: BHK2 Mambo", function() end)

-- ==========================================
-- ปุ่มลอยโลโก้ค่ายทรงสปอร์ต "Speed X" สำหรับเปิด-ปิดเมนูบน Delta
-- ==========================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "SpeedXToggleBtn"
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(0, 20, 0, 150)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
ToggleBtn.Text = "X"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 30, 60)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 22
ToggleBtn.Parent = MainGui

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(1, 0)
tCorner.Parent = ToggleBtn

local tStroke = Instance.new("UIStroke")
tStroke.Color = Color3.fromRGB(255, 30, 60)
tStroke.Thickness = 2
tStroke.Parent = ToggleBtn

-- ทำให้ปุ่มลอยลากเคลื่อนย้ายที่ได้บนจอมือถืออย่างนุ่มนวล
local tDragging, tDragStart, tStartPos
ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        tDragging = true
        tDragStart = input.Position
        tStartPos = ToggleBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and tDragging then
        local delta = input.Position - tDragStart
        ToggleBtn.Position = UDim2.new(tStartPos.X.Scale, tStartPos.X.Offset + delta.X, tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        tDragging = false 
    end
end)

-- ฟังก์ชันเปิด/ปิดหน้าต่าง Speed x Hub แบบนุ่มนวล
local isOpen = true
ToggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 550, 0, 350)}):Play()
    else
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 550, 0, 0)})
        closeTween:Play()
        closeTween.Completed:Connect(function() 
            if not isOpen then 
                MainFrame.Visible = false 
            end 
        end)
    end
end)
