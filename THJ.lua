--// =========================================================
--// Ultimate SpeedFC Hub
--// Premium Fixed Edition
--// Fixed Syntax / Avatar / Fly / Slider / Language / UI
--// =========================================================

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--// =========================================================
--// GLOBAL LANGUAGE
--// =========================================================

_G.Language = "TH"

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

--// =========================================================
--// CONFIG SAVE / LOAD
--// =========================================================

local function saveConfig()
    pcall(function()
        if writefile and HttpService then
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

    if config.Language ~= "TH" and config.Language ~= "EN" then
        config.Language = "TH"
    end

    _G.Language = config.Language
end

loadConfig()

--// =========================================================
--// SCREEN GUI
--// =========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedFCHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ใช้ PlayerGui เป็นหลักเพื่อให้รองรับ Roblox ปกติ
-- ถ้า executor รองรับ CoreGui และต้องการใช้ CoreGui
-- สามารถเปลี่ยน Parent เป็น game:GetService("CoreGui") ได้
ScreenGui.Parent = PlayerGui

--// =========================================================
--// MAIN FRAME
--// =========================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "SpeedFCHubUltimate"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 530, 0, 330)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 180, 255)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

--// =========================================================
--// TOP BAR
--// =========================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

--// Avatar
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "Avatar"
AvatarImage.Parent = TopBar
AvatarImage.Position = UDim2.new(0, 12, 0, 6)
AvatarImage.Size = UDim2.new(0, 30, 0, 30)
AvatarImage.BackgroundTransparency = 1

pcall(function()
    AvatarImage.Image =
        "https://www.roblox.com/headshot-thumbnail/image?userId="
        .. tostring(player.UserId)
        .. "&width=150&height=150&format=png"
end)

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

--// Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.Position = UDim2.new(0, 52, 0, 0)
TitleLabel.Size = UDim2.new(0.4, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "speedFC.ค่าย"
TitleLabel.TextColor3 = Color3.fromRGB(0, 215, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 19
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

--// Player Count
local PlayerCountLabel = Instance.new("TextLabel")
PlayerCountLabel.Parent = TopBar
PlayerCountLabel.Position = UDim2.new(0.45, 0, 0, 0)
PlayerCountLabel.Size = UDim2.new(0.35, 0, 1, 0)
PlayerCountLabel.BackgroundTransparency = 1
PlayerCountLabel.Text = "🎮 Server: 1/12"
PlayerCountLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
PlayerCountLabel.Font = Enum.Font.SourceSansBold
PlayerCountLabel.TextSize = 14
PlayerCountLabel.TextXAlignment = Enum.TextXAlignment.Right

--// Minimize
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = TopBar
MinimizeButton.Position = UDim2.new(1, -65, 0, 8)
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 14

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 4)
MinBtnCorner.Parent = MinimizeButton

--// Close
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TopBar
CloseButton.Position = UDim2.new(1, -35, 0, 8)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 4)
CloseBtnCorner.Parent = CloseButton

--// =========================================================
--// MINI BUTTON
--// =========================================================

local MiniButton = Instance.new("TextButton")
MiniButton.Name = "SpeedFCMini"
MiniButton.Parent = ScreenGui
MiniButton.Position = UDim2.new(0.05, 0, 0.15, 0)
MiniButton.Size = UDim2.new(0, 52, 0, 52)
MiniButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MiniButton.Text = "⚡"
MiniButton.TextColor3 = Color3.fromRGB(0, 215, 255)
MiniButton.Font = Enum.Font.SourceSansBold
MiniButton.TextSize = 28
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

--// =========================================================
--// SIDEBAR
--// =========================================================

local SidebarFrame = Instance.new("Frame")
SidebarFrame.Parent = MainFrame
SidebarFrame.Position = UDim2.new(0, 10, 0, 55)
SidebarFrame.Size = UDim2.new(0, 135, 1, -65)
SidebarFrame.BackgroundTransparency = 1

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = SidebarFrame
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 6)

--// =========================================================
--// CONTENT
--// =========================================================

