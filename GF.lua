--// =========================================================
--// speedFC.ค่าย - Ultimate Hub
--// Fixed Syntax / Mobile + PC / Config Save
--// =========================================================

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--// Remove old GUI
pcall(function()
    local old = PlayerGui:FindFirstChild("SpeedFCHubUltimate")
    if old then
        old:Destroy()
    end
end)

pcall(function()
    local old = game:GetService("CoreGui"):FindFirstChild("SpeedFCHubUltimate")
    if old then
        old:Destroy()
    end
end)

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
                for k, v in pairs(data) do
                    if config[k] ~= nil then
                        config[k] = v
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
--// GUI
--// =========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedFCHubUltimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- PlayerGui works in normal Roblox LocalScripts.
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
MainFrame.BackgroundTransparency = 0.08
MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 540, 0, 340)
MainFrame.BorderSizePixel = 0

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
TopBar.BorderSizePixel = 0

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 14)
TopBarCorner.Parent = TopBar

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Parent = TopBar
AvatarImage.Position = UDim2.new(0, 12, 0, 7)
AvatarImage.Size = UDim2.new(0, 30, 0, 30)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image =
    "rbxthumb://type=AvatarHeadShot&id="
    .. tostring(player.UserId)
    .. "&w=150&h=150"

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

local TitleLabel = Instance.new("TextLabel")
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

local PlayerCountLabel = Instance.new("TextLabel")
PlayerCountLabel.Parent = TopBar
PlayerCountLabel.Position = UDim2.new(0.5, 0, 0, 0)
PlayerCountLabel.Size = UDim2.new(0.32, 0, 1, 0)
PlayerCountLabel.BackgroundTransparency = 1
PlayerCountLabel.Text = "🎮 Ping: 0ms | 1/12"
PlayerCountLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
PlayerCountLabel.Font = Enum.Font.SourceSansBold
PlayerCountLabel.TextSize = 13
PlayerCountLabel.TextXAlignment = Enum.TextXAlignment.Right

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = TopBar
MinimizeButton.Position = UDim2.new(1, -65, 0, 9)
MinimizeButton.Size = UDim2.new(0, 26, 0, 26)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 14
MinimizeButton.BorderSizePixel = 0

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 5)
MinBtnCorner.Parent = MinimizeButton

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TopBar
CloseButton.Position = UDim2.new(1, -35, 0, 9)
CloseButton.Size = UDim2.new(0, 26, 0, 26)
CloseButton.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.BorderSizePixel = 0

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
MiniButton.Size = UDim2.new(0, 52, 0, 52)
MiniButton.BackgroundColor3 = Color3.fromRGB(15, 25, 20)
MiniButton.Image =
    "rbxthumb://type=AvatarHeadShot&id="
    .. tostring(player.UserId)
    .. "&w=150&h=150"
MiniButton.Visible = false
MiniButton.BorderSizePixel = 0

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
    page.CanvasSize = UDim2.new(0, 0, 0, 700)
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
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

local function applyDropdownStyle(container, layout, sizeY)
    container.Parent = MainFrame
    container.Position = UDim2.new(0.32, 0, 0.45, 0)
    container.Size = UDim2.new(0.63, 0, 0, 130)
    container.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    container.BorderSizePixel = 0
    container.Visible = false
    container.ZIndex = 50
    container.CanvasSize = UDim2.new(0, 0, 0, sizeY)
    container.ScrollBarThickness = 4

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Parent = container

    layout.Parent = container
    layout.SortOrder = Enum.SortOrder.LayoutOrder
end

applyDropdownStyle(
    DropdownContainer,
    DropdownListLayout,
    350
)

applyDropdownStyle(
    CharmDropdownContainer,
    CharmDropdownListLayout,
    220
)

applyDropdownStyle(
    TreadmillDropdownContainer,
    TreadmillDropdownListLayout,
    250
)

applyDropdownStyle(
    ColorDropdownContainer,
    ColorDropdownListLayout,
    320
)

applyDropdownStyle(
    LangDropdownContainer,
    LangDropdownListLayout,
    320
)

applyDropdownStyle(
    FxDropdownContainer,
    FxDropdownListLayout,
    220
)

--// =========================================================
--// LANGUAGE
--// =========================================================

