--//====================================================--
--// SS. ULTIMATE HUB - FIXED VERSION
--// Invisible + Speed + Jump + Premium UI
--//====================================================--

--// Cleanup old script
if _G.InvisScript then
    for _, connection in ipairs(_G.InvisScript) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end

    _G.InvisScript = nil
end

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// Connection storage
local connections = {}
_G.InvisScript = connections

local function addConnection(connection)
    if connection then
        table.insert(connections, connection)
    end

    return connection
end

--//====================================================--
--// Character variables
--//====================================================--

local character
local humanoid
local rootPart

local bodyParts = {}

local invisible = false
local speedActive = false
local jumpActive = false

local NORMAL_SPEED = 16
local INVISIBLE_SPEED = 100

local NORMAL_JUMP = 50
local HIGH_JUMP = 150

--//====================================================--
--// Character setup
--//====================================================--

local function setupCharacter(newCharacter)
    character = newCharacter or player.Character

    if not character then
        return
    end

    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")

    bodyParts = {}

    for _, object in ipairs(character:GetDescendants()) do
        if object:IsA("BasePart") then
            table.insert(bodyParts, object)
        end
    end

    -- Restore current settings after respawn
    if speedActive then
        humanoid.WalkSpeed = INVISIBLE_SPEED
    else
        humanoid.WalkSpeed = NORMAL_SPEED
    end

    if jumpActive then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = HIGH_JUMP
    else
        humanoid.UseJumpPower = true
        humanoid.JumpPower = NORMAL_JUMP
    end

    -- Restore invisible state
    if invisible then
        for _, part in ipairs(bodyParts) do
            if part and part.Parent then
                part.LocalTransparencyModifier = 1
            end
        end
    end
end

--//====================================================--
--// Invisible system
--//====================================================--

local function setInvisible(state)
    invisible = state

    for _, part in ipairs(bodyParts) do
        if part and part.Parent then
            if state then
                part.LocalTransparencyModifier = 1
            else
                part.LocalTransparencyModifier = 0
            end
        end
    end
end

--// Initial character
setupCharacter(player.Character or player.CharacterAdded:Wait())

--//====================================================--
--// Input: G = Invisible
--//====================================================--

addConnection(
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end

        if input.KeyCode == Enum.KeyCode.G then
            setInvisible(not invisible)
        end
    end)
)

--//====================================================--
--// Character respawn
--//====================================================--

addConnection(
    player.CharacterAdded:Connect(function(newCharacter)
        invisible = false

        setupCharacter(newCharacter)
    end)
)

--//====================================================--
--// Invisible camera/movement system
--//====================================================--

addConnection(
    RunService.RenderStepped:Connect(function()
        if not invisible then
            return
        end

        if not character or not character.Parent then
            return
        end

        if not rootPart or not rootPart.Parent then
            return
        end

        if not humanoid or not humanoid.Parent then
            return
        end

        -- Keep the character hidden locally without
        -- moving the actual character 200,000 studs.
        for _, part in ipairs(bodyParts) do
            if part and part.Parent then
                part.LocalTransparencyModifier = 1
            end
        end
    end)
)

--//====================================================--
--// GUI cleanup
--//====================================================--

local oldGui = playerGui:FindFirstChild("SS_UltimateGui")

if oldGui then
    oldGui:Destroy()
end

--//====================================================--
--// ScreenGui
--//====================================================--

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SS_UltimateGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

--//====================================================--
--// Main Frame
--//====================================================--

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 210, 0, 310)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(180, 50, 255)
FrameStroke.Thickness = 2.5
FrameStroke.Parent = MainFrame

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 16)
FrameCorner.Parent = MainFrame

--//====================================================--
--// Background
--//====================================================--

local BgImage = Instance.new("ImageLabel")
BgImage.Name = "Background"
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = "rbxassetid://13838271510"
BgImage.ImageTransparency = 0.65
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ZIndex = 0
BgImage.Parent = MainFrame

local BgCorner = Instance.new("UICorner")
BgCorner.CornerRadius = UDim.new(0, 16)
BgCorner.Parent = BgImage

--//====================================================--
--// Top gradient overlay
--//====================================================--

local TopGradient = Instance.new("Frame")
TopGradient.Name = "TopGradient"
TopGradient.Size = UDim2.new(1, 0, 0, 45)
TopGradient.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopGradient.BackgroundTransparency = 0.4
TopGradient.BorderSizePixel = 0
TopGradient.ZIndex = 1
TopGradient.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopGradient

--//====================================================--
--// Title
--//====================================================--

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ [ SS. HUB ] ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.FredokaOne
Title.ZIndex = 2
Title.Parent = MainFrame

local TitleGlow = Instance.new("UIStroke")
TitleGlow.Color = Color3.fromRGB(255, 0, 255)
TitleGlow.Thickness = 1.2
TitleGlow.Parent = Title

--//====================================================--
--// Button creator
--//====================================================--

