--// =========================================================
--// Ultimate SpeedFC Hub - Fixed Edition
--// UI + Config + TH/EN + Farm + Player + Fly
--// =========================================================

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--//=========================================================
--// CONFIG
--//=========================================================

local configFileName = "SpeedFCHub_Config.json"

local config = {
    AutoWinActive = false,
    AutoTreadmillActive = false,
    AutoRebirthActive = false,
    AutoBuyActive = false,
    AutoCharmActive = false,

    InfiniteJumpActive = false,
    FlyActive = false,

    SelectedStage = "Auto",
    SelectedTreadmill = "Basic",
    SelectedCharmRarity = 1,

    WarpDelay = 0.5,
    CharmDelay = 1.0,

    WalkSpeedVal = 16,
    JumpPowerVal = 50,
    FlySpeedVal = 50,

    Language = "TH"
}

--//=========================================================
--// CONFIG SAVE / LOAD
--//=========================================================

local function saveConfig()
    pcall(function()
        if writefile then
            writefile(
                configFileName,
                HttpService:JSONEncode(config)
            )
        end
    end)
end

local function loadConfig()
    pcall(function()
        if readfile and isfile and isfile(configFileName) then
            local data = HttpService:JSONDecode(
                readfile(configFileName)
            )

            if type(data) == "table" then
                for key, value in pairs(data) do
                    if config[key] ~= nil then
                        config[key] = value
                    end
                end
            end
        end
    end)
end

loadConfig()

--// FIX: ห้ามเขียน local _G.Language
_G.Language = config.Language or "TH"

--//=========================================================
--// SCREEN GUI
--//=========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedFCHubUltimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = PlayerGui
end

--//=========================================================
--// MAIN FRAME
--//=========================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BackgroundTransparency = 0.08
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.Parent = MainFrame

--//=========================================================
--// TOP BAR
--//=========================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TopBar.BorderSizePixel = 0

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

-- Avatar
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Parent = TopBar
AvatarImage.Position = UDim2.new(0, 10, 0, 5)
AvatarImage.Size = UDim2.new(0, 30, 0, 30)
AvatarImage.BackgroundTransparency = 1

pcall(function()
    AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="
        .. tostring(player.UserId)
        .. "&width=150&height=150&format=png"
end)

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.Position = UDim2.new(0, 48, 0, 0)
TitleLabel.Size = UDim2.new(0.4, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "speedFC.ค่าย"
TitleLabel.TextColor3 = Color3.fromRGB(0, 215, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Player count
local PlayerCountLabel = Instance.new("TextLabel")
PlayerCountLabel.Parent = TopBar
PlayerCountLabel.Position = UDim2.new(0.45, 0, 0, 0)
PlayerCountLabel.Size = UDim2.new(0.35, 0, 1, 0)
PlayerCountLabel.BackgroundTransparency = 1
PlayerCountLabel.Text = "🎮 Server: 0/0"
PlayerCountLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
PlayerCountLabel.Font = Enum.Font.SourceSansBold
PlayerCountLabel.TextSize = 14
PlayerCountLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Minimize
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = TopBar
MinimizeButton.Position = UDim2.new(1, -65, 0, 5)
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 14

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 4)
MinBtnCorner.Parent = MinimizeButton

-- Close
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TopBar
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 4)
CloseBtnCorner.Parent = CloseButton

--//=========================================================
--// MINI BUTTON
--//=========================================================

local MiniButton = Instance.new("TextButton")
MiniButton.Name = "SpeedFCMini"
MiniButton.Parent = ScreenGui
MiniButton.Position = UDim2.new(0.05, 0, 0.15, 0)
MiniButton.Size = UDim2.new(0, 50, 0, 50)
MiniButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MiniButton.Text = "⚡"
MiniButton.TextColor3 = Color3.fromRGB(0, 215, 255)
MiniButton.Font = Enum.Font.SourceSansBold
MiniButton.TextSize = 26
MiniButton.Visible = false
MiniButton.Active = true
MiniButton.Draggable = true

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = MiniButton

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Thickness = 2
MiniStroke.Color = Color3.fromRGB(0, 180, 255)
MiniStroke.Parent = MiniButton

--//=========================================================
--// SIDEBAR
--//=========================================================

local SidebarFrame = Instance.new("Frame")
SidebarFrame.Parent = MainFrame
SidebarFrame.Position = UDim2.new(0, 10, 0, 50)
SidebarFrame.Size = UDim2.new(0, 130, 1, -60)
SidebarFrame.BackgroundTransparency = 1

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = SidebarFrame
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 6)

