--// =========================================================
--// speedFC.ค่าย - Ultimate Hub
--// FIXED FULL VERSION
--// Mobile + PC / Config Save / UI / Fly / Farm
--// =========================================================

--// =========================================================
--// SERVICES
--// =========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--// =========================================================
--// GLOBAL CONFIG
--// =========================================================

_G.Language = _G.Language or "TH"

_G.AutoWinActive = _G.AutoWinActive or false
_G.AutoTreadmillActive = _G.AutoTreadmillActive or false
_G.AutoRebirthActive = _G.AutoRebirthActive or false
_G.AutoBuyActive = _G.AutoBuyActive or false
_G.AutoCharmActive = _G.AutoCharmActive or false
_G.InfiniteJumpActive = _G.InfiniteJumpActive or false
_G.FlyActive = _G.FlyActive or false

_G.SelectedStage = _G.SelectedStage or "Auto"
_G.SelectedTreadmill = _G.SelectedTreadmill or "Basic"
_G.SelectedCharmRarity = tonumber(_G.SelectedCharmRarity) or 1

_G.WarpDelay = tonumber(_G.WarpDelay) or 0.5
_G.CharmDelay = tonumber(_G.CharmDelay) or 1

_G.WalkSpeedVal = tonumber(_G.WalkSpeedVal) or 16
_G.JumpPowerVal = tonumber(_G.JumpPowerVal) or 50
_G.FlySpeedVal = tonumber(_G.FlySpeedVal) or 50

--// Clamp initial values
_G.WarpDelay = math.clamp(_G.WarpDelay, 0.05, 30)
_G.CharmDelay = math.clamp(_G.CharmDelay, 0.05, 30)

_G.WalkSpeedVal = math.clamp(_G.WalkSpeedVal, 1, 250)
_G.JumpPowerVal = math.clamp(_G.JumpPowerVal, 1, 250)
_G.FlySpeedVal = math.clamp(_G.FlySpeedVal, 1, 250)

--// =========================================================
--// CONFIG SYSTEM
--// =========================================================

local fileName = "speedFC_Config.json"

local function saveConfig()
    pcall(function()

        if not writefile then
            return
        end

        local config = {
            Language = _G.Language,

            AutoWinActive = _G.AutoWinActive,
            AutoTreadmillActive = _G.AutoTreadmillActive,
            AutoRebirthActive = _G.AutoRebirthActive,
            AutoBuyActive = _G.AutoBuyActive,
            AutoCharmActive = _G.AutoCharmActive,
            InfiniteJumpActive = _G.InfiniteJumpActive,
            FlyActive = _G.FlyActive,

            SelectedStage = _G.SelectedStage,
            SelectedTreadmill = _G.SelectedTreadmill,
            SelectedCharmRarity = _G.SelectedCharmRarity,

            WarpDelay = _G.WarpDelay,
            CharmDelay = _G.CharmDelay,

            WalkSpeedVal = _G.WalkSpeedVal,
            JumpPowerVal = _G.JumpPowerVal,
            FlySpeedVal = _G.FlySpeedVal
        }

        writefile(
            fileName,
            HttpService:JSONEncode(config)
        )
    end)
end

local function loadConfig()

    pcall(function()

        if not readfile or not isfile then
            return
        end

        if not isfile(fileName) then
            return
        end

        local raw = readfile(fileName)

        if not raw or raw == "" then
            return
        end

        local loaded = HttpService:JSONDecode(raw)

        if type(loaded) ~= "table" then
            return
        end

        if loaded.Language == "TH"
            or loaded.Language == "EN" then

            _G.Language = loaded.Language
        end

        if loaded.AutoWinActive ~= nil then
            _G.AutoWinActive = loaded.AutoWinActive == true
        end

        if loaded.AutoTreadmillActive ~= nil then
            _G.AutoTreadmillActive =
                loaded.AutoTreadmillActive == true
        end

        if loaded.AutoRebirthActive ~= nil then
            _G.AutoRebirthActive =
                loaded.AutoRebirthActive == true
        end

        if loaded.AutoBuyActive ~= nil then
            _G.AutoBuyActive =
                loaded.AutoBuyActive == true
        end

        if loaded.AutoCharmActive ~= nil then
            _G.AutoCharmActive =
                loaded.AutoCharmActive == true
        end

        if loaded.InfiniteJumpActive ~= nil then
            _G.InfiniteJumpActive =
                loaded.InfiniteJumpActive == true
        end

        if loaded.FlyActive ~= nil then
            _G.FlyActive =
                loaded.FlyActive == true
        end

        if loaded.SelectedStage ~= nil then
            _G.SelectedStage =
                tostring(loaded.SelectedStage)
        end

        if loaded.SelectedTreadmill ~= nil then
            _G.SelectedTreadmill =
                tostring(loaded.SelectedTreadmill)
        end

        if loaded.SelectedCharmRarity ~= nil then
            _G.SelectedCharmRarity =
                math.clamp(
                    tonumber(loaded.SelectedCharmRarity) or 1,
                    1,
                    10
                )
        end

        if loaded.WarpDelay ~= nil then
            _G.WarpDelay =
                math.clamp(
                    tonumber(loaded.WarpDelay) or 0.5,
                    0.05,
                    30
                )
        end

        if loaded.CharmDelay ~= nil then
            _G.CharmDelay =
                math.clamp(
                    tonumber(loaded.CharmDelay) or 1,
                    0.05,
                    30
                )
        end

        if loaded.WalkSpeedVal ~= nil then
            _G.WalkSpeedVal =
                math.clamp(
                    tonumber(loaded.WalkSpeedVal) or 16,
                    1,
                    250
                )
        end

        if loaded.JumpPowerVal ~= nil then
            _G.JumpPowerVal =
                math.clamp(
                    tonumber(loaded.JumpPowerVal) or 50,
                    1,
                    250
                )
        end

        if loaded.FlySpeedVal ~= nil then
            _G.FlySpeedVal =
                math.clamp(
                    tonumber(loaded.FlySpeedVal) or 50,
                    1,
                    250
                )
        end

    end)
end

loadConfig()

--// =========================================================
--// REMOVE OLD GUI
--// =========================================================

