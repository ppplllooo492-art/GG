-- [[ โค้ด Mini Delta Hub เวอร์ชั่นซัพพอร์ตมือถือ มีปุ่มย่อขยายหน้าต่าง ]]
local MiniDelta = Instance.new("ScreenGui")
MiniDelta.Name = "MiniDeltaHubMobile"
MiniDelta.Parent = game:GetService("CoreGui")
MiniDelta.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 260) -- ปรับขนาดให้พอดีจอโทรศัพท์
MainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = MiniDelta
local MainCorner = Instance.new("UICorner") MainCorner.Parent = MainFrame

-- [ สร้างปุ่มเปิด/ปิด จิ๋วหลบมุมจอ ]
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.05, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 90)
ToggleBtn.Text = "Δ"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 24
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true -- ลากปุ่มหลบไปไว้ตรงไหนของจอมือถือก็ได้
ToggleBtn.Parent = MiniDelta
local BtnCorner = Instance.new("UICorner") BtnCorner.CornerRadius = UDim.new(0, 25) BtnCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ( ส่วนโครงสร้างแท็บเมนู )
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 35)
TabBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
TabBar.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -35)
ContentFrame.Position = UDim2.new(0, 0, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local Tabs = {}
local function CreateTabButton(name, pos, frame)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.48, 0, 1, 0)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = TabBar
    frame.Parent = ContentFrame
    frame.Visible = false
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Frame.Visible = false t.Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35) end
        frame.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end)
    table.insert(Tabs, {Btn = btn, Frame = frame})
end

-- ==========================================================
-- แท็บที่ 1: รันสคริปต์และทดสอบ (Executor)
-- ==========================================================
local ExecFrame = Instance.new("Frame")
ExecFrame.Size = UDim2.new(1, 0, 1, 0)
ExecFrame.BackgroundTransparency = 1

local ScriptBox = Instance.new("TextBox")
ScriptBox.Size = UDim2.new(0.94, 0, 0.7, 0)
ScriptBox.Position = UDim2.new(0.03, 0, 0.03, 0)
ScriptBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
ScriptBox.Text = "-- วางสคริปต์/โค้ดทดสอบตรงนี้\nprint('Mobile Test!')"
ScriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptBox.Font = Enum.Font.Code
ScriptBox.TextSize = 12
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.ClearTextOnFocus = false
ScriptBox.MultiLine = true
ScriptBox.Parent = ExecFrame

local RunBtn = Instance.new("TextButton")
RunBtn.Size = UDim2.new(0.94, 0, 0.18, 0)
RunBtn.Position = UDim2.new(0.03, 0, 0.78, 0)
RunBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 90)
RunBtn.Text = "⚡ RUN CODE"
RunBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RunBtn.Font = Enum.Font.SourceSansBold
RunBtn.TextSize = 14
RunBtn.Parent = ExecFrame

RunBtn.MouseButton1Click:Connect(function()
    local code = ScriptBox.Text
    if code and code ~= "" then
        local success, err = pcall(function()
            local func = loadstring(code)
            if func then func() else error("Syntax Error") end
        end)
        if not success then warn("Error: " .. tostring(err)) end
    end
end)

CreateTabButton("💻 Run & Test Script", UDim2.new(0, 0, 0, 0), ExecFrame)
Tabs[1].Frame.Visible = true
Tabs[1].Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)

-- ==========================================================
-- แท็บที่ 2: ดักจับค่า Server (Remote Spy)
-- ==========================================================
local SpyFrame = Instance.new("Frame")
SpyFrame.Size = UDim2.new(1, 0, 1, 0)
SpyFrame.BackgroundTransparency = 1

local LogScroll = Instance.new("ScrollingFrame")
LogScroll.Size = UDim2.new(0.94, 0, 0.7, 0)
LogScroll.Position = UDim2.new(0.03, 0, 0.03, 0)
LogScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
LogScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
LogScroll.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
LogScroll.Parent = SpyFrame

local UIList = Instance.new("UIListLayout") UIList.Parent = LogScroll; UIList.Padding = UDim.new(0, 4)

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.94, 0, 0.18, 0)
ClearBtn.Position = UDim2.new(0.03, 0, 0.78, 0)
ClearBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
ClearBtn.Text = "🗑️ CLEAR LOGS"
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.Font = Enum.Font.SourceSansBold
ClearBtn.TextSize = 14
ClearBtn.Parent = SpyFrame

ClearBtn.MouseButton1Click:Connect(function()
    for _, item in pairs(LogScroll:GetChildren()) do if item:IsA("TextBox") then item:Destroy() end end
end)

local rawmt = getrawmetatable(game)
local oldNamecall = rawmt.__namecall
setreadonly(rawmt, false)
rawmt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if (method == "FireServer" and self:IsA("RemoteEvent")) or (method == "InvokeServer" and self:IsA("RemoteFunction")) then
        task.spawn(function()
            local LogBox = Instance.new("TextBox")
            LogBox.Size = UDim2.new(1, 0, 0, 30)
            LogBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            LogBox.TextColor3 = Color3.fromRGB(0, 255, 150)
            LogBox.Font = Enum.Font.Code
            LogBox.TextSize = 10
            LogBox.ClearTextOnFocus = false
            LogBox.TextXAlignment = Enum.TextXAlignment.Left
            local txt = string.format(" [%s] %s -> ", method, self.Name)
            for i, v in pairs(args) do txt = txt .. string.format("[%d]:%s ", i, tostring(v)) end
            LogBox.Text = txt
            LogBox.Parent = LogScroll
        end)
    end
    return oldNamecall(self, ...)
end)
setreadonly(rawmt, true)

CreateTabButton("📡 Remote Spy", UDim2.new(0.52, 0, 0, 0), SpyFrame)