local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.Position = UDim2.new(0, 160, 0, 60)
ContentFrame.Size = UDim2.new(1, -170, 1, -70)
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
    page.CanvasSize = UDim2.new(0, 0, 0, 700)
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

local function applyDropdownStyle(container, layout, sizeY)
    container.Parent = MainFrame
    container.Position = UDim2.new(0.32, 0, 0.45, 0)
    container.Size = UDim2.new(0.63, 0, 0, 130)
    container.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    container.Visible = false
    container.ZIndex = 20
    container.CanvasSize = UDim2.new(0, 0, 0, sizeY)
    container.ScrollBarThickness = 4
    container.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
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
    150
)

applyDropdownStyle(
    TreadmillDropdownContainer,
    TreadmillDropdownListLayout,
    250
)

--// =========================================================
--// LANGUAGE SYSTEM
--// =========================================================

local textLabels = {}

local function registerLangText(object, th, en, isButton)
    textLabels[object] = {
        TH = th,
        EN = en,
        IsBtn = isButton
    }
end

local function updateLanguageDisplay()
    for obj, data in pairs(textLabels) do
        if obj and obj.Parent then
            local currentText =
                _G.Language == "TH"
                and data.TH
                or data.EN

            if data.IsBtn then
                if obj:GetAttribute("ToggleButton") then
                    local enabled =
                        obj:GetAttribute("ToggleState") == true

                    obj.Text =
                        currentText
                        .. (enabled and " : ON" or " : OFF")
                else
                    obj.Text = currentText
                end
            else
                obj.Text = currentText
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

local function createTabBtn(btn, thText, enText, page)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    btn.TextColor3 = Color3.fromRGB(180, 190, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = SidebarFrame

    registerLangText(
        btn,
        "  " .. thText,
        "  " .. enText,
        false
    )

    btn.Text =
        _G.Language == "TH"
        and "  " .. thText
        or "  " .. enText

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
    "⚙️ Player Options",
    PlayerPage
)

createTabBtn(
    SettingTabButton,
    "🌐 ตั้งค่าภาษา",
    "🌐 Settings & Lang",
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
    parentPage,
    configKey,
    onClick
)
    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(0.96, 0, 0, 38)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    btn.Parent = parentPage

    btn:SetAttribute("ToggleButton", true)

    registerLangText(
        btn,
        thText,
        enText,
        true
    )

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Parent = btn

    local function refreshDisplay()
        local currentText =
            _G.Language == "TH"
            and thText
            or enText

        local enabled = config[configKey] == true

        btn:SetAttribute("ToggleState", enabled)

        btn.Text =
            currentText
            .. (enabled and " : ON" or " : OFF")

        if enabled then
            btn.BackgroundColor3 =
                Color3.fromRGB(40, 170, 90)

            stroke.Color =
                Color3.fromRGB(100, 255, 150)
        else
            btn.BackgroundColor3 =
                Color3.fromRGB(180, 45, 45)

            stroke.Color =
                Color3.fromRGB(255, 100, 100)
        end
    end

    btn.MouseButton1Click:Connect(function()
        config[configKey] =
            not config[configKey]

        saveConfig()
        refreshDisplay()

        pcall(function()
            onClick(config[configKey])
        end)
    end)

    refreshDisplay()

    task.spawn(function()
        pcall(function()
            onClick(config[configKey])
        end)
    end)

    return btn, refreshDisplay
end

--// =========================================================
--// TEXT BOX
--// =========================================================

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

    registerLangText(
        label,
        thPrefix,
        enPrefix,
        false
    )

    label.Text =
        _G.Language == "TH"
        and thPrefix
        or enPrefix

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

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(70, 70, 90)
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
            box.Text = tostring(config[configKey])
        end
    end)

    task.spawn(function()
        pcall(function()
            onChanged(config[configKey])
        end)
    end)

    return box
end