pcall(function()

    local CoreGui = game:GetService("CoreGui")
    local old = CoreGui:FindFirstChild(
        "SpeedFCHubUltimate"
    )

    if old then
        old:Destroy()
    end

end)

pcall(function()

    local old = PlayerGui:FindFirstChild(
        "SpeedFCHubUltimate"
    )

    if old then
        old:Destroy()
    end

end)

--// =========================================================
--// SCREEN GUI
--// =========================================================

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "SpeedFCHubUltimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = PlayerGui
end

--// =========================================================
--// MAIN FRAME
--// =========================================================

local MainFrame = Instance.new("Frame")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui

MainFrame.BackgroundColor3 =
    Color3.fromRGB(15, 15, 22)

MainFrame.BackgroundTransparency = 0.08
MainFrame.Position =
    UDim2.new(0.5, -260, 0.5, -160)

MainFrame.Size =
    UDim2.new(0, 520, 0, 320)

MainFrame.Active = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius =
    UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color =
    Color3.fromRGB(0, 180, 255)
MainStroke.Parent = MainFrame

--// =========================================================
--// TOP BAR
--// =========================================================

local TopBar = Instance.new("Frame")

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame

TopBar.Size =
    UDim2.new(1, 0, 0, 40)

TopBar.BackgroundColor3 =
    Color3.fromRGB(22, 22, 30)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius =
    UDim.new(0, 10)
TopCorner.Parent = TopBar

--// =========================================================
--// AVATAR
--// =========================================================

local AvatarImage = Instance.new("ImageLabel")

AvatarImage.Parent = TopBar
AvatarImage.Position =
    UDim2.new(0, 8, 0, 5)

AvatarImage.Size =
    UDim2.new(0, 30, 0, 30)

AvatarImage.BackgroundTransparency = 1

pcall(function()

    AvatarImage.Image =
        "rbxthumb://type=AvatarHeadShot&id="
        .. tostring(player.UserId)
        .. "&w=150&h=150"

end)

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius =
    UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

--// =========================================================
--// TITLE
--// =========================================================

local TitleLabel = Instance.new("TextLabel")

TitleLabel.Parent = TopBar

TitleLabel.Position =
    UDim2.new(0, 46, 0, 0)

TitleLabel.Size =
    UDim2.new(0, 190, 1, 0)

TitleLabel.BackgroundTransparency = 1

TitleLabel.Text =
    "speedFC.ค่าย"

TitleLabel.TextColor3 =
    Color3.fromRGB(0, 215, 255)

TitleLabel.Font =
    Enum.Font.SourceSansBold

TitleLabel.TextSize = 18

TitleLabel.TextXAlignment =
    Enum.TextXAlignment.Left

--// =========================================================
--// SERVER COUNT
--// =========================================================

local PlayerCountLabel = Instance.new("TextLabel")

PlayerCountLabel.Parent = TopBar

PlayerCountLabel.Position =
    UDim2.new(0.48, 0, 0, 0)

PlayerCountLabel.Size =
    UDim2.new(0, 110, 1, 0)

PlayerCountLabel.BackgroundTransparency = 1

PlayerCountLabel.TextColor3 =
    Color3.fromRGB(0, 255, 150)

PlayerCountLabel.Font =
    Enum.Font.SourceSansBold

PlayerCountLabel.TextSize = 13

PlayerCountLabel.TextXAlignment =
    Enum.TextXAlignment.Right

local function updateServerCount()

    local count =
        #Players:GetPlayers()

    local maxPlayers =
        Players.MaxPlayers

    PlayerCountLabel.Text =
        "Server: "
        .. tostring(count)
        .. "/"
        .. tostring(maxPlayers)

end

updateServerCount()

Players.PlayerAdded:Connect(
    updateServerCount
)

Players.PlayerRemoving:Connect(
    updateServerCount
)

--// =========================================================
--// MINIMIZE
--// =========================================================

local MinimizeButton = Instance.new("TextButton")

MinimizeButton.Parent = TopBar

MinimizeButton.Position =
    UDim2.new(1, -65, 0, 5)

MinimizeButton.Size =
    UDim2.new(0, 25, 0, 25)

MinimizeButton.BackgroundColor3 =
    Color3.fromRGB(40, 40, 50)

MinimizeButton.Text = "—"

MinimizeButton.TextColor3 =
    Color3.fromRGB(255, 255, 255)

MinimizeButton.Font =
    Enum.Font.SourceSansBold

MinimizeButton.TextSize = 14

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius =
    UDim.new(0, 4)
MinBtnCorner.Parent = MinimizeButton

--// =========================================================
--// CLOSE
--// =========================================================

local CloseButton = Instance.new("TextButton")

CloseButton.Parent = TopBar

CloseButton.Position =
    UDim2.new(1, -35, 0, 5)

CloseButton.Size =
    UDim2.new(0, 25, 0, 25)

CloseButton.BackgroundColor3 =
    Color3.fromRGB(150, 30, 30)

CloseButton.Text = "X"

CloseButton.TextColor3 =
    Color3.fromRGB(255, 255, 255)

CloseButton.Font =
    Enum.Font.SourceSansBold

CloseButton.TextSize = 14

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius =
    UDim.new(0, 4)
CloseBtnCorner.Parent = CloseButton

--// =========================================================
--// DRAG SYSTEM
--// =========================================================

local dragging = false
local dragStart
local startPosition

TopBar.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        dragging = true

        dragStart =
            input.Position

        startPosition =
            MainFrame.Position
    end

end)

TopBar.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        dragging = false
    end

end)

UserInputService.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType ~=
        Enum.UserInputType.MouseMovement
        and input.UserInputType ~=
        Enum.UserInputType.Touch then

        return
    end

    local delta =
        input.Position - dragStart

    MainFrame.Position =
        UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,

            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )

end)

--// =========================================================
--// MINI BUTTON
--// =========================================================

local MiniButton = Instance.new("TextButton")

MiniButton.Name = "SpeedFCMini"
MiniButton.Parent = ScreenGui

MiniButton.Position =
    UDim2.new(0.05, 0, 0.15, 0)

MiniButton.Size =
    UDim2.new(0, 52, 0, 52)

MiniButton.BackgroundColor3 =
    Color3.fromRGB(20, 20, 30)

