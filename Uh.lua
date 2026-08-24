--// =========================================================
--// INFINITY HUB - ULTIMATE CYBER EDITION
--// Fixed / Cleaned Version
--// =========================================================

local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local filename = "InfinityHub_Configs.json"

--// =========================================================
--// CONFIG
--// =========================================================

_G.Configs = {
    AutoTeleport = false,
    TargetReward = "None",
    WarpDelay = 0.5,

    AutoAFKRun = false,
    AutoRebirth = false,

    CustomSpeed = 16,
    AutoSpeedActive = false,

    CustomJump = 50,
    AutoJumpActive = false,

    AutoBuyEquipment = false,
    InfJumpActive = false
}

--// =========================================================
--// SAVE / LOAD
--// =========================================================

local function SaveData()
    if writefile then
        pcall(function()
            writefile(
                filename,
                HttpService:JSONEncode(_G.Configs)
            )
        end)
    end
end

local function LoadData()
    if readfile and isfile and isfile(filename) then
        pcall(function()
            local raw = readfile(filename)
            local decoded = HttpService:JSONDecode(raw)

            if type(decoded) == "table" then
                for key, value in pairs(decoded) do
                    if _G.Configs[key] ~= nil then
                        _G.Configs[key] = value
                    end
                end
            end
        end)
    end
end

LoadData()

--// Sync global variables
_G.AutoTeleport = _G.Configs.AutoTeleport
_G.TargetReward = (
    _G.Configs.TargetReward ~= "None"
    and _G.Configs.TargetReward
    or nil
)

_G.WarpDelay = _G.Configs.WarpDelay
_G.AutoAFKRun = _G.Configs.AutoAFKRun
_G.AutoRebirth = _G.Configs.AutoRebirth

_G.CustomSpeed = _G.Configs.CustomSpeed
_G.AutoSpeedActive = _G.Configs.AutoSpeedActive

_G.CustomJump = _G.Configs.CustomJump
_G.AutoJumpActive = _G.Configs.AutoJumpActive

_G.AutoBuyEquipment = _G.Configs.AutoBuyEquipment
_G.InfJumpActive = _G.Configs.InfJumpActive

--// =========================================================
--// ANTI AFK
--// =========================================================

pcall(function()
    local connections = getconnections(LocalPlayer.Idled)

    for _, connection in ipairs(connections) do
        pcall(function()
            connection:Disable()
        end)
    end
end)

--// =========================================================
--// QUEUE ON TELEPORT
--// =========================================================

if queue_on_teleport then
    pcall(function()
        queue_on_teleport([[
            repeat
                task.wait()
            until game:IsLoaded()
        ]])
    end)
end

--// =========================================================
--// AUTO RECONNECT
--// =========================================================

pcall(function()
    GuiService.ErrorMessageChanged:Connect(function()
        task.wait(1)

        pcall(function()
            if #Players:GetPlayers() <= 1 then
                TeleportService:Teleport(
                    game.PlaceId,
                    LocalPlayer
                )
            else
                TeleportService:TeleportToPlaceInstance(
                    game.PlaceId,
                    game.JobId,
                    LocalPlayer
                )
            end
        end)
    end)
end)

--// =========================================================
--// INFINITE JUMP
--// =========================================================

UserInputService.JumpRequest:Connect(function()
    if not _G.InfJumpActive then
        return
    end

    pcall(function()
        local character = LocalPlayer.Character
        local humanoid = character
            and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid:ChangeState(
                Enum.HumanoidStateType.Jumping
            )
        end
    end)
end)

--// =========================================================
--// GUI
--// =========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfinityHub_UltimateCyber"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

--// =========================================================
--// GUI HELPERS
--// =========================================================

local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent

    return corner
end

local function AddStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent

    return stroke
end

local function AddGradient(parent, color1, color2)
    local gradient = Instance.new("UIGradient")

    gradient.Color = ColorSequence.new(
        color1,
        color2
    )

    gradient.Rotation = 45
    gradient.Parent = parent

    return gradient
end

--// =========================================================
--// FLOATING BUTTON
--// =========================================================

