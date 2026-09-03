-- คัดลอกโค้ดทั้งหมดนี้ไปวางใน Delta ได้เลย

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ลบ UI เก่าหากมีการรันซ้ำ
local oldGui = CoreGui:FindFirstChild("SpeedAutoGUI")
if oldGui then
    oldGui:Destroy()
end

-- ==========================================
-- [ ตัวแปรกลาง ]
-- ==========================================

getgenv().EggCollectCooldown = getgenv().EggCollectCooldown or 0.2
getgenv().GlobalCooldown = getgenv().GlobalCooldown or 0.5

getgenv().AutoCollectEggs = false
getgenv().AutoPurpleDiamondsX100 = false
getgenv().AutoDepositEggs = false
getgenv().AutoCollectCash = false
getgenv().AutoBuyChickens = false
getgenv().AutoOpenLuckyBlock = false

local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- [ รูปโปรไฟล์ ]
-- ==========================================

local userId = LocalPlayer.UserId
local thumbType = Enum.ThumbnailType.AvatarThumbnail
local thumbSize = Enum.ThumbnailSize.Size150x150

local avatarImg = ""

pcall(function()
    local image, ready = Players:GetUserThumbnailAsync(
        userId,
        thumbType,
        thumbSize
    )

    if ready then
        avatarImg = image
    end
end)

