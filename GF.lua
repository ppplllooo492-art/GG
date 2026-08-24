-- สร้างและบันทึกระบบจดจำการตั้งค่า (Auto Save Settings)

local HttpService = game:GetService("HttpService")
local filename = "InfinityHub_Configs.json"

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
    AutoBuyEquipment = false
}

local function SaveData()
    if writefile then
        pcall(function()
            writefile(filename, HttpService:JSONEncode(_G.Configs))
        end)
    end
end

local function LoadData()
    if readfile and isfile and isfile(filename) then
        pcall(function()
            local decoded = HttpService:JSONDecode(readfile(filename))

            for k, v in pairs(decoded) do
                _G.Configs[k] = v
            end
        end)
    end
end

LoadData()

-- ย้ายค่า Configs ไปที่ตัวแปรระบบเดิมเพื่อให้สอดคล้องกัน
_G.AutoTeleport = _G.Configs.AutoTeleport
_G.TargetReward = _G.Configs.TargetReward == "None" and nil or _G.Configs.TargetReward
_G.WarpDelay = _G.Configs.WarpDelay
_G.AutoAFKRun = _G.Configs.AutoAFKRun
_G.AutoRebirth = _G.Configs.AutoRebirth
_G.CustomSpeed = _G.Configs.CustomSpeed
_G.AutoSpeedActive = _G.Configs.AutoSpeedActive
_G.CustomJump = _G.Configs.CustomJump
_G.AutoJumpActive = _G.Configs.AutoJumpActive
_G.AutoBuyEquipment = _G.Configs.AutoBuyEquipment

-- ---- ANTI AFK ----
for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
    v:Disable()
end

-- ---- AUTO RECONNECT & AUTO RUN SCRIPT WHEN DISCONNECTED ----
if queue_on_teleport then
    queue_on_teleport([[
        repeat
            task.wait()
        until game:IsLoaded()

        local executor = (syn and syn.request and "Synapse")
            or (secure_load and "Sentinel")
            or "Delta"

        if loadstring then
            pcall(function()
                -- กรณีที่ใช้สคริปต์นี้แบบดึงผ่านลิงก์ให้วาง Loadstring
                -- สคริปต์หลักของคุณตรงนี้
            end)
        end
    ]])
end

-- ตรวจสอบหน้าจอตัดการเชื่อมต่อ (Error Gui)
-- เพื่อกด Reconnect เข้าเกมใหม่ทันที
task.spawn(function()
    local GuiService = game:GetService("GuiService")
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")

    GuiService.ErrorMessageChanged:Connect(function()
        task.wait(1)

        pcall(function()
            if #Players:GetPlayers() <= 1 then
                TeleportService:Teleport(
                    game.PlaceId,
                    Players.LocalPlayer
                )
            else
                TeleportService:TeleportToPlaceInstance(
                    game.PlaceId,
                    game.JobId,
                    Players.LocalPlayer
                )
            end
        end)
    end)
end)

-- สร้างอินเทอร์เฟซหลักทั้งหมด (UI Setup)

local ScreenGui = Instance.new("ScreenGui")
local ToggleHubBtn = Instance.new("TextButton")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local NavigationBar = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

local RewardTabBtn = Instance.new("TextButton")
local AFKTabBtn = Instance.new("TextButton")
local RebirthTabBtn = Instance.new("TextButton")
local PlayerTabBtn = Instance.new("TextButton")
local ShopTabBtn = Instance.new("TextButton")

local PagesFolder = Instance.new("Folder")
local RewardPage = Instance.new("ScrollingFrame")
local AFKPage = Instance.new("ScrollingFrame")
local RebirthPage = Instance.new("ScrollingFrame")
local PlayerPage = Instance.new("ScrollingFrame")
local ShopPage = Instance.new("ScrollingFrame")

ScreenGui.Name = "CustomModernHubV7"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

ToggleHubBtn.Name = "ToggleHubBtn"
ToggleHubBtn.Parent = ScreenGui
ToggleHubBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleHubBtn.BorderSizePixel = 0
ToggleHubBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleHubBtn.Size = UDim2.new(0, 70, 0, 30)
ToggleHubBtn.Font = Enum.Font.GothamBold
ToggleHubBtn.Text = "OPEN UI"
ToggleHubBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleHubBtn.TextSize = 12
ToggleHubBtn.Active = true
ToggleHubBtn.Draggable = true

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 360, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
TitleLabel.BorderSizePixel = 0
TitleLabel.Size = UDim2.new(1, 0, 0, 45)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "   INFINITY HUB V7"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

