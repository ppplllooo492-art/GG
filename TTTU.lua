local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

getgenv().ModSettings = getgenv().ModSettings or {
    CamlockEnabled = false,
    WallCheck = true,
    Smoothness = 90,
    FOVSize = 150,
    AimPart = "HumanoidRootPart",
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
    InfiniteJump = false
}

local Settings = getgenv().ModSettings

local LockedTarget = nil
local UIHidden = false
local ESP = {}

local Rainbow = Color3.fromRGB(255, 0, 0)
local FOVCircle = nil

----------------------------------------------------------------
-- RAINBOW
----------------------------------------------------------------

task.spawn(function()
    local h = 0

    while task.wait() do
        h = (h + 1.5) % 360
        Rainbow = Color3.fromHSV(h / 360, 1, 1)
    end
end)

----------------------------------------------------------------
-- FOV CIRCLE
----------------------------------------------------------------

pcall(function()
    FOVCircle = Drawing.new("Circle")

    FOVCircle.Visible = true
    FOVCircle.Filled = false
    FOVCircle.Thickness = 2
    FOVCircle.Color = Color3.fromRGB(0, 255, 170)
    FOVCircle.Radius = Settings.FOVSize

    FOVCircle.Position = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )
end)

----------------------------------------------------------------
-- ESP
----------------------------------------------------------------

local function createESP(player)
    if player == LocalPlayer or ESP[player] then
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

    local d = ESP[player]

    pcall(function()
        d.Box.Thickness = 1.5
        d.Box.Filled = false
        d.Box.Visible = false

        d.BoxBG.Thickness = 1
        d.BoxBG.Filled = true
        d.BoxBG.Transparency = 0.1
        d.BoxBG.Visible = false

        d.TracerShadow.Thickness = 3
        d.TracerShadow.Color = Color3.new(0, 0, 0)
        d.TracerShadow.Visible = false

        d.Tracer.Thickness = 1.5
        d.Tracer.Visible = false

        d.Name.Size = 13
        d.Name.Center = true
        d.Name.Outline = true
        d.Name.Visible = false
    end)
end

local function removeESP(player)
    if not ESP[player] then
        return
    end

    for _, v in pairs(ESP[player]) do
        pcall(function()
            v:Remove()
        end)
    end

    ESP[player] = nil
end

for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

----------------------------------------------------------------
-- GUI CLEANUP
----------------------------------------------------------------

pcall(function()
    local oldGui = LocalPlayer.PlayerGui:FindFirstChild("CyberHudGuiV3")

    if oldGui then
        oldGui:Destroy()
    end
end)

----------------------------------------------------------------
-- SCREEN GUI
----------------------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyberHudGuiV3"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

----------------------------------------------------------------
-- MAIN FRAME
----------------------------------------------------------------

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 380)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 170)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

----------------------------------------------------------------
-- TOP BAR
----------------------------------------------------------------

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "❖ GG.GR // CYBERPUNK ELITE"
Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

task.spawn(function()
    while ScreenGui.Parent do
        task.wait()
        Title.TextColor3 = Rainbow
    end
end)

----------------------------------------------------------------
-- CLOSE BUTTON
----------------------------------------------------------------

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 45, 85)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    if ScreenGui then
        ScreenGui:Destroy()
    end

    if FOVCircle then
        pcall(function()
            FOVCircle:Remove()
        end)
        FOVCircle = nil
    end

    for player in pairs(ESP) do
        removeESP(player)
    end
end)

----------------------------------------------------------------
-- TAB BAR
----------------------------------------------------------------

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 130, 1, -52)
TabBar.Position = UDim2.new(0, 8, 0, 46)
TabBar.BackgroundColor3 = Color3.fromRGB(13, 13, 19)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 8)
TabBarCorner.Parent = TabBar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -144, 1, -52)
TabContainer.Position = UDim2.new(0, 142, 0, 46)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local Tabs = {}

----------------------------------------------------------------
-- CREATE TAB
----------------------------------------------------------------