local ToggleHubBtn = Instance.new("TextButton")
ToggleHubBtn.Name = "ToggleHubBtn"
ToggleHubBtn.Parent = ScreenGui

ToggleHubBtn.BackgroundColor3 =
    Color3.fromRGB(15, 15, 25)

ToggleHubBtn.BorderSizePixel = 0
ToggleHubBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleHubBtn.Size = UDim2.new(0, 60, 0, 60)

ToggleHubBtn.Font = Enum.Font.GothamBold
ToggleHubBtn.Text = "INF"
ToggleHubBtn.TextColor3 =
    Color3.fromRGB(0, 255, 200)

ToggleHubBtn.TextSize = 16
ToggleHubBtn.Active = true
ToggleHubBtn.Draggable = true

AddCorner(ToggleHubBtn, 30)

local BtnStroke = AddStroke(
    ToggleHubBtn,
    Color3.fromRGB(0, 255, 200),
    2
)

AddGradient(
    ToggleHubBtn,
    Color3.fromRGB(20, 20, 35),
    Color3.fromRGB(0, 50, 100)
)

task.spawn(function()
    while task.wait(0.05) do
        local hue = (tick() % 5) / 5
        local color = Color3.fromHSV(hue, 1, 1)

        BtnStroke.Color = color
        ToggleHubBtn.TextColor3 =
            Color3.fromHSV(hue, 0.8, 1)
    end
end)

--// =========================================================
--// MAIN FRAME
--// =========================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui

MainFrame.BackgroundColor3 =
    Color3.fromRGB(10, 10, 15)

MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 480, 0, 360)

MainFrame.Active = true
MainFrame.Draggable = true

AddCorner(MainFrame, 16)

local MainStroke = AddStroke(
    MainFrame,
    Color3.fromRGB(0, 255, 255),
    2
)

task.spawn(function()
    while task.wait(0.05) do
        local hue = (tick() % 8) / 8

        MainStroke.Color =
            Color3.fromHSV(hue, 0.9, 0.9)
    end
end)

--// =========================================================
--// HEADER
--// =========================================================

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame

TitleLabel.BackgroundColor3 =
    Color3.fromRGB(15, 15, 25)

TitleLabel.BorderSizePixel = 0
TitleLabel.Size = UDim2.new(1, 0, 0, 45)

TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text =
    "    INFINITY HUB  //  ULTIMATE CYBER EDITION"

TitleLabel.TextColor3 =
    Color3.fromRGB(255, 255, 255)

TitleLabel.TextSize = 13
TitleLabel.TextXAlignment =
    Enum.TextXAlignment.Left

AddCorner(TitleLabel, 16)

AddGradient(
    TitleLabel,
    Color3.fromRGB(25, 25, 40),
    Color3.fromRGB(15, 15, 25)
)

--// =========================================================
--// NAVIGATION
--// =========================================================

local NavigationBar = Instance.new("Frame")
NavigationBar.Name = "NavigationBar"
NavigationBar.Parent = MainFrame

NavigationBar.BackgroundColor3 =
    Color3.fromRGB(15, 15, 22)

NavigationBar.BorderSizePixel = 0

NavigationBar.Position =
    UDim2.new(0, 8, 0, 53)

NavigationBar.Size =
    UDim2.new(0, 110, 1, -61)

AddCorner(NavigationBar, 12)

AddStroke(
    NavigationBar,
    Color3.fromRGB(30, 30, 45),
    1
)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = NavigationBar
UIListLayout.SortOrder =
    Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

local RewardTabBtn = Instance.new("TextButton")
local AFKTabBtn = Instance.new("TextButton")
local RebirthTabBtn = Instance.new("TextButton")
local PlayerTabBtn = Instance.new("TextButton")
local ShopTabBtn = Instance.new("TextButton")

local tabs = {
    {
        Btn = RewardTabBtn,
        Text = "💎 Auto Reward"
    },
    {
        Btn = AFKTabBtn,
        Text = "🏃 Auto AFK"
    },
    {
        Btn = RebirthTabBtn,
        Text = "🔄 Auto Rebirth"
    },
    {
        Btn = PlayerTabBtn,
        Text = "⚡ Local Player"
    },
    {
        Btn = ShopTabBtn,
        Text = "🛒 Auto Equip"
    }
}

