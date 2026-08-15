--// GG.GR // SEPARATION EDITION v5 - Fixed
--// Roblox Lua / LocalScript หรือ executor environment ที่รองรับ Drawing + getgenv()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

getgenv().ModSettings = getgenv().ModSettings or {
    CamlockEnabled = false,
    WallCheck = true,
    Smoothness = 90,
    FOVSize = 150,
    AimPart = "Head",

    TeamCheck = false,

    ESPBoxEnabled = true,
    ESPTracerEnabled = true,
    ESPNameEnabled = true,

    SpeedEnabled = false,
    WalkSpeedVal = 25,

    JumpEnabled = false,
    JumpPowerVal = 100,

    HitboxEnabled = false,
    HitboxHead = 1.5,
    HitboxTorso = 2,

    NoClipEnabled = false,
    InfiniteJump = false,

    TargetType = "Players"
}

local Settings = getgenv().ModSettings

local LockedTarget = nil
local UIHidden = false

local ESP = {}
local Rainbow = Color3.fromRGB(255, 0, 0)
local FOVCircle = nil

local LastCameraCFrame = Camera.CFrame

--==================================================
-- Rainbow
--==================================================

task.spawn(function()
    local h = 0

    while task.wait() do
        h = (h + 1.5) % 360
        Rainbow = Color3.fromHSV(h / 360, 1, 1)
    end
end)

--==================================================
-- FOV Circle
--==================================================

pcall(function()
    FOVCircle = Drawing.new("Circle")

    FOVCircle.Visible = true
    FOVCircle.Filled = false
    FOVCircle.Thickness = 2.5
    FOVCircle.Color = Color3.fromRGB(0, 255, 170)
    FOVCircle.Radius = Settings.FOVSize
    FOVCircle.Position = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )
end)

--==================================================
-- ESP
--==================================================

local function createESP(player)
    if player == LocalPlayer then
        return
    end

    if ESP[player] then
        return
    end

    local success, drawings = pcall(function()
        return {
            Box = Drawing.new("Square"),
            BoxBG = Drawing.new("Square"),
            Tracer = Drawing.new("Line"),
            TracerShadow = Drawing.new("Line"),
            Name = Drawing.new("Text")
        }
    end)

    if not success or not drawings then
        return
    end

    ESP[player] = drawings

    local d = drawings

    pcall(function()
        d.Box.Thickness = 2
        d.Box.Filled = false
        d.Box.Visible = false

        d.BoxBG.Thickness = 1
        d.BoxBG.Filled = true
        d.BoxBG.Transparency = 0.15
        d.BoxBG.Visible = false

        d.TracerShadow.Thickness = 4
        d.TracerShadow.Color = Color3.new(0, 0, 0)
        d.TracerShadow.Visible = false

        d.Tracer.Thickness = 2
        d.Tracer.Visible = false

        d.Name.Size = 14
        d.Name.Center = true
        d.Name.Outline = true
        d.Name.Visible = false
    end)
end

local function removeESP(player)
    if not ESP[player] then
        return
    end

    for _, drawing in pairs(ESP[player]) do
        pcall(function()
            drawing:Remove()
        end)
    end

    ESP[player] = nil
end

for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

--==================================================
-- Remove old GUI
--==================================================

pcall(function()
    local oldGui = LocalPlayer.PlayerGui:FindFirstChild("CyberHudGuiV5")

    if oldGui then
        oldGui:Destroy()
    end
end)

--==================================================
-- ScreenGui
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyberHudGuiV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- Main Frame
--==================================================

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 530, 0, 410)
MainFrame.Position = UDim2.new(0.5, -265, 0.5, -205)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

task.spawn(function()
    while task.wait() do
        if MainStroke.Parent then
            MainStroke.Color = Rainbow
        else
            break
        end
    end
end)

--==================================================
-- Top Bar
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 46)
TopBar.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "❖ GG.GR // SEPARATION EDITION v5"
Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

task.spawn(function()
    while task.wait() do
        if Title.Parent then
            Title.TextColor3 = Rainbow
        else
            break
        end
    end
end)

--==================================================
-- Close Button
--==================================================

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 80)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

--==================================================
-- Tab Bar
--==================================================

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 140, 1, -58)
TabBar.Position = UDim2.new(0, 8, 0, 52)
TabBar.BackgroundColor3 = Color3.fromRGB(11, 11, 16)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 8)
TabBarCorner.Parent = TabBar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -160, 1, -58)
TabContainer.Position = UDim2.new(0, 152, 0, 52)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local Tabs = {}

