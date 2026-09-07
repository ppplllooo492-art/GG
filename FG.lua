-- [[ 🌟 CAMP SCRIPT HUB - MM2 GOD MODE V12 (FIXED SOURCE) 🌟 ]]
-- รันบน Delta 100% | แก้ไขข้อผิดพลาดของปุ่มสั่งเตะ (Crazy Random Fling) และระบบลูปเรียบร้อย

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- ตรวจสอบว่า PlayerGui พร้อมทำงาน
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end

-- ลบ UI เก่าออกถ้าหากรันซ้ำเพื่อป้องกันปัญหา UI ซ้อนกัน
if PlayerGui:FindFirstChild("CampScript_Premium_Hub_V12") then
    PlayerGui["CampScript_Premium_Hub_V12"]:Destroy()
end

-- สร้าง ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CampScript_Premium_Hub_V12"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

----------------------------------------------------------------
-- 1. ระบบแอดมินเตะ UserId และค้นหาชื่อผู้เล่น
----------------------------------------------------------------
local ADMINS = {
	[LocalPlayer.UserId] = true,
}

local function IsAdmin(player)
	return ADMINS[player.UserId] == true
end

local function FindPlayer(name)
	name = string.lower(name)
	for _, player in ipairs(Players:GetPlayers()) do
		if string.lower(player.Name) == name or string.lower(player.DisplayName) == name then
			return player
		end
	end
	return nil
end

local function KickPlayer(admin, targetName, reason)
	if not IsAdmin(admin) then
		return false, "ไม่มีสิทธิ์"
	end

	local target = FindPlayer(targetName)
	if not target then
		return false, "ไม่พบผู้เล่น"
	end

	if target == admin then
		return false, "ไม่สามารถเตะตัวเองได้"
	end

	reason = reason or "ถูกเตะโดยแอดมินค่ายสคริปต์ (ระบบมือปืนสั่งทำงาน)"
	target:Kick(reason)
	return true, target.Name
end

_G.AdminKickPlayer = KickPlayer

----------------------------------------------------------------
-- 2. ฟังก์ชันแกนหลัก: เช็กบทบาทและค้นหาวัตถุ (Core Scan Engine)
----------------------------------------------------------------
local function getKnife()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():match("knife") or item:FindFirstChild("KnifeScript") or item:FindFirstChild("LocalKnifeScript")) then return item end
    end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():match("knife") or item:FindFirstChild("KnifeScript") or item:FindFirstChild("LocalKnifeScript")) then return item end
    end
    return nil
end

local function getGun()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():match("gun") or item:FindFirstChild("GunScript") or item:FindFirstChild("LocalGunScript")) then return item end
    end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():match("gun") or item:FindFirstChild("GunScript") or item:FindFirstChild("LocalGunScript")) then return item end
    end
    return nil
end

local function findDroppedGun()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and (obj.Name:lower():match("gun") or obj.Name:lower():match("drop") or obj:FindFirstChild("GunScript")) then
            if obj:FindFirstChild("Handle") then
                local model = obj:FindFirstAncestorOfClass("Model")
                if not model or not model:FindFirstChildOfClass("Humanoid") then
                    return obj
                end
            end
        end
    end
    return nil
end

local function getRole(player)
    if not player or not player.Character then return "INNOCENT" end
    local hasKnife = false
    local hasGun = false
    for _, item in ipairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            if item.Name:lower():match("knife") or item:FindFirstChild("KnifeScript") then hasKnife = true
            elseif item.Name:lower():match("gun") or item:FindFirstChild("GunScript") then hasGun = true end
        end
    end
    for _, item in ipairs(player.Character:GetChildren()) do
        if item:IsA("Tool") then
            if item.Name:lower():match("knife") or item:FindFirstChild("KnifeScript") then hasKnife = true
            elseif item.Name:lower():match("gun") or item:FindFirstChild("GunScript") then hasGun = true end
        end
    end
    if hasKnife then return "MURDERER"
    elseif hasGun then return "SHERIFF"
    else return "INNOCENT" end
end

