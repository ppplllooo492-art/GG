local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

getgenv().ModSettings = {
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

local LockedTarget = nil
local UIHidden = false
local ESP = {}
local Rainbow = Color3.fromRGB(255, 0, 0)
local FOVCircle = nil
local Connections = {}
local Closed = false

-- Rainbow
table.insert(Connections, task.spawn(function()
    local h = 0

    while not Closed do
        task.wait()
        h = (h + 1.5) % 360
        Rainbow = Color3.fromHSV(h / 360, 1, 1)
    end
end))

-- FOV Circle
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

-- ESP
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

table.insert(Connections, Players.PlayerAdded:Connect(createESP))
table.insert(Connections, Players.PlayerRemoving:Connect(removeESP))

-- Remove old UI
pcall(function()
    local old = LocalPlayer.PlayerGui:FindFirstChild("CyberHudGui")
    if old then
        old:Destroy()
    end
end)

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyberHudGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
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

-- Top Bar
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

-- Title
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

-- Close Button
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

-- Container
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -62)
Container.Position = UDim2.new(0, 10, 0, 56)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 880)
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

-- Toggle
local function CreateToggle(name, default, y, callback)
    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1, -10, 0, 42)
    button.Position = UDim2.new(0, 5, 0, y)
    button.BackgroundColor3 = default
        and Color3.fromRGB(0, 180, 120)
        or Color3.fromRGB(22, 22, 32)

    button.Text = "  " .. name .. " [ " .. (default and "ACTIVE" or "OFF") .. " ]"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    local state = default

    table.insert(Connections, button.MouseButton1Click:Connect(function()
        state = not state

        button.BackgroundColor3 = state
            and Color3.fromRGB(0, 180, 120)
            or Color3.fromRGB(22, 22, 32)

        button.Text = "  " .. name .. " [ " .. (state and "ACTIVE" or "OFF") .. " ]"

        callback(state)
    end))

    return button
end

-- Slider
local function CreateSlider(name, y, minValue, maxValue, value, callback)
    local label = Instance.new("TextLabel")

    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, y)
    label.BackgroundTransparency = 1
    label.Text = "  " .. name .. ": " .. value
    label.TextColor3 = Color3.fromRGB(180, 180, 200)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = Container

    local bar = Instance.new("TextButton")
    bar.Size = UDim2.new(1, -10, 0, 18)
    bar.Position = UDim2.new(0, 5, 0, y + 20)
    bar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    bar.Text = ""
    bar.AutoButtonColor = false
    bar.Parent = Container

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 6)
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
    fillCorner.CornerRadius = UDim.new(0, 6)
    fillCorner.Parent = fill

    local dragging = false

    table.insert(Connections, bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end))

    table.insert(Connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    table.insert(Connections, UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local position = math.clamp(
            (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
            0,
            1
        )

        fill.Size = UDim2.new(position, 0, 1, 0)

        local result = math.floor(
            minValue + position * (maxValue - minValue)
        )

        label.Text = "  " .. name .. ": " .. result
        callback(result)
    end))
end

-- UI Controls
CreateToggle(
    "Camlock (ระบบล็อคเป้า)",
    Settings.CamlockEnabled,
    10,
    function(state)
        Settings.CamlockEnabled = state
    end
)

CreateToggle(
    "WallCheck (เช็คสิ่งกีดขวาง/กำแพง)",
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
    "ESP Tracer (เส้นลากหัว)",
    Settings.ESPTracerEnabled,
    326,
    function(state)
        Settings.ESPTracerEnabled = state
    end
)

CreateToggle(
    "ESP Name (แสดงชื่อบนหัว)",
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
    "WalkSpeed (ความเร็ววิ่ง 16-250)",
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
    "JumpPower (พลังกระโดด 50-400)",
    580,
    50,
    400,
    Settings.JumpPowerVal,
    function(value)
        Settings.JumpPowerVal = value
    end
)

CreateToggle(
    "Hitbox Expander (ขยายตัวละคร)",
    Settings.HitboxEnabled,
    642,
    function(state)
        Settings.HitboxEnabled = state
    end
)

CreateToggle(
    "NoClip (เดินทะลุกำแพง)",
    Settings.NoClipEnabled,
    690,
    function(state)
        Settings.NoClipEnabled = state
    end
)

CreateToggle(
    "Infinite Jump (กระโดดกลางอากาศ)",
    Settings.InfiniteJump,
    738,
    function(state)
        Settings.InfiniteJump = state
    end
)

-- Floating Menu Button
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
FloatBtn.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 8)
FloatCorner.Parent = FloatBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(0, 255, 170)
FloatStroke.Thickness = 1
FloatStroke.Parent = FloatBtn

