local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

getgenv().CamlockSettings = {
    Enabled = false,
    WallCheck = true,
    Smoothness = 85,
    FOVSize = 150,
    AimPart = "HumanoidRootPart"
}

local LockedTarget = nil
local UIHidden = false
local ESP = {}
local Rainbow = Color3.fromRGB(255, 0, 0)
local FOVCircle = nil

-- Rainbow ESP
task.spawn(function()
    local h = 0

    while task.wait() do
        h = (h + 1.5) % 360
        Rainbow = Color3.fromHSV(h / 360, 1, 1)
    end
end)

-- FOV Circle
pcall(function()
    FOVCircle = Drawing.new("Circle")

    FOVCircle.Visible = true
    FOVCircle.Filled = false
    FOVCircle.Thickness = 2
    FOVCircle.Color = Color3.fromRGB(0, 170, 255)
    FOVCircle.Radius = getgenv().CamlockSettings.FOVSize
    FOVCircle.Position = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )
end)

-- Create ESP
local function createESP(player)
    if player == LocalPlayer or ESP[player] then
        return
    end

    local success, drawings = pcall(function()
        return {
            Box = Drawing.new("Square"),
            BoxBG = Drawing.new("Square"),
            Tracer = Drawing.new("Line"),
            TracerShadow = Drawing.new("Line")
        }
    end)

    if not success or not drawings then
        return
    end

    ESP[player] = drawings

    local d = ESP[player]

    pcall(function()
        -- Box
        d.Box.Thickness = 2.5
        d.Box.Filled = false
        d.Box.Color = Color3.fromRGB(0, 210, 255)
        d.Box.Visible = false

        -- Box background
        d.BoxBG.Thickness = 1
        d.BoxBG.Filled = true
        d.BoxBG.Color = Color3.fromRGB(0, 210, 255)
        d.BoxBG.Transparency = 0.12
        d.BoxBG.Visible = false

        -- Tracer shadow
        d.TracerShadow.Thickness = 4.5
        d.TracerShadow.Color = Color3.fromRGB(0, 0, 0)
        d.TracerShadow.Visible = false

        -- Tracer
        d.Tracer.Thickness = 2
        d.Tracer.Visible = false
    end)
end

-- Remove ESP
local function removeESP(player)
    local d = ESP[player]

    if not d then
        return
    end

    for _, drawing in pairs(d) do
        pcall(function()
            drawing:Remove()
        end)
    end

    ESP[player] = nil
end

-- Create ESP for existing players
for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)

    if LockedTarget and LockedTarget.Parent == player.Character then
        LockedTarget = nil
    end
end)

-- Remove old GUI
pcall(function()
    local oldGui = LocalPlayer.PlayerGui:FindFirstChild("MegaCamlockGui")

    if oldGui then
        oldGui:Destroy()
    end
end)

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MegaCamlockGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 460)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopBar

local FixBar = Instance.new("Frame")
FixBar.Size = UDim2.new(1, 0, 0, 10)
FixBar.Position = UDim2.new(0, 0, 1, -10)
FixBar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
FixBar.BorderSizePixel = 0
FixBar.Parent = TopBar

-- Title
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -120, 1, 0)
TitleText.Position = UDim2.new(0, 20, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚡ ESP & ULTRA CAMLOCK"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TopBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()

    if FOVCircle then
        pcall(function()
            FOVCircle:Remove()
        end)

        FOVCircle = nil
    end

    for _, player in ipairs(Players:GetPlayers()) do
        removeESP(player)
    end
end)

-- Scrolling Container
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -30, 1, -75)
Container.Position = UDim2.new(0, 15, 0, 65)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 480)
Container.ScrollBarThickness = 6
Container.Parent = MainFrame

-- Toggle
local function CreateToggle(name, defaultState, yPos, callback)
    local Btn = Instance.new("TextButton")

    Btn.Size = UDim2.new(1, 0, 0, 45)
    Btn.Position = UDim2.new(0, 0, 0, yPos)
    Btn.BackgroundColor3 =
        defaultState
        and Color3.fromRGB(40, 160, 80)
        or Color3.fromRGB(45, 45, 60)

    Btn.Text = name .. ": " .. (defaultState and "ON" or "OFF")
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 15
    Btn.Font = Enum.Font.SourceSansBold
    Btn.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Btn

    local state = defaultState

    Btn.MouseButton1Click:Connect(function()
        state = not state

        Btn.BackgroundColor3 =
            state
            and Color3.fromRGB(40, 160, 80)
            or Color3.fromRGB(45, 45, 60)

        Btn.Text = name .. ": " .. (state and "ON" or "OFF")

        callback(state)
    end)

    return Btn