--//=========================================================
--// CONTENT
--//=========================================================

local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.Position = UDim2.new(0, 155, 0, 55)
ContentFrame.Size = UDim2.new(1, -165, 1, -65)
ContentFrame.BackgroundTransparency = 1

-- Pages
local FarmPage = Instance.new("ScrollingFrame")
local CharmPage = Instance.new("ScrollingFrame")
local PlayerPage = Instance.new("ScrollingFrame")
local SettingPage = Instance.new("ScrollingFrame")

local PageLayout1 = Instance.new("UIListLayout")
local PageLayout2 = Instance.new("UIListLayout")
local PageLayout3 = Instance.new("UIListLayout")
local PageLayout4 = Instance.new("UIListLayout")

local function setupPage(page, layout)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 700)
    page.ScrollBarThickness = 3
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
setupPage(SettingPage, PageLayout4)

FarmPage.Visible = true

--//=========================================================
--// DROPDOWNS
--//=========================================================

local DropdownContainer = Instance.new("ScrollingFrame")
local DropdownListLayout = Instance.new("UIListLayout")

local CharmDropdownContainer = Instance.new("ScrollingFrame")
local CharmDropdownListLayout = Instance.new("UIListLayout")

local TreadmillDropdownContainer = Instance.new("ScrollingFrame")
local TreadmillDropdownListLayout = Instance.new("UIListLayout")

local function applyDropdownStyle(container, layout, canvasY)
    container.Parent = MainFrame
    container.Position = UDim2.new(0.32, 0, 0.45, 0)
    container.Size = UDim2.new(0.63, 0, 0, 130)
    container.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    container.BorderSizePixel = 0
    container.Visible = false
    container.ZIndex = 100
    container.CanvasSize = UDim2.new(0, 0, 0, canvasY)
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Parent = container

    layout.Parent = container
    layout.SortOrder = Enum.SortOrder.LayoutOrder
end

applyDropdownStyle(DropdownContainer, DropdownListLayout, 350)
applyDropdownStyle(CharmDropdownContainer, CharmDropdownListLayout, 150)
applyDropdownStyle(TreadmillDropdownContainer, TreadmillDropdownListLayout, 250)

--//=========================================================
--// LANGUAGE SYSTEM
--//=========================================================

local textLabels = {}

local function registerLangText(object, th, en)
    textLabels[object] = {
        TH = th,
        EN = en
    }
end

local function getLangText(th, en)
    if _G.Language == "EN" then
        return en
    end

    return th
end

local function updateLanguageDisplay()
    for object, data in pairs(textLabels) do
        if object and object.Parent then
            object.Text = getLangText(data.TH, data.EN)
        end
    end
end

--//=========================================================
--// TAB BUTTONS
--//=========================================================

local FarmTabButton = Instance.new("TextButton")
local CharmTabButton = Instance.new("TextButton")
local PlayerTabButton = Instance.new("TextButton")
local SettingTabButton = Instance.new("TextButton")

local currentPage = FarmPage

local function createTabBtn(btn, thText, enText, page)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.TextColor3 = Color3.fromRGB(180, 190, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.Parent = SidebarFrame

    registerLangText(btn, "  " .. thText, "  " .. enText)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(45, 45, 60)
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        FarmPage.Visible = false
        CharmPage.Visible = false
        PlayerPage.Visible = false
        SettingPage.Visible = false

        DropdownContainer.Visible = false
        CharmDropdownContainer.Visible = false
        TreadmillDropdownContainer.Visible = false

        FarmTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        CharmTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        PlayerTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        SettingTabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)

        page.Visible = true
        currentPage = page

        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    end)
end

createTabBtn(
    FarmTabButton,
    "🌾 ฟังก์ชันฟาร์ม",
    "🌾 Farm Functions",
    FarmPage
)

createTabBtn(
    CharmTabButton,
    "✨ เครื่องราง",
    "✨ Charm Options",
    CharmPage
)

createTabBtn(
    PlayerTabButton,
    "⚙️ ตัวละคร",
    "⚙️ Player",
    PlayerPage
)

createTabBtn(
    SettingTabButton,
    "🌐 ตั้งค่าภาษา",
    "🌐 Settings & Lang",
    SettingPage
)

FarmTabButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

