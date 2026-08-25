--// =========================================================
--// speedFC.ค่าย - GUI ONLY EDITION
--// GUI / Effects / Theme / Language / Drag / Minimize
--// NO GAME FUNCTIONS
--// =========================================================

--// =========================================================
--// SERVICES
--// =========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--// =========================================================
--// REMOVE OLD GUI
--// =========================================================

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
--// GUI CONFIG
--// =========================================================

local config = {
    Language = "TH",
    ThemeColor = "Cyan"
}

_G.Language = config.Language
_G.ThemeColor = config.ThemeColor

--// =========================================================
--// SCREEN GUI
--// =========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedFCHubUltimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--// =========================================================
--// MAIN FRAME
--// =========================================================

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

--// Avatar

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "AvatarImage"
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

--// Ping / Player Count

local PlayerCountLabel = Instance.new("TextLabel")
PlayerCountLabel.Name = "PlayerCountLabel"
PlayerCountLabel.Parent = TopBar
PlayerCountLabel.Position = UDim2.new(0.5, 0, 0, 0)
PlayerCountLabel.Size = UDim2.new(0.32, 0, 1, 0)
PlayerCountLabel.BackgroundTransparency = 1
PlayerCountLabel.Text = "🎮 Ping: 0ms | 1/12"
PlayerCountLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
PlayerCountLabel.Font = Enum.Font.SourceSansBold
PlayerCountLabel.TextSize = 13
PlayerCountLabel.TextXAlignment = Enum.TextXAlignment.Right

--// =========================================================
--// MINIMIZE BUTTON
--// =========================================================

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
MinimizeButton.BorderSizePixel = 0

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 5)
MinBtnCorner.Parent = MinimizeButton

--// =========================================================
--// CLOSE BUTTON
--// =========================================================

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
    for object, data in pairs(textLabels) do
        if object and object.Parent then
            object.Text = getLanguageText(
                data.TH,
                data.EN,
                data.LA
            )
        end
    end
end

--// =========================================================
--// COLOR SYSTEM
--// =========================================================

local colorObjects = {}

local function getThemeColor(colorName)

    if colorName == "Yellow" then
        return Color3.fromRGB(255, 215, 0)

    elseif colorName == "White" then
        return Color3.fromRGB(240, 240, 240)

    elseif colorName == "Red" then
        return Color3.fromRGB(255, 30, 30)

    elseif colorName == "Green" then
        return Color3.fromRGB(0, 230, 100)

    elseif colorName == "Blue" then
        return Color3.fromRGB(0, 80, 255)

    elseif colorName == "Pink" then
        return Color3.fromRGB(255, 105, 180)

    elseif colorName == "Purple" then
        return Color3.fromRGB(150, 0, 255)

    elseif colorName == "Orange" then
        return Color3.fromRGB(255, 130, 0)

    else
        return Color3.fromRGB(0, 180, 255)
    end
end