for i, tab in ipairs(tabs) do
    local button = tab.Btn

    button.Name =
        "Tab_" .. tostring(i)

    button.Parent = NavigationBar

    button.BackgroundColor3 =
        i == 1
        and Color3.fromRGB(0, 255, 200)
        or Color3.fromRGB(20, 20, 30)

    button.BorderSizePixel = 0
    button.Size =
        UDim2.new(1, 0, 0, 36)

    button.Font = Enum.Font.GothamBold
    button.Text = tab.Text

    button.TextColor3 =
        i == 1
        and Color3.fromRGB(10, 10, 15)
        or Color3.fromRGB(180, 180, 200)

    button.TextSize = 11

    AddCorner(button, 8)

    if i ~= 1 then
        AddStroke(
            button,
            Color3.fromRGB(35, 35, 50),
            1
        )
    end
end

--// =========================================================
--// PAGES
--// =========================================================

local PagesFolder = Instance.new("Folder")
PagesFolder.Name = "Pages"
PagesFolder.Parent = MainFrame

local RewardPage = Instance.new("ScrollingFrame")
local AFKPage = Instance.new("ScrollingFrame")
local RebirthPage = Instance.new("ScrollingFrame")
local PlayerPage = Instance.new("ScrollingFrame")
local ShopPage = Instance.new("ScrollingFrame")

local function ConfigurePage(page, name, visible)
    page.Name = name
    page.Parent = PagesFolder

    page.BackgroundColor3 =
        Color3.fromRGB(13, 13, 20)

    page.BorderSizePixel = 0

    page.Position =
        UDim2.new(0, 126, 0, 53)

    page.Size =
        UDim2.new(0, 346, 0, 299)

    page.CanvasSize =
        UDim2.new(0, 0, 0, 0)

    page.AutomaticCanvasSize =
        Enum.AutomaticSize.Y

    page.ScrollBarThickness = 3

    page.ScrollBarImageColor3 =
        Color3.fromRGB(0, 255, 200)

    page.Visible = visible

    AddCorner(page, 12)

    AddStroke(
        page,
        Color3.fromRGB(30, 30, 45),
        1
    )

    local pageList = Instance.new("UIListLayout")
    pageList.Parent = page
    pageList.SortOrder =
        Enum.SortOrder.LayoutOrder
    pageList.Padding = UDim.new(0, 10)

    local padding = Instance.new("UIPadding")
    padding.Parent = page

    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
end

ConfigurePage(RewardPage, "RewardPage", true)
ConfigurePage(AFKPage, "AFKPage", false)
ConfigurePage(RebirthPage, "RebirthPage", false)
ConfigurePage(PlayerPage, "PlayerPage", false)
ConfigurePage(ShopPage, "ShopPage", false)

--// =========================================================
--// SECTION TITLE
--// =========================================================

local function CreateSectionTitle(parent, text)
    local label = Instance.new("TextLabel")

    label.BackgroundTransparency = 1
    label.Size =
        UDim2.new(0.95, 0, 0, 25)

    label.Font = Enum.Font.GothamBold
    label.Text = "// " .. string.upper(text)

    label.TextColor3 =
        Color3.fromRGB(0, 255, 255)

    label.TextSize = 13
    label.TextXAlignment =
        Enum.TextXAlignment.Left

    label.Parent = parent

    return label
end

--// =========================================================
--// TOGGLE
--// =========================================================

