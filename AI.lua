-- [[ ULTIMATE GOD-MODE MAP EXPLOITER & CHAT ASSISTANT v3.1 ]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("GodModeAssistant") then
    CoreGui.GodModeAssistant:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GodModeAssistant"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 340)
MainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(255, 0, 100)
MainStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "  💀 GOD-MODE MAP EXPLOITER [ONLINE]"
Title.TextColor3 = Color3.fromRGB(255, 0, 100)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

local ChatLog = Instance.new("ScrollingFrame")
ChatLog.Size = UDim2.new(0.94, 0, 0.65, 0)
ChatLog.Position = UDim2.new(0.03, 0, 0.14, 0)
ChatLog.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
ChatLog.BorderSizePixel = 0
ChatLog.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatLog.ScrollBarThickness = 4
ChatLog.Parent = MainFrame

local ChatLayout = Instance.new("UIListLayout")
ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
ChatLayout.Padding = UDim.new(0, 6)
ChatLayout.Parent = ChatLog

local function pushMessage(sender, text)
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -10, 0, 0)
    msg.BackgroundTransparency = 1
    msg.Font = Enum.Font.Code
    msg.TextSize = 13
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Left

    if sender == "You" then
        msg.TextColor3 = Color3.fromRGB(0, 200, 255)
        msg.Text = "👤 [YOU]: " .. text
    elseif sender == "System" then
        msg.TextColor3 = Color3.fromRGB(255, 255, 100)
        msg.Text = "⚙️ [SYSTEM]: " .. text
    else
        msg.TextColor3 = Color3.fromRGB(0, 255, 150)
        msg.Text = "🤖 [AI]: " .. text
    end

    msg.Parent = ChatLog
    msg.Size = UDim2.new(1, -10, 0, msg.TextBounds.Y + 5)
    ChatLog.CanvasSize = UDim2.new(0, 0, 0, ChatLayout.AbsoluteContentSize.Y + 10)
    ChatLog.CanvasPosition = Vector2.new(0, ChatLog.CanvasSize.Y.Offset)
end

local function executeGodEngine(input)
    local q = string.lower(input)

    if string.find(q, "หวัดดี") or string.find(q, "สวัสดี") or string.find(q, "hello") then
        return "สวัสดีครับเจ้านาย! ระบบทำลายข้อจำกัดแมพเปิดใช้งานแล้ว อยากให้ผมเจาะรหัส ค้นหาพิกัด หรือสั่งวาร์ป สั่งมาได้เลยครับ!"

    elseif string.find(q, "สแกน") or string.find(q, "scan") or string.find(q, "วิเคราะห์") then
        local p, m, r, rf, f = 0, 0, 0, 0, 0
        local hiddenItems = {}

        for _, o in pairs(game:GetDescendants()) do
            pcall(function()
                if o:IsA("Part") and o.Parent == Workspace then
                    p = p + 1
                end

                if o:IsA("Model") then
                    m = m + 1
                end

                if o:IsA("RemoteEvent") then
                    r = r + 1
                end

                if o:IsA("RemoteFunction") then
                    rf = rf + 1
                end

                if o:IsA("Folder") then
                    f = f + 1
                end

                local name = string.lower(o.Name)

                if string.find(name, "coin")
                    or string.find(name, "chest")
                    or string.find(name, "gem")
                    or string.find(name, "key")
                    or string.find(name, "egg") then

                    hiddenItems[o.Name] = (hiddenItems[o.Name] or 0) + 1
                end
            end)
        end

        local rep = string.format(
            "💀 [รายงานเจาะระบบแมพขั้นสูง]\n• พาร์ทพื้นผิว: %d | โมเดลรวม: %d\n• โฟลเดอร์ข้อมูล: %d\n• ช่องทางรีโมท (RemoteEvent): %d\n• ช่องทางฟังก์ชัน (RemoteFunction): %d",
            p, m, f, r, rf
        )

        local itemRep = ""

        for k, v in pairs(hiddenItems) do
            itemRep = itemRep .. string.format(
                "\n- ตรวจพบวัตถุมีค่า: '%s' (จำนวน %d ชิ้น)",
                k,
                v
            )
        end

        if itemRep ~= "" then
            rep = rep .. "\n\n🎯 [เป้าหมายที่น่าโจมตี/ฟาร์ม]:" .. itemRep
        end

        return rep

    elseif string.find(q, "tp") or string.find(q, "วาร์ป") then
        local tName =
            string.match(input, "วาร์ป%s*(%S+)")
            or string.match(input, "tp%s*(%S+)")

        if not tName then
            return "❌ รูปแบบผิด! สั่งแบบนี้ครับ: 'tp [ชื่อวัตถุ]' เช่น 'tp Coin'"
        end

        local found = nil

        for _, o in pairs(Workspace:GetDescendants()) do
            if string.lower(o.Name) == string.lower(tName)
                and (o:IsA("BasePart") or o:IsA("Model")) then
                found = o
                break
            end
        end

        if found then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")

                if root then
                    if found:IsA("Model") then
                        root.CFrame = found:GetPivot()
                    else
                        root.CFrame = found.CFrame
                    end
                end
            end)

            return string.format(
                "🌌 สั่งการสำเร็จ! ทำการวาร์ปตัวละครของคุณไปที่พิกัดวัตถุ '%s' เรียบร้อยแล้ว (Path: game.%s)",
                tName,
                string.sub(found:GetFullName(), 7)
            )
        else
            return string.format(
                "❌ 不พบวัตถุชื่อ '%s' ในโครงสร้างแมพ ลองเช็คชื่ออีกครั้ง",
                tName
            )
        end

    elseif string.find(q, "รีโมท") or string.find(q, "remote") then
        local list = "📡 [รายชื่อช่องส่งข้อมูล RemoteEvent ทั้งหมดในคลังเกม]:\n"
        local c = 0

        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                c = c + 1

                list = list .. string.format(
                    "%d. %s (Parent: %s)\n",
                    c,
                    v.Name,
                    v.Parent.Name
                )

                if c >= 15 then
                    break
                end
            end
        end

        return list

    elseif string.find(q, "คุ้ย") or string.find(q, "dump") then
        local pName =
            string.match(input, "คุ้ย%s*(%S+)")
            or string.match(input, "dump%s*(%S+)")

        if not pName then
            return "❌ รูปแบบผิด! สั่งแบบนี้: 'คุ้ย [ชื่อโฟลเดอร์หรือวัตถุ]'"
        end

        local parentObj = game:FindFirstChild(pName, true)

        if not parentObj then
            return "❌ ไม่พบวัตถุหรือโฟลเดอร์ชื่อนี้ในเกม"
        end

        local childList = string.format(
            "📂 [โครงสร้างภายในของ %s]:\n",
            parentObj.Name
        )

        local count = 0

        for _, child in pairs(parentObj:GetChildren()) do
            count = count + 1

            childList = childList .. string.format(
                "- %s [%s]\n",
                child.Name,
                child.ClassName
            )

            if count >= 20 then
                break
            end
        end

        return childList

    elseif string.find(q, "ความเร็ว") or string.find(q, "speed") then
        local num = string.match(q, "%d+")

        if not num then
            return "❌ กรุณาระบุตัวเลขความเร็วด้วยครับ เช่น 'speed 100'"
        end

        pcall(function()
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = tonumber(num)
        end)

        return "⚡ ปรับความเร็วการวิ่งของตัวละครเป็น: " .. num .. " เรียบร้อย!"

    elseif string.find(q, "กระโดด") or string.find(q, "jump") then
        local num = string.match(q, "%d+")

        if not num then
            return "❌ กรุณาระบุตัวเลขพลังโดดด้วยครับ เช่น 'jump 100'"
        end

        pcall(function()
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = tonumber(num)
        end)

        return "🦘 ปรับพลังการกระโดดเป็น: " .. num .. " เรียบร้อย!"

    else
        return "🔥 [ระบบคำสั่งโกงระดับเทพที่คุณใช้สั่งงานได้ทันที]:\n"
            .. "• พิมพ์ 'สแกน' -> ค้นหาวัตถุมีค่า กล่อง เงิน ไอเทมดรอป และ Remote ทั้งเกม\n"
            .. "• พิมพ์ 'tp [ชื่อวัตถุ]' -> วาร์ปตัวละครไปหาวัตถุนั้นจริงในเกมทันทีกลางอากาศ!\n"
            .. "• พิมพ์ 'รีโมท' -> ถอดรหัสเจาะดึงรายชื่อช่องยิง RemoteEvent ทั้งหมดในเกม\n"
            .. "• พิมพ์ 'คุ้ย [ชื่อวัตถุ]' -> แอบส่องดูโครงสร้างและของที่อยู่ข้างในวัตถุนั้น\n"
            .. "• พิมพ์ 'speed [ตัวเลข]' -> ปรับความเร็ววิ่งโกงตามใจชอบ (เช่น speed 100)\n"
            .. "• พิมพ์ 'jump [ตัวเลข]' -> ปรับแรงกระโดดสูงทะลุฟ้า (เช่น jump 120)"
    end
