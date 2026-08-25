-- [[ =========================================================
     PREMIUM HUB X - FIXED FULL VERSION
     Roblox Lua / Mobile + PC UI
     ========================================================= ]]

-- =========================================================
-- 0. SERVICES
-- =========================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- =========================================================
-- 1. CLEAN OLD GUI
-- =========================================================

pcall(function()
    local oldGui = playerGui:FindFirstChild("PremiumHubX")
    if oldGui then
        oldGui:Destroy()
    end
end)

-- =========================================================
-- 2. ANTI AFK
-- =========================================================

pcall(function()
    if getconnections then
        for _, connection in pairs(player.Idled:GetConnections()) do
            pcall(function()
                connection:Disable()
            end)
        end

        print("[PremiumHubX] Anti AFK Enabled!")
    end
end)

-- =========================================================
-- 3. SCREEN GUI
-- =========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumHubX"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- =========================================================
-- 4. MAIN FRAME
-- =========================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -210)
MainFrame.Size = UDim2.new(0, 550, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 255, 170)
UIStroke.Parent = MainFrame

-- =========================================================
-- 5. LEFT PANEL
-- =========================================================

local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Parent = MainFrame
LeftPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
LeftPanel.BorderSizePixel = 0
LeftPanel.Size = UDim2.new(0, 160, 1, 0)

local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 12)
LeftCorner.Parent = LeftPanel

-- =========================================================
-- 6. TITLE
-- =========================================================

local Title = Instance.new("TextLabel")
Title.Parent = LeftPanel
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 15)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "PREMIUM HUB"
Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.TextSize = 16

-- =========================================================
-- 7. TAB CONTAINER
-- =========================================================

local TabContainer = Instance.new("Frame")
TabContainer.Parent = LeftPanel
TabContainer.BackgroundTransparency = 1
TabContainer.Position = UDim2.new(0.05, 0, 0.18, 0)
TabContainer.Size = UDim2.new(0.9, 0, 0.8, 0)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 10)

-- =========================================================
-- 8. RIGHT PANEL
-- =========================================================

local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Parent = MainFrame
RightPanel.BackgroundTransparency = 1
RightPanel.Position = UDim2.new(0, 170, 0, 15)
RightPanel.Size = UDim2.new(0, 365, 0, 390)

-- =========================================================
-- 9. PAGES
-- =========================================================

local Pages = {}

local function createPage(pageName)

    local Scroll = Instance.new("ScrollingFrame")

    Scroll.Name = pageName .. "Page"
    Scroll.Parent = RightPanel

    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0

    Scroll.Position = UDim2.new(0, 0, 0, 0)
    Scroll.Size = UDim2.new(1, 0, 1, 0)

    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

    Scroll.ScrollBarThickness = 3
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170)

    Scroll.Visible = false

    local List = Instance.new("UIListLayout")
    List.Parent = Scroll
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Padding = UDim.new(0, 8)

    Pages[pageName] = Scroll

    return Scroll
end

local MainFarmPage = createPage("MainFarm")
local MovementPage = createPage("Movement")
local AutoWinPage = createPage("AutoWin")

-- =========================================================
-- 10. PAGE SWITCH
-- =========================================================

local function showPage(pageName)

    for name, page in pairs(Pages) do
        page.Visible = (name == pageName)
    end

end

-- =========================================================
-- 11. TAB BUTTON
-- =========================================================

local function createTabButton(text, pageTarget)

    local TabBtn = Instance.new("TextButton")

    TabBtn.Parent = TabContainer
    TabBtn.Size = UDim2.new(1, 0, 0, 35)

    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabBtn.BorderSizePixel = 0

    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.Text = text
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.TextSize = 13

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = TabBtn

    TabBtn.MouseButton1Click:Connect(function()

        for _, btn in pairs(TabContainer:GetChildren()) do

            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end

        end

        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
        TabBtn.TextColor3 = Color3.fromRGB(15, 15, 22)

        showPage(pageTarget)

    end)

    return TabBtn
end

-- =========================================================
-- 12. CREATE TABS
-- =========================================================

createTabButton("🔥 ฟาร์มหลัก & บอท", "MainFarm")
createTabButton("🏃 ความเร็ว & กระโดด", "Movement")
createTabButton("🏆 เก็บวีนด่าน 1-9", "AutoWin")

showPage("MainFarm")

-- =========================================================
-- 13. CHARACTER HELPER
-- =========================================================

