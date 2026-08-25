--// =========================================================
--// Ultimate SpeedFC Hub
--// Grand Finale Premium Edition - Fixed
--// Mobile + PC
--// =========================================================

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

--// Player
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--// =========================================================
--// CONFIG
--// =========================================================

local configFileName = "SpeedFCHub_Config.json"

local config = {
    AutoWinActive = false,
    AutoTreadmillActive = false,
    AutoRebirthActive = false,
    AutoBuyActive = false,
    AutoCharmActive = false,
    InfiniteJumpActive = false,

    SelectedStage = "Auto",
    SelectedTreadmill = "Basic",

    SelectedCharmRarity = 1,
    SelectedFxRarity = 1,

    WarpDelay = 0.5,
    CharmDelay = 1.0,

    WalkSpeedVal = 16,
    JumpPowerVal = 50,

    Language = "TH",
    ThemeColor = "Cyan"
}

_G.Language = config.Language
_G.ThemeColor = config.ThemeColor

--// =========================================================
--// CONFIG SAVE / LOAD
--// =========================================================

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

    _G.Language = config.Language
    _G.ThemeColor = config.ThemeColor
end

loadConfig()

--// =========================================================
--// SCREEN GUI
--// =========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedFCHubUltimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--// Main
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
MainFrame.BackgroundTransparency = 0.08
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -170)
MainFrame.Size = UDim2.new(0, 540, 0, 340)
MainFrame.Active = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2.5
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

--// =========================================================
--// TOP BAR
--// =========================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 44)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 14)
TopBarCorner.Parent = TopBar

--// Avatar
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "AvatarImage"
AvatarImage.Parent = TopBar
AvatarImage.Position = UDim2.new(0, 12, 0, 7)
AvatarImage.Size = UDim2.new(0, 30, 0, 30)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image =
    "https://www.roblox.com/headshot-thumbnail/image?userId="
    .. tostring(player.UserId)
    .. "&width=150&height=150&format=png"

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

--// Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = TopBar
TitleLabel.Position = UDim2.new(0, 52, 0, 0)
TitleLabel.Size = UDim2.new(0.45, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text =
    "ค่าย speedFC [" .. player.Name .. "]"
TitleLabel.TextColor3 = Color3.fromRGB(0, 215, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 17
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

--// Ping
local PlayerCountLabel = Instance.new("TextLabel")
PlayerCountLabel.Name = "PlayerCountLabel"
PlayerCountLabel.Parent = TopBar
PlayerCountLabel.Position = UDim2.new(0.45, 0, 0, 0)
PlayerCountLabel.Size = UDim2.new(0.37, 0, 1, 0)
PlayerCountLabel.BackgroundTransparency = 1
PlayerCountLabel.Text = "🎮 Ping: 0ms | 1/12"
PlayerCountLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
PlayerCountLabel.Font = Enum.Font.SourceSansBold
PlayerCountLabel.TextSize = 13
PlayerCountLabel.TextXAlignment = Enum.TextXAlignment.Right

--// Minimize
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.Position = UDim2.new(1, -65, 0, 9)
MinimizeButton.Size = UDim2.new(0, 26, 0, 26)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 14

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 5)
MinBtnCorner.Parent = MinimizeButton

--// Close
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.Position = UDim2.new(1, -35, 0, 9)
CloseButton.Size = UDim2.new(0, 26, 0, 26)
CloseButton.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 5)
CloseBtnCorner.Parent = CloseButton

--// =========================================================
--// MINI BUTTON
--// =========================================================

local MiniButton = Instance.new("ImageButton")
MiniButton.Name = "SpeedFCMini"
MiniButton.Parent = ScreenGui
MiniButton.Position = UDim2.new(0.05, 0, 0.15, 0)
MiniButton.Size = UDim2.new(0, 55, 0, 52)
MiniButton.BackgroundColor3 = Color3.fromRGB(15, 25, 20)
MiniButton.Image =
    "https://www.roblox.com/headshot-thumbnail/image?userId="
    .. tostring(player.UserId)
    .. "&width=150&height=150&format=png"
MiniButton.Visible = false
MiniButton.Active = true

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = MiniButton

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Thickness = 2.5
MiniStroke.Color = Color3.fromRGB(0, 255, 120)
MiniStroke.Parent = MiniButton

--// =========================================================
--// SIDEBAR
--// =========================================================

local SidebarFrame = Instance.new("Frame")
SidebarFrame.Name = "SidebarFrame"
SidebarFrame.Parent = MainFrame
SidebarFrame.Position = UDim2.new(0, 10, 0, 60)
SidebarFrame.Size = UDim2.new(0, 140, 1, -70)
SidebarFrame.BackgroundTransparency = 1

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = SidebarFrame
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 7)

--// =========================================================
--// CONTENT
--// =========================================================

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.Position = UDim2.new(0, 165, 0, 60)
ContentFrame.Size = UDim2.new(1, -175, 1, -75)
ContentFrame.BackgroundTransparency = 1

--// Pages
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
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 =
        Color3.fromRGB(0, 180, 255)
    page.Visible = false
    page.Parent = ContentFrame

    layout.Parent = page
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12)
end

