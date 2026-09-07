-- [[ 🌟 CAMP SCRIPT HUB - MM2 GOD MODE V8 (ULTIMATE KICK FLING) 🌟 ]]
-- รันบน Delta 100% | ระบบเตะชนแตกหลุดแมป 100% แยกบทบาท | กระสุนล็อกเป้าวาร์ปปักลำตัว | ESP แท้

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- สร้าง ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CampScript_Premium_Hub_V8"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- 1. ฟังก์ชันแกนหลัก: เช็กบทบาทและค้นหาวัตถุ (Core Engine)
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
            if obj:FindFirstChild("Handle") and not obj:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid") then
                return obj
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
-- 2. แผงปุ่มสไลด์เลื่อนคู่และปุ่มเตะแยกบทบาท (Control Panel UI)
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

-- แผงคำสั่งปุ่มเตะแยกบทบาท
local KickLabel = Instance.new("TextLabel")
KickLabel.Size = UDim2.new(1, 0, 0, 20)
KickLabel.Position = UDim2.new(0, 0, 0, 90)
KickLabel.BackgroundTransparency = 1
KickLabel.Text = "Ultimate Fling Kick (100%)"
KickLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
KickLabel.Font = Enum.Font.SourceSansBold
KickLabel.TextSize = 12
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

----------------------------------------------------------------
-- 3. สร้างไอคอนลอยแยกชิ้น ลากเลื่อนอิสระ (Separated Floating Icons)
----------------------------------------------------------------
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
while icon.Parent do
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

-- 4. ฟังก์ชันการทำงานของปุ่มไอคอน (Kill All & God Silent Aim)

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
local char = LocalPlayer.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local gun = getGun()

local murdererPlayer = nil
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and getRole(p) == "MURDERER" then murdererPlayer = p break end
end
if not root or not gun or not murdererPlayer or not murdererPlayer.Character then return end
local targetRoot = murdererPlayer.Character:FindFirstChild("HumanoidRootPart") or murdererPlayer.Character:FindFirstChild("UpperTorso")
if not targetRoot then return end

if gun.Parent == LocalPlayer.Backpack then gun.Parent = char end
task.wait(0.05)

root.CFrame = CFrame.lookAt(root.Position, Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z))

-- [[ GOD MODE BULLET UNFAIR LOCK ]] เขียนทับพิกัดส่งค่าแรงกระสุนวาร์ปปังเดียวดับกลางลำตัว
local shootRemote = gun:FindFirstChild("Shoot") or ReplicatedStorage:FindFirstChild("Shoot")
if shootRemote and shootRemote:IsA("RemoteEvent") then
shootRemote:FireServer(targetRoot.Position)
else
gun:Activate()
end

local laser = Instance.new("Part")
local dist = (root.Position - targetRoot.Position).Magnitude
laser.Size = Vector3.new(0.15, 0.15, dist)
laser.CFrame = CFrame.lookAt(root.Position, targetRoot.Position) * CFrame.new(0, 0, -dist/2)
laser.Color = Color3.fromRGB(255, 0, 0)
laser.Material = Enum.Material.Neon
laser.Anchored = true
laser.CanCollide = false
laser.Parent = Workspace
game:GetService("Debris"):AddItem(laser, 0.4)
end)

-- 5. ระบบวนลูปอัปเดตค่า Auto Grab Gun วาร์ปเก็บปืน

task.spawn(function()
while task.wait(0.1) do
if autoGrabEnabled then
local gunDrop = findDroppedGun()
local char = LocalPlayer.Character
local root = char and char:FindFirstChild("HumanoidRootPart")

if gunDrop and root and not char:FindFirstChild("Gun") and not LocalPlayer.Backpack:FindFirstChild("Gun") then
local originalCFrame = root.CFrame
repeat
root.CFrame = gunDrop.Handle.CFrame * CFrame.new(0, 0.6, 0)
if firetouchinterest then
firetouchinterest(root, gunDrop.Handle, 0)
task.wait()
firetouchinterest(root, gunDrop.Handle, 1)
end
task.wait(0.05)
until not gunDrop.Parent or char:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun") or not autoGrabEnabled
root.CFrame = originalCFrame
end
end
end
end)

-- 6. ระบบลูป Buff ล็อกค่า Speed & Jump

task.spawn(function()
while task.wait(0.5) do
if buffEnabled then
local char = LocalPlayer.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if hum then hum.WalkSpeed = 25 hum.JumpPower = 50 end
end
end
end)

-- 7. [[ ULTIMATE FLING KICK ENGINE - ชนแตกหลุดแมป 100% ]]

local function ultimateFlingKick(targetPlayer)
local char = LocalPlayer.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not root or not hum or not targetPlayer or not targetPlayer.Character then return end
local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
if not targetRoot then return end

local originalPosition = root.CFrame

-- สร้างแรงเหวี่ยงฟิสิกส์ระดับขีดสุด (Infinite Torque Glitch) บังคับตัวละครหมุนทะลวงพิกัดเซิร์ฟเวอร์
local velocityObject = Instance.new("AngularVelocity")
velocityObject.MaxTorque = math.huge
velocityObject.AngularVelocity = Vector3.new(0, 999999, 0) -- เร่งความเร็วรอบทิศทางจนตัวแกะออกจากฟิสิกส์ปกติ
velocityObject.Attachment0 = root:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", root)
velocityObject.Parent = root

-- ล็อกตัวละครให้ไม่มีแรงต้าน Collide ชั่วคราวเพื่อทะลวงเข้ากลางตัวเหยื่อแล้วดีดออก
hum.PlatformStand = true

local startTime = tick()
repeat
-- ใช้เทคนิคการขยับ CFrame สลับจุดหน้าหลังซ้ายขวาเหยื่อในหลักมิลลิวินาที บังคับตัวเหยื่อระเบิดชิ้นส่วนหลุดแมปแน่นอน 100%
root.CFrame = targetRoot.CFrame * CFrame.new(math.random(-1,1)/10, 0, math.random(-1,1)/10)
root.Velocity = Vector3.new(0, 500, 0) -- เพิ่มแรงดีดส่งขึ้นฟ้า
task.wait()
until not targetPlayer or not targetPlayer.Character or not targetRoot.Parent or (tick() - startTime > 1.2)

-- เคลียร์ออบเจ็กต์ฟิสิกส์ออกและวาร์ปเรากลับที่เดิมอย่างปลอดภัย
velocityObject:Destroy()
hum.PlatformStand = false
root.Velocity = Vector3.new(0, 0, 0)
root.RotVelocity = Vector3.new(0, 0, 0)
task.wait(0.05)
root.CFrame = originalPosition
end

KickMudBtn.MouseButton1Click:Connect(function()
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and getRole(p) == "MURDERER" then ultimateFlingKick(p) end
end
end)

KickSherBtn.MouseButton1Click:Connect(function()
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and getRole(p) == "SHERIFF" then ultimateFlingKick(p) end
end
end)

KickInnoBtn.MouseButton1Click:Connect(function()
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and getRole(p) == "INNOCENT" then ultimateFlingKick(p) end
end
end)

-- 8. ระบบ HIGH-PRECISION REAL-TIME ESP (แยกสีเด็ดขาด 100%)

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
elseif p.Character and p.Character:FindFirstChild("CampESP") then
p.Character.CampESP:Destroy()
if p.Character.Head:FindFirstChild("ESPText") then p.Character.Head.ESPText:Destroy() end
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
