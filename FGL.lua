-- [[ CYBERPUNK CUSTOM HUB FRAMEWORK FOR DELTA EXECUTOR ]] --
-- Created for your custom Hub brand. Completely stripped of old UI.
-- Optimized for Delta Executor (Mobile & PC execution)

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Destroy existing UI if running again
if CoreGui:FindFirstChild("CyberHubTemplate") then
    CoreGui:FindFirstChild("CyberHubTemplate"):Destroy()
end

-- UI Parent Setup
local CyberHubTemplate = Instance.new("ScreenGui")
CyberHubTemplate.Name = "CyberHubTemplate"
CyberHubTemplate.Parent = CoreGui
CyberHubTemplate.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (Cyberpunk Dark Neon Theme)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Fallback for delta mobile dragging
MainFrame.Parent = CyberHubTemplate

-- Corner Styling
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Neon Border Effect
local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 255, 200) -- Cyan Neon Glow
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "MY CUSTOM BRAND HUB" -- ** CHANGE YOUR HUB NAME HERE **
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    CyberHubTemplate:Destroy()
end)

-- Sidebar Navigation Layout
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 5)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Parent = Sidebar

-- Container Layout for Multi-Tabs
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -150, 1, -55)
Container.Position = UDim2.new(0, 145, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local tabs = {}
local activeTab = nil

local function CreateTab(tabName, order)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 120, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.TextSize = 14
    TabButton.LayoutOrder = order
    TabButton.Parent = Sidebar
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabButton
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.CanvasSize = UDim2.new(0, 0, 2, 0)
    Page.Parent = Container
    
    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 8)
    PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Parent = Page
    
    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Page.Visible = false
            t.Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            t.Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        end
        Page.Visible = true
        TabButton.TextColor3 = Color3.fromRGB(0, 255, 200)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 40, 50)
    end)
    
    tabs[tabName] = {Btn = TabButton, Page = Page}
    return Page
end

-- Helper Functions to add elements inside tab pages
local function AddButton(page, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 360, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.Parent = page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1
    Stroke.Color = Color3.fromRGB(50, 50, 70)
    Stroke.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

local function AddToggle(page, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 360, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    ToggleFrame.Parent = page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local TglBtn = Instance.new("TextButton")
    TglBtn.Size = UDim2.new(0, 45, 0, 24)
    TglBtn.Position = UDim2.new(1, -60, 0.5, -12)
    TglBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    TglBtn.Text = ""
    TglBtn.Parent = ToggleFrame
    
    local TglCorner = Instance.new("UICorner")
    TglCorner.CornerRadius = UDim.new(0, 12)
    TglCorner.Parent = TglBtn
    
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 18, 0, 18)
    Dot.Position = UDim2.new(0, 3, 0.5, -9)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.Parent = TglBtn
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(0, 9)
    DotCorner.Parent = Dot
    
    local enabled = false
    TglBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(TglBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 200)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
        else
            TweenService:Create(TglBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
        end
        pcall(callback, enabled)
    end)
end

-- ==========================================
-- 🛠️ [PLACE YOUR EXISTING FUNCTIONS HERE] 🛠️
-- ==========================================

local function ExampleAutofarmFunction(state)
    -- Put your main script logic inside functions like this
    _G.Autofarm = state
    while _G.Autofarm do
        task.wait(1)
        print("Autofarming active...")
    end
end

local function ExampleTeleportFunction()
    -- Put your teleport script logic here
    print("Teleporting player...")
end


-- ==========================================
-- 🎛️ BUTTONS & TOGGLES SETUP
-- ==========================================

-- Tab 1: Main Features
local MainTabPage = CreateTab("Main Farm", 1)
AddToggle(MainTabPage, "Enable Autofarm", function(value)
    task.spawn(function()
        ExampleAutofarmFunction(value)
    end)
end)

-- Tab 2: Teleport
local TeleportTabPage = CreateTab("Teleports", 2)
AddButton(TeleportTabPage, "Teleport to Safe Zone", function()
    ExampleTeleportFunction()
end)

-- Tab 3: Misc/Settings
local MiscTabPage = CreateTab("Misc Settings", 3)
AddButton(MiscTabPage, "Destroy UI Entirely", function()
    CyberHubTemplate:Destroy()
end)

-- Default to opening the first tab
tabs["Main Farm"].Btn.TextColor3 = Color3.fromRGB(0, 255, 200)
tabs["Main Farm"].Btn.BackgroundColor3 = Color3.fromRGB(30, 40, 50)
tabs["Main Farm"].Page.Visible = true

-- Mobile-Friendly Dragging Optimization
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
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

TitleBar.InputChanged:Connect(function(input)
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