local function updateThemeColor(colorName)

    _G.ThemeColor = colorName
    config.ThemeColor = colorName

    if colorName == "Rainbow" then
        return
    end

    local targetColor = getThemeColor(colorName)

    MainStroke.Color = targetColor
    TitleLabel.TextColor3 = targetColor

    for _, object in ipairs(colorObjects) do

        if object and object.Parent then

            if object:IsA("UIStroke") then
                object.Color = targetColor

            elseif object:IsA("TextLabel")
                and object.Name == "SliderLabel" then

                object.TextColor3 = targetColor

            elseif object:IsA("TextButton")
                and object.Name == "ThemeAccent" then

                object.TextColor3 = targetColor
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

        local delta =
            input.Position - dragStart

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

                if input.UserInputState
                    == Enum.UserInputState.End then

                    dragging = false
                end
            end)
        end
    end)

    dragAnchor.InputChanged:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            local connection

            connection =
                UserInputService.InputChanged:Connect(function(changedInput)

                    if changedInput == input
                        and dragging then

                        update(changedInput)
                    end
                end)

            input.Changed:Connect(function()

                if input.UserInputState
                    == Enum.UserInputState.End then

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
--// PAGE SYSTEM
--// =========================================================

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
--// TAB BUTTONS
--// =========================================================

local FarmTabButton = Instance.new("TextButton")
local CharmTabButton = Instance.new("TextButton")
local PlayerTabButton = Instance.new("TextButton")
local SettingTabButton = Instance.new("TextButton")

local function hidePages()

    FarmPage.Visible = false
    CharmPage.Visible = false
    PlayerPage.Visible = false
    SettingPage.Visible = false

end

local function createTabButton(
    button,
    thText,
    enText,
    laText,
    page
)

    button.Size =
        UDim2.new(1, 0, 0, 38)

    button.BackgroundColor3 =
        Color3.fromRGB(25, 25, 35)

    button.TextColor3 =
        Color3.fromRGB(180, 190, 200)

    button.Font =
        Enum.Font.SourceSansBold

    button.TextSize = 14

    button.TextXAlignment =
        Enum.TextXAlignment.Left

    button.BorderSizePixel = 0

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

        hidePages()

        FarmTabButton.BackgroundColor3 =
            Color3.fromRGB(25, 25, 35)

        CharmTabButton.BackgroundColor3 =
            Color3.fromRGB(25, 25, 35)

        PlayerTabButton.BackgroundColor3 =
            Color3.fromRGB(25, 25, 35)

        SettingTabButton.BackgroundColor3 =
            Color3.fromRGB(25, 25, 35)

        page.Visible = true

        button.BackgroundColor3 =
            Color3.fromRGB(0, 100, 200)

    end)
end

createTabButton(
    FarmTabButton,
    "หน้าหลัก",
    "Home",
    "ໜ້າຫຼັກ",
    FarmPage
)

createTabButton(
    CharmTabButton,
    "เอฟเฟกต์",
    "Effects",
    "ເອັບເຟັກ",
    CharmPage
)

createTabButton(
    PlayerTabButton,
    "ข้อมูล",
    "Info",
    "ຂໍ້ມູນ",
    PlayerPage
)

createTabButton(
    SettingTabButton,
    "ตั้งค่า GUI",
    "GUI Settings",
    "ຕັ້ງຄ່າ GUI",
    SettingPage
)

FarmTabButton.BackgroundColor3 =
    Color3.fromRGB(0, 100, 200)

--// =========================================================
--// GUI CONTENT
--// =========================================================

local function createInfoLabel(parent, text)

    local label = Instance.new("TextLabel")

    label.Size =
        UDim2.new(0.96, 0, 0, 40)

    label.BackgroundColor3 =
        Color3.fromRGB(25, 25, 35)

    label.TextColor3 =
        Color3.fromRGB(230, 230, 240)

    label.Text =
        text

    label.Font =
        Enum.Font.SourceSansBold

    label.TextSize = 14

    label.BorderSizePixel = 0

    label.Parent = parent

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 7)

    corner.Parent = label

    return label
end

--// HOME

local HomeTitle =
    createInfoLabel(
        FarmPage,
        "🌟 speedFC GUI"
    )

registerLangText(
    HomeTitle,
    "🌟 speedFC GUI",
    "🌟 speedFC GUI",
    "🌟 speedFC GUI"
)

local HomeInfo =
    createInfoLabel(
        FarmPage,
        "GUI Only • ไม่มีระบบฟังก์ชันเกม"
    )

registerLangText(
    HomeInfo,
    "GUI Only • ไม่มีระบบฟังก์ชันเกม",
    "GUI Only • No Game Functions",
    "GUI Only • ບໍ່ມີຟັງຊັນເກມ"
)

--// EFFECTS

local EffectTitle =
    createInfoLabel(
        CharmPage,
        "✨ GUI Effects"
    )

registerLangText(
    EffectTitle,
    "✨ เอฟเฟกต์ GUI",
    "✨ GUI Effects",
    "✨ ເອັບເຟັກ GUI"
)

local EffectInfo =
    createInfoLabel(
        CharmPage,
        "🌈 Rainbow / Glow / UI Animation"
    )

registerLangText(
    EffectInfo,
    "🌈 Rainbow / Glow / UI Animation",
    "🌈 Rainbow / Glow / UI Animation",
    "🌈 Rainbow / Glow / UI Animation"
)

--// INFO

