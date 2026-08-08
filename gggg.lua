-- [[ OVERPOWERED ALL-IN-ONE SYSTEM FOR DELTA EXECUTOR ]] --
getgenv().UltimateSystem = true
getgenv().CircleRadius = 15     -- ความกว้างของวงกลมในการเดิน (สตั๊ด)
getgenv().CircleSpeed = 4      -- ความเร็วในการหมุนเดินวงกลม (ยิ่งมากยิ่งหมุนเร็ว)
getgenv().RebirthCooldown = 0.1 -- ความเร็วในการส่งคำสั่ง Rebirth (วินาที)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ตัวแปรสำหรับระบบเดินเป็นวงกลม
local centerPosition = nil
local angle = 0

-- [ ระบบที่ 1 ]: ฟังก์ชันรวมดึงไอเทมทั้งหมด (Hoops & City Orbs) ยัดเข้าตัวตรงๆ
local function instantWarpAllTargets(playerRoot)
    local targets = {
        workspace:FindFirstChild("Hoops"),
        workspace:FindFirstChild("orbFolder") and workspace.orbFolder:FindFirstChild("City")
    }

    for _, folder in ipairs(targets) do
        if folder then
            local items = folder:GetChildren()
            -- ใช้ Reverse Loop ความเร็วสูงเพื่อดักไอเทมเกิดใหม่ทันที
            for i = #items, 1, -1 do
                if not getgenv().UltimateSystem then break end
                local item = items[i]
                local itemPart = item:IsA("BasePart") and item or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
                
                if itemPart then
                    -- โหมดโหด: ปิดการชนและล้างแรงเหวี่ยงฟิสิกส์ แล้ววาร์ปยัดเข้าพิกัดตัวละครทันที
                    itemPart.CanCollide = false
                    itemPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    itemPart.CFrame = playerRoot.CFrame
                end
            end
        end
    end
end

-- [ ระบบที่ 2 ]: ฟังก์ชันบังคับตัวละครเดินเป็นวงกลมรอบจุดเริ่มต้น (Anti-AFK)
local function walkInCircle(playerRoot, deltaTime)
    if not centerPosition then
        -- บันทึกพิกัดจุดแรกที่กดรันสคริปต์เป็นจุดศูนย์กลาง
        centerPosition = playerRoot.Position
    end

    -- คำนวณมุมตามเฟรมเรทของเกม
    angle = angle + (getgenv().CircleSpeed * deltaTime)
    local offsetX = math.cos(angle) * getgenv().CircleRadius
    local offsetZ = math.sin(angle) * getgenv().CircleRadius
    
    -- ย้ายพิกัดตัวละครให้เดินเป็นวงกลมแบบสมูท
    local targetPosition = Vector3.new(centerPosition.X + offsetX, playerRoot.Position.Y, centerPosition.Z + offsetZ)
    playerRoot.CFrame = CFrame.new(targetPosition, Vector3.new(centerPosition.X, playerRoot.Position.Y, centerPosition.Z))
end

-- [ ระบบที่ 3 ]: ฟังก์ชัน Auto Rebirth สั่งเกิดใหม่อัตโนมัติผ่าน Remote Event ของเกม
local function autoRebirth()
    local rebirthEvent = ReplicatedStorage:FindFirstChild("rEvents") and ReplicatedStorage.rEvents:FindFirstChild("rebirthEvent")
    if rebirthEvent then
        local args = { "rebirthRequest" }
        rebirthEvent:FireServer(unpack(args))
    end
end

-- [[ ลูปหลักควบคุมระบบเคลื่อนที่และระบบดึงไอเทม (รันทุกเฟรมผ่าน Stepped) ]] --
local ultimateConnection
ultimateConnection = RunService.Stepped:Connect(function(deltaTime)
    if getgenv().UltimateSystem then
        local character = LocalPlayer.Character
        local playerRoot = character and character:FindFirstChild("HumanoidRootPart")
        
        if playerRoot then
            -- รันระบบดึงไอเทม + เดินวงกลมไปพร้อมกันในเฟรมเดียว
            instantWarpAllTargets(playerRoot)
            walkInCircle(playerRoot, deltaTime)
        end
    else
        -- ถ้าสั่งปิดระบบ ให้ตัดการเชื่อมต่อเพื่อประหยัดหน่วยความจำมือถือ
        if ultimateConnection then
            ultimateConnection:Disconnect()
        end
    end
end)

-- [[ ลูปแยกควบคุมระบบ Auto Rebirth (ส่งข้อมูลด้วยความเร็วสูงสุดที่ตั้งไว้) ]] --
task.spawn(function()
    while getgenv().UltimateSystem do
        autoRebirth()
        task.wait(getgenv().RebirthCooldown)
    end
end)
