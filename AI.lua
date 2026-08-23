-- [[ EXPERT STANDALONE DEVELOPER SUITE: DEX & RSPY ]]
-- เวอร์ชันแก้ error / ตัดระบบคลิปบอร์ดออกทั้งหมด

local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

if CoreGui:FindFirstChild("UltimateCleanSuite") then
    CoreGui.UltimateCleanSuite:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateCleanSuite"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.BorderSizePixel = 1
MainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 640, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- แถบควบคุมด้านบน
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local WindowTitle = Instance.new("TextLabel")
WindowTitle.Parent = TopBar
WindowTitle.BackgroundTransparency = 1
WindowTitle.Position = UDim2.new(0, 15, 0, 0)
WindowTitle.Size = UDim2.new(0.6, 0, 1, 0)
WindowTitle.Font = Enum.Font.SourceSansBold
WindowTitle.Text = "DELTA SYSTEM DEVELOPER SUITE (FULL EMBEDDED)"
WindowTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
WindowTitle.TextSize = 16
WindowTitle.TextXAlignment = Enum.TextXAlignment.Left

local CloseWindowBtn = Instance.new("TextButton")
CloseWindowBtn.Parent = TopBar
CloseWindowBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseWindowBtn.Position = UDim2.new(1, -45, 0, 7)
CloseWindowBtn.Size = UDim2.new(0, 30, 0, 26)
CloseWindowBtn.Font = Enum.Font.SourceSansBold
CloseWindowBtn.Text = "X"
CloseWindowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseWindowBtn.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseWindowBtn

CloseWindowBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ส่วนหัวของฝั่งซ้ายและขวา
local DexHeader = Instance.new("TextLabel")
DexHeader.Parent = MainFrame
DexHeader.BackgroundTransparency = 1
DexHeader.Position = UDim2.new(0, 15, 0, 45)
DexHeader.Size = UDim2.new(0, 290, 0, 25)
DexHeader.Font = Enum.Font.SourceSansBold
DexHeader.Text = "📁 DEX EXPLORER VIEW"
DexHeader.TextColor3 = Color3.fromRGB(150, 200, 150)
DexHeader.TextSize = 14
DexHeader.TextXAlignment = Enum.TextXAlignment.Left

local SpyHeader = Instance.new("TextLabel")
SpyHeader.Parent = MainFrame
SpyHeader.BackgroundTransparency = 1
SpyHeader.Position = UDim2.new(0, 325, 0, 45)
SpyHeader.Size = UDim2.new(0, 300, 0, 25)
SpyHeader.Font = Enum.Font.SourceSansBold
SpyHeader.Text = "📡 REMOTE EVENT SPY MONITOR"
SpyHeader.TextColor3 = Color3.fromRGB(200, 150, 150)
SpyHeader.TextSize = 14
SpyHeader.TextXAlignment = Enum.TextXAlignment.Left

-- ฟังก์ชันสร้างกล่องสกรอลล์ข้อมูล
local function BuildScrollBox(parent, boxName, framePos, frameSize)
    local Container = Instance.new("ScrollingFrame")
    Container.Name = boxName
    Container.Parent = parent
    Container.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Container.BorderColor3 = Color3.fromRGB(40, 40, 40)
    Container.Position = framePos
    Container.Size = frameSize
    Container.ScrollBarThickness = 6
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.AutomaticCanvasSize = Enum.AutomaticSize.None

    local Alignment = Instance.new("UIListLayout")
    Alignment.Parent = Container
    Alignment.SortOrder = Enum.SortOrder.LayoutOrder
    Alignment.Padding = UDim.new(0, 4)

    return Container, Alignment
end

local MainDexScroll, MainDexList =
    BuildScrollBox(
        MainFrame,
        "MainDexScroll",
        UDim2.new(0, 10, 0, 75),
        UDim2.new(0, 300, 0, 330)
    )

local MainSpyScroll, MainSpyList =
    BuildScrollBox(
        MainFrame,
        "MainSpyScroll",
        UDim2.new(0, 320, 0, 75),
        UDim2.new(0, 310, 0, 330)
    )

-- ====================================================================
-- [ ระบบที่ 1: DEX EXPLORER ]
-- ====================================================================

local function PopulateDexTree(rootInstance, depthLevel, prefixText)
    local gameServices

    if rootInstance then
        gameServices = rootInstance:GetChildren()
    else
        gameServices = {
            game.Workspace,
            game.ReplicatedStorage,
            game.Players,
            game.Lighting,
            game.StarterGui
        }
    end

    prefixText = prefixText or ""

    if not depthLevel then
        for _, oldNode in ipairs(MainDexScroll:GetChildren()) do
            if oldNode:IsA("TextButton") then
                oldNode:Destroy()
            end
        end
    end

    for _, coreObj in ipairs(gameServices) do
        local NodeBtn = Instance.new("TextButton")
        NodeBtn.Parent = MainDexScroll
        NodeBtn.Size = UDim2.new(1, -8, 0, 28)
        NodeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        NodeBtn.BorderColor3 = Color3.fromRGB(45, 45, 45)

        local hasChildren = #coreObj:GetChildren() > 0
        local symbol = hasChildren and "📂 " or "📄 "

        NodeBtn.Text =
            prefixText ..
            symbol ..
            coreObj.Name ..
            " [" ..
            coreObj.ClassName ..
            "]"

        NodeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        NodeBtn.TextXAlignment = Enum.TextXAlignment.Left
        NodeBtn.Font = Enum.Font.SourceSans
        NodeBtn.TextSize = 13

        local isNodeExpanded = false

        NodeBtn.MouseButton1Click:Connect(function()
            if not coreObj or not coreObj.Parent then
                return
            end

            if not isNodeExpanded then
                isNodeExpanded = true
                NodeBtn.BackgroundColor3 = Color3.fromRGB(40, 55, 40)

                print("==========================================")
                print("🔍 [EXPLORING OBJECT]: " .. coreObj:GetFullName())
                print("==========================================")

                for _, insideObj in ipairs(coreObj:GetChildren()) do
                    print(
                        string.format(
                            "-> NAME: %s | CLASS: %s",
                            insideObj.Name,
                            insideObj.ClassName
                        )
                    )
                end
            else
                isNodeExpanded = false
                NodeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
        end)
    end

    MainDexScroll.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            MainDexList.AbsoluteContentSize.Y + 15
        )