--//=========================================================
--// MENU BUTTON
--//=========================================================

local function createMenuButton(
    thText,
    enText,
    parentPage,
    configKey,
    callback
)
    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(0.96, 0, 0, 38)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    btn.BorderSizePixel = 0
    btn.Parent = parentPage

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Parent = btn

    local function refresh()
        local baseText = getLangText(thText, enText)

        if config[configKey] then
            btn.Text = baseText .. " : ON"
            btn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
            stroke.Color = Color3.fromRGB(100, 255, 150)
        else
            btn.Text = baseText .. " : OFF"
            btn.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
            stroke.Color = Color3.fromRGB(255, 100, 100)
        end
    end

    btn.MouseButton1Click:Connect(function()
        config[configKey] = not config[configKey]

        saveConfig()
        refresh()

        pcall(function()
            callback(config[configKey])
        end)
    end)

    refresh()

    return btn, refresh
end

--//=========================================================
--// TEXT BOX
--//=========================================================

local function createMenuTextBox(
    thPrefix,
    enPrefix,
    configKey,
    parentPage,
    onChanged
)
    local frame = Instance.new("Frame")

    frame.Size = UDim2.new(0.96, 0, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parentPage

    local label = Instance.new("TextLabel")

    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 180, 255)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    registerLangText(label, thPrefix, enPrefix)
    label.Text = getLangText(thPrefix, enPrefix)

    local box = Instance.new("TextBox")

    box.Size = UDim2.new(0.35, 0, 0.7, 0)
    box.Position = UDim2.new(0.65, 0, 0.15, 0)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    box.Text = tostring(config[configKey])
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.SourceSansBold
    box.TextSize = 14
    box.ClearTextOnFocus = false
    box.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box

    box.FocusLost:Connect(function()
        local number = tonumber(box.Text)

        if number then
            config[configKey] = number
            saveConfig()

            pcall(function()
                onChanged(number)
            end)
        else
            box.Text = tostring(config[configKey])
        end
    end)

    pcall(function()
        onChanged(config[configKey])
    end)
end

--//=========================================================
--// SLIDER
--//=========================================================

local function createMenuSlider(
    thPrefix,
    enPrefix,
    minValue,
    maxValue,
    configKey,
    parentPage,
    onChanged
)
    local frame = Instance.new("Frame")

    frame.Size = UDim2.new(0.96, 0, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = parentPage

    local label = Instance.new("TextLabel")

    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 180, 255)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("Frame")

    sliderBg.Size = UDim2.new(1, 0, 0, 8)
    sliderBg.Position = UDim2.new(0, 0, 0, 26)
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 4)
    bgCorner.Parent = sliderBg

    local sliderBtn = Instance.new("TextButton")

    sliderBtn.Size = UDim2.new(0, 14, 0, 16)
    sliderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(0, 215, 255)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBg

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = sliderBtn

    local function setSlider(value)
        value = math.clamp(
            tonumber(value) or minValue,
            minValue,
            maxValue
        )

        local percentage =
            (value - minValue) /
            (maxValue - minValue)

        sliderBtn.Position =
            UDim2.new(percentage, 0, 0.5, 0)

        value = math.round(value * 10) / 10

        config[configKey] = value
        saveConfig()

        label.Text =
            getLangText(thPrefix, enPrefix)
            .. " -> "
            .. tostring(value)

        pcall(function()
            onChanged(value)
        end)
    end

    local dragging = false

    local function updateFromX(x)
        local startX = sliderBg.AbsolutePosition.X
        local width = sliderBg.AbsoluteSize.X

        if width <= 0 then
            return
        end

        local percentage =
            math.clamp(
                (x - startX) / width,
                0,
                1
            )

        local value =
            minValue +
            percentage * (maxValue - minValue)

        setSlider(value)
    end

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then

                updateFromX(input.Position.X)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    setSlider(config[configKey])
end

--//=========================================================
--// GAME FUNCTIONS
--//=========================================================

local leaderboard =
    player:WaitForChild("leaderstats", 5)

local function getStageButton(stageNum)
    local map = workspace:FindFirstChild("Map")

    if not map then
        return nil
    end

    local world1 = map:FindFirstChild("World1")

    if not world1 then
        return nil
    end

    local stages = world1:FindFirstChild("Stages")

    if not stages then
        return nil
    end

    local stage =
        stages:FindFirstChild("Stage" .. tostring(stageNum))

    if not stage then
        return nil
    end

    if stageNum == 1 then
        local main = stage:FindFirstChild("Main")

        if main then
            local stageEnd = main:FindFirstChild("StageEnd")

            if stageEnd then
                return stageEnd:FindFirstChild("Button")
            end
        end
    else
        local normalWin = stage:FindFirstChild("NormalWin")

        if normalWin then
            return normalWin:FindFirstChild("Button")
        end
    end

    return nil