local function CreateNeonToggle(parent, labelText, varName)
    local frame = Instance.new("Frame")

    frame.BackgroundColor3 =
        Color3.fromRGB(20, 20, 32)

    frame.Size =
        UDim2.new(0.95, 0, 0, 45)

    AddCorner(frame, 8)

    AddStroke(
        frame,
        Color3.fromRGB(35, 35, 55),
        1
    )

    frame.Parent = parent

    local label = Instance.new("TextLabel")

    label.BackgroundTransparency = 1
    label.Position =
        UDim2.new(0, 10, 0, 0)

    label.Size =
        UDim2.new(0.6, 0, 1, 0)

    label.Font = Enum.Font.GothamSemibold
    label.Text = labelText

    label.TextColor3 =
        Color3.fromRGB(220, 220, 240)

    label.TextSize = 13
    label.TextXAlignment =
        Enum.TextXAlignment.Left

    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")

    toggleBtn.BackgroundColor3 =
        _G[varName]
        and Color3.fromRGB(0, 200, 100)
        or Color3.fromRGB(200, 50, 50)

    toggleBtn.Size =
        UDim2.new(0, 55, 0, 26)

    toggleBtn.Position =
        UDim2.new(0.95, -55, 0.5, -13)

    toggleBtn.Font = Enum.Font.GothamBold

    toggleBtn.Text =
        _G[varName] and "ON" or "OFF"

    toggleBtn.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    toggleBtn.TextSize = 11

    AddCorner(toggleBtn, 13)

    toggleBtn.Parent = frame

    toggleBtn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]

        _G.Configs[varName] =
            _G[varName]

        SaveData()

        local targetColor =
            _G[varName]
            and Color3.fromRGB(0, 200, 100)
            or Color3.fromRGB(200, 50, 50)

        TweenService:Create(
            toggleBtn,
            TweenInfo.new(
                0.2,
                Enum.EasingStyle.Quad
            ),
            {
                BackgroundColor3 = targetColor
            }
        ):Play()

        toggleBtn.Text =
            _G[varName] and "ON" or "OFF"
    end)

    return toggleBtn
end

--// =========================================================
--// SLIDER
--// =========================================================

local function CreateNeonSlider(
    parent,
    labelText,
    minVal,
    maxVal,
    varName,
    isTime,
    suffix
)
    local frame = Instance.new("Frame")

    frame.BackgroundColor3 =
        Color3.fromRGB(20, 20, 32)

    frame.Size =
        UDim2.new(0.95, 0, 0, 55)

    AddCorner(frame, 8)

    AddStroke(
        frame,
        Color3.fromRGB(35, 35, 55),
        1
    )

    frame.Parent = parent

    local label = Instance.new("TextLabel")

    label.BackgroundTransparency = 1
    label.Position =
        UDim2.new(0, 10, 0, 6)

    label.Size =
        UDim2.new(0.5, 0, 0, 20)

    label.Font = Enum.Font.GothamSemibold
    label.Text = labelText

    label.TextColor3 =
        Color3.fromRGB(180, 180, 200)

    label.TextSize = 12
    label.TextXAlignment =
        Enum.TextXAlignment.Left

    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")

    valueLabel.BackgroundTransparency = 1

    valueLabel.Position =
        UDim2.new(0.5, 0, 0, 6)

    valueLabel.Size =
        UDim2.new(0.45, 0, 0, 20)

    valueLabel.Font = Enum.Font.GothamBold

    valueLabel.Text =
        tostring(_G[varName]) .. suffix

    valueLabel.TextColor3 =
        Color3.fromRGB(0, 255, 255)

    valueLabel.TextSize = 12

    valueLabel.TextXAlignment =
        Enum.TextXAlignment.Right

    valueLabel.Parent = frame

    local sliderContainer = Instance.new("Frame")

    sliderContainer.BackgroundColor3 =
        Color3.fromRGB(45, 45, 60)

    sliderContainer.Position =
        UDim2.new(0, 10, 0, 34)

    sliderContainer.Size =
        UDim2.new(0.95, -20, 0, 6)

    AddCorner(sliderContainer, 3)

    sliderContainer.Parent = frame

    local startPercent =
        math.clamp(
            (
                _G[varName] - minVal
            ) / (maxVal - minVal),
            0,
            1
        )

    local sliderBar = Instance.new("Frame")

    sliderBar.BackgroundColor3 =
        Color3.fromRGB(0, 255, 255)

    sliderBar.BorderSizePixel = 0

    sliderBar.Size =
        UDim2.new(startPercent, 0, 1, 0)

    AddCorner(sliderBar, 3)

    sliderBar.Parent = sliderContainer

    AddGradient(
        sliderBar,
        Color3.fromRGB(0, 200, 255),
        Color3.fromRGB(0, 255, 150)
    )

    local sliderDot = Instance.new("TextButton")

    sliderDot.BackgroundColor3 =
        Color3.fromRGB(255, 255, 255)

    sliderDot.BorderSizePixel = 0

    sliderDot.Position =
        UDim2.new(startPercent, -6, 0, -3)

    sliderDot.Size =
        UDim2.new(0, 12, 0, 12)

    sliderDot.Text = ""

    AddCorner(sliderDot, 6)

    sliderDot.Parent = sliderContainer

    AddStroke(
        sliderDot,
        Color3.fromRGB(0, 150, 255),
        1
    )

    local dragging = false

    sliderDot.InputBegan:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            dragging = true
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

        local mouseX =
            input.Position.X
            - sliderContainer.AbsolutePosition.X

        local percentage =
            math.clamp(
                mouseX
                / sliderContainer.AbsoluteSize.X,
                0,
                1
            )

        sliderDot.Position =
            UDim2.new(
                percentage,
                -6,
                0,
                -3
            )

        sliderBar.Size =
            UDim2.new(
                percentage,
                0,
                1,
                0
            )

        local rawValue =
            minVal
            + percentage
            * (maxVal - minVal)

        if isTime then
            _G[varName] =
                math.round(rawValue * 10) / 10
        else
            _G[varName] =
                math.round(rawValue)
        end

        _G.Configs[varName] =
            _G[varName]

        SaveData()

        valueLabel.Text =
            tostring(_G[varName])
            .. suffix
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            dragging = false
        end
    end)