local function getChar()

    return player.Character
        or player.CharacterAdded:Wait()

end

local function getHumanoid()

    local char = getChar()

    if not char then
        return nil
    end

    return char:FindFirstChildOfClass("Humanoid")

end

-- =========================================================
-- 14. SAFE TELEPORT
-- =========================================================

local function teleportToButton(target)

    if not target then
        return false
    end

    local char = getChar()

    if not char then
        return false
    end

    local root = char:FindFirstChild("HumanoidRootPart")

    if not root then
        return false
    end

    local success = pcall(function()

        if target:IsA("BasePart") then

            root.CFrame = target.CFrame + Vector3.new(0, 3, 0)

        elseif target:IsA("Model") then

            root.CFrame = target:GetPivot() + Vector3.new(0, 3, 0)

        end

    end)

    return success
end

-- =========================================================
-- 15. GENERIC TOGGLE SYSTEM
-- =========================================================

local ToggleStates = {}

local function createToggleButton(parentPage, text, defaultColor, callback)

    local Button = Instance.new("TextButton")

    Button.Parent = parentPage
    Button.Size = UDim2.new(0.95, 0, 0, 42)

    Button.BackgroundColor3 = defaultColor
    Button.BorderSizePixel = 0

    Button.Font = Enum.Font.GothamSemibold
    Button.Text = text .. " : ปิดการทำงาน"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    ToggleStates[Button] = false

    Button.MouseButton1Click:Connect(function()

        local newState = not ToggleStates[Button]

        ToggleStates[Button] = newState

        if newState then

            Button.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
            Button.Text = text .. " : กำลังทำงาน 🟢"

        else

            Button.BackgroundColor3 = defaultColor
            Button.Text = text .. " : ปิดการทำงาน"

        end

        task.spawn(function()

            pcall(function()
                callback(newState, Button)
            end)

        end)

    end)

    return Button
end

-- =========================================================
-- 16. ANTI AFK STATUS
-- =========================================================

local AntiAFKStatus = Instance.new("TextLabel")

AntiAFKStatus.Parent = MainFarmPage
AntiAFKStatus.Size = UDim2.new(0.95, 0, 0, 30)

AntiAFKStatus.BackgroundTransparency = 1

AntiAFKStatus.Font = Enum.Font.Gotham
AntiAFKStatus.Text =
    "🛡️ Anti AFK : เปิดใช้งานแล้ว"

AntiAFKStatus.TextColor3 = Color3.fromRGB(0, 255, 170)
AntiAFKStatus.TextSize = 12

-- =========================================================
-- 17. AUTO REBIRTH
-- =========================================================

local RebirthRunning = false

createToggleButton(
    MainFarmPage,
    "⚡ ระบบเกิดใหม่ (Auto Rebirth)",
    Color3.fromRGB(155, 89, 182),

    function(enabled)

        RebirthRunning = enabled

        if not enabled then
            return
        end

        while RebirthRunning do

            pcall(function()

                local Remotes = ReplicatedStorage:FindFirstChild("Remotes")

                if Remotes then

                    local Rebirth = Remotes:FindFirstChild("Rebirth")

                    if Rebirth and Rebirth:IsA("RemoteEvent") then
                        Rebirth:FireServer()
                    end

                end

            end)

            task.wait(0.5)

        end

    end
)

-- =========================================================
-- 18. MOVEMENT
-- =========================================================

local MovementConnection = nil
local MovementEnabled = false

local DEFAULT_SPEED = 16
local DEFAULT_JUMP = 50

local CUSTOM_SPEED = 500
local CUSTOM_JUMP = 350

createToggleButton(
    MovementPage,
    "🏃 ความเร็วแสง & กระโดดสูง",
    Color3.fromRGB(230, 126, 34),

    function(enabled)

        MovementEnabled = enabled

        -- OFF
        if not enabled then

            if MovementConnection then
                MovementConnection:Disconnect()
                MovementConnection = nil
            end

            pcall(function()

                local hum = getHumanoid()

                if hum then
                    hum.WalkSpeed = DEFAULT_SPEED
                    hum.JumpPower = DEFAULT_JUMP
                end

            end)

            return
        end

        -- ป้องกัน connection ซ้ำ
        if MovementConnection then
            MovementConnection:Disconnect()
            MovementConnection = nil
        end

        MovementConnection = RunService.Heartbeat:Connect(function()

            if not MovementEnabled then
                return
            end

            pcall(function()

                local hum = getHumanoid()

                if hum then

                    hum.WalkSpeed = CUSTOM_SPEED
                    hum.JumpPower = CUSTOM_JUMP

                end

            end)

        end)

    end
)