MiniButton.Text = "⚡"

MiniButton.TextColor3 =
    Color3.fromRGB(0, 215, 255)

MiniButton.Font =
    Enum.Font.SourceSansBold

MiniButton.TextSize = 26

MiniButton.Visible = false
MiniButton.Active = true

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius =
    UDim.new(1, 0)
MiniCorner.Parent = MiniButton

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Thickness = 2
MiniStroke.Color =
    Color3.fromRGB(0, 180, 255)
MiniStroke.Parent = MiniButton

--// =========================================================
--// MINI DRAG
--// =========================================================

local miniDragging = false
local miniStart
local miniPosition

MiniButton.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        miniDragging = true
        miniStart = input.Position
        miniPosition = MiniButton.Position

    end

end)

MiniButton.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        miniDragging = false

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if not miniDragging then
        return
    end

    if input.UserInputType ~=
        Enum.UserInputType.MouseMovement
        and input.UserInputType ~=
        Enum.UserInputType.Touch then

        return
    end

    local delta =
        input.Position - miniStart

    MiniButton.Position =
        UDim2.new(
            miniPosition.X.Scale,
            miniPosition.X.Offset + delta.X,

            miniPosition.Y.Scale,
            miniPosition.Y.Offset + delta.Y
        )

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
--// SIDEBAR
--// =========================================================

local SidebarFrame = Instance.new("Frame")

SidebarFrame.Parent = MainFrame

SidebarFrame.Position =
    UDim2.new(0, 10, 0, 50)

SidebarFrame.Size =
    UDim2.new(0, 130, 1, -60)

SidebarFrame.BackgroundTransparency = 1

local SidebarLayout = Instance.new("UIListLayout")

SidebarLayout.Parent =
    SidebarFrame

SidebarLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

SidebarLayout.Padding =
    UDim.new(0, 6)

--// =========================================================
--// CONTENT
--// =========================================================

local ContentFrame = Instance.new("Frame")

ContentFrame.Parent = MainFrame

ContentFrame.Position =
    UDim2.new(0, 155, 0, 55)

ContentFrame.Size =
    UDim2.new(1, -165, 1, -65)

ContentFrame.BackgroundTransparency = 1

--// =========================================================
--// PAGES
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

    page.Parent = ContentFrame

    page.Size =
        UDim2.new(1, 0, 1, 0)

    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0

    page.ScrollBarThickness = 3

    page.ScrollBarImageColor3 =
        Color3.fromRGB(0, 180, 255)

    page.CanvasSize =
        UDim2.new(0, 0, 0, 0)

    page.AutomaticCanvasSize =
        Enum.AutomaticSize.Y

    page.Visible = false

    layout.Parent = page

    layout.SortOrder =
        Enum.SortOrder.LayoutOrder

    layout.Padding =
        UDim.new(0, 8)

end

setupPage(FarmPage, PageLayout1)
setupPage(CharmPage, PageLayout2)
setupPage(PlayerPage, PageLayout3)
setupPage(SettingPage, PageLayout4)

FarmPage.Visible = true

--// =========================================================
--// LANGUAGE SYSTEM
--// =========================================================

local textLabels = {}
local buttonObjects = {}
local sliderObjects = {}
local inputObjects = {}

local function registerLangText(
    object,
    th,
    en
)

    textLabels[object] = {
        TH = th,
        EN = en
    }

end

local function getLangText(
    th,
    en
)

    if _G.Language == "TH" then
        return th
    end

    return en

end

--// =========================================================
--// TABS
--// =========================================================

local FarmTabButton =
    Instance.new("TextButton")

local CharmTabButton =
    Instance.new("TextButton")

local PlayerTabButton =
    Instance.new("TextButton")

local SettingTabButton =
    Instance.new("TextButton")

local currentPage = FarmPage
local currentTab = FarmTabButton

local function createTabBtn(
    btn,
    thText,
    enText,
    page
)

    btn.Size =
        UDim2.new(1, 0, 0, 38)

    btn.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)

    btn.TextColor3 =
        Color3.fromRGB(180, 190, 200)

    btn.Font =
        Enum.Font.SourceSansBold

    btn.TextSize = 14

    btn.TextXAlignment =
        Enum.TextXAlignment.Left

    btn.Text =
        getLangText(thText, enText)

    btn.Parent =
        SidebarFrame

    registerLangText(
        btn,
        thText,
        enText
    )

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 6)

    corner.Parent = btn

    local stroke =
        Instance.new("UIStroke")

    stroke.Thickness = 1
    stroke.Color =
        Color3.fromRGB(45, 45, 60)

    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()

        FarmPage.Visible = false
        CharmPage.Visible = false
        PlayerPage.Visible = false
        SettingPage.Visible = false

        FarmTabButton.BackgroundColor3 =
            Color3.fromRGB(28, 28, 38)

        CharmTabButton.BackgroundColor3 =
            Color3.fromRGB(28, 28, 38)

        PlayerTabButton.BackgroundColor3 =
            Color3.fromRGB(28, 28, 38)

        SettingTabButton.BackgroundColor3 =
            Color3.fromRGB(28, 28, 38)

        page.Visible = true

        btn.BackgroundColor3 =
            Color3.fromRGB(0, 100, 200)

        currentPage = page
        currentTab = btn

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
    "🌐 ตั้งค่า",
    "🌐 Settings",
    SettingPage
)

FarmTabButton.BackgroundColor3 =
    Color3.fromRGB(0, 100, 200)

--// =========================================================
--// BUTTON UI
--// =========================================================

local function updateButtonUI(
    btn,
    active,
    thText,
    enText
)

    local text =
        getLangText(thText, enText)

    if active then

        btn.Text =
            text .. " : ON"

        btn.BackgroundColor3 =
            Color3.fromRGB(40, 170, 90)

    else

        btn.Text =
            text .. " : OFF"

        btn.BackgroundColor3 =
            Color3.fromRGB(180, 45, 45)

    end

    local stroke =
        btn:FindFirstChildOfClass(
            "UIStroke"
        )

    if stroke then

        if active then

            stroke.Color =
                Color3.fromRGB(
                    100,
                    255,
                    150
                )

        else

            stroke.Color =
                Color3.fromRGB(
                    255,
                    100,
                    100
                )

        end

    end

