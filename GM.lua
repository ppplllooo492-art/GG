-- [[ Delta X Spy & Dumper Ultimate Fusion v5.0 (Modern Reborn) ]] --

-- =============================================================================
-- [ 1. SYSTEM INITIALIZATION & CLEANUP ]
-- =============================================================================
if _G.DeltaLoggerActive then _G.DeltaLoggerActive = false end
if _G.RemoteLoggerUI then _G.RemoteLoggerUI:Destroy() end
task.wait(0.2)

_G.DeltaLoggerActive = true

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- =============================================================================
-- [ 2. MODERN DARK UI CREATION ]
-- =============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaFusionSuiteV5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui
_G.RemoteLoggerUI = ScreenGui

-- ฟังก์ชันช่วยใส่ความโค้งมนให้กับ UI
local function applyCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

-- [ ปุ่มเปิด/ปิด เมนูหลัก ]
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 120, 0, 40)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 0)
ToggleBtn.Text = "Toggle Menu"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui
applyCorner(ToggleBtn, 8)

-- [ หน้าต่างเมนูหลัก ]
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
applyCorner(MainFrame, 10)

-- แถบหัวข้อบน (TopBar)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
applyCorner(TopBar, 10)

-- แก้ไขเหลี่ยมด้านล่างของ TopBar ไม่ให้เกินขอบมนหลัก
local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 10)
TopBarFix.Position = UDim2.new(0, 0, 1, -10)
TopBarFix.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Position = UDim2.new(0.04, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DELTA FUSION SUITE v5.0"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.fromRGB(255, 110, 0)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- เมนูด้านซ้าย (SideBar)
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 140, 1, -45)
SideBar.Position = UDim2.new(0, 0, 0, 45)
SideBar.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideBarLayout = Instance.new("UIListLayout")
SideBarLayout.Padding = UDim.new(0, 8)
SideBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideBarLayout.Parent = SideBar

local SideBarPadding = Instance.new("UIPadding")
SideBarPadding.PaddingTop = UDim.new(0, 15)
SideBarPadding.Parent = SideBar

-- ปุ่มสำหรับสลับหน้า (Tabs)
local BtnSpyTab = Instance.new("TextButton")
BtnSpyTab.Size = UDim2.new(0.85, 0, 0, 38)
BtnSpyTab.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
BtnSpyTab.Text = "📡 REMOTE SPY"
BtnSpyTab.Font = Enum.Font.SourceSansBold
BtnSpyTab.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnSpyTab.TextSize = 13
BtnSpyTab.Parent = SideBar
applyCorner(BtnSpyTab, 6)

local BtnDumperTab = Instance.new("TextButton")
BtnDumperTab.Size = UDim2.new(0.85, 0, 0, 38)
BtnDumperTab.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
BtnDumperTab.Text = "🗺️ MAP DUMPER"
BtnDumperTab.Font = Enum.Font.SourceSansBold
BtnDumperTab.TextColor3 = Color3.fromRGB(160, 160, 160)
BtnDumperTab.TextSize = 13
BtnDumperTab.Parent = SideBar
applyCorner(BtnDumperTab, 6)

-- พื้นที่แสดงเนื้อหา (Tab Container)
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -140, 1, -45)
TabContainer.Position = UDim2.new(0, 140, 0, 45)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- =============================================================================
-- [ 3. TAB PAGES CREATION ]
-- =============================================================================

-- [ หน้าที่ 1: REMOTE SPY ]
local SpyPage = Instance.new("Frame")
SpyPage.Size = UDim2.new(1, 0, 1, 0)
SpyPage.BackgroundTransparency = 1
SpyPage.Parent = TabContainer