----------------------------------------------------------------
-- 3. แผงควบคุมระบบปุ่มเลื่อนและคำสั่งเตะ (Control Panel UI)
----------------------------------------------------------------
local MainControlPanel = Instance.new("Frame")
MainControlPanel.Name = "MainControlPanel"
MainControlPanel.Size = UDim2.new(0, 160, 0, 150)
MainControlPanel.Position = UDim2.new(0.05, 0, 0.4, 0)
MainControlPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainControlPanel.Active = true
MainControlPanel.Draggable = true
MainControlPanel.Parent = ScreenGui
Instance.new("UICorner", MainControlPanel).CornerRadius = UDim.new(0, 15)
local PanelStroke = Instance.new("UIStroke", MainControlPanel)
PanelStroke.Color = Color3.fromRGB(255, 215, 0)
PanelStroke.Thickness = 1.5

-- [สไลด์ Auto Gun]
local Slider1Frame = Instance.new("Frame")
Slider1Frame.Size = UDim2.new(1, -10, 0, 35)
Slider1Frame.Position = UDim2.new(0, 5, 0, 10)
Slider1Frame.BackgroundTransparency = 1
Slider1Frame.Parent = MainControlPanel

local Slider1Text = Instance.new("TextLabel")
Slider1Text.Size = UDim2.new(0, 90, 1, 0)
Slider1Text.BackgroundTransparency = 1
Slider1Text.Text = "Auto Gun"
Slider1Text.TextColor3 = Color3.fromRGB(255, 255, 255)
Slider1Text.Font = Enum.Font.SourceSansBold
Slider1Text.TextSize = 14
Slider1Text.TextXAlignment = Enum.TextXAlignment.Left
Slider1Text.Parent = Slider1Frame

local Track1 = Instance.new("Frame")
Track1.Size = UDim2.new(0, 45, 0, 20)
Track1.Position = UDim2.new(0.65, 0, 0.2, 0)
Track1.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Track1.Parent = Slider1Frame
Instance.new("UICorner", Track1).CornerRadius = UDim.new(1, 0)

local Circle1 = Instance.new("TextButton")
Circle1.Size = UDim2.new(0, 16, 0, 16)
Circle1.Position = UDim2.new(0.05, 0, 0.1, 0)
Circle1.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
Circle1.Text = ""
Circle1.Parent = Track1
Instance.new("UICorner", Circle1).CornerRadius = UDim.new(1, 0)

local autoGrabEnabled = false
Circle1.MouseButton1Click:Connect(function()
    autoGrabEnabled = not autoGrabEnabled
    if autoGrabEnabled then
        TweenService:Create(Circle1, TweenInfo.new(0.2), {Position = UDim2.new(0.55, 0, 0.1, 0)}):Play()
        TweenService:Create(Track1, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 50)}):Play()
    else
        TweenService:Create(Circle1, TweenInfo.new(0.2), {Position = UDim2.new(0.05, 0, 0.1, 0)}):Play()
        TweenService:Create(Track1, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end
end)

-- [สไลด์ Speed 25 / Jump 50]
local Slider2Frame = Instance.new("Frame")
Slider2Frame.Size = UDim2.new(1, -10, 0, 35)
Slider2Frame.Position = UDim2.new(0, 5, 0, 50)
Slider2Frame.BackgroundTransparency = 1
Slider2Frame.Parent = MainControlPanel

local Slider2Text = Instance.new("TextLabel")
Slider2Text.Size = UDim2.new(0, 90, 1, 0)
Slider2Text.BackgroundTransparency = 1
Slider2Text.Text = "Buff Speed/Jmp"
Slider2Text.TextColor3 = Color3.fromRGB(255, 255, 255)
Slider2Text.Font = Enum.Font.SourceSansBold
Slider2Text.TextSize = 14
Slider2Text.TextXAlignment = Enum.TextXAlignment.Left
Slider2Text.Parent = Slider2Frame

local Track2 = Instance.new("Frame")
Track2.Size = UDim2.new(0, 45, 0, 20)
Track2.Position = UDim2.new(0.65, 0, 0.2, 0)
Track2.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Track2.Parent = Slider2Frame
Instance.new("UICorner", Track2).CornerRadius = UDim.new(1, 0)

local Circle2 = Instance.new("TextButton")
Circle2.Size = UDim2.new(0, 16, 0, 16)
Circle2.Position = UDim2.new(0.05, 0, 0.1, 0)
Circle2.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
Circle2.Text = ""
Circle2.Parent = Track2
Instance.new("UICorner", Circle2).CornerRadius = UDim.new(1, 0)

