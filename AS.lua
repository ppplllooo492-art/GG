-- [[ Ultimate Universal Egg Stealer - Fixed Version ]] --

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

_G.ScriptConfig = _G.ScriptConfig or {
    Enabled = false,
    SelectedZone = "Forest",
    TargetLargest = true,
    WalkSpeed = 16,
    SafetyHeight = -50
}

--==================================================
-- SAFE FIND
--==================================================

local function waitForChildSafe(parent, name, timeout)
    if not parent then
        return nil
    end

    local object = parent:FindFirstChild(name)

    if object then
        return object
    end

    local success, result = pcall(function()
        return parent:WaitForChild(name, timeout or 10)
    end)

    if success then
        return result
    end

    return nil
end

--==================================================
-- NETWORK
--==================================================

local Network = waitForChildSafe(ReplicatedStorage, "Network", 10)
local RequestCarry = Network and waitForChildSafe(
    Network,
    "Eggs: RequestAreaEggCarry",
    10
)

--==================================================
-- ZONES
--==================================================

local Areas = Workspace:FindFirstChild("__OBJECTS")
local AreaFolder = Areas
    and Areas:FindFirstChild("Areas")

local GuardAreas = AreaFolder
    and AreaFolder:FindFirstChild("GuardAreas")

local ZoneBounds = {}

local ZoneNames = {
    "Forest",
    "Lake",
    "Desert",
    "Volcano"
}

for _, zoneName in ipairs(ZoneNames) do
    if GuardAreas then
        local zone = GuardAreas:FindFirstChild(zoneName)

        if zone then
            local bounds = zone:FindFirstChild("Bounds")

            if bounds and bounds:IsA("BasePart") then
                ZoneBounds[zoneName] = bounds
            end
        end
    end
end

--==================================================
-- TREADMILL
--==================================================

local Plots = Workspace:FindFirstChild("Plots")
local Plot2 = Plots and Plots:FindFirstChild("2")

local Treadmill = Plot2 and Plot2:FindFirstChild("TreadmillBottom")

--==================================================
-- CHARACTER
--==================================================

local function getCharacterData()
    local char = LocalPlayer.Character

    if not char then
        return nil, nil, nil
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    return char, hrp, hum
end

--==================================================
-- OBJECT POSITION
--==================================================

local function getObjectPosition(object)
    if not object then
        return nil
    end

    if object:IsA("BasePart") then
        return object.Position
    end

    if object:IsA("Model") then
        local primary = object.PrimaryPart

        if primary then
            return primary.Position
        end

        local success, pivot = pcall(function()
            return object:GetPivot()
        end)

        if success and pivot then
            return pivot.Position
        end
    end

    return nil
end

--==================================================
-- OBJECT SIZE
--==================================================

local function getObjectSize(object)
    if not object then
        return 0
    end

    if object:IsA("BasePart") then
        return object.Size.Magnitude
    end

    if object:IsA("Model") then
        local success, size = pcall(function()
            return object:GetExtentsSize()
        end)

        if success and size then
            return size.Magnitude
        end
    end

    return 0
end

--==================================================
-- ZONE CHECK
--==================================================

local function isEggInZone(eggPart, zoneName)
    local bound = ZoneBounds[zoneName]

    if not bound or not eggPart then
        return false
    end

    local pos = getObjectPosition(eggPart)

    if not pos then
        return false
    end

    local minPos = bound.Position - (bound.Size / 2)
    local maxPos = bound.Position + (bound.Size / 2)

    return (
        pos.X >= minPos.X
        and pos.X <= maxPos.X
        and pos.Z >= minPos.Z
        and pos.Z <= maxPos.Z
    )
end

--==================================================
-- FIND EGG FOLDER
--==================================================

local function getEggFolder()
    local Camera = Workspace:FindFirstChild("Camera")

    if not Camera then
        return nil
    end

    return Camera:FindFirstChild("AreaEggSlotsClient")
end

--==================================================
-- FIND TARGET EGG
--==================================================

