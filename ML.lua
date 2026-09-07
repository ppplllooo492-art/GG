-- [[ GOD-MODE V4 ULTIMATE FOR MM2 SCRIPT HUB ]]
-- เธฃเธฑเธเธเธ Delta | เธเธฃเธฑเธเธเธฃเธธเธเธฃเธฐเธเธเธ•เธฃเธงเธเธเธฑเธเธเธทเธเธ•เธ + เธ•เธฃเธงเธเธเธฑเธเธเธ—เธเธฒเธ—เนเธซเนเธเธถเนเธ 100% | เธฅเธฒเธเธเธธเนเธกเนเธขเธเนเธ”เนเธญเธดเธชเธฃเธฐ

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- เธชเธฃเนเธฒเธ ScreenGui เธซเธฅเธฑเธ
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CampScript_Ultimate_Hub_V4"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- 1. เธชเธฃเนเธฒเธเธเธธเนเธกเธชเนเธฅเธ”เนเน€เธฅเธทเนเธญเธ เน€เธเธดเธ”/เธเธดเธ” (Toggle Slider UI) เธชเธณเธซเธฃเธฑเธ Auto Gun
----------------------------------------------------------------
local SliderFrame = Instance.new("Frame")
SliderFrame.Name = "SliderFrame"
SliderFrame.Size = UDim2.new(0, 140, 0, 40)
SliderFrame.Position = UDim2.new(0.05, 0, 0.5, 0) -- เธเธฃเธฑเธเธ•เธณเนเธซเธเนเธเนเธซเนเธญเธขเธนเนเธเธฅเธฒเธเธเธญเธเธฑเนเธเธเนเธฒเธขเน€เธซเนเธเธเธฑเธ”เน
SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SliderFrame.Active = true
SliderFrame.Draggable = true
SliderFrame.Parent = ScreenGui
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 10)
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
-- 2. เธชเธฃเนเธฒเธเนเธญเธเธญเธเธฅเธญเธขเนเธขเธเธเธดเนเธ เธฅเธฒเธเน€เธฅเธทเนเธญเธเธญเธดเธชเธฃเธฐ (FORCE VISIBLE เนเธเนเนเธเนเธซเนเธเธถเนเธ 100%)
----------------------------------------------------------------
-- [เนเธญเธเธญเธเธ”เธฒเธ]
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
KillIcon.Visible = false -- เธเธฐเน€เธเธดเธ”เน€เธกเธทเนเธญเธฃเธฐเธเธเธ•เธฃเธงเธเน€เธเธญเธกเธตเธ”
KillIcon.Parent = ScreenGui
Instance.new("UICorner", KillIcon).CornerRadius = UDim.new(1, 0)
local Stroke1 = Instance.new("UIStroke", KillIcon)
Stroke1.Color = Color3.fromRGB(255, 255, 255)
Stroke1.Thickness = 2

-- [เนเธญเธเธญเธเธเธทเธ]
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
ShootIcon.Visible = false -- เธเธฐเน€เธเธดเธ”เน€เธกเธทเนเธญเธฃเธฐเธเธเธ•เธฃเธงเธเน€เธเธญเธเธทเธ
ShootIcon.Parent = ScreenGui
Instance.new("UICorner", ShootIcon).CornerRadius = UDim.new(1, 0)
local Stroke2 = Instance.new("UIStroke", ShootIcon)
Stroke2.Color = Color3.fromRGB(255, 255, 255)
Stroke2.Thickness = 2

-- เนเธญเธเธดเน€เธกเธเธฑเธเธเธธเนเธกเธเธขเธฑเธเธขเธทเธ”เธซเธ”เน€เธเธฒเน เธ•เธฅเธญเธ”เน€เธงเธฅเธฒเน€เธเธดเนเธกเธเธงเธฒเธกเน€เธ—เน
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
                task.wait(0.5)
            end
        end
    end)
end
pulseIcon(KillIcon)
pulseIcon(ShootIcon)

----------------------------------------------------------------
-- 3. เธฃเธฐเธเธเธ•เธฃเธงเธเธเธฑเธเธญเธฒเธงเธธเธเนเธเธเธเธฑเนเธเน€เธ—เธ (เนเธเนเธเธฑเธเธซเธฒเธเธธเนเธกเธ”เธฒเธ/เธเธทเธเนเธกเนเธเธถเนเธ)
----------------------------------------------------------------
-- เธ•เธฃเธงเธเธชเธญเธเธญเธขเนเธฒเธเธฅเธฐเน€เธญเธตเธขเธ”เธ—เธฑเนเธเนเธ Backpack เนเธฅเธฐ Character เธเธญเธเธ•เธฑเธงเน€เธฃเธฒเน€เธญเธ
local function hasKnife(player)
    local p = player or LocalPlayer
    if not p then return false end
    local char = p.Character
    
    -- เน€เธเนเธเธ—เธฑเนเธเธเธทเนเธญ Knife เธซเธฃเธทเธญเนเธญเน€เธ—เธกเธ—เธตเนเธกเธต TouchInterest เธซเธฃเธทเธญเธกเธตเธเธณเธงเนเธฒ Knife เนเธเธเธทเนเธญเธชเธเธดเธ
    if p.Backpack:FindFirstChild("Knife") or (char and char:FindFirstChild("Knife")) then
        return true
    end
    for _, item in ipairs(p.Backpack:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():find("knife") or item:FindFirstChild("KnifeScript")) then
            return true
        end
    end
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and (item.Name:lower():find("knife") or item:FindFirstChild("KnifeScript")) then
                return true
            end
        end
    end
    return false
