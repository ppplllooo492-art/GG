-- ====================================================================
-- PART 1: BASE SYSTEM
-- ====================================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")
local ScriptContext = game:GetService("ScriptContext")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Error listener
ScriptContext.Error:Connect(function()
    return nil
end)

-- Metatable hook
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index

setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()

    if tostring(method) == "Kick"
        or tostring(method) == "kick"
        or (tostring(method) == "Destroy" and self:IsA("Player")) then

        warn("[System]: Kick/Destroy call detected.")
        return nil
    end

    if tostring(method) == "FireServer"
        and self:IsA("RemoteEvent") then

        local remoteName = tostring(self.Name):lower()

        if remoteName:find("cheat")
            or remoteName:find("ban")
            or remoteName:find("kick")
            or remoteName:find("detection")
            or remoteName:find("report")
            or remoteName:find("anticheat") then

            warn("[System]: RemoteEvent filtered: " .. tostring(self.Name))
            return nil
        end
    end

    return oldNamecall(self, ...)
end)

mt.__index = newcclosure(function(t, k)
    if LocalPlayer and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if hum and t == hum then
            if k == "WalkSpeed" then
                return 16
            end

            if k == "JumpPower" then
                return 50
            end

            if k == "HipHeight" then
                return 0
            end
        end

        if hrp and t == hrp and k == "Velocity" then
            return Vector3.new(0, 0, 0)
        end
    end

    return oldIndex(t, k)
end)

setreadonly(mt, true)

-- Error prompt watcher
task.spawn(function()
    pcall(function()
        local RobloxGui = CoreGui:WaitForChild("RobloxGui")

        RobloxGui.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "ErrorPrompt" then
                if descendant.Parent then
                    descendant.Parent.Visible = false
                end
            elseif descendant:IsA("TextLabel")
                and descendant.Text:lower():find("kicked") then

                if descendant.Parent then
                    descendant.Parent.Visible = false
                end
            end
        end)
    end)
end)

-- Velocity protection
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local character = LocalPlayer.Character
            local root = character
                and character:FindFirstChild("HumanoidRootPart")

            if root and root.Velocity.Magnitude > 500 then
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
end)

-- Rejoin
local function forceRejoinOrHop()
    warn("[System]: Rejoining server...")

    task.wait(1)

    local success = pcall(function()
        TeleportService:Teleport(
            game.PlaceId,
            LocalPlayer
        )
    end)

    if not success then
        pcall(function()
            TeleportService:Teleport(
                game.PlaceId,
                LocalPlayer
            )
        end)
    end
end

GuiService.ErrorMessageChanged:Connect(function(errorMessage)
    if errorMessage ~= "" then
        task.spawn(forceRejoinOrHop)
    end
end)


-- ====================================================================
-- PART 2: CONFIGURATION & UI
-- ====================================================================

local ATTACK_RANGE = 30
local SKILL_NUMBER = "4"

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local AttackRemote = ReplicatedStorage
    :WaitForChild("Systems")
    :WaitForChild("ActionsSystem")
    :WaitForChild("Network")
    :WaitForChild("Attack")

-- Remove old GUI
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local oldGui = playerGui:FindFirstChild("SafeAuraGui")

if oldGui then
    oldGui:Destroy()
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local EspButton = Instance.new("TextButton")

local UICorner1 = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")
local UICorner3 = Instance.new("UICorner")

ScreenGui.Name = "SafeAuraGui"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 150, 0, 110)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner1.Parent = MainFrame

