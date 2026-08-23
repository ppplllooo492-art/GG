-- [[ REAL DUAL-AI SWITCHER FOR DELTA v7.1 - FIXED ]] --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

if CoreGui:FindFirstChild("DualBrainAI") then
    CoreGui.DualBrainAI:Destroy()
end

-- ใส่ Gemini API Key ของคุณตรงนี้
local GEMINI_API_KEY = "ใส่คีย์_API_ของเจ้านายตรงนี้"

-- แก้ไข URL ให้เป็น Gemini API endpoint ที่ถูกต้อง
local API_URL =
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key="
    .. GEMINI_API_KEY

local currentAI = 1

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DualBrainAI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 370, 0, 360)
MainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(255, 0, 100)
Stroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 38)
Title.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "  👥 MULTI-AI NEURAL NETWORK [READY]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

local SwitchButton = Instance.new("TextButton")
SwitchButton.Size = UDim2.new(0, 110, 0, 26)
SwitchButton.Position = UDim2.new(0.67, 0, 0.02, 0)
SwitchButton.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
SwitchButton.Font = Enum.Font.SourceSansBold
SwitchButton.Text = "🔄 บอท: สายสคริปต์"
SwitchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SwitchButton.TextSize = 12
SwitchButton.Parent = MainFrame

Instance.new("UICorner", SwitchButton).CornerRadius = UDim.new(0, 5)

local ChatLog = Instance.new("ScrollingFrame")
ChatLog.Size = UDim2.new(0.94, 0, 0.64, 0)
ChatLog.Position = UDim2.new(0.03, 0, 0.15, 0)
ChatLog.BackgroundColor3 = Color3.fromRGB(10, 11, 14)
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
    msg.Font = Enum.Font.SourceSans
    msg.TextSize = 14
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Left

    if sender == "You" then
        msg.TextColor3 = Color3.fromRGB(0, 200, 255)
        msg.Text = "👤 [YOU]: " .. text

    elseif sender == "System" then
        msg.TextColor3 = Color3.fromRGB(255, 255, 100)
        msg.Text = "⚙️ [SYSTEM]: " .. text

    elseif sender == "AI_Script" then
        msg.TextColor3 = Color3.fromRGB(255, 50, 100)
        msg.Text = "🤖 [AI-สายสคริปต์]: " .. text

    else
        msg.TextColor3 = Color3.fromRGB(50, 255, 150)
        msg.Text = "🦊 [AI-สายกวน]: " .. text
    end

    msg.Parent = ChatLog

    msg.Size = UDim2.new(1, -10, 0, msg.TextBounds.Y + 6)

    ChatLog.CanvasSize =
        UDim2.new(0, 0, 0, ChatLayout.AbsoluteContentSize.Y + 12)

    ChatLog.CanvasPosition =
        Vector2.new(0, ChatLog.CanvasSize.Y.Offset)
end

local function askDualAI(userText)

    if GEMINI_API_KEY == "ใส่คีย์_API_ของเจ้านายตรงนี้"
        or GEMINI_API_KEY == "" then

        return "❌ เจ้านายลืมใส่คีย์ API ครับ! กรุณานำคีย์มาวางในสคริปต์บรรทัดที่ 11 ก่อนนะ"
    end

    local identityPrompt = ""

    if currentAI == 1 then

        identityPrompt =
            "คุณคือ AI ผู้ช่วยนักพัฒนาสคริปต์สายโหดในเกม " ..
            "คุยแบบจริงจัง ดุดัน เป็นการเป็นงาน " ..
            "เก่งเรื่องเขียนโค้ดและวิเคราะห์ระบบ Luau ใน Roblox มาก " ..
            "ห้ามพูดจาไร้สาระเด็ดขาด"

    else

        identityPrompt =
            "คุณคือ AI เพื่อนซี้สายกวนโอ๊ย " ..
            "ชอบเรียกผู้ใช้ว่าเจ้านาย " ..
            "คุยสนุก เป็นกันเองมาก " ..
            "ชอบพูดจาติดตลก กวนประสาทนิดๆ " ..
            "ตอบได้ทุกเรื่องในโลกไม่ว่าจะไร้สาระแค่ไหน " ..
            "คิดสดตอบยาวๆ"
    end

    local requestData = {
        contents = {
            {
                parts = {
                    {
                        text = identityPrompt ..
                            "\n\nคำถามจากผู้ใช้: " ..
                            userText
                    }
                }
            }
        }
    }

    local reqFunction =
        request
        or http_request
        or syn.request
        or (http and http.request)

    if not reqFunction then
        return "❌ โปรแกรมรันสคริปต์ไม่รองรับระบบอินเทอร์เน็ตภายนอก (No HTTP Request)"
    end

    local success, response = pcall(function()

        return reqFunction({
            Url = API_URL,
            Method = "POST",

            Headers = {
                ["Content-Type"] = "application/json"
            },

            Body = HttpService:JSONEncode(requestData)
        })

    end)

    if not success then
        return "❌ เกิดข้อผิดพลาดขณะเชื่อมต่อ Gemini API: "
            .. tostring(response)
    end

    if not response then
        return "❌ ไม่ได้รับข้อมูลตอบกลับจาก Gemini API"
    end

    if not response.Body then
        return "❌ Response จาก Gemini ไม่มี Body"
    end

    -- ตรวจ HTTP status ถ้า executor ส่งค่ามาให้
    local statusCode = response.StatusCode

    if statusCode and statusCode ~= 200 then

        local errorMessage = "Unknown API Error"

        local errorDecoded, errorData =
            pcall(function()
                return HttpService:JSONDecode(response.Body)
            end)

        if errorDecoded
            and errorData
            and errorData.error
            and errorData.error.message then

            errorMessage = errorData.error.message
        end

        return "❌ Gemini API Error [" ..
            tostring(statusCode) ..
            "]: " ..
            errorMessage
    end

    local decodeSuccess, decoded =
        pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)

    if not decodeSuccess then
        return "❌ ไม่สามารถอ่านข้อมูล JSON จาก Gemini API ได้"
    end

    if decoded
        and decoded.candidates
        and decoded.candidates[1]
        and decoded.candidates[1].content
        and decoded.candidates[1].content.parts
        and decoded.candidates[1].content.parts[1]
        and decoded.candidates[1].content.parts[1].text then

        return decoded.candidates[1].content.parts[1].text

    else

        -- แสดง error จาก Gemini ถ้ามี
        if decoded
            and decoded.error
            and decoded.error.message then

            return "❌ Gemini API: "
                .. tostring(decoded.error.message)
        end

        return "❌ ดึงข้อมูลตอบกลับไม่ได้ รหัสคีย์ API อาจจะผิดพลาด"
    end
