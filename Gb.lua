--========================================================--
-- Delta Remote Spy & Map Dumper
--========================================================--

-- โหลด Orion Library
local OrionLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/shlexware/Orion/main/source"
))()

if not OrionLib then
    warn("ไม่สามารถโหลด Orion Library ได้")
    return
end

--========================================================--
-- WINDOW
--========================================================--

local Window = OrionLib:MakeWindow({
    Name = "Delta Remote Spy & Map Dumper",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "Delta Advanced Spy"
})

local SpyTab = Window:MakeTab({
    Name = "ดักจับ Remote",
    Icon = "rbxassetid://4483345998"
})

local DumpTab = Window:MakeTab({
    Name = "สแกนข้อมูลแมพ",
    Icon = "rbxassetid://4483345998"
})

--========================================================--
-- VARIABLES
--========================================================--

local spyEnabled = false
local lastGeneratedCode = ""
local dumpType = "Workspace"

--========================================================--
-- UTILITY
--========================================================--

-- แปลง Instance เป็น path ที่ใช้ใน Lua ได้จริง
local function instanceToPath(instance)
    if not instance or not instance:IsA("Instance") then
        return "nil"
    end

    local parts = {}
    local current = instance

    while current and current ~= game do
        table.insert(parts, 1, current.Name)
        current = current.Parent
    end

    local result = "game"

    for _, name in ipairs(parts) do
        -- ใช้ .Name ได้เฉพาะชื่อที่เป็น Lua identifier
        if name:match("^[%a_][%w_]*$") then
            result = result .. "." .. name
        else
            result = result .. "[\"" ..
                name:gsub("\\", "\\\\"):gsub("\"", "\\\"") ..
                "\"]"
        end
    end

    return result
end

-- แปลงค่าเป็นข้อความ Lua
local function serializeValue(value, depth, visited)
    depth = depth or 0
    visited = visited or {}

    if depth > 3 then
        return "{...}"
    end

    local valueType = typeof(value)

    if valueType == "string" then
        return string.format("%q", value)

    elseif valueType == "number" then
        return tostring(value)

    elseif valueType == "boolean" then
        return tostring(value)

    elseif valueType == "nil" then
        return "nil"

    elseif valueType == "Instance" then
        return instanceToPath(value)

    elseif valueType == "Vector3" then
        return string.format(
            "Vector3.new(%s, %s, %s)",
            tostring(value.X),
            tostring(value.Y),
            tostring(value.Z)
        )

    elseif valueType == "Vector2" then
        return string.format(
            "Vector2.new(%s, %s)",
            tostring(value.X),
            tostring(value.Y)
        )

    elseif valueType == "CFrame" then
        local components = {value:GetComponents()}
        local output = {}

        for i, component in ipairs(components) do
            output[i] = tostring(component)
        end

        return "CFrame.new(" .. table.concat(output, ", ") .. ")"

    elseif valueType == "Color3" then
        return string.format(
            "Color3.fromRGB(%d, %d, %d)",
            math.floor(value.R * 255 + 0.5),
            math.floor(value.G * 255 + 0.5),
            math.floor(value.B * 255 + 0.5)
        )

    elseif valueType == "table" then
        if visited[value] then
            return "{...}"
        end

        visited[value] = true

        local result = {"{"}
        local count = 0

        for key, val in pairs(value) do
            count = count + 1

            if count > 20 then
                table.insert(result, "-- more...")
                break
            end

            local keyString

            if type(key) == "string" and key:match("^[%a_][%w_]*$") then
                keyString = key
            else
                keyString = "[" .. serializeValue(key, depth + 1, visited) .. "]"
            end

            table.insert(
                result,
                keyString .. " = " ..
                serializeValue(val, depth + 1, visited) .. ","
            )
        end

        table.insert(result, "}")

        visited[value] = nil

        return table.concat(result, "\n")

    else
        return string.format("%q", tostring(value))
    end
end

local function formatArgs(args)
    local result = {}

    for i, value in ipairs(args) do
        result[i] = serializeValue(value)
    end

    return table.concat(result, ", ")
end

--========================================================--
-- REMOTE SPY UI
--========================================================--

SpyTab:AddToggle({
    Name = "เปิดระบบดักจับ Remote",
    Default = false,

    Callback = function(Value)
        spyEnabled = Value

        if Value then
            LogLabel:Set("กำลังรอ Remote...")
        else
            LogLabel:Set("ปิดระบบดักจับ Remote")
        end
    end
})

local LogLabel = SpyTab:AddLabel(
    "ยังไม่มี Remote ส่งข้อมูลไป Server..."
)

