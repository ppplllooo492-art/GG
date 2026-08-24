--==================================================
-- EGG AUTO FARM V2 - FIXED
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- CLEAN OLD GUI
--==================================================

pcall(function()
    local oldGui = CoreGui:FindFirstChild("DeltaEggFarmGUI")
    if oldGui then
        oldGui:Destroy()
    end
end)

--==================================================
-- STATE
--==================================================

local State = {
    FlySpeed = 70,
    ReturnSpeed = 90,
    CurrentZone = "Forest",
    PlotNumber = "2",
    AutoFarmEggs = false,
}

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaEggFarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 360)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Title.BorderSizePixel = 0
Title.Text = "🌟 EGG AUTO-FARM V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

--==================================================
-- SHOW / HIDE BUTTON
--==================================================

local ToggleGuiBtn = Instance.new("TextButton")
ToggleGuiBtn.Name = "ToggleGuiBtn"
ToggleGuiBtn.Size = UDim2.new(0, 90, 0, 32)
ToggleGuiBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleGuiBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
ToggleGuiBtn.BorderSizePixel = 0
ToggleGuiBtn.Text = "ซ่อนเมนู"
ToggleGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleGuiBtn.Font = Enum.Font.SourceSansBold
ToggleGuiBtn.TextSize = 12
ToggleGuiBtn.ZIndex = 10
ToggleGuiBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleGuiBtn

ToggleGuiBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible

    if MainFrame.Visible then
        ToggleGuiBtn.Text = "ซ่อนเมนู"
        ToggleGuiBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    else
        ToggleGuiBtn.Text = "แสดงเมนู"
        ToggleGuiBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    end
end)

--==================================================
-- PLOT
--==================================================

local PlotLabel = Instance.new("TextLabel")
PlotLabel.Name = "PlotLabel"
PlotLabel.Size = UDim2.new(0, 130, 0, 30)
PlotLabel.Position = UDim2.new(0.05, 0, 0.18, 0)
PlotLabel.BackgroundTransparency = 1
PlotLabel.Text = "หมายเลขพล็อตบ้าน:"
PlotLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
PlotLabel.TextXAlignment = Enum.TextXAlignment.Left
PlotLabel.Font = Enum.Font.SourceSans
PlotLabel.TextSize = 14
PlotLabel.Parent = MainFrame

local PlotInput = Instance.new("TextBox")
PlotInput.Name = "PlotInput"
PlotInput.Size = UDim2.new(0, 140, 0, 30)
PlotInput.Position = UDim2.new(0.5, 0, 0.18, 0)
PlotInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
PlotInput.BorderSizePixel = 0
PlotInput.Text = State.PlotNumber
PlotInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PlotInput.Font = Enum.Font.SourceSansBold
PlotInput.TextSize = 14
PlotInput.ClearTextOnFocus = false
PlotInput.Parent = MainFrame

local PlotCorner = Instance.new("UICorner")
PlotCorner.CornerRadius = UDim.new(0, 6)
PlotCorner.Parent = PlotInput

PlotInput.FocusLost:Connect(function()
    local value = tostring(PlotInput.Text)

    if value == "" then
        value = "2"
        PlotInput.Text = value
    end

    State.PlotNumber = value
end)

--==================================================
-- ZONE LABEL
--==================================================

local ZoneLabel = Instance.new("TextLabel")
ZoneLabel.Name = "ZoneLabel"
ZoneLabel.Size = UDim2.new(1, 0, 0, 25)
ZoneLabel.Position = UDim2.new(0, 0, 0.3, 0)
ZoneLabel.BackgroundTransparency = 1
ZoneLabel.Text = "เลือกโซนที่ต้องการฟาร์มไข่ 🗺️"
ZoneLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
ZoneLabel.Font = Enum.Font.SourceSansBold
ZoneLabel.TextSize = 15
ZoneLabel.Parent = MainFrame

--==================================================
-- ZONES
--==================================================

local Zones = {
    "Forest",
    "Lake",
    "Desert",
    "Volcano"
}

local ActiveZoneBtn = nil