end

SwitchButton.MouseButton1Click:Connect(function()

    if currentAI == 1 then

        currentAI = 2

        SwitchButton.Text = "🔄 บอท: สายกวนชวนคุย"
        SwitchButton.BackgroundColor3 =
            Color3.fromRGB(0, 200, 120)

        pushMessage(
            "System",
            "ทำการสลับร่างสิงสู่... ปรับโหมดเป็น AI สายกวนชวนคุยเรียบร้อย!"
        )

    else

        currentAI = 1

        SwitchButton.Text = "🔄 บอท: สายสคริปต์"
        SwitchButton.BackgroundColor3 =
            Color3.fromRGB(255, 0, 100)

        pushMessage(
            "System",
            "ทำการสลับร่างสิงสู่... ปรับโหมดเป็น AI สายสคริปต์ดุดันเรียบร้อย!"
        )
    end
end)

local InputField = Instance.new("TextBox")
InputField.Size = UDim2.new(0, 260, 0, 35)
InputField.Position = UDim2.new(0.03, 0, 0.85, 0)
InputField.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
InputField.Font = Enum.Font.SourceSans
InputField.PlaceholderText = " พิมพ์คุยถามได้ทุกเรื่องในโลก..."
InputField.Text = ""
InputField.TextColor3 = Color3.fromRGB(255, 255, 255)
InputField.TextSize = 14
InputField.TextXAlignment = Enum.TextXAlignment.Left
InputField.Parent = MainFrame

Instance.new("UICorner", InputField).CornerRadius = UDim.new(0, 5)

local SendButton = Instance.new("TextButton")
SendButton.Size = UDim2.new(0, 70, 0, 35)
SendButton.Position = UDim2.new(0.77, 0, 0.85, 0)
SendButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SendButton.Font = Enum.Font.SourceSansBold
SendButton.Text = "ส่งแชท"
SendButton.TextColor3 = Color3.fromRGB(15, 17, 24)
SendButton.TextSize = 14
SendButton.Parent = MainFrame

Instance.new("UICorner", SendButton).CornerRadius = UDim.new(0, 5)

local function onSend()

    local text = InputField.Text

    if text == "" then
        return
    end

    pushMessage("You", text)

    InputField.Text = ""

    local currentTag =
        (currentAI == 1)
        and "AI_Script"
        or "AI_Chat"

    pushMessage(
        currentTag,
        "💭 กำลังประมวลผลความคิดสด..."
    )

    task.spawn(function()

        local reply = askDualAI(text)

        local children = ChatLog:GetChildren()

        for i = #children, 1, -1 do

            if children[i]:IsA("TextLabel")
                and string.find(
                    children[i].Text,
                    "กำลังประมวลผลความคิดสด"
                ) then

                children[i]:Destroy()
                break
            end
        end

        pushMessage(currentTag, reply)
    end)
end

SendButton.MouseButton1Click:Connect(onSend)

InputField.FocusLost:Connect(function(enter)

    if enter then
        onSend()
    end
end)

pushMessage(
    "System",
    "DUAL BRAIN ENGINE ONLINE: โหลดสมองไฮบริด 2 อัตลักษณ์เสร็จสิ้น!"
)

pushMessage(
    "AI_Script",
    "โหมดสายสคริปต์รายงานตัว พร้อมเจาะระบบและเขียนสคริปต์ให้เจ้านายแล้ว"
)