--==================================================
-- Create Tab
--==================================================

local function CreateTab(name, yPos)
    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(1, -12, 0, 38)
    btn.Position = UDim2.new(0, 6, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    btn.Text = " ❖ " .. name
    btn.TextColor3 = Color3.fromRGB(140, 140, 160)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = TabBar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local page = Instance.new("ScrollingFrame")

    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 360)
    page.ScrollBarThickness = 4
    page.Visible = false
    page.Parent = TabContainer

    local tabData = {
        Btn = btn,
        Page = page
    }

    table.insert(Tabs, tabData)

    btn.MouseButton1Click:Connect(function()
        for _, tab in ipairs(Tabs) do
            tab.Btn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
            tab.Btn.TextColor3 = Color3.fromRGB(140, 140, 160)
            tab.Page.Visible = false
        end

        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
        btn.TextColor3 = Color3.fromRGB(10, 10, 14)
        page.Visible = true
    end)

    return page
end

--==================================================
-- Tabs
--==================================================

local Page1 = CreateTab("Aim Options", 8)
local Page2 = CreateTab("Visuals Only", 52)
local Page3 = CreateTab("Movement", 96)
local Page4 = CreateTab("Hitbox Mod", 140)

if Tabs[1] then
    Tabs[1].Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    Tabs[1].Btn.TextColor3 = Color3.fromRGB(10, 10, 14)
    Tabs[1].Page.Visible = true
end

--==================================================
-- Toggle
--==================================================

local function AddToggle(parent, name, default, y, callback)
    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1, -8, 0, 36)
    button.Position = UDim2.new(0, 4, 0, y)
    button.BackgroundColor3 = default
        and Color3.fromRGB(0, 180, 120)
        or Color3.fromRGB(16, 16, 24)

    button.Text = "  " .. name .. " [ " .. (default and "ON" or "OFF") .. " ]"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 11
    button.Font = Enum.Font.GothamBold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    local state = default

    button.MouseButton1Click:Connect(function()
        state = not state

        button.BackgroundColor3 = state
            and Color3.fromRGB(0, 180, 120)
            or Color3.fromRGB(16, 16, 24)

        button.Text =
            "  " .. name .. " [ " .. (state and "ON" or "OFF") .. " ]"

        callback(state)
    end)

    return button
end

--==================================================
-- Slider
--==================================================

local function AddSlider(parent, name, y, min, max, value, callback)
    local label = Instance.new("TextLabel")

    label.Size = UDim2.new(1, -8, 0, 18)
    label.Position = UDim2.new(0, 4, 0, y)
    label.BackgroundTransparency = 1
    label.Text = "  " .. name .. ": " .. tostring(value)
    label.TextColor3 = Color3.fromRGB(160, 160, 180)
    label.TextSize = 10
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local bar = Instance.new("TextButton")

    bar.Size = UDim2.new(1, -8, 0, 14)
    bar.Position = UDim2.new(0, 4, 0, y + 18)
    bar.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
    bar.Text = ""
    bar.AutoButtonColor = false
    bar.Parent = parent

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")

    fill.Size = UDim2.new(
        math.clamp((value - min) / (max - min), 0, 1),
        0,
        1,
        0
    )

    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

    local dragging = false

    local function updateSlider(inputX)
        local percent = math.clamp(
            (inputX - bar.AbsolutePosition.X) /
                bar.AbsoluteSize.X,
            0,
            1
        )

        local result = min + (percent * (max - min))

        if max - min >= 10 then
            result = math.floor(result)
        else
            result = math.floor(result * 10 + 0.5) / 10
        end

        fill.Size = UDim2.new(percent, 0, 1, 0)

        label.Text =
            "  " .. name .. ": " .. tostring(result)

        callback(result)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            updateSlider(input.Position.X)
        end
    end)

    return {
        Label = label,
        Fill = fill,
        Min = min,
        Max = max,
        Name = name
    }
end

--==================================================
-- Aim Options
--==================================================

AddToggle(
    Page1,
    "Camlock",
    Settings.CamlockEnabled,
    5,
    function(state)
        Settings.CamlockEnabled = state
    end
)