end

local function createMenuButton(
    thText,
    enText,
    parentPage,
    getVar,
    setVar,
    onToggle
)

    local btn =
        Instance.new("TextButton")

    btn.Size =
        UDim2.new(
            0.96,
            0,
            0,
            38
        )

    btn.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )

    btn.Font =
        Enum.Font.SourceSansBold

    btn.TextSize = 14

    btn.Parent =
        parentPage

    buttonObjects[btn] = {
        TH = thText,
        EN = enText,
        getVar = getVar
    }

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 6)

    corner.Parent = btn

    local stroke =
        Instance.new("UIStroke")

    stroke.Thickness = 1

    stroke.Parent = btn

    updateButtonUI(
        btn,
        getVar(),
        thText,
        enText
    )

    btn.MouseButton1Click:Connect(function()

        local newState =
            not getVar()

        setVar(newState)

        updateButtonUI(
            btn,
            newState,
            thText,
            enText
        )

        if onToggle then

            pcall(function()
                onToggle(newState)
            end)

        end

        saveConfig()

    end)

    return btn

end

--// =========================================================
--// TEXT BOX
--// =========================================================

local function createMenuTextBox(
    thPrefix,
    enPrefix,
    getVar,
    parentPage,
    onChanged
)

    local frame =
        Instance.new("Frame")

    frame.Size =
        UDim2.new(
            0.96,
            0,
            0,
            45
        )

    frame.BackgroundTransparency = 1
    frame.Parent = parentPage

    local label =
        Instance.new("TextLabel")

    label.Size =
        UDim2.new(
            0.65,
            0,
            1,
            0
        )

    label.BackgroundTransparency = 1

    label.TextColor3 =
        Color3.fromRGB(
            0,
            180,
            255
        )

    label.Font =
        Enum.Font.SourceSansBold

    label.TextSize = 14

    label.TextXAlignment =
        Enum.TextXAlignment.Left

    label.Text =
        getLangText(
            thPrefix,
            enPrefix
        )

    label.Parent = frame

    registerLangText(
        label,
        thPrefix,
        enPrefix
    )

    local box =
        Instance.new("TextBox")

    box.Size =
        UDim2.new(
            0.30,
            0,
            0.72,
            0
        )

    box.Position =
        UDim2.new(
            0.68,
            0,
            0.14,
            0
        )

    box.BackgroundColor3 =
        Color3.fromRGB(
            30,
            30,
            40
        )

    box.Text =
        tostring(getVar())

    box.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )

    box.Font =
        Enum.Font.SourceSansBold

    box.TextSize = 14

    box.ClearTextOnFocus = false

    box.Parent = frame

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 6)

    corner.Parent = box

    local stroke =
        Instance.new("UIStroke")

    stroke.Thickness = 1

    stroke.Color =
        Color3.fromRGB(
            70,
            70,
            90
        )

    stroke.Parent = box

    inputObjects[box] = {
        getVar = getVar
    }

    box.FocusLost:Connect(function()

        local number =
            tonumber(box.Text)

        if number then

            pcall(function()
                onChanged(number)
            end)

        end

        box.Text =
            tostring(getVar())

        saveConfig()

    end)

    return frame

end

--// =========================================================
--// SELECTOR
--// =========================================================

local function createSelector(
    thPrefix,
    enPrefix,
    options,
    getVar,
    setVar,
    parentPage
)

    local frame =
        Instance.new("Frame")

    frame.Size =
        UDim2.new(
            0.96,
            0,
            0,
            45
        )

    frame.BackgroundTransparency = 1
    frame.Parent = parentPage

    local label =
        Instance.new("TextLabel")

    label.Size =
        UDim2.new(
            0.42,
            0,
            1,
            0
        )

    label.BackgroundTransparency = 1

    label.TextColor3 =
        Color3.fromRGB(
            0,
            180,
            255
        )

    label.Font =
        Enum.Font.SourceSansBold

    label.TextSize = 14

    label.TextXAlignment =
        Enum.TextXAlignment.Left

    label.Text =
        getLangText(
            thPrefix,
            enPrefix
        )

    label.Parent = frame

    registerLangText(
        label,
        thPrefix,
        enPrefix
    )

    local button =
        Instance.new("TextButton")

    button.Size =
        UDim2.new(
            0.54,
            0,
            0.75,
            0
        )

    button.Position =
        UDim2.new(
            0.44,
            0,
            0.125,
            0
        )

    button.BackgroundColor3 =
        Color3.fromRGB(
            30,
            30,
            40
        )

    button.TextColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )

    button.Font =
        Enum.Font.SourceSansBold

    button.TextSize = 13

    button.Parent = frame

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 6)

    corner.Parent = button

    local index = 1

    for i, value in ipairs(options) do

        if tostring(value) ==
            tostring(getVar()) then

            index = i
            break

        end

    end

    local function update()

        button.Text =
            tostring(options[index])

    end

    update()

    button.MouseButton1Click:Connect(function()

        index += 1

        if index > #options then
            index = 1
        end

        local value =
            options[index]

        setVar(value)

        update()

        saveConfig()

    end)

    return frame

end

--// =========================================================
--// SLIDER
--// =========================================================

