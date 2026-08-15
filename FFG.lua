--// CYBERPUNK HUD // DELTA EDITION
--// Fixed / Stable Version

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--==================================================
-- SETTINGS
--==================================================

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
    HitboxSize = 5,

    NoClipEnabled = false,
    InfiniteJump = false
}

local Settings = getgenv().ModSettings

--==================================================
-- VARIABLES
--==================================================

local LockedTarget = nil
local UIHidden = false
local ESP = {}
local Connections = {}
local Rainbow = Color3.fromRGB(255, 0, 0)

local FOVCircle = nil
local Closed = false

local OriginalWalkSpeed = 16
local OriginalJumpPower = 50

local OriginalCollision = {}
local OriginalHitbox = {}

--==================================================
-- SAFE CONNECTION
--==================================================

local function Connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(Connections, connection)
    return connection
end

--==================================================
-- RAINBOW
--==================================================

task.spawn(function()
    local h = 0

    while not Closed do
        h = (h + 1.5) % 360
        Rainbow = Color3.fromHSV(h / 360, 1, 1)
        task.wait()
    end
end)

--==================================================
-- FOV CIRCLE
--==================================================

pcall(function()
    FOVCircle = Drawing.new("Circle")

    FOVCircle.Visible = true
    FOVCircle.Filled = false
    FOVCircle.Thickness = 2
    FOVCircle.Color = Color3.fromRGB(0, 255, 170)
    FOVCircle.Radius = Settings.FOVSize

    if Camera then
        FOVCircle.Position = Vector2.new(
            Camera.ViewportSize.X / 2,
            Camera.ViewportSize.Y / 2
        )
    end
end)

--==================================================
-- DRAWING HELPERS
--==================================================

local function SetVisible(drawing, visible)
    if drawing then
        pcall(function()
            drawing.Visible = visible
        end)
    end
end

local function RemoveDrawing(drawing)
    if drawing then
        pcall(function()
            drawing:Remove()
        end)
    end
end

--==================================================
-- ESP
--==================================================

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

    local d = drawings

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

        d.Name.Size = 14
        d.Name.Center = true
        d.Name.Outline = true
        d.Name.Visible = false
    end)
end

local function hideESP(drawings)
    if not drawings then
        return
    end

    SetVisible(drawings.Box, false)
    SetVisible(drawings.BoxBG, false)
    SetVisible(drawings.Tracer, false)
    SetVisible(drawings.TracerShadow, false)
    SetVisible(drawings.Name, false)
end

local function removeESP(player)
    local drawings = ESP[player]

    if not drawings then
        return
    end

    hideESP(drawings)

    for _, drawing in pairs(drawings) do
        RemoveDrawing(drawing)
    end

    ESP[player] = nil
end

for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

Connect(Players.PlayerAdded, function(player)
    createESP(player)
end)

Connect(Players.PlayerRemoving, function(player)
    removeESP(player)
end)

--==================================================
-- REMOVE OLD UI
--==================================================

pcall(function()
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui then
        local old = PlayerGui:FindFirstChild("CyberHudGui")

        if old then
            old:Destroy()
        end
    end
end)

--==================================================
-- SCREEN GUI
--==================================================

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyberHudGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--==================================================
-- MAIN FRAME
--==================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 520)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 170)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

--==================================================
-- TOP BAR
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = TopBar

local FixTop = Instance.new("Frame")
FixTop.Size = UDim2.new(1, 0, 0, 10)
FixTop.Position = UDim2.new(0, 0, 1, -10)
FixTop.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
FixTop.BorderSizePixel = 0
FixTop.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ CYBERPUNK HUD // DELTA EDITION"
Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

--==================================================
-- CLOSE BUTTON
--==================================================

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

--==================================================
-- CONTAINER
--==================================================

local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -20, 1, -62)
Container.Position = UDim2.new(0, 10, 0, 56)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 810)
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170)
Container.Parent = MainFrame