for i, zoneName in ipairs(Zones) do

    local ZoneBtn = Instance.new("TextButton")
    ZoneBtn.Name = zoneName .. "Button"
    ZoneBtn.Size = UDim2.new(0, 130, 0, 35)

    local xPos
    local yPos

    if i % 2 == 1 then
        xPos = 0.05
    else
        xPos = 0.53
    end

    if i <= 2 then
        yPos = 0.40
    else
        yPos = 0.54
    end

    ZoneBtn.Position = UDim2.new(xPos, 0, yPos, 0)

    if State.CurrentZone == zoneName then
        ZoneBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        ActiveZoneBtn = ZoneBtn
    else
        ZoneBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    end

    ZoneBtn.BorderSizePixel = 0
    ZoneBtn.Text = zoneName
    ZoneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ZoneBtn.Font = Enum.Font.SourceSansBold
    ZoneBtn.TextSize = 14
    ZoneBtn.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = ZoneBtn

    ZoneBtn.MouseButton1Click:Connect(function()

        State.CurrentZone = zoneName

        if ActiveZoneBtn and ActiveZoneBtn.Parent then
            ActiveZoneBtn.BackgroundColor3 =
                Color3.fromRGB(45, 45, 65)
        end

        ZoneBtn.BackgroundColor3 =
            Color3.fromRGB(0, 120, 255)

        ActiveZoneBtn = ZoneBtn
    end)
end

--==================================================
-- MASTER TOGGLE
--==================================================

local MasterToggle = Instance.new("TextButton")
MasterToggle.Name = "MasterToggle"
MasterToggle.Size = UDim2.new(0, 280, 0, 50)
MasterToggle.Position = UDim2.new(0.06, 0, 0.75, 0)
MasterToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MasterToggle.BorderSizePixel = 0
MasterToggle.Text = "ปิดระบบการฟาร์มอยู่ (กดเพื่อเปิด 🟢)"
MasterToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
MasterToggle.Font = Enum.Font.SourceSansBold
MasterToggle.TextSize = 15
MasterToggle.Parent = MainFrame

local ToggleCornerMain = Instance.new("UICorner")
ToggleCornerMain.CornerRadius = UDim.new(0, 8)
ToggleCornerMain.Parent = MasterToggle

--==================================================
-- CHARACTER FUNCTION
--==================================================

local function GetCharacter()
    local character = LocalPlayer.Character

    if not character then
        character = LocalPlayer.CharacterAdded:Wait()
    end

    return character
end

local function GetRoot()
    local character = GetCharacter()

    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

--==================================================
-- TELEPORT WITH TWEEN
--==================================================

local function TeleportWithTween(targetPosition, speed)

    if typeof(targetPosition) ~= "Vector3" then
        return false
    end

    local root = GetRoot()

    if not root then
        return false
    end

    speed = tonumber(speed) or 70

    if speed <= 0 then
        speed = 70
    end

    local distance =
        (root.Position - targetPosition).Magnitude

    if distance < 2 then
        return true
    end

    local duration = distance / speed

    if duration < 0.05 then
        duration = 0.05
    end

    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )

    local tween

    local success = pcall(function()
        tween = TweenService:Create(
            root,
            tweenInfo,
            {
                CFrame = CFrame.new(targetPosition)
            }
        )

        tween:Play()
    end)

    if not success or not tween then
        return false
    end

    local completed = false

    local connection

    connection = tween.Completed:Connect(function()
        completed = true

        if connection then
            connection:Disconnect()
        end
    end)

    local timeout = math.max(duration + 2, 3)
    local startTime = os.clock()

    while not completed do

        if not State.AutoFarmEggs then
            pcall(function()
                tween:Cancel()
            end)

            if connection then
                connection:Disconnect()
            end

            return false
        end

        if not root or not root.Parent then
            pcall(function()
                tween:Cancel()
            end)

            if connection then
                connection:Disconnect()
            end

            return false
        end

        if os.clock() - startTime >= timeout then
            pcall(function()
                tween:Cancel()
            end)

            break
        end

        task.wait()
    end

    if connection then
        connection:Disconnect()
    end

    return true
end

--==================================================
-- GET EGG SLOTS
--==================================================