--// =========================================================
--// SLIDER
--// =========================================================

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
    sliderBg.Parent = frame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderBg

    local sliderBtn = Instance.new("TextButton")

    sliderBtn.Size = UDim2.new(0, 18, 0, 18)
    sliderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderBtn.Position = UDim2.new(0, 0, 0.5, 0)
    sliderBtn.BackgroundColor3 =
        Color3.fromRGB(0, 215, 255)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBg

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderBtn

    registerLangText(
        label,
        thPrefix,
        enPrefix,
        false
    )

    local dragging = false

    local function refreshSlider(value)
        value = math.clamp(
            tonumber(value) or minValue,
            minValue,
            maxValue
        )

        local percentage =
            (value - minValue)
            / (maxValue - minValue)

        sliderBtn.Position =
            UDim2.new(
                percentage,
                0,
                0.5,
                0
            )

        local prefix =
            _G.Language == "TH"
            and thPrefix
            or enPrefix

        label.Text =
            prefix
            .. " -> "
            .. tostring(value)
    end

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

        local value =
            minValue
            + percentage
            * (maxValue - minValue)

        value = math.round(value * 10) / 10

        config[configKey] = value
        saveConfig()

        refreshSlider(value)

        pcall(function()
            onChanged(value)
        end)
    end

    sliderBtn.InputBegan:Connect(function(input)
        if
            input.UserInputType
                == Enum.UserInputType.MouseButton1
            or
            input.UserInputType
                == Enum.UserInputType.Touch
        then
            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if
            input.UserInputType
                == Enum.UserInputType.MouseMovement
            or
            input.UserInputType
                == Enum.UserInputType.Touch
        then
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if
            input.UserInputType
                == Enum.UserInputType.MouseButton1
            or
            input.UserInputType
                == Enum.UserInputType.Touch
        then
            dragging = false
        end
    end)

    refreshSlider(config[configKey])

    task.spawn(function()
        pcall(function()
            onChanged(config[configKey])
        end)
    end)
end

--// =========================================================
--// GAME FUNCTIONS
--// =========================================================

local leaderboard =
    player:FindFirstChild("leaderstats")

if not leaderboard then
    task.spawn(function()
        leaderboard =
            player:WaitForChild(
                "leaderstats",
                15
            )
    end)
end

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
        local stage1 =
            stages:FindFirstChild("Stage1")

        local treadmill =
            stage1
            and stage1:FindFirstChild("TreadmillBasic")

        return treadmill
            and treadmill:FindFirstChild("Basic")
    end

    if name == "Gold" then
        local stage1 =
            stages:FindFirstChild("Stage1")

        local treadmill =
            stage1
            and stage1:FindFirstChild("TreadmillGold")

        return treadmill
            and treadmill:FindFirstChild("Golden")
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
        leaderboard =
            player:FindFirstChild("leaderstats")
    end

    if leaderboard then
        local stat =
            leaderboard:FindFirstChild(statName)

        if stat then
            return tonumber(stat.Value) or 0
        end
    end

    return 0
end