NavigationBar.Name = "NavigationBar"
NavigationBar.Parent = MainFrame
NavigationBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NavigationBar.BorderSizePixel = 0
NavigationBar.Position = UDim2.new(0, 0, 0, 45)
NavigationBar.Size = UDim2.new(0, 100, 1, -45)

UIListLayout.Parent = NavigationBar
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local tabs = {
    {Btn = RewardTabBtn, Text = "Auto Reward"},
    {Btn = AFKTabBtn, Text = "Auto AFK"},
    {Btn = RebirthTabBtn, Text = "Auto Rebirth"},
    {Btn = PlayerTabBtn, Text = "Local Player"},
    {Btn = ShopTabBtn, Text = "Auto Buy Equip"}
}

for i, tab in ipairs(tabs) do
    tab.Btn.Name = tab.Btn.ClassName .. "_" .. tab.Text
    tab.Btn.Parent = NavigationBar
    tab.Btn.BackgroundColor3 =
        i == 1
        and Color3.fromRGB(30, 30, 30)
        or Color3.fromRGB(25, 25, 25)

    tab.Btn.BorderSizePixel = 0
    tab.Btn.Size = UDim2.new(1, 0, 0, 40)
    tab.Btn.Font = Enum.Font.Gotham
    tab.Btn.Text = tab.Text
    tab.Btn.TextColor3 =
        i == 1
        and Color3.fromRGB(255, 255, 255)
        or Color3.fromRGB(150, 150, 150)

    tab.Btn.TextSize = 12
end

PagesFolder.Name = "Pages"
PagesFolder.Parent = MainFrame

local function configurePage(page, name, visible)
    page.Name = name
    page.Parent = PagesFolder
    page.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    page.BorderSizePixel = 0
    page.Position = UDim2.new(0, 110, 0, 55)
    page.Size = UDim2.new(0, 240, 0, 350)
    page.CanvasSize = UDim2.new(0, 0, 0, 450)
    page.ScrollBarThickness = 2
    page.Visible = visible
end

configurePage(RewardPage, "RewardPage", true)
configurePage(AFKPage, "AFKPage", false)
configurePage(RebirthPage, "RebirthPage", false)
configurePage(PlayerPage, "PlayerPage", false)
configurePage(ShopPage, "ShopPage", false)

-- ส่วนประกอบหน้า LOCAL PLAYER

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Parent = PlayerPage
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Size = UDim2.new(0.95, 0, 0, 25)
SpeedTitle.Font = Enum.Font.GothamBold
SpeedTitle.Text = "WalkSpeed Setting"
SpeedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTitle.TextSize = 14

local SpeedSliderFrame = Instance.new("Frame")
SpeedSliderFrame.Parent = PlayerPage
SpeedSliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedSliderFrame.BorderSizePixel = 0
SpeedSliderFrame.Position = UDim2.new(0, 0, 0, 30)
SpeedSliderFrame.Size = UDim2.new(0.95, 0, 0, 55)

local SpeedSliderLabel = Instance.new("TextLabel")
SpeedSliderLabel.Parent = SpeedSliderFrame
SpeedSliderLabel.BackgroundTransparency = 1
SpeedSliderLabel.Position = UDim2.new(0, 8, 0, 5)
SpeedSliderLabel.Size = UDim2.new(0.5, 0, 0, 20)
SpeedSliderLabel.Font = Enum.Font.Gotham
SpeedSliderLabel.Text = "Speed Value"
SpeedSliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedSliderLabel.TextSize = 12

local SpeedValueLabel = Instance.new("TextLabel")
SpeedValueLabel.Parent = SpeedSliderFrame
SpeedValueLabel.BackgroundTransparency = 1
SpeedValueLabel.Position = UDim2.new(0.6, 0, 0, 5)
SpeedValueLabel.Size = UDim2.new(0.35, 0, 0, 20)
SpeedValueLabel.Font = Enum.Font.GothamBold
SpeedValueLabel.Text = tostring(_G.CustomSpeed)
SpeedValueLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
SpeedValueLabel.TextSize = 12
SpeedValueLabel.TextXAlignment = Enum.TextXAlignment.Right

local SpeedSliderContainer = Instance.new("Frame")
SpeedSliderContainer.Parent = SpeedSliderFrame
SpeedSliderContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedSliderContainer.BorderSizePixel = 0
SpeedSliderContainer.Position = UDim2.new(0, 8, 0, 32)
SpeedSliderContainer.Size = UDim2.new(0.9, 0, 0, 6)

local SpeedSliderBar = Instance.new("Frame")
SpeedSliderBar.Parent = SpeedSliderContainer
SpeedSliderBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SpeedSliderBar.BorderSizePixel = 0