end

--// =========================================================
--// REWARD LIST
--// =========================================================

local function GetRewardsList()
    local list = {}

    pcall(function()
        local reward =
            workspace:FindFirstChild("Reward")

        local normal =
            reward
            and reward:FindFirstChild("Normal")

        if normal then
            for _, object in ipairs(
                normal:GetChildren()
            ) do
                table.insert(
                    list,
                    object.Name
                )
            end
        end
    end)

    table.sort(list)

    return list
end

local rewardsList = GetRewardsList()

--// =========================================================
--// AUTO REWARD PAGE
--// =========================================================

CreateSectionTitle(
    RewardPage,
    "Target Station Selector"
)

local DropdownBtn = Instance.new("TextButton")

DropdownBtn.BackgroundColor3 =
    Color3.fromRGB(25, 25, 38)

DropdownBtn.Size =
    UDim2.new(0.95, 0, 0, 38)

DropdownBtn.Font = Enum.Font.GothamSemibold

DropdownBtn.Text =
    _G.TargetReward
    and "📍 LOCKED ON: REWARD "
        .. _G.TargetReward
    or "🔽 SELECT REWARD STATION"

DropdownBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

DropdownBtn.TextSize = 13

AddCorner(DropdownBtn, 8)

AddStroke(
    DropdownBtn,
    Color3.fromRGB(45, 45, 65),
    1
)

DropdownBtn.Parent = RewardPage

local DropdownList = Instance.new("ScrollingFrame")

DropdownList.BackgroundColor3 =
    Color3.fromRGB(18, 18, 28)

DropdownList.Size =
    UDim2.new(0.95, 0, 0, 110)

DropdownList.CanvasSize =
    UDim2.new(0, 0, 0, 0)

DropdownList.AutomaticCanvasSize =
    Enum.AutomaticSize.Y

DropdownList.ScrollBarThickness = 2

DropdownList.Visible = false
DropdownList.ZIndex = 5

AddCorner(DropdownList, 8)

AddStroke(
    DropdownList,
    Color3.fromRGB(0, 255, 200),
    1
)

DropdownList.Parent = RewardPage

local DropListLayout =
    Instance.new("UIListLayout")

DropListLayout.Parent =
    DropdownList

DropListLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