end

PopulateDexTree(nil, false, "")

-- ====================================================================
-- [ ระบบที่ 2: REMOTE EVENT SPY ]
-- ====================================================================

local function InsertSpyMonitorLog(commType, commInstance, packetArgs)
    if not commInstance or not commInstance.Parent then
        return
    end

    local LogRow = Instance.new("TextButton")
    LogRow.Parent = MainSpyScroll
    LogRow.Size = UDim2.new(1, -8, 0, 34)

    if commType == "Event" then
        LogRow.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
    else
        LogRow.BackgroundColor3 = Color3.fromRGB(30, 40, 50)
    end

    LogRow.BorderColor3 = Color3.fromRGB(60, 60, 60)
    LogRow.Text =
        string.format(
            " [%s] -> %s",
            commType:upper(),
            commInstance.Name
        )

    LogRow.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogRow.TextXAlignment = Enum.TextXAlignment.Left
    LogRow.Font = Enum.Font.SourceSansBold
    LogRow.TextSize = 12

    LogRow.MouseButton1Click:Connect(function()
        if not commInstance or not commInstance.Parent then
            return
        end

        print("------------------------------------------")
        print("📡 [REMOTE TRAFFIC CAPTURED]")
        print("NAME: " .. commInstance.Name)
        print("FULL PATH: game:" .. commInstance:GetFullName())
        print("METHOD TYPE: " .. commType)
        print("------------------------------------------")

        for index, val in ipairs(packetArgs) do
            print(
                string.format(
                    " Parameter [%d]: Value = %s | Type = %s",
                    index,
                    tostring(val),
                    typeof(val)
                )
            )
        end

        print("------------------------------------------")
    end)

    local allLogs = {}

    for _, child in ipairs(MainSpyScroll:GetChildren()) do
        if child:IsA("TextButton") then
            table.insert(allLogs, child)
        end
    end

    if #allLogs > 45 then
        for i = 1, (#allLogs - 45) do
            if allLogs[i] and allLogs[i].Parent then
                allLogs[i]:Destroy()
            end
        end
    end

    MainSpyScroll.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            MainSpyList.AbsoluteContentSize.Y + 15
        )
end

-- ====================================================================
-- [ FIX: ตรวจสอบว่ารันใน Environment ที่รองรับ Metatable Hook หรือไม่ ]
-- ====================================================================

local function StartRemoteSpy()
    local getRawMeta = getrawmetatable
    local newClosure = newcclosure
    local getNameCallMethod = getnamecallmethod
    local setReadOnly = setreadonly

    if type(getRawMeta) ~= "function"
        or type(newClosure) ~= "function"
        or type(getNameCallMethod) ~= "function"
        or type(setReadOnly) ~= "function" then

        warn(
            "[UltimateCleanSuite] Remote Spy disabled: " ..
            "current environment does not provide the required hook API."
        )

        return false
    end

    local success, err = pcall(function()
        local gameMetatable = getRawMeta(game)

        if not gameMetatable then
            error("Unable to obtain game metatable")
        end

        local backupNamecall = gameMetatable.__namecall

        if type(backupNamecall) ~= "function" then
            error("game.__namecall is unavailable")
        end

        setReadOnly(gameMetatable, false)

        gameMetatable.__namecall = newClosure(function(self, ...)
            local currentMethod = getNameCallMethod()
            local argumentList = {...}

            if currentMethod == "FireServer"
                and typeof(self) == "Instance"
                and self:IsA("RemoteEvent") then

                task.spawn(function()
                    pcall(function()
                        InsertSpyMonitorLog(
                            "Event",
                            self,
                            argumentList
                        )
                    end)
                end)

            elseif currentMethod == "InvokeServer"
                and typeof(self) == "Instance"
                and self:IsA("RemoteFunction") then

                task.spawn(function()
                    pcall(function()
                        InsertSpyMonitorLog(
                            "Func",
                            self,
                            argumentList
                        )
                    end)
                end)
            end

            return backupNamecall(self, ...)
        end)

        setReadOnly(gameMetatable, true)
    end)

    if not success then
        warn(
            "[UltimateCleanSuite] Failed to start Remote Spy: " ..
            tostring(err)
        )

        return false
    end

    return true
end

local SpyEnabled = StartRemoteSpy()

-- ====================================================================
-- [ Notification ]
-- ====================================================================

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Delta Suite Ready",
        Text = SpyEnabled
            and "ระบบ DEX และ Remote Spy เปิดทำงานแล้ว!"
            or "DEX เปิดทำงานแล้ว แต่ Remote Spy ไม่รองรับใน Environment นี้",
        Duration = 3
    })
end)
