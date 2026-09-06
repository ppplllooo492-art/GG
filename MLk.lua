-- ลบ GUI เก่าออกก่อนถ้ามีอยู่ เพื่อป้องกันเมนูซ้ำ
if game:GetService("CoreGui"):FindFirstChild("NeonXenonHub") then
    game:GetService("CoreGui").NeonXenonHub:Destroy()
end

-- สร้าง ScreenGui หลัก
local XenonHub = Instance.new("ScreenGui")
XenonHub.Name = "NeonXenonHub"
XenonHub.Parent = game:GetService("CoreGui")
XenonHub.ResetOnSpawn = false

-- ตัวแปรสถานะขนาดหน้าต่าง
local isExpanded = false

-- ==========================================
-- 🪐 ปุ่มรูปภาพวงกลมสำหรับกดเปิดกลับ (Floating Toggle Button)
-- ==========================================
local OpenCircleBtn = Instance.new("ImageButton")
OpenCircleBtn.Name = "OpenCircleBtn"
OpenCircleBtn.Parent = XenonHub
OpenCircleBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
OpenCircleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
OpenCircleBtn.Size = UDim2.new(0, 55, 0, 55)
OpenCircleBtn.Image = "rbxassetid://6031097225" -- โลโก้เรืองแสงนีออนแท้
OpenCircleBtn.Visible = false
OpenCircleBtn.Active = true
OpenCircleBtn.Draggable = true
OpenCircleBtn.ZIndex = 10

local CircleCorner = Instance.new("UICorner") CircleCorner.CornerRadius = UDim.new(1, 0) CircleCorner.Parent = OpenCircleBtn
local CircleStroke = Instance.new("UIStroke") CircleStroke.Thickness = 2 CircleStroke.Color = Color3.fromRGB(0, 255, 128) CircleStroke.Parent = OpenCircleBtn

-- ==========================================
-- 1. โครงสร้างหน้าต่างหลัก (Image Background Window)
-- ==========================================
local MainFrame = Instance.new("ImageLabel") 
MainFrame.Name = "MainFrame"
MainFrame.Parent = XenonHub
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 620, 0, 440) -- ขนาดเริ่มต้น
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Image = "rbxassetid://6034289502" -- ภาพพื้นหลังไซเบอร์นีออนแท้
MainFrame.ImageTransparency = 0.1
MainFrame.ZIndex = 1

local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 14) MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke") MainStroke.Thickness = 2 MainStroke.Color = Color3.fromRGB(255, 255, 255) MainStroke.Parent = MainFrame

-- แถบหัวข้อด้านบน (Top Bar)
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
TopBar.BackgroundTransparency = 0.4
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.ZIndex = 2
local TopCorner = Instance.new("UICorner") TopCorner.CornerRadius = UDim.new(0, 14) TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 320, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "🪐 NEON XENON HUB V9"
Title.TextColor3 = Color3.fromRGB(0, 255, 128) -- เรืองแสงเขียวไซเบอร์
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3

