-- คัดลอกโค้ดทั้งหมดนี้ไปวางใน Delta ได้เลย

-- ==========================================
-- ลบ UI เก่าออกก่อนหากมีการรันซ้ำ
-- ==========================================
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("DeltaCustomGUI") then
    CoreGui.DeltaCustomGUI:Destroy()
end

-- ==========================================
-- สร้างโครงสร้างหลักของ GUI
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCustomGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 320)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(35, 60, 45)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- ==========================================
-- Title Bar
-- ==========================================
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 0, 30)
TitleLabel.Position = UDim2.new(0, 15, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "✨ Steal Egg Auto Premium [Delta Custom]"
TitleLabel.TextColor3 = Color3.fromRGB(200, 255, 210)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

-- ==========================================
-- ปุ่มปิด GUI
-- ==========================================
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(200, 80, 80)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ==========================================
-- Left Navigation Bar
-- ==========================================
local LeftMenu = Instance.new("Frame")
LeftMenu.Size = UDim2.new(0, 140, 1, -45)
LeftMenu.Position = UDim2.new(0, 10, 0, 35)
LeftMenu.BackgroundColor3 = Color3.fromRGB(10, 18, 14)
LeftMenu.BorderSizePixel = 0
LeftMenu.Parent = MainFrame

local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 6)
LeftCorner.Parent = LeftMenu

-- ==========================================
-- Tab 1
-- ==========================================
local TabBtn1 = Instance.new("TextButton")
TabBtn1.Size = UDim2.new(1, -10, 0, 35)
TabBtn1.Position = UDim2.new(0, 5, 0, 10)
TabBtn1.BackgroundColor3 = Color3.fromRGB(25, 45, 35)
TabBtn1.Text = " 🥚 Auto Collect"
TabBtn1.TextColor3 = Color3.fromRGB(255, 255, 255)
TabBtn1.TextSize = 14
TabBtn1.Font = Enum.Font.SourceSansBold
TabBtn1.TextXAlignment = Enum.TextXAlignment.Left
TabBtn1.Parent = LeftMenu

local TabCorner1 = Instance.new("UICorner")
TabCorner1.CornerRadius = UDim.new(0, 4)
TabCorner1.Parent = TabBtn1

-- ==========================================
-- Tab 2
-- ==========================================
local TabBtn2 = Instance.new("TextButton")
TabBtn2.Size = UDim2.new(1, -10, 0, 35)
TabBtn2.Position = UDim2.new(0, 5, 0, 50)
TabBtn2.BackgroundColor3 = Color3.fromRGB(15, 28, 22)
TabBtn2.Text = " ⚙️ Auto Farm"
TabBtn2.TextColor3 = Color3.fromRGB(160, 180, 165)
TabBtn2.TextSize = 14
TabBtn2.Font = Enum.Font.SourceSansBold
TabBtn2.TextXAlignment = Enum.TextXAlignment.Left
TabBtn2.Parent = LeftMenu

local TabCorner2 = Instance.new("UICorner")
TabCorner2.CornerRadius = UDim.new(0, 4)
TabCorner2.Parent = TabBtn2

-- ==========================================
-- Page Collect
-- ==========================================
local PageCollect = Instance.new("ScrollingFrame")
PageCollect.Size = UDim2.new(1, -170, 1, -45)
PageCollect.Position = UDim2.new(0, 160, 0, 35)
PageCollect.BackgroundTransparency = 1
PageCollect.BorderSizePixel = 0
PageCollect.ScrollBarThickness = 4
PageCollect.CanvasSize = UDim2.new(0, 0, 0, 350)
PageCollect.Visible = true
PageCollect.Parent = MainFrame

-- ==========================================
-- Page Farm
-- ==========================================
local PageFarm = Instance.new("ScrollingFrame")
PageFarm.Size = UDim2.new(1, -170, 1, -45)
PageFarm.Position = UDim2.new(0, 160, 0, 35)
PageFarm.BackgroundTransparency = 1
PageFarm.BorderSizePixel = 0
PageFarm.ScrollBarThickness = 4
PageFarm.CanvasSize = UDim2.new(0, 0, 0, 350)
PageFarm.Visible = false
PageFarm.Parent = MainFrame

