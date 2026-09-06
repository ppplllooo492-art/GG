-- ลบ GUI เก่าออกก่อนถ้ามีอยู่ เพื่อป้องกันเมนูซ้อนทับกัน
if game:GetService("CoreGui"):FindFirstChild("NeonXenonHub") then
    game:GetService("CoreGui").NeonXenonHub:Destroy()
end

-- สร้าง ScreenGui หลัก
local XenonHub = Instance.new("ScreenGui")
XenonHub.Name = "NeonXenonHub"
XenonHub.Parent = game:GetService("CoreGui")
XenonHub.ResetOnSpawn = false

-- ==========================================
-- 🪐 ปุ่มรูปภาพวงกลมสำหรับกดเปิดกลับมา (Floating Toggle Image Button)
-- ==========================================
local OpenCircleBtn = Instance.new("ImageButton")
OpenCircleBtn.Name = "OpenCircleBtn"
OpenCircleBtn.Parent = XenonHub
OpenCircleBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
OpenCircleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
OpenCircleBtn.Size = UDim2.new(0, 55, 0, 55)
-- ใช้รูปภาพโลโก้ดาวเคราะห์ไซเบอร์สุดพรีเมียม
OpenCircleBtn.Image = "rbxassetid://10723345474" 
OpenCircleBtn.Visible = false
OpenCircleBtn.Active = true
OpenCircleBtn.Draggable = true -- เปิดฟีเจอร์ให้ผู้เล่นลากย้ายปุ่มกลมนี้ไปมาบนหน้าจอได้อิสระ!

local CircleCorner = Instance.new("UICorner") CircleCorner.CornerRadius = UDim.new(1, 0) CircleCorner.Parent = OpenCircleBtn
local CircleStroke = Instance.new("UIStroke") CircleStroke.Thickness = 2 CircleStroke.Color = Color3.fromRGB(0, 255, 128) CircleStroke.Parent = OpenCircleBtn

-- ==========================================
-- 1. โครงสร้างหน้าต่างหลักนำยุค (Image Background Window)
-- ==========================================
local MainFrame = Instance.new("ImageLabel") 
MainFrame.Name = "MainFrame"
MainFrame.Parent = XenonHub
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 620, 0, 440)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Image = "rbxassetid://10842272780" -- แปะรูปวอลเปเปอร์ไซเบอร์พรีเมียม
MainFrame.ImageTransparency = 0.15 
MainFrame.ScaleType = Enum.ScaleType.Slice

local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 14) MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke") MainStroke.Thickness = 2 MainStroke.Color = Color3.fromRGB(245, 245, 250) MainStroke.Parent = MainFrame

-- แถบหัวข้อด้านบน (Top Bar)
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
TopBar.BackgroundTransparency = 0.3
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 45)
local TopCorner = Instance.new("UICorner") TopCorner.CornerRadius = UDim.new(0, 14) TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 350, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "🪐 NEON XENON HUB : NEO-FUTURE"
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ❌ ปุ่มกากบาทปิดถาวร (Close Button) อยู่มุมขวาสุด
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(0.93, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
CloseBtn.TextSize = 18

-- ➖ ปุ่มลดขนาด/ปุ่มลบเพื่อซ่อน UI (Minimize Image Button) อยู่ใกล้ ๆ กับปุ่ม X
local MinimizeBtn = Instance.new("ImageButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Position = UDim2.new(0.86, 0, 0.15, 0)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
-- แปะรูปภาพไอคอนลบหรือขีดลดขนาดเพื่อให้สวยล้ำยุคเข้ากับตัวหน้าต่าง
MinimizeBtn.Image = "rbxassetid://10734950339" 

-- สคริปต์อนิเมชันสลับหน้าจอ (กดซ่อนแล้วเปิดปุ่มกลมลอยขึ้นมาแทน)
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quad", 0.18, true, function()
        MainFrame.Visible = false
        OpenCircleBtn.Visible = true -- โชว์ปุ่มวงกลมลอยน้ำสำหรับกดเปิดกลับ
    end)
end)

OpenCircleBtn.MouseButton1Click:Connect(function()
    OpenCircleBtn.Visible = false
    MainFrame.Visible = true
    MainFrame:TweenSize(UDim2.new(0, 620, 0, 440), "Out", "Quad", 0.18)
end)

