-- ====================================================================  
-- 🛡️ PART 1: UNIVERSAL ANTI-BAN & ANTI-KICK BASE SYSTEM (หัวสคริปต์กันแบน)  
-- ====================================================================  
  
local Players = game:GetService("Players")  
local TeleportService = game:GetService("TeleportService")  
local HttpService = game:GetService("HttpService")  
local LogService = game:GetService("LogService")  
local ScriptContext = game:GetService("ScriptContext")  
local GuiService = game:GetService("GuiService")  
local CoreGui = game:GetService("CoreGui")  
  
local LocalPlayer = Players.LocalPlayer  
  
-- ปิดระบบส่งข้อมูล ERROR & LOGS (Anti-Report Bypass)  
ScriptContext.Error:Connect(function()   
    return nil   
end)  
  
-- ระบบ HOOK METATABLE (ดักจับการเตะฝั่ง Client + หลอกค่าความเร็วและแรงกระโดด)  
local mt = getrawmetatable(game)  
local oldNamecall = mt.__namecall  
local oldIndex = mt.__index  
setreadonly(mt, false)  
  
mt.__namecall = newcclosure(function(self, ...)  
    local method = getnamecallmethod()  
    local args = {...}  
      
    -- ดักจับและบล็อกคำสั่ง Kick / Destroy ตัวผู้เล่น จากฝั่ง Client ดื้อๆ  
    if tostring(method) == "Kick" or tostring(method) == "kick" or (tostring(method) == "Destroy" and self:IsA("Player")) then  
        warn("[Anti-Ban]: สกัดกั้นคำสั่งเตะออกจากเซิร์ฟเวอร์เรียบร้อย!")  
        return nil  
    end  
      
    -- ตรวจจับและตัดสัญญาณ RemoteEvent แปลกๆ ที่ชอบส่งข้อมูลแบนส่งเดชกลับเซิร์ฟเวอร์  
    if tostring(method) == "FireServer" and self:IsA("RemoteEvent") then  
        local remoteName = tostring(self.Name):lower()  
        if remoteName:find("cheat") or remoteName:find("ban") or remoteName:find("kick") or remoteName:find("detection") or remoteName:find("report") or remoteName:find("anticheat") then  
            warn("[Anti-Ban]: บล็อกการส่งข้อมูลแจ้งเตือนการโกง: " .. tostring(self.Name))  
            return nil  
        end  
    end  
      
    return oldNamecall(self, ...)  
end)  
  
-- ระบบ Memory Spoofing หลอกค่าสถานะตัวละครกันแอนตี้เช็คสแกนเจอ  
mt.__index = newcclosure(function(t, k)  
    if LocalPlayer and LocalPlayer.Character then  
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")  
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")  
          
        if hum and t == hum then  
            if k == "WalkSpeed" then return 16 end  
            if k == "JumpPower" then return 50 end  
            if k == "HipHeight" then return 0 end  
        end  
          
        if hrp and t == hrp and k == "Velocity" then  
            return Vector3.new(0, 0, 0)  
        end  
    end  
    return oldIndex(t, k)  
end)  
  
setreadonly(mt, true)  
  
-- ระบบซ่อนหน้าต่างแจ้งเตือนโดนเตะ (Error Prompt Bypass)  
task.spawn(function()  
    pcall(function()  
        local RobloxGui = CoreGui:WaitForChild("RobloxGui")  
        RobloxGui.DescendantAdded:Connect(function(descendant)  
            if descendant.Name == "ErrorPrompt" or (descendant:IsA("TextLabel") and descendant.Text:find("kicked")) then  
                descendant.Parent.Visible = false  
                warn("[Anti-Kick]: ตรวจพบหน้าต่างแจ้งเตือนการเตะ ทำการซ่อนทันที!")  
            end  
        end)  
    end)  
end)  
  
-- ระบบจำลองการเคลียร์ความเร็วหลุดโลก (Anti-Velocity Fling Kick)  
task.spawn(function()  
    while task.wait(0.5) do  
        pcall(function()  
            if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then  
                if LocalPlayer.Character.HumanoidRootPart.Velocity.Magnitude > 500 then  
                    LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)  
                end  
            end  
        end)  
    end  
end)  
  
-- ระบบไม้ตายดึงกลับเข้าเกมหรือย้ายห้องหนีอัตโนมัติ (Auto Rejoin / Server Hop)  
local function forceRejoinOrHop()  
    warn("[Anti-Disconnect]: กำลังพาย้ายเซิร์ฟเวอร์เพื่อความปลอดภัย...")  
    task.wait(1)  
    local success, err = pcall(function()  
        if #Players:GetPlayers() <= 1 then  
            TeleportService:Teleport(game.PlaceId, LocalPlayer)  
        else  
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)  
        end  
    end)  
    if not success then  
        TeleportService:Teleport(game.PlaceId, LocalPlayer)  
    end  
end  
  
GuiService.ErrorMessageChanged:Connect(function(errorMessage)  
    if errorMessage ~= "" then  
        forceRejoinOrHop()  
    end  
end)  
  
  
-- ====================================================================  
-- ⚔️ PART 2: MAIN SCRIPT CONFIGURATION & UI (สคริปต์โจมตีและระบบควบคุมหลัก)  
-- ====================================================================  
  
-- [[ ตั้งค่าระบบการทำงานหลัก - เวอร์ชันลดความเสี่ยง ]]  
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
  
