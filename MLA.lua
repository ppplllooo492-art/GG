-- ลบ GUI เก่าออกก่อนถ้ามีอยู่
if game:GetService("CoreGui"):FindFirstChild("NeonXenonHub") then
    game:GetService("CoreGui").NeonXenonHub:Destroy()
end

-- สร้าง ScreenGui หลัก
local XenonHub = Instance.new("ScreenGui")
XenonHub.Name = "NeonXenonHub"
XenonHub.Parent = game:GetService("CoreGui")
XenonHub.ResetOnSpawn = false

-- ตัวแปรควบคุมการเปิด/ปิด UI (Toggle Visibility)
local isOpen = true

-- ==========================================
-- ปุ่มลอยสำหรับกดเปิด (Floating Open Image Button) - โชว์เมื่อซ่อนหน้าต่าง
-- ==========================================
local OpenCircleBtn = Instance.new("ImageButton")
OpenCircleBtn.Name = "OpenCircleBtn"
OpenCircleBtn.Parent = XenonHub
OpenCircleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OpenCircleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
OpenCircleBtn.Size = UDim2.new(0, 50, 0, 50)
OpenCircleBtn.Image = "rbxassetid://10723345474" -- รูปภาพไอคอนโลโก้ไซเบอร์สุดเท่
OpenCircleBtn.Visible = false
OpenCircleBtn.Active = true
OpenCircleBtn.Draggable = true -- ลากย้ายปุ่มเปิดได้อิสระบนหน้าจอมือถือ

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = OpenCircleBtn

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Thickness = 2
CircleStroke.Color = Color3.fromRGB(0, 255, 128)
CircleStroke.Parent = OpenCircleBtn

-- ==========================================
-- 1. โครงสร้างหน้าต่างหลัก (Main Window)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = XenonHub
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10) -- ดำสนิทดาร์กโหมด
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 600, 0, 430) -- ขยายขนาดเพื่อความอลังการ
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- เส้นขอบหน้าต่างสีขาวนวลแบบโมเดิร์น
local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(240, 240, 245)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- แถบหัวข้อด้านบน (Top Bar)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 45)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "🪐 NEON XENON HUB v1.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 128) -- เรืองแสงเขียวนีออน
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่มซ่อนหน้าต่างสุดพรีเมียม (Minimize Image Button)
local MinimizeBtn = Instance.new("ImageButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Position = UDim2.new(0.86, 0, 0.15, 0)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
-- ใช้ไอคอนรูปดวงตาซ่อน/ลดขนาดหน้าต่างเพื่อให้สวยงาม
MinimizeBtn.Image = "rbxassetid://10734950339" 

-- ปุ่มปิดถาวร (Close Button)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TopBar
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(0.93, 0, 0, 0)
CloseBtn.Size = UDim2.new(0, 35, 1, 0)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 18

-- จัดการการสลับหน้าจอ ซ่อน/แสดง ด้วยเอฟเฟกต์สมูท
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quad", 0.2, true, function()
        MainFrame.Visible = false
        OpenCircleBtn.Visible = true
    end)
end)

OpenCircleBtn.MouseButton1Click:Connect(function()
    OpenCircleBtn.Visible = false
    MainFrame.Visible = true
    MainFrame:TweenSize(UDim2.new(0, 600, 0, 430), "Out", "Quad", 0.2)
end)

CloseBtn.MouseButton1Click:Connect(function() XenonHub:Destroy() end)

-- ==========================================
-- 2. รูปโปรไฟล์ผู้เล่น & การแสดงผลค่าแลค (Performance)
-- ==========================================
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Parent = MainFrame
ProfileFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
ProfileFrame.Position = UDim2.new(0, 12, 0, 55)
ProfileFrame.Size = UDim2.new(0, 140, 0, 140)
local ProfCorner = Instance.new("UICorner") ProfCorner.CornerRadius = UDim.new(0, 8) ProfCorner.Parent = ProfileFrame

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Parent = ProfileFrame
AvatarImg.BackgroundTransparency = 1
AvatarImg.Position = UDim2.new(0.2, 0, 0.05, 0)
AvatarImg.Size = UDim2.new(0, 84, 0, 84)
local localPlayer = game.Players.LocalPlayer
-- แก้ไข Error: เติม /?userId= ให้ถูกต้องตาม Endpoint ของ Roblox
AvatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..localPlayer.UserId.."&width=150&height=150&format=png"