-- ❌ ปุ่มกากบาทปิดถาวร
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(0.93, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
CloseBtn.TextSize = 18
CloseBtn.ZIndex = 4

-- ⤢ ปุ่มขยายหน้าต่าง UI (Resize Button)
local ResizeBtn = Instance.new("TextButton")
ResizeBtn.Parent = TopBar
ResizeBtn.BackgroundTransparency = 1
ResizeBtn.Position = UDim2.new(0.87, 0, 0, 0)
ResizeBtn.Size = UDim2.new(0, 35, 1, 0)
ResizeBtn.Font = Enum.Font.SourceSansBold
ResizeBtn.Text = "[ ⤢ ]"
ResizeBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
ResizeBtn.TextSize = 14
ResizeBtn.ZIndex = 4

-- ➖ ปุ่มขีดลบเพื่อย่อซ่อน UI (Minimize Button)
local MinimizeBtn = Instance.new("ImageButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Position = UDim2.new(0.81, 0, 0.15, 0)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Image = "rbxassetid://6031075929" -- รูปภาพขีดลดขนาด
MinimizeBtn.ZIndex = 4

-- ระบบอนิเมชันปุ่ม ย่อ/ซ่อน หน้าต่างหลัก
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenCircleBtn.Visible = true
end)

OpenCircleBtn.MouseButton1Click:Connect(function()
    OpenCircleBtn.Visible = false
    MainFrame.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function() XenonHub:Destroy() end)

-- ระบบสลับขนาดหน้าต่าง ขยาย / ย่อกลับเท่าเดิม
ResizeBtn.MouseButton1Click:Connect(function()
    isExpanded = not isExpanded
    if isExpanded then
        MainFrame:TweenSize(UDim2.new(0, 750, 0, 520), "Out", "Quad", 0.2, true)
    else
        MainFrame:TweenSize(UDim2.new(0, 620, 0, 440), "Out", "Quad", 0.2, true)
    end
end)

-- ==========================================
-- 2. รูปโปรไฟล์ผู้เล่น & การแสดงผลค่าแลค (Performance Monitor)
-- ==========================================
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Parent = MainFrame
ProfileFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
ProfileFrame.BackgroundTransparency = 0.3
ProfileFrame.Position = UDim2.new(0, 12, 0, 55)
ProfileFrame.Size = UDim2.new(0, 140, 0, 140)
ProfileFrame.ZIndex = 2
local ProfCorner = Instance.new("UICorner") ProfCorner.CornerRadius = UDim.new(0, 8) ProfCorner.Parent = ProfileFrame

-- แสดงรูปหัวตัวละครผู้เล่นจริง
local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Parent = ProfileFrame
AvatarImg.BackgroundTransparency = 1
AvatarImg.Position = UDim2.new(0.2, 0, 0.05, 0)
AvatarImg.Size = UDim2.new(0, 84, 0, 84)
local localPlayer = game.Players.LocalPlayer
AvatarImg.ZIndex = 3
local AvCorner = Instance.new("UICorner") AvCorner.CornerRadius = UDim.new(1, 0) AvCorner.Parent = AvatarImg

-- ป้องกันข้อผิดพลาดกรณีดึงรูปภาพล้มเหลว
pcall(function()
    AvatarImg.Image = game:GetService("Players"):GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)

local NameLbl = Instance.new("TextLabel")
NameLbl.Parent = ProfileFrame
NameLbl.BackgroundTransparency = 1
NameLbl.Position = UDim2.new(0, 5, 0, 92)
NameLbl.Size = UDim2.new(1, -10, 0, 20)
NameLbl.Font = Enum.Font.SourceSansBold
NameLbl.Text = localPlayer.DisplayName
NameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLbl.TextSize = 13
NameLbl.ZIndex = 3

local PerformanceLbl = Instance.new("TextLabel")
PerformanceLbl.Parent = ProfileFrame
PerformanceLbl.BackgroundTransparency = 1
PerformanceLbl.Position = UDim2.new(0, 5, 0, 115)
PerformanceLbl.Size = UDim2.new(1, -10, 0, 20)
PerformanceLbl.Font = Enum.Font.Code
PerformanceLbl.Text = "FPS: CALC | PING: --"
PerformanceLbl.TextColor3 = Color3.fromRGB(0, 200, 255)
PerformanceLbl.TextSize = 11
PerformanceLbl.ZIndex = 3

task.spawn(function()
    local runService = game:GetService("RunService")
    while true do
        local start = os.clock()
        runService.RenderStepped:Wait()
        local fps = math.floor(1 / (os.clock() - start))
        local ping = math.floor(game:GetService("Stats").Network.ServerTickRate:GetValue())
        if fps > 1000 then fps = 60 end
        PerformanceLbl.Text = "FPS: " .. fps .. " | PING: " .. ping .. "ms"
        task.wait(0.5)
    end
end)

-- ==========================================
-- 3. แท็บเมนูฝั่งซ้ายล่าง (Navigation Tabs)
-- ==========================================
local LeftBar = Instance.new("Frame")
LeftBar.Parent = MainFrame
LeftBar.BackgroundTransparency = 1
LeftBar.Position = UDim2.new(0, 12, 0, 205)
LeftBar.Size = UDim2.new(0, 140, 1, -215)
local LeftList = Instance.new("UIListLayout") LeftList.Parent = LeftBar; LeftList.Padding = UDim.new(0, 5)
LeftBar.ZIndex = 2

local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 165, 0, 55)
ContentArea.Size = UDim2.new(1, -175, 1, -65)
ContentArea.ZIndex = 2