local speedPercent =
    math.clamp((_G.CustomSpeed - 16) / (1000 - 16), 0, 1)

SpeedSliderBar.Size = UDim2.new(speedPercent, 0, 1, 0)

local SpeedSliderDot = Instance.new("TextButton")
SpeedSliderDot.Parent = SpeedSliderContainer
SpeedSliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedSliderDot.BorderSizePixel = 0
SpeedSliderDot.Position = UDim2.new(speedPercent, -6, 0, -3)
SpeedSliderDot.Size = UDim2.new(0, 12, 0, 12)
SpeedSliderDot.Text = ""

local SpeedToggleFrame = Instance.new("Frame")
SpeedToggleFrame.Parent = PlayerPage
SpeedToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SpeedToggleFrame.BorderSizePixel = 0
SpeedToggleFrame.Position = UDim2.new(0, 0, 0, 90)
SpeedToggleFrame.Size = UDim2.new(0.95, 0, 0, 40)

local SpeedToggleLabel = Instance.new("TextLabel")
SpeedToggleLabel.Parent = SpeedToggleFrame
SpeedToggleLabel.BackgroundTransparency = 1
SpeedToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
SpeedToggleLabel.Font = Enum.Font.Gotham
SpeedToggleLabel.Text = "  Enable Auto Speed"
SpeedToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedToggleLabel.TextSize = 12

local SpeedToggleBtn = Instance.new("TextButton")
SpeedToggleBtn.Parent = SpeedToggleFrame
SpeedToggleBtn.BackgroundColor3 =
    _G.AutoSpeedActive
    and Color3.fromRGB(0, 200, 100)
    or Color3.fromRGB(200, 50, 50)

SpeedToggleBtn.BorderSizePixel = 0
SpeedToggleBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
SpeedToggleBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
SpeedToggleBtn.Font = Enum.Font.GothamBold
SpeedToggleBtn.Text = _G.AutoSpeedActive and "ON" or "OFF"
SpeedToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggleBtn.TextSize = 12

local JumpTitle = Instance.new("TextLabel")
JumpTitle.Parent = PlayerPage
JumpTitle.BackgroundTransparency = 1
JumpTitle.Position = UDim2.new(0, 0, 0, 145)
JumpTitle.Size = UDim2.new(0.95, 0, 0, 25)
JumpTitle.Font = Enum.Font.GothamBold
JumpTitle.Text = "JumpPower Setting"
JumpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpTitle.TextSize = 14

local JumpSliderFrame = Instance.new("Frame")
JumpSliderFrame.Parent = PlayerPage
JumpSliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
JumpSliderFrame.BorderSizePixel = 0
JumpSliderFrame.Position = UDim2.new(0, 0, 0, 175)
JumpSliderFrame.Size = UDim2.new(0.95, 0, 0, 55)

local JumpSliderLabel = Instance.new("TextLabel")
JumpSliderLabel.Parent = JumpSliderFrame
JumpSliderLabel.BackgroundTransparency = 1
JumpSliderLabel.Position = UDim2.new(0, 8, 0, 5)
JumpSliderLabel.Size = UDim2.new(0.5, 0, 0, 20)
JumpSliderLabel.Font = Enum.Font.Gotham
JumpSliderLabel.Text = "Jump Value"
JumpSliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
JumpSliderLabel.TextSize = 12

local JumpValueLabel = Instance.new("TextLabel")
JumpValueLabel.Parent = JumpSliderFrame
JumpValueLabel.BackgroundTransparency = 1
JumpValueLabel.Position = UDim2.new(0.6, 0, 0, 5)
JumpValueLabel.Size = UDim2.new(0.35, 0, 0, 20)
JumpValueLabel.Font = Enum.Font.GothamBold
JumpValueLabel.Text = tostring(_G.CustomJump)
JumpValueLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
JumpValueLabel.TextSize = 12
JumpValueLabel.TextXAlignment = Enum.TextXAlignment.Right

local JumpSliderContainer = Instance.new("Frame")
JumpSliderContainer.Parent = JumpSliderFrame
JumpSliderContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
JumpSliderContainer.BorderSizePixel = 0
JumpSliderContainer.Position = UDim2.new(0, 8, 0, 32)
JumpSliderContainer.Size = UDim2.new(0.9, 0, 0, 6)

local JumpSliderBar = Instance.new("Frame")
JumpSliderBar.Parent = JumpSliderContainer
JumpSliderBar.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
JumpSliderBar.BorderSizePixel = 0

local jumpPercent =
    math.clamp((_G.CustomJump - 50) / (1000 - 50), 0, 1)

