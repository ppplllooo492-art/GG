--// .GG.BR ULTIMATE MOBILE EDITION
--// Clean / Fixed Version

local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

if not Camera then
    workspace:GetPropertyChangedSignal("CurrentCamera"):Wait()
    Camera = workspace.CurrentCamera
end

--==================================================
-- SETTINGS
--==================================================

_G.GGBR_Settings = _G.GGBR_Settings or {
    Aim = false,
    Head = false,
    ESP = false,

    FOV = 130,
    Smoothness = 1.8,

    LockFOV = true,

    CenterPos = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )
}

local S = _G.GGBR_Settings

--==================================================
-- COLORS
--==================================================

local RainbowColor = Color3.fromRGB(255, 0, 0)

task.spawn(function()
    local hue = 0

    while task.wait() do
        hue = (hue + 1.5) % 360
        RainbowColor = Color3.fromHSV(hue / 360, 1, 1)
    end
end)

--==================================================
-- DRAWING CHECK
--==================================================

local DrawingAvailable = pcall(function()
    return Drawing.new("Circle")
end)

if not DrawingAvailable then
    warn("[.GG.BR] Drawing API is not available in this executor.")
end

--==================================================
-- FOV CIRCLE
--==================================================

local FOV_Ring

if DrawingAvailable then
    FOV_Ring = Drawing.new("Circle")

    FOV_Ring.Thickness = 2
    FOV_Ring.NumSides = 64
    FOV_Ring.Radius = S.FOV
    FOV_Ring.Filled = false
    FOV_Ring.Color = Color3.fromRGB(0, 0, 0)
    FOV_Ring.Visible = true
end

--==================================================
-- UTILITY
--==================================================

local function getCharacter(player)
    if not player then
        return nil
    end

    local character = player.Character

    if not character then
        return nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then
        return nil
    end

    if humanoid.Health <= 0 then
        return nil
    end

    return character, humanoid, root
end

local function getTargetPart(player)
    local character = getCharacter(player)

    if not character then
        return nil
    end

    if S.Head then
        return character:FindFirstChild("Head")
            or character:FindFirstChild("HumanoidRootPart")
    end

    return character:FindFirstChild("HumanoidRootPart")
end

--==================================================
-- VISIBILITY CHECK
--==================================================

local function checkPlayerVisibility(targetPlayer)
    local character, _, root = getCharacter(targetPlayer)

    if not character or not root then
        return false
    end

    local origin = Camera.CFrame.Position
    local direction = root.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {
        LocalPlayer.Character,
        character
    }
    params.IgnoreWater = true

    local result = workspace:Raycast(
        origin,
        direction,
        params
    )

    return result == nil
end

--==================================================
-- TARGET SCANNER
--==================================================

local function scanValidTarget()
    local bestTarget = nil
    local shortestDistance = S.FOV

    local center = S.CenterPos

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then

            local character, humanoid = getCharacter(player)

            if character and humanoid then

                local targetPart = getTargetPart(player)

                if targetPart and checkPlayerVisibility(player) then

                    local screenPosition, onScreen =
                        Camera:WorldToViewportPoint(targetPart.Position)

                    if onScreen and screenPosition.Z > 0 then

                        local screenVector = Vector2.new(
                            screenPosition.X,
                            screenPosition.Y
                        )

                        local distance =
                            (screenVector - center).Magnitude

                        if distance < shortestDistance then
                            shortestDistance = distance
                            bestTarget = player
                        end
                    end
                end
            end
        end
    end

    return bestTarget
end

--==================================================
-- ESP STORAGE
--==================================================

local ESP_Storage = {}

local function createDrawingObjects()
    if not DrawingAvailable then
        return nil
    end

    local objects = {}

    objects.Box = Drawing.new("Square")
    objects.BoxBG = Drawing.new("Square")

    objects.Tracer = Drawing.new("Line")
    objects.TracerShadow = Drawing.new("Line")

    objects.Box.Thickness = 2.5
    objects.Box.Filled = false
    objects.Box.Color = Color3.fromRGB(0, 210, 255)

    objects.BoxBG.Thickness = 1
    objects.BoxBG.Filled = true
    objects.BoxBG.Color = Color3.fromRGB(0, 210, 255)
    objects.BoxBG.Transparency = 0.12

    objects.Tracer.Thickness = 2

    objects.TracerShadow.Thickness = 4.5
    objects.TracerShadow.Color = Color3.fromRGB(0, 0, 0)

    objects.Box.Visible = false
    objects.BoxBG.Visible = false
    objects.Tracer.Visible = false
    objects.TracerShadow.Visible = false

    return objects
