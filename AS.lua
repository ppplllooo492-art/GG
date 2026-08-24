-- [[ 🧠 STEAL AN EGG - FULL AI PILOT AGENT (V7 FIXED) ]]
-- [[ สำหรับ Roblox Studio / แมพของตัวเอง ]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- NETWORK
--==================================================

local Network = ReplicatedStorage:WaitForChild("Network")
local RequestCarry = Network:WaitForChild("Eggs: RequestAreaEggCarry")

--==================================================
-- MAP REFERENCES
--==================================================

local Objects = Workspace:WaitForChild("__OBJECTS")
local Areas = Objects:WaitForChild("Areas")
local GuardAreas = Areas:WaitForChild("GuardAreas")

local ZoneBounds = {
    Forest = GuardAreas:WaitForChild("Forest"):WaitForChild("Bounds"),
    Lake = GuardAreas:WaitForChild("Lake"):WaitForChild("Bounds"),
    Desert = GuardAreas:WaitForChild("Desert"):WaitForChild("Bounds"),
    Volcano = GuardAreas:WaitForChild("Volcano"):WaitForChild("Bounds")
}

local Plots = Workspace:WaitForChild("Plots")
local Plot5 = Plots:WaitForChild("5")
local ToUpdate = Plot5:WaitForChild("ToUpdate")
local HomeZone = ToUpdate:WaitForChild("PetArea")

--==================================================
-- CONFIG
--==================================================

_G.AIScriptConfig = {
    Enabled = false,
    SelectedZone = "Forest",
    TargetLargest = true,
    WalkSpeed = 16,
    SafetyHeight = -50
}

--==================================================
-- PATHFINDING
--==================================================

local aiAgentParams = {
    AgentRadius = 2.5,
    AgentHeight = 5,
    AgentCanJump = true,
    WaypointSpacing = 2.5
}

local function createPath()
    return PathfindingService:CreatePath(aiAgentParams)
end

--==================================================
-- CHARACTER
--==================================================

local function getCharacterComponents()
    local character = LocalPlayer.Character

    if not character then
        return nil, nil, nil
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    return character, hrp, humanoid
end

--==================================================
-- GET OBJECT POSITION
-- รองรับทั้ง BasePart และ Model
--==================================================

local function getObjectPosition(object)
    if not object then
        return nil
    end

    if object:IsA("BasePart") then
        return object.Position
    end

    if object:IsA("Model") then
        return object:GetPivot().Position
    end

    return nil
end

--==================================================
-- CHECK ZONE
--==================================================

local function checkZoneContainment(object, zoneName)
    local bound = ZoneBounds[zoneName]

    if not bound or not object then
        return false
    end

    local position = getObjectPosition(object)

    if not position then
        return false
    end

    local minBound = bound.Position - (bound.Size / 2)
    local maxBound = bound.Position + (bound.Size / 2)

    return
        position.X >= minBound.X
        and position.X <= maxBound.X
        and position.Z >= minBound.Z
        and position.Z <= maxBound.Z
end

--==================================================
-- EGG SIZE
--==================================================

local function getEggSize(egg)
    if not egg then
        return 0
    end

    if egg:IsA("Model") then
        return egg:GetExtentsSize().Magnitude
    end

    if egg:IsA("BasePart") then
        return egg.Size.Magnitude
    end

    return 0
end

--==================================================
-- FIND BEST EGG
--==================================================

local function aiSelectBestEgg()
    local cameraFolder = Workspace:FindFirstChild("Camera")

    if not cameraFolder then
        return nil
    end

    local eggFolder = cameraFolder:FindFirstChild("AreaEggSlotsClient")

    if not eggFolder then
        return nil
    end

    local _, hrp = getCharacterComponents()

    if not hrp then
        return nil
    end

    local bestEgg = nil
    local maxSize = -math.huge
    local closestDist = math.huge

    for _, egg in ipairs(eggFolder:GetChildren()) do

        if checkZoneContainment(
            egg,
            _G.AIScriptConfig.SelectedZone
        ) then

            local eggPosition = getObjectPosition(egg)

            if eggPosition then

                local size = getEggSize(egg)
                local distance = (eggPosition - hrp.Position).Magnitude

                if _G.AIScriptConfig.TargetLargest then

                    if size > maxSize then
                        maxSize = size
                        closestDist = distance
                        bestEgg = egg

                    elseif size == maxSize and distance < closestDist then
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
-- RETURN HOME
--==================================================

local function returnHome()
    local homePosition = getObjectPosition(HomeZone)

    if not homePosition then
        return false
    end

    local _, hrp = getCharacterComponents()

    if not hrp then
        return false
    end

    if hrp.Position.Y < _G.AIScriptConfig.SafetyHeight then
        hrp.CFrame = CFrame.new(
            homePosition + Vector3.new(0, 3, 0)
        )

        return true
    end

    return false
end

--==================================================
-- AI NAVIGATION
--==================================================

local function aiDriveTo(destination)
    if typeof(destination) ~= "Vector3" then
        return false
    end

    local character, hrp, humanoid = getCharacterComponents()

    if not character or not hrp or not humanoid then
        return false
    end

    humanoid.WalkSpeed = _G.AIScriptConfig.WalkSpeed

    local aiPath = createPath()

    local computeOK, computeError = pcall(function()
        aiPath:ComputeAsync(
            hrp.Position,
            destination
        )
    end)

    if not computeOK then
        warn("AI Path Error:", computeError)

        humanoid:MoveTo(destination)
        task.wait(0.5)

        return false
    end

    if aiPath.Status ~= Enum.PathStatus.Success then

        humanoid:MoveTo(destination)
        task.wait(0.5)

        return false
    end

    local waypoints = aiPath:GetWaypoints()

    if #waypoints == 0 then
        return false
    end

    local lastTrackedPosition = hrp.Position
    local stuckTime = 0

    for _, waypoint in ipairs(waypoints) do

        if not _G.AIScriptConfig.Enabled then
            humanoid:MoveTo(hrp.Position)
            return false
        end

        -- Anti fall
        if hrp.Position.Y < _G.AIScriptConfig.SafetyHeight then
            returnHome()
            return false
        end

        -- Jump waypoint
        if waypoint.Action == Enum.PathWaypointAction.Jump then
            humanoid.Jump = true
        end

        humanoid:MoveTo(waypoint.Position)

        local reached = false
        local startTime = os.clock()

        while not reached do

            if not _G.AIScriptConfig.Enabled then
                humanoid:MoveTo(hrp.Position)
                return false
            end

            if not hrp.Parent or not humanoid.Parent then
                return false
            end

            if hrp.Position.Y < _G.AIScriptConfig.SafetyHeight then
                returnHome()
                return false
            end

            local distanceToWaypoint =
                (hrp.Position - waypoint.Position).Magnitude

            if distanceToWaypoint <= 3 then
                reached = true
                stuckTime = 0
                break
            end

            -- Detect stuck
            local movement =
                (hrp.Position - lastTrackedPosition).Magnitude

            if movement < 0.2 then
                stuckTime = stuckTime + 0.1
            else
                stuckTime = 0
            end

            if stuckTime >= 1.2 then

                humanoid.Jump = true

                local currentCFrame = hrp.CFrame

                hrp.CFrame =
                    currentCFrame
                    * CFrame.new(0, 0, -1.5)

                humanoid:MoveTo(waypoint.Position)

                return false
            end

            -- Timeout for this waypoint
            if os.clock() - startTime > 8 then
                return false
            end

            lastTrackedPosition = hrp.Position

            task.wait(0.1)
        end
    end

    humanoid:MoveTo(hrp.Position)

    return true
end

--==================================================
-- REQUEST CARRY
--==================================================

local function requestCarryEgg(egg)
    if not egg then
        return false
    end

    local slotKey =
        egg:GetAttribute("FirstAreaSlotKey")

    local uid =
        egg:GetAttribute("Uid")

    if not slotKey or slotKey == "" then
        slotKey =
            _G.AIScriptConfig.SelectedZone .. ":Slot_002"
    end

    if not uid or uid == "" then
        uid = egg.Name
    end

    local args = {
        {
            FirstAreaSlotKey = slotKey,
            Uid = uid
        }
    }

    local success, result = pcall(function()
        return RequestCarry:InvokeServer(unpack(args))
    end)

    if not success then
        warn("RequestCarry Error:", result)
        return false
    end

    return true
end

--==================================================
-- MAIN AI LOOP
--==================================================

task.spawn(function()

    while true do
        task.wait(0.4)

        if _G.AIScriptConfig.Enabled then

            local targetEgg = aiSelectBestEgg()

            if targetEgg then

                local eggPosition =
                    getObjectPosition(targetEgg)

                if eggPosition then

                    -- Go to egg
                    local arrived =
                        aiDriveTo(eggPosition)

                    if arrived
                        and _G.AIScriptConfig.Enabled
                        and targetEgg.Parent then

                        -- Request carry
                        requestCarryEgg(targetEgg)

                        task.wait(0.4)

                        -- Return home
                        local homePosition =
                            getObjectPosition(HomeZone)

                        if homePosition then
                            aiDriveTo(homePosition)
                        end

                        task.wait(0.4)
                    end
                end

            else

                -- No egg -> return home
                local homePosition =
                    getObjectPosition(HomeZone)

                if homePosition then
                    aiDriveTo(homePosition)
                end

            end
        end
    end
end)

--==================================================
-- GUI
--==================================================

local PlayerGui =
    LocalPlayer:WaitForChild("PlayerGui")

local oldGui =
    PlayerGui:FindFirstChild("EggAIPilotSystem")

if oldGui then
    oldGui:Destroy()
end

local ScreenGui =
    Instance.new("ScreenGui")

ScreenGui.Name = "EggAIPilotSystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

--==================================================
-- MAIN FRAME
--==================================================

local MainFrame =
    Instance.new("Frame")

MainFrame.Name = "MainFrame"
MainFrame.Size =
    UDim2.new(0, 230, 0, 320)

MainFrame.Position =
    UDim2.new(0.05, 0, 0.25, 0)

MainFrame.BackgroundColor3 =
    Color3.fromRGB(15, 20, 28)

MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner =
    Instance.new("UICorner")

MainCorner.CornerRadius =
    UDim.new(0, 12)

MainCorner.Parent = MainFrame

--==================================================
-- TITLE
--==================================================

local Title =
    Instance.new("TextLabel")

Title.Name = "Title"
Title.Size =
    UDim2.new(0.8, 0, 0, 42)

Title.Position =
    UDim2.new(0, 0, 0, 0)

Title.BackgroundColor3 =
    Color3.fromRGB(24, 32, 45)

Title.BorderSizePixel = 0

Title.Text =
    "🤖 PURE AI PILOT v7"

Title.TextColor3 =
    Color3.fromRGB(255, 255, 255)

Title.Font =
    Enum.Font.SourceSansBold

Title.TextSize = 15
Title.Parent = MainFrame

--==================================================
-- MINIMIZE
--==================================================

local MinBtn =
    Instance.new("TextButton")

MinBtn.Name = "MinBtn"

MinBtn.Size =
    UDim2.new(0.2, 0, 0, 42)

MinBtn.Position =
    UDim2.new(0.8, 0, 0, 0)

MinBtn.BackgroundColor3 =
    Color3.fromRGB(35, 45, 60)

MinBtn.BorderSizePixel = 0

MinBtn.Text = "-"
MinBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

MinBtn.TextSize = 18
MinBtn.Parent = MainFrame

local MinCorner =
    Instance.new("UICorner")

MinCorner.CornerRadius =
    UDim.new(0, 8)

MinCorner.Parent = MinBtn

--==================================================
-- CONTAINER
--==================================================

local Container =
    Instance.new("Frame")

Container.Name = "Container"

Container.Size =
    UDim2.new(1, 0, 0, 278)

Container.Position =
    UDim2.new(0, 0, 0, 42)

Container.BackgroundTransparency = 1
Container.Parent = MainFrame

--==================================================
-- MINIMIZE LOGIC
--==================================================

local menuClosed = false

MinBtn.MouseButton1Click:Connect(function()

    menuClosed = not menuClosed

    if menuClosed then

        Container.Visible = false
        MinBtn.Text = "+"

        MainFrame:TweenSize(
            UDim2.new(0, 230, 0, 42),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.18,
            true
        )

    else

        Container.Visible = true
        MinBtn.Text = "-"

        MainFrame:TweenSize(
            UDim2.new(0, 230, 0, 320),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.18,
            true
        )

    end
end)

--==================================================
-- TOGGLE BUTTON
--==================================================

local ToggleBtn =
    Instance.new("TextButton")

ToggleBtn.Name = "ToggleBtn"

ToggleBtn.Size =
    UDim2.new(0.9, 0, 0, 42)

ToggleBtn.Position =
    UDim2.new(0.05, 0, 0.06, 0)

ToggleBtn.BackgroundColor3 =
    Color3.fromRGB(180, 45, 45)

ToggleBtn.BorderSizePixel = 0

ToggleBtn.Text =
    "AI SYSTEM: INACTIVE"

ToggleBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

ToggleBtn.Font =
    Enum.Font.SourceSansBold

ToggleBtn.TextSize = 14
ToggleBtn.Parent = Container

local ToggleCorner =
    Instance.new("UICorner")

ToggleCorner.CornerRadius =
    UDim.new(0, 8)

ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()

    _G.AIScriptConfig.Enabled =
        not _G.AIScriptConfig.Enabled

    if _G.AIScriptConfig.Enabled then

        ToggleBtn.BackgroundColor3 =
            Color3.fromRGB(40, 160, 90)

        ToggleBtn.Text =
            "AI SYSTEM: RUNNING"

    else

        ToggleBtn.BackgroundColor3 =
            Color3.fromRGB(180, 45, 45)

        ToggleBtn.Text =
            "AI SYSTEM: INACTIVE"

        local _, _, humanoid =
            getCharacterComponents()

        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid:MoveTo(
                humanoid.RootPart
                    and humanoid.RootPart.Position
                    or humanoid.Parent:GetPivot().Position
            )
        end
    end
end)

