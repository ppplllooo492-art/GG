-- [[ DELTA LIGHTWEIGHT SCRIPT ASSISTANT v2.5 ]] --
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("DeltaScriptAssistant") then
    CoreGui.DeltaScriptAssistant:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaScriptAssistant"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 300)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "  📱 DELTA MAP ASSISTANT [READY]"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

local ChatLog = Instance.new("ScrollingFrame")
ChatLog.Size = UDim2.new(0.94, 0, 0.68, 0)
ChatLog.Position = UDim2.new(0.03, 0, 0.14, 0)
ChatLog.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
ChatLog.BorderSizePixel = 0
ChatLog.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatLog.ScrollBarThickness = 4
ChatLog.Parent = MainFrame

local ChatLayout = Instance.new("UIListLayout")
ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
ChatLayout.Padding = UDim.new(0, 5)
ChatLayout.Parent = ChatLog

local function pushMessage(sender, text)
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -10, 0, 0)
    msg.BackgroundTransparency = 1
    msg.Font = Enum.Font.SourceSans
    msg.TextSize = 14
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Left
    
    if sender == "You" then
        msg.TextColor3 = Color3.fromRGB(0, 200, 255)
        msg.Text = "> " .. text
    else
        msg.TextColor3 = Color3.fromRGB(200, 255, 200)
        msg.Text = "[AI]: " .. text
    end
    
    msg.Parent = ChatLog
    msg.Size = UDim2.new(1, -10, 0, msg.TextBounds.Y + 5)
    ChatLog.CanvasSize = UDim2.new(0, 0, 0, ChatLayout.AbsoluteContentSize.Y + 10)
    ChatLog.CanvasPosition = Vector2.new(0, ChatLog.CanvasSize.Y.Offset)
end

local function processBrain(input)
    local q = string.lower(input)
    
    if string.find(q, "สแกน") or string.find(q, "scan") then
        local p, m, r = 0, 0, 0
        for _, o in pairs(game:GetDescendants()) do
            pcall(function()
                if o:IsA("Part") and o.Parent == Workspace then p = p + 1 end
                if o:IsA("Model") then m = m + 1 end
                if o:IsA("RemoteEvent") then r = r + 1 end
            end)
        end
        return string.format("📊 รายงานแมพ:\n- Part ใน Workspace: %d ชิ้น\n- Model ทั้งหมด: %d ตัว\n- RemoteEvent ในเกม: %d ตัว", p, m, r)
        
    elseif string.find(q, "หา") or string.find(q, "find") then
        local target = string.match(input, "หา%s*(%S+)") or string.match(input, "find%s*(%S+)")
        if not target then return "❌ กรุณาระบุชื่อวัตถุ เช่น 'หา Coin'" end
        
        local found = Workspace:FindFirstChild(target, true)
        if found then
            return string.format("✅ เจอตำแหน่ง! วัตถุชื่อ '%s' อยู่ในโครงสร้าง: game.%s", target, string.sub(found:GetFullName(), 7))
        else
            return string.format("❌ ไม่พบวัตถุชื่อ '%s' ใน Workspace ลองเช็คตัวพิมพ์เล็ก-ใหญ่ดูครับ", target)
        end
        
    elseif string.find(q, "รีโมท") or string.find(q, "remote") then
        local list = "📡 รายชื่อ RemoteEvent เด่นๆ:\n"
        local c = 0
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                c = c + 1
                list = list .. "- " .. v.Name .. "\n"
                if c >= 8 then break end
            end
        end
        return list
        
    else
        return "💡 สั่งงานพิมพ์:\n- 'สแกน' เพื่อตรวจสอบนับจำนวนวัตถุรวม\n- 'หา [ชื่อของ]' เพื่อหาพิกัดที่อยู่ของสิ่งนั้น\n- 'รีโมท' เพื่อดึงชื่อ Remote สำหรับส่งค่า"
    end
end

local InputField = Instance.new("TextBox")
InputField.Size = UDim2.new(0.7, 0, 0.12, 0)
InputField.Position = UDim2.new(0.03, 0, 0.84, 0)
InputField.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
InputField.Font = Enum.Font.SourceSans
InputField.PlaceholderText = " พิมพ์คำสั่ง: สแกน / หา [ชื่อ] / รีโมท"
InputField.Text = ""
InputField.TextColor3 = Color3.fromRGB(255, 255, 255)
InputField.TextSize = 14
InputField.TextXAlignment = Enum.TextXAlignment.Left
InputField.Parent = MainFrame
Instance.new("UICorner", InputField).CornerRadius = UDim.new(0, 5)

local SendButton = Instance.new("TextButton")
SendButton.Size = UDim2.new(0.22, 0, 0.12, 0)
SendButton.Position = UDim2.new(0.75, 0, 0.84, 0)
SendButton.BackgroundColor3 = Color3.fromRGB(0, 130, 200)
SendButton.Font = Enum.Font.SourceSansBold
SendButton.Text = "ส่ง"
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.TextSize = 14
SendButton.Parent = MainFrame
Instance.new("UICorner", SendButton).CornerRadius = UDim.new(0, 5)

local function runCommand()
    local text = InputField.Text
    if text == "" then return end
    pushMessage("You", text)
    InputField.Text = ""
    task.spawn(function()
        local reply = processBrain(text)
        pushMessage("AI", reply)
    end)
end

SendButton.MouseButton1Click:Connect(runCommand)
InputField.FocusLost:Connect(function(enter) if enter then runCommand() end end)

pushMessage("AI", "สคริปต์ขนาดเล็ก (Lightweight) พร้อมทำงานบน Delta แล้วครับ! สแกนและอ่านค่าแมพได้ทันทีโดยโค้ดไม่ขาดหายแน่นอน")
