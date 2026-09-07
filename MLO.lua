-- [[ 🌟 CAMP SCRIPT HUB - MM2 GOD MODE V7 (ULTIMATE CHEAT) 🌟 ]]
-- รันบน Delta | ล็อกเป้ากระสุนวาร์ป 100% | วาร์ปเก็บปืนอัปเดตถี่ | เตะอัตโนมัติแบบเลวร้ายที่สุด

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- สร้าง ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CampScript_Premium_Hub_V7"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- 1. ฟังก์ชันสแกนหาบทบาทและตรวจสอบขั้นลึก (Advanced Role Scanner)
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
-- 2. แผงปุ่มสไลด์เลื่อนคู่แบบลากย้ายได้ (Control Switch Panel)
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

-- [สไลด์ที่ 1: Auto Gun วาร์ปเก็บปืน]
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

-- [สไลด์ที่ 2: Buff Speed 25 & Jump 50]
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

-- [สไลด์ที่ 3: ระบบวาร์ปเตะฆาตกร/นายอำเภออัตโนมัติ (Auto Fling Kick)]
local Slider3Frame = Instance.new("Frame")
Slider3Frame.Size = UDim2.new(1, -10, 0, 35)
Slider3Frame.Position = UDim2.new(0, 5, 0, 90)
Slider3Frame.BackgroundTransparency = 1
Slider3Frame.Parent = MainControlPanel

local Slider3Text = Instance.new("TextLabel")
Slider3Text.Size = UDim2.new(0, 90, 1, 0)
Slider3Text.BackgroundTransparency = 1
Slider3Text.Text = "⛔ Auto Kick Bad"
Slider3Text.TextColor3 = Color3.fromRGB(255, 100, 100)
Slider3Text.Font = Enum.Font.SourceSansBold
Slider3Text.TextSize = 13
Slider3Text.TextXAlignment = Enum.TextXAlignment.Left
Slider3Text.Parent = Slider3Frame

local Track3 = Instance.new("Frame")
Track3.Size = UDim2.new(0, 45, 0, 20)
Track3.Position = UDim2.new(0.65, 0, 0.2, 0)
Track3.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Track3.Parent = Slider3Frame
Instance.new("UICorner", Track3).CornerRadius = UDim.new(1, 0)

local Circle3 = Instance.new("TextButton")
Circle3.Size = UDim2.new(0, 16, 0, 16)
Circle3.Position = UDim2.new(0.05, 0, 0.1, 0)
Circle3.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
Circle3.Text = ""
Circle3.Parent = Track3
Instance.new("UICorner", Circle3).CornerRadius = UDim.new(1, 0)

local autoKickBadRoles = false
Circle3.MouseButton1Click:Connect(function()
    autoKickBadRoles = not autoKickBadRoles
    if autoKickBadRoles then
        TweenService:Create(Circle3, TweenInfo.new(0.2), {Position = UDim2.new(0.55, 0, 0.1, 0)}):Play()
        TweenService:Create(Track3, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 0, 0)}):Play()
    else
        TweenService:Create(Circle3, TweenInfo.new(0.2), {Position = UDim2.new(0.05, 0, 0.1, 0)}):Play()
        TweenService:Create(Track3, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end
end)

----------------------------------------------------------------
-- 3. ไอคอนลอยแยกชิ้น ลากเลื่อนอิสระ (Separated Draggable Icons)
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

-- ระบบบังคับเปิดปุ่มตรวจสอบบทบาท Real-time
RunService.Heartbeat:Connect(function()
KillIcon.Visible = (getKnife() ~= nil)
ShootIcon.Visible = (getGun() ~= nil)
end)

-- 4. ฟังก์ชันกดปุ่ม: ดึงฟัน และ ล็อกเป้ากระสุนวาร์ปกลางหลังฆาตกร

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

-- ปุ่มยิงปืน: ล็อกกระสุนพุ่งปักเป้าหมาย 100% พร้อมวาดเส้นเลเซอร์สีแดง
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

-- ล็อกทิศทางมุมกล้องไปที่เป้าหมายทันที
root.CFrame = CFrame.lookAt(root.Position, Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z))

-- [[ GOD MODE SILENT AIM BULLET LOCK ]]
-- สั่งยิงโดยบังคับพิกัดรีโมทส่งตรงเข้าไปที่พิกัดของตัวฆาตกรโดยตรง (กระสุนวาร์ปปักเป้าหมาย)
local shootRemote = gun:FindFirstChild("Shoot") or ReplicatedStorage:FindFirstChild("Shoot")
if shootRemote and shootRemote:IsA("RemoteEvent") then
shootRemote:FireServer(targetRoot.Position)
else
gun:Activate()
end

-- วาดเส้นเลเซอร์สีแดงนีออนพุ่งทะลวงจากกระบอกปืนสับเข้ากลางตัวฆาตกรแบบชัดเจน
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

-- 5. ระบบวนลูปอัปเดตค่า Auto Grab Gun เมื่อเปิดสวิตช์ (Fixed)

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

-- 6. ระบบล็อกค่า Buff ความเร็ว 25 และกระโดด 50

task.spawn(function()
while task.wait(0.5) do
if buffEnabled then
local char = LocalPlayer.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if hum then hum.WalkSpeed = 25 hum.JumpPower = 50 end
end
end
end)

-- 7. ระบบโค้ดเลวร้าย: บังคับวาร์ปหมุนสปีดเตะฆาตกรและนายอำเภอหลุดแมปอัตโนมัติ

local function runFlingKick(targetPlayer)
local char = LocalPlayer.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if not root or not targetPlayer or not targetPlayer.Character then return end
local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
if not targetRoot then return end

local savedCFrame = root.CFrame

-- ใส่แรงหมุนความเร็วสูงระดับฟิสิกส์หลุดแมป
local angularV = Instance.new("AngularVelocity")
angularV.MaxTorque = math.huge
angularV.AngularVelocity = Vector3.new(0, 99999, 0)
angularV.Attachment0 = root:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", root)
angularV.Parent = root

local tStart = tick()
repeat
root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 0.05)
task.wait()
until not targetPlayer or not targetPlayer.Character or (tick() - tStart > 1.2)

angularV:Destroy()
root.CFrame = savedCFrame
end

-- ลูปเช็กฆาตกรและนายอำเภอเพื่อสั่งลากไปเตะหลุดโลกทันที
task.spawn(function()
while task.wait(0.5) do
if autoKickBadRoles then
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character then
local role = getRole(p)
if role == "MURDERER" or role == "SHERIFF" then
runFlingKick(p)
task.wait(0.2)
end
end
end
end
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
local role = getRole(p)
if role == "MURDERER" then
applyESP(p, Color3.fromRGB(255, 0, 0), "MURDERER")
elseif role == "SHERIFF" then
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

