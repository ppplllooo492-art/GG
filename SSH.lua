--// Ultimate God Menu PRO - Fixed Version
--// Client-side Roblox / Delta

--==================================================
-- CLEAN OLD VERSION
--==================================================

pcall(function()
    if _G.UltimateGodUI then
        _G.UltimateGodUI:Destroy()
    end
end)

pcall(function()
    if _G.UltimateGodConnections then
        for _, conn in ipairs(_G.UltimateGodConnections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
    end
end)

_G.UltimateGodUI = nil
_G.UltimateGodConnections = nil

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--==================================================
-- SETTINGS
--==================================================

local DEFAULT_SPEED = 16
local GOD_SPEED = 75

local DEFAULT_JUMP = 50
local GOD_JUMP = 150

local invisible = false
local speedEnabled = false
local jumpEnabled = false

local character
local humanoid
local rootPart

local bodyParts = {}
local originalTransparency = {}

local connections = {}

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateGodMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

_G.UltimateGodUI = ScreenGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 240)
MainFrame.Position = UDim2.new(0.5, -110, 0.35, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

--==================================================
-- DRAG SYSTEM
--==================================================

local dragging = false
local dragStart
local startPosition

local function updateDrag(input)
    local delta = input.Position - dragStart

    MainFrame.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        updateDrag(input)
    end
end)

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "⚡ GOD MENU PRO ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

--==================================================
-- BUTTON CREATOR
--==================================================

local function createButton(name, posY)
    local btn = Instance.new("TextButton")

    btn.Name = name:gsub("%s+", "")
    btn.Size = UDim2.new(0, 180, 0, 38)
    btn.Position = UDim2.new(0.5, -90, 0, posY)

    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0

    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)

    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13

    btn.AutoButtonColor = false
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    return btn
end

local InvisBtn = createButton("INVIS/GOD", 45)
local SpeedBtn = createButton("SUPER SPEED", 90)
local JumpBtn = createButton("HIGH JUMP", 135)

--==================================================
-- INFO
--==================================================

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 25)
InfoLabel.Position = UDim2.new(0, 0, 1, -30)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Draggable Menu | G = Invisible"
InfoLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextSize = 10
InfoLabel.Parent = MainFrame

--==================================================
-- BUTTON STATE
--==================================================

local function updateBtnState(btn, state, onText, offText)

    local targetColor

    if state then
        btn.Text = onText
        targetColor = Color3.fromRGB(0, 180, 90)
    else
        btn.Text = offText
        targetColor = Color3.fromRGB(40, 40, 40)
    end

    TweenService:Create(
        btn,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            BackgroundColor3 = targetColor
        }
    ):Play()
end

--==================================================
-- CHARACTER SETUP
--==================================================

local function cacheBodyParts()

    bodyParts = {}
    originalTransparency = {}

    if not character then
        return
    end

    for _, object in ipairs(character:GetDescendants()) do

        if object:IsA("BasePart") then

            table.insert(bodyParts, object)

            originalTransparency[object] = object.Transparency
        end
    end
end

local function applySpeed()

    if not humanoid or not humanoid.Parent then
        return
    end

    if speedEnabled then
        humanoid.WalkSpeed = GOD_SPEED
    else
        humanoid.WalkSpeed = DEFAULT_SPEED
    end
end

local function applyJump()

    if not humanoid or not humanoid.Parent then
        return
    end

    humanoid.UseJumpPower = true

    if jumpEnabled then
        humanoid.JumpPower = GOD_JUMP
    else
        humanoid.JumpPower = DEFAULT_JUMP
    end
end

local function setupCharacter(newCharacter)

    character = newCharacter or player.Character

    if not character then
        return
    end

    humanoid = character:WaitForChild("Humanoid", 10)
    rootPart = character:WaitForChild("HumanoidRootPart", 10)

    if not humanoid or not rootPart then
        return
    end

    cacheBodyParts()

    -- Reset invisible after respawn
    invisible = false

    updateBtnState(
        InvisBtn,
        false,
        "INVIS/GOD: ON",
        "INVIS/GOD: OFF"
    )

    applySpeed()
    applyJump()
end

--==================================================
-- INVISIBLE
--==================================================

local function setInvisible(state)

    invisible = state

    updateBtnState(
        InvisBtn,
        invisible,
        "INVIS/GOD: ON",
        "INVIS/GOD: OFF"
    )

    if not character then
        return
    end

    for _, part in ipairs(bodyParts) do

        if part and part.Parent then

            if state then

                -- Keep accessories/parts partially invisible
                part.Transparency = 1

            else

                local original = originalTransparency[part]

                if original ~= nil then
                    part.Transparency = original
                else
                    part.Transparency = 0
                end
            end
        end
    end
end

--==================================================
-- INITIAL CHARACTER
--==================================================

setupCharacter(player.Character or player.CharacterAdded:Wait())

--==================================================
-- INVISIBLE BUTTON
--==================================================

table.insert(connections, InvisBtn.MouseButton1Click:Connect(function()

    if not character or not humanoid then
        return
    end

    setInvisible(not invisible)
end))

--==================================================
-- SPEED BUTTON
--==================================================

table.insert(connections, SpeedBtn.MouseButton1Click:Connect(function()

    speedEnabled = not speedEnabled

    applySpeed()

    updateBtnState(
        SpeedBtn,
        speedEnabled,
        "SUPER SPEED: ON",
        "SUPER SPEED: OFF"
    )
end))

--==================================================
-- JUMP BUTTON
--==================================================

table.insert(connections, JumpBtn.MouseButton1Click:Connect(function()

    jumpEnabled = not jumpEnabled

    applyJump()

    updateBtnState(
        JumpBtn,
        jumpEnabled,
        "HIGH JUMP: ON",
        "HIGH JUMP: OFF"
    )
end))

--==================================================
-- KEYBOARD
--==================================================

table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)

    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.G then

        if character and humanoid then
            setInvisible(not invisible)
        end
    end
end))

--==================================================
-- CHARACTER ADDED
--==================================================

table.insert(connections, player.CharacterAdded:Connect(function(newCharacter)

    -- Wait for Roblox to finish loading character
    task.wait(0.5)

    setupCharacter(newCharacter)

    -- Keep speed/jump settings after respawn
    task.wait(0.2)

    applySpeed()
    applyJump()
end))

--==================================================
-- HEARTBEAT
--==================================================

table.insert(connections, RunService.Heartbeat:Connect(function()

    -- Keep speed
    if speedEnabled then

        if humanoid and humanoid.Parent then

            if humanoid.WalkSpeed ~= GOD_SPEED then
                humanoid.WalkSpeed = GOD_SPEED
            end
        end
    end

    -- Keep jump
    if jumpEnabled then

        if humanoid and humanoid.Parent then

            humanoid.UseJumpPower = true

            if humanoid.JumpPower ~= GOD_JUMP then
                humanoid.JumpPower = GOD_JUMP
            end
        end
    end

    -- Keep invisible
    if invisible then

        for _, part in ipairs(bodyParts) do

            if part and part.Parent then
                if part.Transparency ~= 1 then
                    part.Transparency = 1
                end
            end
        end
    end
end))

--==================================================
-- CLEANUP
--==================================================

_G.UltimateGodConnections = connections

print("====================================")
print(" Ultimate God Menu PRO Loaded!")
print(" Invisible : G")
print(" Speed     : 75")
print(" Jump      : 150")
print("====================================")