AddToggle(
    Page1,
    "WallCheck",
    Settings.WallCheck,
    45,
    function(state)
        Settings.WallCheck = state
    end
)

AddToggle(
    Page1,
    "Team Check",
    Settings.TeamCheck,
    85,
    function(state)
        Settings.TeamCheck = state
    end
)

--==================================================
-- Target Type
--==================================================

local TargetTypeBtn = Instance.new("TextButton")

TargetTypeBtn.Size = UDim2.new(1, -8, 0, 36)
TargetTypeBtn.Position = UDim2.new(0, 4, 0, 125)
TargetTypeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)

TargetTypeBtn.Text =
    "  TARGET: [ " .. Settings.TargetType:upper() .. " ]"

TargetTypeBtn.TextColor3 = Color3.fromRGB(0, 255, 170)
TargetTypeBtn.TextSize = 11
TargetTypeBtn.Font = Enum.Font.GothamBold
TargetTypeBtn.TextXAlignment = Enum.TextXAlignment.Left
TargetTypeBtn.Parent = Page1

local targetCorner = Instance.new("UICorner")
targetCorner.CornerRadius = UDim.new(0, 6)
targetCorner.Parent = TargetTypeBtn

TargetTypeBtn.MouseButton1Click:Connect(function()
    if Settings.TargetType == "Players" then
        Settings.TargetType = "NPC"
        TargetTypeBtn.Text = "  TARGET: [ NPC / MONSTERS ]"
    else
        Settings.TargetType = "Players"
        TargetTypeBtn.Text = "  TARGET: [ PLAYERS ]"
    end
end)

local S1 = AddSlider(
    Page1,
    "Lock Speed",
    170,
    1,
    100,
    Settings.Smoothness,
    function(value)
        Settings.Smoothness = value
    end
)

local S2 = AddSlider(
    Page1,
    "FOV Circle Size",
    220,
    50,
    400,
    Settings.FOVSize,
    function(value)
        Settings.FOVSize = value

        if FOVCircle then
            FOVCircle.Radius = value
        end
    end
)

--==================================================
-- Visuals
--==================================================

AddToggle(
    Page2,
    "ESP Box",
    Settings.ESPBoxEnabled,
    5,
    function(state)
        Settings.ESPBoxEnabled = state
    end
)

AddToggle(
    Page2,
    "ESP Tracer",
    Settings.ESPTracerEnabled,
    45,
    function(state)
        Settings.ESPTracerEnabled = state
    end
)

AddToggle(
    Page2,
    "ESP Name",
    Settings.ESPNameEnabled,
    85,
    function(state)
        Settings.ESPNameEnabled = state
    end
)

--==================================================
-- Movement
--==================================================

AddToggle(
    Page3,
    "Speed Boost",
    Settings.SpeedEnabled,
    5,
    function(state)
        Settings.SpeedEnabled = state
    end
)

local S3 = AddSlider(
    Page3,
    "WalkSpeed Value",
    45,
    16,
    250,
    Settings.WalkSpeedVal,
    function(value)
        Settings.WalkSpeedVal = value
    end
)

AddToggle(
    Page3,
    "High Jump",
    Settings.JumpEnabled,
    95,
    function(state)
        Settings.JumpEnabled = state
    end
)

local S4 = AddSlider(
    Page3,
    "JumpPower Value",
    135,
    50,
    400,
    Settings.JumpPowerVal,
    function(value)
        Settings.JumpPowerVal = value
    end
)

AddToggle(
    Page3,
    "NoClip",
    Settings.NoClipEnabled,
    185,
    function(state)
        Settings.NoClipEnabled = state
    end
)

AddToggle(
    Page3,
    "Infinite Jump",
    Settings.InfiniteJump,
    225,
    function(state)
        Settings.InfiniteJump = state
    end
)

--==================================================
-- Hitbox
--==================================================

AddToggle(
    Page4,
    "Hitbox Scale",
    Settings.HitboxEnabled,
    5,
    function(state)
        Settings.HitboxEnabled = state
    end
)

local S5 = AddSlider(
    Page4,
    "Head Hitbox",
    45,
    1,
    15,
    Settings.HitboxHead,
    function(value)
        Settings.HitboxHead = value
    end
)

local S6 = AddSlider(
    Page4,
    "Body Hitbox",
    95,
    2,
    20,
    Settings.HitboxTorso,
    function(value)
        Settings.HitboxTorso = value
    end
)