end

local function hasGun(player)
    local p = player or LocalPlayer
    if not p then return false end
    local char = p.Character
    
    if p.Backpack:FindFirstChild("Gun") or (char and char:FindFirstChild("Gun")) then
        return true
    end
    for _, item in ipairs(p.Backpack:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():find("gun") or item:FindFirstChild("GunScript")) then
            return true
        end
    end
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and (item.Name:lower():find("gun") or item:FindFirstChild("GunScript")) then
                return true
            end
        end
    end
    return false
end

-- เธฅเธนเธเธญเธฑเธเน€เธ”เธ•เธเธฒเธฃเนเธชเธ”เธเธเธฅเธเธธเนเธกเนเธญเธเธญเธเธ•เธฅเธญเธ”เน€เธงเธฅเธฒ (เนเธกเนเธกเธตเธเธฅเธฒเธ”)
task.spawn(function()
    while task.wait(0.2) do
        KillIcon.Visible = hasKnife(LocalPlayer)
        ShootIcon.Visible = hasGun(LocalPlayer)
    end
end)

----------------------------------------------------------------
-- 4. เธเธฑเธเธเนเธเธฑเธเธเธฒเธฃเธ—เธณเธเธฒเธเธเธญเธเธเธธเนเธกเนเธญเธเธญเธ (Kill All & Sheriff Silent Aim Shoot)
----------------------------------------------------------------
local function getMyKnifeTool()
    local char = LocalPlayer.Character
    local knife = LocalPlayer.Backpack:FindFirstChild("Knife") or (char and char:FindFirstChild("Knife"))
    if not knife then
        for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name:lower():find("knife") then knife = item break end
        end
    end
    if not knife and char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and item.Name:lower():find("knife") then knife = item break end
        end
    end
    return knife
end

KillIcon.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local knife = getMyKnifeTool()
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
        if p ~= LocalPlayer and hasKnife(p) then
            return p
        end
    end
    return nil
end

local function getMyGunTool()
    local char = LocalPlayer.Character
    local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or (char and char:FindFirstChild("Gun"))
    if not gun then
        for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name:lower():find("gun") then gun = item break end
        end
    end
    if not gun and char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and item.Name:lower():find("gun") then gun = item break end
        end
    end
    return gun
end