--==================================================
-- ZONE BUTTON
--==================================================

local ZoneBtn =
    Instance.new("TextButton")

ZoneBtn.Name = "ZoneBtn"

ZoneBtn.Size =
    UDim2.new(0.9, 0, 0, 42)

ZoneBtn.Position =
    UDim2.new(0.05, 0, 0.25, 0)

ZoneBtn.BackgroundColor3 =
    Color3.fromRGB(40, 40, 50)

ZoneBtn.BorderSizePixel = 0

ZoneBtn.Text =
    "AI ZONE: Forest"

ZoneBtn.TextColor3 =
    Color3.fromRGB(240, 240, 240)

ZoneBtn.TextSize = 13
ZoneBtn.Parent = Container

local ZoneCorner =
    Instance.new("UICorner")

ZoneCorner.CornerRadius =
    UDim.new(0, 8)

ZoneCorner.Parent = ZoneBtn

local zones = {
    "Forest",
    "Lake",
    "Desert",
    "Volcano"
}

local currentZoneIdx = 1

ZoneBtn.MouseButton1Click:Connect(function()

    currentZoneIdx =
        currentZoneIdx + 1

    if currentZoneIdx > #zones then
        currentZoneIdx = 1
    end

    _G.AIScriptConfig.SelectedZone =
        zones[currentZoneIdx]

    ZoneBtn.Text =
        "AI ZONE: " .. zones[currentZoneIdx]
end)

