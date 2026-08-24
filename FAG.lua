--// =========================================================
--// 💎 REBEL CLUB HUB | EXCLUSIVE V2
--// Fixed / Clean Version
--// =========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--============================================================
-- CLEAN OLD GUI
--============================================================

local oldGui = playerGui:FindFirstChild("CyberHubPremium")

if oldGui then
    oldGui:Destroy()
end

--============================================================
-- GLOBAL SETTINGS
--============================================================

_G.AutoWinActive = false
_G.AutoRebirthActive = false
_G.WalkSpeedActive = false
_G.JumpPowerActive = false
_G.InfJumpActive = false
_G.FlyActive = false
_G.WalkInCircleActive = false
_G.EspActive = false

--============================================================
-- SCREEN GUI
--============================================================

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "CyberHubPremium"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

--============================================================
-- ANTI IDLE
--============================================================

pcall(function()
    if getconnections then
        for _, connection in pairs(
            getconnections(player.Idled)
        ) do
            pcall(function()
                connection:Disable()
            end)
        end
    end
end)

--============================================================
-- OPEN BUTTON
--============================================================

local OpenButton = Instance.new("TextButton")
local OpenCorner = Instance.new("UICorner")
local OpenStroke = Instance.new("UIStroke")

OpenButton.Name = "OpenButton"
OpenButton.Parent = ScreenGui

OpenButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OpenButton.Position = UDim2.new(0, 15, 0, 15)
OpenButton.Size = UDim2.new(0, 50, 0, 50)

OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.Text = "🔮"
OpenButton.TextColor3 = Color3.fromRGB(0, 255, 200)
OpenButton.TextSize = 24

OpenButton.Visible = false
OpenButton.Active = true
OpenButton.Draggable = true

OpenCorner.CornerRadius = UDim.new(0, 15)
OpenCorner.Parent = OpenButton

OpenStroke.Color = Color3.fromRGB(0, 255, 200)
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenButton

--============================================================
-- MAIN FRAME
--============================================================

local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
local UIGradient = Instance.new("UIGradient")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui

MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.Position = UDim2.new(0.5, -375, 0.5, -240)
MainFrame.Size = UDim2.new(0, 750, 0, 480)

MainFrame.Active = true

MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

MainStroke.Thickness = 2.5
MainStroke.Parent = MainFrame

UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(
        0,
        Color3.fromRGB(0, 255, 200)
    ),

    ColorSequenceKeypoint.new(
        0.5,
        Color3.fromRGB(0, 150, 255)
    ),

    ColorSequenceKeypoint.new(
        1,
        Color3.fromRGB(255, 0, 128)
    )
})

UIGradient.Parent = MainStroke

--============================================================
-- TOP BAR
--============================================================

local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame

TopBar.BackgroundTransparency = 1
TopBar.Size = UDim2.new(1, 0, 0, 50)

Title.Name = "Title"
Title.Parent = TopBar

Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)

Title.Font = Enum.Font.SourceSansBold
Title.Text = "💎 REBEL CLUB HUB | EXCLUSIVE V2 💎"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar

CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -50, 0, 0)
CloseButton.Size = UDim2.new(0, 50, 0, 50)

CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "❌"
CloseButton.TextSize = 16

--============================================================
-- SIDEBAR
--============================================================

local SideBar = Instance.new("Frame")
local SideBarLayout = Instance.new("UIListLayout")

SideBar.Name = "SideBar"
SideBar.Parent = MainFrame

SideBar.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
SideBar.Position = UDim2.new(0, 0, 0, 50)
SideBar.Size = UDim2.new(0, 180, 1, -50)

SideBarLayout.Parent = SideBar
SideBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideBarLayout.Padding = UDim.new(0, 8)

--============================================================
-- TAB BUTTONS
--============================================================

local tabButtons = {}

local function createTabButton(name, icon, order)

    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    local padding = Instance.new("UIPadding")

    btn.Name = "Tab_" .. name
    btn.Parent = SideBar

    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)

    if order == 1 then
        btn.BackgroundTransparency = 0
        btn.TextColor3 = Color3.fromRGB(0, 255, 200)
    else
        btn.BackgroundTransparency = 1
        btn.TextColor3 = Color3.fromRGB(150, 150, 160)
    end

    btn.Size = UDim2.new(1, -20, 0, 42)

    btn.Font = Enum.Font.SourceSansBold
    btn.Text = "  " .. icon .. "  " .. name
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left

    btn.LayoutOrder = order

    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = btn

    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    tabButtons[name] = btn

    return btn