local Pages = {}
local function CreatePage(pageName)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = pageName; Page.Parent = ContentArea; Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0
    Page.Size = UDim2.new(1, 0, 1, 0); Page.CanvasSize = UDim2.new(0, 0, 0, 750); Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 128); Page.Visible = false
    Page.ZIndex = 3
    local PageList = Instance.new("UIListLayout") PageList.Parent = Page; PageList.SortOrder = Enum.SortOrder.LayoutOrder; PageList.Padding = UDim.new(0, 6)
    Pages[pageName] = Page
    return Page
end

local PageFarm = CreatePage("PageFarm")
local PageUpgrade = CreatePage("PageUpgrade")
local PageBox = CreatePage("PageBox")
local PagePlayer = CreatePage("PagePlayer") -- หน้าระบบผู้เล่นฝั่งขวา (แก้ไขเลื่อนสไลเดอร์ได้แน่นอน)

local function SwitchPage(pageName)
    for name, page in pairs(Pages) do page.Visible = (name == pageName) end
end

local function CreateTabButton(text, iconAssetId, targetPage, isDefault)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 38)
    TabBtn.BackgroundColor3 = isDefault and Color3.fromRGB(30, 45, 35) or Color3.fromRGB(20, 20, 25)
    TabBtn.BackgroundTransparency = 0.3
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.Text = "       " .. text
    TabBtn.TextColor3 = isDefault and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(170, 170, 170)
    TabBtn.TextSize = 13
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.Parent = LeftBar
    TabBtn.ZIndex = 4
    local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6) Corner.Parent = TabBtn
    
    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Size = UDim2.new(0, 18, 0, 18); TabIcon.Position = UDim2.new(0, 8, 0.25, 0); TabIcon.BackgroundTransparency = 1; TabIcon.Image = iconAssetId; TabIcon.Parent = TabBtn; TabIcon.ZIndex = 5
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, btn in pairs(LeftBar:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                btn.TextColor3 = Color3.fromRGB(170, 170, 170)
            end
        end
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 45, 35)
        TabBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
        SwitchPage(targetPage)
    end)
end

CreateTabButton("ฟาร์มอัตโนมัติ", "rbxassetid://10734951421", "PageFarm", true)
CreateTabButton("ซื้อไก่ / อัปเกรด", "rbxassetid://10723346914", "PageUpgrade", false)
CreateTabButton("กล่อง Lucky Box", "rbxassetid://10734963321", "PageBox", false)
CreateTabButton("ระบบผู้เล่น / สไลเดอร์", "rbxassetid://10723393114", "PagePlayer", false)
SwitchPage("PageFarm")