CloseBtn.MouseButton1Click:Connect(function() XenonHub:Destroy() end)

-- ==========================================
-- 2. รูปโปรไฟล์ผู้เล่น & การแสดงผลค่าแลค (Performance Monitor)
-- ==========================================
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Parent = MainFrame
ProfileFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
ProfileFrame.BackgroundTransparency = 0.2
ProfileFrame.Position = UDim2.new(0, 12, 0, 55)
ProfileFrame.Size = UDim2.new(0, 140, 0, 140)
local ProfCorner = Instance.new("UICorner") ProfCorner.CornerRadius = UDim.new(0, 8) ProfCorner.Parent = ProfileFrame

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Parent = ProfileFrame
AvatarImg.BackgroundTransparency = 1
AvatarImg.Position = UDim2.new(0.2, 0, 0.05, 0)
AvatarImg.Size = UDim2.new(0, 84, 0, 84)
local localPlayer = game.Players.LocalPlayer
AvatarImg.Image = "rbxassetid://" .. localPlayer.UserId

local NameLbl = Instance.new("TextLabel")
NameLbl.Parent = ProfileFrame
NameLbl.BackgroundTransparency = 1
NameLbl.Position = UDim2.new(0, 5, 0, 90)
NameLbl.Size = UDim2.new(1, -10, 0, 20)
NameLbl.Font = Enum.Font.SourceSansBold
NameLbl.Text = localPlayer.DisplayName
NameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLbl.TextSize = 13

local PerformanceLbl = Instance.new("TextLabel")
PerformanceLbl.Parent = ProfileFrame
PerformanceLbl.BackgroundTransparency = 1
PerformanceLbl.Position = UDim2.new(0, 5, 0, 112)
PerformanceLbl.Size = UDim2.new(1, -10, 0, 25)
PerformanceLbl.Font = Enum.Font.Code
PerformanceLbl.Text = "FPS: -- | PING: --ms"
PerformanceLbl.TextColor3 = Color3.fromRGB(0, 200, 255)
PerformanceLbl.TextSize = 11

task.spawn(function()
    while task.wait(1) do
        local fps = math.floor(workspace:GetRealPhysicsFPS())
        local ping = math.floor(game:GetService("Stats").Network.ServerTickRate:GetValue())
        PerformanceLbl.Text = "FPS: " .. fps .. " | PING: " .. ping .. "ms"
    end
end)

-- ==========================================
-- 3. แท็บเมนูฝั่งซ้ายล่าง (Navigation Tabs)
-- ==========================================
local LeftBar = Instance.new("Frame")
LeftBar.Parent = MainFrame
LeftBar.BackgroundTransparency = 1
LeftBar.Position = UDim2.new(0, 12, 0, 205)
LeftBar.Size = UDim2.new(0, 140, 0, 220)
local LeftList = Instance.new("UIListLayout") LeftList.Parent = LeftBar; LeftList.Padding = UDim.new(0, 5)

local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 165, 0, 55)
ContentArea.Size = UDim2.new(1, -175, 1, -65)

local Pages = {}
local function CreatePage(pageName)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = pageName; Page.Parent = ContentArea; Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0
    Page.Size = UDim2.new(1, 0, 1, 0); Page.CanvasSize = UDim2.new(0, 0, 0, 700); Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 128); Page.Visible = false
    local PageList = Instance.new("UIListLayout") PageList.Parent = Page; PageList.SortOrder = Enum.SortOrder.LayoutOrder; PageList.Padding = UDim.new(0, 6)
    Pages[pageName] = Page
    return Page
end

local PageFarm = CreatePage("PageFarm")
local PageUpgrade = CreatePage("PageUpgrade")
local PageBox = CreatePage("PageBox")
local PagePlayer = CreatePage("PagePlayer")

local function SwitchPage(pageName)
    for name, page in pairs(Pages) do page.Visible = (name == pageName) end
end