local function triggerTouch(part)
    if
        not part
        or not part:IsA("BasePart")
    then
        return
    end

    local character =
        player.Character

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

    pcall(function()
        if firetouchinterest then
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

    local currencyValue =
        child:FindFirstChild("Currency")
        or child:FindFirstChild("Type")

    if not priceValue then
        return
    end

    local price =
        tonumber(priceValue.Value)

    if not price then
        return
    end

    local currencyName =
        currencyValue
        and tostring(currencyValue.Value)
        or "Coins"

    currencyName =
        string.lower(currencyName)

    if
        currencyName == "win"
        or
        currencyName == "wins"
    then
        currencyName = "Wins"
    else
        currencyName =
            currencyValue
            and tostring(currencyValue.Value)
            or "Coins"
    end

    local playerMoney =
        getPlayerStat(currencyName)

    if playerMoney < price then
        return
    end

    local mainPart =
        child:FindFirstChild("Button")
        or child:FindFirstChild("Touch")
        or child:FindFirstChild("Hitbox")

    if
        not mainPart
        and child:IsA("BasePart")
    then
        mainPart = child
    end

    if mainPart then
        triggerTouch(mainPart)
        return
    end

    for _, subChild in ipairs(
        child:GetDescendants()
    ) do
        if
            subChild:IsA("TouchTransmitter")
        then
            triggerTouch(
                subChild.Parent
            )
            break
        end
    end
end

--// =========================================================
--// BUTTONS / DROPDOWNS
--// =========================================================

local dropBtn =
    Instance.new("TextButton")

dropBtn.Size =
    UDim2.new(0.96, 0, 0, 38)

dropBtn.BackgroundColor3 =
    Color3.fromRGB(30, 30, 42)

dropBtn.Font =
    Enum.Font.SourceSansBold

dropBtn.TextSize = 14
dropBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

dropBtn.Parent = FarmPage

local dropCorner =
    Instance.new("UICorner")

dropCorner.CornerRadius =
    UDim.new(0, 6)

dropCorner.Parent = dropBtn

local function updateStageButton()
    local prefix =
        _G.Language == "TH"
        and "🎯 เลือกด่าน: "
        or "🎯 Select Stage: "

    dropBtn.Text =
        prefix
        .. tostring(config.SelectedStage)
end

updateStageButton()

local treadmillDropBtn =
    Instance.new("TextButton")

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

local treadmillCorner =
    Instance.new("UICorner")

treadmillCorner.CornerRadius =
    UDim.new(0, 6)

treadmillCorner.Parent =
    treadmillDropBtn

local function updateTreadmillButton()
    local prefix =
        _G.Language == "TH"
        and "🏃 เลือกลู่วิ่ง: "
        or "🏃 Select Treadmill: "

    treadmillDropBtn.Text =
        prefix
        .. tostring(config.SelectedTreadmill)
end

updateTreadmillButton()

local charmDropBtn =
    Instance.new("TextButton")

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

local charmCorner =
    Instance.new("UICorner")

charmCorner.CornerRadius =
    UDim.new(0, 6)

charmCorner.Parent =
    charmDropBtn

local function updateCharmButton()
    local prefix =
        _G.Language == "TH"
        and "✨ ระดับ: "
        or "✨ Rarity: "

    charmDropBtn.Text =
        prefix
        .. tostring(config.SelectedCharmRarity)
end

updateCharmButton()

--// =========================================================
--// FARM BUTTONS
--// =========================================================

local autoWinButton =
    createMenuButton(
        "ออโต้วิน (เก็บชนะ)",
        "Auto Win (Collect Wins)",
        FarmPage,
        "AutoWinActive",
        function(enabled)
            if enabled then
                config.AutoTreadmillActive = false
                saveConfig()
            end
        end
    )

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
    "ออโต้ลู่วิ่ง (ปั๊มสปีด)",
    "Auto Treadmill (Farm Speed)",
    FarmPage,
    "AutoTreadmillActive",
    function(enabled)
        if enabled then
            config.AutoWinActive = false
            saveConfig()
        end
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

--// =========================================================
--// CHARM
--// =========================================================

createMenuButton(
    "ซื้อเครื่องรางอัตโนมัติ",
    "Auto Buy Charms",
    CharmPage,
    "AutoCharmActive",
    function()
    end
)

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

--// =========================================================
--// PLAYER
--// =========================================================

createMenuTextBox(
    "🏃 ปรับความเร็วตัวละคร (ใส่เลข)",
    "🏃 WalkSpeed Value",
    "WalkSpeedVal",
    PlayerPage,
    function()
    end
)

createMenuTextBox(
    "🦘 ปรับแรงกระโดดตัวละคร (ใส่เลข)",
    "🦘 JumpPower Value",
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
    "✈️ Fly Speed Value",
    "FlySpeedVal",
    PlayerPage,
    function()
    end
)

--// =========================================================
--// LANGUAGE SETTINGS
--// =========================================================

local thLangBtn =
    Instance.new("TextButton")

thLangBtn.Size =
    UDim2.new(0.96, 0, 0, 38)

thLangBtn.Text =
    "ภาษาไทย (TH)"

thLangBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

thLangBtn.Font =
    Enum.Font.SourceSansBold

thLangBtn.TextSize = 15
thLangBtn.Parent = SettingPage

local thCorner =
    Instance.new("UICorner")

thCorner.CornerRadius =
    UDim.new(0, 6)

thCorner.Parent = thLangBtn

local enLangBtn =
    Instance.new("TextButton")

enLangBtn.Size =
    UDim2.new(0.96, 0, 0, 38)

enLangBtn.Text =
    "English (EN)"

enLangBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

enLangBtn.Font =
    Enum.Font.SourceSansBold

enLangBtn.TextSize = 15
enLangBtn.Parent = SettingPage

local enCorner =
    Instance.new("UICorner")

enCorner.CornerRadius =
    UDim.new(0, 6)

enCorner.Parent = enLangBtn

local function refreshLanguageButtons()
    if _G.Language == "TH" then
        thLangBtn.BackgroundColor3 =
            Color3.fromRGB(0, 120, 255)

        enLangBtn.BackgroundColor3 =
            Color3.fromRGB(40, 40, 50)
    else
        enLangBtn.BackgroundColor3 =
            Color3.fromRGB(0, 120, 255)

        thLangBtn.BackgroundColor3 =
            Color3.fromRGB(40, 40, 50)
    end
end

thLangBtn.MouseButton1Click:Connect(function()
    _G.Language = "TH"
    config.Language = "TH"

    saveConfig()

    refreshLanguageButtons()
    updateLanguageDisplay()
    updateStageButton()
    updateTreadmillButton()
    updateCharmButton()
end)

enLangBtn.MouseButton1Click:Connect(function()
    _G.Language = "EN"
    config.Language = "EN"

    saveConfig()

    refreshLanguageButtons()
    updateLanguageDisplay()
    updateStageButton()
    updateTreadmillButton()
    updateCharmButton()
end)

refreshLanguageButtons()

--// =========================================================
--// DROPDOWN OPTIONS
--// =========================================================

local function createDropdownOption(text, value)
    local btn = Instance.new("TextButton")

    btn.Size =
        UDim2.new(1, 0, 0, 32)

    btn.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)

    btn.Text = text
    btn.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    btn.Font =
        Enum.Font.SourceSans

    btn.TextSize = 14
    btn.Parent = DropdownContainer
    btn.ZIndex = 21

    btn.MouseButton1Click:Connect(function()
        config.SelectedStage = value

        saveConfig()
        updateStageButton()

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

    btn.Size =
        UDim2.new(1, 0, 0, 32)

    btn.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)

    btn.Text = text
    btn.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    btn.Font =
        Enum.Font.SourceSans

    btn.TextSize = 14
    btn.Parent = TreadmillDropdownContainer
    btn.ZIndex = 21

    btn.MouseButton1Click:Connect(function()
        config.SelectedTreadmill = value

        saveConfig()
        updateTreadmillButton()

        TreadmillDropdownContainer.Visible = false
    end)