-- =========================================================
-- 19. STAGE FINDER
-- =========================================================

local function findStageButton(stageNumber)

    local success, result = pcall(function()

        local Map = workspace:FindFirstChild("Map")

        if not Map then
            return nil
        end

        local World1 = Map:FindFirstChild("World1")

        if not World1 then
            return nil
        end

        local StagesFolder = World1:FindFirstChild("Stages")

        if not StagesFolder then
            return nil
        end

        local Stage = StagesFolder:FindFirstChild(
            "Stage" .. tostring(stageNumber)
        )

        if not Stage then
            return nil
        end

        -- ด่าน 1 ใช้ Main/StageEnd/Button
        if stageNumber == 1 then

            local Main = Stage:FindFirstChild("Main")

            if Main then

                local StageEnd = Main:FindFirstChild("StageEnd")

                if StageEnd then
                    return StageEnd:FindFirstChild("Button")
                end

            end

        end

        -- ด่าน 2-9 ใช้ NormalWin/Button
        local NormalWin = Stage:FindFirstChild("NormalWin")

        if NormalWin then
            return NormalWin:FindFirstChild("Button")
        end

        return nil

    end)

    if success then
        return result
    end

    return nil
end

-- =========================================================
-- 20. AUTO WIN STATES
-- =========================================================

local StageRunning = {}

-- =========================================================
-- 21. CREATE AUTO WIN BUTTONS
-- =========================================================

for stageNumber = 1, 9 do

    local stageText =
        "🏆 วาปไปเก็บสถิติวีน [ด่าน " ..
        tostring(stageNumber) ..
        "]"

    local stageColor = Color3.fromRGB(45, 52, 54)

    createToggleButton(
        AutoWinPage,
        stageText,
        stageColor,

        function(enabled)

            StageRunning[stageNumber] = enabled

            if not enabled then
                return
            end

            while StageRunning[stageNumber] do

                local target = findStageButton(stageNumber)

                if target then
                    teleportToButton(target)
                end

                task.wait(0.15)

            end

        end
    )

end

-- =========================================================
-- 22. MINI TOGGLE BUTTON
-- =========================================================

local ToggleUI = Instance.new("ImageButton")

ToggleUI.Name = "MiniToggle"
ToggleUI.Parent = ScreenGui

ToggleUI.Size = UDim2.new(0, 50, 0, 50)

ToggleUI.Position = UDim2.new(
    0.02,
    0,
    0.4,
    0
)

ToggleUI.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ToggleUI.BorderSizePixel = 0

ToggleUI.Image = "rbxassetid://6031243531"
ToggleUI.ImageColor3 = Color3.fromRGB(0, 255, 170)

ToggleUI.AutoButtonColor = true

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleUI

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(0, 255, 170)
ToggleStroke.Parent = ToggleUI

-- =========================================================
-- 23. MINI BUTTON SHOW / HIDE
-- =========================================================

ToggleUI.MouseButton1Click:Connect(function()

    MainFrame.Visible = not MainFrame.Visible

end)

-- =========================================================
-- 24. DRAG MINI BUTTON
-- =========================================================

local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragStart = nil
local startPos = nil

ToggleUI.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = ToggleUI.Position

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local delta = input.Position - dragStart

    ToggleUI.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )

end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false

    end

end)

-- =========================================================
-- 25. CHARACTER RESPAWN RESET
-- =========================================================

player.CharacterAdded:Connect(function()

    task.wait(1)

    if MovementEnabled then

        pcall(function()

            local hum = getHumanoid()

            if hum then
                hum.WalkSpeed = CUSTOM_SPEED
                hum.JumpPower = CUSTOM_JUMP
            end

        end)

    end

end)

-- =========================================================
-- 26. INITIAL STATE
-- =========================================================

MainFrame.Visible = true
ToggleUI.Visible = true

print("[PremiumHubX] Loaded Successfully!")
print("[PremiumHubX] Anti AFK : Ready")
print("[PremiumHubX] MainFarm : Ready")
print("[PremiumHubX] Movement : Ready")
print("[PremiumHubX] AutoWin : Ready")