local function CreateTabButton(text, iconAssetId, targetPage, isDefault)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 38)
    TabBtn.BackgroundColor3 = isDefault and Color3.fromRGB(20, 25, 22) or Color3.fromRGB(14, 14, 18)
    TabBtn.BackgroundTransparency = isDefault and 0.2 or 0.5
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.Text = "       " .. text
    TabBtn.TextColor3 = isDefault and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(170, 170, 170)
    TabBtn.TextSize = 13
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.Parent = LeftBar
    local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6) Corner.Parent = TabBtn
    
    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Size = UDim2.new(0, 18, 0, 18); TabIcon.Position = UDim2.new(0, 8, 0.25, 0); TabIcon.BackgroundTransparency = 1; TabIcon.Image = iconAssetId; TabIcon.Parent = TabBtn
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, btn in pairs(LeftBar:GetChildren()) do
            if btn:IsA("TextButton") then btn.BackgroundTransparency = 0.5; btn.TextColor3 = Color3.fromRGB(170, 170, 170) end
        end
        TabBtn.BackgroundTransparency = 0.2; TabBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
        SwitchPage(targetPage)
    end)
end

CreateTabButton("ฟาร์มอัตโนมัติ", "rbxassetid://10734951421", "PageFarm", true)
CreateTabButton("ซื้อไก่ / อัปเกรด", "rbxassetid://10723346914", "PageUpgrade", false)
CreateTabButton("กล่อง Lucky Box", "rbxassetid://10734963321", "PageBox", false)
CreateTabButton("ระบบผู้เล่น / สไลเดอร์", "rbxassetid://10723393114", "PagePlayer", false)
SwitchPage("PageFarm")

-- ==========================================
-- 4. ระบบแผงควบคุมสวิตช์ปุ่มเลื่อนอัตโนมัติ (Animated Slider Toggles)
-- ==========================================
local Flags = {
    PullEggs = false, EggInvis = false, CollectCash = false, DepositEggs = false,
    UpgradeBuyTier = false, UpgradeProcess = false,
    Buy1 = false, Buy5 = false, Buy25 = false, Buy100 = false,
    OpenLucky = false, DiscardLucky = false, AutoCidDress = false
}
local Values = { WalkSpeed = 16, JumpPower = 50, InfJumpPower = 0 }

local function CreateSliderToggle(parentPage, textName, iconId, targetFlag, customCallback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 44); Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 18); Frame.BackgroundTransparency = 0.3; Frame.Parent = parentPage
    local Round = Instance.new("UICorner") Round.CornerRadius = UDim.new(0, 6) Round.Parent = Frame

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 20, 0, 20); Icon.Position = UDim2.new(0, 10, 0.25, 0); Icon.BackgroundTransparency = 1; Icon.Image = iconId; Icon.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1; Label.Position = UDim2.new(0, 38, 0, 0); Label.Size = UDim2.new(0, 230, 1, 0); Label.Font = Enum.Font.SourceSansBold
    Label.Text = textName; Label.TextColor3 = Color3.fromRGB(220, 220, 220); Label.TextSize = 14; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Parent = Frame

    local Track = Instance.new("TextButton")
    Track.Size = UDim2.new(0, 46, 0, 22); Track.Position = UDim2.new(0.85, 0, 0.25, 0); Track.BackgroundColor3 = Color3.fromRGB(40, 40, 45); Track.Text = ""; Track.Parent = Frame
    local TrackRound = Instance.new("UICorner") TrackRound.CornerRadius = UDim.new(1, 0) TrackRound.Parent = Track

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18); Knob.Position = UDim2.new(0.05, 0, 0.1, 0); Knob.BackgroundColor3 = Color3.fromRGB(180, 180, 180); Knob.Parent = Track
    local KnobRound = Instance.new("UICorner") KnobRound.CornerRadius = UDim.new(1, 0) KnobRound.Parent = Knob

    Track.MouseButton1Click:Connect(function()
        Flags[targetFlag] = not Flags[targetFlag]
        if Flags[targetFlag] then
            Track.BackgroundColor3 = Color3.fromRGB(0, 210, 105)
            Knob:TweenPosition(UDim2.new(0.55, 0, 0.1, 0), "Out", "Quad", 0.15)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            if customCallback then customCallback(true) end
        else
            Track.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Knob:TweenPosition(UDim2.new(0.05, 0, 0.1, 0), "Out", "Quad", 0.15)
            Knob.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            if customCallback then customCallback(false) end
        end
    end)
end