end

local function hideESP(data)
    if not data then
        return
    end

    data.Box.Visible = false
    data.BoxBG.Visible = false
    data.Tracer.Visible = false
    data.TracerShadow.Visible = false
end

local function removeESP(player)
    local data = ESP_Storage[player]

    if not data then
        return
    end

    pcall(function()
        data.Box:Remove()
        data.BoxBG:Remove()
        data.Tracer:Remove()
        data.TracerShadow:Remove()
    end)

    ESP_Storage[player] = nil
end

local function registerESP(player)
    if player == LocalPlayer then
        return
    end

    if ESP_Storage[player] then
        return
    end

    local objects = createDrawingObjects()

    if objects then
        ESP_Storage[player] = objects
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    registerESP(player)
end

Players.PlayerAdded:Connect(function(player)
    registerESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

--==================================================
-- UPDATE ESP
--==================================================

local function updateESP(player, data)
    if not S.ESP then
        hideESP(data)
        return
    end

    local character, humanoid, root = getCharacter(player)

    if not character or not humanoid or not root then
        hideESP(data)
        return
    end

    local head = character:FindFirstChild("Head")

    if not head then
        hideESP(data)
        return
    end

    local headPosition, headVisible =
        Camera:WorldToViewportPoint(
            head.Position + Vector3.new(0, 0.5, 0)
        )

    local legPosition =
        Camera:WorldToViewportPoint(
            root.Position - Vector3.new(0, 3, 0)
        )

    if not headVisible or headPosition.Z <= 0 then
        hideESP(data)
        return
    end

    local height = math.abs(
        headPosition.Y - legPosition.Y
    )

    if height <= 1 then
        hideESP(data)
        return
    end

    local width = height / 1.55

    local boxSize = Vector2.new(
        width,
        height
    )

    local boxPosition = Vector2.new(
        headPosition.X - width / 2,
        headPosition.Y
    )

    data.Box.Size = boxSize
    data.Box.Position = boxPosition
    data.Box.Visible = true

    data.BoxBG.Size = boxSize
    data.BoxBG.Position = boxPosition
    data.BoxBG.Visible = true

    local screenStart = Vector2.new(
        Camera.ViewportSize.X / 2,
        0
    )

    local targetPosition = Vector2.new(
        headPosition.X,
        headPosition.Y
    )

    data.TracerShadow.From = screenStart
    data.TracerShadow.To = targetPosition
    data.TracerShadow.Visible = true

    data.Tracer.From = screenStart
    data.Tracer.To = targetPosition
    data.Tracer.Color = RainbowColor
    data.Tracer.Visible = true
end

--==================================================
-- MAIN RENDER LOOP
--==================================================

RunService.RenderStepped:Connect(function()

    if not Camera then
        Camera = workspace.CurrentCamera
    end

    if not Camera then
        return
    end

    if S.LockFOV then
        S.CenterPos = Vector2.new(
            Camera.ViewportSize.X / 2,
            Camera.ViewportSize.Y / 2
        )
    end

    -- FOV
    if FOV_Ring then

        FOV_Ring.Position = S.CenterPos
        FOV_Ring.Radius = S.FOV

        if S.Aim then
            FOV_Ring.Radius =
                math.max(
                    S.FOV - 15,
                    FOV_Ring.Radius - 1.8
                )
        end
    end

    -- AIM
    if S.Aim then

        local targetPlayer = scanValidTarget()

        local targetPart =
            targetPlayer and getTargetPart(targetPlayer)

        if targetPart then

            local smoothness =
                math.max(1, tonumber(S.Smoothness) or 1)

            local alpha =
                math.clamp(1 / smoothness, 0.01, 1)

            local desiredCFrame =
                CFrame.new(
                    Camera.CFrame.Position,
                    targetPart.Position
                )

            Camera.CFrame =
                Camera.CFrame:Lerp(
                    desiredCFrame,
                    alpha
                )
        end
    end

    -- ESP
    for player, data in pairs(ESP_Storage) do
        updateESP(player, data)
    end
end)

--==================================================
-- FOV TOUCH DRAG
--==================================================

local screenTouchActive = false

UserInputService.InputBegan:Connect(function(input, processed)

    if processed then
        return
    end

    local isPointer =
        input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch

    if not isPointer then
        return
    end

    if S.LockFOV then
        return
    end

    local position = Vector2.new(
        input.Position.X,
        input.Position.Y
    )

    local distance =
        (position - S.CenterPos).Magnitude

    if distance <= S.FOV then
        screenTouchActive = true
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not screenTouchActive then
        return
    end

    local isMovement =
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch

    if not isMovement then
        return
    end

    S.CenterPos = Vector2.new(
        input.Position.X,
        input.Position.Y
    )
end)

UserInputService.InputEnded:Connect(function(input)

    local isPointer =
        input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch

    if isPointer then
        screenTouchActive = false
    end
end)

--==================================================
-- SCREEN GUI
--==================================================

local ScreenUI = Instance.new("ScreenGui")

ScreenUI.Name = "GGBR_MobileRoot"
ScreenUI.ResetOnSpawn = false
ScreenUI.IgnoreGuiInset = false

local guiSuccess = pcall(function()
    ScreenUI.Parent = CoreGui
end)

if not guiSuccess or not ScreenUI.Parent then
    ScreenUI.Parent =
        LocalPlayer:WaitForChild("PlayerGui")
end

--==================================================
-- WINDOW CREATOR
--==================================================

local function generateBaseWindow(
    headerName,
    basePosition,
    verticalDimension
)

    local frameObject = Instance.new("Frame")

    frameObject.Size =
        UDim2.new(0, 230, 0, verticalDimension)

    frameObject.Position = basePosition

    frameObject.BackgroundColor3 =
        Color3.fromRGB(10, 11, 16)

    frameObject.BorderSizePixel = 0
    frameObject.Active = true

    -- Draggable still works on supported Roblox environments.
    frameObject.Draggable = true

    local designCorner = Instance.new("UICorner")
    designCorner.CornerRadius = UDim.new(0, 10)
    designCorner.Parent = frameObject

    local neonOutline = Instance.new("UIStroke")

    neonOutline.Thickness = 2
    neonOutline.Color = Color3.fromRGB(0, 210, 255)
    neonOutline.Parent = frameObject

    task.spawn(function()
        while frameObject.Parent do
            task.wait(0.03)

            if neonOutline.Parent then
                neonOutline.Color = RainbowColor
            end
        end
    end)

    local windowLabel = Instance.new("TextLabel")

    windowLabel.Size =
        UDim2.new(1, -10, 0, 32)

    windowLabel.Position =
        UDim2.new(0, 10, 0, 2)

    windowLabel.BackgroundTransparency = 1

    windowLabel.Text =
        "⚡ " .. headerName .. "  [.GG.BR]"

    windowLabel.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    windowLabel.Font =
        Enum.Font.GothamBold

    windowLabel.TextSize = 11
    windowLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    windowLabel.Parent = frameObject

    frameObject.Parent = ScreenUI

    return frameObject
end

--==================================================
-- TOGGLE
--==================================================

local function attachToggleAction(
    targetFrame,
    descriptiveText,
    internalKey,
    verticalOffset
)

    local toggleButton = Instance.new("TextButton")

    toggleButton.Size =
        UDim2.new(0.92, 0, 0, 32)

    toggleButton.Position =
        UDim2.new(0.04, 0, 0, verticalOffset)

    toggleButton.BackgroundColor3 =
        Color3.fromRGB(15, 16, 22)

    toggleButton.BackgroundTransparency = 0.25

    toggleButton.Text =
        "     [ ]  " .. descriptiveText

    toggleButton.TextColor3 =
        Color3.fromRGB(140, 150, 170)

    toggleButton.Font =
        Enum.Font.GothamSemibold

    toggleButton.TextSize = 11
    toggleButton.TextXAlignment =
        Enum.TextXAlignment.Left

    toggleButton.AutoButtonColor = false
    toggleButton.ZIndex = 2

    local toggleCorner = Instance.new("UICorner")

    toggleCorner.CornerRadius =
        UDim.new(0, 8)

    toggleCorner.Parent = toggleButton

    local interactionStroke =
        Instance.new("UIStroke")

    interactionStroke.Thickness = 1.5

    interactionStroke.Color =
        Color3.fromRGB(32, 34, 44)

    interactionStroke.Parent = toggleButton

    local function redrawToggleButton()

        local active =
            S[internalKey] == true

        TweenService:Create(
            toggleButton,
            TweenInfo.new(0.22),
            {
                BackgroundColor3 =
                    active
                    and Color3.fromRGB(15, 35, 45)
                    or Color3.fromRGB(15, 16, 22),

                TextColor3 =
                    active
                    and Color3.fromRGB(0, 255, 200)
                    or Color3.fromRGB(140, 150, 170)
            }
        ):Play()

        TweenService:Create(
            interactionStroke,
            TweenInfo.new(0.22),
            {
                Color =
                    active
                    and Color3.fromRGB(0, 255, 200)
                    or Color3.fromRGB(32, 34, 44)
            }
        ):Play()

        toggleButton.Text =
            "     "
            .. (active and "[✓]" or "[ ]")
            .. "  "
            .. descriptiveText
    end

    toggleButton.Activated:Connect(function()

        S[internalKey] =
            not S[internalKey]

        redrawToggleButton()
    end)

    redrawToggleButton()

    toggleButton.Parent = targetFrame
end

--==================================================
-- SLIDER
--==================================================

local function attachSliderAction(
    targetFrame,
    descriptiveText,
    internalKey,
    absoluteMin,
    absoluteMax,
    verticalOffset
)

    local sliderBackground = Instance.new("Frame")

    sliderBackground.Size =
        UDim2.new(0.92, 0, 0, 42)

    sliderBackground.Position =
        UDim2.new(0.04, 0, 0, verticalOffset)

    sliderBackground.BackgroundColor3 =
        Color3.fromRGB(15, 16, 22)

    sliderBackground.BackgroundTransparency = 0.25

    local panelCorner = Instance.new("UICorner")

    panelCorner.CornerRadius =
        UDim.new(0, 8)

    panelCorner.Parent = sliderBackground

    local panelStroke = Instance.new("UIStroke")

    panelStroke.Thickness = 1.5
    panelStroke.Color =
        Color3.fromRGB(32, 34, 44)

    panelStroke.Parent = sliderBackground

    local numericLabel = Instance.new("TextLabel")

    numericLabel.Size =
        UDim2.new(1, -10, 0, 18)

    numericLabel.Position =
        UDim2.new(0, 8, 0, 2)

    numericLabel.BackgroundTransparency = 1

    numericLabel.Text =
        descriptiveText
        .. ": "
        .. tostring(S[internalKey])

    numericLabel.TextColor3 =
        Color3.fromRGB(180, 190, 210)

    numericLabel.Font =
        Enum.Font.GothamSemibold

    numericLabel.TextSize = 10

    numericLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    numericLabel.Parent = sliderBackground

    local interactiveTrack =
        Instance.new("TextButton")

    interactiveTrack.Size =
        UDim2.new(0.92, 0, 0, 10)

    interactiveTrack.Position =
        UDim2.new(0.04, 0, 0, 24)

    interactiveTrack.BackgroundColor3 =
        Color3.fromRGB(30, 35, 48)

    interactiveTrack.BorderSizePixel = 0
    interactiveTrack.Text = ""

    local trackCorner = Instance.new("UICorner")

    trackCorner.CornerRadius =
        UDim.new(0, 4)

    trackCorner.Parent = interactiveTrack

    local progressBarFill =
        Instance.new("Frame")

    progressBarFill.BackgroundColor3 =
        Color3.fromRGB(0, 255, 200)

    progressBarFill.BorderSizePixel = 0

    local progressCorner =
        Instance.new("UICorner")

    progressCorner.CornerRadius =
        UDim.new(0, 4)

    progressCorner.Parent =
        progressBarFill

    progressBarFill.Parent =
        interactiveTrack

    interactiveTrack.Parent =
        sliderBackground

    local activelyDraggingSlider = false

    local function updateSlider(inputPosition)

        local trackPosition =
            interactiveTrack.AbsolutePosition

        local trackSize =
            interactiveTrack.AbsoluteSize

        if trackSize.X <= 0 then
            return
        end

        local ratio =
            (inputPosition.X - trackPosition.X)
            / trackSize.X

        ratio = math.clamp(ratio, 0, 1)

        local value =
            absoluteMin
            + (absoluteMax - absoluteMin) * ratio

        value =
            math.floor(value * 10 + 0.5) / 10

        S[internalKey] = value

        progressBarFill.Size =
            UDim2.new(ratio, 0, 1, 0)

        numericLabel.Text =
            descriptiveText
            .. ": "
            .. tostring(value)
    end

    interactiveTrack.Activated:Connect(function(input)

        local position

        if input and input.Position then
            position = Vector2.new(
                input.Position.X,
                input.Position.Y
            )
        else
            position = UserInputService:GetMouseLocation()
        end

        updateSlider(position)
    end)

    interactiveTrack.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            activelyDraggingSlider = true

            updateSlider(
                Vector2.new(
                    input.Position.X,
                    input.Position.Y
                )
            )
        end
    end)

    interactiveTrack.InputEnded:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            activelyDraggingSlider = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)

        if not activelyDraggingSlider then
            return
        end

        local validInput =
            input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or input.UserInputType ==
            Enum.UserInputType.Touch

        if validInput then

            updateSlider(
                Vector2.new(
                    input.Position.X,
                    input.Position.Y
                )
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            activelyDraggingSlider = false
        end
    end)

    local initialRatio =
        math.clamp(
            (S[internalKey] - absoluteMin)
            / (absoluteMax - absoluteMin),
            0,
            1
        )

    progressBarFill.Size =
        UDim2.new(initialRatio, 0, 1, 0)

    sliderBackground.Parent = targetFrame
