local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
-- ระบบ UI ผู้ถือการแจ้งเตือน (Notification Holder)
-- ==========================================
local function GetNotificationHolder()
    local screenGui = PlayerGui:FindFirstChild("CyberNotificationGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CyberNotificationGui"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = PlayerGui
    end
    
    local holder = screenGui:FindFirstChild("Holder")
    if not holder then
        holder = Instance.new("Frame")
        holder.Name = "Holder"
        holder.Size = UDim2.new(0, 340, 1, -40)
        holder.Position = UDim2.new(1, -360, 0, 25)
        holder.BackgroundTransparency = 1
        holder.Parent = screenGui
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 10)
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        listLayout.Parent = holder
    end
    return holder
end

-- ==========================================
-- ฟังก์ชันแจ้งเตือนแบบใหม่ (Cyberpunk Style)
-- ==========================================
local function Notify(titleText, messageText, displayTime)
    titleText = titleText or "SYSTEM"
    messageText = messageText or "Notification message."
    displayTime = displayTime or 4
    
    local holder = GetNotificationHolder()
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = false
    container.Parent = holder
    
    -- การ์ดแจ้งเตือนหลัก
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 75)
    card.Position = UDim2.new(1, 50, 0, 0)
    card.BackgroundColor3 = Color3.fromRGB(10, 11, 16)
    card.BackgroundTransparency = 0.1
    card.BorderSizePixel = 0
    card.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card
    
    -- เส้นขอบนีออนเรืองแสง
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 204) -- สีฟ้าอมเขียวนีออน
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.Parent = card
    
    -- แถบสีค่ายด้านซ้าย (Accent Bar)
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 5, 1, 0)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BackgroundColor3 = Color3.fromRGB(0, 255, 204)
    accentBar.BorderSizePixel = 0
    accentBar.Parent = card
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 8)
    barCorner.Parent = accentBar
    
    -- หัวข้อ (Title)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -50, 0, 22)
    title.Position = UDim2.new(0, 18, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = string.upper(titleText)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.RobotoMono
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card
    
    -- ข้อความ (Message)
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -50, 0, 32)
    msg.Position = UDim2.new(0, 18, 0, 32)
    msg.BackgroundTransparency = 1
    msg.Text = messageText
    msg.TextColor3 = Color3.fromRGB(150, 160, 175)
    msg.TextSize = 12
    msg.Font = Enum.Font.Gotham
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.TextYAlignment = Enum.TextYAlignment.Top
    msg.Parent = card
    
    -- ปุ่มปิดแบบมินิมอล (Close Button)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -28, 0, 12)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(100, 110, 125)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamStatement
    closeBtn.Parent = card
    
    -- เส้นบอกเวลาโหลดด้านล่าง (Progress Line)
    local progressTrack = Instance.new("Frame")
    progressTrack.Size = UDim2.new(1, -26, 0, 2)
    progressTrack.Position = UDim2.new(0, 16, 1, -6)
    progressTrack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressTrack.BackgroundTransparency = 0.9
    progressTrack.BorderSizePixel = 0
    progressTrack.Parent = card
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 204)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressTrack
    
    local function Dismiss()
        if container:GetAttribute("Dismissing") then return end
        container:SetAttribute("Dismissing", true)
        
        local t1 = TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1})
        local t2 = TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0)})
        
        t1:Play()
        t2:Play()
        t1.Completed:Connect(function() container:Destroy() end)
    end
    
    closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100) end)
    closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = Color3.fromRGB(100, 110, 125) end)
    closeBtn.MouseButton1Click:Connect(Dismiss)
    
    -- เล่นแอนิเมชันเปิด UI
    TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 75)}):Play()
    TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    local progressTween = TweenService:Create(progressBar, TweenInfo.new(displayTime, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)})
    progressTween:Play()
    
    task.delay(displayTime, function() Dismiss() end)
end