CreateSliderToggle(PageFarm, "ดึงไข่ทั้งหมดมาที่ตัว (0.1s)", "rbxassetid://10734951421", "PullEggs")
CreateSliderToggle(PageFarm, "เปิดโหมดซ่อนไข่ให้ล่องหน", "rbxassetid://10723345474", "EggInvis")
CreateSliderToggle(PageFarm, "เก็บเงินออโต้อัตโนมัติ (0.1s)", "rbxassetid://10734959823", "CollectCash")
CreateSliderToggle(PageFarm, "ส่งไข่ออกร้านค้าออโต้ (0.1s)", "rbxassetid://10723346914", "DepositEggs")

CreateSliderToggle(PageUpgrade, "อัปเกรดความเร็วการซื้อออโต้", "rbxassetid://10734961019", "UpgradeBuyTier")
CreateSliderToggle(PageUpgrade, "อัปเกรดความเร็วการขายออโต้", "rbxassetid://10734961532", "UpgradeProcess")
CreateSliderToggle(PageUpgrade, "ซื้อไก่เร่งด่วนทีละ 1 ตัว", "rbxassetid://10723346914", "Buy1")
CreateSliderToggle(PageUpgrade, "ซื้อไก่เร่งด่วนทีละ 5 ตัว", "rbxassetid://10723346914", "Buy5")
CreateSliderToggle(PageUpgrade, "ซื้อไก่เร่งด่วนทีละ 25 ตัว", "rbxassetid://10723346914", "Buy25")
CreateSliderToggle(PageUpgrade, "ซื้อไก่เร่งด่วนทีละ 100 ตัว", "rbxassetid://10723346914", "Buy100")

CreateSliderToggle(PageBox, "เปิดกล่อง Lucky Box ทุกแบบในแมพ", "rbxassetid://10734963321", "OpenLucky")
CreateSliderToggle(PageBox, "ลบทำลายกล่อง Lucky Box ทุกแบบในแมพ", "rbxassetid://10734962650", "DiscardLucky")

-- ==========================================
-- 5. ระบบแต่งตัว ซิด คาเกโน่ อัตโนมัติ (Cid Kagenou Setup)
-- ==========================================
local function equipCidOutfit()
    local char = localPlayer.Character
    if not char then return end
    pcall(function()
        for _, item in pairs(char:GetChildren()) do
            if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("Accessory") or item:IsA("ShirtGraphic") then item:Destroy() end
        end
        local newShirt = Instance.new("Shirt")
        newShirt.Name = "CidShirt"; newShirt.ShirtTemplate = "rbxassetid://15696478858"; newShirt.Parent = char
        local newPants = Instance.new("Pants")
        newPants.Name = "CidPants"; newPants.PantsTemplate = "rbxassetid://14973643849"; newPants.Parent = char

        local InsertService = game:GetService("InsertService")
        local function attachAsset(id)
            local model = InsertService:LoadAsset(id)
            local acc = model:FindFirstChildWhichIsA("Accessory")
            if acc then acc.Parent = char end
            model:Destroy()
        end
        attachAsset(16413210405) -- ทรงผม Cid
        attachAsset(18793262391) -- ผ้าคลุม Shadow
        if char:FindFirstChild("Head") and char.Head:FindFirstChild("face") then char.Head.face.Texture = "rbxassetid://14408035" end
    end)
end

CreateSliderToggle(PagePlayer, "🎭 แปลงร่างเป็น ซิด คาเกโน่ (Cid Outfit)", "rbxassetid://10723345474", "AutoCidDress", function(state)
    if state then equipCidOutfit() end
end)

localPlayer.CharacterAdded:Connect(function()
    if Flags.AutoCidDress then task.wait(0.8) equipCidOutfit() end
end)