--==================================================
-- Reset
--==================================================

local ResetBtn = Instance.new("TextButton")

ResetBtn.Size = UDim2.new(1, -8, 0, 36)
ResetBtn.Position = UDim2.new(0, 4, 0, 150)
ResetBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
ResetBtn.Text = "⚠ RESET CONFIGURATIONS"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.TextSize = 11
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.Parent = Page4

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 6)
resetCorner.Parent = ResetBtn

local function setSliderVisual(slider, value)
    if not slider then
        return
    end

    slider.Label.Text =
        "  " .. slider.Name .. ": " .. tostring(value)

    local percent = math.clamp(
        (value - slider.Min) /
            (slider.Max - slider.Min),
        0,
        1
    )

    slider.Fill.Size = UDim2.new(percent, 0, 1, 0)
end

ResetBtn.MouseButton1Click:Connect(function()
    Settings.CamlockEnabled = false
    Settings.WallCheck = true
    Settings.TeamCheck = false

    Settings.Smoothness = 90
    Settings.FOVSize = 150

    Settings.WalkSpeedVal = 25
    Settings.JumpPowerVal = 100

    Settings.HitboxHead = 1.5
    Settings.HitboxTorso = 2

    Settings.TargetType = "Players"

    TargetTypeBtn.Text = "  TARGET: [ PLAYERS ]"

    if FOVCircle then
        FOVCircle.Radius = 150
    end

    setSliderVisual(S1, 90)
    setSliderVisual(S2, 150)
    setSliderVisual(S3, 25)
    setSliderVisual(S4, 100)
    setSliderVisual(S5, 1.5)
    setSliderVisual(S6, 2)
end)

--==================================================
-- Hide Icon
--==================================================

local HideIcon = Instance.new("TextButton")

HideIcon.Size = UDim2.new(0, 46, 0, 46)
HideIcon.Position = UDim2.new(0.02, 0, 0.12, 0)
HideIcon.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
HideIcon.Text = "⚡"
HideIcon.TextSize = 20
HideIcon.Font = Enum.Font.GothamBold
HideIcon.Active = true
HideIcon.Draggable = true
HideIcon.Parent = ScreenGui

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 10)
HideCorner.Parent = HideIcon

local strokeIcon = Instance.new("UIStroke")
strokeIcon.Thickness = 1.5
strokeIcon.Parent = HideIcon

task.spawn(function()
    while task.wait() do
        if HideIcon.Parent then
            HideIcon.TextColor3 = Rainbow
            strokeIcon.Color = Rainbow
        else
            break
        end
    end
end)

HideIcon.MouseButton1Click:Connect(function()
    UIHidden = not UIHidden
    MainFrame.Visible = not UIHidden
end)

--==================================================
-- Infinite Jump
--==================================================