--==================================================
-- TOGGLE
--==================================================

local function CreateToggle(name, default, y, callback)

    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1, -10, 0, 42)
    button.Position = UDim2.new(0, 5, 0, y)

    button.BackgroundColor3 =
        default
        and Color3.fromRGB(0, 180, 120)
        or Color3.fromRGB(22, 22, 32)

    button.Text =
        "  "
        .. name
        .. " [ "
        .. (default and "ACTIVE" or "OFF")
        .. " ]"

    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.AutoButtonColor = false
    button.Parent = Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    local state = default

    Connect(button.MouseButton1Click, function()

        state = not state

        button.BackgroundColor3 =
            state
            and Color3.fromRGB(0, 180, 120)
            or Color3.fromRGB(22, 22, 32)

        button.Text =
            "  "
            .. name
            .. " [ "
            .. (state and "ACTIVE" or "OFF")
            .. " ]"

        pcall(callback, state)
    end)

    return button
end

--==================================================
-- SLIDER
--==================================================

local function CreateSlider(name, y, minValue, maxValue, value, callback)

    local label = Instance.new("TextLabel")

    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, y)
    label.BackgroundTransparency = 1
    label.Text = "  " .. name .. ": " .. tostring(value)
    label.TextColor3 = Color3.fromRGB(180, 180, 200)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = Container

    local bar = Instance.new("TextButton")

    bar.Size = UDim2.new(1, -10, 0, 18)
    bar.Position = UDim2.new(0, 5, 0, y + 20)
    bar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    bar.BorderSizePixel = 0
    bar.Text = ""
    bar.AutoButtonColor = false
    bar.Parent = Container

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 6)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 6)
    fillCorner.Parent = fill

    local initialPosition = math.clamp(
        (value - minValue) / (maxValue - minValue),
        0,
        1
    )

    fill.Size = UDim2.new(initialPosition, 0, 1, 0)

    local dragging = false

    local function updateSlider(inputX)

        if bar.AbsoluteSize.X <= 0 then
            return
        end

        local position = math.clamp(
            (inputX - bar.AbsolutePosition.X)
                / bar.AbsoluteSize.X,
            0,
            1
        )

        fill.Size = UDim2.new(position, 0, 1, 0)

        local result = math.floor(
            minValue
            + position * (maxValue - minValue)
            + 0.5
        )

        label.Text = "  " .. name .. ": " .. tostring(result)

        pcall(callback, result)
    end

    Connect(bar.InputBegan, function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            updateSlider(input.Position.X)
        end
    end)

    Connect(UserInputService.InputEnded, function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    Connect(UserInputService.InputChanged, function(input)

        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then

            return
        end

        updateSlider(input.Position.X)
    end)
end

--==================================================
-- UI CONTROLS
--==================================================

CreateToggle(
    "Camlock (ระบบล็อคเป้า)",
    Settings.CamlockEnabled,
    10,
    function(state)
        Settings.CamlockEnabled = state

        if not state then
            LockedTarget = nil
        end
    end
)

CreateToggle(
    "WallCheck (เช็คกำแพง)",
    Settings.WallCheck,
    58,
    function(state)
        Settings.WallCheck = state
    end
)

CreateToggle(
    "Team Check (แยกทีมเดียวกัน)",
    Settings.TeamCheck,
    106,
    function(state)
        Settings.TeamCheck = state
    end
)

CreateSlider(
    "Lock Speed (ความเร็ว 1-100)",
    158,
    1,
    100,
    Settings.Smoothness,
    function(value)
        Settings.Smoothness = value
    end
)

CreateSlider(
    "FOV Circle (ขนาดวงกลม 50-400)",
    216,
    50,
    400,
    Settings.FOVSize,
    function(value)

        Settings.FOVSize = value

        if FOVCircle then
            pcall(function()
                FOVCircle.Radius = value
            end)
        end
    end
)

CreateToggle(
    "ESP Box (กรอบสี่เหลี่ยม)",
    Settings.ESPBoxEnabled,
    278,
    function(state)
        Settings.ESPBoxEnabled = state
    end
)

CreateToggle(
    "ESP Tracer (เส้นลาก)",
    Settings.ESPTracerEnabled,
    326,
    function(state)
        Settings.ESPTracerEnabled = state
    end
)

CreateToggle(
    "ESP Name (แสดงชื่อ)",
    Settings.ESPNameEnabled,
    374,
    function(state)
        Settings.ESPNameEnabled = state
    end
)

CreateToggle(
    "Speed Boost (วิ่งเร็ว)",
    Settings.SpeedEnabled,
    422,
    function(state)
        Settings.SpeedEnabled = state
    end
)

CreateSlider(
    "WalkSpeed (16-250)",
    470,
    16,
    250,
    Settings.WalkSpeedVal,
    function(value)
        Settings.WalkSpeedVal = value
    end
)

CreateToggle(
    "High Jump (กระโดดสูง)",
    Settings.JumpEnabled,
    532,
    function(state)
        Settings.JumpEnabled = state
    end
)

CreateSlider(
    "JumpPower (50-400)",
    580,
    50,
    400,
    Settings.JumpPowerVal,
    function(value)
        Settings.JumpPowerVal = value
    end
)

CreateToggle(
    "Hitbox Expander",
    Settings.HitboxEnabled,
    642,
    function(state)
        Settings.HitboxEnabled = state
    end
)

CreateToggle(
    "NoClip",
    Settings.NoClipEnabled,
    690,
    function(state)
        Settings.NoClipEnabled = state
    end
)

CreateToggle(
    "Infinite Jump",
    Settings.InfiniteJump,
    738,
    function(state)
        Settings.InfiniteJump = state
    end
)

--==================================================
-- FLOATING MENU
--==================================================

local FloatBtn = Instance.new("TextButton")

FloatBtn.Size = UDim2.new(0, 110, 0, 40)
FloatBtn.Position = UDim2.new(0.03, 0, 0.12, 0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
FloatBtn.Text = "MENU UI"
FloatBtn.TextColor3 = Color3.fromRGB(0, 255, 170)
FloatBtn.TextSize = 13
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.Active = true
FloatBtn.Draggable = true
FloatBtn.AutoButtonColor = false
FloatBtn.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 8)
FloatCorner.Parent = FloatBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(0, 255, 170)
FloatStroke.Thickness = 1
FloatStroke.Parent = FloatBtn

Connect(FloatBtn.MouseButton1Click, function()

    UIHidden = not UIHidden
    MainFrame.Visible = not UIHidden

end)

--==================================================
-- INFINITE JUMP
--==================================================

Connect(UserInputService.JumpRequest, function()

    if not Settings.InfiniteJump then
        return
    end

    local character = LocalPlayer.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    if humanoid and humanoid.Health > 0 then
        humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )
    end
end)