local textLabels = {}

local function registerLangText(object, th, en, la)
    textLabels[object] = {
        TH = th,
        EN = en,
        LA = la
    }
end

local function getLanguageText(th, en, la)
    if _G.Language == "EN" then
        return en
    elseif _G.Language == "LA" then
        return la
    else
        return th
    end
end

local function updateLanguageDisplay()
    for obj, data in pairs(textLabels) do
        if obj and obj.Parent then
            obj.Text = getLanguageText(
                data.TH,
                data.EN,
                data.LA
            )
        end
    end
end

--// =========================================================
--// THEME
--// =========================================================

local colorObjects = {}

local function updateThemeColor(colorName)
    _G.ThemeColor = colorName
    config.ThemeColor = colorName
    saveConfig()

    if colorName == "Rainbow" then
        return
    end

    local targetColor = Color3.fromRGB(0, 180, 255)

    if colorName == "Yellow" then
        targetColor = Color3.fromRGB(255, 215, 0)
    elseif colorName == "White" then
        targetColor = Color3.fromRGB(240, 240, 240)
    elseif colorName == "Red" then
        targetColor = Color3.fromRGB(255, 30, 30)
    elseif colorName == "Green" then
        targetColor = Color3.fromRGB(0, 230, 100)
    elseif colorName == "Blue" then
        targetColor = Color3.fromRGB(0, 80, 255)
    elseif colorName == "Pink" then
        targetColor = Color3.fromRGB(255, 105, 180)
    elseif colorName == "Purple" then
        targetColor = Color3.fromRGB(150, 0, 255)
    elseif colorName == "Orange" then
        targetColor = Color3.fromRGB(255, 130, 0)
    end

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
--// DRAG SYSTEM
--// =========================================================

local function makeDraggable(frame, dragAnchor)
    local dragging = false
    local dragStart
    local startPosition

    local function update(input)
        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end

    dragAnchor.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragAnchor.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            local connection
            connection = UserInputService.InputChanged:Connect(
                function(changedInput)
                    if changedInput == input
                        and dragging then
                        update(changedInput)
                    end
                end
            )

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    if connection then
                        connection:Disconnect()
                    end
                end
            end)
        end
    end)
end

makeDraggable(MainFrame, TopBar)
makeDraggable(MiniButton, MiniButton)

--// =========================================================
--// TAB BUTTONS
--// =========================================================

local FarmTabButton = Instance.new("TextButton")
local CharmTabButton = Instance.new("TextButton")
local PlayerTabButton = Instance.new("TextButton")
local SettingTabButton = Instance.new("TextButton")

local function hideDropdowns()
    DropdownContainer.Visible = false
    CharmDropdownContainer.Visible = false
    TreadmillDropdownContainer.Visible = false
    ColorDropdownContainer.Visible = false
    LangDropdownContainer.Visible = false
    FxDropdownContainer.Visible = false
end