-- ==========================================
-- 6. ระบบหลอดเลื่อนปรับระดับ (WalkSpeed / JumpPower / InfJump Sliders)
-- ==========================================
local function CreateVisualSlider(parentPage, titleText, min, max, default, iconId, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -5, 0, 55); SliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); SliderFrame.BackgroundTransparency = 0.4; SliderFrame.Parent = parentPage
    local Round = Instance.new("UICorner") Round.CornerRadius = UDim.new(0, 6) Round.Parent = SliderFrame

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 18, 0, 18); Icon.Position = UDim2.new(0, 10, 0.15, 0); Icon.BackgroundTransparency = 1; Icon.Image = iconId; Icon.Parent = SliderFrame

    local Label = Instance.new("TextLabel")
    Label.Position = UDim2.new(0, 35, 0, 4); Label.Size = UDim2.new(0, 200, 0, 20); Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSansBold; Label.Text = titleText .. " : " .. default; Label.TextColor3 = Color3.fromRGB(0, 255, 128); Label.TextSize = 13; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Parent = SliderFrame

    local SliderTrack = Instance.new("TextButton")
    SliderTrack.Size = UDim2.new(0.9, 0, 0, 8); SliderTrack.Position = UDim2.new(0.05, 0, 0.65, 0); SliderTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 55); SliderTrack.Text = ""; SliderTrack.Parent = SliderFrame
    local TRound = Instance.new("UICorner") TRound.CornerRadius = UDim.new(1, 0) TRound.Parent = SliderTrack

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 128); Fill.BorderSizePixel = 0; Fill.Parent = SliderTrack
    local FRound = Instance.new("UICorner") FRound.CornerRadius = UDim.new(1, 0) FRound.Parent = Fill

    local function UpdateSliderInput(input)
        local percentage = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        local value = math.floor(min + (percentage * (max - min)))
        Label.Text = titleText .. " : " .. value
        callback(value)
    end

    local dragging = false
    SliderTrack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    game:GetService("UserInputService").InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSliderInput(input) end end)
end

CreateVisualSlider(PagePlayer, "⚡ ปรับความเร็วตัวละคร (WalkSpeed)", 16, 300, 16, "rbxassetid://10723345474", function(val)
    Values.WalkSpeed = val
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then localPlayer.Character.Humanoid.WalkSpeed = val end
end)

CreateVisualSlider(PagePlayer, "🦘 ปรับแรงกระโดดสูง (JumpPower)", 50, 300, 50, "rbxassetid://10723393114", function(val)
    Values.JumpPower = val
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        localPlayer.Character.Humanoid.JumpPower = val
        localPlayer.Character.Humanoid.UseJumpPower = true
    end
end)

CreateVisualSlider(PagePlayer, "🚀 สไลเดอร์กระโดดไม่จำกัดชั้น (Infinite Jump Height)", 0, 100, 0, "rbxassetid://10842272780", function(val)
    Values.InfJumpPower = val
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
                if Values.WalkSpeed > 16 then localPlayer.Character.Humanoid.WalkSpeed = Values.WalkSpeed end
            end
        end)
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if Values.InfJumpPower > 0 and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState("Jumping")
            local velocityBoost = Values.InfJumpPower * 0.8
            localPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(localPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity.X, velocityBoost, localPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity.Z)
        end
    end
end)

-- ==========================================
-- 7. ระบบวาร์ปไปหาผู้เล่นคนอื่นในเซิร์ฟเวอร์พร้อมรูปประจำตัว
-- ==========================================
local TeleportFrame = Instance.new("Frame")
TeleportFrame.Size = UDim2.new(1, -5, 0, 175); TeleportFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16); TeleportFrame.BackgroundTransparency = 0.4; TeleportFrame.Parent = PagePlayer
local TC = Instance.new("UICorner") TC.CornerRadius = UDim.new(0, 6) TC.Parent = TeleportFrame

local TeleportTitle = Instance.new("TextLabel")
TeleportTitle.Size = UDim2.new(1, 0, 0, 30); TeleportTitle.BackgroundTransparency = 1; TeleportTitle.Font = Enum.Font.SourceSansBold
TeleportTitle.Text = "🎯 รายชื่อผู้เล่นทั้งหมด (คลิกรูปเพื่อเทเลพอร์ต)"; TeleportTitle.TextColor3 = Color3.fromRGB(0, 255, 128); TeleportTitle.TextSize = 14; TeleportTitle.Parent = TeleportFrame

local PListScroll = Instance.new("ScrollingFrame")
PListScroll.Position = UDim2.new(0, 5, 0, 35); PListScroll.Size = UDim2.new(1, -10, 0, 130); PListScroll.BackgroundTransparency = 1; PListScroll.CanvasSize = UDim2.new(0, 0, 0, 450); PListScroll.ScrollBarThickness = 4; PListScroll.Parent = TeleportFrame
local PListLayout = Instance.new("UIListLayout") PListLayout.Parent = PListScroll; PListLayout.Padding = UDim.new(0, 5)