setupPage(FarmPage, PageLayout1)
setupPage(CharmPage, PageLayout2)
setupPage(PlayerPage, PageLayout3)
setupPage(SettingPage, PageLayout4)

FarmPage.Visible = true

--// =========================================================
--// DROPDOWNS
--// =========================================================

local DropdownContainer = Instance.new("ScrollingFrame")
local DropdownListLayout = Instance.new("UIListLayout")

local CharmDropdownContainer = Instance.new("ScrollingFrame")
local CharmDropdownListLayout = Instance.new("UIListLayout")

local TreadmillDropdownContainer = Instance.new("ScrollingFrame")
local TreadmillDropdownListLayout = Instance.new("UIListLayout")

local ColorDropdownContainer = Instance.new("ScrollingFrame")
local ColorDropdownListLayout = Instance.new("UIListLayout")

local LangDropdownContainer = Instance.new("ScrollingFrame")
local LangDropdownListLayout = Instance.new("UIListLayout")

local FxDropdownContainer = Instance.new("ScrollingFrame")
local FxDropdownListLayout = Instance.new("UIListLayout")

local dropdowns = {}

local function setupDropdown(container, layout, canvasY)
    container.Parent = MainFrame
    container.Position = UDim2.new(0.32, 0, 0.45, 0)
    container.Size = UDim2.new(0.63, 0, 0, 130)
    container.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    container.BorderSizePixel = 0
    container.Visible = false
    container.ZIndex = 50
    container.CanvasSize = UDim2.new(0, 0, 0, canvasY)
    container.ScrollBarThickness = 4

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Parent = container

    layout.Parent = container
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)

    table.insert(dropdowns, container)
end

setupDropdown(
    DropdownContainer,
    DropdownListLayout,
    350
)

setupDropdown(
    CharmDropdownContainer,
    CharmDropdownListLayout,
    220
)

setupDropdown(
    TreadmillDropdownContainer,
    TreadmillDropdownListLayout,
    250
)

setupDropdown(
    ColorDropdownContainer,
    ColorDropdownListLayout,
    180
)

setupDropdown(
    LangDropdownContainer,
    LangDropdownListLayout,
    130
)

setupDropdown(
    FxDropdownContainer,
    FxDropdownListLayout,
    220
)

local function closeAllDropdowns()
    for _, dropdown in ipairs(dropdowns) do
        dropdown.Visible = false
    end
end

--// =========================================================
--// LANGUAGE SYSTEM
--// =========================================================

local textLabels = {}

local function registerLangText(object, th, en, la)
    textLabels[object] = {
        TH = th,
        EN = en,
        LA = la
    }
end

local function getLangText(data)
    if _G.Language == "EN" then
        return data.EN
    elseif _G.Language == "LA" then
        return data.LA
    end

    return data.TH
end

local function updateLanguageDisplay()
    for object, data in pairs(textLabels) do
        if object and object.Parent then
            object.Text = getLangText(data)
        end
    end
end

--// =========================================================
--// THEME
--// =========================================================

local colorObjects = {}

local function getThemeColor(colorName)
    if colorName == "Yellow" then
        return Color3.fromRGB(255, 215, 0)
    elseif colorName == "White" then
        return Color3.fromRGB(240, 240, 240)
    elseif colorName == "Red" then
        return Color3.fromRGB(255, 30, 30)
    end

    return Color3.fromRGB(0, 180, 255)
end

local function updateThemeColor(colorName)
    _G.ThemeColor = colorName
    config.ThemeColor = colorName

    saveConfig()

    if colorName == "Rainbow" then
        return
    end

    local targetColor = getThemeColor(colorName)

    MainStroke.Color = targetColor
    TitleLabel.TextColor3 = targetColor

    for _, obj in ipairs(colorObjects) do
        if obj and obj.Parent then
            if obj:IsA("UIStroke") then
                obj.Color = targetColor
            elseif obj:IsA("TextLabel")
                and obj.Name == "SliderLabel" then
                obj.TextColor3 = targetColor
            end
        end
    end
end

--// =========================================================
--// TAB BUTTONS
--// =========================================================

local FarmTabButton = Instance.new("TextButton")
local CharmTabButton = Instance.new("TextButton")
local PlayerTabButton = Instance.new("TextButton")
local SettingTabButton = Instance.new("TextButton")

local function createTabButton(
    button,
    thText,
    enText,
    laText,
    page
)
    button.Size = UDim2.new(1, 0, 0, 38)
    button.BackgroundColor3 =
        Color3.fromRGB(25, 25, 35)
    button.TextColor3 =
        Color3.fromRGB(180, 190, 200)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 14
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = SidebarFrame

    registerLangText(
        button,
        "  " .. thText,
        "  " .. enText,
        "  " .. laText
    )

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(45, 45, 60)
    stroke.Parent = button

    table.insert(colorObjects, stroke)

    button.MouseButton1Click:Connect(function()
        FarmPage.Visible = false
        CharmPage.Visible = false
        PlayerPage.Visible = false
        SettingPage.Visible = false

        FarmTabButton.BackgroundColor3 =
            Color3.fromRGB(25, 25, 35)
        CharmTabButton.BackgroundColor3 =
            Color3.fromRGB(25, 25, 35)
        PlayerTabButton.BackgroundColor3 =
            Color3.fromRGB(25, 25, 35)
        SettingTabButton.BackgroundColor3 =
            Color3.fromRGB(25, 25, 35)

        closeAllDropdowns()

        page.Visible = true
        button.BackgroundColor3 =
            Color3.fromRGB(0, 100, 200)
    end)