end

local btnMain = createTabButton(
    "Main Farm",
    "🔥",
    1
)

local btnPlayer = createTabButton(
    "Player Cheats",
    "⚡",
    2
)

local btnVisual = createTabButton(
    "Visual / ESP",
    "👁️",
    3
)

local btnTeleport = createTabButton(
    "Teleports",
    "🗺️",
    4
)

local btnSettings = createTabButton(
    "Hub Settings",
    "⚙️",
    5
)

--============================================================
-- CONTAINER
--============================================================

local Container = Instance.new("Frame")

Container.Name = "Container"
Container.Parent = MainFrame

Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 180, 0, 50)
Container.Size = UDim2.new(1, -180, 1, -50)

--============================================================
-- PAGES
--============================================================

local pages = {}

local function createPage(name)

    local scrollFrame = Instance.new("ScrollingFrame")
    local layout = Instance.new("UIListLayout")
    local pad = Instance.new("UIPadding")

    scrollFrame.Name = "Page_" .. name
    scrollFrame.Parent = Container

    scrollFrame.BackgroundTransparency = 1

    scrollFrame.Size = UDim2.new(1, 0, 1, 0)

    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 =
        Color3.fromRGB(0, 255, 200)

    scrollFrame.Visible = false

    scrollFrame.CanvasSize =
        UDim2.new(0, 0, 0, 1200)

    layout.Parent = scrollFrame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12)

    pad.PaddingLeft = UDim.new(0, 20)
    pad.PaddingTop = UDim.new(0, 20)
    pad.PaddingRight = UDim.new(0, 20)

    pad.Parent = scrollFrame

    pages[name] = scrollFrame

    return scrollFrame
end

local pageMain = createPage("Main Farm")
local pagePlayer = createPage("Player Cheats")
local pageVisual = createPage("Visual / ESP")
local pageTeleport = createPage("Teleports")
local pageSettings = createPage("Hub Settings")

pageMain.Visible = true

--============================================================
-- TAB SWITCH
--============================================================

local function switchTab(tabName)

    for name, page in pairs(pages) do
        page.Visible = (name == tabName)
    end

    for name, button in pairs(tabButtons) do

        if name == tabName then

            button.BackgroundTransparency = 0
            button.TextColor3 =
                Color3.fromRGB(0, 255, 200)

        else

            button.BackgroundTransparency = 1
            button.TextColor3 =
                Color3.fromRGB(150, 150, 160)

        end
    end
end

btnMain.MouseButton1Click:Connect(function()
    switchTab("Main Farm")
end)

btnPlayer.MouseButton1Click:Connect(function()
    switchTab("Player Cheats")
end)

btnVisual.MouseButton1Click:Connect(function()
    switchTab("Visual / ESP")
end)

btnTeleport.MouseButton1Click:Connect(function()
    switchTab("Teleports")
end)

btnSettings.MouseButton1Click:Connect(function()
    switchTab("Hub Settings")
end)

--============================================================
-- TOGGLE CREATOR
--============================================================

local function createToggle(
    parentPage,
    text,
    globalVar,
    callback
)

    local box = Instance.new("Frame")
    local label = Instance.new("TextLabel")
    local btn = Instance.new("TextButton")

    local boxCorner = Instance.new("UICorner")
    local buttonCorner = Instance.new("UICorner")

    box.Size = UDim2.new(1, 0, 0, 60)
    box.BackgroundColor3 =
        Color3.fromRGB(16, 16, 22)

    box.Parent = parentPage

    boxCorner.CornerRadius = UDim.new(0, 8)
    boxCorner.Parent = box

    label.Text = text

    label.Size =
        UDim2.new(0.6, 0, 1, 0)

    label.Position =
        UDim2.new(0, 15, 0, 0)

    label.TextColor3 =
        Color3.fromRGB(230, 230, 235)

    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 15
    label.TextXAlignment =
        Enum.TextXAlignment.Left

    label.BackgroundTransparency = 1
    label.Parent = box

    btn.Size = UDim2.new(0, 110, 0, 36)
    btn.Position =
        UDim2.new(1, -125, 0, 12)

    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13

    if _G[globalVar] then

        btn.Text = "ACTIVE"
        btn.BackgroundColor3 =
            Color3.fromRGB(0, 200, 120)

    else

        btn.Text = "DISABLED"
        btn.BackgroundColor3 =
            Color3.fromRGB(220, 50, 70)

    end

    btn.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    btn.Parent = box

    buttonCorner.CornerRadius =
        UDim.new(0, 6)

    buttonCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()

        _G[globalVar] =
            not _G[globalVar]

        if _G[globalVar] then

            btn.Text = "ACTIVE"

            btn.BackgroundColor3 =
                Color3.fromRGB(0, 200, 120)

        else

            btn.Text = "DISABLED"

            btn.BackgroundColor3 =
                Color3.fromRGB(220, 50, 70)

        end

        if callback then
            pcall(function()
                callback(_G[globalVar])
            end)
        end

    end)
