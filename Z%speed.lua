local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local PlayerCountLabel = Instance.new("TextLabel")
local SidebarFrame = Instance.new("Frame")
local SidebarLayout = Instance.new("UIListLayout")
local ContentFrame = Instance.new("Frame")

local FarmTabButton = Instance.new("TextButton")
local CharmTabButton = Instance.new("TextButton")
local PlayerTabButton = Instance.new("TextButton")

local FarmPage = Instance.new("ScrollingFrame")
local CharmPage = Instance.new("ScrollingFrame")
local PlayerPage = Instance.new("ScrollingFrame")

local PageLayout1 = Instance.new("UIListLayout")
local PageLayout2 = Instance.new("UIListLayout")
local PageLayout3 = Instance.new("UIListLayout")

local DropdownContainer = Instance.new("ScrollingFrame")
local DropdownListLayout = Instance.new("UIListLayout")

-- GUI
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "SpeedFCHubPremium"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- TopBar
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

TitleLabel.Parent = TopBar
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "👤 speedFC.ค่าย"
TitleLabel.TextColor3 = Color3.fromRGB(0, 215, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

PlayerCountLabel.Parent = TopBar
PlayerCountLabel.Position = UDim2.new(0.5, 0, 0, 0)
PlayerCountLabel.Size = UDim2.new(0.5, -15, 1, 0)
PlayerCountLabel.BackgroundTransparency = 1
PlayerCountLabel.Text = "🎮 Server: 1/12 Players"
PlayerCountLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
PlayerCountLabel.Font = Enum.Font.SourceSansBold
PlayerCountLabel.TextSize = 15
PlayerCountLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Sidebar
SidebarFrame.Parent = MainFrame
SidebarFrame.Position = UDim2.new(0, 10, 0, 50)
SidebarFrame.Size = UDim2.new(0, 130, 1, -60)
SidebarFrame.BackgroundTransparency = 1

SidebarLayout.Parent = SidebarFrame
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 6)

-- Content
ContentFrame.Parent = MainFrame
ContentFrame.Position = UDim2.new(0, 155, 0, 55)
ContentFrame.Size = UDim2.new(1, -165, 1, -65)
ContentFrame.BackgroundTransparency = 1

local function setupPage(page, layout)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 480)
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    page.Visible = false
    page.Parent = ContentFrame

    layout.Parent = page
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
end

setupPage(FarmPage, PageLayout1)
setupPage(CharmPage, PageLayout2)
setupPage(PlayerPage, PageLayout3)

FarmPage.Visible = true

-- Dropdown
DropdownContainer.Parent = MainFrame
DropdownContainer.Position = UDim2.new(0.32, 0, 0.45, 0)
DropdownContainer.Size = UDim2.new(0.63, 0, 0, 130)
DropdownContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
DropdownContainer.Visible = false
DropdownContainer.ZIndex = 10
DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, 450)
DropdownContainer.ScrollBarThickness = 4

local DropdownStroke = Instance.new("UIStroke")
DropdownStroke.Thickness = 1
DropdownStroke.Color = Color3.fromRGB(0, 150, 255)
DropdownStroke.Parent = DropdownContainer