end

local function getTreadmillPart(name)
    local map = workspace:FindFirstChild("Map")

    if not map then
        return nil
    end

    local world1 = map:FindFirstChild("World1")

    if not world1 then
        return nil
    end

    local stages = world1:FindFirstChild("Stages")

    if not stages then
        return nil
    end

    if name == "Basic" then
        local stage1 = stages:FindFirstChild("Stage1")

        if stage1 then
            local tm = stage1:FindFirstChild("TreadmillBasic")

            if tm then
                return tm:FindFirstChild("Basic")
            end
        end
    end

    if name == "Gold" then
        local stage1 = stages:FindFirstChild("Stage1")

        if stage1 then
            local tm = stage1:FindFirstChild("TreadmillGold")

            if tm then
                return tm:FindFirstChild("Golden")
            end
        end
    end

    local spawn = stages:FindFirstChild("Spawn")

    if not spawn then
        return nil
    end

    local treadmills = spawn:FindFirstChild("Treadmills")

    if not treadmills then
        return nil
    end

    local mapNames = {
        Galaxy = {"TreadmillGalaxy", "Galaxy"},
        Void = {"TreadmillVoid", "Void"},
        Celestial = {"TreadmillCelestial", "Celestial"},
        Diamond = {"TreadmillDiamond", "Diamond"},
        Playtime = {"TreadmillPlaytime", "Reward"}
    }

    local data = mapNames[name]

    if data then
        local treadmill =
            treadmills:FindFirstChild(data[1])

        if treadmill then
            return treadmill:FindFirstChild(data[2])
        end
    end

    return nil
end

local function getPlayerStat(statName)
    if not leaderboard then
        return 0
    end

    local stat =
        leaderboard:FindFirstChild(statName)

    if stat then
        return tonumber(stat.Value) or 0
    end

    return 0
end

--//=========================================================
--// FARM BUTTONS
--//=========================================================

local AutoWinButton = createMenuButton(
    "ออโต้วิน (เก็บชนะ)",
    "Auto Win (Collect Wins)",
    FarmPage,
    "AutoWinActive",
    function(enabled)
        if enabled then
            config.AutoTreadmillActive = false
        end
    end
)

-- Stage Dropdown
local dropBtn = Instance.new("TextButton")

dropBtn.Size = UDim2.new(0.96, 0, 0, 38)
dropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dropBtn.Font = Enum.Font.SourceSansBold
dropBtn.TextSize = 14
dropBtn.BorderSizePixel = 0
dropBtn.Parent = FarmPage

local dropCorner = Instance.new("UICorner")
dropCorner.CornerRadius = UDim.new(0, 6)
dropCorner.Parent = dropBtn

dropBtn.Text =
    getLangText(
        "🎯 เลือกด่าน: ",
        "🎯 Select Stage: "
    ) .. tostring(config.SelectedStage)

-- Treadmill
local AutoTreadmillButton = createMenuButton(
    "ออโต้ลู่วิ่ง (ปั๊มสปีด)",
    "Auto Treadmill (Farm Speed)",
    FarmPage,
    "AutoTreadmillActive",
    function(enabled)
        if enabled then
            config.AutoWinActive = false
        end
    end
)

local treadmillDropBtn = Instance.new("TextButton")

treadmillDropBtn.Size = UDim2.new(0.96, 0, 0, 38)
treadmillDropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
treadmillDropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
treadmillDropBtn.Font = Enum.Font.SourceSansBold
treadmillDropBtn.TextSize = 14
treadmillDropBtn.BorderSizePixel = 0
treadmillDropBtn.Parent = FarmPage

local treadmillCorner = Instance.new("UICorner")
treadmillCorner.CornerRadius = UDim.new(0, 6)
treadmillCorner.Parent = treadmillDropBtn

treadmillDropBtn.Text =
    getLangText(
        "🏃 เลือกลู่วิ่ง: ",
        "🏃 Select Treadmill: "
    ) .. tostring(config.SelectedTreadmill)