-- ==========================================
-- หน้าต่างโหลดเปิดตัวค่าย (Cyber Loading Screen)
-- ==========================================
local function StartLoadingScreen()
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting
    TweenService:Create(blur, TweenInfo.new(0.4), {Size = 20}):Play()
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CyberLoadingScreen"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui
    
    -- พื้นหลังมืดสนิทไล่โทน
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(6, 7, 10)
    bg.BackgroundTransparency = 0.2
    bg.Parent = screenGui
    
    -- หน้าต่างหลัก (Main Panel)
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 400, 0, 250)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
    panel.BorderSizePixel = 0
    panel.BackgroundTransparency = 1 -- จะค่อยๆ Fade In
    panel.Parent = bg
    
    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 12)
    panelCorner.Parent = panel
    
    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(0, 255, 204)
    panelStroke.Thickness = 1.2
    panelStroke.Transparency = 1
    panelStroke.Parent = panel
    
    -- ชื่อค่ายสคริปต์ (Brand Name)
    local brandText = Instance.new("TextLabel")
    brandText.Size = UDim2.new(1, 0, 0, 40)
    brandText.Position = UDim2.new(0, 0, 0, 45)
    brandText.BackgroundTransparency = 1
    brandText.Text = "MAMBO HUB" -- เปลี่ยนชื่อค่ายของคุณตรงนี้ได้เลย
    brandText.TextColor3 = Color3.fromRGB(0, 255, 204)
    brandText.TextSize = 28
    brandText.Font = Enum.Font.RobotoMono
    brandText.TextTransparency = 1
    brandText.Parent = panel
    
    -- รูปโปรไฟล์ผู้ใช้แบบวงกลมนีออน
    local avatarFrame = Instance.new("ImageLabel")
    avatarFrame.Size = UDim2.new(0, 60, 0, 60)
    avatarFrame.Position = UDim2.new(0.5, -30, 0, 95)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    avatarFrame.BorderSizePixel = 0
    avatarFrame.ImageTransparency = 1
    avatarFrame.Parent = panel
    
    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatarFrame
    
    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Color = Color3.fromRGB(255, 255, 255)
    avatarStroke.Thickness = 1.5
    avatarStroke.Transparency = 1
    avatarStroke.Parent = avatarFrame
    
    task.spawn(function()
        avatarFrame.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
    
    -- ข้อความสถานะการโหลด
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -80, 0, 20)
    statusText.Position = UDim2.new(0, 40, 0, 175)
    statusText.BackgroundTransparency = 1
    statusText.Text = "INITIALIZING SYSTEM..."
    statusText.TextColor3 = Color3.fromRGB(140, 150, 165)
    statusText.TextSize = 11
    statusText.Font = Enum.Font.RobotoMono
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextTransparency = 1
    statusText.Parent = panel
    
    -- เปอร์เซ็นต์ตัวเลข
    local percentText = Instance.new("TextLabel")
    percentText.Size = UDim2.new(0, 60, 0, 20)
    percentText.Position = UDim2.new(1, -100, 0, 175)
    percentText.BackgroundTransparency = 1
    percentText.Text = "0%"
    percentText.TextColor3 = Color3.fromRGB(0, 255, 204)
    percentText.TextSize = 12
    percentText.Font = Enum.Font.RobotoMono
    percentText.TextXAlignment = Enum.TextXAlignment.Right
    percentText.TextTransparency = 1
    percentText.Parent = panel
    
    -- แถบ Loading Bar ด้านล่าง
    local barTrack = Instance.new("Frame")
    barTrack.Size = UDim2.new(1, -80, 0, 4)
    barTrack.Position = UDim2.new(0.5, 0, 0, 200)
    barTrack.AnchorPoint = Vector2.new(0.5, 0)
    barTrack.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
    barTrack.BorderSizePixel = 0
    barTrack.BackgroundTransparency = 1
    barTrack.Parent = panel
    
    local barTrackCorner = Instance.new("UICorner")
    barTrackCorner.CornerRadius = UDim.new(1, 0)
    barTrackCorner.Parent = barTrack
    
    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 204)
    barFill.BorderSizePixel = 0
    barFill.Parent = barTrack
    
    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1, 0)
    barFillCorner.Parent = barFill
    
    -- เอฟเฟกต์ Fade In ทางสายตา
    TweenService:Create(panel, TweenInfo.new(0.4), {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(panelStroke, TweenInfo.new(0.4), {Transparency = 0.5}):Play()
    TweenService:Create(brandText, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(avatarFrame, TweenInfo.new(0.4), {ImageTransparency = 0}):Play()
    TweenService:Create(avatarStroke, TweenInfo.new(0.4), {Transparency = 0.7}):Play()
    TweenService:Create(statusText, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(percentText, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(barTrack, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    
    task.wait(0.4)
    
    -- ลูปจำลองการโหลดสำหรับค่ายสคริปต์
    local stages = {
        {checkpoint = 20, text = "CONNECTING TO SERVER..."},
        {checkpoint = 50, text = "VERIFYING WHITELIST KEY..."},
        {checkpoint = 80, text = "EXECUTING CORE SCRIPT..."},
        {checkpoint = 100, text = "WELCOME TO MAMBO HUB!"}
    }
    
    local currentStage = 1
    for i = 0, 100 do
        percentText.Text = i.."%"
        
        if stages[currentStage] and i >= stages[currentStage].checkpoint then
            statusText.Text = stages[currentStage].text
            currentStage = currentStage + 1
        end
        
        TweenService:Create(barFill, TweenInfo.new(0.02, Enum.EasingStyle.Quad), {Size = UDim2.new(i/100, 0, 1, 0)}):Play()
        task.wait(0.025)
    end
    
    task.wait(0.8)
    
    -- เอฟเฟกต์ Fade Out ตอนโหลดเสร็จ
    TweenService:Create(panel, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(panelStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
    TweenService:Create(brandText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(avatarFrame, TweenInfo.new(0.4), {ImageTransparency = 1}):Play()
    TweenService:Create(avatarStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
    TweenService:Create(statusText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(percentText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(barTrack, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(blur, TweenInfo.new(0.4), {Size = 0}):Play()
    
    task.wait(0.4)
    blur:Destroy()
    screenGui:Destroy()
    
    -- เมื่อโหลดเสร็จ ให้แจ้งเตือนว่าเปิดสคริปต์สำเร็จ
    Notify("MAMBO HUB", "สคริปต์เริ่มทำงานสำเร็จแล้ว ขอให้สนุก!", 4)
end

-- ==========================================
-- เริ่มทำงานสคริปต์
-- ==========================================
task.spawn(StartLoadingScreen)

-- ตัวดึงสคริปต์หลักภายนอก (ของคุณ) ให้รันควบคู่กันไป
task.spawn(function()
    task.wait(0.5)
    pcall(function()
        loadstring(game:HttpGet("https://pastefy.app/tqNF1Nxo/raw"))()
    end)
end)