DropdownListLayout.Parent = DropdownContainer
DropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Tabs
local function createTabBtn(btn, text, page)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(180, 190, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = SidebarFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Thickness = 1
    s.Color = Color3.fromRGB(45, 45, 60)
    s.Parent = btn

    btn.MouseButton1Click:Connect(function()
        FarmPage.Visible = false
        CharmPage.Visible = false
        PlayerPage.Visible = false

        FarmTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        CharmTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        PlayerTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)

        FarmTabButton.TextColor3 = Color3.fromRGB(180, 190, 200)
        CharmTabButton.TextColor3 = Color3.fromRGB(180, 190, 200)
        PlayerTabButton.TextColor3 = Color3.fromRGB(180, 190, 200)

        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

createTabBtn(FarmTabButton, "🌾 ฟังก์ชันฟาร์ม", FarmPage)
createTabBtn(CharmTabButton, "✨ เครื่องราง", CharmPage)
createTabBtn(PlayerTabButton, "⚙️ ตัวละคร", PlayerPage)

FarmTabButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
FarmTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Toggle Button
local function createMenuButton(text, parentPage, onClick)
    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(0.96, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
    btn.Text = text .. " : OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    btn.Parent = parentPage

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Thickness = 1
    s.Color = Color3.fromRGB(255, 100, 100)
    s.Parent = btn

    local active = false

    btn.MouseButton1Click:Connect(function()
        active = not active

        if active then
            btn.Text = text .. " : ON"
            btn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
            s.Color = Color3.fromRGB(100, 255, 150)
        else
            btn.Text = text .. " : OFF"
            btn.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
            s.Color = Color3.fromRGB(255, 100, 100)
        end

        onClick(active)
    end)

    return btn
end

-- Slider
local function createMenuSlider(labelPrefix, min, max, default, parentPage, onChanged)
    local frame = Instance.new("Frame")

    frame.Size = UDim2.new(0.96, 0, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parentPage

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = labelPrefix .. " -> " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(0, 180, 255)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 8)
    sliderBg.Position = UDim2.new(0, 0, 0, 26)
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sliderBg.Parent = frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = sliderBg

    local sliderBtn = Instance.new("TextButton")
    local startPerc = (default - min) / (max - min)

    sliderBtn.Size = UDim2.new(0.06, 0, 2, 0)
    sliderBtn.Position = UDim2.new(
        math.clamp(startPerc - 0.03, 0, 0.94),
        0,
        -0.5,
        0
    )
    sliderBtn.BackgroundColor3 = Color3.fromRGB(0, 215, 255)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBg

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 10)
    bc.Parent = sliderBtn

    local uis = game:GetService("UserInputService")
    local dragging = false

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    uis.InputChanged:Connect(function(input)
        if dragging
            and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            ) then

            local mouseX = input.Position.X
            local bgX = sliderBg.AbsolutePosition.X
            local bgWidth = sliderBg.AbsoluteSize.X

            local percentage = math.clamp(
                (mouseX - bgX) / bgWidth,
                0,
                1
            )

            sliderBtn.Position = UDim2.new(
                math.clamp(percentage - 0.03, 0, 0.94),
                0,
                -0.5,
                0
            )

            local val = min + (percentage * (max - min))
            val = math.round(val * 10) / 10

            label.Text = labelPrefix .. " -> " .. tostring(val)
            onChanged(val)
        end
    end)

    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- FIX: ห้ามใช้ local _G.xxx
_G.AutoWinActive = false
_G.AutoRebirthActive = false
_G.AutoBuyActive = false
_G.AutoCharmActive = false
_G.InfiniteJumpActive = false
_G.SelectedStage = "Auto"

_G.WarpDelay = 0.5
_G.CharmDelay = 1.0

_G.WalkSpeedVal = 16
_G.JumpPowerVal = 50

local player = game:GetService("Players").LocalPlayer
local leaderboard = player:WaitForChild("leaderstats", 5)

-- Stage
local function getStageButton(stageNum)
    local map = workspace:FindFirstChild("Map")

    if map
        and map:FindFirstChild("World1")
        and map.World1:FindFirstChild("Stages") then

        local stage = map.World1.Stages:FindFirstChild("Stage" .. stageNum)

        if stage then
            if stageNum == 1 then
                if stage:FindFirstChild("Main")
                    and stage.Main:FindFirstChild("StageEnd") then

                    return stage.Main.StageEnd:FindFirstChild("Button")
                end
            elseif stage:FindFirstChild("NormalWin") then
                return stage.NormalWin:FindFirstChild("Button")
            end
        end
    end

    return nil
end

-- Treadmill
local function getTreadmillPart(name)
    local map = workspace:FindFirstChild("Map")

    if not map
        or not map:FindFirstChild("World1")
        or not map.World1:FindFirstChild("Stages") then
        return nil
    end

    local stages = map.World1.Stages

    if name == "Basic"
        and stages:FindFirstChild("Stage1")
        and stages.Stage1:FindFirstChild("TreadmillBasic") then

        return stages.Stage1.TreadmillBasic:FindFirstChild("Basic")

    elseif name == "Golden"
        and stages:FindFirstChild("Stage1")
        and stages.Stage1:FindFirstChild("TreadmillGold") then

        return stages.Stage1.TreadmillGold:FindFirstChild("Golden")

    elseif stages:FindFirstChild("Spawn")
        and stages.Spawn:FindFirstChild("Treadmills") then

        local tm = stages.Spawn.Treadmills

        if name == "Galaxy"
            and tm:FindFirstChild("TreadmillGalaxy") then

            return tm.TreadmillGalaxy:FindFirstChild("Galaxy")

        elseif name == "Void"
            and tm:FindFirstChild("TreadmillVoid") then

            return tm.TreadmillVoid:FindFirstChild("Void")

        elseif name == "Celestial"
            and tm:FindFirstChild("TreadmillCelestial") then

            return tm.TreadmillCelestial:FindFirstChild("Celestial")

        elseif name == "Diamond"
            and tm:FindFirstChild("TreadmillDiamond") then

            return tm.TreadmillDiamond:FindFirstChild("Diamond")

        elseif name == "Reward"
            and tm:FindFirstChild("TreadmillPlaytime") then

            return tm.TreadmillPlaytime:FindFirstChild("Reward")
        end
    end

    return nil
