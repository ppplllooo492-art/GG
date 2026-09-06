-- ====================================================================
-- ✨ [GGของแท้] - ULTIMATE HYPER-MODERN NOTIFICATION SYSTEM
-- 🚀 BEAUTIFUL FX, LIGHTWEIGHT, FLUID AND ANTI-LAG OPTIMIZED
-- ====================================================================

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function GetNotificationHolder()
    local screenGui = PlayerGui:FindFirstChild("CustomNotificationGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CustomNotificationGui"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = PlayerGui
    end
    
    local holder = screenGui:FindFirstChild("Holder")
    if not holder then
        holder = Instance.new("Frame")
        holder.Name = "Holder"
        holder.Size = UDim2.new(0, 390, 1, -40)
        holder.Position = UDim2.new(1, -410, 0, 25)
        holder.BackgroundTransparency = 1
        holder.Parent = screenGui
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 16)
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        listLayout.Parent = holder
    end
    return holder
end

local function Notify(titleText, messageText, displayTime)
    titleText = titleText or "GGของแท้"
    messageText = messageText or "ระบบทำงานเสร็จสิ้น"
    displayTime = displayTime or 4
    
    local holder = GetNotificationHolder()
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = false
    container.Parent = holder
    
    -- 🌌 Neon Shadow Aura (เอฟเฟกต์แสงเรืองรอบนอกแบบกระจายตัวหนา)
    local ambientGlow = Instance.new("ImageLabel")
    ambientGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    ambientGlow.Position = UDim2.new(0.5, 0, 0.5, 2)
    ambientGlow.Size = UDim2.new(1, 55, 1, 55)
    ambientGlow.BackgroundTransparency = 1
    ambientGlow.Image = "rbxassetid://5554236805"
    ambientGlow.ImageColor3 = Color3.fromRGB(0, 240, 255)
    ambientGlow.ImageTransparency = 0.6
    ambientGlow.ScaleType = Enum.ScaleType.Slice
    ambientGlow.SliceCenter = Rect.new(23, 23, 277, 277)
    ambientGlow.ZIndex = 1
    ambientGlow.Parent = container
    
    local ambientGradient = Instance.new("UIGradient")
    ambientGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 245, 255)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 0, 140)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 200, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 245, 255))
    })
    ambientGradient.Parent = ambientGlow
    
    -- 💎 Main Glassmorphism Card (การ์ด UI กระจกหรูหรา)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 96)
    card.Position = UDim2.new(1, 160, 0, 0)
    card.BackgroundColor3 = Color3.fromRGB(11, 12, 18)
    card.BackgroundTransparency = 0.04
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.ZIndex = 2
    card.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = card
    
    -- 🌈 Hyper Dynamic RGB Stroke (เส้นขอบหนาเอฟเฟกต์โครม่าเคลื่อนไหว)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2.6
    stroke.Transparency = 0.02
    stroke.Parent = card
    
    local strokeGradient = Instance.new("UIGradient")
    strokeGradient.Color = ambientGradient.Color
    strokeGradient.Rotation = 0
    strokeGradient.Parent = stroke
    
    local cardGradient = Instance.new("UIGradient")
    cardGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 22, 40)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(13, 14, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 10, 14))
    })
    cardGradient.Rotation = 145
    cardGradient.Parent = card
    
    -- 🔮 Corner Particle Flare Effect (แสงสะท้อนภายในที่มุมการ์ด)
    local innerGlow = Instance.new("Frame")
    innerGlow.Size = UDim2.new(0, 150, 0, 150)
    innerGlow.Position = UDim2.new(0, -50, 0, -40)
    innerGlow.BackgroundColor3 = Color3.fromRGB(0, 245, 255)
    innerGlow.BackgroundTransparency = 0.94
    innerGlow.BorderSizePixel = 0
    innerGlow.ZIndex = 2
    innerGlow.Parent = card
    
    local innerGlowCorner = Instance.new("UICorner")
    innerGlowCorner.CornerRadius = UDim.new(1, 0)
    innerGlowCorner.Parent = innerGlow
    
    -- 🎖️ Futuristic Icon Badge (กรอบไอคอนโฮโลแกรม)
    local iconBadge = Instance.new("Frame")
    iconBadge.Size = UDim2.new(0, 48, 0, 48)
    iconBadge.Position = UDim2.new(0, 16, 0, 16)
    iconBadge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    iconBadge.BackgroundTransparency = 0.92
    iconBadge.BorderSizePixel = 0
    iconBadge.ZIndex = 3
    iconBadge.Parent = card
    
    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0, 16)
    badgeCorner.Parent = iconBadge
    
    local badgeStroke = Instance.new("UIStroke")
    badgeStroke.Thickness = 1.4
    badgeStroke.Transparency = 0.2
    badgeStroke.Parent = iconBadge
    
    local badgeGradient = Instance.new("UIGradient")
    badgeGradient.Color = strokeGradient.Color
    badgeGradient.Parent = badgeStroke
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 26, 0, 26)
    icon.Position = UDim2.new(0.5, -13, 0.5, -13)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://6031071057"
    icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    icon.ZIndex = 4
    icon.Parent = iconBadge
    
    -- 📝 Text Elements (หัวข้อข้อความและการจัดวางระดับพรีเมียม)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -115, 0, 24)
    title.Position = UDim2.new(0, 78, 0, 16)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 17
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = card
    
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -115, 0, 36)
    msg.Position = UDim2.new(0, 78, 0, 42)
    msg.BackgroundTransparency = 1
    msg.Text = messageText
    msg.TextColor3 = Color3.fromRGB(215, 222, 235)
    msg.TextSize = 13
    msg.Font = Enum.Font.GothamMedium
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.TextYAlignment = Enum.TextYAlignment.Top
    msg.ZIndex = 3
    msg.Parent = card
    
    -- ❌ Close Button (ปุ่มปิดตัดขอบเลเซอร์อนิเมชัน)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -40, 0, 16)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundTransparency = 0.96
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(185, 195, 210)
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 4
    closeBtn.Parent = card
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = Color3.fromRGB(255, 255, 255)
    closeStroke.Thickness = 1
    closeStroke.Transparency = 0.85
    closeStroke.Parent = closeBtn
    
    -- ⏳ Laser Progress Bar (หลอดจับเวลาไล่เฉด RGB สดใส)
    local progressTrack = Instance.new("Frame")
    progressTrack.Size = UDim2.new(1, -32, 0, 4)
    progressTrack.Position = UDim2.new(0, 16, 1, -12)
    progressTrack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressTrack.BackgroundTransparency = 0.95
    progressTrack.BorderSizePixel = 0
    progressTrack.ZIndex = 3
    progressTrack.Parent = card
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = progressTrack
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.Position = UDim2.new(0, 0, 0, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 4
    progressBar.Parent = progressTrack
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = progressBar
    
    local barGradient = Instance.new("UIGradient")
    barGradient.Color = strokeGradient.Color
    barGradient.Parent = progressBar
    
    -- ⚡ Anti-Lag High Performance RGB Rotator (ระบบอัปเดตสีลื่นไหลโดยใช้ลูปน้ำหนักเบา)
    local rotationActive = true
    task.spawn(function()
        local rot = 0
        while rotationActive and task.wait(0.015) do
            rot = (rot + 2.5) % 360
            strokeGradient.Rotation = rot
            ambientGradient.Rotation = rot
            badgeGradient.Rotation = -rot
            barGradient.Rotation = rot
        end
    end)
    
    -- 🎵 Gentle Notification Chime SFX
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://4590662766"
        sound.Volume = 0.55
        sound.Parent = SoundService
        sound:Play()
        task.wait(2)
        sound:Destroy()
    end)
    
    -- ฟังก์ชันอนิเมชั่นปิดตัวที่นุ่มนวลสูงสุด (Ultra Fluid Outro)
    local function Dismiss()
        if container:GetAttribute("Dismissing") then return end
        container:SetAttribute("Dismissing", true)
        rotationActive = false
        
        local slideOut = TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 160, 0, 0)})
        local glowFade = TweenService:Create(ambientGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {ImageTransparency = 1})
        local collapse = TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0)})
        
        slideOut:Play()
        glowFade:Play()
        collapse:Play()
        
        slideOut.Completed:Connect(function()
            container:Destroy()
        end)
    end
    
    -- ปุ่ม Close Interactions
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85, TextColor3 = Color3.fromRGB(255, 75, 95), BackgroundColor3 = Color3.fromRGB(255, 225, 230)}):Play()
        closeStroke.Transparency = 0.4
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.96, TextColor3 = Color3.fromRGB(185, 195, 210), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        closeStroke.Transparency = 0.85
    end)
    closeBtn.MouseButton1Click:Connect(Dismiss)
    
    -- อนิเมชั่นขาเข้าที่ลื่นไหลขั้นสุด (Ultra Smooth Intro)
    TweenService:Create(container, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 96)}):Play()
    TweenService:Create(card, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    local progressTween = TweenService:Create(progressBar, TweenInfo.new(displayTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 1, 0)})
    progressTween:Play()
    
    task.delay(displayTime, function()
        Dismiss()
    end)