local function findTargetEgg()
    local eggFolder = getEggFolder()

    if not eggFolder then
        return nil
    end

    local _, hrp = getCharacterData()

    if not hrp then
        return nil
    end

    local bestEgg = nil
    local maxSize = -math.huge
    local closestDist = math.huge

    for _, egg in ipairs(eggFolder:GetChildren()) do

        if isEggInZone(
            egg,
            _G.ScriptConfig.SelectedZone
        ) then

            local eggPosition = getObjectPosition(egg)

            if eggPosition then

                local size = getObjectSize(egg)
                local distance =
                    (eggPosition - hrp.Position).Magnitude

                if _G.ScriptConfig.TargetLargest then

                    if size > maxSize then
                        maxSize = size
                        closestDist = distance
                        bestEgg = egg

                    elseif size == maxSize
                        and distance < closestDist then

                        closestDist = distance
                        bestEgg = egg
                    end

                else

                    if distance < closestDist then
                        closestDist = distance
                        bestEgg = egg
                    end

                end
            end
        end
    end

    return bestEgg
end

--==================================================
-- MOVE TO POSITION
--==================================================

local function walkTo(targetPosition)
    if not targetPosition then
        return false
    end

    local char, hrp, hum = getCharacterData()

    if not char or not hrp or not hum then
        return false
    end

    if hum.Health <= 0 then
        return false
    end

    hum.WalkSpeed = tonumber(
        _G.ScriptConfig.WalkSpeed
    ) or 16

    hum:MoveTo(targetPosition)

    local elapsed = 0
    local timeout = 5

    while elapsed < timeout do

        if not _G.ScriptConfig.Enabled then
            return false
        end

        if not hrp.Parent then
            return false
        end

        -- Void protection
        if hrp.Position.Y < _G.ScriptConfig.SafetyHeight then

            if Treadmill then
                local returnPosition =
                    Treadmill.Position
                    + Vector3.new(0, 3, 0)

                hrp.CFrame =
                    CFrame.new(returnPosition)
            end

            task.wait(0.5)

            return false
        end

        local distance =
            (hrp.Position - targetPosition).Magnitude

        if distance <= 4 then
            return true
        end

        task.wait(0.1)
        elapsed += 0.1
    end

    return false
end

--==================================================
-- CARRY EGG
--==================================================

local function carryEgg(egg)
    if not egg then
        return false
    end

    if not RequestCarry then
        warn(
            "[EggStealer] RequestCarry Remote not found."
        )
        return false
    end

    if not RequestCarry:IsA("RemoteFunction") then
        warn(
            "[EggStealer] RequestCarry is not a RemoteFunction."
        )
        return false
    end

    local slotKey =
        egg:GetAttribute("FirstAreaSlotKey")

    local uid =
        egg:GetAttribute("Uid")

    -- ใช้ค่าจาก Attribute ก่อน
    -- ถ้าไม่มีให้ใช้ชื่อ Object เป็น fallback
    if not slotKey then
        slotKey =
            _G.ScriptConfig.SelectedZone
            .. ":Slot_"
            .. tostring(egg.Name)
    end

    if not uid then
        uid =
            "FirstAreaEgg_"
            .. tostring(egg.Name)
    end

    local args = {
        {
            FirstAreaSlotKey = slotKey,
            Uid = uid
        }
    }

    local success, result = pcall(function()
        return RequestCarry:InvokeServer(
            unpack(args)
        )
    end)

    if not success then
        warn(
            "[EggStealer] InvokeServer error:",
            result
        )

        return false
    end

    return true
end

--==================================================
-- MAIN FARM LOOP
--==================================================

task.spawn(function()

    while true do

        task.wait(0.5)

        if _G.ScriptConfig.Enabled then

            local targetEgg = findTargetEgg()

            if targetEgg then

                local targetPosition =
                    getObjectPosition(targetEgg)

                if targetPosition then

                    local reached =
                        walkTo(targetPosition)

                    if reached
                        and _G.ScriptConfig.Enabled then

                        carryEgg(targetEgg)

                        task.wait(0.3)
                    end
                end

            else

                -- ไม่มีไข่ → กลับ Treadmill
                if Treadmill
                    and Treadmill:IsA("BasePart") then

                    walkTo(
                        Treadmill.Position
                        + Vector3.new(0, 2, 0)
                    )
                end
            end
        end
    end
end)

--==================================================
-- GUI
--==================================================

local CoreGui = game:GetService("CoreGui")

local oldGui =
    CoreGui:FindFirstChild("EggStealerGUI")

if oldGui then
    oldGui:Destroy()
end

local ScreenGui =
    Instance.new("ScreenGui")

ScreenGui.Name = "EggStealerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

ScreenGui.Parent = CoreGui

--==================================================
-- MAIN FRAME
--==================================================

local MainFrame =
    Instance.new("Frame")

MainFrame.Size =
    UDim2.new(0, 220, 0, 320)

MainFrame.Position =
    UDim2.new(0.05, 0, 0.3, 0)