createMenuSlider(
    "หน่วงเวลาการวาร์ป",
    "Warp Speed Delay",
    0.1,
    3.0,
    "WarpDelay",
    FarmPage,
    function()
    end
)

createMenuButton(
    "เกิดใหม่อัตโนมัติ",
    "Auto Rebirth",
    FarmPage,
    "AutoRebirthActive",
    function()
    end
)

createMenuButton(
    "ซื้อของอัปเกรดอัตโนมัติ",
    "Auto Buy Upgrades",
    FarmPage,
    "AutoBuyActive",
    function()
    end
)

--//=========================================================
--// CHARM PAGE
--//=========================================================

createMenuButton(
    "ซื้อเครื่องรางอัตโนมัติ",
    "Auto Buy Charms",
    CharmPage,
    "AutoCharmActive",
    function()
    end
)

local charmDropBtn = Instance.new("TextButton")

charmDropBtn.Size = UDim2.new(0.96, 0, 0, 38)
charmDropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
charmDropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
charmDropBtn.Font = Enum.Font.SourceSansBold
charmDropBtn.TextSize = 14
charmDropBtn.BorderSizePixel = 0
charmDropBtn.Parent = CharmPage

local charmCorner = Instance.new("UICorner")
charmCorner.CornerRadius = UDim.new(0, 6)
charmCorner.Parent = charmDropBtn

charmDropBtn.Text =
    getLangText(
        "✨ ระดับ: Rarity ",
        "✨ Rarity: "
    ) .. tostring(config.SelectedCharmRarity)

createMenuSlider(
    "หน่วงเวลาซื้อเครื่องราง",
    "Charm Speed Delay",
    0.1,
    3.0,
    "CharmDelay",
    CharmPage,
    function()
    end
)

--//=========================================================
--// PLAYER PAGE
--//=========================================================

createMenuTextBox(
    "🏃 ปรับความเร็วตัวละคร (ใส่เลข)",
    "🏃 WalkSpeed Value (Type)",
    "WalkSpeedVal",
    PlayerPage,
    function()
    end
)

createMenuTextBox(
    "🦘 ปรับแรงกระโดดตัวละคร (ใส่เลข)",
    "🦘 JumpPower Value (Type)",
    "JumpPowerVal",
    PlayerPage,
    function()
    end
)

createMenuButton(
    "กระโดดไม่จำกัด",
    "Infinite Jump",
    PlayerPage,
    "InfiniteJumpActive",
    function()
    end
)

createMenuButton(
    "✈️ เปิดระบบบินควบคุมอิสระ",
    "✈️ Toggle Fly System",
    PlayerPage,
    "FlyActive",
    function()
    end
)

createMenuTextBox(
    "✈️ ความเร็วในการบิน (ใส่เลข)",
    "✈️ Fly Speed Value (Type)",
    "FlySpeedVal",
    PlayerPage,
    function()
    end
)

--//=========================================================
--// LANGUAGE PAGE
--//=========================================================

local thLangBtn = Instance.new("TextButton")

thLangBtn.Size = UDim2.new(0.96, 0, 0, 38)
thLangBtn.Text = "ภาษาไทย (TH)"
thLangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
thLangBtn.Font = Enum.Font.SourceSansBold
thLangBtn.TextSize = 15
thLangBtn.BorderSizePixel = 0
thLangBtn.Parent = SettingPage

local thCorner = Instance.new("UICorner")
thCorner.CornerRadius = UDim.new(0, 6)
thCorner.Parent = thLangBtn

local enLangBtn = Instance.new("TextButton")

enLangBtn.Size = UDim2.new(0.96, 0, 0, 38)
enLangBtn.Text = "English (EN)"
enLangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
enLangBtn.Font = Enum.Font.SourceSansBold
enLangBtn.TextSize = 15
enLangBtn.BorderSizePixel = 0
enLangBtn.Parent = SettingPage

local enCorner = Instance.new("UICorner")
enCorner.CornerRadius = UDim.new(0, 6)
enCorner.Parent = enLangBtn

local function refreshLanguageButtons()
    if _G.Language == "TH" then
        thLangBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        enLangBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    else
        thLangBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        enLangBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end
end