-- สร้างหน้าต่างเมนูควบคุม (GUI)  
local ScreenGui = Instance.new("ScreenGui")  
local MainFrame = Instance.new("Frame")  
local ToggleButton = Instance.new("TextButton")  
local EspButton = Instance.new("TextButton")  
local UICorner1 = Instance.new("UICorner")  
local UICorner2 = Instance.new("UICorner")  
local UICorner3 = Instance.new("UICorner")  
  
-- ลบ UI เก่าออกเพื่อป้องกันการซ้อนทับ  
local oldGui = LocalPlayer.PlayerGui:FindFirstChild("SafeAuraGui")  
if oldGui then oldGui:Destroy() end  
  
ScreenGui.Name = "SafeAuraGui"  
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")  
ScreenGui.ResetOnSpawn = false  
  
MainFrame.Name = "MainFrame"  
MainFrame.Parent = ScreenGui  
MainFrame.Size = UDim2.new(0, 150, 0, 110)  
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)  
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  
MainFrame.Active = true  
MainFrame.Draggable = true  
UICorner1.Parent = MainFrame  
  
-- ปุ่มเปิด/ปิดโจมตีออโต้  
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
  
-- ปุ่มเปิด/ปิด ESP  
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
  
-- ฟังก์ชันอัปเดตสถานะปุ่ม  
local function updateVisuals()  
    if _G.AuraActive then  
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 167, 69)}):Play()  
        ToggleButton.Text = "Aura: ON"  
    else  
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 53, 69)}):Play()  
        ToggleButton.Text = "Aura: OFF"  
    end  
      
    if _G.EspActive then  
        TweenService:Create(EspButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 167, 69)}):Play()  
        EspButton.Text = "ESP: ON"  
    else  
        TweenService:Create(EspButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 53, 69)}):Play()  
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
-- 🚀 PART 3: DETECTIONS & ACTIONS LOOP (ระบบหลบแอดมิน + ทำลายล้างออโต้)  
-- ====================================================================  
  
-- [[ 1. ระบบตรวจจับแอดมินและการหลบหนีอัตโนมัติ (Anti-Admin Ban) ]]  
local function checkAdmin(player)  
    if player:GetRankInGroup(0) >= 200 or player.AccountAge < 1 then   
        return true  
    end  
    local nameLower = player.Name:lower()  
    if nameLower:find("admin") or nameLower:find("mod") or nameLower:find("staff") then  
        return true  
    end  
    return false  
end  
  
local function handleAdminDetection()  
    for _, player in pairs(Players:GetPlayers()) do  
        if player ~= LocalPlayer and checkAdmin(player) then  
            -- เมื่อเจอแอดมินในห้อง ระบบจะทำการวาร์ปหลบหนีออกจากเซิร์ฟเวอร์ทันทีแทนการค้างหน้าจอ  
            task.spawn(forceRejoinOrHop)  
        end  
    end  
end  
  
Players.PlayerAdded:Connect(function(player)  
    if checkAdmin(player) then  
        task.spawn(forceRejoinOrHop)  
    end  
end)  
  
-- [[ 2. ระบบสร้างกรอบ (ESP System) ]]  
local function createESP(player)  
    local highlight = Instance.new("Highlight")  
    highlight.Name = "EspHighlight"  
    highlight.FillColor = Color3.fromRGB(255, 0, 0)  
    highlight.FillTransparency = 0.5  
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)  
    highlight.OutlineTransparency = 0  
      
    local function applyESP()  
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
            if _G.EspActive and player ~= LocalPlayer then  
                highlight.Parent = player.Character  
            else  
                highlight.Parent = nil  
            end  
        end  
    end  
      
    player.CharacterAdded:Connect(function()  
        task.wait(0.5)  
        applyESP()  
    end)  
      
    RunService.RenderStepped:Connect(applyESP)  
end  
  
for _, p in pairs(Players:GetPlayers()) do  
    createESP(p)  
end  
Players.PlayerAdded:Connect(createESP)  
  
-- [[ 3. ลูปการทำงานหลักในการโจมตีอัตโนมัติ (Kill Aura) ]]  
task.spawn(function()  
    while true do  
        -- เวลาหน่วงสุ่มปลอดภัย (0.25 - 0.35 วินาที) ลดความเสี่ยง Packet   
local secureDelay = math.random(25, 35) / 100task.wait(secureDelay)handleAdminDetection()if _G.AuraActive thenlocal myChar = LocalPlayer.Characterlocal myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")if myRoot thenfor _, player in pairs(Players:GetPlayers()) doif player ~= LocalPlayer thenlocal targetChar = player.Characterlocal targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")local targetHumanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")if targetRoot and targetHumanoid and targetHumanoid.Health > 0 thenif targetHumanoid.MaxHealth > 5000 or targetHumanoid.Health > 5000 thencontinueendlocal distance = (myRoot.Position - targetRoot.Position).Magnitude-- ทำงานเมื่อศัตรูอยู่ในระยะ 30 Studsif distance <= ATTACK_RANGE and _G.AuraActive thentask.spawn(function()pcall(function()local targetPos = Vector3.new(targetRoot.Position.X, myRoot.Position.Y, targetRoot.Position.Z)myRoot.CFrame = CFrame.lookAt(myRoot.Position, targetPos)end)end)local args = {targetChar,SKILL_NUMBER}task.spawn(function()AttackRemote:InvokeServer(unpack(args))end)endendendendendendendend)print("[SYSTEM]: มัดรวมระบบกันแบนเสร็จสมบูรณ์! เมนูโจมตีเปิดใช้งานแล้วครับน้องชาย 🛡️⚡")