local NameLbl = Instance.new("TextLabel")
NameLbl.Parent = ProfileFrame
NameLbl.BackgroundTransparency = 1
NameLbl.Position = UDim2.new(0, 5, 0, 90)
NameLbl.Size = UDim2.new(1, -10, 0, 20)
NameLbl.Font = Enum.Font.SourceSansBold
NameLbl.Text = localPlayer.DisplayName
NameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLbl.TextSize = 13
NameLbl.TextTruncate = Enum.TextTruncate.AtEnd

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
        PerformanceLbl.TextColor3 = (ping > 150) and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(0, 200, 255)
    end
end)

-- ==========================================
-- 3. แท็บเมนูฝั่งซ้ายล่าง (Navigation Tabs พร้อมใส่ไอคอนรูปภาพ)
-- ==========================================
local LeftBar = Instance.new("Frame")
LeftBar.Parent = MainFrame
LeftBar.BackgroundTransparency = 1
LeftBar.Position = UDim2.new(0, 12, 0, 205)
LeftBar.Size = UDim2.new(0, 140, 0, 215)

local LeftList = Instance.new("UIListLayout")
LeftList.Parent = LeftBar
LeftList.SortOrder = Enum.SortOrder.LayoutOrder
LeftList.Padding = UDim.new(0, 5)

local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 165, 0, 55)
ContentArea.Size = UDim2.new(1, -175, 1, -65)

local Pages = {}
local function CreatePage(pageName)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = pageName
    Page.Parent = ContentArea
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 650)
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 128)
    Page.Visible = false
    
    local PageList = Instance.new("UIListLayout")
    PageList.Parent = Page
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Padding = UDim.new(0, 6)
    
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

-- สร้างปุ่มเมนูแท็บที่มีไอคอนรูปภาพประกอบเพื่อความเข้าใจง่าย
local function CreateTabButton(text, iconAssetId, targetPage, isDefault)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 38)
    TabBtn.BackgroundColor3 = isDefault and Color3.fromRGB(20, 25, 22) or Color3.fromRGB(14, 14, 18)
    TabBtn.Font = Enum.Font.SourceSansBold
    TabBtn.Text = "       " .. text -- เว้นที่ให้รูปภาพไอคอน
    TabBtn.TextColor3 = isDefault and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(170, 170, 170)
    TabBtn.TextSize = 13
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.Parent = LeftBar
    local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0, 6) Corner.Parent = TabBtn
    
    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Size = UDim2.new(0, 18, 0, 18)
    TabIcon.Position = UDim2.new(0, 8, 0.25, 0)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Image = iconAssetId
    TabIcon.Parent = TabBtn
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, btn in pairs(LeftBar:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
                btn.TextColor3 = Color3.fromRGB(170, 170, 170)
            end
        end
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 22)
        TabBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
        SwitchPage(targetPage)
    end)
end

-- ใส่แท็บเมนูพร้อมรูปภาพไอคอนระดับพรีเมียม
CreateTabButton("ฟาร์มอัตโนมัติ", "rbxassetid://10734951421", "PageFarm", true)
CreateTabButton("ซื้อไก่ / อัปเกรด", "rbxassetid://10723346914", "PageUpgrade", false)
CreateTabButton("กล่อง Lucky Box", "rbxassetid://10734963321", "PageBox", false)
CreateTabButton("ระบบผู้เล่น / วาร์ป", "rbxassetid://10723393114", "PagePlayer", false)
SwitchPage("PageFarm")

-- ==========================================
-- 4. ระบบสร้างปุ่มเลื่อนสวิตช์อัตโนมัติ (Animated Slider Toggle พร้อมไอคอน)
-- ==========================================
local Flags = {
PullEggs = false, EggInvis = false, CollectCash = false, DepositEggs = false,
UpgradeBuyTier = false, UpgradeProcess = false,
Buy1 = false, Buy5 = false, Buy25 = false, Buy100 = false,
OpenLucky = false, DiscardLucky = false, InfJump = false
}

local function CreateSliderToggle(parentPage, textName, iconId, targetFlag)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(1, -5, 0, 44)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Frame.BorderSizePixel = 0
Frame.Parent = parentPage
local Round = Instance.new("UICorner") Round.CornerRadius = UDim.new(0, 6) Round.Parent = Frame

local Icon = Instance.new("ImageLabel")
Icon.Size = UDim2.new(0, 20, 0, 20)
Icon.Position = UDim2.new(0, 10, 0.25, 0)
Icon.BackgroundTransparency = 1
Icon.Image = iconId
Icon.Parent = Frame

