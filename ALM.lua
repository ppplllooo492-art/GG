-- [[ CAMP SCRIPT PREMIUM GOD-MODE V3 ALL-IN-ONE FOR MM2 ]]
-- เธฃเธฑเธเธเธ Delta เนเธ”เน 100% | เธฃเธงเธกเธเธธเนเธกเธชเนเธฅเธ”เนเนเธฅเธฐเนเธญเธเธญเธเธฅเธญเธขเนเธขเธเธเธดเนเธเธฅเธฒเธเธญเธดเธชเธฃเธฐ | ESP เธญเธฑเธเน€เธ”เธ•เน€เธเนเธฐ 100%

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- เธชเธฃเนเธฒเธ ScreenGui เธซเธฅเธฑเธ
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CampScript_Premium_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- 1. เธชเธฃเนเธฒเธเธเธธเนเธกเธชเนเธฅเธ”เนเน€เธฅเธทเนเธญเธ เน€เธเธดเธ”/เธเธดเธ” (Toggle Slider UI) เธชเธณเธซเธฃเธฑเธ Auto Gun
----------------------------------------------------------------
local SliderFrame = Instance.new("Frame")
SliderFrame.Name = "SliderFrame"
SliderFrame.Size = UDim2.new(0, 140, 0, 40)
SliderFrame.Position = UDim2.new(0.05, 0, 0.65, 0)
SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SliderFrame.Active = true
SliderFrame.Draggable = true
SliderFrame.Parent = ScreenGui
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 20)
local SliderStroke = Instance.new("UIStroke", SliderFrame)
SliderStroke.Color = Color3.fromRGB(255, 215, 0)
SliderStroke.Thickness = 1.5

local SliderText = Instance.new("TextLabel")
SliderText.Size = UDim2.new(0, 80, 1, 0)
SliderText.Position = UDim2.new(0, 10, 0, 0)
SliderText.BackgroundTransparency = 1
SliderText.Text = "Auto Gun"
SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderText.Font = Enum.Font.SourceSansBold
SliderText.TextSize = 14
SliderText.TextXAlignment = Enum.TextXAlignment.Left
SliderText.Parent = SliderFrame

local SlideTrack = Instance.new("Frame")
SlideTrack.Size = UDim2.new(0, 45, 0, 22)
SlideTrack.Position = UDim2.new(0.6, 0, 0.22, 0)
SlideTrack.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SlideTrack.Parent = SliderFrame
Instance.new("UICorner", SlideTrack).CornerRadius = UDim.new(1, 0)

local SlideCircle = Instance.new("TextButton")
SlideCircle.Size = UDim2.new(0, 18, 0, 18)
SlideCircle.Position = UDim2.new(0.05, 0, 0.1, 0)
SlideCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
SlideCircle.Text = ""
SlideCircle.Parent = SlideTrack
Instance.new("UICorner", SlideCircle).CornerRadius = UDim.new(1, 0)

local autoGrabEnabled = false