JumpSliderBar.Size = UDim2.new(jumpPercent, 0, 1, 0)

local JumpSliderDot = Instance.new("TextButton")
JumpSliderDot.Parent = JumpSliderContainer
JumpSliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
JumpSliderDot.BorderSizePixel = 0
JumpSliderDot.Position = UDim2.new(jumpPercent, -6, 0, -3)
JumpSliderDot.Size = UDim2.new(0, 12, 0, 12)
JumpSliderDot.Text = ""

local JumpToggleFrame = Instance.new("Frame")
JumpToggleFrame.Parent = PlayerPage
JumpToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
JumpToggleFrame.BorderSizePixel = 0
JumpToggleFrame.Position = UDim2.new(0, 0, 0, 235)
JumpToggleFrame.Size = UDim2.new(0.95, 0, 0, 40)

local JumpToggleLabel = Instance.new("TextLabel")
JumpToggleLabel.Parent = JumpToggleFrame
JumpToggleLabel.BackgroundTransparency = 1
JumpToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
JumpToggleLabel.Font = Enum.Font.Gotham
JumpToggleLabel.Text = "  Enable Auto Jump"
JumpToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
JumpToggleLabel.TextSize = 12

local JumpToggleBtn = Instance.new("TextButton")
JumpToggleBtn.Parent = JumpToggleFrame
JumpToggleBtn.BackgroundColor3 =
    _G.AutoJumpActive
    and Color3.fromRGB(0, 200, 100)
    or Color3.fromRGB(200, 50, 50)

JumpToggleBtn.BorderSizePixel = 0
JumpToggleBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
JumpToggleBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
JumpToggleBtn.Font = Enum.Font.GothamBold
JumpToggleBtn.Text = _G.AutoJumpActive and "ON" or "OFF"
JumpToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpToggleBtn.TextSize = 12

-- ส่วนประกอบหน้า REWARD

local DropdownBtn = Instance.new("TextButton")
DropdownBtn.Parent = RewardPage
DropdownBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DropdownBtn.BorderSizePixel = 0
DropdownBtn.Size = UDim2.new(0.95, 0, 0, 35)
DropdownBtn.Font = Enum.Font.Gotham
DropdownBtn.Text =
    _G.TargetReward
    and ("Selected: Reward " .. _G.TargetReward)
    or "Select Reward: None"

DropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownBtn.TextSize = 14

local DropdownList = Instance.new("ScrollingFrame")
DropdownList.Parent = RewardPage
DropdownList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
DropdownList.BorderSizePixel = 0
DropdownList.Position = UDim2.new(0, 0, 0, 40)
DropdownList.Size = UDim2.new(0.95, 0, 0, 120)
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 430)
DropdownList.Visible = false
DropdownList.ZIndex = 5

local UIListLayout_Drop = Instance.new("UIListLayout")
UIListLayout_Drop.Parent = DropdownList
UIListLayout_Drop.SortOrder = Enum.SortOrder.LayoutOrder

local rewardsList = {
    "1", "2", "3", "5", "6", "7",
    "8", "9", "10", "11", "12", "13", "14"
}

for _, name in ipairs(rewardsList) do
    local ItemBtn = Instance.new("TextButton")

    ItemBtn.Parent = DropdownList
    ItemBtn.Size = UDim2.new(1, 0, 0, 30)
    ItemBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ItemBtn.BorderSizePixel = 0
    ItemBtn.Font = Enum.Font.Gotham
    ItemBtn.Text = "Reward " .. name
    ItemBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    ItemBtn.TextSize = 13
    ItemBtn.ZIndex = 6

    ItemBtn.MouseButton1Click:Connect(function()
        _G.TargetReward = name
        _G.Configs.TargetReward = name

        SaveData()

        DropdownBtn.Text = "Selected: Reward " .. name
        DropdownList.Visible = false
    end)
end

local SliderFrame = Instance.new("Frame")
SliderFrame.Parent = RewardPage
SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SliderFrame.BorderSizePixel = 0
SliderFrame.Position = UDim2.new(0, 0, 0, 180)
SliderFrame.Size = UDim2.new(0.95, 0, 0, 55)

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Parent = SliderFrame
SliderLabel.BackgroundTransparency = 1
SliderLabel.Position = UDim2.new(0, 8, 0, 5)
SliderLabel.Size = UDim2.new(0.6, 0, 0, 20)
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.Text = "Warp Delay (Seconds)"
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SliderLabel.TextSize = 12