end

createTreadmillOption(
    "Treadmill Basic",
    "Basic"
)

createTreadmillOption(
    "Treadmill Gold",
    "Gold"
)

createTreadmillOption(
    "Treadmill Galaxy",
    "Galaxy"
)

createTreadmillOption(
    "Treadmill Void",
    "Void"
)

createTreadmillOption(
    "Treadmill Celestial",
    "Celestial"
)

createTreadmillOption(
    "Treadmill Diamond",
    "Diamond"
)

createTreadmillOption(
    "Treadmill Playtime",
    "Playtime"
)

local function createCharmOption(text, value)
    local btn = Instance.new("TextButton")

    btn.Size =
        UDim2.new(1, 0, 0, 32)

    btn.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)

    btn.Text = text
    btn.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    btn.Font =
        Enum.Font.SourceSans

    btn.TextSize = 14
    btn.Parent = CharmDropdownContainer
    btn.ZIndex = 21

    btn.MouseButton1Click:Connect(function()
        config.SelectedCharmRarity = value

        saveConfig()
        updateCharmButton()

        CharmDropdownContainer.Visible = false
    end)
end

createCharmOption(
    "Common (ระดับ 1)",
    1
)

createCharmOption(
    "Rare (ระดับ 2)",
    2
)

createCharmOption(
    "Epic (ระดับ 3)",
    3
)