-- ==========================================
-- สลับหน้า
-- ==========================================
TabBtn1.MouseButton1Click:Connect(function()
    PageCollect.Visible = true
    PageFarm.Visible = false

    TabBtn1.BackgroundColor3 = Color3.fromRGB(25, 45, 35)
    TabBtn1.TextColor3 = Color3.fromRGB(255, 255, 255)

    TabBtn2.BackgroundColor3 = Color3.fromRGB(15, 28, 22)
    TabBtn2.TextColor3 = Color3.fromRGB(160, 180, 165)
end)

TabBtn2.MouseButton1Click:Connect(function()
    PageCollect.Visible = false
    PageFarm.Visible = true

    TabBtn2.BackgroundColor3 = Color3.fromRGB(25, 45, 35)
    TabBtn2.TextColor3 = Color3.fromRGB(255, 255, 255)

    TabBtn1.BackgroundColor3 = Color3.fromRGB(15, 28, 22)
    TabBtn1.TextColor3 = Color3.fromRGB(160, 180, 165)
end)

-- ==========================================
-- ฟังก์ชันสร้าง Toggle
-- ==========================================
local function CreateToggle(parent, text, yPos, callback)

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.Position = UDim2.new(0, 5, 0, yPos)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 32, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 4)
    FrameCorner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 230, 220)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local SwitchBtn = Instance.new("TextButton")
    SwitchBtn.Size = UDim2.new(0, 45, 0, 22)
    SwitchBtn.Position = UDim2.new(1, -55, 0.5, -11)
    SwitchBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 40)
    SwitchBtn.Text = "OFF"
    SwitchBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    SwitchBtn.TextSize = 11
    SwitchBtn.Font = Enum.Font.SourceSansBold
    SwitchBtn.Parent = Frame

    local SwCorner = Instance.new("UICorner")
    SwCorner.CornerRadius = UDim.new(0, 11)
    SwCorner.Parent = SwitchBtn

    local toggled = false

    SwitchBtn.MouseButton1Click:Connect(function()

        toggled = not toggled

        if toggled then
            SwitchBtn.BackgroundColor3 = Color3.fromRGB(35, 180, 95)
            SwitchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            SwitchBtn.Text = "ON"
        else
            SwitchBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 40)
            SwitchBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            SwitchBtn.Text = "OFF"
        end

        callback(toggled)
    end)
end

-- ==========================================
-- Remote Function
-- ==========================================
local remoteFunction = game:GetService("ReplicatedStorage")
    :WaitForChild("Paper")
    :WaitForChild("Remotes")
    :WaitForChild("__remotefunction")

-- ==========================================
-- PAGE COLLECT
-- ==========================================

-- 1. Auto Collect Normal Eggs
CreateToggle(
    PageCollect,
    "Auto Collect Normal Eggs (ดึงไข่ขุ่น)",
    10,
    function(state)

        getgenv().AutoCollectEggs = state

        if state then
            task.spawn(function()

                while getgenv().AutoCollectEggs do

                    pcall(function()

                        local character = game.Players.LocalPlayer.Character
                        local hrp = character and character:FindFirstChild("HumanoidRootPart")

                        if not hrp then
                            return
                        end

                        local eggsFolder = workspace:FindFirstChild("Eggs")

                        if eggsFolder then

                            for _, egg in pairs(eggsFolder:GetChildren()) do

                                if (egg:IsA("BasePart") or egg:IsA("MeshPart"))
                                    and not string.find(egg.Name, "Purple") then

                                    egg.CanCollide = false
                                    egg.Transparency = 0.5
                                    egg.Anchored = true
                                    egg.CFrame = hrp.CFrame

                                end
                            end
                        end

                    end)

                    task.wait(0.1)
                end
            end)
        end
    end
)