local function createMenuSlider(
    thPrefix,
    enPrefix,
    minValue,
    maxValue,
    getVar,
    setVar,
    parentPage
)

    local frame =
        Instance.new("Frame")

    frame.Size =
        UDim2.new(
            0.96,
            0,
            0,
            55
        )

    frame.BackgroundTransparency = 1
    frame.Parent = parentPage

    local label =
        Instance.new("TextLabel")

    label.Size =
        UDim2.new(
            1,
            0,
            0,
            20
        )

    label.BackgroundTransparency = 1

    label.TextColor3 =
        Color3.fromRGB(
            0,
            180,
            255
        )

    label.Font =
        Enum.Font.SourceSansBold

    label.TextSize = 14

    label.TextXAlignment =
        Enum.TextXAlignment.Left

    label.Parent = frame

    local function updateLabel()

        label.Text =
            getLangText(
                thPrefix,
                enPrefix
            )
            .. " -> "
            .. tostring(
                math.round(
                    getVar() * 10
                ) / 10
            )

    end

    registerLangText(
        label,
        thPrefix,
        enPrefix
    )

    updateLabel()

    local sliderBg =
        Instance.new("Frame")

    sliderBg.Size =
        UDim2.new(
            1,
            0,
            0,
            8
        )

    sliderBg.Position =
        UDim2.new(
            0,
            0,
            0,
            30
        )

    sliderBg.BackgroundColor3 =
        Color3.fromRGB(
            35,
            35,
            45
        )

    sliderBg.Parent = frame

    local bgCorner =
        Instance.new("UICorner")

    bgCorner.CornerRadius =
        UDim.new(0, 4)

    bgCorner.Parent =
        sliderBg

    local sliderBtn =
        Instance.new("TextButton")

    sliderBtn.Size =
        UDim2.new(
            0,
            16,
            0,
            16
        )

    sliderBtn.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    sliderBtn.BackgroundColor3 =
        Color3.fromRGB(
            0,
            215,
            255
        )

    sliderBtn.Text = ""

    sliderBtn.Parent =
        sliderBg

    local sliderCorner =
        Instance.new("UICorner")

    sliderCorner.CornerRadius =
        UDim.new(1, 0)

    sliderCorner.Parent =
        sliderBtn

    local function setSlider(value)

        value =
            math.clamp(
                tonumber(value) or minValue,
                minValue,
                maxValue
            )

        local percent =
            (value - minValue)
            / (maxValue - minValue)

        sliderBtn.Position =
            UDim2.new(
                percent,
                0,
                0.5,
                0
            )

        setVar(value)
        updateLabel()

    end

    setSlider(getVar())

    local draggingSlider = false

    local function updateFromX(x)

        local left =
            sliderBg.AbsolutePosition.X

        local width =
            sliderBg.AbsoluteSize.X

        if width <= 0 then
            return
        end

        local percent =
            math.clamp(
                (x - left) / width,
                0,
                1
            )

        local value =
            minValue
            + (
                maxValue
                - minValue
            ) * percent

        value =
            math.round(value * 10)
            / 10

        setSlider(value)

    end

    local function beginSlider(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            draggingSlider = true

            updateFromX(
                input.Position.X
            )

        end

    end

    sliderBtn.InputBegan:Connect(
        beginSlider
    )

    sliderBg.InputBegan:Connect(
        beginSlider
    )

    UserInputService.InputChanged:Connect(
        function(input)

            if not draggingSlider then
                return
            end

            if input.UserInputType ==
                Enum.UserInputType.MouseMovement
                or input.UserInputType ==
                Enum.UserInputType.Touch then

                updateFromX(
                    input.Position.X
                )

            end

        end
    )

    UserInputService.InputEnded:Connect(
        function(input)

            if input.UserInputType ==
                Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                Enum.UserInputType.Touch then

                if draggingSlider then

                    draggingSlider = false

                    saveConfig()

                end

            end

        end
    )

    sliderObjects[#sliderObjects + 1] = {
        refresh = updateLabel,
        setSlider = setSlider
    }

    return frame

end

--// =========================================================
--// GAME HELPERS
--// =========================================================

local function getCharacter()

    return player.Character
        or player.CharacterAdded:Wait()

end

local function getHumanoid()

    local character =
        getCharacter()

    if not character then
        return nil
    end

    return character:FindFirstChildOfClass(
        "Humanoid"
    )

end

local function getRoot()

    local character =
        getCharacter()

    if not character then
        return nil
    end

    return character:FindFirstChild(
        "HumanoidRootPart"
    )

end

--// =========================================================
--// STAGE
--// =========================================================

local function getStageButton(stageNum)

    local map =
        workspace:FindFirstChild("Map")

    if not map then
        return nil
    end

    local world1 =
        map:FindFirstChild("World1")

    if not world1 then
        return nil
    end

    local stages =
        world1:FindFirstChild("Stages")

    if not stages then
        return nil
    end

    local stage =
        stages:FindFirstChild(
            "Stage"
            .. tostring(stageNum)
        )

    if not stage then
        return nil
    end

    if tonumber(stageNum) == 1 then

        local main =
            stage:FindFirstChild("Main")

        if main then

            local endPart =
                main:FindFirstChild(
                    "StageEnd"
                )

            if endPart then

                return endPart:FindFirstChild(
                    "Button"
                )

            end

        end

    else

        local normalWin =
            stage:FindFirstChild(
                "NormalWin"
            )

        if normalWin then

            return normalWin:FindFirstChild(
                "Button"
            )

        end

    end

    return nil

end

local function getAvailableStages()

    local result = {
        "Auto"
    }

    local map =
        workspace:FindFirstChild("Map")

    if not map then
        return result
    end

    local world =
        map:FindFirstChild("World1")

    if not world then
        return result
    end

    local stages =
        world:FindFirstChild("Stages")

    if not stages then
        return result
    end

    local numbers = {}

    for _, object in ipairs(
        stages:GetChildren()
    ) do

        local number =
            tonumber(
                string.match(
                    object.Name,
                    "^Stage(%d+)$"
                )
            )

        if number then
            table.insert(
                numbers,
                number
            )
        end

    end

    table.sort(numbers)

    for _, number in ipairs(numbers) do

        table.insert(
            result,
            "Stage " .. tostring(number)
        )

    end

    return result

end

--// =========================================================
--// TREADMILL
--// =========================================================

local function getTreadmillPart(name)

    local map =
        workspace:FindFirstChild("Map")

    if not map then
        return nil
    end

    local world1 =
        map:FindFirstChild("World1")

    if not world1 then
        return nil
    end

    local stages =
        world1:FindFirstChild("Stages")

    if not stages then
        return nil
    end

    local stage1 =
        stages:FindFirstChild("Stage1")

    if name == "Basic" then

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
        stages:FindFirstChild(
            "Spawn"
        )

    if not spawn then
        return nil
    end

    local treadmills =
        spawn:FindFirstChild(
            "Treadmills"
        )

    if not treadmills then
        return nil
    end

    local names = {

        Galaxy = {
            "TreadmillGalaxy",
            "Galaxy"
        },

        Void = {
            "TreadmillVoid",
            "Void"
        },

        Celestial = {
            "TreadmillCelestial",
            "Celestial"
        },

        Diamond = {
            "TreadmillDiamond",
            "Diamond"
        },

        Playtime = {
            "TreadmillPlaytime",
            "Reward"
        }

    }

    local data =
        names[name]

    if data then

        local model =
            treadmills:FindFirstChild(
                data[1]
            )

        if model then

            return model:FindFirstChild(
                data[2]
            )

        end

    end

    return nil

end

--// =========================================================
--// TELEPORT
--// =========================================================

local function teleportToPart(part)

    if not part then
        return false
    end

    local root =
        getRoot()

    if not root then
        return false
    end

    local targetCFrame

    pcall(function()

        if part:IsA("BasePart") then

            targetCFrame =
                part.CFrame

        elseif part:IsA("Model") then

            targetCFrame =
                part:GetPivot()

        end

    end)

    if not targetCFrame then
        return false
    end

    pcall(function()

        root.CFrame =
            targetCFrame
            + Vector3.new(
                0,
                3,
                0
            )

    end)

    return true

end

--// =========================================================
--// FARM PAGE
--// =========================================================

createMenuButton(
    "🏁 Auto Win",
    "🏁 Auto Win",
    FarmPage,

    function()
        return _G.AutoWinActive
    end,

    function(value)
        _G.AutoWinActive = value
    end
)

createSelector(
    "🎯 Stage",
    "🎯 Stage",
    getAvailableStages(),
    function()
        return _G.SelectedStage
    end,
    function(value)
        _G.SelectedStage = value
    end,
    FarmPage
)

createMenuTextBox(
    "⏱️ ความเร็ววาร์ป",
    "⏱️ Warp Delay",
    function()
        return _G.WarpDelay
    end,
    FarmPage,
    function(value)

        _G.WarpDelay =
            math.clamp(
                value,
                0.05,
                30
            )

    end
)

createMenuButton(
    "🏃 Auto Treadmill",
    "🏃 Auto Treadmill",
    FarmPage,

    function()
        return _G.AutoTreadmillActive
    end,

    function(value)
        _G.AutoTreadmillActive = value
    end
)

createSelector(
    "🏃 Treadmill",
    "🏃 Treadmill",
    {
        "Basic",
        "Gold",
        "Galaxy",
        "Void",
        "Celestial",
        "Diamond",
        "Playtime"
    },

    function()
        return _G.SelectedTreadmill
    end,

    function(value)
        _G.SelectedTreadmill = value
    end,

    FarmPage
)

createMenuButton(
    "🔄 Auto Rebirth",
    "🔄 Auto Rebirth",
    FarmPage,

    function()
        return _G.AutoRebirthActive
    end,

    function(value)
        _G.AutoRebirthActive = value
    end
)

createMenuButton(
    "🛒 Auto Buy",
    "🛒 Auto Buy",
    FarmPage,

    function()
        return _G.AutoBuyActive
    end,

    function(value)
        _G.AutoBuyActive = value
    end
)

--// =========================================================
--// CHARM PAGE
--// =========================================================

createMenuButton(
    "✨ Auto Charm",
    "✨ Auto Charm",
    CharmPage,

    function()
        return _G.AutoCharmActive
    end,

    function(value)
        _G.AutoCharmActive = value
    end
)

createMenuTextBox(
    "⏱️ Charm Delay",
    "⏱️ Charm Delay",
    function()
        return _G.CharmDelay
    end,
    CharmPage,
    function(value)

        _G.CharmDelay =
            math.clamp(
                value,
                0.05,
                30
            )

    end
)

createMenuTextBox(
    "⭐ Charm Rarity",
    "⭐ Charm Rarity",
    function()
        return _G.SelectedCharmRarity
    end,
    CharmPage,
    function(value)

        _G.SelectedCharmRarity =
            math.clamp(
                math.floor(value),
                1,
                10
            )

    end
)

--// =========================================================
--// PLAYER PAGE
--// =========================================================

createMenuSlider(
    "🏃 ความเร็วเดิน",
    "🏃 Walk Speed",
    1,
    250,

    function()
        return _G.WalkSpeedVal
    end,

    function(value)

        _G.WalkSpeedVal =
            value

    end,

    PlayerPage
)

createMenuSlider(
    "🦘 พลังการกระโดด",
    "🦘 Jump Power",
    1,
    250,

    function()
        return _G.JumpPowerVal
    end,

    function(value)

        _G.JumpPowerVal =
            value

    end,

    PlayerPage
)

createMenuSlider(
    "✈️ ความเร็วบิน",
    "✈️ Fly Speed",
    1,
    250,

    function()
        return _G.FlySpeedVal
    end,

    function(value)

        _G.FlySpeedVal =
            value

    end,

    PlayerPage
)

createMenuButton(
    "♾️ กระโดดไม่จำกัด",
    "♾️ Infinite Jump",
    PlayerPage,

    function()
        return _G.InfiniteJumpActive
    end,

    function(value)
        _G.InfiniteJumpActive = value
    end
)

createMenuButton(
    "✈️ บิน",
    "✈️ Fly",
    PlayerPage,

    function()
        return _G.FlyActive
    end,

    function(value)
        _G.FlyActive = value
    end
)

--// =========================================================
--// SETTINGS
--// =========================================================

local LanguageButton =
    Instance.new("TextButton")

LanguageButton.Size =
    UDim2.new(
        0.96,
        0,
        0,
        42
    )

LanguageButton.BackgroundColor3 =
    Color3.fromRGB(
        0,
        100,
        180
    )

LanguageButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

LanguageButton.Font =
    Enum.Font.SourceSansBold

LanguageButton.TextSize = 15

LanguageButton.Parent =
    SettingPage

local langCorner =
    Instance.new("UICorner")

langCorner.CornerRadius =
    UDim.new(0, 6)

langCorner.Parent =
    LanguageButton

local function updateLanguageButton()

    if _G.Language == "TH" then

        LanguageButton.Text =
            "🌐 ภาษา : ไทย"

    else

        LanguageButton.Text =
            "🌐 Language : English"

    end

end

updateLanguageButton()

--// =========================================================
--// RESET BUTTON
--// =========================================================

local ResetButton =
    Instance.new("TextButton")

ResetButton.Size =
    UDim2.new(
        0.96,
        0,
        0,
        42
    )

ResetButton.BackgroundColor3 =
    Color3.fromRGB(
        120,
        60,
        40
    )

ResetButton.TextColor3 =
    Color3.fromRGB(
        255,
        255,
        255
    )

ResetButton.Font =
    Enum.Font.SourceSansBold

ResetButton.TextSize = 14

ResetButton.Parent =
    SettingPage

local resetCorner =
    Instance.new("UICorner")

resetCorner.CornerRadius =
    UDim.new(0, 6)

resetCorner.Parent =
    ResetButton

local function updateResetText()

    if _G.Language == "TH" then

        ResetButton.Text =
            "♻️ รีเซ็ตค่า Config"

    else

        ResetButton.Text =
            "♻️ Reset Config"

    end

end

updateResetText()

--// =========================================================
--// LANGUAGE CHANGE
--// =========================================================

LanguageButton.MouseButton1Click:Connect(function()

    if _G.Language == "TH" then
        _G.Language = "EN"
    else
        _G.Language = "TH"
    end

    updateLanguageButton()
    updateResetText()

    for object, data in pairs(
        textLabels
    ) do

        if object
            and object.Parent then

            object.Text =
                getLangText(
                    data.TH,
                    data.EN
                )

        end

    end

    for object, data in pairs(
        buttonObjects
    ) do

        if object
            and object.Parent then

            updateButtonUI(
                object,
                data.getVar(),
                data.TH,
                data.EN
            )

        end

    end

    for _, data in ipairs(
        sliderObjects
    ) do

        pcall(function()
            data.refresh()
        end)

    end

    saveConfig()

end)

--// =========================================================
--// RESET CONFIG
--// =========================================================

ResetButton.MouseButton1Click:Connect(function()

    _G.AutoWinActive = false
    _G.AutoTreadmillActive = false
    _G.AutoRebirthActive = false
    _G.AutoBuyActive = false
    _G.AutoCharmActive = false
    _G.InfiniteJumpActive = false
    _G.FlyActive = false

    _G.SelectedStage = "Auto"
    _G.SelectedTreadmill = "Basic"
    _G.SelectedCharmRarity = 1

    _G.WarpDelay = 0.5
    _G.CharmDelay = 1

    _G.WalkSpeedVal = 16
    _G.JumpPowerVal = 50
    _G.FlySpeedVal = 50

    -- Update buttons
    for object, data in pairs(
        buttonObjects
    ) do

        if object
            and object.Parent then

            updateButtonUI(
                object,
                data.getVar(),
                data.TH,
                data.EN
            )

        end

    end

    -- Update text boxes
    for object, data in pairs(
        inputObjects
    ) do

        if object
            and object.Parent then

            object.Text =
                tostring(
                    data.getVar()
                )

        end

    end

    -- Update sliders
    for _, data in ipairs(
        sliderObjects
    ) do

        pcall(function()

            data.setSlider(
                data.getSliderValue
                    and data.getSliderValue()
                    or 0
            )

        end)

        pcall(function()
            data.refresh()
        end)

    end

    saveConfig()

    applyPlayerSettings()

    -- Stop fly immediately
    if stopFly then
        pcall(stopFly)
    end

end)

--// =========================================================
--// APPLY PLAYER SETTINGS
--// =========================================================

local function applyPlayerSettings()

    local humanoid =
        getHumanoid()

    if not humanoid then
        return
    end

    pcall(function()

        humanoid.WalkSpeed =
            math.clamp(
                tonumber(
                    _G.WalkSpeedVal
                ) or 16,
                1,
                250
            )

    end)

    pcall(function()

        humanoid.JumpPower =
            math.clamp(
                tonumber(
                    _G.JumpPowerVal
                ) or 50,
                1,
                250
            )

    end)

end

--// =========================================================
--// INFINITE JUMP
--// =========================================================

UserInputService.JumpRequest:Connect(function()

    if not _G.InfiniteJumpActive then
        return
    end

    local humanoid =
        getHumanoid()

    if humanoid then

        pcall(function()

            humanoid:ChangeState(
                Enum.HumanoidStateType.Jumping
            )

        end)

    end

end)

--// =========================================================
--// FLY
--// =========================================================

local flyConnection = nil
local flyVelocity = nil
local flyGyro = nil

local function stopFly()

    if flyConnection then

        pcall(function()
            flyConnection:Disconnect()
        end)

        flyConnection = nil

    end

    if flyVelocity then

        pcall(function()
            flyVelocity:Destroy()
        end)

        flyVelocity = nil

    end

    if flyGyro then

        pcall(function()
            flyGyro:Destroy()
        end)

        flyGyro = nil

    end

end

local function startFly()

    stopFly()

    local root =
        getRoot()

    if not root then
        return
    end

    local camera =
        workspace.CurrentCamera

    if not camera then
        return
    end

    flyVelocity =
        Instance.new(
            "BodyVelocity"
        )

    flyVelocity.MaxForce =
        Vector3.new(
            math.huge,
            math.huge,
            math.huge
        )

    flyVelocity.Velocity =
        Vector3.zero

    flyVelocity.Parent =
        root

    flyGyro =
        Instance.new(
            "BodyGyro"
        )

    flyGyro.MaxTorque =
        Vector3.new(
            math.huge,
            math.huge,
            math.huge
        )

    flyGyro.P = 10000

    flyGyro.CFrame =
        camera.CFrame

    flyGyro.Parent =
        root

    flyConnection =
        RunService.RenderStepped:Connect(
            function()

                if not _G.FlyActive then
                    stopFly()
                    return
                end

                if not root
                    or not root.Parent then

                    stopFly()
                    return

                end

                local currentCamera =
                    workspace.CurrentCamera

                if not currentCamera then
                    return
                end

                local direction =
                    Vector3.zero

                -- PC keyboard
                if UserInputService:IsKeyDown(
                    Enum.KeyCode.W
                ) then

                    direction +=
                        currentCamera.CFrame.LookVector

                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.S
                ) then

                    direction -=
                        currentCamera.CFrame.LookVector

                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.A
                ) then

                    direction -=
                        currentCamera.CFrame.RightVector

                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.D
                ) then

                    direction +=
                        currentCamera.CFrame.RightVector

                end

                -- Mobile joystick
                local humanoid =
                    getHumanoid()

                if humanoid
                    and humanoid.MoveDirection.Magnitude > 0 then

                    direction =
                        humanoid.MoveDirection

                end

                -- PC vertical controls
                if UserInputService:IsKeyDown(
                    Enum.KeyCode.Space
                ) then

                    direction +=
                        Vector3.new(
                            0,
                            1,
                            0
                        )

                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.LeftControl
                ) then

                    direction -=
                        Vector3.new(
                            0,
                            1,
                            0
                        )

                end

                if direction.Magnitude > 0 then

                    direction =
                        direction.Unit

                end

                flyVelocity.Velocity =
                    direction
                    * (
                        tonumber(
                            _G.FlySpeedVal
                        ) or 50
                    )

                flyGyro.CFrame =
                    currentCamera.CFrame

            end
        )