end

--============================================================
-- BUTTON CREATOR
--============================================================

local function createButton(
    parentPage,
    text,
    callback
)

    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")

    btn.Size = UDim2.new(1, 0, 0, 45)

    btn.BackgroundColor3 =
        Color3.fromRGB(30, 30, 40)

    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text

    btn.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    btn.TextSize = 15

    btn.Parent = parentPage

    corner.CornerRadius =
        UDim.new(0, 8)

    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()

        if callback then
            pcall(callback)
        end

    end)

    return btn
end

--============================================================
-- MAIN FARM
--============================================================

createToggle(
    pageMain,
    "🔁 ระบบ Auto Win Loop (Stage 1 - 9)",
    "AutoWinActive"
)

createToggle(
    pageMain,
    "✨ ระบบ Auto Rebirth",
    "AutoRebirthActive"
)

--============================================================
-- PLAYER
--============================================================

createToggle(
    pagePlayer,
    "🏃 เพิ่มสปีดการวิ่ง (WalkSpeed x100)",
    "WalkSpeedActive",

    function(state)

        if not state
            and player.Character
        then

            local humanoid =
                player.Character:FindFirstChildOfClass(
                    "Humanoid"
                )

            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
)

createToggle(
    pagePlayer,
    "🦘 เพิ่มพลังการกระโดดสูงพิเศษ",
    "JumpPowerActive",

    function(state)

        if not player.Character then
            return
        end

        local humanoid =
            player.Character:FindFirstChildOfClass(
                "Humanoid"
            )

        if not humanoid then
            return
        end

        humanoid.UseJumpPower = true

        if state then
            humanoid.JumpPower = 150
        else
            humanoid.JumpPower = 50
        end

    end
)

createToggle(
    pagePlayer,
    "🎈 กระโดดไม่จำกัด",
    "InfJumpActive"
)

createToggle(
    pagePlayer,
    "🕊️ ระบบบิน",
    "FlyActive"
)

createToggle(
    pagePlayer,
    "🔄 เดินเป็นวงกลม",
    "WalkInCircleActive"
)

--============================================================
-- VISUAL / ESP
--============================================================

createToggle(
    pageVisual,
    "👁️ Player ESP",
    "EspActive",

    function(state)

        if not state then

            for _, p in pairs(
                Players:GetPlayers()
            ) do

                if p.Character then

                    local highlight =
                        p.Character:FindFirstChild(
                            "CyberESP"
                        )

                    if highlight then
                        highlight:Destroy()
                    end

                end
            end
        end
    end
)

--============================================================
-- TELEPORT
--============================================================

createButton(
    pageTeleport,
    "🌌 วาร์ปไปยัง Safezone",
    function()

        local character =
            player.Character

        if not character then
            return
        end

        local hrp =
            character:FindFirstChild(
                "HumanoidRootPart"
            )

        if hrp then
            hrp.CFrame =
                CFrame.new(0, 50, 0)
        end
    end
)

--============================================================
-- SETTINGS
--============================================================

createButton(
    pageSettings,
    "❌ ลบหน้าต่างเมนู",
    function()

        _G.AutoWinActive = false
        _G.AutoRebirthActive = false
        _G.WalkSpeedActive = false
        _G.JumpPowerActive = false
        _G.InfJumpActive = false
        _G.FlyActive = false
        _G.WalkInCircleActive = false
        _G.EspActive = false

        ScreenGui:Destroy()
    end
)