end

createTabButton(
    FarmTabButton,
    "🌾 ฟังก์ชันฟาร์ม",
    "🌾 Farm Functions",
    "🌾 ຟັງຊັນຟາມ",
    FarmPage
)

createTabButton(
    CharmTabButton,
    "✨ เครื่องราง",
    "✨ Charm Options",
    "✨ ເຄື່ອງລາງ",
    CharmPage
)

createTabButton(
    PlayerTabButton,
    "⚙️ ตัวละคร",
    "⚙️ Player Settings",
    "⚙️ ຕົວລະຄອນ",
    PlayerPage
)

createTabButton(
    SettingTabButton,
    "🌐 ตั้งค่าระบบ",
    "🌐 Settings Menu",
    "🌐 ຕັ້ງຄ່າລະບົບ",
    SettingPage
)

FarmTabButton.BackgroundColor3 =
    Color3.fromRGB(0, 100, 200)

--// =========================================================
--// MENU BUTTON
--// =========================================================

local function createMenuButton(
    thText,
    enText,
    laText,
    parentPage,
    configKey,
    onClick
)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.96, 0, 0, 42)
    frame.BackgroundTransparency = 1
    frame.Parent = parentPage

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 =
        Color3.fromRGB(235, 235, 245)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    registerLangText(
        label,
        thText,
        enText,
        laText
    )

    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 48, 0, 24)
    switchBg.Position = UDim2.new(
        1,
        -50,
        0.5,
        -12
    )
    switchBg.Text = ""
    switchBg.Parent = frame

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = switchBg

    local ball = Instance.new("Frame")
    ball.Size = UDim2.new(0, 18, 0, 18)
    ball.Parent = switchBg

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(1, 0)
    bCorner.Parent = ball

    local function renderSwitch()
        if config[configKey] then
            switchBg.BackgroundColor3 =
                Color3.fromRGB(40, 170, 90)

            ball.Position =
                UDim2.new(1, -21, 0.5, -9)

            ball.BackgroundColor3 =
                Color3.fromRGB(255, 255, 255)
        else
            switchBg.BackgroundColor3 =
                Color3.fromRGB(60, 60, 70)

            ball.Position =
                UDim2.new(0, 3, 0.5, -9)

            ball.BackgroundColor3 =
                Color3.fromRGB(180, 180, 180)
        end
    end

    switchBg.MouseButton1Click:Connect(function()
        config[configKey] =
            not config[configKey]

        saveConfig()
        renderSwitch()

        pcall(function()
            onClick(config[configKey])
        end)
    end)

    renderSwitch()

    task.spawn(function()
        pcall(function()
            onClick(config[configKey])
        end)
    end)
end

--// =========================================================
--// TEXTBOX
--// =========================================================

local function createMenuTextBox(
    thPrefix,
    enPrefix,
    laPrefix,
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
    label.TextColor3 =
        Color3.fromRGB(0, 180, 255)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    registerLangText(
        label,
        thPrefix,
        enPrefix,
        laPrefix
    )

    table.insert(colorObjects, label)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.35, 0, 0.7, 0)
    box.Position = UDim2.new(
        0.65,
        0,
        0.15,
        0
    )
    box.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)
    box.Text = tostring(config[configKey])
    box.TextColor3 =
        Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.SourceSansBold
    box.TextSize = 14
    box.ClearTextOnFocus = false
    box.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color =
        Color3.fromRGB(50, 50, 70)
    stroke.Parent = box

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)

        if num then
            config[configKey] = num
            saveConfig()

            pcall(function()
                onChanged(num)
            end)
        else
            box.Text =
                tostring(config[configKey])
        end
    end)

    task.spawn(function()
        pcall(function()
            onChanged(config[configKey])
        end)
    end)
end

--// =========================================================
--// SLIDER
--// =========================================================