local SliderValueLabel = Instance.new("TextLabel")
SliderValueLabel.Parent = SliderFrame
SliderValueLabel.BackgroundTransparency = 1
SliderValueLabel.Position = UDim2.new(0.6, 0, 0, 5)
SliderValueLabel.Size = UDim2.new(0.35, 0, 0, 20)
SliderValueLabel.Font = Enum.Font.GothamBold
SliderValueLabel.Text = tostring(_G.WarpDelay) .. "s"
SliderValueLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
SliderValueLabel.TextSize = 12
SliderValueLabel.TextXAlignment = Enum.TextXAlignment.Right

local SliderContainer = Instance.new("Frame")
SliderContainer.Parent = SliderFrame
SliderContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SliderContainer.BorderSizePixel = 0
SliderContainer.Position = UDim2.new(0, 8, 0, 32)
SliderContainer.Size = UDim2.new(0.9, 0, 0, 6)

local SliderBar = Instance.new("Frame")
SliderBar.Parent = SliderContainer
SliderBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SliderBar.BorderSizePixel = 0

local delayPercent =
    math.clamp((_G.WarpDelay - 0.1) / (2.0 - 0.1), 0, 1)

SliderBar.Size = UDim2.new(delayPercent, 0, 1, 0)

local SliderDot = Instance.new("TextButton")
SliderDot.Parent = SliderContainer
SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderDot.BorderSizePixel = 0
SliderDot.Position = UDim2.new(delayPercent, -6, 0, -3)
SliderDot.Size = UDim2.new(0, 12, 0, 12)
SliderDot.Text = ""

local ToggleFrame = Instance.new("Frame")
ToggleFrame.Parent = RewardPage
ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleFrame.BorderSizePixel = 0
ToggleFrame.Position = UDim2.new(0, 0, 0, 250)
ToggleFrame.Size = UDim2.new(0.95, 0, 0, 45)

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Parent = ToggleFrame
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
ToggleLabel.Font = Enum.Font.Gotham
ToggleLabel.Text = "  Reward Teleport"
ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleLabel.TextSize = 14

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ToggleFrame
ToggleBtn.BackgroundColor3 =
    _G.AutoTeleport
    and Color3.fromRGB(0, 200, 100)
    or Color3.fromRGB(200, 50, 50)

ToggleBtn.BorderSizePixel = 0
ToggleBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
ToggleBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = _G.AutoTeleport and "ON" or "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 12

-- ส่วนประกอบหน้า AFK และหน้า REBIRTH

local AFKTitle = Instance.new("TextLabel")
AFKTitle.Parent = AFKPage
AFKTitle.BackgroundTransparency = 1
AFKTitle.Size = UDim2.new(0.95, 0, 0, 30)
AFKTitle.Font = Enum.Font.GothamBold
AFKTitle.Text = "Auto Treadmill Speed Farm"
AFKTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AFKTitle.TextSize = 14

local AFKToggleFrame = Instance.new("Frame")
AFKToggleFrame.Parent = AFKPage
AFKToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
AFKToggleFrame.BorderSizePixel = 0
AFKToggleFrame.Position = UDim2.new(0, 0, 0, 40)
AFKToggleFrame.Size = UDim2.new(0.95, 0, 0, 45)

local AFKToggleLabel = Instance.new("TextLabel")
AFKToggleLabel.Parent = AFKToggleFrame
AFKToggleLabel.BackgroundTransparency = 1
AFKToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
AFKToggleLabel.Font = Enum.Font.Gotham
AFKToggleLabel.Text = "  Smart Auto AFK"
AFKToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
AFKToggleLabel.TextSize = 14

local AFKToggleBtn = Instance.new("TextButton")
AFKToggleBtn.Parent = AFKToggleFrame
AFKToggleBtn.BackgroundColor3 =
    _G.AutoAFKRun
    and Color3.fromRGB(0, 200, 100)
    or Color3.fromRGB(200, 50, 50)

AFKToggleBtn.BorderSizePixel = 0
AFKToggleBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
AFKToggleBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
AFKToggleBtn.Font = Enum.Font.GothamBold
AFKToggleBtn.Text = _G.AutoAFKRun and "ON" or "OFF"
AFKToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AFKToggleBtn.TextSize = 12

local RebirthTitle = Instance.new("TextLabel")
RebirthTitle.Parent = RebirthPage
RebirthTitle.BackgroundTransparency = 1
RebirthTitle.Size = UDim2.new(0.95, 0, 0, 30)
RebirthTitle.Font = Enum.Font.GothamBold
RebirthTitle.Text = "Auto Rebirth System"
RebirthTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
RebirthTitle.TextSize = 14