-- ==========================================
-- [ สร้าง GUI ]
-- ==========================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedAutoGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 320)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(180, 150, 220)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- ==========================================
-- [ Title ]
-- ==========================================

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 0, 30)
TitleLabel.Position = UDim2.new(0, 15, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🚀 speed auto [Premium Setup]"
TitleLabel.TextColor3 = Color3.fromRGB(220, 200, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

-- ==========================================
-- [ Close Button ]
-- ==========================================

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 120, 120)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ==========================================
-- [ Toggle Menu Button ]
-- ==========================================

local ToggleMenuButton = Instance.new("TextButton")
ToggleMenuButton.Name = "ToggleMenuButton"
ToggleMenuButton.Size = UDim2.new(0, 45, 0, 45)
ToggleMenuButton.Position = UDim2.new(0, 20, 0, 80)
ToggleMenuButton.BackgroundColor3 = Color3.fromRGB(45, 35, 55)
ToggleMenuButton.Text = "S"
ToggleMenuButton.TextColor3 = Color3.fromRGB(215, 185, 255)
ToggleMenuButton.TextSize = 20
ToggleMenuButton.Font = Enum.Font.SourceSansBold
ToggleMenuButton.Active = true
ToggleMenuButton.Draggable = true
ToggleMenuButton.Parent = ScreenGui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(0, 22.5)
CircleCorner.Parent = ToggleMenuButton

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(180, 150, 220)
CircleStroke.Thickness = 1.5
CircleStroke.Parent = ToggleMenuButton

ToggleMenuButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ==========================================
-- [ Left Menu ]
-- ==========================================

local LeftMenu = Instance.new("Frame")
LeftMenu.Size = UDim2.new(0, 140, 1, -45)
LeftMenu.Position = UDim2.new(0, 10, 0, 35)
LeftMenu.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
LeftMenu.BorderSizePixel = 0
LeftMenu.Parent = MainFrame

local LeftCorner = Instance.new("UICorner")
LeftCorner.CornerRadius = UDim.new(0, 6)
LeftCorner.Parent = LeftMenu

-- ==========================================
-- [ Tab 1 ]
-- ==========================================

local TabBtn1 = Instance.new("TextButton")
TabBtn1.Size = UDim2.new(1, -10, 0, 35)
TabBtn1.Position = UDim2.new(0, 5, 0, 10)
TabBtn1.BackgroundColor3 = Color3.fromRGB(55, 45, 70)
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
-- [ Tab 2 ]
-- ==========================================

local TabBtn2 = Instance.new("TextButton")
TabBtn2.Size = UDim2.new(1, -10, 0, 35)
TabBtn2.Position = UDim2.new(0, 5, 0, 50)
TabBtn2.BackgroundColor3 = Color3.fromRGB(30, 22, 40)
TabBtn2.Text = " ⚙️ Auto Farm"
TabBtn2.TextColor3 = Color3.fromRGB(190, 175, 210)
TabBtn2.TextSize = 14
TabBtn2.Font = Enum.Font.SourceSansBold
TabBtn2.TextXAlignment = Enum.TextXAlignment.Left
TabBtn2.Parent = LeftMenu

local TabCorner2 = Instance.new("UICorner")
TabCorner2.CornerRadius = UDim.new(0, 4)
TabCorner2.Parent = TabBtn2

-- ==========================================
-- [ Player Panel ]
-- ==========================================

local PlayerPanel = Instance.new("Frame")
PlayerPanel.Size = UDim2.new(1, -10, 0, 140)
PlayerPanel.Position = UDim2.new(0, 5, 1, -145)
PlayerPanel.BackgroundTransparency = 1
PlayerPanel.Parent = LeftMenu

local PlayerImage = Instance.new("ImageLabel")
PlayerImage.Size = UDim2.new(0, 80, 0, 80)
PlayerImage.Position = UDim2.new(0.5, -40, 0, 10)
PlayerImage.BackgroundColor3 = Color3.fromRGB(35, 30, 45)
PlayerImage.BackgroundTransparency = 0
PlayerImage.Image = avatarImg
PlayerImage.Parent = PlayerPanel

local ImageCorner = Instance.new("UICorner")
ImageCorner.CornerRadius = UDim.new(0, 40)
ImageCorner.Parent = PlayerImage

local ImageStroke = Instance.new("UIStroke")
ImageStroke.Color = Color3.fromRGB(180, 150, 220)
ImageStroke.Thickness = 1.5
ImageStroke.Parent = PlayerImage

local PlayerNameLabel = Instance.new("TextLabel")
PlayerNameLabel.Size = UDim2.new(1, 0, 0, 20)
PlayerNameLabel.Position = UDim2.new(0, 0, 0, 95)
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.Text = "@" .. LocalPlayer.Name
PlayerNameLabel.TextColor3 = Color3.fromRGB(200, 180, 235)
PlayerNameLabel.TextSize = 12
PlayerNameLabel.Font = Enum.Font.SourceSansBold
PlayerNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
PlayerNameLabel.Parent = PlayerPanel

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 15)
StatusLabel.Position = UDim2.new(0, 0, 0, 115)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "★ PREM USER"
StatusLabel.TextColor3 = Color3.fromRGB(165, 255, 175)
StatusLabel.TextSize = 10
StatusLabel.Font = Enum.Font.SourceSansBold
StatusLabel.Parent = PlayerPanel

-- ==========================================
-- [ Pages ]
-- ==========================================

local PageCollect = Instance.new("ScrollingFrame")
PageCollect.Size = UDim2.new(1, -170, 1, -45)
PageCollect.Position = UDim2.new(0, 160, 0, 35)
PageCollect.BackgroundTransparency = 1
PageCollect.BorderSizePixel = 0
PageCollect.ScrollBarThickness = 4
PageCollect.CanvasSize = UDim2.new(0, 0, 0, 380)
PageCollect.Visible = true
PageCollect.Parent = MainFrame

local PageFarm = Instance.new("ScrollingFrame")
PageFarm.Size = UDim2.new(1, -170, 1, -45)
PageFarm.Position = UDim2.new(0, 160, 0, 35)
PageFarm.BackgroundTransparency = 1
PageFarm.BorderSizePixel = 0
PageFarm.ScrollBarThickness = 4
PageFarm.CanvasSize = UDim2.new(0, 0, 0, 420)
PageFarm.Visible = false
PageFarm.Parent = MainFrame

-- ==========================================
-- [ Tab Switching ]
-- ==========================================