local function createTabBtn(
    btn,
    thText,
    enText,
    laText,
    page
)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.TextColor3 = Color3.fromRGB(180, 190, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.Parent = SidebarFrame

    registerLangText(
        btn,
        "  " .. thText,
        "  " .. enText,
        "  " .. laText
    )

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(45, 45, 60)
    stroke.Parent = btn

    table.insert(colorObjects, stroke)

    btn.MouseButton1Click:Connect(function()
        FarmPage.Visible = false
        CharmPage.Visible = false
        PlayerPage.Visible = false
        SettingPage.Visible = false

        hideDropdowns()

        FarmTabButton.BackgroundColor3 =
            Color3.fromRGB(25, 25, 35)

        CharmTabButton.BackgroundColor3 =
            Color3.fromRGB(25, 25, 35)

        PlayerTabButton.BackgroundColor3 =
            Color3.fromRGB(25, 25, 35)

        SettingTabButton.BackgroundColor3 =
            Color3.fromRGB(25, 25, 35)

        page.Visible = true
        btn.BackgroundColor3 =
            Color3.fromRGB(0, 100, 200)
    end)
end

createTabBtn(
    FarmTabButton,
    "🌾 ฟังก์ชันฟาร์ม",
    "🌾 Farm Functions",
    "🌾 ຟັງຊັນຟາມ",
    FarmPage
)

createTabBtn(
    CharmTabButton,
    "✨ เครื่องราง",
    "✨ Charm Options",
    "✨ ເຄື່ອງລາງ",
    CharmPage
)

createTabBtn(
    PlayerTabButton,
    "⚙️ ตัวละคร",
    "⚙️ Player",
    "⚙️ ຕົວລະຄອນ",
    PlayerPage
)

createTabBtn(
    SettingTabButton,
    "🌐 ตั้งค่าระบบ",
    "🌐 Settings",
    "🌐 ຕັ້ງຄ່າ",
    SettingPage
)

FarmTabButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

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
    label.TextColor3 = Color3.fromRGB(235, 235, 245)
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
    switchBg.Position = UDim2.new(1, -50, 0.5, -12)
    switchBg.Text = ""
    switchBg.BorderSizePixel = 0
    switchBg.Parent = frame

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBg

    local ball = Instance.new("Frame")
    ball.Size = UDim2.new(0, 18, 0, 18)
    ball.BorderSizePixel = 0
    ball.Parent = switchBg

    local ballCorner = Instance.new("UICorner")
    ballCorner.CornerRadius = UDim.new(1, 0)
    ballCorner.Parent = ball

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
        config[configKey] = not config[configKey]

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
--// TEXT BOX
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
    label.TextColor3 = Color3.fromRGB(0, 180, 255)
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
    box.Position = UDim2.new(0.65, 0, 0.15, 0)
    box.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    box.Text = tostring(config[configKey])
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.SourceSansBold
    box.TextSize = 14
    box.ClearTextOnFocus = false
    box.BorderSizePixel = 0
    box.Parent = frame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = box

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1
    boxStroke.Color = Color3.fromRGB(50, 50, 70)
    boxStroke.Parent = box

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)

        if num then
            config[configKey] = num
            saveConfig()

            pcall(function()
                onChanged(num)
            end)
        else
            box.Text = tostring(config[configKey])
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
    min,
    max,
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
    label.TextColor3 = Color3.fromRGB(0, 180, 255)
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
    sliderBtn.Size = UDim2.new(0, 16, 0, 20)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(0, 215, 255)
    sliderBtn.Text = ""
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Parent = sliderBg

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = sliderBtn

    local currentValue =
        tonumber(config[configKey]) or min

    local percentage =
        math.clamp(
            (currentValue - min) / (max - min),
            0,
            1
        )

    local dragging = false

    local function updateSlider(mouseX)
        local bgX = sliderBg.AbsolutePosition.X
        local bgWidth = sliderBg.AbsoluteSize.X

        if bgWidth <= 0 then
            return
        end

        local percentage =
            math.clamp(
                (mouseX - bgX) / bgWidth,
                0,
                1
            )

        sliderBtn.Position =
            UDim2.new(
                percentage,
                -8,
                0.5,
                -10
            )

        local val =
            min + percentage * (max - min)

        val = math.round(val * 10) / 10

        config[configKey] = val
        saveConfig()

        local prefix =
            getLanguageText(
                thPrefix,
                enPrefix,
                laPrefix
            )

        label.Text =
            prefix .. " -> " .. tostring(val)

        pcall(function()
            onChanged(val)
        end)
    end

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then

                updateSlider(input.Position.X)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    sliderBtn.Position =
        UDim2.new(
            percentage,
            -8,
            0.5,
            -10
        )

    label.Text =
        getLanguageText(
            thPrefix,
            enPrefix,
            laPrefix
        ) .. " -> " .. tostring(currentValue)

    task.spawn(function()
        pcall(function()
            onChanged(currentValue)
        end)
    end)
end