end

--// =========================================================
--// FLY STATE WATCHER
--// =========================================================

task.spawn(function()

    local previous =
        _G.FlyActive

    while ScreenGui.Parent do

        task.wait(0.15)

        if _G.FlyActive ~= previous then

            previous =
                _G.FlyActive

            if _G.FlyActive then

                startFly()

            else

                stopFly()

            end

        end

    end

end)

--// =========================================================
--// CHARACTER RESPAWN
--// =========================================================

player.CharacterAdded:Connect(
    function()

        task.wait(0.8)

        applyPlayerSettings()

        if _G.FlyActive then

            task.wait(0.2)

            startFly()

        end

    end
)

--// =========================================================
--// AUTO WIN
--// =========================================================

task.spawn(function()

    while ScreenGui.Parent do

        local delay =
            math.max(
                tonumber(
                    _G.WarpDelay
                ) or 0.5,
                0.05
            )

        task.wait(delay)

        if not _G.AutoWinActive then
            continue
        end

        local targetStage =
            _G.SelectedStage

        if targetStage == "Auto" then

            local stages = {}

            local map =
                workspace:FindFirstChild(
                    "Map"
                )

            if map then

                local world =
                    map:FindFirstChild(
                        "World1"
                    )

                if world then

                    local stageFolder =
                        world:FindFirstChild(
                            "Stages"
                        )

                    if stageFolder then

                        for _, object in ipairs(
                            stageFolder:GetChildren()
                        ) do

                            local number =
                                tonumber(
                                    string.match(
                                        object.Name,
                                        "^Stage(%d+)$"
                                    )
                                )

                            if number then

                                table.insert(
                                    stages,
                                    number
                                )

                            end

                        end

                    end

                end

            end

            table.sort(stages)

            if #stages > 0 then

                targetStage =
                    "Stage "
                    .. tostring(
                        stages[#stages]
                    )

            end

        end

        local stageNumber =
            tonumber(
                tostring(
                    targetStage
                ):match("%d+")
            )

        if stageNumber then

            local button =
                getStageButton(
                    stageNumber
                )

            if button then

                teleportToPart(
                    button
                )

            end

        end

    end

end)

--// =========================================================
--// AUTO TREADMILL
--// =========================================================

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(0.5)

        if _G.AutoTreadmillActive then

            local treadmill =
                getTreadmillPart(
                    _G.SelectedTreadmill
                )

            if treadmill then

                teleportToPart(
                    treadmill
                )

            end

        end

    end

end)