local function refreshDropTexts()
    dropBtn.Text =
        getLangText(
            "🎯 เลือกด่าน: ",
            "🎯 Select Stage: "
        ) .. tostring(config.SelectedStage)

    treadmillDropBtn.Text =
        getLangText(
            "🏃 เลือกลู่วิ่ง: ",
            "🏃 Select Treadmill: "
        ) .. tostring(config.SelectedTreadmill)

    charmDropBtn.Text =
        getLangText(
            "✨ ระดับ: Rarity ",
            "✨ Rarity: "
        ) .. tostring(config.SelectedCharmRarity)
end

thLangBtn.MouseButton1Click:Connect(function()
    _G.Language = "TH"
    config.Language = "TH"

    saveConfig()

    updateLanguageDisplay()
    refreshLanguageButtons()
    refreshDropTexts()
end)

enLangBtn.MouseButton1Click:Connect(function()
    _G.Language = "EN"
    config.Language = "EN"

    saveConfig()

    updateLanguageDisplay()
    refreshLanguageButtons()
    refreshDropTexts()
end)

refreshLanguageButtons()

--//=========================================================
--// DROPDOWN OPTIONS
--//=========================================================

local function createDropdownOption(text, value)
    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.ZIndex = 101
    btn.Parent = DropdownContainer

    btn.MouseButton1Click:Connect(function()
        config.SelectedStage = value
        saveConfig()

        refreshDropTexts()

        DropdownContainer.Visible = false
    end)
end

createDropdownOption(
    "Auto (Loop 1-9)",
    "Auto"
)

for i = 1, 9 do
    createDropdownOption(
        "Stage " .. tostring(i),
        tostring(i)
    )
end

local function createTreadmillOption(text, value)
    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.ZIndex = 101
    btn.Parent = TreadmillDropdownContainer

    btn.MouseButton1Click:Connect(function()
        config.SelectedTreadmill = value
        saveConfig()

        refreshDropTexts()

        TreadmillDropdownContainer.Visible = false
    end)
end

createTreadmillOption("Treadmill Basic", "Basic")
createTreadmillOption("Treadmill Gold", "Gold")
createTreadmillOption("Treadmill Galaxy", "Galaxy")
createTreadmillOption("Treadmill Void", "Void")
createTreadmillOption("Treadmill Celestial", "Celestial")
createTreadmillOption("Treadmill Diamond", "Diamond")
createTreadmillOption("Treadmill Playtime", "Playtime")

local function createCharmOption(text, value)
    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.ZIndex = 101
    btn.Parent = CharmDropdownContainer

    btn.MouseButton1Click:Connect(function()
        config.SelectedCharmRarity = value
        saveConfig()

        refreshDropTexts()

        CharmDropdownContainer.Visible = false
    end)
end

createCharmOption("Common (ระดับ 1)", 1)
createCharmOption("Rare (ระดับ 2)", 2)
createCharmOption("Epic (ระดับ 3)", 3)
createCharmOption("Secret (ระดับ 4)", 4)

-- Dropdown click
dropBtn.MouseButton1Click:Connect(function()
    DropdownContainer.Visible =
        not DropdownContainer.Visible

    CharmDropdownContainer.Visible = false
    TreadmillDropdownContainer.Visible = false
end)

treadmillDropBtn.MouseButton1Click:Connect(function()
    TreadmillDropdownContainer.Visible =
        not TreadmillDropdownContainer.Visible

    DropdownContainer.Visible = false
    CharmDropdownContainer.Visible = false
end)

charmDropBtn.MouseButton1Click:Connect(function()
    CharmDropdownContainer.Visible =
        not CharmDropdownContainer.Visible

    DropdownContainer.Visible = false
    TreadmillDropdownContainer.Visible = false
end)

--//=========================================================
--// PLAYER MOVEMENT
--//=========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.1)

        pcall(function()
            local character = player.Character
            local humanoid =
                character and character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                if not config.FlyActive then
                    humanoid.WalkSpeed =
                        tonumber(config.WalkSpeedVal) or 16

                    humanoid.UseJumpPower = true

                    humanoid.JumpPower =
                        tonumber(config.JumpPowerVal) or 50
                end
            end
        end)
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if not config.InfiniteJumpActive then
        return
    end

    if config.FlyActive then
        return
    end

    pcall(function()
        local character = player.Character

        local humanoid =
            character and
            character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid:ChangeState(
                Enum.HumanoidStateType.Jumping
            )
        end
    end)
end)

--//=========================================================
--// FLY SYSTEM
--//=========================================================

local flyingCore = nil

local function stopFly()
    if flyingCore then
        flyingCore:Destroy()
        flyingCore = nil
    end

    local character = player.Character

    if character then
        local humanoid =
            character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