UserInputService.JumpRequest:Connect(function()
    if not Settings.InfiniteJump then
        return
    end

    local character = LocalPlayer.Character

    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--==================================================
-- Team Check
--==================================================

local function IsValidPlayer(player)
    if player == LocalPlayer then
        return false
    end

    if Settings.TeamCheck then
        if LocalPlayer.Team ~= nil and player.Team ~= nil then
            if LocalPlayer.Team == player.Team then
                return false
            end
        end
    end

    return true
end

--==================================================
-- Target Search
--==================================================

local function GetTargetInFOV()
    local target = nil
    local shortest = Settings.FOVSize

    Camera = Workspace.CurrentCamera

    if not Camera then
        return nil
    end

    local center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    local candidates = {}

    -- Players
    if Settings.TargetType == "Players" then
        for _, player in ipairs(Players:GetPlayers()) do
            if IsValidPlayer(player) and player.Character then
                table.insert(candidates, {
                    Character = player.Character,
                    Player = player
                })
            end
        end

    -- NPC
    else
        for _, object in ipairs(Workspace:GetDescendants()) do
            if object:IsA("Model")
                and object:FindFirstChildOfClass("Humanoid")
                and not Players:GetPlayerFromCharacter(object) then

                table.insert(candidates, {
                    Character = object,
                    Player = nil
                })
            end
        end
    end

    for _, data in ipairs(candidates) do
        local character = data.Character
        local player = data.Player

        local humanoid =
            character:FindFirstChildOfClass("Humanoid")

        local part =
            character:FindFirstChild(Settings.AimPart)
            or character:FindFirstChild("HumanoidRootPart")

        if humanoid
            and humanoid.Health > 0
            and part then

            local valid = true

            -- Wall Check
            if Settings.WallCheck then
                local origin = Camera.CFrame.Position
                local direction = part.Position - origin

                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                rayParams.FilterDescendantsInstances = {
                    LocalPlayer.Character,
                    character
                }

                local ray =
                    Workspace:Raycast(
                        origin,
                        direction,
                        rayParams
                    )

                if ray then
                    valid = false
                end
            end

            if valid then
                local screenPosition, onScreen =
                    Camera:WorldToViewportPoint(part.Position)

                if onScreen then
                    local distance =
                        (
                            Vector2.new(
                                screenPosition.X,
                                screenPosition.Y
                            ) - center
                        ).Magnitude

                    if distance <= shortest then
                        shortest = distance
                        target = part
                    end
                end
            end
        end
    end

    return target
end

--==================================================
-- ESP Update
--==================================================

local function updateESP()
    Camera = Workspace.CurrentCamera

    if not Camera then
        return
    end

    for player, drawings in pairs(ESP) do
        local character = player.Character

        if not character then
            drawings.Box.Visible = false
            drawings.BoxBG.Visible = false
            drawings.Tracer.Visible = false
            drawings.TracerShadow.Visible = false
            drawings.Name.Visible = false

            continue
        end

        local humanoid =
            character:FindFirstChildOfClass("Humanoid")

        local root =
            character:FindFirstChild("HumanoidRootPart")

        if not humanoid or not root or humanoid.Health <= 0 then
            drawings.Box.Visible = false
            drawings.BoxBG.Visible = false
            drawings.Tracer.Visible = false
            drawings.TracerShadow.Visible = false
            drawings.Name.Visible = false

            continue
        end

        if Settings.TeamCheck
            and LocalPlayer.Team ~= nil
            and player.Team ~= nil
            and LocalPlayer.Team == player.Team then

            drawings.Box.Visible = false
            drawings.BoxBG.Visible = false
            drawings.Tracer.Visible = false
            drawings.TracerShadow.Visible = false
            drawings.Name.Visible = false

            continue
        end

        local rootPosition, rootVisible =
            Camera:WorldToViewportPoint(root.Position)

        local head = character:FindFirstChild("Head")

        local headPosition

        if head then
            headPosition =
                Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        else
            headPosition =
                Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
        end

        local footPosition =
            Camera:WorldToViewportPoint(
                root.Position - Vector3.new(0, 3, 0)
            )

        if not rootVisible then
            drawings.Box.Visible = false
            drawings.BoxBG.Visible = false
            drawings.Tracer.Visible = false
            drawings.TracerShadow.Visible = false
            drawings.Name.Visible = false

            continue
        end

        local height =
            math.abs(headPosition.Y - footPosition.Y)

        local width = math.max(height * 0.55, 2)

        local boxPosition =
            Vector2.new(
                rootPosition.X - width / 2,
                headPosition.Y
            )

        local boxSize =
            Vector2.new(width, height)

        -- Box
        drawings.Box.Visible = Settings.ESPBoxEnabled
        drawings.Box.Position = boxPosition
        drawings.Box.Size = boxSize
        drawings.Box.Color = Rainbow

        -- Background
        drawings.BoxBG.Visible = Settings.ESPBoxEnabled
        drawings.BoxBG.Position = boxPosition
        drawings.BoxBG.Size = boxSize
        drawings.BoxBG.Color = Rainbow

        -- Tracer
        local screenBottom =
            Vector2.new(
                Camera.ViewportSize.X / 2,
                Camera.ViewportSize.Y
            )

        local tracerEnd =
            Vector2.new(
                rootPosition.X,
                footPosition.Y
            )

        drawings.Tracer.Visible = Settings.ESPTracerEnabled
        drawings.Tracer.From = screenBottom
        drawings.Tracer.To = tracerEnd
        drawings.Tracer.Color = Rainbow

        drawings.TracerShadow.Visible =
            Settings.ESPTracerEnabled

        drawings.TracerShadow.From = screenBottom
        drawings.TracerShadow.To = tracerEnd

        -- Name
        drawings.Name.Visible = Settings.ESPNameEnabled
        drawings.Name.Text = player.Name
        drawings.Name.Position =
            Vector2.new(
                rootPosition.X,
                headPosition.Y - 15
            )
        drawings.Name.Color = Rainbow
    end
end

--==================================================
-- Hitbox
--==================================================

local function updateHitboxes()
    if not Settings.HitboxEnabled then
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer
            and player.Character then

            local character = player.Character

            local head = character:FindFirstChild("Head")
            local torso =
                character:FindFirstChild("UpperTorso")
                or character:FindFirstChild("Torso")
                or character:FindFirstChild("HumanoidRootPart")

            if head then
                pcall(function()
                    head.Size = Vector3.new(
                        Settings.HitboxHead,
                        Settings.HitboxHead,
                        Settings.HitboxHead
                    )
                end)
            end

            if torso then
                pcall(function()
                    torso.Size = Vector3.new(
                        Settings.HitboxTorso,
                        Settings.HitboxTorso,
                        Settings.HitboxTorso
                    )
                end)
            end
        end
    end
end

--==================================================
-- Movement
--==================================================

local function updateMovement()
    local character = LocalPlayer.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    if Settings.SpeedEnabled then
        humanoid.WalkSpeed = Settings.WalkSpeedVal
    else
        humanoid.WalkSpeed = 16
    end

    if Settings.JumpEnabled then
        humanoid.JumpPower = Settings.JumpPowerVal
    else
        humanoid.JumpPower = 50
    end

    if Settings.NoClipEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

--==================================================
-- Main Render Loop
--==================================================

RunService.RenderStepped:Connect(function()
    Camera = Workspace.CurrentCamera

    if not Camera then
        return
    end

    -- FOV
    if FOVCircle then
        pcall(function()
            if Settings.CamlockEnabled then
                FOVCircle.Position = Vector2.new(
                    Camera.ViewportSize.X / 2,
                    Camera.ViewportSize.Y / 2
                )
            else
                local delta =
                    Camera.CFrame.Position -
                    LastCameraCFrame.Position

                local screenCenter =
                    Vector2.new(
                        Camera.ViewportSize.X / 2,
                        Camera.ViewportSize.Y / 2
                    )

                FOVCircle.Position =
                    screenCenter +
                    Vector2.new(
                        delta.X * 45,
                        delta.Y * 45
                    )
            end

            FOVCircle.Radius = Settings.FOVSize
        end)
    end

    LastCameraCFrame = Camera.CFrame

    updateMovement()
    updateESP()
    updateHitboxes()

    --==================================================
    -- Camlock
    --==================================================

    if not Settings.CamlockEnabled then
        LockedTarget = nil
        return
    end

    if LockedTarget and LockedTarget.Parent then
        local character = LockedTarget.Parent
        local humanoid =
            character:FindFirstChildOfClass("Humanoid")

        local screenPosition, onScreen =
            Camera:WorldToViewportPoint(
                LockedTarget.Position
            )

        local center =
            Vector2.new(
                Camera.ViewportSize.X / 2,
                Camera.ViewportSize.Y / 2
            )

        local currentDistance =
            (
                Vector2.new(
                    screenPosition.X,
                    screenPosition.Y
                ) - center
            ).Magnitude

        if not onScreen
            or (humanoid and humanoid.Health <= 0)
            or currentDistance > Settings.FOVSize then

            LockedTarget = GetTargetInFOV()
        end
    else
        LockedTarget = GetTargetInFOV()
    end

    if LockedTarget then
        local destination =
            CFrame.new(
                Camera.CFrame.Position,
                LockedTarget.Position
            )

        local speed = Settings.Smoothness

        if speed >= 100 then
            Camera.CFrame = destination
        else
            Camera.CFrame =
                Camera.CFrame:Lerp(
                    destination,
                    math.clamp(
                        speed / 100,
                        0.01,
                        1
                    )
                )
        end
    end
end)

--==================================================
-- Close / Cleanup
--==================================================

local function cleanup()
    pcall(function()
        if FOVCircle then
            FOVCircle:Remove()
            FOVCircle = nil
        end
    end)

    for player in pairs(ESP) do
        removeESP(player)
    end

    if ScreenGui then
        ScreenGui:Destroy()
    end
end

CloseBtn.MouseButton1Click:Connect(function()
    cleanup()
end)

--==================================================
-- Character Respawn Support
--==================================================

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)

    LockedTarget = nil
end)

print("GG.GR Separation Edition v5 loaded successfully.")