-- ==========================================
-- 4. ระบบสวิตช์ปุ่มเลื่อนอัตโนมัติ (Animated Slider Toggles)
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
    Frame.Size = UDim2.new(1, -5, 0, 44); Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28); Frame.BackgroundTransparency = 0.4; Frame.Parent = parentPage; Frame.ZIndex = 4
    local Round = Instance.new("UICorner") Round.CornerRadius = UDim.new(0, 6) Round.Parent = Frame

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 20, 0, 20); Icon.Position = UDim2.new(0, 10, 0.25, 0); Icon.BackgroundTransparency = 1; Icon.Image = iconId; Icon.Parent = Frame; Icon.ZIndex = 5

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1; Label.Position = UDim2.new(0, 38, 0, 0); Label.Size = UDim2.new(0, 230, 1, 0); Label.Font = Enum.Font.SourceSansBold
    Label.Text = textName; Label.TextColor3 = Color3.fromRGB(0, 255, 128); Label.TextSize = 14; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Parent = Frame; Label.ZIndex = 5

    local Track = Instance.new("TextButton")
    Track.Size = UDim2.new(0, 46, 0, 22); Track.Position = UDim2.new(0.85, 0, 0.25, 0); Track.BackgroundColor3 = Color3.fromRGB(55, 55, 60); Track.Text = ""; Track.Parent = Frame; Track.ZIndex = 5
    local TrackRound = Instance.new("UICorner") TrackRound.CornerRadius = UDim.new(1, 0) TrackRound.Parent = Track

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18); Knob.Position = UDim2.new(0.05, 0, 0.1, 0); Knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200); Knob.Parent = Track; Knob.ZIndex = 6
    local KnobRound = Instance.new("UICorner") KnobRound.CornerRadius = UDim.new(1, 0) KnobRound.Parent = Knob

    Track.MouseButton1Click:Connect(function()
        Flags[targetFlag] = not Flags[targetFlag]
        if Flags[targetFlag] then
            Track.BackgroundColor3 = Color3.fromRGB(0, 210, 105)
            Knob:TweenPosition(UDim2.new(0.55, 0, 0.1, 0), "Out", "Quad", 0.15)
            if customCallback then customCallback(true) end
        else
            Track.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
            Knob:TweenPosition(UDim2.new(0.05, 0, 0.1, 0), "Out", "Quad", 0.15)
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
            -- ครอบ pcall เพื่อไม่ให้สคริปต์หยุดทำงานหากดึง Asset ถอดรหัสล้มเหลว หรือไม่มีสิทธิ์เข้าถึง (Third-party asset)
            pcall(function()
                local model = InsertService:LoadAsset(id)
                local acc = model:FindFirstChildWhichIsA("Accessory")
                if acc then acc.Parent = char end
                model:Destroy()
            end)
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
-- 6. ระบบหลอดเลื่อนปรับระดับ (Fix ZIndex การคลิกเลื่อนหลอดฝั่งขวา)
-- ==========================================
local function CreateVisualSlider(parentPage, titleText, min, max, default, iconId, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -5, 0, 55); SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30); SliderFrame.BackgroundTransparency = 0.4; SliderFrame.Parent = parentPage; SliderFrame.ZIndex = 4
    local Round = Instance.new("UICorner") Round.CornerRadius = UDim.new(0, 6) Round.Parent = SliderFrame

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 18, 0, 18); Icon.Position = UDim2.new(0, 10, 0.15, 0); Icon.BackgroundTransparency = 1; Icon.Image = iconId; Icon.Parent = SliderFrame; Icon.ZIndex = 5

    local Label = Instance.new("TextLabel")
    Label.Position = UDim2.new(0, 35, 0, 4); Label.Size = UDim2.new(0, 200, 0, 20); Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.SourceSansBold; Label.Text = titleText .. " : " .. default; Label.TextColor3 = Color3.fromRGB(0, 255, 128); Label.TextSize = 13; Label.TextXAlignment = Enum.TextXAlignment.Left; Label.Parent = SliderFrame; Label.ZIndex = 5

    local SliderTrack = Instance.new("TextButton")
    SliderTrack.Size = UDim2.new(0.9, 0, 0, 8); SliderTrack.Position = UDim2.new(0.05, 0, 0.65, 0); SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 75); SliderTrack.Text = ""; SliderTrack.Parent = SliderFrame; SliderTrack.ZIndex = 5
    local TRound = Instance.new("UICorner") TRound.CornerRadius = UDim.new(1, 0) TRound.Parent = SliderTrack

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 128); Fill.BorderSizePixel = 0; Fill.Parent = SliderTrack; Fill.ZIndex = 6
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
            localPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(localPlayer.Character.HumanoidRootPart.Velocity.X, velocityBoost, localPlayer.Character.HumanoidRootPart.Velocity.Z)
        end
    end
end)

-- ==========================================
-- 7. ระบบวาร์ปไปหาผู้เล่นคนอื่นในเซิร์ฟเวอร์พร้อมรูปประจำตัว
-- ==========================================
local TeleportFrame = Instance.new("Frame")
TeleportFrame.Size = UDim2.new(1, -5, 0, 175); TeleportFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22); TeleportFrame.BackgroundTransparency = 0.4; TeleportFrame.Parent = PagePlayer; TeleportFrame.ZIndex = 4
local TC = Instance.new("UICorner") TC.CornerRadius = UDim.new(0, 6) TC.Parent = TeleportFrame

local TeleportTitle = Instance.new("TextLabel")
TeleportTitle.Size = UDim2.new(1, 0, 0, 30); TeleportTitle.BackgroundTransparency = 1; TeleportTitle.Font = Enum.Font.SourceSansBold
TeleportTitle.Text = "🎯 รายชื่อผู้เล่นทั้งหมด (คลิกรูปเพื่อเทเลพอร์ต)"; TeleportTitle.TextColor3 = Color3.fromRGB(0, 255, 128); TeleportTitle.TextSize = 14; TeleportTitle.Parent = TeleportFrame; TeleportTitle.ZIndex = 5