for _, name in ipairs(rewardsList) do
    local itemBtn =
        Instance.new("TextButton")

    itemBtn.Size =
        UDim2.new(1, 0, 0, 30)

    itemBtn.BackgroundColor3 =
        Color3.fromRGB(22, 22, 32)

    itemBtn.BorderSizePixel = 0

    itemBtn.Font = Enum.Font.Gotham

    itemBtn.Text =
        "Target Node // " .. name

    itemBtn.TextColor3 =
        Color3.fromRGB(200, 200, 220)

    itemBtn.TextSize = 12
    itemBtn.ZIndex = 6

    itemBtn.Parent = DropdownList

    itemBtn.MouseButton1Click:Connect(function()
        _G.TargetReward = name
        _G.Configs.TargetReward = name

        SaveData()

        DropdownBtn.Text =
            "📍 LOCKED ON: REWARD "
            .. name

        DropdownList.Visible = false
    end)
end

if #rewardsList == 0 then
    local emptyLabel =
        Instance.new("TextLabel")

    emptyLabel.Size =
        UDim2.new(1, 0, 0, 30)

    emptyLabel.BackgroundTransparency = 1

    emptyLabel.Text =
        "No Reward Station Found"

    emptyLabel.TextColor3 =
        Color3.fromRGB(150, 150, 170)

    emptyLabel.TextSize = 11

    emptyLabel.Parent = DropdownList
end

DropdownBtn.MouseButton1Click:Connect(function()
    DropdownList.Visible =
        not DropdownList.Visible
end)

CreateSectionTitle(
    RewardPage,
    "Teleport Core Configs"
)

CreateNeonSlider(
    RewardPage,
    "Warp Interval Delay",
    0.1,
    2.0,
    "WarpDelay",
    true,
    "s"
)

CreateNeonToggle(
    RewardPage,
    "Activation Matrix",
    "AutoTeleport"
)

--// =========================================================
--// AUTO AFK
--// =========================================================

CreateSectionTitle(
    AFKPage,
    "Intelligent Treadmill Core"
)

CreateNeonToggle(
    AFKPage,
    "Smart Speed Farm Matrix",
    "AutoAFKRun"
)

local afkDesc =
    Instance.new("TextLabel")

afkDesc.BackgroundTransparency = 1

afkDesc.Size =
    UDim2.new(0.95, 0, 0, 50)

afkDesc.Font = Enum.Font.Gotham

afkDesc.Text =
    "ระบบตรวจจับค่าพลังในตัวละครอัตโนมัติ "
    .. "และเลือกพื้นที่ AFK ที่เหมาะสม"

afkDesc.TextColor3 =
    Color3.fromRGB(140, 140, 160)

afkDesc.TextSize = 11
afkDesc.TextWrapped = true

afkDesc.TextXAlignment =
    Enum.TextXAlignment.Left

afkDesc.Parent = AFKPage

--// =========================================================
--// AUTO REBIRTH
--// =========================================================

CreateSectionTitle(
    RebirthPage,
    "Server Rebirth Engine"
)

CreateNeonToggle(
    RebirthPage,
    "Auto Spammer (Remote)",
    "AutoRebirth"
)

--// =========================================================
--// LOCAL PLAYER
--// =========================================================

CreateSectionTitle(
    PlayerPage,
    "Physical Body Modification"
)

CreateNeonSlider(
    PlayerPage,
    "Sprinting WalkSpeed",
    16,
    1000,
    "CustomSpeed",
    false,
    ""
)

CreateNeonToggle(
    PlayerPage,
    "Lock Speed Value",
    "AutoSpeedActive"
)

CreateNeonSlider(
    PlayerPage,
    "Gravitational JumpPower",
    50,
    1000,
    "CustomJump",
    false,
    ""
)

CreateNeonToggle(
    PlayerPage,
    "Lock Jump Value",
    "AutoJumpActive"
)

CreateSectionTitle(
    PlayerPage,
    "Physics Overrides"
)

CreateNeonToggle(
    PlayerPage,
    "Infinite Air Jump (Anti-Void)",
    "InfJumpActive"
)

--// =========================================================
--// AUTO EQUIP
--// =========================================================

CreateSectionTitle(
    ShopPage,
    "Dynamic Shop System"
)