--// =========================================================
--// AUTO REBIRTH
--// =========================================================
--// IMPORTANT:
--// Only uses known RemoteEvent names.
--// Does NOT randomly fire every remote.
--// =========================================================

local rebirthRemoteNames = {

    "Rebirth",
    "RebirthEvent",
    "RebirthRemote",
    "DoRebirth"

}

local function findRebirthRemote()

    for _, name in ipairs(
        rebirthRemoteNames
    ) do

        local remote =
            ReplicatedStorage:FindFirstChild(
                name,
                true
            )

        if remote
            and remote:IsA(
                "RemoteEvent"
            ) then

            return remote

        end

    end

    return nil

end

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(1)

        if not _G.AutoRebirthActive then
            continue
        end

        local remote =
            findRebirthRemote()

        if remote then

            pcall(function()
                remote:FireServer()
            end)

        end

    end

end)

--// =========================================================
--// AUTO BUY
--// =========================================================
--// Disabled until the game's actual buy Remote is known.
--// =========================================================

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(1)

        if not _G.AutoBuyActive then
            continue
        end

        -- Add the game's actual Buy Remote here.
        -- This prevents accidental Remote calls.

    end

end)

--// =========================================================
--// AUTO CHARM
--// =========================================================
--// Disabled until the game's actual Charm Remote is known.
--// =========================================================