local ClearSpyBtn = Instance.new("TextButton")
ClearSpyBtn.Size = UDim2.new(0, 110, 0, 28)
ClearSpyBtn.Position = UDim2.new(0.72, 0, 0.03, 0)
ClearSpyBtn.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
ClearSpyBtn.Text = "CLEAR LOGS"
ClearSpyBtn.Font = Enum.Font.SourceSansBold
ClearSpyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearSpyBtn.TextSize = 12
ClearSpyBtn.Parent = SpyPage
applyCorner(ClearSpyBtn, 5)

local LogScrollingFrame = Instance.new("ScrollingFrame")
LogScrollingFrame.Size = UDim2.new(0.94, 0, 0.82, 0)
LogScrollingFrame.Position = UDim2.new(0.03, 0, 0.14, 0)
LogScrollingFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 14)
LogScrollingFrame.BorderSizePixel = 0
LogScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
LogScrollingFrame.ScrollBarThickness = 5
LogScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 110, 0)
LogScrollingFrame.Parent = SpyPage
applyCorner(LogScrollingFrame, 6)

local LogListLayout = Instance.new("UIListLayout")
LogListLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogListLayout.Padding = UDim.new(0, 6)
LogListLayout.Parent = LogScrollingFrame

local LogPadding = Instance.new("UIPadding")
LogPadding.PaddingTop = UDim.new(0, 6)
LogPadding.PaddingLeft = UDim.new(0, 6)
LogPadding.Parent = LogScrollingFrame

-- [ หน้าที่ 2: MAP DUMPER ]
local DumperPage = Instance.new("Frame")
DumperPage.Size = UDim2.new(1, 0, 1, 0)
DumperPage.BackgroundTransparency = 1
DumperPage.Visible = false
DumperPage.Parent = TabContainer

local DumpMapBtn = Instance.new("TextButton")
DumpMapBtn.Size = UDim2.new(0.94, 0, 0, 35)
DumpMapBtn.Position = UDim2.new(0.03, 0, 0.03, 0)
DumpMapBtn.BackgroundColor3 = Color3.fromRGB(36, 120, 75)
DumpMapBtn.Text = "เริ่มดึงโค้ดข้อมูลแมพทั้งหมด (Full Map Code Dump)"
DumpMapBtn.Font = Enum.Font.SourceSansBold
DumpMapBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DumpMapBtn.TextSize = 13
DumpMapBtn.Parent = DumperPage
applyCorner(DumpMapBtn, 6)

local MapTextBox = Instance.new("TextBox")
MapTextBox.Size = UDim2.new(0.94, 0, 0, 220)
MapTextBox.Position = UDim2.new(0.03, 0, 0.16, 0)
MapTextBox.BackgroundColor3 = Color3.fromRGB(11, 11, 14)
MapTextBox.BorderSizePixel = 0
MapTextBox.Text = "-- โค้ดข้อมูลโครงสร้างแมพทั้งหมดจะแสดงตรงนี้หลังจากกดปุ่มดั้ม --"
MapTextBox.Font = Enum.Font.Code
MapTextBox.TextColor3 = Color3.fromRGB(0, 230, 100)
MapTextBox.TextSize = 11
MapTextBox.ClearTextOnFocus = false
MapTextBox.MultiLine = true
MapTextBox.TextXAlignment = Enum.TextXAlignment.Left
MapTextBox.TextYAlignment = Enum.TextYAlignment.Top
MapTextBox.Parent = DumperPage
applyCorner(MapTextBox, 6)

local MapCopyBtn = Instance.new("TextButton")
MapCopyBtn.Size = UDim2.new(0.94, 0, 0, 35)
MapCopyBtn.Position = UDim2.new(0.03, 0, 0.85, 0)
MapCopyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
MapCopyBtn.Text = "📋 คัดลอกโค้ดโครงสร้างแมพทั้งหมด"
MapCopyBtn.Font = Enum.Font.SourceSansBold
MapCopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MapCopyBtn.TextSize = 13
MapCopyBtn.Parent = DumperPage
applyCorner(MapCopyBtn, 6)

-- =============================================================================
-- [ 4. UI INTERACTION CONTROL & INTERFACE LOGIC ]
-- =============================================================================