createCharmOption(
    "Secret (ระดับ 4)",
    4
)

--// =========================================================
--// DROPDOWN EVENTS
--// =========================================================

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

--// =========================================================
--// SERVER PLAYER COUNT
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(2)

        pcall(function()
            local allPlayers =
                Players:GetPlayers()

            local maxPlayers =
                Players.MaxPlayers

            PlayerCountLabel.Text =
                "🎮 Server: "
                .. tostring(#allPlayers)
                .. "/"
                .. tostring(maxPlayers)
        end)
    end
end)

--// =========================================================
--// AUTO WIN / TREADMILL
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(
            math.max(
                tonumber(config.WarpDelay)
                    or 0.5,
                0.05
            )
        )

        if
            config.AutoWinActive
            and player.Character
        then
            local hrp =
                player.Character:
                FindFirstChild(
                    "HumanoidRootPart"
                )

            local hum =
                player.Character:
                FindFirstChildOfClass(
                    "Humanoid"
                )

            if hrp and hum then
                if config.SelectedStage == "Auto" then

                    for i = 1, 9 do
                        if not config.AutoWinActive then
                            break
                        end

                        local btn =
                            getStageButton(i)

                        if btn then
                            pcall(function()
                                hrp.CFrame =
                                    btn.CFrame

                                hum.Jump = true
                            end)

                            task.wait(0.1)
                        end
                    end

                else
                    local stageNum =
                        tonumber(
                            config.SelectedStage
                        )

                    if stageNum then
                        local btn =
                            getStageButton(
                                stageNum
                            )

                        if btn then
                            pcall(function()
                                hrp.CFrame =
                                    btn.CFrame

                                hum.Jump = true
                            end)
                        end
                    end
                end
            end

        elseif
            config.AutoTreadmillActive
            and player.Character
        then
            local hrp =
                player.Character:
                FindFirstChild(
                    "HumanoidRootPart"
                )

            if hrp then
                local tmPart =
                    getTreadmillPart(
                        config.SelectedTreadmill
                    )

                if tmPart then
                    pcall(function()
                        hrp.CFrame =
                            tmPart.CFrame
                    end)
                end
            end
        end
    end
end)

--// =========================================================
--// AUTO BUY
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.8)

        if
            config.AutoBuyActive
            and player.Character
        then
            pcall(function()
                local fx =
                    workspace:FindFirstChild("Fx")

                if fx then
                    for _, child in ipairs(
                        fx:GetChildren()
                    ) do
                        checkAndBuy(child)
                    end
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
                    ):FindFirstChild(
                        "Remotes"
                    )

                if remotes then
                    local rebirth =
                        remotes:FindFirstChild(
                            "Rebirth"
                        )

                    if rebirth then
                        rebirth:FireServer()
                    end
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
                tonumber(config.CharmDelay)
                    or 1,
                0.05
            )
        )

        if config.AutoCharmActive then
            pcall(function()
                local remotes =
                    game:GetService(
                        "ReplicatedStorage"
                    ):FindFirstChild(
                        "Remotes"
                    )

                if remotes then
                    local buyCharm =
                        remotes:FindFirstChild(
                            "BuyCharm"
                        )

                    if buyCharm then
                        buyCharm:FireServer(
                            config.SelectedCharmRarity
                        )
                    end
                end
            end)
        end
    end
end)

--// =========================================================
--// PLAYER SPEED / JUMP
--// =========================================================

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.1)

        pcall(function()
            if config.FlyActive then
                return
            end

            local char =
                player.Character

            local hum =
                char
                and char:FindFirstChildOfClass(
                    "Humanoid"
                )

            if hum then
                hum.WalkSpeed =
                    tonumber(
                        config.WalkSpeedVal
                    )
                    or 16

                hum.UseJumpPower = true

                hum.JumpPower =
                    tonumber(
                        config.JumpPowerVal
                    )
                    or 50
            end
        end)
    end
end)

--// =========================================================
--// INFINITE JUMP
--// =========================================================