local RebirthToggleFrame = Instance.new("Frame")
RebirthToggleFrame.Parent = RebirthPage
RebirthToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
RebirthToggleFrame.BorderSizePixel = 0
RebirthToggleFrame.Position = UDim2.new(0, 0, 0, 40)
RebirthToggleFrame.Size = UDim2.new(0.95, 0, 0, 45)

local RebirthToggleLabel = Instance.new("TextLabel")
RebirthToggleLabel.Parent = RebirthToggleFrame
RebirthToggleLabel.BackgroundTransparency = 1
RebirthToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
RebirthToggleLabel.Font = Enum.Font.Gotham
RebirthToggleLabel.Text = "  Auto Rebirth (Remote)"
RebirthToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
RebirthToggleLabel.TextSize = 14

local RebirthToggleBtn = Instance.new("TextButton")
RebirthToggleBtn.Parent = RebirthToggleFrame
RebirthToggleBtn.BackgroundColor3 =
    _G.AutoRebirth
    and Color3.fromRGB(0, 200, 100)
    or Color3.fromRGB(200, 50, 50)

RebirthToggleBtn.BorderSizePixel = 0
RebirthToggleBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
RebirthToggleBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
RebirthToggleBtn.Font = Enum.Font.GothamBold
RebirthToggleBtn.Text = _G.AutoRebirth and "ON" or "OFF"
RebirthToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RebirthToggleBtn.TextSize = 12

-- ส่วนประกอบหน้า SHOP

local ShopTitle = Instance.new("TextLabel")
ShopTitle.Parent = ShopPage
ShopTitle.BackgroundTransparency = 1
ShopTitle.Size = UDim2.new(0.95, 0, 0, 30)
ShopTitle.Font = Enum.Font.GothamBold
ShopTitle.Text = "Smart Auto Equipment Buy"
ShopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ShopTitle.TextSize = 14

local ShopToggleFrame = Instance.new("Frame")
ShopToggleFrame.Parent = ShopPage
ShopToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ShopToggleFrame.BorderSizePixel = 0
ShopToggleFrame.Position = UDim2.new(0, 0, 0, 40)
ShopToggleFrame.Size = UDim2.new(0.95, 0, 0, 45)

local ShopToggleLabel = Instance.new("TextLabel")
ShopToggleLabel.Parent = ShopToggleFrame
ShopToggleLabel.BackgroundTransparency = 1
ShopToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
ShopToggleLabel.Font = Enum.Font.Gotham
ShopToggleLabel.Text = "  Auto Buy Highest Items"
ShopToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ShopToggleLabel.TextSize = 14

local ShopToggleBtn = Instance.new("TextButton")
ShopToggleBtn.Parent = ShopToggleFrame
ShopToggleBtn.BackgroundColor3 =
    _G.AutoBuyEquipment
    and Color3.fromRGB(0, 200, 100)
    or Color3.fromRGB(200, 50, 50)

ShopToggleBtn.BorderSizePixel = 0
ShopToggleBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
ShopToggleBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
ShopToggleBtn.Font = Enum.Font.GothamBold
ShopToggleBtn.Text = _G.AutoBuyEquipment and "ON" or "OFF"
ShopToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShopToggleBtn.TextSize = 12

local ShopDescLabel = Instance.new("TextLabel")
ShopDescLabel.Parent = ShopPage
ShopDescLabel.BackgroundTransparency = 1
ShopDescLabel.Position = UDim2.new(0, 0, 0, 95)
ShopDescLabel.Size = UDim2.new(0.95, 0, 0, 60)
ShopDescLabel.Font = Enum.Font.Gotham
ShopDescLabel.Text =
    "ระบบจะทำการแสกนหาไอเทม ID สูงสุดที่ระบบร้านค้าของเกมมีขายในปัจจุบันโดยอัตโนมัติ เพื่อยิงสั่งซื้อเลเวลสูงสุดให้คุณเองโดยไม่ต้องแก้ไขโค้ดเมื่อมีของใหม่เพิ่มเข้ามา"

ShopDescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
ShopDescLabel.TextSize = 11
ShopDescLabel.TextWrapped = true
ShopDescLabel.TextXAlignment = Enum.TextXAlignment.Left

-- การทำงานปุ่มกดและระเบียบแท็บ

local function switchTab(activePage, activeBtn)
    RewardPage.Visible = false
    AFKPage.Visible = false
    RebirthPage.Visible = false
    PlayerPage.Visible = false
    ShopPage.Visible = false

    RewardTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    RewardTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)

    AFKTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    AFKTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)

    RebirthTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    RebirthTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)

    PlayerTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    PlayerTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)

    ShopTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ShopTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)

    activePage.Visible = true
    activeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    activeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end