local function createMenuSlider(
    thPrefix,
    enPrefix,
    laPrefix,
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
    label.Name = "SliderLabel"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 =
        Color3.fromRGB(0, 180, 255)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    table.insert(colorObjects, label)

    registerLangText(
        label,
        thPrefix,
        enPrefix,
        laPrefix
    )

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 8)
    sliderBg.Position = UDim2.new(0, 0, 0, 26)
    sliderBg.BackgroundColor3 =
        Color3.fromRGB(35, 35, 45)
    sliderBg.Parent = frame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderBg

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 18, 0, 18)
    sliderBtn.AnchorPoint =
        Vector2.new(0.5, 0.5)
    sliderBtn.BackgroundColor3 =
        Color3.fromRGB(0, 215, 255)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBg

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius =
        UDim.new(1, 0)
    buttonCorner.Parent = sliderBtn

    local dragging = false

    local function renderSlider(value)
        local percentage =
            math.clamp(
                (value - minValue)
                / (maxValue - minValue),
                0,
                1
            )

        sliderBtn.Position =
            UDim2.new(
                percentage,
                0,
                0.5,
                0
            )

        local prefix = thPrefix

        if _G.Language == "EN" then
            prefix = enPrefix
        elseif _G.Language == "LA" then
            prefix = laPrefix
        end

        label.Text =
            prefix .. " -> "
            .. tostring(value)
    end

    local function updateSlider(mouseX)
        local bgX =
            sliderBg.AbsolutePosition.X

        local bgWidth =
            sliderBg.AbsoluteSize.X

        if bgWidth <= 0 then
            return
        end

        local percentage =
            math.clamp(
                (mouseX - bgX) / bgWidth,
                0,
                1
            )

        local value =
            minValue
            + percentage
            * (maxValue - minValue)

        value =
            math.round(value * 10) / 10

        config[configKey] = value
        saveConfig()

        renderSlider(value)

        pcall(function()
            onChanged(value)
        end)
    end

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType ==
                Enum.UserInputType.MouseMovement
                or input.UserInputType ==
                Enum.UserInputType.Touch then

                updateSlider(input.Position.X)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    renderSlider(config[configKey])

    task.spawn(function()
        pcall(function()
            onChanged(config[configKey])
        end)
    end)
end

--// =========================================================
--// GAME OBJECT HELPERS
--// =========================================================

local function getStageButton(stageNum)
    local map = workspace:FindFirstChild("Map")

    if not map then
        return nil
    end

    local world = map:FindFirstChild("World1")

    if not world then
        return nil
    end

    local stages = world:FindFirstChild("Stages")

    if not stages then
        return nil
    end

    local stage =
        stages:FindFirstChild(
            "Stage" .. tostring(stageNum)
        )

    if not stage then
        return nil
    end

    if stageNum == 1 then
        local main =
            stage:FindFirstChild("Main")

        if main then
            local stageEnd =
                main:FindFirstChild("StageEnd")

            if stageEnd then
                return stageEnd:FindFirstChild(
                    "Button"
                )
            end
        end
    else
        local normalWin =
            stage:FindFirstChild("NormalWin")

        if normalWin then
            return normalWin:FindFirstChild(
                "Button"
            )
        end
    end

    return nil
end

local function getTreadmillPart(name)
    local map =
        workspace:FindFirstChild("Map")

    if not map then
        return nil
    end

    local world =
        map:FindFirstChild("World1")

    if not world then
        return nil
    end

    local stages =
        world:FindFirstChild("Stages")

    if not stages then
        return nil
    end

    if name == "Basic" then
        local stage1 =
            stages:FindFirstChild("Stage1")

        if stage1 then
            local treadmill =
                stage1:FindFirstChild(
                    "TreadmillBasic"
                )

            if treadmill then
                return treadmill:FindFirstChild(
                    "Basic"
                )
            end
        end

    elseif name == "Gold" then
        local stage1 =
            stages:FindFirstChild("Stage1")

        if stage1 then
            local treadmill =
                stage1:FindFirstChild(
                    "TreadmillGold"
                )

            if treadmill then
                return treadmill:FindFirstChild(
                    "Golden"
                )
            end
        end
    end

    local spawn =
        stages:FindFirstChild("Spawn")

    if not spawn then
        return nil
    end

    local treadmills =
        spawn:FindFirstChild("Treadmills")

    if not treadmills then
        return nil
    end

    local names = {
        Galaxy = {
            folder = "TreadmillGalaxy",
            part = "Galaxy"
        },

        Void = {
            folder = "TreadmillVoid",
            part = "Void"
        },

        Celestial = {
            folder = "TreadmillCelestial",
            part = "Celestial"
        },

        Diamond = {
            folder = "TreadmillDiamond",
            part = "Diamond"
        },

        Playtime = {
            folder = "TreadmillPlaytime",
            part = "Reward"
        }
    }

    local data = names[name]

    if data then
        local folder =
            treadmills:FindFirstChild(
                data.folder
            )

        if folder then
            return folder:FindFirstChild(
                data.part
            )
        end
    end

    return nil
end

--// =========================================================
--// FARM PAGE
--// =========================================================

createMenuButton(
    "ออโต้วิน (เก็บชนะ)",
    "Auto Win (Collect Wins)",
    "ອໍໂຕວິນ (ເກັບຊະນະ)",
    FarmPage,
    "AutoWinActive",
    function(value)
        if value then
            config.AutoTreadmillActive = false
        end
    end
)

local dropBtn = Instance.new("TextButton")
dropBtn.Size = UDim2.new(0.96, 0, 0, 38)
dropBtn.BackgroundColor3 =
    Color3.fromRGB(30, 30, 42)
dropBtn.Font = Enum.Font.SourceSansBold
dropBtn.TextSize = 14
dropBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)
dropBtn.Parent = FarmPage

local dropCorner = Instance.new("UICorner")
dropCorner.CornerRadius = UDim.new(0, 6)
dropCorner.Parent = dropBtn

local dropStroke = Instance.new("UIStroke")
dropStroke.Thickness = 1
dropStroke.Color =
    Color3.fromRGB(0, 150, 255)
dropStroke.Parent = dropBtn

table.insert(colorObjects, dropStroke)