table.insert(Connections, FloatBtn.MouseButton1Click:Connect(function()
    UIHidden = not UIHidden
    MainFrame.Visible = not UIHidden
end))

-- Infinite Jump
table.insert(Connections, UserInputService.JumpRequest:Connect(function()
    if not Settings.InfiniteJump then
        return
    end

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

-- Get target
local function GetTargetInFOV()
    local target = nil
    local shortestDistance = Settings.FOVSize

    Camera = Workspace.CurrentCamera

    local center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then
            continue
        end

        if not player.Character then
            continue
        end

        local part = player.Character:FindFirstChild(Settings.AimPart)

        if not part then
            continue
        end

        if Settings.TeamCheck and player.Team == LocalPlayer.Team then
            continue
        end

        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

        if not humanoid or humanoid.Health <= 0 then
            continue
        end

        -- Wall check
        if Settings.WallCheck then
            local origin = Camera.CFrame.Position
            local direction = part.Position - origin

            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {
                LocalPlayer.Character
            }
            params.IgnoreWater = true

            local result = Workspace:Raycast(
                origin,
                direction,
                params
            )

            if result and not result.Instance:IsDescendantOf(player.Character) then
                continue
            end
        end

        local screenPosition, onScreen =
            Camera:WorldToViewportPoint(part.Position)

        if not onScreen or screenPosition.Z <= 0 then
            continue
        end

        local distance = (
            Vector2.new(screenPosition.X, screenPosition.Y) - center
        ).Magnitude

        if distance <= shortestDistance then
            shortestDistance = distance
            target = part
        end
    end

    return target
end

-- Main loop
table.insert(Connections, RunService.RenderStepped:Connect(function()
    if Closed then
        return
    end

    Camera = Workspace.CurrentCamera

    -- FOV
    if FOVCircle then
        pcall(function()
            FOVCircle.Position = Vector2.new(
                Camera.ViewportSize.X / 2,
                Camera.ViewportSize.Y / 2
            )

            FOVCircle.Radius = Settings.FOVSize
        end)
    end

    local character = LocalPlayer.Character

    -- Local player settings
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

        -- NoClip
        if Settings.NoClipEnabled then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end

    -- Hitbox
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer
            and player.Character
            and player.Character:FindFirstChild("HumanoidRootPart") then

            local root = player.Character.HumanoidRootPart

            if Settings.HitboxEnabled then
                if Settings.TeamCheck and player.Team == LocalPlayer.Team then
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 0
                else
                    root.Size = Vector3.new(
                        Settings.HitboxSize,
                        Settings.HitboxSize,
                        Settings.HitboxSize
                    )
                    root.Transparency = 0.7
                    root.CanCollide = false
                end
            else
                root.Size = Vector3.new(2, 2, 1)
                root.Transparency = 0
            end
        end
    end

    -- ESP
    for player, drawings in pairs(ESP) do
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")

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
                local height = math.abs(headPosition.Y - rootPosition.Y)
                local width = height / 1.6

                -- Box
                if Settings.ESPBoxEnabled then
                    drawings.Box.Size = Vector2.new(width, height)
                    drawings.Box.Position = Vector2.new(
                        headPosition.X - width / 2,
                        headPosition.Y
                    )
                    drawings.Box.Color = Rainbow
                    drawings.Box.Visible = true

                    drawings.BoxBG.Size = Vector2.new(width, height)
                    drawings.BoxBG.Position = Vector2.new(
                        headPosition.X - width / 2,
                        headPosition.Y
                    )
                    drawings.BoxBG.Color = Rainbow
                    drawings.BoxBG.Visible = true
                else
                    drawings.Box.Visible = false
                    drawings.BoxBG.Visible = false
                end

                -- Tracer
                if Settings.ESPTracerEnabled then
                    local startPosition = Vector2.new(
                        Camera.ViewportSize.X / 2,
                        0
                    )

                    drawings.TracerShadow.From = startPosition
                    drawings.TracerShadow.To = Vector2.new(
                        headPosition.X,
                        headPosition.Y
                    )
                    drawings.TracerShadow.Visible = true

                    drawings.Tracer.From = startPosition
                    drawings.Tracer.To = Vector2.new(
                        headPosition.X,
                        headPosition.Y
                    )
                    drawings.Tracer.Color = Rainbow
                    drawings.Tracer.Visible = true
                else
                    drawings.Tracer.Visible = false
                    drawings.TracerShadow.Visible = false
                end

                -- Name
                if Settings.ESPNameEnabled then
                    drawings.Name.Text = player.Name
                    drawings.Name.Position = Vector2.new(
                        headPosition.X,
                        headPosition.Y - 20
                    )
                    drawings.Name.Color = Rainbow
                    drawings.Name.Visible = true
                else
                    drawings.Name.Visible = false
                end
            else
                drawings.Box.Visible = false
                drawings.BoxBG.Visible = false
                drawings.Tracer.Visible = false
                drawings.TracerShadow.Visible = false
                drawings.Name.Visible = false
            end
        else
            drawings.Box.Visible = false
            drawings.BoxBG.Visible = false
            drawings.Tracer.Visible = false
            drawings.TracerShadow.Visible = false
            drawings.Name.Visible = false
        end
    end

    -- Camlock
    if Settings.CamlockEnabled then
        if LockedTarget and LockedTarget.Parent then
            local targetCharacter = LockedTarget.Parent
            local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
            local player = Players:GetPlayerFromCharacter(targetCharacter)

            local center = Vector2.new(
                Camera.ViewportSize.X / 2,
                Camera.ViewportSize.Y / 2
            )

            local screenPosition, onScreen =
                Camera:WorldToViewportPoint(LockedTarget.Position)

            local currentDistance = (
                Vector2.new(screenPosition.X, screenPosition.Y) - center
            ).Magnitude

            local isTeam =
                Settings.TeamCheck
                and player
                and player.Team == LocalPlayer.Team

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
            local destination =
                CFrame.new(
                    Camera.CFrame.Position,
                    LockedTarget.Position
                )

            local smoothness = Settings.Smoothness

            if smoothness >= 100 then
                Camera.CFrame = destination
            else
                Camera.CFrame = Camera.CFrame:Lerp(
                    destination,
                    math.clamp(smoothness / 100, 0.01, 1)
                )
            end
        end
    else
        LockedTarget = nil
    end
end))

-- Close / Cleanup
local function Cleanup()
    if Closed then
        return
    end

    Closed = true
    LockedTarget = nil

    for _, connection in ipairs(Connections) do
        pcall(function()
            if typeof(connection) == "RBXScriptConnection" then
                connection:Disconnect()
            end
        end)
    end

    for player in pairs(ESP) do
        removeESP(player)
    end

    if FOVCircle then
        pcall(function()
            FOVCircle:Remove()
        end)

        FOVCircle = nil
    end

    pcall(function()
        ScreenGui:Destroy()
    end)
end

table.insert(Connections, CloseBtn.MouseButton1Click:Connect(Cleanup))