local function GetAvailableEggs(zoneName)

    local eggs = {}

    if not zoneName then
        return eggs
    end

    local camera = workspace:FindFirstChild("Camera")

    if not camera then
        return eggs
    end

    local areaSlots =
        camera:FindFirstChild("AreaEggSlotsClient")

    if not areaSlots then
        return eggs
    end

    for _, egg in ipairs(areaSlots:GetChildren()) do

        if egg:IsA("BasePart") then

            local eggName = tostring(egg.Name)

            if string.sub(eggName, 1, #zoneName) == zoneName then
                table.insert(eggs, egg)
            end
        end
    end

    return eggs
end

--==================================================
-- GET EGG REMOTE
--==================================================

local function GetEggRemote()

    local network =
        ReplicatedStorage:FindFirstChild("Network")

    if not network then
        return nil
    end

    local remote =
        network:FindFirstChild("Eggs: RequestAreaEggCarry")

    if not remote then
        return nil
    end

    return remote
end

--==================================================
-- CLAIM EGG
--==================================================

local function ClaimEggNetwork(eggInstance)

    if not eggInstance then
        return false
    end

    if not eggInstance.Parent then
        return false
    end

    local eggRequest = GetEggRemote()

    if not eggRequest then
        return false
    end

    local firstAreaSlotKey =
        tostring(eggInstance.Name)

    local uidAttr =
        eggInstance:GetAttribute("Uid")

    if uidAttr == nil then
        uidAttr = eggInstance:GetAttribute("ID")
    end

    if uidAttr == nil then
        uidAttr =
            "FirstAreaEgg_" ..
            tostring(eggInstance.Position.Magnitude)
    end

    local args = {
        {
            FirstAreaSlotKey = firstAreaSlotKey,
            Uid = uidAttr
        }
    }

    local success = false

    pcall(function()

        if eggRequest:IsA("RemoteFunction") then

            eggRequest:InvokeServer(unpack(args))
            success = true

        elseif eggRequest:IsA("RemoteEvent") then

            eggRequest:FireServer(unpack(args))
            success = true
        end

    end)

    return success
end

--==================================================
-- GET PLOT
--==================================================

local function GetMyPlot()

    local plots = workspace:FindFirstChild("Plots")

    if not plots then
        return nil
    end

    local plot =
        plots:FindFirstChild(tostring(State.PlotNumber))

    return plot
end

--==================================================
-- RETURN TO PLOT
--==================================================

local function ReturnToPlot()

    local myPlot = GetMyPlot()

    if not myPlot then
        return false
    end

    local treadmillBottom =
        myPlot:FindFirstChild("TreadmillBottom")

    if not treadmillBottom then
        treadmillBottom =
            myPlot:FindFirstChild("Tread")
    end

    if not treadmillBottom then
        return false
    end

    if not treadmillBottom:IsA("BasePart") then
        return false
    end

    return TeleportWithTween(
        treadmillBottom.Position,
        State.ReturnSpeed
    )
end

--==================================================
-- MOVE TO ZONE
--==================================================

local function MoveToZone()

    local objects =
        workspace:FindFirstChild("__OBJECTS")

    if not objects then
        return false
    end

    local areas =
        objects:FindFirstChild("Areas")

    if not areas then
        return false
    end

    local guardAreas =
        areas:FindFirstChild("GuardAreas")

    if not guardAreas then
        return false
    end

    local targetZone =
        guardAreas:FindFirstChild(State.CurrentZone)

    if not targetZone then
        return false
    end

    local bounds =
        targetZone:FindFirstChild("Bounds")

    if not bounds then
        return false
    end

    if not bounds:IsA("BasePart") then
        return false
    end

    return TeleportWithTween(
        bounds.Position,
        State.FlySpeed
    )
end

--==================================================
-- AUTO FARM LOOP
--==================================================

local function StartAutomationLoop()

    while ScreenGui and ScreenGui.Parent do

        task.wait(0.5)

        if not State.AutoFarmEggs then
            continue
        end

        local eggsToCollect =
            GetAvailableEggs(State.CurrentZone)

        if #eggsToCollect > 0 then

            for _, egg in ipairs(eggsToCollect) do

                if not State.AutoFarmEggs then
                    break
                end

                if not egg then
                    continue
                end

                if not egg.Parent then
                    continue
                end

                local success =
                    TeleportWithTween(
                        egg.Position,
                        State.FlySpeed
                    )

                if success and State.AutoFarmEggs then

                    ClaimEggNetwork(egg)

                    task.wait(0.08)
                end
            end

            if State.AutoFarmEggs then
                ReturnToPlot()
            end

        else

            MoveToZone()

            task.wait(0.3)
        end
    end
end

--==================================================
-- MASTER BUTTON
--==================================================

MasterToggle.MouseButton1Click:Connect(function()

    State.AutoFarmEggs =
        not State.AutoFarmEggs

    if State.AutoFarmEggs then

        MasterToggle.BackgroundColor3 =
            Color3.fromRGB(50, 180, 50)

        MasterToggle.Text =
            "เปิดใช้งานระบบฟาร์มอยู่ (กดเพื่อปิด 🔴)"

    else

        MasterToggle.BackgroundColor3 =
            Color3.fromRGB(200, 50, 50)

        MasterToggle.Text =
            "ปิดระบบการฟาร์มอยู่ (กดเพื่อเปิด 🟢)"
    end
end)

--==================================================
-- START LOOP
--==================================================

task.spawn(StartAutomationLoop)

--==================================================
-- ANTI AFK
--==================================================

pcall(function()

    LocalPlayer.Idled:Connect(function()

        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(
                Vector2.new(0, 0)
            )
        end)

    end)

end)

--==================================================
-- CHARACTER RESPAWN SAFE
--==================================================

LocalPlayer.CharacterAdded:Connect(function()

    task.wait(1)

    if State.AutoFarmEggs then
        task.wait(1)
    end

end)

print("[Egg Auto Farm] Loaded successfully.")