--============================================================
-- AUTO WIN
--============================================================

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(0.5)

        if _G.AutoWinActive then

            for i = 1, 9 do

                if not _G.AutoWinActive then
                    break
                end

                local stagePath = nil

                pcall(function()

                    local map =
                        workspace:FindFirstChild("Map")

                    local world1 =
                        map and
                        map:FindFirstChild("World1")

                    local stages =
                        world1 and
                        world1:FindFirstChild("Stages")

                    if not stages then
                        return
                    end

                    if i == 1 then

                        local stage =
                            stages:FindFirstChild("Stage1")

                        if stage then

                            local main =
                                stage:FindFirstChild("Main")

                            local stageEnd =
                                main and
                                main:FindFirstChild("StageEnd")

                            stagePath =
                                stageEnd and
                                stageEnd:FindFirstChild(
                                    "Button"
                                )
                        end

                    else

                        local stageName =
                            "Stage" .. tostring(i)

                        local stage =
                            stages:FindFirstChild(
                                stageName
                            )

                        if stage then

                            local win =
                                stage:FindFirstChild(
                                    "NormalWin"
                                )

                            stagePath =
                                win and
                                win:FindFirstChild(
                                    "Button"
                                )
                        end
                    end
                end)

                if stagePath then

                    pcall(function()

                        if fireclickdetector
                            and stagePath:IsA(
                                "ClickDetector"
                            )
                        then

                            fireclickdetector(
                                stagePath
                            )

                        else

                            local detector =
                                stagePath:FindFirstChildOfClass(
                                    "ClickDetector"
                                )

                            if detector
                                and fireclickdetector
                            then

                                fireclickdetector(
                                    detector
                                )

                            elseif
                                player.Character
                            then

                                local hrp =
                                    player.Character:
                                    FindFirstChild(
                                        "HumanoidRootPart"
                                    )

                                if hrp
                                    and stagePath:IsA(
                                        "BasePart"
                                    )
                                then

                                    hrp.CFrame =
                                        stagePath.CFrame

                                end
                            end
                        end
                    end)

                    task.wait(0.2)
                end

                task.wait(0.8)
            end
        end
    end
end)

--============================================================
-- AUTO REBIRTH
--============================================================

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(1)

        if _G.AutoRebirthActive then

            pcall(function()

                local remotes =
                    ReplicatedStorage:
                    FindFirstChild("Remotes")

                if not remotes then
                    return
                end

                local rebirthRemote =
                    remotes:FindFirstChild(
                        "Rebirth"
                    )

                if rebirthRemote
                    and rebirthRemote:IsA(
                        "RemoteEvent"
                    )
                then

                    rebirthRemote:FireServer()

                end
            end)
        end
    end
end)

--============================================================
-- WALK SPEED
--============================================================

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(0.1)

        if _G.WalkSpeedActive
            and player.Character
        then

            local humanoid =
                player.Character:
                FindFirstChildOfClass(
                    "Humanoid"
                )

            if humanoid then
                humanoid.WalkSpeed = 100
            end
        end
    end
end)

--============================================================
-- INFINITE JUMP
--============================================================

UserInputService.JumpRequest:Connect(function()

    if not _G.InfJumpActive then
        return
    end

    if not player.Character then
        return
    end

    local humanoid =
        player.Character:
        FindFirstChildOfClass(
            "Humanoid"
        )

    if humanoid then

        humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )

    end
end)

--============================================================
-- FLY
--============================================================

local flySpeed = 50