CreateNeonToggle(
    ShopPage,
    "Auto Purchase Highest Tier",
    "AutoBuyEquipment"
)

--// =========================================================
--// TAB SYSTEM
--// =========================================================

local function TabAnimate(activePage, activeBtn)
    RewardPage.Visible = false
    AFKPage.Visible = false
    RebirthPage.Visible = false
    PlayerPage.Visible = false
    ShopPage.Visible = false

    local allBtns = {
        RewardTabBtn,
        AFKTabBtn,
        RebirthTabBtn,
        PlayerTabBtn,
        ShopTabBtn
    }

    for _, btn in ipairs(allBtns) do
        TweenService:Create(
            btn,
            TweenInfo.new(
                0.15,
                Enum.EasingStyle.Quad
            ),
            {
                BackgroundColor3 =
                    Color3.fromRGB(20, 20, 30),

                TextColor3 =
                    Color3.fromRGB(180, 180, 200)
            }
        ):Play()
    end

    activePage.Visible = true

    TweenService:Create(
        activeBtn,
        TweenInfo.new(
            0.2,
            Enum.EasingStyle.Quad
        ),
        {
            BackgroundColor3 =
                Color3.fromRGB(0, 255, 200),

            TextColor3 =
                Color3.fromRGB(10, 10, 15)
        }
    ):Play()
end

RewardTabBtn.MouseButton1Click:Connect(function()
    TabAnimate(
        RewardPage,
        RewardTabBtn
    )
end)

AFKTabBtn.MouseButton1Click:Connect(function()
    TabAnimate(
        AFKPage,
        AFKTabBtn
    )
end)

RebirthTabBtn.MouseButton1Click:Connect(function()
    TabAnimate(
        RebirthPage,
        RebirthTabBtn
    )
end)

PlayerTabBtn.MouseButton1Click:Connect(function()
    TabAnimate(
        PlayerPage,
        PlayerTabBtn
    )
end)

ShopTabBtn.MouseButton1Click:Connect(function()
    TabAnimate(
        ShopPage,
        ShopTabBtn
    )
end)

--// =========================================================
--// OPEN / CLOSE
--// =========================================================

local OriginalSize =
    UDim2.new(0, 480, 0, 360)

MainFrame.Visible = true

ToggleHubBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame:TweenSize(
            UDim2.new(0, 0, 0, 0),
            Enum.EasingDirection.In,
            Enum.EasingStyle.Back,
            0.25,
            true,
            function()
                MainFrame.Visible = false
            end
        )
    else
        MainFrame.Visible = true

        MainFrame:TweenSize(
            OriginalSize,
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Back,
            0.25,
            true
        )
    end
end)

--// =========================================================
--// CHARACTER PROPERTY LOOP
--// =========================================================

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local character =
                LocalPlayer.Character

            local humanoid =
                character
                and character:FindFirstChildOfClass(
                    "Humanoid"
                )

            if humanoid then
                if _G.AutoSpeedActive then
                    humanoid.WalkSpeed =
                        _G.CustomSpeed
                end

                if _G.AutoJumpActive then
                    humanoid.JumpPower =
                        _G.CustomJump
                end
            end
        end)
    end
end)

--// =========================================================
--// AUTO EQUIPMENT
--// =========================================================

task.spawn(function()
    while task.wait(1.5) do
        if _G.AutoBuyEquipment then
            pcall(function()
                local remoteFolder =
                    ReplicatedStorage:FindFirstChild(
                        "Remote"
                    )

                local equipmentFolder =
                    remoteFolder
                    and remoteFolder:FindFirstChild(
                        "Equipment"
                    )

                local remote =
                    equipmentFolder
                    and equipmentFolder:FindFirstChild(
                        "PurchaseWithWin"
                    )

                if not remote then
                    return
                end

                local configFolder =
                    ReplicatedStorage:FindFirstChild(
                        "EquipmentConfigs"
                    )
                    or ReplicatedStorage:FindFirstChild(
                        "Equipments"
                    )

                if not configFolder then
                    return
                end

                local highestItemIndex =
                    #configFolder:GetChildren()

                if highestItemIndex < 1 then
                    return
                end

                if remote:IsA("RemoteFunction") then
                    pcall(function()
                        remote:InvokeServer(
                            highestItemIndex
                        )
                    end)
                elseif remote:IsA("RemoteEvent") then
                    pcall(function()
                        remote:FireServer(
                            highestItemIndex
                        )
                    end)
                end
            end)
        end
    end
end)