local InfoTitle =
    createInfoLabel(
        PlayerPage,
        "👤 Player Information"
    )

registerLangText(
    InfoTitle,
    "👤 ข้อมูลผู้เล่น",
    "👤 Player Information",
    "👤 ຂໍ້ມູນຜູ້ຫຼິ້ນ"
)

local InfoName =
    createInfoLabel(
        PlayerPage,
        "ชื่อ: " .. player.Name
    )

local InfoID =
    createInfoLabel(
        PlayerPage,
        "UserId: " .. tostring(player.UserId)
    )

--// =========================================================
--// SETTINGS
--// =========================================================

local ThemeButton = Instance.new("TextButton")

ThemeButton.Name = "ThemeButton"
ThemeButton.Size =
    UDim2.new(0.96, 0, 0, 42)

ThemeButton.BackgroundColor3 =
    Color3.fromRGB(30, 30, 42)

ThemeButton.TextColor3 =
    Color3.fromRGB(255, 255, 255)

ThemeButton.Font =
    Enum.Font.SourceSansBold

ThemeButton.TextSize = 14

ThemeButton.BorderSizePixel = 0
ThemeButton.Parent = SettingPage

local ThemeCorner =
    Instance.new("UICorner")

ThemeCorner.CornerRadius =
    UDim.new(0, 7)

ThemeCorner.Parent = ThemeButton

local ThemeStroke =
    Instance.new("UIStroke")

ThemeStroke.Thickness = 1
ThemeStroke.Color =
    Color3.fromRGB(0, 150, 255)

ThemeStroke.Parent = ThemeButton

table.insert(colorObjects, ThemeStroke)

--// =========================================================
--// THEME DROPDOWN
--// =========================================================

local ThemeDropdown =
    Instance.new("ScrollingFrame")

ThemeDropdown.Name =
    "ThemeDropdown"

ThemeDropdown.Size =
    UDim2.new(0.96, 0, 0, 150)

ThemeDropdown.BackgroundColor3 =
    Color3.fromRGB(20, 20, 28)

ThemeDropdown.BorderSizePixel = 0
ThemeDropdown.ScrollBarThickness = 4
ThemeDropdown.Visible = false
ThemeDropdown.Parent = SettingPage

local ThemeLayout =
    Instance.new("UIListLayout")

ThemeLayout.Parent =
    ThemeDropdown

ThemeLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

--// =========================================================
--// THEME OPTIONS
--// =========================================================

local themeNames = {
    "Cyan",
    "Yellow",
    "White",
    "Red",
    "Green",
    "Blue",
    "Pink",
    "Purple",
    "Orange",
    "Rainbow"
}

for _, themeName in ipairs(themeNames) do

    local button =
        Instance.new("TextButton")

    button.Size =
        UDim2.new(1, 0, 0, 32)

    button.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)

    button.Text =
        "🎨 " .. themeName

    button.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    button.Font =
        Enum.Font.SourceSansBold

    button.TextSize = 14

    button.BorderSizePixel = 0

    button.Parent = ThemeDropdown

    button.MouseButton1Click:Connect(function()

        config.ThemeColor =
            themeName

        ThemeButton.Text =
            "🎨 Theme: "
            .. themeName

        ThemeDropdown.Visible =
            false

        updateThemeColor(themeName)

    end)
end

ThemeButton.MouseButton1Click:Connect(function()

    ThemeDropdown.Visible =
        not ThemeDropdown.Visible

end)

--// =========================================================
--// LANGUAGE BUTTON
--// =========================================================

local LanguageButton =
    Instance.new("TextButton")

LanguageButton.Name =
    "LanguageButton"

LanguageButton.Size =
    UDim2.new(0.96, 0, 0, 42)

LanguageButton.BackgroundColor3 =
    Color3.fromRGB(30, 30, 42)

LanguageButton.TextColor3 =
    Color3.fromRGB(255, 255, 255)

LanguageButton.Font =
    Enum.Font.SourceSansBold

LanguageButton.TextSize = 14

LanguageButton.BorderSizePixel = 0
LanguageButton.Parent = SettingPage

local LangCorner =
    Instance.new("UICorner")

LangCorner.CornerRadius =
    UDim.new(0, 7)