--// =========================================================
--// GAME HELPERS
--// =========================================================

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
        stages:FindFirstChild(
            "Stage" .. tostring(stageNum)
        )

    if not stage then
        return nil
    end

    if stageNum == 1 then
        local main = stage:FindFirstChild("Main")

        if main then
            local stageEnd =
                main:FindFirstChild("StageEnd")

            if stageEnd then
                return stageEnd:FindFirstChild("Button")
            end
        end
    else
        local normalWin =
            stage:FindFirstChild("NormalWin")

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
            local folder =
                stage1:FindFirstChild("TreadmillBasic")

            if folder then
                return folder:FindFirstChild("Basic")
            end
        end

    elseif name == "Gold" then
        local stage1 = stages:FindFirstChild("Stage1")

        if stage1 then
            local folder =
                stage1:FindFirstChild("TreadmillGold")

            if folder then
                return folder:FindFirstChild("Golden")
            end
        end
    end

    local spawn = stages:FindFirstChild("Spawn")

    if not spawn then
        return nil
    end

    local treadmills =
        spawn:FindFirstChild("Treadmills")

    if not treadmills then
        return nil
    end

    local names = {
        Galaxy = {"TreadmillGalaxy", "Galaxy"},
        Void = {"TreadmillVoid", "Void"},
        Celestial = {"TreadmillCelestial", "Celestial"},
        Diamond = {"TreadmillDiamond", "Diamond"},
        Playtime = {"TreadmillPlaytime", "Reward"}
    }

    local data = names[name]

    if data then
        local folder =
            treadmills:FindFirstChild(data[1])

        if folder then
            return folder:FindFirstChild(data[2])
        end
    end

    return nil
end

--// =========================================================
--// FARM PAGE
--// =========================================================

createMenuButton(
    "ออโต้วิน (ดึงปุ่มวินเข้าหาตัว Player)",
    "Auto Win (Pull Buttons to Player)",
    "ອໍໂຕວິນ (ດຶງປຸ່ມວິນຫາ Player)",
    FarmPage,
    "AutoWinActive",
    function(value)
        if value then
            config.AutoTreadmillActive = false
            saveConfig()
        end
    end
)

local dropBtn = Instance.new("TextButton")
dropBtn.Size = UDim2.new(0.96, 0, 0, 38)
dropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
dropBtn.Font = Enum.Font.SourceSansBold
dropBtn.TextSize = 14
dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dropBtn.BorderSizePixel = 0
dropBtn.Parent = FarmPage

local dc = Instance.new("UICorner")
dc.CornerRadius = UDim.new(0, 6)
dc.Parent = dropBtn

local ds1 = Instance.new("UIStroke")
ds1.Thickness = 1
ds1.Color = Color3.fromRGB(0, 150, 255)
ds1.Parent = dropBtn

table.insert(colorObjects, ds1)

registerLangText(
    dropBtn,
    "🎯 เลือกด่าน: " .. tostring(config.SelectedStage),
    "🎯 Select Stage: " .. tostring(config.SelectedStage),
    "🎯 ເລືອກດ່ານ: " .. tostring(config.SelectedStage)
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
            saveConfig()
        end
    end
)

local treadmillDropBtn = Instance.new("TextButton")
treadmillDropBtn.Size = UDim2.new(0.96, 0, 0, 38)
treadmillDropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
treadmillDropBtn.Font = Enum.Font.SourceSansBold
treadmillDropBtn.TextSize = 14
treadmillDropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
treadmillDropBtn.BorderSizePixel = 0
treadmillDropBtn.Parent = FarmPage

local tdc = Instance.new("UICorner")
tdc.CornerRadius = UDim.new(0, 6)
tdc.Parent = treadmillDropBtn

local ds2 = Instance.new("UIStroke")
ds2.Thickness = 1
ds2.Color = Color3.fromRGB(0, 150, 255)
ds2.Parent = treadmillDropBtn

table.insert(colorObjects, ds2)

registerLangText(
    treadmillDropBtn,
    "🏃 เลือกลู่วิ่ง: " .. tostring(config.SelectedTreadmill),
    "🏃 Select Treadmill: " .. tostring(config.SelectedTreadmill),
    "🏃 ເລືອກລູ່ວິ່ງ: " .. tostring(config.SelectedTreadmill)
)

createMenuSlider(
    "หน่วงเวลาการดึงปุ่ม",
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
    "ออเดอร์ออโต้ซื้อของตู้สินค้า (ลำดับ 1,2,3)",
    "Auto Buy Remotes Loop (1,2,3)",
    "ລະບົບຊື້ເຄື່ອງອໍໂຕ (1,2,3)",
    FarmPage,
    "AutoBuyActive",
    function()
    end
)