TabBtn1.MouseButton1Click:Connect(function()
    PageCollect.Visible = true
    PageFarm.Visible = false

    TabBtn1.BackgroundColor3 = Color3.fromRGB(55, 45, 70)
    TabBtn1.TextColor3 = Color3.fromRGB(255, 255, 255)

    TabBtn2.BackgroundColor3 = Color3.fromRGB(30, 22, 40)
    TabBtn2.TextColor3 = Color3.fromRGB(190, 175, 210)
end)

TabBtn2.MouseButton1Click:Connect(function()
    PageCollect.Visible = false
    PageFarm.Visible = true

    TabBtn2.BackgroundColor3 = Color3.fromRGB(55, 45, 70)
    TabBtn2.TextColor3 = Color3.fromRGB(255, 255, 255)

    TabBtn1.BackgroundColor3 = Color3.fromRGB(30, 22, 40)
    TabBtn1.TextColor3 = Color3.fromRGB(190, 175, 210)
end)

-- ==========================================
-- [ Speed Slider ]
-- ==========================================

local function CreateSpeedSlider(parent, titleText, yPos, startVal, callback)

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Frame.Position = UDim2.new(0, 5, 0, yPos)
    Frame.BackgroundColor3 = Color3.fromRGB(45, 38, 55)
    Frame.Parent = parent

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 4)
    FrameCorner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = string.format("%s: %.2f วินาที", titleText, startVal)
    Label.TextColor3 = Color3.fromRGB(230, 215, 255)
    Label.TextSize = 12
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local SliderBar = Instance.new("TextButton")
    SliderBar.Size = UDim2.new(1, -20, 0, 8)
    SliderBar.Position = UDim2.new(0, 10, 0, 32)
    SliderBar.BackgroundColor3 = Color3.fromRGB(65, 55, 75)
    SliderBar.Text = ""
    SliderBar.AutoButtonColor = false
    SliderBar.Parent = Frame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 4)
    BarCorner.Parent = SliderBar

    local SliderBtn = Instance.new("TextButton")
    SliderBtn.Size = UDim2.new(0, 16, 0, 16)

    local initX = (startVal - 0.05) / 1.95
    initX = math.clamp(initX, 0, 1)

    SliderBtn.Position = UDim2.new(initX, -8, 0.5, -8)
    SliderBtn.BackgroundColor3 = Color3.fromRGB(215, 185, 255)
    SliderBtn.Text = ""
    SliderBtn.AutoButtonColor = false
    SliderBtn.Parent = SliderBar

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderBtn

    local dragging = false

    SliderBtn.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
        end
    end)

    SliderBar.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true

            local relativeX =
                (input.Position.X - SliderBar.AbsolutePosition.X)
                / SliderBar.AbsoluteSize.X

            relativeX = math.clamp(relativeX, 0, 1)

            SliderBtn.Position =
                UDim2.new(relativeX, -8, 0.5, -8)

            local calculatedVal =
                0.05 + (relativeX * 1.95)

            Label.Text =
                string.format("%s: %.2f วินาที", titleText, calculatedVal)

            callback(calculatedVal)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)

        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            local absolutePosition = SliderBar.AbsolutePosition
            local absoluteSize = SliderBar.AbsoluteSize

            if absoluteSize.X <= 0 then
                return
            end

            local mouseX = input.Position.X

            local relativeX =
                (mouseX - absolutePosition.X)
                / absoluteSize.X

            relativeX = math.clamp(relativeX, 0, 1)

            SliderBtn.Position =
                UDim2.new(relativeX, -8, 0.5, -8)

            local calculatedVal =
                0.05 + (relativeX * 1.95)

            Label.Text =
                string.format("%s: %.2f วินาที", titleText, calculatedVal)

            callback(calculatedVal)
        end
    end)
end

-- ==========================================
-- [ Toggle Switch ]
-- ==========================================