local function CreateTab(name, yPos)
    local btn = Instance.new("TextButton")

    btn.Size = UDim2.new(1, -12, 0, 36)
    btn.Position = UDim2.new(0, 6, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(150, 150, 170)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = TabBar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local page = Instance.new("ScrollingFrame")

    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 340)
    page.ScrollBarThickness = 3
    page.Visible = false
    page.BorderSizePixel = 0
    page.Parent = TabContainer

    local tab = {
        Btn = btn,
        Page = page
    }

    table.insert(Tabs, tab)

    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(Tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
            t.Btn.TextColor3 = Color3.fromRGB(150, 150, 170)
            t.Page.Visible = false
        end

        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
        btn.TextColor3 = Color3.fromRGB(10, 10, 14)
        page.Visible = true
    end)

    return page
end

local Page1 = CreateTab("Aim & Lock", 8)
local Page2 = CreateTab("Visuals (ESP)", 50)
local Page3 = CreateTab("Movement", 92)
local Page4 = CreateTab("Hitbox Settings", 134)

if #Tabs > 0 then
    Tabs[1].Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    Tabs[1].Btn.TextColor3 = Color3.fromRGB(10, 10, 14)
    Tabs[1].Page.Visible = true
end

----------------------------------------------------------------
-- TOGGLE
----------------------------------------------------------------

local function AddToggle(parent, name, default, y, callback)
    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1, -8, 0, 36)
    button.Position = UDim2.new(0, 4, 0, y)
    button.BackgroundColor3 =
        default
        and Color3.fromRGB(0, 180, 120)
        or Color3.fromRGB(18, 18, 26)

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

        button.BackgroundColor3 =
            state
            and Color3.fromRGB(0, 180, 120)
            or Color3.fromRGB(18, 18, 26)

        button.Text =
            "  "
            .. name
            .. " [ "
            .. (state and "ON" or "OFF")
            .. " ]"

        callback(state)
    end)
end

----------------------------------------------------------------
-- SLIDER
----------------------------------------------------------------