task.spawn(function()

    while ScreenGui.Parent do

        local delay =
            math.max(
                tonumber(
                    _G.CharmDelay
                ) or 1,
                0.05
            )

        task.wait(delay)

        if not _G.AutoCharmActive then
            continue
        end

        -- Add the game's actual Charm Remote here.
        -- Selected rarity is stored in:
        -- _G.SelectedCharmRarity

    end

end)

--// =========================================================
--// PLAYER SETTINGS LOOP
--// =========================================================

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(0.25)

        if not _G.FlyActive then

            applyPlayerSettings()

        end

    end

end)

--// =========================================================
--// CLOSE
--// =========================================================

CloseButton.MouseButton1Click:Connect(
    function()

        _G.FlyActive = false

        stopFly()

        saveConfig()

        ScreenGui:Destroy()

    end
)

--// =========================================================
--// CLEANUP
--// =========================================================

ScreenGui.Destroying:Connect(
    function()

        _G.FlyActive = false

        stopFly()

        saveConfig()

    end
)

--// =========================================================
--// INITIAL STATE
--// =========================================================

applyPlayerSettings()

if _G.FlyActive then

    task.defer(function()

        task.wait(0.5)

        if ScreenGui.Parent
            and _G.FlyActive then

            startFly()

        end

    end)

end

--// =========================================================
--// FINAL
--// =========================================================

print("========================================")
print(" speedFC.ค่าย - Ultimate Hub")
print(" GUI Loaded Successfully")
print(" Language:", _G.Language)
print(" Config:", fileName)
print(" Mobile + PC: Ready")
print("========================================")