local function CreateSliderToggle(parent, text, yPos, callback)

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.Position = UDim2.new(0, 5, 0, yPos)
    Frame.BackgroundColor3 = Color3.fromRGB(38, 32, 48)
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
    Label.TextColor3 = Color3.fromRGB(230, 220, 245)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local SliderTrack = Instance.new("TextButton")
    SliderTrack.Size = UDim2.new(0, 40, 0, 20)
    SliderTrack.Position = UDim2.new(1, -50, 0.5, -10)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(50, 45, 55)
    SliderTrack.Text = ""
    SliderTrack.AutoButtonColor = false
    SliderTrack.Parent = Frame

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(0, 10)
    TrackCorner.Parent = SliderTrack

    local SliderBall = Instance.new("Frame")
    SliderBall.Size = UDim2.new(0, 16, 0, 16)
    SliderBall.Position = UDim2.new(0, 2, 0.5, -8)
    SliderBall.BackgroundColor3 = Color3.fromRGB(160, 140, 180)
    SliderBall.BorderSizePixel = 0
    SliderBall.Parent = SliderTrack

    local BallCorner = Instance.new("UICorner")
    BallCorner.CornerRadius = UDim.new(0, 8)
    BallCorner.Parent = SliderBall

    local toggled = false

    SliderTrack.MouseButton1Click:Connect(function()

        toggled = not toggled

        if toggled then

            SliderBall:TweenPosition(
                UDim2.new(1, -18, 0.5, -8),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.15,
                true
            )

            SliderTrack.BackgroundColor3 =
                Color3.fromRGB(130, 90, 185)

            SliderBall.BackgroundColor3 =
                Color3.fromRGB(215, 185, 255)

        else

            SliderBall:TweenPosition(
                UDim2.new(0, 2, 0.5, -8),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.15,
                true
            )

            SliderTrack.BackgroundColor3 =
                Color3.fromRGB(50, 45, 55)

            SliderBall.BackgroundColor3 =
                Color3.fromRGB(160, 140, 180)
        end

        callback(toggled)
    end)
end

-- ==========================================
-- [ Remote Function ]
-- ==========================================

local remoteFunction

pcall(function()
    remoteFunction =
        ReplicatedStorage
        :WaitForChild("Paper")
        :WaitForChild("Remotes")
        :WaitForChild("__remotefunction")
end)

-- ==========================================
-- [ AUTO COLLECT PAGE ]
-- ==========================================

CreateSpeedSlider(
    PageCollect,
    "⏱️ หน่วงเวลาดึงไข่/เพชร",
    10,
    getgenv().EggCollectCooldown,
    function(val)
        getgenv().EggCollectCooldown = val
    end
)

CreateSliderToggle(
    PageCollect,
    "Auto Collect Normal Eggs (ฟาร์มไข่เงียบ)",
    70,
    function(state)

        getgenv().AutoCollectEggs = state

        if not state then
            return
        end

        task.spawn(function()

            while getgenv().AutoCollectEggs do

                pcall(function()

                    local character = LocalPlayer.Character
                    if not character then
                        return
                    end

                    local hrp =
                        character:FindFirstChild("HumanoidRootPart")

                    if not hrp then
                        return
                    end

                    local eggsFolder =
                        workspace:FindFirstChild("Eggs")

                    if not eggsFolder then
                        return
                    end

                    for _, egg in pairs(eggsFolder:GetChildren()) do

                        if not getgenv().AutoCollectEggs then
                            break
                        end

                        if egg:IsA("BasePart")
                            and not string.find(egg.Name, "Purple") then

                            firetouchinterest(hrp, egg, 0)
                            task.wait()
                            firetouchinterest(hrp, egg, 1)
                        end
                    end
                end)

                task.wait(getgenv().EggCollectCooldown)
            end
        end)
    end
)

-- ==========================================
-- [ AUTO PURPLE DIAMONDS ]
-- ==========================================