local fxDropBtn = Instance.new("TextButton")
fxDropBtn.Size = UDim2.new(0.96, 0, 0, 38)
fxDropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
fxDropBtn.Font = Enum.Font.SourceSansBold
fxDropBtn.TextSize = 14
fxDropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fxDropBtn.BorderSizePixel = 0
fxDropBtn.Parent = FarmPage

local fxCorner = Instance.new("UICorner")
fxCorner.CornerRadius = UDim.new(0, 6)
fxCorner.Parent = fxDropBtn

local fxStroke = Instance.new("UIStroke")
fxStroke.Thickness = 1
fxStroke.Color = Color3.fromRGB(0, 150, 255)
fxStroke.Parent = fxDropBtn

table.insert(colorObjects, fxStroke)

registerLangText(
    fxDropBtn,
    "🛒 เลือกระดับตู้สินค้า: Rarity " .. tostring(config.SelectedFxRarity),
    "🛒 Select Shop Rarity: Rarity " .. tostring(config.SelectedFxRarity),
    "🛒 ເລືອກລະດັບຕູ້ສິນຄ້າ: Rarity " .. tostring(config.SelectedFxRarity)
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
charmDropBtn.Size = UDim2.new(0.96, 0, 0, 38)
charmDropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
charmDropBtn.Font = Enum.Font.SourceSansBold
charmDropBtn.TextSize = 14
charmDropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
charmDropBtn.BorderSizePixel = 0
charmDropBtn.Parent = CharmPage

local charmCorner = Instance.new("UICorner")
charmCorner.CornerRadius = UDim.new(0, 6)
charmCorner.Parent = charmDropBtn

local charmStroke = Instance.new("UIStroke")
charmStroke.Thickness = 1
charmStroke.Color = Color3.fromRGB(0, 150, 255)
charmStroke.Parent = charmDropBtn

table.insert(colorObjects, charmStroke)

registerLangText(
    charmDropBtn,
    "✨ เลือกระดับเครื่องราง: Rarity " .. tostring(config.SelectedCharmRarity),
    "✨ Select Charm Rarity: Rarity " .. tostring(config.SelectedCharmRarity),
    "✨ ເລືອກລະດັບເຄື່ອງລາງ: Rarity " .. tostring(config.SelectedCharmRarity)
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
    "🏃 WalkSpeed Value (Type)",
    "🏃 ປັບຄວາມໄວຕົວລະຄອນ (ໃສ່ເລກ)",
    "WalkSpeedVal",
    PlayerPage,
    function(value)
        local character = player.Character
        local humanoid =
            character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
)

createMenuTextBox(
    "🦘 ปรับแรงกระโดดตัวละคร (ใส่เลข)",
    "🦘 JumpPower Value (Type)",
    "🦘 ປັບແຮງກະໂດດຕົວລະຄອນ (ໃສ່ເລກ)",
    "JumpPowerVal",
    PlayerPage,
    function(value)
        local character = player.Character
        local humanoid =
            character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = value
        end
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
themeDropBtn.Size = UDim2.new(0.96, 0, 0, 38)
themeDropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
themeDropBtn.Font = Enum.Font.SourceSansBold
themeDropBtn.TextSize = 14
themeDropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
themeDropBtn.BorderSizePixel = 0
themeDropBtn.Parent = SettingPage

local themeCorner = Instance.new("UICorner")
themeCorner.CornerRadius = UDim.new(0, 6)
themeCorner.Parent = themeDropBtn

local themeStroke = Instance.new("UIStroke")
themeStroke.Thickness = 1
themeStroke.Color = Color3.fromRGB(0, 150, 255)
themeStroke.Parent = themeDropBtn

table.insert(colorObjects, themeStroke)

registerLangText(
    themeDropBtn,
    "🎨 เปลี่ยนสี UI: " .. tostring(config.ThemeColor),
    "🎨 Change UI Theme: " .. tostring(config.ThemeColor),
    "🎨 ປ່ຽນສີ UI: " .. tostring(config.ThemeColor)
)

local langDropBtn = Instance.new("TextButton")
langDropBtn.Size = UDim2.new(0.96, 0, 0, 38)
langDropBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
langDropBtn.Font = Enum.Font.SourceSansBold
langDropBtn.TextSize = 14
langDropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langDropBtn.BorderSizePixel = 0
langDropBtn.Parent = SettingPage

local langCorner = Instance.new("UICorner")
langCorner.CornerRadius = UDim.new(0, 6)
langCorner.Parent = langDropBtn

local langStroke = Instance.new("UIStroke")
langStroke.Thickness = 1
langStroke.Color = Color3.fromRGB(0, 150, 255)
langStroke.Parent = langDropBtn

table.insert(colorObjects, langStroke)

registerLangText(
    langDropBtn,
    "🌐 เปลี่ยนภาษา: " .. tostring(config.Language),
    "🌐 Change Language: " .. tostring(config.Language),
    "🌐 ປ່ຽນພາສາ: " .. tostring(config.Language)
)

--// =========================================================
--// DROPDOWN OPTIONS
--// =========================================================

local function createDropdownOption(text, value)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.ZIndex = 51
    btn.Parent = DropdownContainer

    btn.MouseButton1Click:Connect(function()
        config.SelectedStage = value
        saveConfig()

        dropBtn.Text =
            getLanguageText(
                "🎯 เลือกด่าน: ",
                "🎯 Select Stage: ",
                "🎯 ເລືອກດ່ານ: "
            ) .. text

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
    btn.ZIndex = 51
    btn.Parent = TreadmillDropdownContainer

    btn.MouseButton1Click:Connect(function()
        config.SelectedTreadmill = value
        saveConfig()

        treadmillDropBtn.Text =
            getLanguageText(
                "🏃 เลือกลู่วิ่ง: ",
                "🏃 Select Treadmill: ",
                "🏃 ເລືອກລູ່ວິ່ງ: "
            ) .. text

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
    btn.ZIndex = 51
    btn.Parent = CharmDropdownContainer

    btn.MouseButton1Click:Connect(function()
        config.SelectedCharmRarity = value
        saveConfig()

        charmDropBtn.Text =
            getLanguageText(
                "✨ ระดับเครื่องราง: ",
                "✨ Charm Rarity: ",
                "✨ ລະດັບເຄື່ອງລາງ: "
            ) .. text

        CharmDropdownContainer.Visible = false
    end)
end

createCharmOption("Common (ระดับ 1)", 1)
createCharmOption("Rare (ระดับ 2)", 2)
createCharmOption("Epic (ระดับ 3)", 3)
createCharmOption("Legendary (ระดับ 4)", 4)
createCharmOption("Mythical (ระดับ 5)", 5)
createCharmOption("Secret (ระดับ 6)", 6)

local function createFxOption(text, value)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.ZIndex = 51
    btn.Parent = FxDropdownContainer

    btn.MouseButton1Click:Connect(function()
        config.SelectedFxRarity = value
        saveConfig()

        fxDropBtn.Text =
            getLanguageText(
                "🛒 เลือกระดับตู้สินค้า: ",
                "🛒 Shop Rarity: ",
                "🛒 ເລືອກລະດັບຕູ້ສິນຄ້າ: "
            ) .. text

        FxDropdownContainer.Visible = false
    end)
end

createFxOption("Common (ระดับ 1)", 1)
createFxOption("Rare (ระดับ 2)", 2)
createFxOption("Epic (ระดับ 3)", 3)
createFxOption("Legendary (ระดับ 4)", 4)
createFxOption("Mythical (ระดับ 5)", 5)
createFxOption("Secret (ระดับ 6)", 6)

local function createColorOption(text, colorKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.ZIndex = 51
    btn.Parent = ColorDropdownContainer

    btn.MouseButton1Click:Connect(function()
        updateThemeColor(colorKey)

        themeDropBtn.Text =
            getLanguageText(
                "🎨 เปลี่ยนสี UI: ",
                "🎨 Change UI Theme: ",
                "🎨 ປ່ຽນສີ UI: "
            ) .. text

        ColorDropdownContainer.Visible = false
    end)
end

createColorOption("Cyan", "Cyan")
createColorOption("Yellow", "Yellow")
createColorOption("White", "White")
createColorOption("Red", "Red")
createColorOption("Green", "Green")
createColorOption("Blue", "Blue")
createColorOption("Pink", "Pink")
createColorOption("Purple", "Purple")
createColorOption("Orange", "Orange")
createColorOption("Rainbow", "Rainbow")

local function createLangOption(text, langKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.ZIndex = 51
    btn.Parent = LangDropdownContainer

    btn.MouseButton1Click:Connect(function()
        _G.Language = langKey
        config.Language = langKey

        saveConfig()
        updateLanguageDisplay()

        langDropBtn.Text =
            getLanguageText(
                "🌐 เปลี่ยนภาษา: ",
                "🌐 Change Language: ",
                "🌐 ປ່ຽນພາສາ: "
            ) .. text

        LangDropdownContainer.Visible = false
    end)
end

createLangOption("ภาษาไทย (TH)", "TH")
createLangOption("English (EN)", "EN")
createLangOption("ພາສາລາວ (LA)", "LA")
createLangOption("日本語 (JP)", "JP")
createLangOption("한국어 (KR)", "KR")
createLangOption("简体中文 (CN)", "CN")
createLangOption("Tiếng Việt (VN)", "VN")
createLangOption("Русский (RU)", "RU")
createLangOption("Español (ES)", "ES")
createLangOption("Français (FR)", "FR")

--// =========================================================
--// DROPDOWN EVENTS
--// =========================================================

dropBtn.MouseButton1Click:Connect(function()
    local state = not DropdownContainer.Visible

    hideDropdowns()
    DropdownContainer.Visible = state
end)

treadmillDropBtn.MouseButton1Click:Connect(function()
    local state = not TreadmillDropdownContainer.Visible

    hideDropdowns()
    TreadmillDropdownContainer.Visible = state
end)

charmDropBtn.MouseButton1Click:Connect(function()
    local state = not CharmDropdownContainer.Visible

    hideDropdowns()
    CharmDropdownContainer.Visible = state
end)

themeDropBtn.MouseButton1Click:Connect(function()
    local state = not ColorDropdownContainer.Visible

    hideDropdowns()
    ColorDropdownContainer.Visible = state
end)

langDropBtn.MouseButton1Click:Connect(function()
    local state = not LangDropdownContainer.Visible

    hideDropdowns()
    LangDropdownContainer.Visible = state
end)

fxDropBtn.MouseButton1Click:Connect(function()
    local state = not FxDropdownContainer.Visible

    hideDropdowns()
    FxDropdownContainer.Visible = state
end)

--// =========================================================
--// CLOSE / MINIMIZE
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
                    network:FindFirstChild("ServerStatsItem")

                if serverStats then
                    local dataPing =
                        serverStats:FindFirstChild("Data Ping")

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

            local col =
                Color3.fromHSV(
                    rainbowTick % 1,
                    0.8,
                    1
                )

            MainStroke.Color = col
            TitleLabel.TextColor3 = col

            for _, obj in ipairs(colorObjects) do
                if obj and obj.Parent then
                    if obj:IsA("UIStroke") then
                        obj.Color = col
                    elseif obj:IsA("TextLabel")
                        and obj.Name == "SliderLabel" then
                        obj.TextColor3 = col
                    end
                end
            end
        end
    end
end)

--// =========================================================
--// AUTO WIN / TREADMILL
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(
            math.max(
                tonumber(config.WarpDelay) or 0.5,
                0.1
            )
        )

        if not player.Character then
            continue
        end

        local root =
            player.Character:FindFirstChild(
                "HumanoidRootPart"
            )

        if not root then
            continue
        end

        if config.AutoWinActive then
            pcall(function()
                if config.SelectedStage == "Auto" then
                    for i = 1, 9 do
                        if not config.AutoWinActive then
                            break
                        end

                        local btn =
                            getStageButton(i)

                        if btn then
                            btn.CFrame = root.CFrame
                        end

                        task.wait(0.05)
                    end
                else
                    local stageNumber =
                        tonumber(
                            config.SelectedStage
                        )

                    if stageNumber then
                        local btn =
                            getStageButton(stageNumber)

                        if btn then
                            btn.CFrame = root.CFrame
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

                if treadmill then
                    root.CFrame =
                        treadmill.CFrame
                end
            end)
        end
    end
end)

--// =========================================================
--// AUTO BUY
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.5)

        if config.AutoBuyActive then
            pcall(function()
                local ReplicatedStorage =
                    game:GetService(
                        "ReplicatedStorage"
                    )

                local remotes =
                    ReplicatedStorage:FindFirstChild(
                        "Remotes"
                    )

                if not remotes then
                    return
                end

                local remote =
                    remotes:FindFirstChild(
                        "SetPendingCharmSlot"
                    )

                if remote then
                    remote:FireServer(1)
                    task.wait(0.05)

                    remote:FireServer(2)
                    task.wait(0.05)

                    remote:FireServer(3)
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
                local ReplicatedStorage =
                    game:GetService(
                        "ReplicatedStorage"
                    )

                local remotes =
                    ReplicatedStorage:FindFirstChild(
                        "Remotes"
                    )

                if not remotes then
                    return
                end

                local rebirth =
                    remotes:FindFirstChild(
                        "Rebirth"
                    )

                if rebirth then
                    rebirth:FireServer()
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
                0.1
            )
        )

        if config.AutoCharmActive then
            pcall(function()
                local ReplicatedStorage =
                    game:GetService(
                        "ReplicatedStorage"
                    )

                local remotes =
                    ReplicatedStorage:FindFirstChild(
                        "Remotes"
                    )

                if not remotes then
                    return
                end

                local buyCharm =
                    remotes:FindFirstChild(
                        "BuyCharm"
                    )

                if buyCharm then
                    buyCharm:FireServer(
                        config.SelectedCharmRarity
                    )
                end
            end)
        end
    end
end)

--// =========================================================
--// PLAYER SETTINGS LOOP
--// =========================================================

local function applyCharacterSettings()
    local character = player.Character

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

    humanoid.WalkSpeed =
        tonumber(config.WalkSpeedVal) or 16

    humanoid.UseJumpPower = true

    humanoid.JumpPower =
        tonumber(config.JumpPowerVal) or 50
end

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.1)

        pcall(function()
            applyCharacterSettings()
        end)
    end