local PListScroll = Instance.new("ScrollingFrame")
PListScroll.Position = UDim2.new(0, 5, 0, 35); PListScroll.Size = UDim2.new(1, -10, 0, 130); PListScroll.BackgroundTransparency = 1; PListScroll.CanvasSize = UDim2.new(0, 0, 0, 500); PListScroll.ScrollBarThickness = 4; PListScroll.Parent = TeleportFrame; PListScroll.ZIndex = 5
local PListLayout = Instance.new("UIListLayout") PListLayout.Parent = PListScroll; PListLayout.Padding = UDim.new(0, 5)

local function RefreshPlayerTeleportList()
    for _, child in pairs(PListScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for _, targetPlayer in pairs(game.Players:GetPlayers()) do
        if targetPlayer ~= localPlayer then
            local RowFrame = Instance.new("Frame")
            RowFrame.Size = UDim2.new(1, 0, 0, 42); RowFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35); RowFrame.BackgroundTransparency = 0.3; RowFrame.Parent = PListScroll; RowFrame.ZIndex = 5
            local RC = Instance.new("UICorner") RC.CornerRadius = UDim.new(0, 6) RC.Parent = RowFrame

            local TargetHeadshot = Instance.new("ImageLabel")
            TargetHeadshot.Size = UDim2.new(0, 34, 0, 34); TargetHeadshot.Position = UDim2.new(0, 5, 0.1, 0); TargetHeadshot.BackgroundTransparency = 1
            TargetHeadshot.Parent = RowFrame; TargetHeadshot.ZIndex = 6
            local HC = Instance.new("UICorner") HC.CornerRadius = UDim.new(1, 0) HC.Parent = TargetHeadshot
            
            pcall(function()
                TargetHeadshot.Image = game:GetService("Players"):GetUserThumbnailAsync(targetPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            end)

            local WarpClickBtn = Instance.new("TextButton")
            WarpClickBtn.Position = UDim2.new(0, 45, 0, 0); WarpClickBtn.Size = UDim2.new(1, -50, 1, 0); WarpClickBtn.BackgroundTransparency = 1; WarpClickBtn.Font = Enum.Font.SourceSansBold
            WarpClickBtn.Text = "⚡ บินเทเลพอร์ตไปหา -> " .. targetPlayer.DisplayName; WarpClickBtn.TextColor3 = Color3.fromRGB(245, 245, 250); WarpClickBtn.TextSize = 13; WarpClickBtn.TextXAlignment = Enum.TextXAlignment.Left; WarpClickBtn.Parent = RowFrame; WarpClickBtn.ZIndex = 6

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
-- 8. ระบบเบื้องหลังลูปฟาร์มอัตโนมัติ (Parallel Loops 0.1s - แก้บั๊กล่องหนแบบถาวร)
-- ==========================================
local remotesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes")
local remoteFunction = remotesFolder:WaitForChild("__remotefunction")
local remoteEvent = remotesFolder:WaitForChild("__remoteevent")

-- ฟังก์ชันดิ่งลึกเข้าไปสแกนทุกชิ้นส่วนในโมเดลไข่ให้ล่องหน
local function fullyInvisible(object)
    if object:IsA("BasePart") then
        object.Transparency = 1
    elseif object:IsA("Decal") or object:IsA("Texture") then
        object.Transparency = 1
    end
    for _, child in pairs(object:GetChildren()) do
        fullyInvisible(child)
    end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if Flags.PullEggs and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = localPlayer.Character.HumanoidRootPart.Position
            if workspace:FindFirstChild("Eggs") then
                for _, egg in pairs(workspace.Eggs:GetChildren()) do
                    -- ดึงไข่มากลางตัวผู้เล่น
                    if egg:IsA("Model") then egg:PivotTo(CFrame.new(targetPos))
                    elseif egg:IsA("BasePart") then egg.CFrame = CFrame.new(targetPos) end

                    -- ตรวจสอบโหมดไข่ล่องหน (ทำงานแบบ Recursion ไม่เหลือแม้แต่เงา)
                    if Flags.EggInvis then
                        fullyInvisible(egg)
                    end
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