end

-- Stats
local function getPlayerStat(statName)
    if leaderboard then
        local stat = leaderboard:FindFirstChild(statName)

        if stat then
            return stat.Value
        end
    end

    return 0
end

-- Buy
local function checkAndBuy(button)
    if not button or not button:IsA("BasePart") then
        return
    end

    local priceValue =
        button:FindFirstChild("Price")
        or button:FindFirstChild("Cost")

    local currencyValue =
        button:FindFirstChild("Currency")
        or button:FindFirstChild("Type")

    if priceValue then
        local price = priceValue.Value
        local currencyName =
            currencyValue and currencyValue.Value or "Coins"

        local playerMoney = getPlayerStat(currencyName)

        if playerMoney >= price then
            if player.Character
                and player.Character:FindFirstChild("HumanoidRootPart") then

                local root = player.Character.HumanoidRootPart
                local currentCFrame = root.CFrame

                root.CFrame = button.CFrame

                task.wait(0.1)

                root.CFrame = currentCFrame
            end
        end
    end
end

-- Farm
createMenuButton(
    "Auto Win / Treadmill",
    FarmPage,
    function(val)
        _G.AutoWinActive = val
    end
)

local dropBtn = Instance.new("TextButton")

dropBtn.Size = UDim2.new(0.96, 0, 0, 38)
dropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
dropBtn.Text = "🎯 Select Target: Auto (Loop 1-9)"
dropBtn.TextColor3 = Color3.fromRGB(0, 180, 255)
dropBtn.Font = Enum.Font.SourceSansBold
dropBtn.TextSize = 14
dropBtn.Parent = FarmPage

local dc = Instance.new("UICorner")
dc.CornerRadius = UDim.new(0, 6)
dc.Parent = dropBtn

local ds = Instance.new("UIStroke")
ds.Thickness = 1
ds.Color = Color3.fromRGB(0, 150, 255)
ds.Parent = dropBtn

createMenuSlider(
    "Warp Speed Delay",
    0.1,
    3.0,
    0.5,
    FarmPage,
    function(val)
        _G.WarpDelay = val
    end
)

createMenuButton(
    "Auto Rebirth",
    FarmPage,
    function(val)
        _G.AutoRebirthActive = val
    end
)

createMenuButton(
    "Auto Buy Upgrades (Fx)",
    FarmPage,
    function(val)
        _G.AutoBuyActive = val
    end
)

-- Charm
createMenuButton(
    "Auto Buy Charms (Slot 1-3)",
    CharmPage,
    function(val)
        _G.AutoCharmActive = val
    end
)

createMenuSlider(
    "Charm Speed Delay",
    0.1,
    3.0,
    1.0,
    CharmPage,
    function(val)
        _G.CharmDelay = val
    end
)

-- Player
createMenuSlider(
    "WalkSpeed Custom",
    16,
    200,
    16,
    PlayerPage,
    function(val)
        _G.WalkSpeedVal = val
    end
)

createMenuSlider(
    "JumpPower Custom",
    50,
    300,
    50,
    PlayerPage,
    function(val)
        _G.JumpPowerVal = val
    end
)

createMenuButton(
    "Infinite Jump",
    PlayerPage,
    function(val)
        _G.InfiniteJumpActive = val
    end
)