SlideCircle.MouseButton1Click:Connect(function()
    autoGrabEnabled = not autoGrabEnabled
    if autoGrabEnabled then
        TweenService:Create(SlideCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.55, 0, 0.1, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(SlideTrack, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(0, 180, 50)}):Play()
    else
        TweenService:Create(SlideCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.05, 0, 0.1, 0), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        TweenService:Create(SlideTrack, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end
end)

----------------------------------------------------------------
-- 2. เธชเธฃเนเธฒเธเนเธญเธเธญเธเธฅเธญเธขเนเธขเธเธเธดเนเธ เธฅเธฒเธเน€เธฅเธทเนเธญเธเธญเธดเธชเธฃเธฐ (Separated Draggable Icons)
----------------------------------------------------------------
local KillIcon = Instance.new("TextButton")
KillIcon.Name = "KillAllIcon"
KillIcon.Size = UDim2.new(0, 65, 0, 65)
KillIcon.Position = UDim2.new(0.2, 0, 0.75, 0)
KillIcon.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
KillIcon.Text = "โ”๏ธ"
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
ShootIcon.Position = UDim2.new(0.3, 0, 0.75, 0)
ShootIcon.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ShootIcon.Text = "๐”ซ"
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

----------------------------------------------------------------
-- 3. เธฃเธฐเธเธเน€เธเนเธเธเนเธฒเธเธทเธ/เธกเธตเธ” Real-time เน€เธเธทเนเธญเน€เธเธดเธ”เธเธดเธ”เนเธญเธเธญเธเธญเธฑเธ•เนเธเธกเธฑเธ•เธดเธ•เธฒเธกเธเธ—เธเธฒเธ—
----------------------------------------------------------------
local function getKnife()
    local char = LocalPlayer.Character
    return char and (LocalPlayer.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife"))
end

local function getGun()
    local char = LocalPlayer.Character
    return char and (LocalPlayer.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Gun"))
end

task.spawn(function()
    while task.wait(0.3) do
        KillIcon.Visible = (getKnife() ~= nil)
        ShootIcon.Visible = (getGun() ~= nil)
    end
end)

----------------------------------------------------------------
-- 4. เธเธฑเธเธเนเธเธฑเธเธเธฒเธฃเธ—เธณเธเธฒเธเธเธญเธเธเธธเนเธกเนเธญเธเธญเธ (Kill All & Sheriff Silent Aim Shoot)
----------------------------------------------------------------
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

local function getMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then
            return p
        end
    end
    return nil
end

ShootIcon.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local gun = getGun()
    local mud = getMurderer()
    if not root or not gun or not mud or not mud.Character then return end
    local targetRoot = mud.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    if gun.Parent == LocalPlayer.Backpack then gun.Parent = char end
    task.wait(0.05)
    
    root.CFrame = CFrame.lookAt(root.Position, Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z))
    
    local shootRemote = gun:FindFirstChild("Shoot") or ReplicatedStorage:FindFirstChild("Shoot")
    if shootRemote and shootRemote:IsA("RemoteEvent") then
        shootRemote:FireServer(targetRoot.Position)
    else
        gun:Activate()
    end
    
    local laser = Instance.new("Part")
    local dist = (root.Position - targetRoot.Position).Magnitude
    laser.Size = Vector3.new(0.12, 0.12, dist)
    laser.CFrame = CFrame.lookAt(root.Position, targetRoot.Position) * CFrame.new(0, 0, -dist/2)
    laser.Color = Color3.fromRGB(255, 0, 0)
    laser.Material = Enum.Material.Neon
    laser.Anchored = true
    laser.CanCollide = false
    laser.Parent = Workspace
    game:GetService("Debris"):AddItem(laser, 0.4)
end)

----------------------------------------------------------------
-- 5. เธฃเธฐเธเธเธงเธเธฅเธนเธเธญเธฑเธเน€เธ”เธ•เธเนเธฒ Auto Grab Gun เน€เธกเธทเนเธญเน€เธเธดเธ”เธเธธเนเธกเน€เธฅเธทเนเธญเธเธชเนเธฅเธ”เน
----------------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if autoGrabEnabled then
            local gunDrop = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
            if gunDrop and gunDrop:IsA("Tool") and gunDrop:FindFirstChild("Handle") then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                
                if root and not char:FindFirstChild("Gun") and not LocalPlayer.Backpack:FindFirstChild("Gun") then
                    local originalCFrame = root.CFrame
                    
                    repeat
                        root.CFrame = gunDrop.Handle.CFrame + Vector3.new(0, 1, 0)
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
    end
end)

----------------------------------------------------------------
-- 6. เธฃเธฐเธเธ HIGH-PRECISION REAL-TIME ESP (เนเธขเธเธชเธตเน€เธ”เนเธ”เธเธฒเธ” 100%)
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
            local hasKnife = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
            local hasGun = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
            
            if hasKnife then
                applyESP(p, Color3.fromRGB(255, 0, 0), "MURDERER")
            elseif hasGun then
                applyESP(p, Color3.fromRGB(0, 120, 255), "SHERIFF / HERO")
            else
                applyESP(p, Color3.fromRGB(0, 255, 100), "INNOCENT")
            end
        elseif p.Character and p.Character:FindFirstChild("CampESP") then
            p.Character.CampESP:Destroy()
            if p.Character.Head:FindFirstChild("ESPText") then
                p.Character.Head.ESPText:Destroy()
            end
        end
    end
    
    local gunDrop = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
    if gunDrop and gunDrop:IsA("Tool") and gunDrop:FindFirstChild("Handle") then
        if not gunDrop.Handle:FindFirstChild("GunSelectionESP") then
            local sphere = Instance.new("SelectionSphere")
            sphere.Name = "GunSelectionESP"
            sphere.Color3 = Color3.fromRGB(255, 215, 0)
            sphere.Adornee = gunDrop.Handle
            sphere.Parent = gunDrop.Handle
        end
    end
end)