--==================================================
-- CHARACTER HANDLER
--==================================================

local function SetupCharacter(character)

    local humanoid =
        character:WaitForChild("Humanoid", 5)

    if humanoid then
        OriginalWalkSpeed = humanoid.WalkSpeed

        if humanoid.UseJumpPower then
            OriginalJumpPower = humanoid.JumpPower
        else
            OriginalJumpPower = 50
        end
    end

    OriginalCollision = {}
end

if LocalPlayer.Character then
    task.spawn(function()
        SetupCharacter(LocalPlayer.Character)
    end)
end

Connect(
    LocalPlayer.CharacterAdded,
    function(character)
        task.spawn(function()
            SetupCharacter(character)
        end)

        LockedTarget = nil
    end
)

--==================================================
-- TARGET CHECK
--==================================================

local function IsValidTarget(player)

    if not player or player == LocalPlayer then
        return false
    end

    local character = player.Character

    if not character then
        return false
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    if not humanoid or humanoid.Health <= 0 then
        return false
    end

    if Settings.TeamCheck
        and player.Team == LocalPlayer.Team then

        return false
    end

    return true
end

--==================================================
-- GET TARGET
--==================================================

local function GetTargetInFOV()

    if not Camera then
        return nil
    end

    local target = nil
    local shortestDistance = Settings.FOVSize

    local center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    for _, player in ipairs(Players:GetPlayers()) do

        if not IsValidTarget(player) then
            continue
        end

        local character = player.Character

        local part =
            character:FindFirstChild(Settings.AimPart)

        if not part or not part:IsA("BasePart") then
            continue
        end

        -- Wall Check
        if Settings.WallCheck then

            local origin = Camera.CFrame.Position
            local direction = part.Position - origin

            local params = RaycastParams.new()

            params.FilterType =
                Enum.RaycastFilterType.Exclude

            params.FilterDescendantsInstances = {
                LocalPlayer.Character
            }

            params.IgnoreWater = true

            local result = Workspace:Raycast(
                origin,
                direction,
                params
            )

            if result
                and not result.Instance:IsDescendantOf(character) then

                continue
            end
        end

        local screenPosition, onScreen =
            Camera:WorldToViewportPoint(part.Position)

        if not onScreen or screenPosition.Z <= 0 then
            continue
        end

        local distance = (
            Vector2.new(
                screenPosition.X,
                screenPosition.Y
            ) - center
        ).Magnitude

        if distance <= shortestDistance then
            shortestDistance = distance
            target = part
        end
    end

    return target