local Label = Instance.new("TextLabel")
Label.BackgroundTransparency = 1
Label.Position = UDim2.new(0, 38, 0, 0)
Label.Size = UDim2.new(0, 230, 1, 0)
Label.Font = Enum.Font.SourceSansBold
Label.Text = textName
Label.TextColor3 = Color3.fromRGB(220, 220, 220)
Label.TextSize = 14
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = Frame

local Track = Instance.new("TextButton")
Track.Size = UDim2.new(0, 46, 0, 22)
Track.Position = UDim2.new(0.85, 0, 0.25, 0)
Track.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Track.Text = ""
Track.Parent = Frame
local TrackRound = Instance.new("UICorner") TrackRound.CornerRadius = UDim.new(1, 0) TrackRound.Parent = Track

local Knob = Instance.new("Frame")
Knob.Size = UDim2.new(0, 18, 0, 18)
Knob.Position = UDim2.new(0.05, 0, 0.1, 0)
Knob.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
Knob.Parent = Track
local KnobRound = Instance.new("UICorner") KnobRound.CornerRadius = UDim.new(1, 0) KnobRound.Parent = Knob

Track.MouseButton1Click:Connect(function()
Flags[targetFlag] = not Flags[targetFlag]
if Flags[targetFlag] then
Track.BackgroundColor3 = Color3.fromRGB(0, 210, 105)
Knob:TweenPosition(UDim2.new(0.55, 0, 0.1, 0), "Out", "Quad", 0.15)
Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
else
Track.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Knob:TweenPosition(UDim2.new(0.05, 0, 0.1, 0), "Out", "Quad", 0.15)
Knob.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
end
end)
end

-- เพิ่มฟังก์ชันปุ่มเลื่อนพร้อมรูปภาพไอคอนเข้าใจง่าย
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
-- 5. แท็บระบบผู้เล่น: วิ่งไว / กระโดดไม่จำกัด / ระบบดึงรูปวาร์ปหาเพื่อน
-- ==========================================
CreateSliderToggle(PagePlayer, "เปิดระบบกระโดดไม่จำกัดชั้น (Infinite Jump)", "rbxassetid://10723393114", "InfJump")

-- ปุ่มเพิ่มสปีดการเดิน
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(1, -5, 0, 38)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(24, 28, 36)
SpeedBtn.Font = Enum.Font.SourceSansBold
SpeedBtn.Text = "⚡ เปิดโหมดติดสปีด (WalkSpeed = 120)"
SpeedBtn.TextColor3 = Color3.fromRGB(255, 210, 0)
SpeedBtn.TextSize = 14
SpeedBtn.Parent = PagePlayer
local SC = Instance.new("UICorner") SC.CornerRadius = UDim.new(0, 6) SC.Parent = SpeedBtn
SpeedBtn.MouseButton1Click:Connect(function()
if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then localPlayer.Character.Humanoid.WalkSpeed = 120 end
end)

-- ระบบเลือกรายชื่อผู้เล่นเพื่อวาร์ปไปหาพร้อมโชว์รูปอวตารของคนนั้น ๆ (Player Avatar Teleportation)
local TeleportFrame = Instance.new("Frame")
TeleportFrame.Size = UDim2.new(1, -5, 0, 180)
TeleportFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
TeleportFrame.Parent = PagePlayer
local TC = Instance.new("UICorner") TC.CornerRadius = UDim.new(0, 6) TC.Parent = TeleportFrame

local TeleportTitle = Instance.new("TextLabel")
TeleportTitle.Size = UDim2.new(1, 0, 0, 30)
TeleportTitle.BackgroundTransparency = 1
TeleportTitle.Font = Enum.Font.SourceSansBold
TeleportTitle.Text = "🎯 รายชื่อผู้เล่นในเซิร์ฟเวอร์ (คลิกเพื่อวาร์ปไปหา)"
TeleportTitle.TextColor3 = Color3.fromRGB(0, 255, 128)
TeleportTitle.TextSize = 14
TeleportTitle.Parent = TeleportFrame

local PListScroll = Instance.new("ScrollingFrame")
PListScroll.Position = UDim2.new(0, 5, 0, 35)
PListScroll.Size = UDim2.new(1, -10, 0, 135)
PListScroll.BackgroundTransparency = 1
PListScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
PListScroll.ScrollBarThickness = 4
PListScroll.Parent = TeleportFrame

local PListLayout = Instance.new("UIListLayout")
PListLayout.Parent = PListScroll
PListLayout.Padding = UDim.new(0, 5)