local function createButton(name, text, yPos, colorCode, callback)
    local btn = Instance.new("TextButton")

    btn.Name = name
    btn.Size = UDim2.new(0, 175, 0, 38)
    btn.Position = UDim2.new(0, 17, 0, yPos)
    btn.BackgroundColor3 = colorCode
    btn.BackgroundTransparency = 0.25
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(200, 100, 255)
    stroke.Thickness = 1
    stroke.Parent = btn

    addConnection(
        btn.MouseEnter:Connect(function()
            TweenService:Create(
                stroke,
                TweenInfo.new(0.2),
                {
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 1.8
                }
            ):Play()
        end)
    )

    addConnection(
        btn.MouseLeave:Connect(function()
            TweenService:Create(
                stroke,
                TweenInfo.new(0.2),
                {
                    Color = Color3.fromRGB(200, 100, 255),
                    Thickness = 1
                }
            ):Play()
        end)
    )

    addConnection(
        btn.MouseButton1Click:Connect(callback)
    )

    return btn
end

--//====================================================--
--// Invisible button
--//====================================================--

local InvisBtn

InvisBtn = createButton(
    "InvisBtn",
    "👻 G : INVIS OFF",
    50,
    Color3.fromRGB(50, 20, 80),
    function()
        setInvisible(not invisible)

        if invisible then
            InvisBtn.Text = "👻 G : INVIS ON"
            InvisBtn.BackgroundColor3 = Color3.fromRGB(90, 20, 130)
        else
            InvisBtn.Text = "👻 G : INVIS OFF"
            InvisBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 80)
        end
    end
)

--//====================================================--
--// Speed
--//====================================================--

local SpeedBtn

SpeedBtn = createButton(
    "SpeedBtn",
    "⚡ SPEED : OFF",
    96,
    Color3.fromRGB(25, 25, 35),
    function()
        speedActive = not speedActive

        if speedActive then
            SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
            SpeedBtn.Text = "⚡ SPEED : ON (100)"

            if humanoid then
                humanoid.WalkSpeed = INVISIBLE_SPEED
            end
        else
            SpeedBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            SpeedBtn.Text = "⚡ SPEED : OFF"

            if humanoid then
                humanoid.WalkSpeed = NORMAL_SPEED
            end
        end
    end
)

--//====================================================--
--// Jump
--//====================================================--

local JumpBtn

JumpBtn = createButton(
    "JumpBtn",
    "🚀 JUMP : OFF",
    142,
    Color3.fromRGB(25, 25, 35),
    function()
        jumpActive = not jumpActive

        if jumpActive then
            JumpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
            JumpBtn.Text = "🚀 JUMP : ON (150)"

            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = HIGH_JUMP
            end
        else
            JumpBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            JumpBtn.Text = "🚀 JUMP : OFF"

            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = NORMAL_JUMP
            end
        end
    end
)

--//====================================================--
--// Hide button
--//====================================================--

local HideBtn = createButton(
    "HideBtn",
    "❌ HIDE PANEL",
    200,
    Color3.fromRGB(120, 20, 40),
    function()
        MainFrame.Visible = false
        OpenIcon.Visible = true
    end
)

--//====================================================--
--// Open icon
--//====================================================--

OpenIcon = Instance.new("ImageButton")
OpenIcon.Name = "OpenIcon"
OpenIcon.Size = UDim2.new(0, 55, 0, 55)
OpenIcon.Position = UDim2.new(0.02, 0, 0.4, 0)
OpenIcon.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
OpenIcon.BackgroundTransparency = 0
OpenIcon.Image = "rbxassetid://13838271510"
OpenIcon.Visible = false
OpenIcon.Active = true
OpenIcon.Draggable = true
OpenIcon.AutoButtonColor = false
OpenIcon.ZIndex = 5
OpenIcon.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = OpenIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 0, 255)
IconStroke.Thickness = 2
IconStroke.Parent = OpenIcon

--//====================================================--
--// Open / Close
--//====================================================--

addConnection(
    OpenIcon.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenIcon.Visible = false
    end)
)

--//====================================================--
--// Keep GUI button states after respawn
--//====================================================--

addConnection(
    player.CharacterAdded:Connect(function(newCharacter)
        task.wait(0.5)

        if not newCharacter or not newCharacter.Parent then
            return
        end

        humanoid = newCharacter:WaitForChild("Humanoid")
        rootPart = newCharacter:WaitForChild("HumanoidRootPart")

        bodyParts = {}

        for _, object in ipairs(newCharacter:GetDescendants()) do
            if object:IsA("BasePart") then
                table.insert(bodyParts, object)
            end
        end

        -- Speed
        if speedActive then
            humanoid.WalkSpeed = INVISIBLE_SPEED
        else
            humanoid.WalkSpeed = NORMAL_SPEED
        end

        -- Jump
        humanoid.UseJumpPower = true

        if jumpActive then
            humanoid.JumpPower = HIGH_JUMP
        else
            humanoid.JumpPower = NORMAL_JUMP
        end

        -- Invisible
        if invisible then
            for _, part in ipairs(bodyParts) do
                if part and part.Parent then
                    part.LocalTransparencyModifier = 1
                end
            end
        end
    end)
)

print("====================================")
print(" SS. ULTIMATE HUB LOADED SUCCESSFULLY")
print("====================================")