end)

player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid", 5)

    task.wait(0.2)

    pcall(function()
        applyCharacterSettings()
    end)
end)

--// =========================================================
--// INFINITE JUMP
--// =========================================================

UserInputService.JumpRequest:Connect(function()
    if not config.InfiniteJumpActive then
        return
    end

    pcall(function()
        local character = player.Character

        if not character then
            return
        end

        local humanoid =
            character:FindFirstChildOfClass(
                "Humanoid"
            )

        local root =
            character:FindFirstChild(
                "HumanoidRootPart"
            )

        if humanoid and root then
            humanoid:ChangeState(
                Enum.HumanoidStateType.Jumping
            )

            root.AssemblyLinearVelocity =
                Vector3.new(
                    root.AssemblyLinearVelocity.X,
                    tonumber(config.JumpPowerVal) or 50,
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

-- Set initial dynamic texts
dropBtn.Text =
    getLanguageText(
        "🎯 เลือกด่าน: ",
        "🎯 Select Stage: ",
        "🎯 ເລືອກດ່ານ: "
    ) .. tostring(config.SelectedStage)

treadmillDropBtn.Text =
    getLanguageText(
        "🏃 เลือกลู่วิ่ง: ",
        "🏃 Select Treadmill: ",
        "🏃 ເລືອກລູ່ວິ່ງ: "
    ) .. tostring(config.SelectedTreadmill)

charmDropBtn.Text =
    getLanguageText(
        "✨ ระดับเครื่องราง: ",
        "✨ Charm Rarity: ",
        "✨ ລະດັບເຄື່ອງລາງ: "
    ) .. tostring(config.SelectedCharmRarity)

fxDropBtn.Text =
    getLanguageText(
        "🛒 เลือกระดับตู้สินค้า: ",
        "🛒 Shop Rarity: ",
        "🛒 ເລືອກລະດັບຕູ້ສິນຄ້າ: "
    ) .. tostring(config.SelectedFxRarity)

themeDropBtn.Text =
    getLanguageText(
        "🎨 เปลี่ยนสี UI: ",
        "🎨 Change UI Theme: ",
        "🎨 ປ່ຽນສີ UI: "
    ) .. tostring(config.ThemeColor)

langDropBtn.Text =
    getLanguageText(
        "🌐 เปลี่ยนภาษา: ",
        "🌐 Change Language: ",
        "🌐 ປ່ຽນພາສາ: "
    ) .. tostring(config.Language)

print("SpeedFC Hub loaded successfully.")