--==================================================
-- PRIORITY BUTTON
--==================================================

local SizeBtn =
    Instance.new("TextButton")

SizeBtn.Name = "SizeBtn"

SizeBtn.Size =
    UDim2.new(0.9, 0, 0, 42)

SizeBtn.Position =
    UDim2.new(0.05, 0, 0.44, 0)

SizeBtn.BackgroundColor3 =
    Color3.fromRGB(0, 110, 160)

SizeBtn.BorderSizePixel = 0

SizeBtn.Text =
    "PRIORITY: MAX SIZE FIRST"

SizeBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

SizeBtn.TextSize = 13
SizeBtn.Parent = Container

local SizeCorner =
    Instance.new("UICorner")

SizeCorner.CornerRadius =
    UDim.new(0, 8)

SizeCorner.Parent = SizeBtn

SizeBtn.MouseButton1Click:Connect(function()

    _G.AIScriptConfig.TargetLargest =
        not _G.AIScriptConfig.TargetLargest

    if _G.AIScriptConfig.TargetLargest then

        SizeBtn.Text =
            "PRIORITY: MAX SIZE FIRST"

        SizeBtn.BackgroundColor3 =
            Color3.fromRGB(0, 110, 160)

    else

        SizeBtn.Text =
            "PRIORITY: NEAREST FIRST"

        SizeBtn.BackgroundColor3 =
            Color3.fromRGB(95, 95, 105)

    end
end)