end

--==================================================
-- WINDOWS
--==================================================

local WinAim = generateBaseWindow(
    "AIMBOT LOCK",
    UDim2.new(0.05, 0, 0.2, 0),
    165
)

attachToggleAction(
    WinAim,
    "เปิดระบบ ล็อคเป้า (Aimbot)",
    "Aim",
    40
)

attachToggleAction(
    WinAim,
    "สลับล็อกหัว (เปิด=หัว/ตัว)",
    "Head",
    78
)

attachSliderAction(
    WinAim,
    "ความสมูท (Smoothness)",
    "Smoothness",
    1,
    5,
    116
)

--==================================================

local WinESP = generateBaseWindow(
    "ESP WALL VISION",
    UDim2.new(0.7, 0, 0.2, 0),
    90
)

attachToggleAction(
    WinESP,
    "เปิดระบบ มองทะลุ (ESP)",
    "ESP",
    40
)

--==================================================

local WinFOV = generateBaseWindow(
    "FOV SETTING",
    UDim2.new(0.38, 0, 0.65, 0),
    165
)

attachToggleAction(
    WinFOV,
    "ล็อกวงกลมกลางจอ",
    "LockFOV",
    40
)

attachSliderAction(
    WinFOV,
    "ขนาดวงกลม (FOV Radius)",
    "FOV",
    40,
    400,
    78
)