ShootIcon.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local gun = getMyGunTool()
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
-- 5. เนเธเนเนเธเธฃเธฐเธเธ AUTO GRAB GUN เธเธฑเนเธเธชเธนเธเธชเธธเธ” (เธญเธฑเธเน€เธ”เธ•เธ•เธณเนเธซเธเนเธเนเธฅเธฐเธชเนเธเธเธซเธฒเธเธทเธเธ•เธ 100%)
----------------------------------------------------------------
-- เธเธฑเธเธเนเธเธฑเธเธเนเธเธซเธฒเธเธทเธเธ•เธเธญเธขเนเธฒเธเธฅเธฐเน€เธญเธตเธขเธ”เนเธเธ—เธธเธเธเธญเธเธกเธธเธกเธเธญเธ Workspace
local function findDroppedGun()
    -- 1. เธซเธฒเนเธเธเธ•เธฃเธเธ•เธฑเธง (เธฃเธฐเธเธเธ”เธฑเนเธเน€เธ”เธดเธกเธเธญเธ MM2)
    local drop = Workspace:FindFirstChild("GunDrop")
    if drop and drop:IsA("Tool") and drop:FindFirstChild("Handle") then
        return drop
    end
    -- 2. เธเนเธเธซเธฒเนเธ Workspace เน€เธเธทเนเธญเธเธทเนเธญเน€เธเนเธเธญเธขเนเธฒเธเธญเธทเนเธเนเธ•เนเธกเธตเธเธธเธ“เธฅเธฑเธเธฉเธ“เธฐเน€เธเนเธเธเธทเธเธ—เธตเนเธ•เธเธเธทเนเธ
    for _, object in ipairs(Workspace:GetChildren()) do
        if object:IsA("Tool") and (object.Name:lower():find("gun") or object.Name == "Weapon") and object:FindFirstChild("Handle") then
            -- เธ•เนเธญเธเน€เธเนเธเธงเนเธฒเนเธกเนเนเธ”เนเธญเธขเธนเนเนเธเธ•เธฑเธงเธเธนเนเน€เธฅเนเธเธเธเธญเธทเนเธ
            return object
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(0.1) do
        if autoGrabEnabled then
            local gunDrop = findDroppedGun()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChild("Humanoid")
            
            -- เธ—เธณเธเธฒเธเน€เธกเธทเนเธญ: เธกเธตเธเธทเธเธ•เธเธเธเธเธทเนเธ + เน€เธฃเธฒเธขเธฑเธเธกเธตเธเธตเธงเธดเธ•เธญเธขเธนเน + เธ•เธฑเธงเน€เธฃเธฒเธขเธฑเธเนเธกเนเธกเธตเธเธทเธเธเธ
            if gunDrop and root and humanoid and humanoid.Health > 0 and not hasGun(LocalPlayer) then
                local originalCFrame = root.CFrame -- 1. เธเธฑเธเธ—เธถเธเธ•เธณเนเธซเธเนเธเธเธฑเธเธเธธเธเธฑเธเนเธงเนเธเนเธญเธเธงเธฒเธฃเนเธ
                
                -- เธงเธฒเธฃเนเธเนเธเธเธ•เนเธญเน€เธเธทเนเธญเธเธเธเธเธงเนเธฒเธเธฐเน€เธเนเธเธชเธณเน€เธฃเนเธ เธซเธฃเธทเธญเธเธทเธเธซเธฒเธขเนเธ
                local timeout = 0
                while gunDrop.Parent == Workspace and not hasGun(LocalPlayer) and autoGrabEnabled and timeout < 50 do
                    -- 2. เธงเธฒเธฃเนเธเนเธเธ—เธฑเธเธเธดเธเธฑเธ”เธเธทเธเธ•เธเนเธ”เธขเธ•เธฃเธ (เธเธงเธเธเธงเธฒเธกเธชเธนเธเน€เธฅเนเธเธเนเธญเธขเน€เธเธทเนเธญเธเธงเธฒเธกเน€เธเธตเธขเธ)
                    root.CFrame = gunDrop.Handle.CFrame + Vector3.new(0, 0.5, 0)
                    
                    -- เน€เธฃเนเธเธเธเธดเธเธดเธฃเธดเธขเธฒเธเธฒเธฃเธ”เธนเธ”เธเธญเธเน€เธเนเธฒเธ•เธฑเธง (FireTouchInterest)
                    if firetouchinterest and gunDrop:FindFirstChild("Handle") then
                        firetouchinterest(root, gunDrop.Handle, 0)
                        task.wait(0.02)
                        firetouchinterest(root, gunDrop.Handle, 1)
                    end
                    
                    timeout = timeout + 1
                    task.wait(0.05)
                end
                
                -- 3. เน€เธกเธทเนเธญเธเธทเธเน€เธเนเธฒเธ•เธฑเธงเน€เธฃเธตเธขเธเธฃเนเธญเธขเนเธฅเนเธง เนเธซเนเธงเธฒเธฃเนเธเธเธฅเธฑเธเธ•เธณเนเธซเธเนเธเน€เธ”เธดเธกเธ—เธฑเธเธ—เธต
                task.wait(0.05)
                root.CFrame = originalCFrame
            end
        end
    end
end)

----------------------------------------------------------------
-- 6. เธฃเธฐเธเธ HIGH-PRECISION REAL-TIME ESP (เนเธขเธเนเธขเธฐเนเธกเนเธเธขเธณ เน€เธเธฅเธตเนเธขเธเธ•เธฒเธกเธเธ—เธเธฒเธ—เน€เธเธฃเธกเธ•เนเธญเน€เธเธฃเธก)
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
            if hasKnife(p) then
                applyESP(p, Color3.fromRGB(255, 0, 0), "MURDERER")
            elseif hasGun(p) then
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
    
    -- เธ—เธณ ESP เนเธฅเธเนเนเธซเนเธเธทเธเธ•เธเธ—เธตเนเธเธทเนเธ (เธชเธตเน€เธซเธฅเธทเธญเธเธ—เธญเธเน€เธฃเธทเธญเธเนเธชเธ)
    local gunDrop = findDroppedGun()
    if gunDrop and gunDrop:FindFirstChild("Handle") then
        if not gunDrop.Handle:FindFirstChild("GunSelectionESP") then
            local sphere = Instance.new("SelectionSphere")
            sphere.Name = "GunSelectionESP"
            sphere.Color3 = Color3.fromRGB(255, 215, 0)
            sphere.Adornee = gunDrop.Handle
            sphere.Parent = gunDrop.Handle
        end
    end
end)