CreateSliderToggle(
    PageCollect,
    "Auto Purple Diamonds [100X] (ฟาร์มเพชรคูณ100)",
    120,
    function(state)

        getgenv().AutoPurpleDiamondsX100 = state

        if not state then
            return
        end

        task.spawn(function()

            while getgenv().AutoPurpleDiamondsX100 do

                pcall(function()

                    local character = LocalPlayer.Character
                    if not character then
                        return
                    end

                    local hrp =
                        character:FindFirstChild("HumanoidRootPart")

                    if not hrp then
                        return
                    end

                    local eggsFolder =
                        workspace:FindFirstChild("Eggs")

                    if not eggsFolder then
                        return
                    end

                    for _, object in pairs(eggsFolder:GetChildren()) do

                        if not getgenv().AutoPurpleDiamondsX100 then
                            break
                        end

                        if object:IsA("BasePart")
                            and string.find(object.Name, "Purple") then

                            for i = 1, 100 do

                                if not getgenv().AutoPurpleDiamondsX100 then
                                    break
                                end

                                firetouchinterest(hrp, object, 0)
                                firetouchinterest(hrp, object, 1)
                            end
                        end
                    end
                end)

                task.wait(getgenv().EggCollectCooldown)
            end
        end)
    end
)

-- ==========================================
-- [ AUTO FARM PAGE ]
-- ==========================================

CreateSpeedSlider(
    PageFarm,
    "⏱️ หน่วงเวลารีโมทฟาร์มต่างๆ",
    10,
    getgenv().GlobalCooldown,
    function(val)
        getgenv().GlobalCooldown = val
    end
)

-- ==========================================
-- [ Auto Deposit Eggs ]
-- ==========================================

CreateSliderToggle(
    PageFarm,
    "Auto Deposit Eggs (ส่งไข่ออโต้)",
    70,
    function(state)

        getgenv().AutoDepositEggs = state

        if not state then
            return
        end

        task.spawn(function()

            while getgenv().AutoDepositEggs do

                if remoteFunction then
                    pcall(function()
                        remoteFunction:InvokeServer("Deposit Eggs")
                    end)
                end

                task.wait(getgenv().GlobalCooldown)
            end
        end)
    end
)

-- ==========================================
-- [ Auto Collect Cash ]
-- ==========================================

CreateSliderToggle(
    PageFarm,
    "Auto Collect Cash (เก็บเงินออโต้)",
    120,
    function(state)

        getgenv().AutoCollectCash = state

        if not state then
            return
        end

        task.spawn(function()

            while getgenv().AutoCollectCash do

                if remoteFunction then
                    pcall(function()
                        remoteFunction:InvokeServer("Collect Cash")
                    end)
                end

                task.wait(getgenv().GlobalCooldown)
            end
        end)
    end
)

-- ==========================================
-- [ Auto Buy Chickens ]
-- ==========================================

CreateSliderToggle(
    PageFarm,
    "Auto Buy Chickens [x100] (ซื้อไก่ออโต้)",
    170,
    function(state)

        getgenv().AutoBuyChickens = state

        if not state then
            return
        end

        task.spawn(function()

            while getgenv().AutoBuyChickens do

                if remoteFunction then
                    pcall(function()
                        remoteFunction:InvokeServer("Buy Chickens", 100)
                    end)
                end

                task.wait(getgenv().GlobalCooldown)
            end
        end)
    end
)

-- ==========================================
-- [ Auto Open Lucky Block ]
-- ==========================================

CreateSliderToggle(
    PageFarm,
    "Auto Open Lucky Block (เปิดกล่องออโต้)",
    220,
    function(state)

        getgenv().AutoOpenLuckyBlock = state

        if not state then
            return
        end

        task.spawn(function()

            while getgenv().AutoOpenLuckyBlock do

                if remoteFunction then
                    pcall(function()
                        remoteFunction:InvokeServer("Open Lucky Block")
                    end)
                end

                task.wait(getgenv().GlobalCooldown)
            end
        end)
    end
)

print("SpeedAutoGUI loaded successfully.")