-- ปุ่มย่อ/ขยาย เมนูหลัก
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ฟังก์ชันสลับหน้าอย่างเป็นระบบ พร้อมแอนิเมชันสีปุ่ม
local function ShowPage(targetTab)
    SpyPage.Visible = (targetTab == "Spy")
    DumperPage.Visible = (targetTab == "Dumper")
    
    if targetTab == "Spy" then
        BtnSpyTab.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        BtnSpyTab.TextColor3 = Color3.fromRGB(255, 110, 0)
        BtnDumperTab.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        BtnDumperTab.TextColor3 = Color3.fromRGB(160, 160, 160)
    else
        BtnSpyTab.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        BtnSpyTab.TextColor3 = Color3.fromRGB(160, 160, 160)
        BtnDumperTab.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        BtnDumperTab.TextColor3 = Color3.fromRGB(255, 110, 0)
    end
end

BtnSpyTab.MouseButton1Click:Connect(function() ShowPage("Spy") end)
BtnDumperTab.MouseButton1Click:Connect(function() ShowPage("Dumper") end)

-- ปุ่มล้างประวัติการตรวจจับ Remote
ClearSpyBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(LogScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    LogScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
end)

-- =============================================================================
-- [ 5. BACKEND LOGIC & ENGINE FUNCTIONALITY ]
-- =============================================================================

-- ฟังก์ชันวิเคราะห์หาตำแหน่งของวัตถุภายในแมพ
local function getPosition(obj)
    if obj:IsA("Model") then
        if obj.PrimaryPart then 
            return obj.PrimaryPart.Position
        else 
            local part = obj:FindFirstChildWhichIsA("BasePart", true) 
            if part then return part.Position end 
        end