-- ฟังก์ชันดึงรูปเพื่อนและปุ่มวาร์ปหาแบบเรียลไทม์
local function RefreshPlayerTeleportList()
for _, child in pairs(PListScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end

for _, targetPlayer in pairs(game.Players:GetPlayers()) do
if targetPlayer ~= localPlayer then
local RowFrame = Instance.new("Frame")
RowFrame.Size = UDim2.new(1, 0, 0, 40)
RowFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
RowFrame.Parent = PListScroll
local RC = Instance.new("UICorner") RC.CornerRadius = UDim.new(0, 6) RC.Parent = RowFrame

-- รูปหัวของเป้าหมายที่จะวาร์ปไปหา
local TargetHeadshot = Instance.new("ImageLabel")
TargetHeadshot.Size = UDim2.new(0, 32, 0, 32)
TargetHeadshot.Position = UDim2.new(0, 6, 0.1, 0)
TargetHeadshot.BackgroundTransparency = 1
-- แก้ไข Error: เติม /?userId= ให้ถูกต้องตาม Endpoint ของ Roblox
TargetHeadshot.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..targetPlayer.UserId.."&width=150&height=150&format=png"
TargetHeadshot.Parent = RowFrame
local HC = Instance.new("UICorner") HC.CornerRadius = UDim.new(1, 0) HC.Parent = TargetHeadshot

-- ปุ่มกดเทเลพอร์ตขอบขาวเรืองแสง
local WarpClickBtn = Instance.new("TextButton")
WarpClickBtn.Position = UDim2.new(0, 45, 0, 0)
WarpClickBtn.Size = UDim2.new(1, -50, 1, 0)
WarpClickBtn.BackgroundTransparency = 1
WarpClickBtn.Font = Enum.Font.SourceSansBold
WarpClickBtn.Text = "วาร์ปไปหา -> " .. targetPlayer.DisplayName
WarpClickBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
WarpClickBtn.TextSize = 13
WarpClickBtn.TextXAlignment = Enum.TextXAlignment.Left
WarpClickBtn.Parent = RowFrame

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

-- ระบบ Infinite Jump ล็อกคำสั่งตรวจจับการกดปุ่มโดดรัว ๆ กลางอากาศ
game:GetService("UserInputService").JumpRequest:Connect(function()
if Flags.InfJump and localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
localPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
end
end)

-- ==========================================
-- 6. ระบบคำสั่งฟาร์ม Loops เบื้องหลัง (ขนานสปีด 0.1 วินาที)
-- ==========================================
local function makeInvisible(obj)
if obj:IsA("BasePart") then obj.Transparency = 1 end
for _, child in pairs(obj:GetChildren()) do makeInvisible(child) end
end

local remotesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes")
local remoteFunction = remotesFolder:WaitForChild("__remotefunction")
local remoteEvent = remotesFolder:WaitForChild("__remoteevent")

-- ลูป 1: ดึงไข่มาที่ตัว
task.spawn(function()
while true do
task.wait(0.1)
if Flags.PullEggs and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
local targetPos = localPlayer.Character.HumanoidRootPart.Position
if workspace:FindFirstChild("Eggs") then
for _, egg in pairs(workspace.Eggs:GetChildren()) do
if egg:IsA("Model") then egg:PivotTo(CFrame.new(targetPos))
elseif egg:IsA("BasePart") then egg.CFrame = CFrame.new(targetPos) end
if Flags.EggInvis then makeInvisible(egg) end
end
end
end
end
end)

-- ลูป 2: ฟาร์มออโต้ / อัปเกรดกระเป๋า/ซื้อไก่
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

-- ลูป 3: เปิดและลบกล่อง Lucky Box รอบแมพ
task.spawn(function()
while true do
task.wait(0.1)
pcall(function()
if Flags.OpenLucky then
remoteFunction:InvokeServer("Open Lucky Block")
for _, obj in pairs(workspace:GetChildren()) do
if obj:IsA("Model") and (string.find(obj.Name, "Lucky") or string.find(obj.Name, "Block") or string.find(obj.Name, "Box")) then
remoteFunction:InvokeServer("Open Lucky Block", obj.Name)
end
end
end
if Flags.DiscardLucky then
remoteEvent:FireServer("Discard Lucky Block")
for _, obj in pairs(workspace:GetChildren()) do
if obj:IsA("Model") and (string.find(obj.Name, "Lucky") or string.find(obj.Name, "Block") or string.find(obj.Name, "Box")) then
remoteEvent:FireServer("Discard Lucky Block", obj.Name)
end
end
end
end)
end
end)