--==================================================
-- SPEED LABEL
--==================================================

local SpeedLabel =
    Instance.new("TextLabel")

SpeedLabel.Name = "SpeedLabel"

SpeedLabel.Size =
    UDim2.new(0.9, 0, 0, 20)

SpeedLabel.Position =
    UDim2.new(0.05, 0, 0.65, 0)

SpeedLabel.BackgroundTransparency = 1

SpeedLabel.Text =
    "AI SET SPEED: "
    .. tostring(_G.AIScriptConfig.WalkSpeed)

SpeedLabel.TextColor3 =
    Color3.fromRGB(255, 255, 255)

SpeedLabel.TextSize = 13
SpeedLabel.Parent = Container

--==================================================
-- SPEED SLIDER
--==================================================

local SpeedSliderFrame =
    Instance.new("Frame")

SpeedSliderFrame.Name =
    "SpeedSliderFrame"

SpeedSliderFrame.Size =
    UDim2.new(0.9, 0, 0, 14)

SpeedSliderFrame.Position =
    UDim2.new(0.05, 0, 0.74, 0)

SpeedSliderFrame.BackgroundColor3 =
    Color3.fromRGB(50, 50, 60)

SpeedSliderFrame.BorderSizePixel = 0
SpeedSliderFrame.Parent = Container