RewardTabBtn.MouseButton1Click:Connect(function()
    switchTab(RewardPage, RewardTabBtn)
end)

AFKTabBtn.MouseButton1Click:Connect(function()
    switchTab(AFKPage, AFKTabBtn)
end)

RebirthTabBtn.MouseButton1Click:Connect(function()
    switchTab(RebirthPage, RebirthTabBtn)
end)

PlayerTabBtn.MouseButton1Click:Connect(function()
    switchTab(PlayerPage, PlayerTabBtn)
end)

ShopTabBtn.MouseButton1Click:Connect(function()
    switchTab(ShopPage, ShopTabBtn)
end)

ToggleHubBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible

    ToggleHubBtn.Text =
        MainFrame.Visible
        and "CLOSE UI"
        or "OPEN UI"

    ToggleHubBtn.BackgroundColor3 =
        MainFrame.Visible
        and Color3.fromRGB(200, 50, 50)
        or Color3.fromRGB(0, 170, 255)
end)

local UserInputService = game:GetService("UserInputService")

local dragData = {
    [SpeedSliderDot] = false,
    [JumpSliderDot] = false,
    [SliderDot] = false
}

local function handleSliderLogic(
    dot,
    bar,
    container,
    label,
    minVal,
    maxVal,
    varName,
    isTime
)
    dot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragData[dot] = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragData[dot]
            and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            ) then

            local mouseX =
                input.Position.X - container.AbsolutePosition.X

            local percentage =
                math.clamp(
                    mouseX / container.AbsoluteSize.X,
                    0,
                    1
                )

            dot.Position =
                UDim2.new(percentage, -6, 0, -3)

            bar.Size =
                UDim2.new(percentage, 0, 1, 0)

            local rawValue =
                minVal + (percentage * (maxVal - minVal))

            _G[varName] =
                isTime
                and (math.round(rawValue * 10) / 10)
                or math.round(rawValue)

            _G.Configs[varName] = _G[varName]

            SaveData()

            label.Text =
                tostring(_G[varName])
                .. (isTime and "s" or "")
        end
    end)
end

handleSliderLogic(
    SpeedSliderDot,
    SpeedSliderBar,
    SpeedSliderContainer,
    SpeedValueLabel,
    16,
    1000,
    "CustomSpeed",
    false
)

handleSliderLogic(
    JumpSliderDot,
    JumpSliderBar,
    JumpSliderContainer,
    JumpValueLabel,
    50,
    1000,
    "CustomJump",
    false
)

handleSliderLogic(
    SliderDot,
    SliderBar,
    SliderContainer,
    SliderValueLabel,
    0.1,
    2.0,
    "WarpDelay",
    true
)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        for k in pairs(dragData) do
            dragData[k] = false
        end
    end
end)

-- ฟังก์ชันจัดการสวิตช์เปิด/ปิด + บันทึกค่าลงไฟล์

SpeedToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoSpeedActive = not _G.AutoSpeedActive
    _G.Configs.AutoSpeedActive = _G.AutoSpeedActive

    SaveData()

    SpeedToggleBtn.Text =
        _G.AutoSpeedActive and "ON" or "OFF"

    SpeedToggleBtn.BackgroundColor3 =
        _G.AutoSpeedActive
        and Color3.fromRGB(0, 200, 100)
        or Color3.fromRGB(200, 50, 50)
end)

JumpToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoJumpActive = not _G.AutoJumpActive
    _G.Configs.AutoJumpActive = _G.AutoJumpActive

    SaveData()

    JumpToggleBtn.Text =
        _G.AutoJumpActive and "ON" or "OFF"

    JumpToggleBtn.BackgroundColor3 =
        _G.AutoJumpActive
        and Color3.fromRGB(0, 200, 100)
        or Color3.fromRGB(200, 50, 50)
end)

ToggleBtn.MouseButton1Click:Connect(function()
    if not _G.TargetReward then
        return
    end

    _G.AutoTeleport = not _G.AutoTeleport
    _G.Configs.AutoTeleport = _G.AutoTeleport

    SaveData()

    ToggleBtn.Text =
        _G.AutoTeleport and "ON" or "OFF"

    ToggleBtn.BackgroundColor3 =
        _G.AutoTeleport
        and Color3.fromRGB(0, 200, 100)
        or Color3.fromRGB(200, 50, 50)
end)

AFKToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoAFKRun = not _G.AutoAFKRun
    _G.Configs.AutoAFKRun = _G.AutoAFKRun

    SaveData()

    AFKToggleBtn.Text =
        _G.AutoAFKRun and "ON" or "OFF"

    AFKToggleBtn.BackgroundColor3 =
        _G.AutoAFKRun
        and Color3.fromRGB(0, 200, 100)
        or Color3.fromRGB(200, 50, 50)