elseif obj:IsA("BasePart") thenreturn obj.Positionendreturn nilend-- ฟังก์ชันประมวลผลคำสั่งดึงข้อมูลแมพ (Map Dumper Event)DumpMapBtn.MouseButton1Click:Connect(function()DumpMapBtn.Text = "กำลังสแกนสโคปและโครงสร้างวัตถุ... กรุณารอสักครู่"task.wait(0.2)local dumpResult = "-- [[ ROBLOX FULL MAP DUMP DATA ]] --\nlocal GameMapStructure = {\n"local keywords = {["Monsters"] = {"Monster", "NPC", "Enemy", "Boss"},["Chests"] = {"Chest", "Treasure", "Gold", "Box"},["Items"] = {"Fruit", "Item", "Tool", "Weapon", "Spawn"}}for category, wordList in pairs(keywords) dodumpResult = dumpResult .. "    ["" .. category .. ""] = {\n"for _, obj in pairs(Workspace:GetDescendants()) dolocal match = falsefor _, word in pairs(wordList) doif string.find(string.lower(obj.Name), string.lower(word)) thenmatch = truebreakendendif match thenlocal pos = getPosition(obj)if pos thendumpResult = dumpResult .. string.format('        {Name = "%s", Class = "%s", Vector = Vector3.new(%.2f, %.2f, %.2f)},\n', obj.Name, obj.ClassName, pos.X, pos.Y, pos.Z)endendenddumpResult = dumpResult .. "    },\n"enddumpResult = dumpResult .. "}\nreturn GameMapStructure"MapTextBox.Text = dumpResultDumpMapBtn.Text = "ดึงข้อมูลโครงสร้างวัตถุเสร็จสิ้น!"end)-- ฟังก์ชันปุ่มคัดลอกรหัสโครงสร้างแมพMapCopyBtn.MouseButton1Click:Connect(function()if setclipboard thensetclipboard(MapTextBox.Text)MapCopyBtn.Text = "✅ คัดลอกรหัสโครงสร้างลงคลิปบอร์ดแล้ว!"task.wait(1.5)MapCopyBtn.Text = "📋 คัดลอกโค้ดโครงสร้างแมพทั้งหมด"endend)-- ฟังก์ชันแปลงและจัดรูปแบบ Arguments ของ Remotelocal function ParseArguments(...)local args = {...}local strArgs = {}for i, v in ipairs(args) dolocal t = type(v)if t == "string" thentable.insert(strArgs, '"' .. v .. '"')elseif t == "userdata" and typeof(v) == "Instance" thentable.insert(strArgs, v:GetFullName())elsetable.insert(strArgs, tostring(v))endendreturn table.concat(strArgs, ", ")end-- ฟังก์ชันจัดเก็บและแสดงประวัติการเรียกใช้ Remote (Spy Logging)local function LogRemoteSafe(name, path, argsText, method)if not _G.DeltaLoggerActive then return end-- ลิมิตประวัติบันทึกไว้สูงสุดที่ 20 รายการเพื่อป้องกัน UI ค้างหรือหน่วงlocal logs = 0for _, c in pairs(LogScrollingFrame:GetChildren()) doif c:IsA("Frame") then logs = logs + 1 endendif logs >= 20 thenlocal first = LogScrollingFrame:FindFirstChild("ItemFrame")if first then first:Destroy() endendlocal ItemFrame = Instance.new("Frame")ItemFrame.Name = "ItemFrame"ItemFrame.Size = UDim2.new(0.96, 0, 0, 52)ItemFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 29)ItemFrame.BorderSizePixel = 0ItemFrame.Parent = LogScrollingFrameapplyCorner(ItemFrame, 6)local InfoLabel = Instance.new("TextLabel")InfoLabel.Size = UDim2.new(0.76, 0, 0.8, 0)InfoLabel.Position = UDim2.new(0.03, 0, 0.1, 0)InfoLabel.BackgroundTransparency = 1InfoLabel.Font = Enum.Font.SourceSansInfoLabel.Text = string.format("[%s] Name: %s\nArgs: %s", method, name, argsText)InfoLabel.TextColor3 = Color3.fromRGB(235, 235, 235)InfoLabel.TextSize = 12InfoLabel.TextXAlignment = Enum.TextXAlignment.LeftInfoLabel.TextWrapped = trueInfoLabel.Parent = ItemFramelocal CopyButton = Instance.new("TextButton")CopyButton.Size = UDim2.new(0.18, 0, 0.7, 0)CopyButton.Position = UDim2.new(0.79, 0, 0.15, 0)CopyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 85)CopyButton.Text = "COPY"CopyButton.Font = Enum.Font.SourceSansBoldCopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)CopyButton.TextSize = 12CopyButton.Parent = ItemFrameapplyCorner(CopyButton, 4)local rawCode = string.format("-- Generated Safe Code\nlocal Remote = game.%s\nRemote:%s(%s)", path, method, argsText)CopyButton.MouseButton1Click:Connect(function()if setclipboard thensetclipboard(rawCode)CopyButton.Text = "COPIED!"CopyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)task.wait(0.7)CopyButton.Text = "COPY"CopyButton.BackgroundColor3 = Color3.fromRGB(0, 130, 85)endend)LogScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, LogListLayout.AbsoluteContentSize.Y + 15)end-- =============================================================================-- [ 6. METATABLE HOOKING ENGINE ]-- =============================================================================local oldNamecalloldNamecall = hookmetamethod(game, "__namecall", function(self, ...)local method = getnamecallmethod()if _G.DeltaLoggerActive and (method == "FireServer" or method == "InvokeServer") thenlocal argsText = ParseArguments(...)local name = tostring(self.Name)local path = "GetService("ReplicatedStorage")." .. namepcall(function() path = self:GetFullName() end)task.spawn(function()LogRemoteSafe(name, path, argsText, method)end)endreturn oldNamecall(self, ...)end)-- เริ่มต้นเปิดใช้งานหน้าดักจับ Remote Spy เป็นหน้าแรกShowPage("Spy")