end

-- Slider
local function CreateSlider(name, yPos, initialVal, callback)
    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(1, 0, 0, 22)
    Label.Position = UDim2.new(0, 0, 0, yPos)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. initialVal
    Label.TextColor3 = Color3.fromRGB(200, 200, 220)
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local SliderBar = Instance.new("TextButton")

    SliderBar.Size = UDim2.new(1, 0, 0, 22)
    SliderBar.Position = UDim2.new(0, 0, 0, yPos + 24)
    SliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    SliderBar.Text = ""
    SliderBar.Parent = Container

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 6)
    BarCorner.Parent = SliderBar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(initialVal / 100, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 6)
    FillCorner.Parent = Fill

    local dragging = false

    SliderBar.InputBegan:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1
        then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1
        then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if
            dragging
            and (
                input.UserInputType == Enum.UserInputType.Touch
                or input.UserInputType == Enum.UserInputType.MouseMovement
            )
        then
            local pos = math.clamp(
                (input.Position.X - SliderBar.AbsolutePosition.X)
                    / SliderBar.AbsoluteSize.X,
                0,
                1
            )

            Fill.Size = UDim2.new(pos, 0, 1, 0)

            local val = math.floor(pos * 100)

            if val < 1 then
                val = 1
            end

            Label.Text = name .. ": " .. val

            callback(val)
        end
    end)
end

-- UI Controls
CreateToggle(
    "Camlock Status",
    getgenv().CamlockSettings.Enabled,
    10,
    function(state)
        getgenv().CamlockSettings.Enabled = state

        if not state then
            LockedTarget = nil
        end
    end
)

CreateToggle(
    "WallCheck (ทะลุกำแพง/ไม่ทะลุ)",
    getgenv().CamlockSettings.WallCheck,
    65,
    function(state)
        getgenv().CamlockSettings.WallCheck = state
    end
)

CreateSlider(
    "Lock Speed (ความเร็ว 1-100)",
    125,
    getgenv().CamlockSettings.Smoothness,
    function(val)
        getgenv().CamlockSettings.Smoothness = val
    end
)

CreateSlider(
    "FOV Circle Size",
    195,
    math.clamp(
        math.floor(getgenv().CamlockSettings.FOVSize / 3),
        1,
        100
    ),
    function(val)
        getgenv().CamlockSettings.FOVSize = val * 3

        if FOVCircle then
            FOVCircle.Radius = getgenv().CamlockSettings.FOVSize
        end
    end
)

-- Floating Toggle UI Button
local OpenCloseGuiBtn = Instance.new("TextButton")
OpenCloseGuiBtn.Size = UDim2.new(0, 130, 0, 45)
OpenCloseGuiBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
OpenCloseGuiBtn.BackgroundColor3 = Color3.fromRGB(30, 130, 255)
OpenCloseGuiBtn.Text = "Toggle UI"
OpenCloseGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenCloseGuiBtn.TextSize = 15
OpenCloseGuiBtn.Font = Enum.Font.SourceSansBold
OpenCloseGuiBtn.Active = true
OpenCloseGuiBtn.Draggable = true
OpenCloseGuiBtn.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 10)
FloatCorner.Parent = OpenCloseGuiBtn

OpenCloseGuiBtn.MouseButton1Click:Connect(function()
    UIHidden = not UIHidden
    MainFrame.Visible = not UIHidden
end)

-- Get closest target
local function GetClosestTargetInFOV()
    local closestTarget = nil
    local shortestDistance = getgenv().CamlockSettings.FOVSize

    local screenCenter = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    for _, player in ipairs(Players:GetPlayers()) do
        if
            player ~= LocalPlayer
            and player.Character
            and player.Character:FindFirstChild(
                getgenv().CamlockSettings.AimPart
            )
        then
            local humanoid =
                player.Character:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then
                local targetPart =
                    player.Character[getgenv().CamlockSettings.AimPart]

                -- WallCheck
                if getgenv().CamlockSettings.WallCheck then
                    local origin = Camera.CFrame.Position
                    local direction = targetPart.Position - origin

                    local raycastParams = RaycastParams.new()

                    raycastParams.FilterDescendantsInstances = {
                        LocalPlayer.Character,
                        player.Character
                    }

                    raycastParams.FilterType =
                        Enum.RaycastFilterType.Exclude

                    local result = workspace:Raycast(
                        origin,
                        direction,
                        raycastParams
                    )

                    if result then
                        continue
                    end
                end

                local screenPoint, onScreen =
                    Camera:WorldToViewportPoint(targetPart.Position)

                if onScreen and screenPoint.Z > 0 then
                    local mouseDist =
                        (
                            Vector2.new(screenPoint.X, screenPoint.Y)
                            - screenCenter
                        ).Magnitude

                    if mouseDist < shortestDistance then
                        shortestDistance = mouseDist
                        closestTarget = targetPart
                    end
                end
            end
        end
    end

    return closestTarget