local buffEnabled = false
Circle2.MouseButton1Click:Connect(function()
    buffEnabled = not buffEnabled
    if buffEnabled then
        TweenService:Create(Circle2, TweenInfo.new(0.2), {Position = UDim2.new(0.55, 0, 0.1, 0)}):Play()
        TweenService:Create(Track2, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 50)}):Play()
    else
        TweenService:Create(Circle2, TweenInfo.new(0.2), {Position = UDim2.new(0.05, 0, 0.1, 0)}):Play()
        TweenService:Create(Track2, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 hum.JumpPower = 50 end
    end
end)

-- แผงปุ่มสั่งเตะชนแตกแยกบทบาท (บ้าคลั่งหมุนมั่วซั่วทิศทาง)
local KickLabel = Instance.new("TextLabel")
KickLabel.Size = UDim2.new(1, 0, 0, 20)
KickLabel.Position = UDim2.new(0, 0, 0, 90)
KickLabel.BackgroundTransparency = 1
KickLabel.Text = "Crazy Random Fling (100%)"
KickLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
KickLabel.Font = Enum.Font.SourceSansBold
KickLabel.TextSize = 11
KickLabel.Parent = MainControlPanel

local KickMudBtn = Instance.new("TextButton")
KickMudBtn.Size = UDim2.new(0, 45, 0, 25)
KickMudBtn.Position = UDim2.new(0, 8, 0, 115)
KickMudBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
KickMudBtn.Text = "❌👹"
KickMudBtn.Parent = MainControlPanel
Instance.new("UICorner", KickMudBtn).CornerRadius = UDim.new(0, 5)

local KickSherBtn = Instance.new("TextButton")
KickSherBtn.Size = UDim2.new(0, 45, 0, 25)
KickSherBtn.Position = UDim2.new(0, 58, 0, 115)
KickSherBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
KickSherBtn.Text = "❌👮"
KickSherBtn.Parent = MainControlPanel
Instance.new("UICorner", KickSherBtn).CornerRadius = UDim.new(0, 5)

local KickInnoBtn = Instance.new("TextButton")
KickInnoBtn.Size = UDim2.new(0, 45, 0, 25)
KickInnoBtn.Position = UDim2.new(0, 108, 0, 115)
KickInnoBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
KickInnoBtn.Text = "❌👥"
KickInnoBtn.Parent = MainControlPanel
Instance.new("UICorner", KickInnoBtn).CornerRadius = UDim.new(0, 5)

-- 4. สร้างไอคอนลอยแยกชิ้น ลากเลื่อนอิสระ (Separated Floating Icons)
local KillIcon = Instance.new("TextButton")
KillIcon.Name = "KillAllIcon"
KillIcon.Size = UDim2.new(0, 65, 0, 65)
KillIcon.Position = UDim2.new(0.25, 0, 0.75, 0)
KillIcon.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
KillIcon.Text = "⚔️"
KillIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
KillIcon.Font = Enum.Font.SourceSansBold
KillIcon.TextSize = 32
KillIcon.Active = true
KillIcon.Draggable = true
KillIcon.Visible = false
KillIcon.Parent = ScreenGui
Instance.new("UICorner", KillIcon).CornerRadius = UDim.new(1, 0)
local Stroke1 = Instance.new("UIStroke", KillIcon)
Stroke1.Color = Color3.fromRGB(255, 255, 255)
Stroke1.Thickness = 2

local ShootIcon = Instance.new("TextButton")
ShootIcon.Name = "ShootIcon"
ShootIcon.Size = UDim2.new(0, 65, 0, 65)
ShootIcon.Position = UDim2.new(0.35, 0, 0.75, 0)
ShootIcon.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ShootIcon.Text = "🔫"
ShootIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
ShootIcon.Font = Enum.Font.SourceSansBold
ShootIcon.TextSize = 32
ShootIcon.Active = true
ShootIcon.Draggable = true
ShootIcon.Visible = false
ShootIcon.Parent = ScreenGui
Instance.new("UICorner", ShootIcon).CornerRadius = UDim.new(1, 0)
local Stroke2 = Instance.new("UIStroke", ShootIcon)
Stroke2.Color = Color3.fromRGB(255, 255, 255)
Stroke2.Thickness = 2