LangCorner.Parent =
    LanguageButton

local LangStroke =
    Instance.new("UIStroke")

LangStroke.Thickness = 1
LangStroke.Color =
    Color3.fromRGB(0, 150, 255)

LangStroke.Parent =
    LanguageButton

table.insert(
    colorObjects,
    LangStroke
)

--// =========================================================
--// LANGUAGE DROPDOWN
--// =========================================================

local LanguageDropdown =
    Instance.new("ScrollingFrame")

LanguageDropdown.Name =
    "LanguageDropdown"

LanguageDropdown.Size =
    UDim2.new(0.96, 0, 0, 150)

LanguageDropdown.BackgroundColor3 =
    Color3.fromRGB(20, 20, 28)

LanguageDropdown.BorderSizePixel = 0
LanguageDropdown.ScrollBarThickness = 4
LanguageDropdown.Visible = false
LanguageDropdown.Parent = SettingPage

local LanguageLayout =
    Instance.new("UIListLayout")

LanguageLayout.Parent =
    LanguageDropdown

LanguageLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

local languages = {
    {
        name = "ภาษาไทย (TH)",
        key = "TH"
    },
    {
        name = "English (EN)",
        key = "EN"
    },
    {
        name = "ພາສາລາວ (LA)",
        key = "LA"
    }
}

for _, language in ipairs(languages) do

    local button =
        Instance.new("TextButton")

    button.Size =
        UDim2.new(1, 0, 0, 32)

    button.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)

    button.Text =
        language.name

    button.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    button.Font =
        Enum.Font.SourceSansBold

    button.TextSize = 14

    button.BorderSizePixel = 0

    button.Parent =
        LanguageDropdown

    button.MouseButton1Click:Connect(function()

        _G.Language =
            language.key

        config.Language =
            language.key

        LanguageButton.Text =
            "🌐 Language: "
            .. language.name

        LanguageDropdown.Visible =
            false

        updateLanguageDisplay()

    end)
end

LanguageButton.MouseButton1Click:Connect(function()

    LanguageDropdown.Visible =
        not LanguageDropdown.Visible

end)

--// =========================================================
--// INITIAL SETTINGS
--// =========================================================

ThemeButton.Text =
    "🎨 Theme: "
    .. config.ThemeColor

LanguageButton.Text =
    "🌐 Language: "
    .. config.Language

updateThemeColor(
    config.ThemeColor
)

updateLanguageDisplay()

--// =========================================================
--// MINIMIZE / RESTORE
--// =========================================================

MinimizeButton.MouseButton1Click:Connect(function()

    MainFrame.Visible = false
    MiniButton.Visible = true

end)

MiniButton.MouseButton1Click:Connect(function()

    MainFrame.Visible = true
    MiniButton.Visible = false

end)

--// =========================================================
--// CLOSE
--// =========================================================

CloseButton.MouseButton1Click:Connect(function()

    ScreenGui:Destroy()

end)

--// =========================================================
--// PING / PLAYER COUNT
--// GUI DISPLAY ONLY
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
--// RAINBOW GUI EFFECT
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

            MainStroke.Color =
                color

            TitleLabel.TextColor3 =
                color

            for _, object in ipairs(colorObjects) do

                if object and object.Parent then

                    if object:IsA("UIStroke") then

                        object.Color =
                            color

                    elseif object:IsA("TextLabel")
                        and object.Name
                        == "SliderLabel" then

                        object.TextColor3 =
                            color
                    end
                end
            end
        end
    end

end)

--// =========================================================
--// GUI GLOW EFFECT
--// =========================================================

task.spawn(function()

    local pulse = 0

    while ScreenGui.Parent do

        task.wait(0.05)

        pulse += 0.03

        local alpha =
            (math.sin(pulse) + 1) / 2

        if _G.ThemeColor ~= "Rainbow" then

            local base =
                getThemeColor(
                    _G.ThemeColor
                )

            local glow =
                base:Lerp(
                    Color3.fromRGB(
                        255,
                        255,
                        255
                    ),
                    alpha * 0.15
                )

            MainStroke.Color =
                glow
        end
    end

end)

print(
    "speedFC GUI Only loaded successfully."
)