local SliderCorner =
    Instance.new("UICorner")

SliderCorner.CornerRadius =
    UDim.new(0, 7)

SliderCorner.Parent = SpeedSliderFrame

local SpeedSliderBall =
    Instance.new("TextButton")

SpeedSliderBall.Name =
    "SpeedSliderBall"

SpeedSliderBall.Size =
    UDim2.new(0, 20, 0, 20)

SpeedSliderBall.AnchorPoint =
    Vector2.new(0.5, 0.5)

SpeedSliderBall.Position =
    UDim2.new(0, 0, 0.5, 0)

SpeedSliderBall.BackgroundColor3 =
    Color3.fromRGB(0, 180, 240)

SpeedSliderBall.BorderSizePixel = 0
SpeedSliderBall.Text = ""
SpeedSliderBall.Parent = SpeedSliderFrame

local BallCorner =
    Instance.new("UICorner")

BallCorner.CornerRadius =
    UDim.new(1, 0)

BallCorner.Parent = SpeedSliderBall

--==================================================
-- MOBILE + PC SLIDER
--==================================================

local userDragging = false

local function updateSpeedFromInput(inputX)
    local framePosition =
        SpeedSliderFrame.AbsolutePosition.X

    local frameWidth =
        SpeedSliderFrame.AbsoluteSize.X

    if frameWidth <= 0 then
        return
    end

    local percentage =
        math.clamp(
            (inputX - framePosition) / frameWidth,
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

    _G.AIScriptConfig.WalkSpeed =
        calculatedSpeed

    SpeedLabel.Text =
        "AI SET SPEED: "
        .. tostring(calculatedSpeed)
end

SpeedSliderBall.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        userDragging = true

        updateSpeedFromInput(
            input.Position.X
        )
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not userDragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        updateSpeedFromInput(
            input.Position.X
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        userDragging = false
    end
end)

--==================================================
-- CHARACTER RESPAWN
--==================================================

LocalPlayer.CharacterAdded:Connect(function(character)

    local humanoid =
        character:WaitForChild("Humanoid", 5)

    if humanoid then
        humanoid.WalkSpeed =
            _G.AIScriptConfig.WalkSpeed
    end
end)

--==================================================
-- START
--==================================================

print(
    "✅ Full AI Smart Agent Executive Mode Activated!"
)

print(
    "Zone:",
    _G.AIScriptConfig.SelectedZone
)

print(
    "Speed:",
    _G.AIScriptConfig.WalkSpeed
)