MainFrame.BackgroundColor3 =
    Color3.fromRGB(30, 30, 35)

MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local Corner =
    Instance.new("UICorner")

Corner.CornerRadius =
    UDim.new(0, 10)

Corner.Parent = MainFrame

--==================================================
-- TITLE
--==================================================

local Title =
    Instance.new("TextLabel")

Title.Size =
    UDim2.new(1, 0, 0, 40)

Title.BackgroundColor3 =
    Color3.fromRGB(45, 45, 50)

Title.Text =
    "EGG STEALER V1"

Title.TextColor3 =
    Color3.fromRGB(255, 255, 255)

Title.Font =
    Enum.Font.SourceSansBold

Title.TextSize = 18
Title.Parent = MainFrame

local TitleCorner =
    Instance.new("UICorner")

TitleCorner.CornerRadius =
    UDim.new(0, 10)

TitleCorner.Parent = Title

--==================================================
-- DRAG SYSTEM
--==================================================

local draggingFrame = false
local dragStart
local startPosition

Title.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        draggingFrame = true

        dragStart = input.Position
        startPosition = MainFrame.Position
    end
end)

Title.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        draggingFrame = false
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not draggingFrame then
        return
    end

    if input.UserInputType ==
        Enum.UserInputType.MouseMovement
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        local delta =
            input.Position - dragStart

        MainFrame.Position =
            UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
    end
end)

--==================================================
-- TOGGLE BUTTON
--==================================================

local ToggleBtn =
    Instance.new("TextButton")

ToggleBtn.Size =
    UDim2.new(0.9, 0, 0, 40)

ToggleBtn.Position =
    UDim2.new(0.05, 0, 0.15, 0)

ToggleBtn.BackgroundColor3 =
    Color3.fromRGB(200, 50, 50)

ToggleBtn.Text =
    "STATUS: OFF"

ToggleBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

ToggleBtn.Font =
    Enum.Font.SourceSansBold

ToggleBtn.TextSize = 16
ToggleBtn.Parent = MainFrame

local ToggleCorner =
    Instance.new("UICorner")

ToggleCorner.CornerRadius =
    UDim.new(0, 8)

ToggleCorner.Parent = ToggleBtn

ToggleBtn.Activated:Connect(function()

    _G.ScriptConfig.Enabled =
        not _G.ScriptConfig.Enabled

    if _G.ScriptConfig.Enabled then

        ToggleBtn.BackgroundColor3 =
            Color3.fromRGB(50, 200, 50)

        ToggleBtn.Text =
            "STATUS: ON"

    else

        ToggleBtn.BackgroundColor3 =
            Color3.fromRGB(200, 50, 50)

        ToggleBtn.Text =
            "STATUS: OFF"

        local _, _, hum =
            getCharacterData()

        if hum then
            hum.WalkSpeed = 16
        end
    end
end)

--==================================================
-- ZONE BUTTON
--==================================================

local ZoneBtn =
    Instance.new("TextButton")

ZoneBtn.Size =
    UDim2.new(0.9, 0, 0, 40)

ZoneBtn.Position =
    UDim2.new(0.05, 0, 0.32, 0)

ZoneBtn.BackgroundColor3 =
    Color3.fromRGB(50, 50, 60)

ZoneBtn.Text =
    "ZONE: "
    .. _G.ScriptConfig.SelectedZone

ZoneBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

ZoneBtn.TextSize = 14
ZoneBtn.Parent = MainFrame

local ZoneCorner =
    Instance.new("UICorner")

ZoneCorner.CornerRadius =
    UDim.new(0, 8)

ZoneCorner.Parent = ZoneBtn

local currentZoneIdx = 1

for i, zone in ipairs(ZoneNames) do

    if zone ==
        _G.ScriptConfig.SelectedZone then

        currentZoneIdx = i
        break
    end
end

ZoneBtn.Activated:Connect(function()

    currentZoneIdx += 1

    if currentZoneIdx >
        #ZoneNames then

        currentZoneIdx = 1
    end

    local zone =
        ZoneNames[currentZoneIdx]

    _G.ScriptConfig.SelectedZone =
        zone

    ZoneBtn.Text =
        "ZONE: " .. zone
end)

--==================================================
-- TARGET BUTTON
--==================================================

local SizeBtn =
    Instance.new("TextButton")

SizeBtn.Size =
    UDim2.new(0.9, 0, 0, 40)

SizeBtn.Position =
    UDim2.new(0.05, 0, 0.49, 0)