registerLangText(
    dropBtn,
    "🎯 เลือกด่าน: " .. config.SelectedStage,
    "🎯 Select Stage: " .. config.SelectedStage,
    "🎯 ເລືອກດ່ານ: " .. config.SelectedStage
)

createMenuButton(
    "ออโต้ลู่วิ่ง (ปั๊มสปีด)",
    "Auto Treadmill (Farm Speed)",
    "ອໍໂຕລູ່ວິ່ງ (ປັ້ມສະປີດ)",
    FarmPage,
    "AutoTreadmillActive",
    function(value)
        if value then
            config.AutoWinActive = false
        end
    end
)

local treadmillDropBtn = Instance.new("TextButton")
treadmillDropBtn.Size =
    UDim2.new(0.96, 0, 0, 38)
treadmillDropBtn.BackgroundColor3 =
    Color3.fromRGB(30, 30, 42)
treadmillDropBtn.Font =
    Enum.Font.SourceSansBold
treadmillDropBtn.TextSize = 14
treadmillDropBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)
treadmillDropBtn.Parent = FarmPage

local treadmillCorner = Instance.new("UICorner")
treadmillCorner.CornerRadius = UDim.new(0, 6)
treadmillCorner.Parent = treadmillDropBtn

local treadmillStroke = Instance.new("UIStroke")
treadmillStroke.Thickness = 1
treadmillStroke.Color =
    Color3.fromRGB(0, 150, 255)
treadmillStroke.Parent = treadmillDropBtn

table.insert(colorObjects, treadmillStroke)

registerLangText(
    treadmillDropBtn,
    "🏃 เลือกลู่วิ่ง: " .. config.SelectedTreadmill,
    "🏃 Select Treadmill: " .. config.SelectedTreadmill,
    "🏃 ເລືອກລູ່ວິ່ງ: " .. config.SelectedTreadmill
)

createMenuSlider(
    "หน่วงเวลาการวาร์ป",
    "Warp Speed Delay",
    "ໜ່ວງເວລາວາບ",
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
    "ເກີດໃໝ່ອໍໂຕ",
    FarmPage,
    "AutoRebirthActive",
    function()
    end
)

createMenuButton(
    "ซื้อตู้สินค้าอัปเกรดอัตโนมัติ",
    "Auto Buy Upgrades",
    "ຊື້ຕູ້ສິນຄ້າອັບເກຣດອໍໂຕ",
    FarmPage,
    "AutoBuyActive",
    function()
    end
)

local fxDropBtn = Instance.new("TextButton")
fxDropBtn.Size =
    UDim2.new(0.96, 0, 0, 38)
fxDropBtn.BackgroundColor3 =
    Color3.fromRGB(30, 30, 42)
fxDropBtn.Font =
    Enum.Font.SourceSansBold
fxDropBtn.TextSize = 14
fxDropBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)
fxDropBtn.Parent = FarmPage

local fxCorner = Instance.new("UICorner")
fxCorner.CornerRadius = UDim.new(0, 6)
fxCorner.Parent = fxDropBtn

local fxStroke = Instance.new("UIStroke")
fxStroke.Thickness = 1
fxStroke.Color =
    Color3.fromRGB(0, 150, 255)
fxStroke.Parent = fxDropBtn

table.insert(colorObjects, fxStroke)

registerLangText(
    fxDropBtn,
    "🛒 เลือกระดับตู้สินค้า: Rarity "
        .. tostring(config.SelectedFxRarity),
    "🛒 Select Shop Rarity: Rarity "
        .. tostring(config.SelectedFxRarity),
    "🛒 ເລືອກລະດັບຕູ້ສິນຄ້າ: Rarity "
        .. tostring(config.SelectedFxRarity)
)

--// =========================================================
--// CHARM PAGE
--// =========================================================

createMenuButton(
    "ซื้อเครื่องรางอัตโนมัติ",
    "Auto Buy Charms",
    "ຊື້ເຄື່ອງລາງອໍໂຕ",
    CharmPage,
    "AutoCharmActive",
    function()
    end
)

local charmDropBtn = Instance.new("TextButton")
charmDropBtn.Size =
    UDim2.new(0.96, 0, 0, 38)
charmDropBtn.BackgroundColor3 =
    Color3.fromRGB(30, 30, 42)
charmDropBtn.Font =
    Enum.Font.SourceSansBold
charmDropBtn.TextSize = 14
charmDropBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)
charmDropBtn.Parent = CharmPage

local charmCorner = Instance.new("UICorner")
charmCorner.CornerRadius = UDim.new(0, 6)
charmCorner.Parent = charmDropBtn

local charmStroke = Instance.new("UIStroke")
charmStroke.Thickness = 1
charmStroke.Color =
    Color3.fromRGB(0, 150, 255)
charmStroke.Parent = charmDropBtn

table.insert(colorObjects, charmStroke)

registerLangText(
    charmDropBtn,
    "✨ เลือกระดับเครื่องราง: Rarity "
        .. tostring(config.SelectedCharmRarity),
    "✨ Select Charm Rarity: Rarity "
        .. tostring(config.SelectedCharmRarity),
    "✨ ເລືອກລະດັບເຄື່ອງລາງ: Rarity "
        .. tostring(config.SelectedCharmRarity)
)