local function RefreshPlayerTeleportList()
    for _, child in pairs(PListScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for _, targetPlayer in pairs(game.Players:GetPlayers()) do
        if targetPlayer ~= localPlayer then
            local RowFrame = Instance.new("Frame")
            RowFrame.Size = UDim2.new(1, 0, 0, 42); RowFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); RowFrame.BackgroundTransparency = 0.3; RowFrame.Parent = PListScroll
            local RC = Instance.new("UICorner") RC.CornerRadius = UDim.new(0, 6) RC.Parent = RowFrame

            local TargetHeadshot = Instance.new("ImageLabel")
            TargetHeadshot.Size = UDim2.new(0, 34, 0, 34); TargetHeadshot.Position = UDim2.new(0, 5, 0.1, 0); TargetHeadshot.BackgroundTransparency = 1
            TargetHeadshot.Image = "rbxassetid://" .. targetPlayer.UserId
            TargetHeadshot.Parent = RowFrame
            local HC = Instance.new("UICorner") HC.CornerRadius = UDim.new(1, 0) HC.Parent = TargetHeadshot

            local WarpClickBtn = Instance.new("TextButton")
            WarpClickBtn.Position = UDim2.new(0, 45, 0, 0); WarpClickBtn.Size = UDim2.new(1, -50, 1, 0); WarpClickBtn.BackgroundTransparency = 1; WarpClickBtn.Font = Enum.Font.SourceSansBold
            WarpClickBtn.Text = "⚡ บินเทเลพอร์ตไปหา -> " .. targetPlayer.DisplayName; WarpClickBtn.TextColor3 = Color3.fromRGB(245, 245, 250); WarpClickBtn.TextSize = 13; WarpClickBtn.TextXAlignment = Enum.TextXAlignment.Left; WarpClickBtn.Parent = RowFrame

            WarpClickBtn.MouseButton1Click:Connect(function()
                if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                end
            end)
        end
    end
end
RefreshPlayerTeleportList()
game.Players.PlayerAdded:Connect(RefreshPlayerTeleportList)
game.Players.PlayerRemoving:Connect(RefreshPlayerTeleportList)

-- ==========================================
-- 8. ระบบเบื้องหลังลูปฟาร์มอัตโนมัติ (Parallel Loops 0.1s)
-- ==========================================
local remotesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes")
local remoteFunction = remotesFolder:WaitForChild("__remotefunction")
local remoteEvent = remotesFolder:WaitForChild("__remoteevent")

task.spawn(function()
    while true do
        task.wait(0.1)
        if Flags.PullEggs and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = localPlayer.Character.HumanoidRootPart.Position
            if workspace:FindFirstChild("Eggs") then
                for _, egg in pairs(workspace.Eggs:GetChildren()) do
                    if egg:IsA("Model") then egg:PivotTo(CFrame.new(targetPos))
                    elseif egg:IsA("BasePart") then egg.CFrame = CFrame.new(targetPos) end
                    if Flags.EggInvis and egg:IsA("BasePart") then egg.Transparency = 1 end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            if Flags.CollectCash then remoteFunction:InvokeServer("Collect Cash") end
            if Flags.DepositEggs then remoteFunction:InvokeServer("Deposit Eggs") end
            if Flags.UpgradeBuyTier then remoteFunction:InvokeServer("Upgrade Buy Tier Level") end
            if Flags.UpgradeProcess then remoteFunction:InvokeServer("Upgrade Process Level") end
            if Flags.Buy1 then remoteFunction:InvokeServer("Buy Chickens", 1) end
            if Flags.Buy5 then remoteFunction:InvokeServer("Buy Chickens", 5) end
            if Flags.Buy25 then remoteFunction:InvokeServer("Buy Chickens", 25) end
            if Flags.Buy100 then remoteFunction:InvokeServer("Buy Chickens", 100) end
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            if Flags.OpenLucky then
                remoteFunction:InvokeServer("Open Lucky Block")
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and (string.find(obj.Name, "Lucky") or string.find(obj.Name, "Block") or string.find(obj.Name, "Box")) then remoteFunction:InvokeServer("Open Lucky Block", obj.Name) end
                end
            end
            if Flags.DiscardLucky then
                remoteEvent:FireServer("Discard Lucky Block")
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and (string.find(obj.Name, "Lucky") or string.find(obj.Name, "Block") or string.find(obj.Name, "Box")) then remoteEvent:FireServer("Discard Lucky Block", obj.Name) end
                end
            end
        end)
    end
end)