SizeBtn.BackgroundColor3 =
    Color3.fromRGB(50, 150, 200)

SizeBtn.Text =
    "TARGET: LARGEST FIRST"

SizeBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

SizeBtn.TextSize = 14
SizeBtn.Parent = MainFrame

local SizeCorner =
    Instance.new("UICorner")

SizeCorner.CornerRadius =
    UDim.new(0, 8)

SizeCorner.Parent = SizeBtn

SizeBtn.Activated:Connect(function()

    _G.ScriptConfig.TargetLargest =
        not _G.ScriptConfig.TargetLargest

    if _G.ScriptConfig.TargetLargest then

        SizeBtn.Text =
            "TARGET: LARGEST FIRST"

        SizeBtn.BackgroundColor3 =
            Color3.fromRGB(50, 150, 200)

    else

        SizeBtn.Text =
            "TARGET: CLOSEST FIRST"

        SizeBtn.BackgroundColor3 =
            Color3.fromRGB(120, 120, 130)
    end
end)

--==================================================
-- SPEED LABEL
--==================================================

local SpeedLabel =
    Instance.new("TextLabel")

SpeedLabel.Size =
    UDim2.new(0.9, 0, 0, 20)

SpeedLabel.Position =
    UDim2.new(0.05, 0, 0.67, 0)

SpeedLabel.BackgroundTransparency = 1

SpeedLabel.Text =
    "WALKSPEED: "
    .. tostring(_G.ScriptConfig.WalkSpeed)

SpeedLabel.TextColor3 =
    Color3.fromRGB(255, 255, 255)

SpeedLabel.TextSize = 14
SpeedLabel.Parent = MainFrame

--==================================================
-- SPEED SLIDER
--==================================================

local SpeedSliderFrame =
    Instance.new("Frame")

SpeedSliderFrame.Size =
    UDim2.new(0.9, 0, 0, 15)

SpeedSliderFrame.Position =
    UDim2.new(0.05, 0, 0.75, 0)

SpeedSliderFrame.BackgroundColor3 =
    Color3.fromRGB(70, 70, 80)

SpeedSliderFrame.BorderSizePixel = 0
SpeedSliderFrame.Parent = MainFrame

local SliderCorner =
    Instance.new("UICorner")

SliderCorner.CornerRadius =
    UDim.new(1, 0)

SliderCorner.Parent =
    SpeedSliderFrame

local SpeedSliderBall =
    Instance.new("TextButton")

SpeedSliderBall.Size =
    UDim2.new(0, 20, 0, 20)

SpeedSliderBall.AnchorPoint =
    Vector2.new(0.5, 0.5)

SpeedSliderBall.Position =
    UDim2.new(0, 0, 0.5, 0)

SpeedSliderBall.BackgroundColor3 =
    Color3.fromRGB(255, 165, 0)

SpeedSliderBall.Text = ""

SpeedSliderBall.AutoButtonColor = false
SpeedSliderBall.Parent =
    SpeedSliderFrame

local BallCorner =
    Instance.new("UICorner")

BallCorner.CornerRadius =
    UDim.new(1, 0)

BallCorner.Parent =
    SpeedSliderBall

--==================================================
-- SLIDER CONTROL
--==================================================

local sliderDragging = false

local function updateSlider(inputX)

    local frameX =
        SpeedSliderFrame.AbsolutePosition.X

    local frameWidth =
        SpeedSliderFrame.AbsoluteSize.X

    if frameWidth <= 0 then
        return
    end

    local percentage =
        math.clamp(
            (inputX - frameX) / frameWidth,
            0,
            1
        )

    SpeedSliderBall.Position =
        UDim2.new(
            percentage,
            0,
            0.5,
            0
        )

    local calculatedSpeed =
        math.floor(
            16 + (percentage * 84)
        )

    _G.ScriptConfig.WalkSpeed =
        calculatedSpeed

    SpeedLabel.Text =
        "WALKSPEED: "
        .. tostring(calculatedSpeed)
end

SpeedSliderBall.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        sliderDragging = true

        updateSlider(input.Position.X)
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not sliderDragging then
        return
    end

    if input.UserInputType ==
        Enum.UserInputType.MouseMovement
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        updateSlider(input.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        sliderDragging = false
    end
end)

--==================================================
-- INITIAL SLIDER
--==================================================

updateSlider(
    SpeedSliderFrame.AbsolutePosition.X
)

print(
    "[EggStealer] GUI Loaded Successfully!"
)