local function startFly()
    local character = player.Character

    if not character then
        return
    end

    local hrp =
        character:FindFirstChild("HumanoidRootPart")

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    if not hrp or not humanoid then
        return
    end

    stopFly()

    humanoid.PlatformStand = true

    flyingCore = Instance.new("BodyVelocity")
    flyingCore.Name = "SpeedFC_FlyVelocity"
    flyingCore.MaxForce =
        Vector3.new(math.huge, math.huge, math.huge)
    flyingCore.Velocity =
        Vector3.new(0, 0, 0)
    flyingCore.Parent = hrp
end

task.spawn(function()
    while ScreenGui.Parent do
        RunService.RenderStepped:Wait()

        if config.FlyActive then
            local character = player.Character

            if character then
                local hrp =
                    character:FindFirstChild("HumanoidRootPart")

                local humanoid =
                    character:FindFirstChildOfClass("Humanoid")

                if hrp and humanoid then
                    if not flyingCore then
                        startFly()
                    end

                    local camera =
                        workspace.CurrentCamera

                    if camera and flyingCore then
                        local move =
                            Vector3.new(0, 0, 0)

                        -- PC
                        if UserInputService:IsKeyDown(
                            Enum.KeyCode.W
                        ) then
                            move += camera.CFrame.LookVector
                        end

                        if UserInputService:IsKeyDown(
                            Enum.KeyCode.S
                        ) then
                            move -= camera.CFrame.LookVector
                        end

                        if UserInputService:IsKeyDown(
                            Enum.KeyCode.A
                        ) then
                            move -= camera.CFrame.RightVector
                        end

                        if UserInputService:IsKeyDown(
                            Enum.KeyCode.D
                        ) then
                            move += camera.CFrame.RightVector
                        end

                        local vertical = 0

                        if UserInputService:IsKeyDown(
                            Enum.KeyCode.Space
                        ) then
                            vertical += 1
                        end

                        if UserInputService:IsKeyDown(
                            Enum.KeyCode.LeftShift
                        ) then
                            vertical -= 1
                        end

                        -- FIX:
                        -- ไม่ใช้ Vector3.Unit กับ Vector3.zero
                        -- เพราะจะได้ NaN
                        if move.Magnitude > 0 then
                            move = move.Unit
                        else
                            move = Vector3.zero
                        end

                        local speed =
                            tonumber(config.FlySpeedVal) or 50

                        flyingCore.Velocity =
                            (move * speed)
                            + Vector3.new(
                                0,
                                vertical * speed,
                                0
                            )
                    end
                end
            end
        else
            if flyingCore then
                stopFly()
            end
        end
    end
end)

--//=========================================================
--// AUTO WIN
--//=========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(
            math.max(
                tonumber(config.WarpDelay) or 0.5,
                0.1
            )
        )

        if not config.AutoWinActive then
            continue
        end

        pcall(function()
            local character = player.Character

            if not character then
                return
            end

            local hrp =
                character:FindFirstChild("HumanoidRootPart")

            if not hrp then
                return
            end

            if config.SelectedStage == "Auto" then
                for i = 1, 9 do
                    if not config.AutoWinActive then
                        break
                    end

                    local button =
                        getStageButton(i)

                    if button then
                        hrp.CFrame =
                            button.CFrame
                            + Vector3.new(0, 3, 0)

                        task.wait(0.1)
                    end
                end
            else
                local stageNumber =
                    tonumber(config.SelectedStage)

                if stageNumber then
                    local button =
                        getStageButton(stageNumber)

                    if button then
                        hrp.CFrame =
                            button.CFrame
                            + Vector3.new(0, 3, 0)
                    end
                end
            end
        end)
    end
end)

--//=========================================================
--// AUTO TREADMILL
--//=========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(
            math.max(
                tonumber(config.WarpDelay) or 0.5,
                0.1
            )
        )

        if config.AutoTreadmillActive then
            pcall(function()
                local character = player.Character

                if not character then
                    return
                end

                local hrp =
                    character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if not hrp then
                    return
                end

                local treadmill =
                    getTreadmillPart(
                        config.SelectedTreadmill
                    )

                if treadmill then
                    hrp.CFrame =
                        treadmill.CFrame
                        + Vector3.new(0, 3, 0)
                end
            end)
        end
    end
end)