createMenuSlider(
    "หน่วงเวลาซื้อเครื่องราง",
    "Charm Speed Delay",
    "ໜ່ວງເວລາຊື້ເຄື່ອງລາງ",
    0.1,
    3.0,
    "CharmDelay",
    CharmPage,
    function()
    end
)

--// =========================================================
--// PLAYER PAGE
--// =========================================================

createMenuTextBox(
    "🏃 ปรับความเร็วตัวละคร (ใส่เลข)",
    "🏃 WalkSpeed Value",
    "🏃 ປັບຄວາມໄວຕົວລະຄອນ",
    "WalkSpeedVal",
    PlayerPage,
    function()
    end
)

createMenuTextBox(
    "🦘 ปรับแรงกระโดดตัวละคร (ใส่เลข)",
    "🦘 JumpPower Value",
    "🦘 ປັບແຮງກະໂດດຕົວລະຄອນ",
    "JumpPowerVal",
    PlayerPage,
    function()
    end
)

createMenuButton(
    "กระโดดไม่จำกัด",
    "Infinite Jump",
    "ກະໂດດບໍ່ຈຳກັດ",
    PlayerPage,
    "InfiniteJumpActive",
    function()
    end
)

--// =========================================================
--// SETTINGS PAGE
--// =========================================================

local themeDropBtn = Instance.new("TextButton")
themeDropBtn.Size =
    UDim2.new(0.96, 0, 0, 38)
themeDropBtn.BackgroundColor3 =
    Color3.fromRGB(30, 30, 42)
themeDropBtn.Font =
    Enum.Font.SourceSansBold
themeDropBtn.TextSize = 14
themeDropBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)
themeDropBtn.Parent = SettingPage

local themeCorner = Instance.new("UICorner")
themeCorner.CornerRadius = UDim.new(0, 6)
themeCorner.Parent = themeDropBtn

local themeStroke = Instance.new("UIStroke")
themeStroke.Thickness = 1
themeStroke.Color =
    Color3.fromRGB(0, 150, 255)
themeStroke.Parent = themeDropBtn

table.insert(colorObjects, themeStroke)

registerLangText(
    themeDropBtn,
    "🎨 เปลี่ยนสี UI: " .. config.ThemeColor,
    "🎨 Change UI Theme: " .. config.ThemeColor,
    "🎨 ປ່ຽນສີ UI: " .. config.ThemeColor
)

local langDropBtn = Instance.new("TextButton")
langDropBtn.Size =
    UDim2.new(0.96, 0, 0, 38)
langDropBtn.BackgroundColor3 =
    Color3.fromRGB(30, 30, 42)
langDropBtn.Font =
    Enum.Font.SourceSansBold
langDropBtn.TextSize = 14
langDropBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)
langDropBtn.Parent = SettingPage

local langCorner = Instance.new("UICorner")
langCorner.CornerRadius = UDim.new(0, 6)
langCorner.Parent = langDropBtn

local langStroke = Instance.new("UIStroke")
langStroke.Thickness = 1
langStroke.Color =
    Color3.fromRGB(0, 150, 255)
langStroke.Parent = langDropBtn

table.insert(colorObjects, langStroke)

registerLangText(
    langDropBtn,
    "🌐 เปลี่ยนภาษา: " .. config.Language,
    "🌐 Change Language: " .. config.Language,
    "🌐 ປ່ຽນພາສາ: " .. config.Language
)

--// =========================================================
--// DROPDOWN OPTIONS
--// =========================================================