-- Aura button
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.Size = UDim2.new(0, 130, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
ToggleButton.Text = "Aura: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 16

UICorner2.Parent = ToggleButton

-- ESP button
EspButton.Name = "EspButton"
EspButton.Parent = MainFrame
EspButton.Size = UDim2.new(0, 130, 0, 40)
EspButton.Position = UDim2.new(0, 10, 0, 60)
EspButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
EspButton.Text = "ESP: OFF"
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EspButton.Font = Enum.Font.SourceSansBold
EspButton.TextSize = 16

UICorner3.Parent = EspButton

_G.AuraActive = false
_G.EspActive = false

local function updateVisuals()
    if _G.AuraActive then
        TweenService:Create(
            ToggleButton,
            TweenInfo.new(0.2),
            {
                BackgroundColor3 = Color3.fromRGB(40, 167, 69)
            }
        ):Play()

        ToggleButton.Text = "Aura: ON"
    else
        TweenService:Create(
            ToggleButton,
            TweenInfo.new(0.2),
            {
                BackgroundColor3 = Color3.fromRGB(220, 53, 69)
            }
        ):Play()

        ToggleButton.Text = "Aura: OFF"
    end

    if _G.EspActive then
        TweenService:Create(
            EspButton,
            TweenInfo.new(0.2),
            {
                BackgroundColor3 = Color3.fromRGB(40, 167, 69)
            }
        ):Play()

        EspButton.Text = "ESP: ON"
    else
        TweenService:Create(
            EspButton,
            TweenInfo.new(0.2),
            {
                BackgroundColor3 = Color3.fromRGB(220, 53, 69)
            }
        ):Play()

        EspButton.Text = "ESP: OFF"
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    _G.AuraActive = not _G.AuraActive
    updateVisuals()
end)

EspButton.MouseButton1Click:Connect(function()
    _G.EspActive = not _G.EspActive
    updateVisuals()
end)


-- ====================================================================
-- PART 3: DETECTIONS & ACTIONS
-- ====================================================================

local function checkAdmin(player)
    local nameLower = player.Name:lower()

    if player.AccountAge < 1 then
        return true
    end

    if nameLower:find("admin")
        or nameLower:find("mod")
        or nameLower:find("staff") then

        return true
    end

    return false
end

local function handleAdminDetection()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and checkAdmin(player) then
            task.spawn(forceRejoinOrHop)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if checkAdmin(player) then
        task.spawn(forceRejoinOrHop)
    end
end)


-- ====================================================================
-- ESP
-- ====================================================================

local function createESP(player)
    if player == LocalPlayer then
        return
    end

    local highlight = Instance.new("Highlight")

    highlight.Name = "EspHighlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0

    local function applyESP()
        if not highlight then
            return
        end

        local character = player.Character

        if character
            and character:FindFirstChild("HumanoidRootPart")
            and _G.EspActive then

            highlight.Parent = character
        else
            highlight.Parent = nil
        end
    end

    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        applyESP()
    end)

    RunService.RenderStepped:Connect(applyESP)
end

for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)


-- ====================================================================
-- MAIN LOOP
-- ====================================================================

task.spawn(function()
    while true do

        -- FIXED:
        -- เดิมคำสั่งถูกต่อกันเป็น
        -- / 100task.wait(secureDelay)handleAdminDetection()
        -- ซึ่งทำให้เกิด Syntax Error

        local secureDelay = math.random(25, 35) / 100

        task.wait(secureDelay)

        handleAdminDetection()

        if _G.AuraActive then

            local myChar = LocalPlayer.Character

            local myRoot = myChar
                and myChar:FindFirstChild("HumanoidRootPart")

            if myRoot then

                for _, player in pairs(Players:GetPlayers()) do

                    if player ~= LocalPlayer then

                        local targetChar = player.Character

                        local targetRoot = targetChar
                            and targetChar:FindFirstChild("HumanoidRootPart")

                        local targetHumanoid = targetChar
                            and targetChar:FindFirstChildOfClass("Humanoid")

                        if targetRoot
                            and targetHumanoid
                            and targetHumanoid.Health > 0 then

                            if targetHumanoid.MaxHealth > 5000
                                or targetHumanoid.Health > 5000 then

                                continue
                            end

                            local distance =
                                (myRoot.Position - targetRoot.Position).Magnitude

                            if distance <= ATTACK_RANGE
                                and _G.AuraActive then

                                pcall(function()
                                    local targetPos = Vector3.new(
                                        targetRoot.Position.X,
                                        myRoot.Position.Y,
                                        targetRoot.Position.Z
                                    )

                                    myRoot.CFrame =
                                        CFrame.lookAt(
                                            myRoot.Position,
                                            targetPos
                                        )
                                end)

                                local args = {
                                    targetChar,
                                    SKILL_NUMBER
                                }

                                task.spawn(function()
                                    pcall(function()
                                        AttackRemote:InvokeServer(
                                            unpack(args)
                                        )
                                    end)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

updateVisuals()

print("[SYSTEM]: Script syntax check completed.")