--//=========================================================
--// AUTO REBIRTH
--//=========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(1.5)

        if config.AutoRebirthActive then
            pcall(function()
                local remotes =
                    game:GetService(
                        "ReplicatedStorage"
                    ):FindFirstChild("Remotes")

                if not remotes then
                    return
                end

                local rebirth =
                    remotes:FindFirstChild("Rebirth")

                if rebirth and rebirth:IsA("RemoteEvent") then
                    rebirth:FireServer()
                end
            end)
        end
    end
end)

--//=========================================================
--// AUTO CHARM
--//=========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(
            math.max(
                tonumber(config.CharmDelay) or 1,
                0.1
            )
        )

        if config.AutoCharmActive then
            pcall(function()
                local remotes =
                    game:GetService(
                        "ReplicatedStorage"
                    ):FindFirstChild("Remotes")

                if not remotes then
                    return
                end

                local buyCharm =
                    remotes:FindFirstChild("BuyCharm")

                if buyCharm
                    and buyCharm:IsA("RemoteEvent") then

                    buyCharm:FireServer(
                        config.SelectedCharmRarity
                    )
                end
            end)
        end
    end
end)

--//=========================================================
--// AUTO BUY
--//=========================================================

local function triggerTouch(part)
    if not part then
        return
    end

    if not part:IsA("BasePart") then
        return
    end

    pcall(function()
        if firetouchinterest then
            local character = player.Character

            if not character then
                return
            end

            local hrp =
                character:FindFirstChild(
                    "HumanoidRootPart"
                )

            if not hrp then
                return
            end

            firetouchinterest(
                hrp,
                part,
                0
            )

            task.wait(0.02)

            firetouchinterest(
                hrp,
                part,
                1
            )
        end
    end)
end

local function checkAndBuy(child)
    if not child then
        return
    end

    local priceValue =
        child:FindFirstChild("Price")
        or child:FindFirstChild("Cost")

    if not priceValue then
        return
    end

    local price =
        tonumber(priceValue.Value)

    if not price then
        return
    end

    local currencyValue =
        child:FindFirstChild("Currency")
        or child:FindFirstChild("Type")

    local currencyName = "Coins"

    if currencyValue then
        currencyName =
            tostring(currencyValue.Value)
    end

    if string.lower(currencyName) == "win"
        or string.lower(currencyName) == "wins" then

        currencyName = "Wins"
    end

    local money =
        getPlayerStat(currencyName)

    if money < price then
        return
    end

    local target =
        child:FindFirstChild("Button")
        or child:FindFirstChild("Touch")
        or child:FindFirstChild("Hitbox")

    if target and target:IsA("BasePart") then
        triggerTouch(target)
        return
    end

    if child:IsA("BasePart") then
        triggerTouch(child)
        return
    end

    for _, descendant in ipairs(
        child:GetDescendants()
    ) do
        if descendant:IsA("TouchTransmitter") then
            triggerTouch(descendant.Parent)
            break
        end
    end
end

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.8)

        if config.AutoBuyActive then
            pcall(function()
                local fx =
                    workspace:FindFirstChild("Fx")

                if not fx then
                    return
                end

                for _, child in ipairs(
                    fx:GetChildren()
                ) do
                    checkAndBuy(child)
                end
            end)
        end
    end
end)

--//=========================================================
--// SERVER PLAYER COUNT
--//=========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(2)

        pcall(function()
            local players =
                Players:GetPlayers()

            local maxPlayers =
                Players.MaxPlayers

            PlayerCountLabel.Text =
                "🎮 Server: "
                .. tostring(#players)
                .. "/"
                .. tostring(maxPlayers)
        end)
    end
end)

--//=========================================================
--// CHARACTER RESPAWN
--//=========================================================

player.CharacterAdded:Connect(function()
    flyingCore = nil

    task.wait(1)

    if config.FlyActive then
        pcall(startFly)
    end
end)

--//=========================================================
--// MINIMIZE / CLOSE
--//=========================================================

CloseButton.MouseButton1Click:Connect(function()
    config.FlyActive = false
    stopFly()

    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniButton.Visible = true
end)

MiniButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniButton.Visible = false
end)

--//=========================================================
--// INITIAL REFRESH
--//=========================================================

updateLanguageDisplay()
refreshLanguageButtons()
refreshDropTexts()

print("========================================")
print("SpeedFC Hub loaded successfully")
print("Language:", _G.Language)
print("Config:", configFileName)
print("========================================")