local function createDropdownOption(text, value)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 =
        Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.ZIndex = 51
    btn.Parent = DropdownContainer

    btn.MouseButton1Click:Connect(function()
        config.SelectedStage = value
        saveConfig()

        local prefix = "🎯 เลือกด่าน: "

        if _G.Language == "EN" then
            prefix = "🎯 Select Stage: "
        elseif _G.Language == "LA" then
            prefix = "🎯 ເລືອກດ່ານ: "
        end

        dropBtn.Text = prefix .. text
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
    btn.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 =
        Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.ZIndex = 51
    btn.Parent = TreadmillDropdownContainer

    btn.MouseButton1Click:Connect(function()
        config.SelectedTreadmill = value
        saveConfig()

        local prefix =
            "🏃 เลือกลู่วิ่ง: "

        if _G.Language == "EN" then
            prefix = "🏃 Select Treadmill: "
        elseif _G.Language == "LA" then
            prefix =
                "🏃 ເລືອກລູ່ວິ່ງ: "
        end

        treadmillDropBtn.Text =
            prefix .. text

        TreadmillDropdownContainer.Visible =
            false
    end)
end

local treadmillOptions = {
    {"Treadmill Basic", "Basic"},
    {"Treadmill Gold", "Gold"},
    {"Treadmill Galaxy", "Galaxy"},
    {"Treadmill Void", "Void"},
    {"Treadmill Celestial", "Celestial"},
    {"Treadmill Diamond", "Diamond"},
    {"Treadmill Playtime", "Playtime"}
}

for _, option in ipairs(treadmillOptions) do
    createTreadmillOption(
        option[1],
        option[2]
    )
end

local function createCharmOption(text, value)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 =
        Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.ZIndex = 51
    btn.Parent = CharmDropdownContainer

    btn.MouseButton1Click:Connect(function()
        config.SelectedCharmRarity = value
        saveConfig()

        local prefix =
            "✨ ระดับเครื่องราง: "

        if _G.Language == "EN" then
            prefix = "✨ Charm Rarity: "
        elseif _G.Language == "LA" then
            prefix =
                "✨ ລະດັບເຄື່ອງລາງ: "
        end

        charmDropBtn.Text =
            prefix .. text

        CharmDropdownContainer.Visible =
            false
    end)
end

local rarityNames = {
    "Common (ระดับ 1)",
    "Rare (ระดับ 2)",
    "Epic (ระดับ 3)",
    "Legendary (ระดับ 4)",
    "Mythical (ระดับ 5)",
    "Secret (ระดับ 6)"
}

for i, name in ipairs(rarityNames) do
    createCharmOption(name, i)
end

local function createFxOption(text, value)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 =
        Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.ZIndex = 51
    btn.Parent = FxDropdownContainer

    btn.MouseButton1Click:Connect(function()
        config.SelectedFxRarity = value
        saveConfig()

        local prefix =
            "🛒 เลือกระดับตู้สินค้า: "

        if _G.Language == "EN" then
            prefix = "🛒 Shop Rarity: "
        elseif _G.Language == "LA" then
            prefix =
                "🛒 ເລືອກລະດັບຕູ້ສິນຄ້າ: "
        end

        fxDropBtn.Text =
            prefix .. text

        FxDropdownContainer.Visible =
            false
    end)
end

for i, name in ipairs(rarityNames) do
    createFxOption(name, i)
end

local function createColorOption(text, colorKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 =
        Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.ZIndex = 51
    btn.Parent = ColorDropdownContainer

    btn.MouseButton1Click:Connect(function()
        updateThemeColor(colorKey)

        local prefix =
            "🎨 เปลี่ยนสี UI: "

        if _G.Language == "EN" then
            prefix = "🎨 Change UI Theme: "
        elseif _G.Language == "LA" then
            prefix =
                "🎨 ປ່ຽນສີ UI: "
        end

        themeDropBtn.Text =
            prefix .. text

        ColorDropdownContainer.Visible =
            false
    end)
end

local colorOptions = {
    {"Cyan", "Cyan"},
    {"Yellow", "Yellow"},
    {"White", "White"},
    {"Red", "Red"},
    {"Rainbow", "Rainbow"}
}

for _, option in ipairs(colorOptions) do
    createColorOption(
        option[1],
        option[2]
    )
end

local function createLangOption(text, langKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 =
        Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.ZIndex = 51
    btn.Parent = LangDropdownContainer

    btn.MouseButton1Click:Connect(function()
        _G.Language = langKey
        config.Language = langKey

        saveConfig()
        updateLanguageDisplay()

        LangDropdownContainer.Visible =
            false
    end)
end

createLangOption(
    "ภาษาไทย (TH)",
    "TH"
)

createLangOption(
    "English (EN)",
    "EN"
)

createLangOption(
    "ພາສາລາວ (LA)",
    "LA"
)

--// =========================================================
--// DROPDOWN BUTTON EVENTS
--// =========================================================

dropBtn.MouseButton1Click:Connect(function()
    closeAllDropdowns()
    DropdownContainer.Visible = true
end)

treadmillDropBtn.MouseButton1Click:Connect(function()
    closeAllDropdowns()
    TreadmillDropdownContainer.Visible = true
end)

charmDropBtn.MouseButton1Click:Connect(function()
    closeAllDropdowns()
    CharmDropdownContainer.Visible = true
end)

themeDropBtn.MouseButton1Click:Connect(function()
    closeAllDropdowns()
    ColorDropdownContainer.Visible = true
end)

langDropBtn.MouseButton1Click:Connect(function()
    closeAllDropdowns()
    LangDropdownContainer.Visible = true
end)

fxDropBtn.MouseButton1Click:Connect(function()
    closeAllDropdowns()
    FxDropdownContainer.Visible = true
end)

--// =========================================================
--// MINIMIZE / CLOSE
--// =========================================================

CloseButton.MouseButton1Click:Connect(function()
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

--// =========================================================
--// PING / PLAYER COUNT
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(1.5)

        pcall(function()
            local players =
                Players:GetPlayers()

            local maxPlayers =
                Players.MaxPlayers

            local pingVal = 0

            local network =
                Stats:FindFirstChild("Network")

            if network then
                local serverStats =
                    network:FindFirstChild(
                        "ServerStatsItem"
                    )

                if serverStats then
                    local dataPing =
                        serverStats:FindFirstChild(
                            "Data Ping"
                        )

                    if dataPing then
                        pingVal =
                            math.round(
                                dataPing:GetValue()
                            )
                    end
                end
            end

            PlayerCountLabel.Text =
                "🎮 Ping: "
                .. tostring(pingVal)
                .. "ms | "
                .. tostring(#players)
                .. "/"
                .. tostring(maxPlayers)
        end)
    end
end)

--// =========================================================
--// RAINBOW THEME
--// =========================================================

task.spawn(function()
    local rainbowTick = 0

    while ScreenGui.Parent do
        task.wait(0.03)

        if _G.ThemeColor == "Rainbow" then
            rainbowTick += 0.01

            local color =
                Color3.fromHSV(
                    rainbowTick % 1,
                    0.8,
                    1
                )

            MainStroke.Color = color
            TitleLabel.TextColor3 = color

            for _, obj in ipairs(colorObjects) do
                if obj and obj.Parent then
                    if obj:IsA("UIStroke") then
                        obj.Color = color
                    elseif obj:IsA("TextLabel")
                        and obj.Name == "SliderLabel" then

                        obj.TextColor3 = color
                    end
                end
            end
        end
    end
end)

--// =========================================================
--// AUTO STAGE / TREADMILL
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(
            math.max(
                tonumber(config.WarpDelay) or 0.5,
                0.05
            )
        )

        if not player.Character then
            continue
        end

        local character =
            player.Character

        local root =
            character:FindFirstChild(
                "HumanoidRootPart"
            )

        local humanoid =
            character:FindFirstChildOfClass(
                "Humanoid"
            )

        if not root or not humanoid then
            continue
        end

        if config.AutoWinActive then
            pcall(function()
                if config.SelectedStage == "Auto" then

                    for i = 1, 9 do
                        if not config.AutoWinActive then
                            break
                        end

                        local button =
                            getStageButton(i)

                        if button
                            and button:IsA("BasePart") then

                            root.CFrame =
                                button.CFrame
                                + Vector3.new(0, 3, 0)

                            task.wait(0.1)
                            humanoid.Jump = true
                        end
                    end

                else
                    local stageNumber =
                        tonumber(
                            config.SelectedStage
                        )

                    if stageNumber then
                        local button =
                            getStageButton(
                                stageNumber
                            )

                        if button
                            and button:IsA("BasePart") then

                            root.CFrame =
                                button.CFrame
                                + Vector3.new(0, 3, 0)

                            humanoid.Jump = true
                        end
                    end
                end
            end)

        elseif config.AutoTreadmillActive then
            pcall(function()
                local treadmill =
                    getTreadmillPart(
                        config.SelectedTreadmill
                    )

                if treadmill
                    and treadmill:IsA("BasePart") then

                    root.CFrame =
                        treadmill.CFrame
                        + Vector3.new(0, 3, 0)
                end
            end)
        end
    end
end)

--// =========================================================
--// AUTO BUY UPGRADE
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.5)

        if config.AutoBuyActive then
            pcall(function()
                local remotes =
                    game:GetService(
                        "ReplicatedStorage"
                    ):FindFirstChild("Remotes")

                if not remotes then
                    return
                end

                local remote =
                    remotes:FindFirstChild(
                        "BuyUpgrade"
                    )

                if remote
                    and remote:IsA("RemoteEvent") then

                    remote:FireServer(
                        config.SelectedFxRarity
                    )
                end
            end)
        end
    end
end)

--// =========================================================
--// AUTO REBIRTH
--// =========================================================

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

                local remote =
                    remotes:FindFirstChild(
                        "Rebirth"
                    )

                if remote
                    and remote:IsA("RemoteEvent") then

                    remote:FireServer()
                end
            end)
        end
    end