-- ==========================================
-- 2. Auto Purple Diamonds x100
-- ==========================================
CreateToggle(
    PageCollect,
    "Auto Purple Diamonds [100X] (ดึงเพชรคูณ100)",
    60,
    function(state)

        getgenv().AutoPurpleDiamondsX100 = state

        if state then

            task.spawn(function()

                while getgenv().AutoPurpleDiamondsX100 do

                    pcall(function()

                        local character = game.Players.LocalPlayer.Character
                        local hrp = character and character:FindFirstChild("HumanoidRootPart")

                        if not hrp then
                            return
                        end

                        local eggsFolder = workspace:FindFirstChild("Eggs")

                        if eggsFolder then

                            for _, object in pairs(eggsFolder:GetChildren()) do

                                if (object:IsA("BasePart") or object:IsA("MeshPart"))
                                    and string.find(object.Name, "Purple") then

                                    for i = 1, 100 do

                                        local duplicateDiamond = object:Clone()

                                        duplicateDiamond.Parent = workspace
                                        duplicateDiamond.CanCollide = false
                                        duplicateDiamond.Transparency = 0.6
                                        duplicateDiamond.Anchored = true
                                        duplicateDiamond.CFrame = hrp.CFrame

                                        task.spawn(function()

                                            pcall(function()
                                                firetouchinterest(hrp, duplicateDiamond, 0)
                                                task.wait()
                                                firetouchinterest(hrp, duplicateDiamond, 1)
                                            end)

                                            if duplicateDiamond then
                                                duplicateDiamond:Destroy()
                                            end

                                        end)
                                    end

                                    object.CanCollide = false
                                    object.Transparency = 0.6
                                    object.CFrame = hrp.CFrame

                                end
                            end
                        end

                    end)

                    task.wait(0.1)
                end
            end)
        end
    end
)

-- ==========================================
-- PAGE FARM
-- ==========================================

-- 1. Auto Deposit Eggs
CreateToggle(
    PageFarm,
    "Auto Deposit Eggs (ส่งไข่ออโต้)",
    10,
    function(state)

        getgenv().AutoDepositEggs = state

        if state then

            task.spawn(function()

                while getgenv().AutoDepositEggs do

                    pcall(function()
                        remoteFunction:InvokeServer("Deposit Eggs")
                    end)

                    task.wait(0.5)
                end
            end)
        end
    end
)

-- ==========================================
-- 2. Auto Collect Cash
-- ==========================================
CreateToggle(
    PageFarm,
    "Auto Collect Cash (เก็บเงินออโต้)",
    60,
    function(state)

        getgenv().AutoCollectCash = state

        if state then

            task.spawn(function()

                while getgenv().AutoCollectCash do

                    pcall(function()
                        remoteFunction:InvokeServer("Collect Cash")
                    end)

                    task.wait(0.5)
                end
            end)
        end
    end
)

-- ==========================================
-- 3. Auto Buy Chickens x100
-- ==========================================
CreateToggle(
    PageFarm,
    "Auto Buy Chickens [x100] (ซื้อไก่ออโต้)",
    110,
    function(state)

        getgenv().AutoBuyChickens = state

        if state then

            task.spawn(function()

                while getgenv().AutoBuyChickens do

                    pcall(function()
                        remoteFunction:InvokeServer("Buy Chickens", 100)
                    end)

                    task.wait(0.5)
                end
            end)
        end
    end
)

-- ==========================================
-- 4. Auto Open Lucky Block
-- ==========================================
CreateToggle(
    PageFarm,
    "Auto Open Lucky Block (เปิดกล่องออโต้)",
    160,
    function(state)

        getgenv().AutoOpenLuckyBlock = state

        if state then

            task.spawn(function()

                while getgenv().AutoOpenLuckyBlock do

                    pcall(function()
                        remoteFunction:InvokeServer("Open Lucky Block")
                    end)

                    task.wait(0.3)
                end
            end)
        end
    end
)

print("DeltaCustomGUI Loaded Successfully")