end

-- 🎉 แสดงการแจ้งเตือนเริ่มต้นต้อนรับผู้ใช้งาน
Notify("GGของแท้", "ขอบคุณที่ใช้สคริปของ BHK2 Mambo", 5)

-- ====================================================================
-- 🌀 ส่วนแกนโค้ดระบบโหลดความเร็วสูงและลิงก์ภายนอก
-- ====================================================================
local _SRC = [=[
task.wait(0.5)
local P=game:GetService("Players")
local L=game:GetService("Lighting")
local T=game:GetService("TweenService")
local p=P.LocalPlayer 
local g=(gethui and gethui())or p:WaitForChild("PlayerGui")
local b=Instance.new("BlurEffect")
b.Size=0 
b.Parent=L 
T:Create(b,TweenInfo.new(0.5),{Size=28}):Play()
local s=Instance.new("ScreenGui")
s.Name="UltraLoadingScreen"
s.IgnoreGuiInset=true 
s.ResetOnSpawn=false 
s.Parent=g 
local bg=Instance.new("Frame")
bg.Size=UDim2.new(1,0,1,0)
bg.BackgroundColor3=Color3.fromRGB(5,5,8)
bg.BackgroundTransparency=0.35 
bg.Parent=s 
local c=Instance.new("CanvasGroup")
c.Size=UDim2.new(0,440,0,340)
c.Position=UDim2.new(0.5,0,0.5,0)
c.AnchorPoint=Vector2.new(0.5,0.5)
c.BackgroundColor3=Color3.fromRGB(15,15,20)
c.BackgroundTransparency=0.15 
c.GroupTransparency=1 
c.Parent=bg 
local cc=Instance.new("UICorner")
cc.CornerRadius=UDim.new(0,24)
cc.Parent=c 
local cs=Instance.new("UIStroke")
cs.Color=Color3.fromRGB(0,245,255)
cs.Thickness=1.8 
cs.Transparency=0.3 
cs.Parent=c 
local cg=Instance.new("UIGradient")
cg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(24,20,38)),ColorSequenceKeypoint.new(1,Color3.fromRGB(10,10,14))})
cg.Rotation=45 
cg.Parent=c 
local pc=Instance.new("Frame")
pc.Size=UDim2.new(0,100,0,100)
pc.Position=UDim2.new(0.5,0,0,30)
pc.AnchorPoint=Vector2.new(0.5,0)
pc.BackgroundTransparency=1 
pc.Parent=c 
local pi=Instance.new("ImageLabel")
pi.Size=UDim2.new(1,0,1,0)
pi.BackgroundColor3=Color3.fromRGB(25,25,30)
pi.Parent=pc 
local pic=Instance.new("UICorner")
pic.CornerRadius=UDim.new(1,0)
pic.Parent=pi 
local pis=Instance.new("UIStroke")
pis.Color=Color3.fromRGB(0,245,255)
pis.Thickness=3 
pis.Parent=pi 
task.spawn(function()pi.Image=P:GetUserThumbnailAsync(p.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)end)
local dn=Instance.new("TextLabel")
dn.Size=UDim2.new(1,-40,0,24)
dn.Position=UDim2.new(0.5,0,0,145)
dn.AnchorPoint=Vector2.new(0.5,0)
dn.BackgroundTransparency=1 
dn.Text=p.DisplayName 
dn.TextColor3=Color3.fromRGB(255,255,255)
dn.TextSize=20 
dn.Font=Enum.Font.GothamBold 
dn.Parent=c 
local un=Instance.new("TextLabel")
un.Size=UDim2.new(1,-40,0,18)
un.Position=UDim2.new(0.5,0,0,171)
un.AnchorPoint=Vector2.new(0.5,0)
un.BackgroundTransparency=1 
un.Text="@"..p.Name 
un.TextColor3=Color3.fromRGB(160,160,175)
un.TextSize=13 
un.Font=Enum.Font.Gotham 
un.Parent=c 
local st=Instance.new("TextLabel")
st.Size=UDim2.new(1,-100,0,18)
st.Position=UDim2.new(0,30,0,218)
st.BackgroundTransparency=1 
st.Text="กำลังโหลดสคริปต์..."
st.TextColor3=Color3.fromRGB(200,200,215)
st.TextSize=11 
st.Font=Enum.Font.GothamBold 
st.TextXAlignment=Enum.TextXAlignment.Left 
st.Parent=c 
local pr=Instance.new("TextLabel")
pr.Size=UDim2.new(0,50,0,18)
pr.Position=UDim2.new(1,-80,0,218)
pr.BackgroundTransparency=1 
pr.Text="0%"
pr.TextColor3=Color3.fromRGB(0,245,255)
pr.TextSize=13 
pr.Font=Enum.Font.GothamBold 
pr.TextXAlignment=Enum.TextXAlignment.Right 
pr.Parent=c 
local bb=Instance.new("Frame")
bb.Size=UDim2.new(1,-60,0,10)
bb.Position=UDim2.new(0.5,0,0,244)
bb.AnchorPoint=Vector2.new(0.5,0)
bb.BackgroundColor3=Color3.fromRGB(25,25,35)
bb.ClipsDescendants=true 
bb.Parent=c 
local bbc=Instance.new("UICorner")
bbc.CornerRadius=UDim.new(1,0)
bbc.Parent=bb 
local bf=Instance.new("Frame")
bf.Size=UDim2.new(0,0,1,0)
bf.BackgroundColor3=Color3.fromRGB(255,255,255)
bf.Parent=bb 
local bfc=Instance.new("UICorner")
bfc.CornerRadius=UDim.new(1,0)
bfc.Parent=bf 
local bfg=Instance.new("UIGradient")
bfg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(0,245,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,140))})
bfg.Parent=bf 
T:Create(c,TweenInfo.new(0.4,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{GroupTransparency=0}):Play()
for i=0,100 do 
    pr.Text=i.."%"
    if i==25 then st.Text="กำลังตั้งค่าโมดูลอินเทอร์เฟซ..."
    elseif i==50 then st.Text="กำลังซิงค์ระบบสคริปต์ GGของแท้..."
    elseif i==100 then st.Text="ระบบพร้อมใช้งานแล้ว ขอให้สนุกกับการเล่นเกม!"
    end 
    T:Create(bf,TweenInfo.new(0.03,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(i/100,0,1,0)}):Play()
    task.wait(0.02)
end 
task.wait(0.8)
T:Create(c,TweenInfo.new(0.5,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{GroupTransparency=1}):Play()
T:Create(b,TweenInfo.new(0.5),{Size=0}):Play()
task.wait(0.5)
b:Destroy()
s:Destroy()
]=]

loadstring(_SRC)()

task.spawn(function()
    task.wait(0.5)
    loadstring(game:HttpGet("https://pastefy.app/tqNF1Nxo/raw"))()
end)

task.wait(0.5)
Notify("GGของแท้", "สคริปรันติดเเล้ว ระบบทำงานเต็มรูปแบบ!", 4)