end

-- Main Render Loop
RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera

    -- Update FOV
    if FOVCircle then
        pcall(function()
            FOVCircle.Position = Vector2.new(
                Camera.ViewportSize.X / 2,
                Camera.ViewportSize.Y / 2
            )

            FOVCircle.Radius =
                getgenv().CamlockSettings.FOVSize
        end)
    end

    -- ESP
    for player, d in pairs(ESP) do
        local character = player.Character

        local humanoid =
            character
            and character:FindFirstChildOfClass("Humanoid")

        local root =
            character
            and character:FindFirstChild("HumanoidRootPart")

        local head =
            character
            and character:FindFirstChild("Head")

        if
            humanoid
            and root
            and head
            and humanoid.Health > 0
        then
            local headPos, headOnScreen =
                Camera:WorldToViewportPoint(
                    head.Position + Vector3.new(0, 0.5, 0)
                )

            local legPos =
                Camera:WorldToViewportPoint(
                    root.Position - Vector3.new(0, 3, 0)
                )

            if headOnScreen and headPos.Z > 0 then
                local height =
                    math.abs(headPos.Y - legPos.Y)

                local width = height / 1.55

                local size =
                    Vector2.new(width, height)

                local position =
                    Vector2.new(
                        headPos.X - width / 2,
                        headPos.Y
                    )

                pcall(function()
                    -- Box
                    d.Box.Size = size
                    d.Box.Position = position
                    d.Box.Color = Rainbow
                    d.Box.Visible = true

                    -- Background
                    d.BoxBG.Size = size
                    d.BoxBG.Position = position
                    d.BoxBG.Color = Rainbow
                    d.BoxBG.Visible = true

                    -- Tracer
                    local screenTop =
                        Vector2.new(
                            Camera.ViewportSize.X / 2,
                            0
                        )

                    local target =
                        Vector2.new(
                            headPos.X,
                            headPos.Y
                        )

                    d.TracerShadow.From = screenTop
                    d.TracerShadow.To = target
                    d.TracerShadow.Visible = true

                    d.Tracer.From = screenTop
                    d.Tracer.To = target
                    d.Tracer.Color = Rainbow
                    d.Tracer.Visible = true
                end)
            else
                pcall(function()
                    d.Box.Visible = false
                    d.BoxBG.Visible = false
                    d.Tracer.Visible = false
                    d.TracerShadow.Visible = false
                end)
            end
        else
            pcall(function()
                d.Box.Visible = false
                d.BoxBG.Visible = false
                d.Tracer.Visible = false
                d.TracerShadow.Visible = false
            end)
        end
    end

    -- Camlock
    if getgenv().CamlockSettings.Enabled then
        -- Find target if current target is invalid
        if
            not LockedTarget
            or not LockedTarget.Parent
            or (
                LockedTarget.Parent:FindFirstChildOfClass("Humanoid")
                and LockedTarget.Parent:FindFirstChildOfClass("Humanoid").Health <= 0
            )
        then
            LockedTarget = GetClosestTargetInFOV()
        end

        if LockedTarget and LockedTarget.Parent then
            local targetCFrame =
                CFrame.new(
                    Camera.CFrame.Position,
                    LockedTarget.Position
                )

            local speedVal =
                getgenv().CamlockSettings.Smoothness

            if speedVal >= 100 then
                Camera.CFrame = targetCFrame
            else
                local alpha =
                    math.clamp(
                        speedVal / 100,
                        0.01,
                        1
                    )

                Camera.CFrame =
                    Camera.CFrame:Lerp(
                        targetCFrame,
                        alpha
                    )
            end
        end
    else
        LockedTarget = nil
    end
end)