end)

RebirthToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoRebirth = not _G.AutoRebirth
    _G.Configs.AutoRebirth = _G.AutoRebirth

    SaveData()

    RebirthToggleBtn.Text =
        _G.AutoRebirth and "ON" or "OFF"

    RebirthToggleBtn.BackgroundColor3 =
        _G.AutoRebirth
        and Color3.fromRGB(0, 200, 100)
        or Color3.fromRGB(200, 50, 50)
end)

ShopToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoBuyEquipment = not _G.AutoBuyEquipment
    _G.Configs.AutoBuyEquipment = _G.AutoBuyEquipment

    SaveData()

    ShopToggleBtn.Text =
        _G.AutoBuyEquipment and "ON" or "OFF"

    ShopToggleBtn.BackgroundColor3 =
        _G.AutoBuyEquipment
        and Color3.fromRGB(0, 200, 100)
        or Color3.fromRGB(200, 50, 50)
end)

DropdownBtn.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
end)

-- ลูปการทำงานเบื้องหลังระบบผู้เล่นและฟาร์มออโต้ทั้งหมด

task.spawn(function()
    while true do
        task.wait(0.1)

        pcall(function()
            local humanoid =
                game.Players.LocalPlayer.Character
                and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")

            if humanoid then
                if _G.AutoSpeedActive then
                    humanoid.WalkSpeed = _G.CustomSpeed
                end

                if _G.AutoJumpActive then
                    humanoid.JumpPower = _G.CustomJump
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(1.5)

        if _G.AutoBuyEquipment then
            pcall(function()
                local replicatedStorage =
                    game:GetService("ReplicatedStorage")

                local remote =
                    replicatedStorage
                    :WaitForChild("Remote")
                    :WaitForChild("Equipment")
                    :WaitForChild("PurchaseWithWin")

                if remote then
                    local highestItemIndex = 3

                    local configFolder =
                        replicatedStorage:FindFirstChild("EquipmentConfigs")
                        or replicatedStorage:FindFirstChild("Equipments")

                    if configFolder then
                        local count = #configFolder:GetChildren()

                        if count > highestItemIndex then
                            highestItemIndex = count
                        end
                    else
                        for testIndex = highestItemIndex + 1,
                            highestItemIndex + 10 do

                            highestItemIndex = testIndex
                        end
                    end

                    for currentIndex = highestItemIndex, 1, -1 do
                        local args = {
                            currentIndex
                        }

                        remote:InvokeServer(unpack(args))
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(_G.WarpDelay)

        if _G.AutoTeleport
            and _G.TargetReward
            and not _G.AutoAFKRun then

            pcall(function()
                local target =
                    workspace.Reward.Normal:FindFirstChild(
                        _G.TargetReward
                    )

                local hrp =
                    game.Players.LocalPlayer.Character
                    and game.Players.LocalPlayer.Character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if hrp and target then
                    hrp.CFrame =
                        target.PrimaryPart
                        and target.PrimaryPart.CFrame
                        or target.CFrame
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)

        if _G.AutoAFKRun then
            pcall(function()
                local character =
                    game.Players.LocalPlayer.Character

                local hrp =
                    character
                    and character:FindFirstChild("HumanoidRootPart")

                if hrp then
                    local currentSpeed = 0

                    for _, v in pairs(
                        game.Players.LocalPlayer:GetDescendants()
                    ) do
                        if (v:IsA("NumberValue") or v:IsA("IntValue"))
                            and (
                                string.find(
                                    string.lower(v.Name),
                                    "speed"
                                )
                                or string.find(
                                    string.lower(v.Name),
                                    "power"
                                )
                            ) then

                            currentSpeed = v.Value
                            break
                        end
                    end

                    local targetArea =
                        currentSpeed >= 50000
                        and workspace:FindFirstChild("AFK Area_World2")
                        or workspace:FindFirstChild("AFK Area")

                    if targetArea then
                        hrp.CFrame =
                            targetArea.PrimaryPart
                            and targetArea.PrimaryPart.CFrame
                            or targetArea.CFrame
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1)

        if _G.AutoRebirth then
            pcall(function()
                local remote =
                    game:GetService("ReplicatedStorage")
                    :WaitForChild("Remote")
                    :WaitForChild("Rebirth")
                    :WaitForChild("RequestRebirth")

                if remote:IsA("RemoteFunction") then
                    remote:InvokeServer()
                else
                    remote:FireServer()
                end
            end)
        end
    end
end)