end

local InputField = Instance.new("TextBox")
InputField.Size = UDim2.new(0, 260, 0, 35)
InputField.Position = UDim2.new(0.03, 0, 0.85, 0)
InputField.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
InputField.Font = Enum.Font.SourceSans
InputField.PlaceholderText = " พิมพ์คำสั่งโกง หรือ คุยสอบถามค่าแมพ..."
InputField.Text = ""
InputField.TextColor3 = Color3.fromRGB(255, 255, 255)
InputField.TextSize = 14
InputField.TextXAlignment = Enum.TextXAlignment.Left
InputField.Parent = MainFrame

Instance.new("UICorner", InputField).CornerRadius = UDim.new(0, 5)

local SendButton = Instance.new("TextButton")
SendButton.Size = UDim2.new(0, 70, 0, 35)
SendButton.Position = UDim2.new(0.77, 0, 0.85, 0)
SendButton.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
SendButton.Font = Enum.Font.SourceSansBold
SendButton.Text = "สั่งการ"
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.TextSize = 14
SendButton.Parent = MainFrame

Instance.new("UICorner", SendButton).CornerRadius = UDim.new(0, 5)

local function runCommand()
    local text = InputField.Text

    if text == "" then
        return
    end

    pushMessage("You", text)
    InputField.Text = ""

    task.spawn(function()
        local reply = executeGodEngine(text)
        pushMessage("AI", reply)
    end)
end

SendButton.MouseButton1Click:Connect(runCommand)

InputField.FocusLost:Connect(function(enter)
    if enter then
        runCommand()
    end
end)

pushMessage(
    "System",
    "ULTRA GOD-MODE SCRIPT ASSISTANT บู๊ตระบบเข้าสู่แกนเกมสำเร็จ!"
)

pushMessage(
    "AI",
    "รอบนี้ส่งข้อความดิบให้โดยตรง ไม่มีตัวครอบกล่องคัดลอกมาขวางทางแล้วครับเจ้านาย ลองคัดลอกไปเทสปุ่มสั่งการวาร์ปหรือสแกนใน Delta ได้เลยครับ!"
)