end)

--// =========================================================
--// AUTO CHARM
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(
            math.max(
                tonumber(config.CharmDelay) or 1,
                0.05
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

                local remote =
                    remotes:FindFirstChild(
                        "BuyCharm"
                    )

                if remote
                    and remote:IsA("RemoteEvent") then

                    remote:FireServer(
                        config.SelectedCharmRarity
                    )
                end
            end)
        end
    end
end)

--// =========================================================
--// PLAYER SETTINGS
--// =========================================================

local function applyCharacterSettings()
    local character =
        player.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass(
            "Humanoid"
        )

    if not humanoid then
        return
    end

    pcall(function()
        humanoid.WalkSpeed =
            tonumber(config.WalkSpeedVal)
            or 16

        humanoid.UseJumpPower = true

        humanoid.JumpPower =
            tonumber(config.JumpPowerVal)
            or 50
    end)
end

player.CharacterAdded:Connect(function(character)
    character:WaitForChild(
        "Humanoid",
        5
    )

    task.wait(0.2)

    applyCharacterSettings()
end)

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.25)
        applyCharacterSettings()
    end
end)

--// =========================================================
--// INFINITE JUMP
--// =========================================================

UserInputService.JumpRequest:Connect(function()
    if not config.InfiniteJumpActive then
        return
    end

    pcall(function()
        local character =
            player.Character

        local humanoid =
            character
            and character:FindFirstChildOfClass(
                "Humanoid"
            )

        local root =
            character
            and character:FindFirstChild(
                "HumanoidRootPart"
            )

        if humanoid and root then
            root.AssemblyLinearVelocity =
                Vector3.new(
                    root.AssemblyLinearVelocity.X,
                    tonumber(
                        config.JumpPowerVal
                    ) or 50,
                    root.AssemblyLinearVelocity.Z
                )
        end
    end)
end)

--// =========================================================
--// INITIAL DISPLAY
--// =========================================================

updateThemeColor(config.ThemeColor)
updateLanguageDisplay()

print(
    "[SpeedFC Hub] Loaded successfully."
)
