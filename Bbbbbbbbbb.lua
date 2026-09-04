-- สร้างหน้าต่าง UI หลัก
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local DumpBtn = Instance.new("TextButton")
local ToggleBtn = Instance.new("TextButton")
local CodeBox = Instance.new("TextBox")
local CopyBtn = Instance.new("TextButton")

-- ตั้งค่าตัวเปิด/ปิด UI (ปุ่มเล็กๆ บนหน้าจอ)
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleBtn.Size = UDim2.new(0, 80, 0, 35)
ToggleBtn.Text = "เปิด/ปิด"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Active = true
ToggleBtn.Draggable = true -- สามารถลากย้ายตำแหน่งปุ่มได้

-- หน้าต่างเมนูหลัก
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 320)
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "MAP DUMPER & EXTRACTOR"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 16

-- ปุ่มสั่งดั้มไฟล์
DumpBtn.Parent = MainFrame
DumpBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
DumpBtn.Size = UDim2.new(0, 315, 0, 40)
DumpBtn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
DumpBtn.Text = "เริ่มดั้มข้อมูลแมพทั้งหมด"
DumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DumpBtn.TextSize = 14

-- กล่องแสดงผลโค้ดที่ดึงมาได้
CodeBox.Parent = MainFrame
CodeBox.Position = UDim2.new(0.05, 0, 0.32, 0)
CodeBox.Size = UDim2.new(0, 315, 0, 150)
CodeBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CodeBox.Text = "-- โค้ดพิกัดแมพจะแสดงตรงนี้หลังจากกดดั้ม --"
CodeBox.TextColor3 = Color3.fromRGB(0, 255, 0)
CodeBox.TextSize = 12
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.ClearTextOnFocus = false
CodeBox.MultiLine = true

-- ปุ่มกดคัดลอกโค้ด
CopyBtn.Parent = MainFrame
CopyBtn.Position = UDim2.new(0.05, 0, 0.83, 0)
CopyBtn.Size = UDim2.new(0, 315, 0, 40)
CopyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
CopyBtn.Text = "คัดลอกโค้ดทั้งหมด (Copy To Clipboard)"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.TextSize = 14

-- ระบบ เปิด/ปิด หน้าต่างหลัก
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ระบบทำฟังก์ชันดั้มข้อมูล
DumpBtn.MouseButton1Click:Connect(function()
    DumpBtn.Text = "กำลังดั้มข้อมูล... กรุณารอ"
    DumpBtn.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
    task.wait(0.2)
    
    local folderToDump = workspace
    local fileName = "Full_Map_Dump.txt"
    local dumpText = "-- ROBLOX MAP DATA DUMP --\nlocal MapData = {\n"

    for _, obj in pairs(folderToDump:GetDescendants()) do
        if obj:IsA("BasePart") then
            local pos = obj.Position
            dumpText = dumpText .. string.format('    ["%s"] = {Pos = Vector3.new(%.2f, %.2f, %.2f), Class = "%s"},\n', obj.Name, pos.X, pos.Y, pos.Z, obj.ClassName)
        elseif obj:IsA("Model") and obj.PrimaryPart then
            local pos = obj.PrimaryPart.Position
            dumpText = dumpText .. string.format('    ["%s"] = {Pos = Vector3.new(%.2f, %.2f, %.2f), Class = "Model"},\n', obj.Name, pos.X, pos.Y, pos.Z)
        end
    end
    dumpText = dumpText .. "}\nreturn MapData"

    -- บันทึกไฟล์ลงในโฟลเดอร์ Delta workspace ตามเดิม
    if writefile then
        writefile(fileName, dumpText)
    end
    
    -- แสดงผลบนหน้าจอให้เห็นและก๊อปปี้ได้ทันที
    CodeBox.Text = dumpText
    DumpBtn.Text = "ดั้มข้อมูลเสร็จสิ้น! (บันทึกไฟล์แล้ว)"
    DumpBtn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
end)

-- ระบบปุ่มคัดลอกข้อความอัตโนมัติ
CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(CodeBox.Text)
        CopyBtn.Text = "คัดลอกสำเร็จแล้ว!"
        CopyBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
        task.wait(2)
        CopyBtn.Text = "คัดลอกโค้ดทั้งหมด (Copy To Clipboard)"
        CopyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    else
        CopyBtn.Text = "Executor ไม่รองรับฟังก์ชันก๊อปปี้อัตโนมัติ"
    end
end)