UserInputService.JumpRequest:Connect(function()
    if not config.InfiniteJumpActive then
        return
    end

    if config.FlyActive then
        return
    end

    pcall(function()
        local char =
            player.Character

        local hum =
            char
            and char:FindFirstChildOfClass(
                "Humanoid"
            )

        local hrp =
            char
            and char:FindFirstChild(
                "HumanoidRootPart"
            )

        if hum and hrp then
            local velocity =
                hrp.AssemblyLinearVelocity

            hrp.AssemblyLinearVelocity =
                Vector3.new(
                    velocity.X,
                    tonumber(
                        config.JumpPowerVal
                    ) or 50,
                    velocity.Z
                )
        end
    end)
end)

--// =========================================================
--// FLY SYSTEM
--// =========================================================

local flyingCore = nil

local function stopFly()
    if flyingCore then
        pcall(function()
            flyingCore:Destroy()
        end)

        flyingCore = nil
    end

    pcall(function()
        local char =
            player.Character

        local hum =
            char
            and char:FindFirstChildOfClass(
                "Humanoid"
            )

        if hum then
            hum.PlatformStand = false
        end
    end)
end

local function startFly()
    local char =
        player.Character

    if not char then
        return
    end

    local hrp =
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    local hum =
        char:FindFirstChildOfClass(
            "Humanoid"
        )

    if not hrp or not hum then
        return
    end

    if not flyingCore then
        flyingCore =
            Instance.new("BodyVelocity")

        flyingCore.Name =
            "SpeedFC_FlyVelocity"

        flyingCore.MaxForce =
            Vector3.new(
                1e6,
                1e6,
                1e6
            )

        flyingCore.Velocity =
            Vector3.zero

        flyingCore.Parent = hrp
    end

    hum.PlatformStand = true
end

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.01)

        if
            config.FlyActive
            and player.Character
        then
            pcall(function()
                startFly()

                local char =
                    player.Character

                local hrp =
                    char:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if not hrp or not flyingCore then
                    return
                end

                local cam =
                    workspace.CurrentCamera

                if not cam then
                    return
                end

                local moveDir =
                    Vector3.zero

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.W
                ) then
                    moveDir +=
                        cam.CFrame.LookVector
                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.S
                ) then
                    moveDir -=
                        cam.CFrame.LookVector
                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.A
                ) then
                    moveDir -=
                        cam.CFrame.RightVector
                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.D
                ) then
                    moveDir +=
                        cam.CFrame.RightVector
                end

                local horizontal =
                    Vector3.new(
                        moveDir.X,
                        0,
                        moveDir.Z
                    )

                if horizontal.Magnitude > 0 then
                    horizontal =
                        horizontal.Unit
                else
                    horizontal =
                        Vector3.zero
                end

                local vertical = 0

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.Space
                ) then
                    vertical = 1
                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.LeftShift
                ) then
                    vertical = -1
                end

                local speed =
                    math.max(
                        tonumber(
                            config.FlySpeedVal
                        ) or 50,
                        0
                    )

                flyingCore.Velocity =
                    (
                        horizontal * speed
                    )
                    +
                    Vector3.new(
                        0,
                        vertical * speed,
                        0
                    )
            end)
        else
            stopFly()
        end
    end

    stopFly()
end)

--// =========================================================
--// CHARACTER RESPAWN
--// =========================================================

player.CharacterAdded:Connect(function()
    stopFly()

    task.wait(1)

    if config.FlyActive then
        startFly()
    end
end)

--// =========================================================
--// MINIMIZE / CLOSE
--// =========================================================

CloseButton.MouseButton1Click:Connect(function()
    config.FlyActive = false
    saveConfig()

    stopFly()

    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniButton.Visible = true

    DropdownContainer.Visible = false
    CharmDropdownContainer.Visible = false
    TreadmillDropdownContainer.Visible = false
end)

MiniButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniButton.Visible = false
end)

--// =========================================================
--// FINAL REFRESH
--// =========================================================

updateLanguageDisplay()
updateStageButton()
updateTreadmillButton()
updateCharmButton()
refreshLanguageButtons()

print(
    "[SpeedFC Hub] Premium Fixed Edition loaded successfully."
)