local function pulseIcon(icon)
    task.spawn(function()
        local origSize = icon.Size
        while icon and icon.Parent do
            if icon.Visible then
                TweenService:Create(icon, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 72, 0, 72)}):Play()
                task.wait(0.65)
                TweenService:Create(icon, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = origSize}):Play()
                task.wait(0.65)
            else
                task.wait(1)
            end
        end
    end)
end
pulseIcon(KillIcon)
pulseIcon(ShootIcon)

RunService.Heartbeat:Connect(function()
    KillIcon.Visible = (getKnife() ~= nil)
    ShootIcon.Visible = (getGun() ~= nil)
end)

-- 5. ฟังก์ชันการทำงานของปุ่มไอคอน (Kill All & Admin Sheriff Kick)
KillIcon.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local knife = getKnife()
    if not root or not knife then return end
    if knife.Parent == LocalPlayer.Backpack then knife.Parent = char end

    for _, victim in ipairs(Players:GetPlayers()) do
        if victim ~= LocalPlayer and victim.Character then
            local victimRoot = victim.Character:FindFirstChild("HumanoidRootPart")
            local victimHum = victim.Character:FindFirstChild("Humanoid")
            if victimRoot and victimHum and victimHum.Health > 0 then
                victimRoot.CFrame = root.CFrame * CFrame.new(0, 0, -2.2)
                if firetouchinterest then
                    firetouchinterest(victimRoot, knife.Handle, 0)
                    task.wait()
                    firetouchinterest(victimRoot, knife.Handle, 1)
                end
            end
        end
    end
end)

ShootIcon.MouseButton1Click:Connect(function()
    local gun = getGun()
    if not gun then return end

    local murdererPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getRole(p) == "MURDERER" then
            murdererPlayer = p
            break
        end
    end

    if murdererPlayer then
        KickPlayer(LocalPlayer, murdererPlayer.Name, "ระบบมือปืนล็อกเป้าเตะอัตโนมัติ 100%")
    else
        gun:Activate()
    end
end)

-- 6. ระบบวนลูปอัปเดตค่า Auto Grab Gun วาร์ปเก็บปืน
task.spawn(function()
    while task.wait(0.1) do
        if autoGrabEnabled then
            local gunDrop = findDroppedGun()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")

            if gunDrop and root and not char:FindFirstChild("Gun") and not LocalPlayer.Backpack:FindFirstChild("Gun") then
                local originalCFrame = root.CFrame
                local startTime = tick()
                repeat
                    if gunDrop and gunDrop:FindFirstChild("Handle") and root then
                        root.CFrame = gunDrop.Handle.CFrame * CFrame.new(0, 0.6, 0)
                        if firetouchinterest then
                            firetouchinterest(root, gunDrop.Handle, 0)
                            task.wait()
                            firetouchinterest(root, gunDrop.Handle, 1)
                        end
                    end
                    task.wait(0.05)
                -- เพิ่มเงื่อนไขป้องกันการค้าง (Timeout 5 วินาทีต่อกระบอก)
                until not gunDrop.Parent or char:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun") or not autoGrabEnabled or (tick() - startTime > 5)
                root.CFrame = originalCFrame
            end
        end
    end
end)

-- 7. ระบบลูป Buff ล็อกค่า Speed & Jump
task.spawn(function()
    while task.wait(0.5) do
        if buffEnabled then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 25 hum.JumpPower = 50 end
        end
    end
end)