task.spawn(function()

    while ScreenGui.Parent do

        task.wait()

        if _G.FlyActive
            and player.Character
        then

            local hrp =
                player.Character:
                FindFirstChild(
                    "HumanoidRootPart"
                )

            local humanoid =
                player.Character:
                FindFirstChildOfClass(
                    "Humanoid"
                )

            local camera =
                workspace.CurrentCamera

            if hrp and camera then

                local moveDirection =
                    Vector3.zero

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.W
                ) then

                    moveDirection +=
                        camera.CFrame.LookVector
                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.S
                ) then

                    moveDirection -=
                        camera.CFrame.LookVector
                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.A
                ) then

                    moveDirection -=
                        camera.CFrame.RightVector
                end

                if UserInputService:IsKeyDown(
                    Enum.KeyCode.D
                ) then

                    moveDirection +=
                        camera.CFrame.RightVector
                end

                local bodyVelocity =
                    hrp:FindFirstChild(
                        "FlyBodyVelocity"
                    )

                if not bodyVelocity then

                    bodyVelocity =
                        Instance.new(
                            "BodyVelocity"
                        )

                    bodyVelocity.Name =
                        "FlyBodyVelocity"

                    bodyVelocity.MaxForce =
                        Vector3.new(
                            math.huge,
                            math.huge,
                            math.huge
                        )

                    bodyVelocity.Parent =
                        hrp
                end

                bodyVelocity.Velocity =
                    moveDirection * flySpeed

                if humanoid then
                    humanoid.PlatformStand = true
                end
            end

        else

            if player.Character then

                local hrp =
                    player.Character:
                    FindFirstChild(
                        "HumanoidRootPart"
                    )

                local humanoid =
                    player.Character:
                    FindFirstChildOfClass(
                        "Humanoid"
                    )

                if hrp then

                    local bodyVelocity =
                        hrp:FindFirstChild(
                            "FlyBodyVelocity"
                        )

                    if bodyVelocity then
                        bodyVelocity:Destroy()
                    end
                end

                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end
    end
end)

--============================================================
-- WALK IN CIRCLE
--============================================================

local angle = 0

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(0.02)

        if _G.WalkInCircleActive
            and player.Character
        then

            local hrp =
                player.Character:
                FindFirstChild(
                    "HumanoidRootPart"
                )

            local humanoid =
                player.Character:
                FindFirstChildOfClass(
                    "Humanoid"
                )

            if hrp and humanoid then

                angle += 0.05

                local offset =
                    Vector3.new(
                        math.cos(angle) * 10,
                        0,
                        math.sin(angle) * 10
                    )

                humanoid:MoveTo(
                    hrp.Position + offset
                )
            end
        end
    end
end)

--============================================================
-- ESP
--============================================================

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(1)

        if _G.EspActive then

            for _, p in pairs(
                Players:GetPlayers()
            ) do

                if p ~= player
                    and p.Character
                then

                    local hrp =
                        p.Character:
                        FindFirstChild(
                            "HumanoidRootPart"
                        )

                    if hrp then

                        local highlight =
                            p.Character:
                            FindFirstChild(
                                "CyberESP"
                            )

                        if not highlight then

                            highlight =
                                Instance.new(
                                    "Highlight"
                                )

                            highlight.Name =
                                "CyberESP"

                            highlight.Parent =
                                p.Character

                            highlight.FillColor =
                                Color3.fromRGB(
                                    0,
                                    255,
                                    200
                                )

                            highlight.OutlineColor =
                                Color3.fromRGB(
                                    255,
                                    255,
                                    255
                                )

                            highlight.FillTransparency =
                                0.5
                        end
                    end
                end
            end
        end
    end
end)

--============================================================
-- CLOSE / OPEN
--============================================================

CloseButton.MouseButton1Click:Connect(function()

    MainFrame.Visible = false
    OpenButton.Visible = true

end)

OpenButton.MouseButton1Click:Connect(function()

    MainFrame.Visible = true
    OpenButton.Visible = false

end)

--============================================================
-- MOBILE + PC DRAG SYSTEM
--============================================================

local isDragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function updateDrag(input)

    if not dragStart or not startPos then
        return
    end

    local delta =
        input.Position - dragStart

    MainFrame.Position =
        UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
end

TopBar.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or
        input.UserInputType ==
        Enum.UserInputType.Touch
    then

        isDragging = true

        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()

            if input.UserInputState ==
                Enum.UserInputState.End
            then

                isDragging = false

            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseMovement
        or
        input.UserInputType ==
        Enum.UserInputType.Touch
    then

        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if input == dragInput
        and isDragging
    then

        updateDrag(input)

    end
end)

--============================================================
-- CHARACTER RESPAWN SUPPORT
--============================================================

player.CharacterAdded:Connect(function(character)

    task.wait(1)

    local humanoid =
        character:FindFirstChildOfClass(
            "Humanoid"
        )

    if humanoid then

        humanoid.WalkSpeed = 16
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 50

    end
end)

--============================================================
-- DONE
--============================================================

print(
    "[CyberHubPremium] Loaded successfully."
)