--// =========================================================
--// AUTO REWARD TELEPORT
--// =========================================================

task.spawn(function()
    while task.wait(
        math.max(
            tonumber(_G.WarpDelay) or 0.5,
            0.1
        )
    ) do

        if
            _G.AutoTeleport
            and _G.TargetReward
            and not _G.AutoAFKRun
        then

            pcall(function()
                local rewardPath =
                    workspace:FindFirstChild(
                        "Reward"
                    )

                if not rewardPath then
                    return
                end

                local normalPath =
                    rewardPath:FindFirstChild(
                        "Normal"
                    )

                if not normalPath then
                    return
                end

                local target =
                    normalPath:FindFirstChild(
                        _G.TargetReward
                    )

                local character =
                    LocalPlayer.Character

                local hrp =
                    character
                    and character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if not target or not hrp then
                    return
                end

                local targetPart = nil

                if target:IsA("BasePart") then
                    targetPart = target
                elseif target:IsA("Model") then
                    targetPart =
                        target.PrimaryPart
                        or target:FindFirstChildWhichIsA(
                            "BasePart"
                        )
                end

                if targetPart then
                    hrp.CFrame =
                        targetPart.CFrame
                end
            end)
        end
    end
end)

--// =========================================================
--// AUTO AFK
--// =========================================================

task.spawn(function()
    while task.wait(1) do
        if _G.AutoAFKRun then
            pcall(function()
                local character =
                    LocalPlayer.Character

                local hrp =
                    character
                    and character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if not hrp then
                    return
                end

                local currentSpeed = 0

                for _, object in ipairs(
                    LocalPlayer:GetDescendants()
                ) do

                    if
                        object:IsA("NumberValue")
                        or object:IsA("IntValue")
                    then

                        local lowerName =
                            string.lower(
                                object.Name
                            )

                        if
                            string.find(
                                lowerName,
                                "speed"
                            )
                            or string.find(
                                lowerName,
                                "power"
                            )
                        then

                            currentSpeed =
                                object.Value

                            break
                        end
                    end
                end

                local targetArea

                if currentSpeed >= 50000 then
                    targetArea =
                        workspace:FindFirstChild(
                            "AFK Area_World2"
                        )
                else
                    targetArea =
                        workspace:FindFirstChild(
                            "AFK Area"
                        )
                end

                if not targetArea then
                    return
                end

                local targetPart = nil

                if targetArea:IsA("BasePart") then
                    targetPart = targetArea
                elseif targetArea:IsA("Model") then
                    targetPart =
                        targetArea.PrimaryPart
                        or targetArea:FindFirstChildWhichIsA(
                            "BasePart"
                        )
                end

                if targetPart then
                    hrp.CFrame =
                        targetPart.CFrame
                end
            end)
        end
    end
end)

--// =========================================================
--// AUTO REBIRTH
--// =========================================================

task.spawn(function()
    while task.wait(1) do
        if _G.AutoRebirth then
            pcall(function()
                local remoteFolder =
                    ReplicatedStorage:FindFirstChild(
                        "Remote"
                    )

                local rebirthFolder =
                    remoteFolder
                    and remoteFolder:FindFirstChild(
                        "Rebirth"
                    )

                local remote =
                    rebirthFolder
                    and rebirthFolder:FindFirstChild(
                        "RequestRebirth"
                    )

                if not remote then
                    return
                end

                if remote:IsA("RemoteFunction") then
                    remote:InvokeServer()
                elseif remote:IsA("RemoteEvent") then
                    remote:FireServer()
                end
            end)
        end
    end
end)

--// =========================================================
--// DONE
--// =========================================================

print("[InfinityHub] Loaded successfully.")