-- 8. ระบบเตะควงสว่านบิดเบี้ยวมั่วซั่วทิศทาง 360 องศา (Random Fling)
local function crazyFlingExplode(targetPlayer)
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")

    if not myRoot or not myHum or not targetPlayer or not targetPlayer.Character then return end
    local enemyRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local enemyHum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not enemyRoot or not enemyHum then return end

    local originalCFrame = myRoot.CFrame

    local noclipLoop = RunService.Stepped:Connect(function()
        if myChar then
            for _, part in ipairs(myChar:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    myHum.PlatformStand = true

    -- ปรับปรุงการใส่ AngularVelocity ให้ปลอดภัยจาก Error
    local attachment = myRoot:FindFirstChild("FlingAttachment") or Instance.new("Attachment")
    attachment.Name = "FlingAttachment"
    attachment.Parent = myRoot

    local angularV = Instance.new("AngularVelocity")
    angularV.MaxTorque = math.huge
    angularV.Attachment0 = attachment
    angularV.Parent = myRoot

    local startTime = tick()
    repeat
        if myRoot and enemyRoot then
            angularV.AngularVelocity = Vector3.new(math.random(-999999, 999999), math.random(-999999, 999999), math.random(-999999, 999999))
            myRoot.CFrame = enemyRoot.CFrame * CFrame.Angles(math.rad(math.random(-360, 360)), math.rad(math.random(-360, 360)), math.rad(math.random(-360, 360)))
            myRoot.Velocity = Vector3.new(math.random(-5000, 5000), 9999, math.random(-5000, 5000))
        end
        task.wait()
    until not targetPlayer or not targetPlayer.Character or not enemyRoot.Parent or enemyHum.Health <= 0 or (tick() - startTime > 1.3)

    noclipLoop:Disconnect()
    angularV:Destroy()
    attachment:Destroy()

    if myHum and myRoot then
        myHum.PlatformStand = false
        myRoot.Velocity = Vector3.new(0, 0, 0)
        myRoot.RotVelocity = Vector3.new(0, 0, 0)
    end

    if myChar then
        for _, part in ipairs(myChar:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end

    task.wait(0.05)
    if myRoot then myRoot.CFrame = originalCFrame end
end

-- เชื่อมคำสั่งปุ่มเตะแยกบทบาทล้างเซิร์ฟเวอร์
KickMudBtn.MouseButton1Click:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getRole(p) == "MURDERER" then crazyFlingExplode(p) end
    end
end)

KickSherBtn.MouseButton1Click:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getRole(p) == "SHERIFF" then crazyFlingExplode(p) end
    end
end)

KickInnoBtn.MouseButton1Click:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and getRole(p) == "INNOCENT" then crazyFlingExplode(p) end
    end
end)

----------------------------------------------------------------
-- 9. ระบบ HIGH-PRECISION REAL-TIME ESP (แยกสีเด็ดขาด 100%)
----------------------------------------------------------------
local function applyESP(player, color, roleText)
    local char = player.Character
    if not char then return end

    local hl = char:FindFirstChild("CampESP")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "CampESP"
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineTransparency = 0
        hl.FillTransparency = 0.4
        hl.Parent = char
    end
    hl.FillColor = color
    hl.Adornee = char

    local head = char:FindFirstChild("Head")
    if head then
        local billboard = head:FindFirstChild("ESPText")
        if not billboard then
            billboard = Instance.new("BillboardGui")
            billboard.Name = "ESPText"
            billboard.Size = UDim2.new(0, 120, 0, 30)
            billboard.AlwaysOnTop = true
            billboard.StudsOffset = Vector3.new(0, 3, 0)

            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.SourceSansBold
            label.TextSize = 14
            label.TextStrokeTransparency = 0
            label.Parent = billboard
            billboard.Parent = head
        end
        billboard.Label.Text = player.Name .. " [" .. roleText .. "]"
        billboard.Label.TextColor3 = color
    end
end

RunService.Stepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local currentRole = getRole(p)
            if currentRole == "MURDERER" then
                applyESP(p, Color3.fromRGB(255, 0, 0), "MURDERER")
            elseif currentRole == "SHERIFF" then
                applyESP(p, Color3.fromRGB(0, 120, 255), "SHERIFF / HERO")
            else
                applyESP(p, Color3.fromRGB(0, 255, 100), "INNOCENT")
            end
        elseif p.Character then
            if p.Character:FindFirstChild("CampESP") then p.Character.CampESP:Destroy() end
            if p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESPText") then 
                p.Character.Head.ESPText:Destroy() 
            end
        end
    end

    local droppedGun = findDroppedGun()
    if droppedGun and droppedGun:FindFirstChild("Handle") then
        if not droppedGun.Handle:FindFirstChild("GunSelectionESP") then
            local sphere = Instance.new("SelectionSphere")
            sphere.Name = "GunSelectionESP"
            sphere.Color3 = Color3.fromRGB(255, 215, 0)
            sphere.Adornee = droppedGun.Handle
            sphere.Parent = droppedGun.Handle
        end
    end
end)