local function AddSlider(parent, name, y, minValue, maxValue, value, callback)
    local label = Instance.new("TextLabel")

    label.Size = UDim2.new(1, -8, 0, 18)
    label.Position = UDim2.new(0, 4, 0, y)
    label.BackgroundTransparency = 1
    label.Text = "  " .. name .. ": " .. value
    label.TextColor3 = Color3.fromRGB(160, 160, 180)
    label.TextSize = 10
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local bar = Instance.new("TextButton")

    bar.Size = UDim2.new(1, -8, 0, 14)
    bar.Position = UDim2.new(0, 4, 0, y + 18)
    bar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    bar.Text = ""
    bar.BorderSizePixel = 0
    bar.Parent = parent

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")

    fill.Size = UDim2.new(
        math.clamp((value - minValue) / (maxValue - minValue), 0, 1),
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
        local position = math.clamp(
            (inputX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
            0,
            1
        )

        fill.Size = UDim2.new(position, 0, 1, 0)

        local result = math.floor(
            minValue + position * (maxValue - minValue)
        )

        label.Text = "  " .. name .. ": " .. result

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
end

----------------------------------------------------------------
-- AIM TAB
----------------------------------------------------------------

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

AddSlider(
    Page1,
    "Lock Speed",
    130,
    1,
    100,
    Settings.Smoothness,
    function(value)
        Settings.Smoothness = value
    end
)

AddSlider(
    Page1,
    "FOV Circle Size",
    180,
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

----------------------------------------------------------------
-- ESP TAB
----------------------------------------------------------------

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

----------------------------------------------------------------
-- MOVEMENT TAB
----------------------------------------------------------------

AddToggle(
    Page3,
    "Speed Boost",
    Settings.SpeedEnabled,
    5,
    function(state)
        Settings.SpeedEnabled = state
    end
)

AddSlider(
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

AddSlider(
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

----------------------------------------------------------------
-- HITBOX TAB
----------------------------------------------------------------

AddToggle(
    Page4,
    "Hitbox Scale",
    Settings.HitboxEnabled,
    5,
    function(state)
        Settings.HitboxEnabled = state
    end
)

AddSlider(
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

AddSlider(
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

----------------------------------------------------------------
-- HIDE BUTTON
----------------------------------------------------------------

local HideIcon = Instance.new("TextButton")

HideIcon.Size = UDim2.new(0, 45, 0, 45)
HideIcon.Position = UDim2.new(0.02, 0, 0.1, 0)
HideIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
HideIcon.Text = "⚡"
HideIcon.TextColor3 = Color3.fromRGB(0, 255, 170)
HideIcon.TextSize = 18
HideIcon.Font = Enum.Font.GothamBold
HideIcon.Active = true
HideIcon.Draggable = true
HideIcon.Parent = ScreenGui

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 10)
HideCorner.Parent = HideIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 255, 170)
IconStroke.Thickness = 1.5
IconStroke.Parent = HideIcon

HideIcon.MouseButton1Click:Connect(function()
    UIHidden = not UIHidden
    MainFrame.Visible = not UIHidden
end)

----------------------------------------------------------------
-- INFINITE JUMP
----------------------------------------------------------------

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

----------------------------------------------------------------
-- TARGET FUNCTION
----------------------------------------------------------------

local function GetTargetInFOV()
    local target = nil
    local shortest = Settings.FOVSize

    local center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then
            continue
        end

        local character = player.Character

        if not character then
            continue
        end

        local part = character:FindFirstChild(Settings.AimPart)

        if not part then
            continue
        end

        if Settings.TeamCheck and player.Team == LocalPlayer.Team then
            continue
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if not humanoid or humanoid.Health <= 0 then
            continue
        end

        --------------------------------------------------------
        -- WALL CHECK
        --------------------------------------------------------

        if Settings.WallCheck then
            local origin = Camera.CFrame.Position
            local direction = part.Position - origin

            local rayParams = RaycastParams.new()

            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = {
                LocalPlayer.Character
            }

            rayParams.IgnoreWater = true

            local rayResult = Workspace:Raycast(
                origin,
                direction,
                rayParams
            )

            if rayResult
                and rayResult.Instance
                and not rayResult.Instance:IsDescendantOf(character) then

                continue
            end
        end

        --------------------------------------------------------
        -- FOV CHECK
        --------------------------------------------------------

        local screenPosition, onScreen =
            Camera:WorldToViewportPoint(part.Position)

        if not onScreen then
            continue
        end

        local distance = (
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

    return target
end

----------------------------------------------------------------
-- RENDER LOOP
----------------------------------------------------------------

RunService.RenderStepped:Connect(function()
    Camera = Workspace.CurrentCamera

    if not Camera then
        return
    end

    ------------------------------------------------------------
    -- FOV
    ------------------------------------------------------------

    if FOVCircle then
        pcall(function()
            FOVCircle.Position = Vector2.new(
                Camera.ViewportSize.X / 2,
                Camera.ViewportSize.Y / 2
            )

            FOVCircle.Radius = Settings.FOVSize
            FOVCircle.Visible = true
        end)
    end

    ------------------------------------------------------------
    -- LOCAL PLAYER
    ------------------------------------------------------------

    local character = LocalPlayer.Character

    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
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
        end

        --------------------------------------------------------
        -- NOCLIP
        --------------------------------------------------------

        if Settings.NoClipEnabled then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end

    ------------------------------------------------------------
    -- HITBOX
    ------------------------------------------------------------

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then
            continue
        end

        local targetCharacter = player.Character

        if not targetCharacter then
            continue
        end

        local head = targetCharacter:FindFirstChild("Head")
        local torso =
            targetCharacter:FindFirstChild("UpperTorso")
            or targetCharacter:FindFirstChild("Torso")

        local sameTeam =
            Settings.TeamCheck
            and player.Team == LocalPlayer.Team

        if Settings.HitboxEnabled and not sameTeam then
            if head then
                head.Size = Vector3.new(
                    Settings.HitboxHead,
                    Settings.HitboxHead,
                    Settings.HitboxHead
                )

                head.Transparency = 0.5
                head.CanCollide = false
            end

            if torso then
                torso.Size = Vector3.new(
                    Settings.HitboxTorso,
                    Settings.HitboxTorso,
                    Settings.HitboxTorso
                )

                torso.Transparency = 0.5
                torso.CanCollide = false
            end
        else
            if head then
                head.Size = Vector3.new(2, 1, 1)
                head.Transparency = 0
            end

            if torso then
                torso.Size = Vector3.new(2, 2, 1)
                torso.Transparency = 0
            end
        end
    end

    ------------------------------------------------------------
    -- ESP
    ------------------------------------------------------------

    for player, drawings in pairs(ESP) do
        local d = drawings

        local targetCharacter = player.Character

        local humanoid =
            targetCharacter
            and targetCharacter:FindFirstChildOfClass("Humanoid")

        local root =
            targetCharacter
            and targetCharacter:FindFirstChild("HumanoidRootPart")

        local head =
            targetCharacter
            and targetCharacter:FindFirstChild("Head")

        local isTeam =
            Settings.TeamCheck
            and player.Team == LocalPlayer.Team

        if humanoid
            and root
            and head
            and humanoid.Health > 0
            and not isTeam then

            local headPosition, headOnScreen =
                Camera:WorldToViewportPoint(
                    head.Position + Vector3.new(0, 0.5, 0)
                )

            local rootPosition =
                Camera:WorldToViewportPoint(
                    root.Position - Vector3.new(0, 3, 0)
                )

            if headOnScreen and headPosition.Z > 0 then
                local height =
                    math.abs(headPosition.Y - rootPosition.Y)

                local width = height / 1.6

                ------------------------------------------------
                -- BOX
                ------------------------------------------------

                if Settings.ESPBoxEnabled then
                    d.Box.Size = Vector2.new(width, height)
                    d.Box.Position = Vector2.new(
                        headPosition.X - width / 2,
                        headPosition.Y
                    )

                    d.Box.Color = Rainbow
                    d.Box.Visible = true

                    d.BoxBG.Size = Vector2.new(width, height)
                    d.BoxBG.Position = Vector2.new(
                        headPosition.X - width / 2,
                        headPosition.Y
                    )

                    d.BoxBG.Color = Rainbow
                    d.BoxBG.Visible = true
                else
                    d.Box.Visible = false
                    d.BoxBG.Visible = false
                end

                ------------------------------------------------
                -- TRACER
                ------------------------------------------------

                if Settings.ESPTracerEnabled then
                    local tracerStart =
                        Vector2.new(
                            Camera.ViewportSize.X / 2,
                            0
                        )

                    local tracerEnd =
                        Vector2.new(
                            headPosition.X,
                            headPosition.Y
                        )

                    d.TracerShadow.From = tracerStart
                    d.TracerShadow.To = tracerEnd
                    d.TracerShadow.Visible = true

                    d.Tracer.From = tracerStart
                    d.Tracer.To = tracerEnd
                    d.Tracer.Color = Rainbow
                    d.Tracer.Visible = true
                else
                    d.Tracer.Visible = false
                    d.TracerShadow.Visible = false
                end

                ------------------------------------------------
                -- NAME
                ------------------------------------------------

                if Settings.ESPNameEnabled then
                    d.Name.Text = player.Name
                    d.Name.Position = Vector2.new(
                        headPosition.X,
                        headPosition.Y - 18
                    )

                    d.Name.Color = Rainbow
                    d.Name.Visible = true
                else
                    d.Name.Visible = false
                end
            else
                d.Box.Visible = false
                d.BoxBG.Visible = false
                d.Tracer.Visible = false
                d.TracerShadow.Visible = false
                d.Name.Visible = false
            end
        else
            d.Box.Visible = false
            d.BoxBG.Visible = false
            d.Tracer.Visible = false
            d.TracerShadow.Visible = false
            d.Name.Visible = false
        end
    end

    ------------------------------------------------------------
    -- CAMLOCK
    ------------------------------------------------------------

    if Settings.CamlockEnabled then

        if LockedTarget and LockedTarget.Parent then
            local targetCharacter = LockedTarget.Parent

            local humanoid =
                targetCharacter:FindFirstChildOfClass("Humanoid")

            local center = Vector2.new(
                Camera.ViewportSize.X / 2,
                Camera.ViewportSize.Y / 2
            )

            local screenPosition, onScreen =
                Camera:WorldToViewportPoint(
                    LockedTarget.Position
                )

            local currentDistance =
                (
                    Vector2.new(
                        screenPosition.X,
                        screenPosition.Y
                    ) - center
                ).Magnitude

            local targetPlayer =
                Players:GetPlayerFromCharacter(
                    targetCharacter
                )

            local isTeam =
                Settings.TeamCheck
                and targetPlayer
                and targetPlayer.Team == LocalPlayer.Team

            if not onScreen
                or (humanoid and humanoid.Health <= 0)
                or currentDistance > Settings.FOVSize
                or isTeam then

                LockedTarget = nil
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
                        math.clamp(speed / 100, 0.01, 1)
                    )
            end
        end
    else
        LockedTarget = nil
    end
end)