SpyTab:AddButton({
    Name = "คัดลอกโค้ด Remote ล่าสุด",
    
    Callback = function()
        if lastGeneratedCode ~= "" then

            if setclipboard then
                setclipboard(lastGeneratedCode)

                OrionLib:MakeNotification({
                    Name = "Success",
                    Content = "คัดลอกโค้ดลงคลิปบอร์ดแล้ว!",
                    Time = 2
                })
            else
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "Executor นี้ไม่รองรับ setclipboard",
                    Time = 3
                })
            end

        else
            OrionLib:MakeNotification({
                Name = "Warning",
                Content = "ยังไม่มี Remote ให้คัดลอก",
                Time = 2
            })
        end
    end
})

--========================================================--
-- REMOTE SPY HOOK
--========================================================--

local hookInstalled = false

pcall(function()

    if not hookmetamethod then
        warn("Executor นี้ไม่รองรับ hookmetamethod")
        return
    end

    if hookInstalled then
        return
    end

    hookInstalled = true

    local oldNamecall

    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)

        local method = getnamecallmethod()

        if spyEnabled
            and typeof(self) == "Instance"
            and (method == "FireServer" or method == "InvokeServer")
        then

            local args = {...}

            local success, result = pcall(function()

                local remotePath = instanceToPath(self)
                local formattedArgs = formatArgs(args)

                lastGeneratedCode = string.format(
                    "%s:%s(%s)",
                    remotePath,
                    method,
                    formattedArgs
                )

                LogLabel:Set(
                    "พบ Remote: " .. self:GetFullName()
                )

            end)

            if not success then
                warn("Remote Spy Error:", result)
            end
        end

        return oldNamecall(self, ...)
    end))

end)

--========================================================--
-- MAP DUMPER UI
--========================================================--

DumpTab:AddDropdown({
    Name = "เลือกส่วนที่ต้องการสแกน",
    Default = "Workspace",

    Options = {
        "Workspace",
        "ReplicatedStorage",
        "Players"
    },

    Callback = function(Value)
        dumpType = Value
    end
})

DumpTab:AddButton({
    Name = "เริ่มสแกนและคัดลอกข้อมูลทั้งหมด",

    Callback = function()

        local success, target = pcall(function()
            return game:GetService(dumpType)
        end)

        if not success or not target then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "ไม่พบ Service: " .. tostring(dumpType),
                Time = 3
            })

            return
        end

        local lines = {}

        table.insert(
            lines,
            "--==================================================--"
        )

        table.insert(
            lines,
            "-- MAP DUMP DATA FOR " .. string.upper(dumpType)
        )

        table.insert(
            lines,
            "--==================================================--"
        )

        table.insert(lines, "")

        local descendants = target:GetDescendants()

        for index, obj in ipairs(descendants) do

            local ok, err = pcall(function()

                table.insert(
                    lines,
                    string.format(
                        "[%d] Class: [%s] -> Path: %s",
                        index,
                        obj.ClassName,
                        instanceToPath(obj)
                    )
                )

            end)

            if not ok then
                warn("Dump Error:", err)
            end
        end

        local dumpText = table.concat(lines, "\n")

        if setclipboard then

            setclipboard(dumpText)

            OrionLib:MakeNotification({
                Name = "Dump Complete!",
                Content = "สแกน " .. tostring(#descendants) ..
                    " Objects และคัดลอกลง Clipboard แล้ว",
                Time = 4
            })

        else

            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Executor นี้ไม่รองรับ setclipboard",
                Time = 3
            })

        end
    end
})

--========================================================--
-- SPEED HACK
--========================================================--

local speedEnabled = false
local currentSpeed = 16

DumpTab:AddToggle({
    Name = "เปิดใช้งาน Speed",
    Default = false,

    Callback = function(Value)
        speedEnabled = Value

        pcall(function()

            local character = game.Players.LocalPlayer.Character
            local humanoid = character and
                character:FindFirstChildOfClass("Humanoid")

            if humanoid then

                if Value then
                    humanoid.WalkSpeed = currentSpeed
                else
                    humanoid.WalkSpeed = 16
                end

            end
        end)
    end
})

DumpTab:AddSlider({
    Name = "ปรับความเร็วเดิน",

    Min = 16,
    Max = 500,
    Default = 16,

    Color = Color3.fromRGB(
        255,
        255,
        255
    ),

    Increment = 1,
    ValueName = "Speed",

    Callback = function(Value)

        currentSpeed = Value

        if speedEnabled then

            pcall(function()

                local character =
                    game.Players.LocalPlayer.Character

                local humanoid =
                    character and
                    character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid.WalkSpeed = Value
                end

            end)

        end
    end
})

--========================================================--
-- CHARACTER RESPAWN HANDLER
--========================================================--

local player = game.Players.LocalPlayer

if player then

    player.CharacterAdded:Connect(function(character)

        if not speedEnabled then
            return
        end

        local humanoid =
            character:WaitForChild("Humanoid", 10)

        if humanoid then
            task.wait(0.2)
            humanoid.WalkSpeed = currentSpeed
        end

    end)

end

--========================================================--
-- INIT
--========================================================--

OrionLib:Init()