--==================================================
-- RESET FOV BUTTON
--==================================================

local CenterResetButton =
    Instance.new("TextButton")

CenterResetButton.Size =
    UDim2.new(0.92, 0, 0, 32)

CenterResetButton.Position =
    UDim2.new(0.04, 0, 0, 124)

CenterResetButton.BackgroundColor3 =
    Color3.fromRGB(35, 15, 20)

CenterResetButton.BorderSizePixel = 0

CenterResetButton.Text =
    "🔄 รีเซ็ตวงกลมกลับมากลางจอ"

CenterResetButton.TextColor3 =
    Color3.fromRGB(255, 100, 100)

CenterResetButton.Font =
    Enum.Font.GothamBold

CenterResetButton.TextSize = 11

CenterResetButton.AutoButtonColor = false

local customButtonCorner =
    Instance.new("UICorner")

customButtonCorner.CornerRadius =
    UDim.new(0, 8)

customButtonCorner.Parent =
    CenterResetButton

local customButtonStroke =
    Instance.new("UIStroke")

customButtonStroke.Thickness = 1.5

customButtonStroke.Color =
    Color3.fromRGB(80, 30, 44)

customButtonStroke.Parent =
    CenterResetButton

CenterResetButton.Activated:Connect(function()

    S.CenterPos = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    TweenService:Create(
        CenterResetButton,
        TweenInfo.new(0.1),
        {
            BackgroundColor3 =
                Color3.fromRGB(60, 20, 30)
        }
    ):Play()

    task.wait(0.1)

    if CenterResetButton.Parent then

        TweenService:Create(
            CenterResetButton,
            TweenInfo.new(0.1),
            {
                BackgroundColor3 =
                    Color3.fromRGB(35, 15, 20)
            }
        ):Play()
    end
end)

CenterResetButton.Parent = WinFOV

--==================================================
-- TOGGLE UI
-- INSERT / RIGHT SHIFT
--==================================================

UserInputService.InputBegan:Connect(function(
    input,
    processed
)

    if processed then
        return
    end

    if input.KeyCode == Enum.KeyCode.Insert
        or input.KeyCode == Enum.KeyCode.RightShift then

        WinAim.Visible =
            not WinAim.Visible

        WinESP.Visible =
            not WinESP.Visible

        WinFOV.Visible =
            not WinFOV.Visible
    end
end)

--==================================================
-- CLEANUP
--==================================================

ScreenUI.AncestryChanged:Connect(function(
    _,
    parent
)

    if parent then
        return
    end

    if FOV_Ring then
        pcall(function()
            FOV_Ring:Remove()
        end)
    end

    for player in pairs(ESP_Storage) do
        removeESP(player)
    end
end)

print("[.GG.BR] Ultimate Mobile Edition loaded.")