end

--==================================================
-- MAIN LOOP
--==================================================

Connect(
    RunService.RenderStepped,
    function()

        if Closed then
            return
        end

        Camera = Workspace.CurrentCamera

        if not Camera then
            return
        end

        --==========================================
        -- FOV
        --==========================================

        if FOVCircle then
            pcall(function()

                FOVCircle.Position = Vector2.new(
                    Camera.ViewportSize.X / 2,
                    Camera.ViewportSize.Y / 2
                )

                FOVCircle.Radius = Settings.FOVSize
            end)
        end

        --==========================================
        -- LOCAL CHARACTER
        --==========================================

        local character = LocalPlayer.Character

        if character then

            local humanoid =
                character:FindFirstChildOfClass("Humanoid")

            if humanoid then

                -- Speed
                if Settings.SpeedEnabled then
                    humanoid.WalkSpeed =
                        Settings.WalkSpeedVal
                else
                    humanoid.WalkSpeed =
                        OriginalWalkSpeed
                end

                -- Jump
                if Settings.JumpEnabled then
                    if humanoid.UseJumpPower then
                        humanoid.JumpPower =
                            Settings.JumpPowerVal
                    end
                else
                    if humanoid.UseJumpPower then
                        humanoid.JumpPower =
                            OriginalJumpPower
                    end
                end
            end

            --======================================
            -- NOCLIP
            --======================================

            if Settings.NoClipEnabled then

                for _, part in ipairs(
                    character:GetDescendants()
                ) do

                    if part:IsA("BasePart") then

                        if OriginalCollision[part] == nil then
                            OriginalCollision[part] =
                                part.CanCollide
                        end

                        part.CanCollide = false
                    end
                end

            else

                for part, original in pairs(OriginalCollision) do

                    if part
                        and part.Parent
                        and part:IsA("BasePart") then

                        pcall(function()
                            part.CanCollide = original
                        end)
                    end
                end

                OriginalCollision = {}
            end
        end

        --==========================================
        -- HITBOX
        --==========================================

        for _, player in ipairs(Players:GetPlayers()) do

            if player ~= LocalPlayer then

                local targetCharacter = player.Character

                local root =
                    targetCharacter
                    and targetCharacter:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if root then

                    if OriginalHitbox[root] == nil then

                        OriginalHitbox[root] = {
                            Size = root.Size,
                            Transparency = root.Transparency,
                            CanCollide = root.CanCollide
                        }
                    end

                    local sameTeam =
                        Settings.TeamCheck
                        and player.Team == LocalPlayer.Team

                    if Settings.HitboxEnabled
                        and not sameTeam then

                        pcall(function()

                            root.Size = Vector3.new(
                                Settings.HitboxSize,
                                Settings.HitboxSize,
                                Settings.HitboxSize
                            )

                            root.Transparency = 0.7
                            root.CanCollide = false
                        end)

                    else

                        local original =
                            OriginalHitbox[root]

                        if original then
                            pcall(function()

                                root.Size =
                                    original.Size

                                root.Transparency =
                                    original.Transparency

                                root.CanCollide =
                                    original.CanCollide
                            end)

                            OriginalHitbox[root] = nil
                        end
                    end
                end
            end
        end

        --==========================================
        -- ESP
        --==========================================

        for player, drawings in pairs(ESP) do

            if not drawings then
                continue
            end

            local targetCharacter =
                player.Character

            local humanoid =
                targetCharacter
                and targetCharacter:FindFirstChildOfClass(
                    "Humanoid"
                )

            local root =
                targetCharacter
                and targetCharacter:FindFirstChild(
                    "HumanoidRootPart"
                )

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
                        head.Position
                            + Vector3.new(0, 0.5, 0)
                    )

                local rootPosition =
                    Camera:WorldToViewportPoint(
                        root.Position
                            - Vector3.new(0, 3, 0)
                    )

                if headOnScreen
                    and headPosition.Z > 0
                    and rootPosition.Z > 0 then

                    local height =
                        math.abs(
                            headPosition.Y
                            - rootPosition.Y
                        )

                    local width =
                        math.max(height / 1.6, 2)

                    -- Box
                    if Settings.ESPBoxEnabled then

                        pcall(function()

                            drawings.Box.Size =
                                Vector2.new(
                                    width,
                                    height
                                )

                            drawings.Box.Position =
                                Vector2.new(
                                    headPosition.X
                                        - width / 2,
                                    headPosition.Y
                                )

                            drawings.Box.Color = Rainbow
                            drawings.Box.Visible = true

                            drawings.BoxBG.Size =
                                Vector2.new(
                                    width,
                                    height
                                )

                            drawings.BoxBG.Position =
                                Vector2.new(
                                    headPosition.X
                                        - width / 2,
                                    headPosition.Y
                                )

                            drawings.BoxBG.Color = Rainbow
                            drawings.BoxBG.Visible = true
                        end)

                    else
                        SetVisible(drawings.Box, false)
                        SetVisible(drawings.BoxBG, false)
                    end

                    -- Tracer
                    if Settings.ESPTracerEnabled then

                        pcall(function()

                            local startPosition =
                                Vector2.new(
                                    Camera.ViewportSize.X / 2,
                                    Camera.ViewportSize.Y
                                )

                            drawings.TracerShadow.From =
                                startPosition

                            drawings.TracerShadow.To =
                                Vector2.new(
                                    headPosition.X,
                                    headPosition.Y
                                )

                            drawings.TracerShadow.Visible =
                                true

                            drawings.Tracer.From =
                                startPosition

                            drawings.Tracer.To =
                                Vector2.new(
                                    headPosition.X,
                                    headPosition.Y
                                )

                            drawings.Tracer.Color =
                                Rainbow

                            drawings.Tracer.Visible =
                                true
                        end)

                    else
                        SetVisible(drawings.Tracer, false)
                        SetVisible(drawings.TracerShadow, false)
                    end

                    -- Name
                    if Settings.ESPNameEnabled then

                        pcall(function()

                            drawings.Name.Text =
                                player.Name

                            drawings.Name.Position =
                                Vector2.new(
                                    headPosition.X,
                                    headPosition.Y - 20
                                )

                            drawings.Name.Color = Rainbow
                            drawings.Name.Visible = true
                        end)

                    else
                        SetVisible(drawings.Name, false)
                    end

                else
                    hideESP(drawings)
                end

            else
                hideESP(drawings)
            end
        end

        --==========================================
        -- CAMLOCK
        --==========================================

        if Settings.CamlockEnabled then

            if LockedTarget
                and LockedTarget.Parent then

                local targetCharacter =
                    LockedTarget.Parent

                local humanoid =
                    targetCharacter:FindFirstChildOfClass(
                        "Humanoid"
                    )

                local targetPlayer =
                    Players:GetPlayerFromCharacter(
                        targetCharacter
                    )

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

                local isTeam =
                    Settings.TeamCheck
                    and targetPlayer
                    and targetPlayer.Team
                        == LocalPlayer.Team

                if not onScreen
                    or screenPosition.Z <= 0
                    or not humanoid
                    or humanoid.Health <= 0
                    or currentDistance > Settings.FOVSize
                    or isTeam then

                    LockedTarget = nil
                end

            else
                LockedTarget = GetTargetInFOV()
            end

            if LockedTarget then

                local targetCharacter =
                    LockedTarget.Parent

                if targetCharacter then

                    local targetPlayer =
                        Players:GetPlayerFromCharacter(
                            targetCharacter
                        )

                    if IsValidTarget(targetPlayer) then

                        local destination =
                            CFrame.new(
                                Camera.CFrame.Position,
                                LockedTarget.Position
                            )

                        local smoothness =
                            math.clamp(
                                Settings.Smoothness,
                                1,
                                100
                            )

                        local alpha =
                            smoothness / 100

                        Camera.CFrame =
                            Camera.CFrame:Lerp(
                                destination,
                                alpha
                            )
                    else
                        LockedTarget = nil
                    end
                else
                    LockedTarget = nil
                end
            end

        else
            LockedTarget = nil
        end
    end
)