-- Player Count
task.spawn(function()
    while true do
        task.wait(2)

        pcall(function()
            local players = game:GetService("Players"):GetPlayers()
            local maxPlayers = game:GetService("Players").MaxPlayers

            PlayerCountLabel.Text =
                "🎮 Server: "
                .. tostring(#players)
                .. "/"
                .. tostring(maxPlayers)
                .. " Players"
        end)
    end
end)

-- Auto Win
task.spawn(function()
    while true do
        task.wait(_G.WarpDelay)

        if _G.AutoWinActive
            and player.Character
            and player.Character:FindFirstChild("HumanoidRootPart") then

            local root = player.Character.HumanoidRootPart

            if _G.SelectedStage == "Auto" then

                for i = 1, 9 do
                    local btn = getStageButton(i)

                    if btn and btn:IsA("BasePart") then
                        root.CFrame = btn.CFrame
                        task.wait(0.1)
                    end
                end

            elseif string.sub(_G.SelectedStage, 1, 2) == "TM" then

                local tmPart =
                    getTreadmillPart(
                        string.sub(_G.SelectedStage, 4)
                    )

                if tmPart and tmPart:IsA("BasePart") then
                    root.CFrame = tmPart.CFrame
                end

            elseif _G.SelectedStage ~= "Header" then

                local stageNumber = tonumber(_G.SelectedStage)

                if stageNumber then
                    local btn = getStageButton(stageNumber)

                    if btn and btn:IsA("BasePart") then
                        root.CFrame = btn.CFrame
                    end
                end
            end
        end
    end
end)

-- Auto Buy
task.spawn(function()
    while true do
        task.wait(1)

        if _G.AutoBuyActive
            and player.Character
            and player.Character:FindFirstChild("HumanoidRootPart") then

            local fx = workspace:FindFirstChild("Fx")

            if fx then
                for _, child in pairs(fx:GetChildren()) do

                    local btn

                    if child:IsA("Model") then
                        btn =
                            child:FindFirstChild("Button")
                            or child:FindFirstChild("Touch")
                            or child
                    else
                        btn = child
                    end

                    checkAndBuy(btn)
                end
            end
        end
    end
end)

-- Auto Rebirth
task.spawn(function()
    while true do
        task.wait(1)

        if _G.AutoRebirthActive then
            pcall(function()
                local remotes =
                    game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")

                if remotes
                    and remotes:FindFirstChild("Rebirth") then

                    remotes.Rebirth:FireServer()
                end
            end)
        end
    end
end)

-- Auto Charm
task.spawn(function()
    while true do
        task.wait(_G.CharmDelay)

        if _G.AutoCharmActive then
            pcall(function()
                local remotes =
                    game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")

                if remotes
                    and remotes:FindFirstChild("SetPendingCharmSlot") then

                    remotes.SetPendingCharmSlot:FireServer(1)
                    task.wait(0.05)

                    remotes.SetPendingCharmSlot:FireServer(2)
                    task.wait(0.05)

                    remotes.SetPendingCharmSlot:FireServer(3)
                end
            end)
        end
    end
end)

-- Character
task.spawn(function()
    while true do
        task.wait(0.1)

        pcall(function()
            if player.Character
                and player.Character:FindFirstChild("Humanoid") then

                local humanoid = player.Character.Humanoid

                humanoid.WalkSpeed = _G.WalkSpeedVal
                humanoid.JumpPower = _G.JumpPowerVal
            end
        end)
    end
end)

-- Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJumpActive
        and player.Character
        and player.Character:FindFirstChild("Humanoid") then

        player.Character.Humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )
    end
end)

-- Dropdown Option
local function createDropdownOption(text, value)
    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = DropdownContainer
    btn.ZIndex = 11

    btn.MouseButton1Click:Connect(function()
        if value ~= "Header" then
            _G.SelectedStage = value
            dropBtn.Text = "🎯 Target: " .. text
            DropdownContainer.Visible = false
        end
    end)
end

createDropdownOption("Auto (Loop 1-9)", "Auto")

for i = 1, 9 do
    createDropdownOption("Stage " .. i, tostring(i))
end

createDropdownOption(
    "--- ลู่วิ่ง (Treadmills) ---",
    "Header"
)

createDropdownOption("Treadmill Basic", "TM_Basic")
createDropdownOption("Treadmill Gold", "TM_Golden")
createDropdownOption("Treadmill Galaxy", "TM_Galaxy")
createDropdownOption("Treadmill Void", "TM_Void")
createDropdownOption("Treadmill Celestial", "TM_Celestial")
createDropdownOption("Treadmill Diamond", "TM_Diamond")
createDropdownOption("Treadmill Playtime", "TM_Reward")

dropBtn.MouseButton1Click:Connect(function()
    DropdownContainer.Visible = not DropdownContainer.Visible
end)