--==================================================
-- CLEANUP
--==================================================

local function Cleanup()

    if Closed then
        return
    end

    Closed = true
    LockedTarget = nil

    -- Restore local character
    local character = LocalPlayer.Character

    if character then

        local humanoid =
            character:FindFirstChildOfClass("Humanoid")

        if humanoid then

            pcall(function()
                humanoid.WalkSpeed =
                    OriginalWalkSpeed
            end)

            if humanoid.UseJumpPower then
                pcall(function()
                    humanoid.JumpPower =
                        OriginalJumpPower
                end)
            end
        end
    end

    -- Restore collision
    for part, original in pairs(OriginalCollision) do

        if part and part.Parent then
            pcall(function()
                part.CanCollide = original
            end)
        end
    end

    OriginalCollision = {}

    -- Restore hitboxes
    for root, original in pairs(OriginalHitbox) do

        if root and root.Parent and original then

            pcall(function()

                root.Size = original.Size
                root.Transparency =
                    original.Transparency
                root.CanCollide =
                    original.CanCollide

            end)
        end
    end

    OriginalHitbox = {}

    -- Disconnect
    for _, connection in ipairs(Connections) do

        if typeof(connection)
            == "RBXScriptConnection" then

            pcall(function()
                connection:Disconnect()
            end)
        end
    end

    table.clear(Connections)

    -- Remove ESP
    for player in pairs(ESP) do
        removeESP(player)
    end

    table.clear(ESP)

    -- Remove FOV
    if FOVCircle then
        RemoveDrawing(FOVCircle)
        FOVCircle = nil
    end

    -- Remove UI
    pcall(function()
        ScreenGui:Destroy()
    end)
end

Connect(CloseBtn.MouseButton1Click, Cleanup)

--==================================================
-- READY
--==================================================

print("[CYBERPUNK HUD] Loaded successfully.")
