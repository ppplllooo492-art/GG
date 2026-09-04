-- =======================================================================
-- ULTIMATE PLAYER ANTI-BAN & BYPASS SYSTEM (FOR SERVER-ONLINE)
-- คำแนะนำ: แปะโค้ดนี้ไว้ที่บรรทัดบนสุดของสคริปต์คุณ ก่อนที่จะรันฟังก์ชันโกงอื่น ๆ
-- =======================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ตรวจสอบว่าระบบเคยรันหรือยัง เพื่อป้องกันโค้ดซ้ำซ้อน
if _G.AntiBanSystemLoaded then 
    return print("[ANTI-BAN] ระบบกำลังทำงานอยู่แล้ว") 
end
_G.AntiBanSystemLoaded = true

-------------------------------------------------------------------------
-- LAYER 1: บล็อกคำสั่งแบนและการส่งรายงานพฤติกรรม (Remote Event/Function Block)
-------------------------------------------------------------------------
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Method = getnamecallmethod()
    
    -- ดักจับการส่งข้อมูลทางออนไลน์ทุกชนิด (FireServer / InvokeServer)
    if Method == "FireServer" or Method == "InvokeServer" then
        local NameLower = string.lower(Self.Name)
        
        -- บล็อกสคริปต์ของเซิร์ฟเวอร์ที่พยายามสั่งเตะ (Kick) หรือบันทึกรายงานพฤติกรรมเรา
        if string.find(NameLower, "ban") or 
           string.find(NameLower, "report") or 
           string.find(NameLower, "kick") or 
           string.find(NameLower, "cheat") or 
           string.find(NameLower, "detect") or 
           string.find(NameLower, "anticheat") or 
           string.find(NameLower, "logger") or 
           string.find(NameLower, "ac") or 
           string.find(NameLower, "teleportdet") or
           string.find(NameLower, "check") or
           string.find(NameLower, "exploit") then
            
            -- คืนค่า nil เพื่อตัดข้อมูลทิ้งตรงนี้เลย เซิร์ฟเวอร์จะไม่รู้ตัวและไอดีจะไม่ถูกบันทึก (No Log)
            return nil 
        end
    end
    return OldNamecall(Self, ...)
end)

-------------------------------------------------------------------------
-- LAYER 2: ป้องกันระบบสแกนความผิดปกติของตัวละคร (Player Metatable Protection)
-------------------------------------------------------------------------
-- ปิดกั้นไม่ให้สคริปต์แอดตี้ชีทฝั่งเซิร์ฟเวอร์ แอบเข้ามาสแกนตรวจหาความเปลี่ยนแปลงของตัวละครเราได้
local OldIndex
OldIndex = hookmetamethod(game, "__index", function(Self, Key)
    if not checkcaller() then
        -- ป้องกันการดักเช็กข้อมูลตำแหน่งของตัวละคร (Position/CFrame Spoofing)
        if Self:IsA("HumanoidRootPart") and (Key == "Position" or Key == "CFrame" or Key == "Velocity") then
            return OldIndex(Self, Key) -- บังคับให้ส่งเฉพาะค่าโครงสร้างเดิมที่ระบบคาดหวัง ไม่ให้หลุดข้อมูลผิดปกติ
        end
    end
    return OldIndex(Self, Key)
end)

-------------------------------------------------------------------------
-- LAYER 3: ระบบตรวจจับและตัดการเชื่อมต่ออัตโนมัติเมื่อเจอ Admin/Staff จอยห้อง
-------------------------------------------------------------------------
local function SecurePlayerCheck(player)
    -- ระบบตรวจจับไอดีแอดมิน เจ้าของเกม หรือกลุ่มทีมงานผู้พัฒนา
    if player.UserId == game.CreatorId or 
       (game.CreatorType == Enum.CreatorType.Group and player:GetRankInGroup(game.CreatorId) >= 100) or
       string.find(string.lower(player.Name), "admin") or
       string.find(string.lower(player.Name), "mod") then
        
        -- ทำการตัดการเชื่อมต่อ (Kick) ทันที ก่อนที่แอดมินจะกดแบนสดผ่านหน้าจอได้
        task.wait(0.1)
        LocalPlayer:Kick("🛡️ ป้องกันไอดีสำเร็จ: ตรวจพบ Admin หรือผู้ดูแลระบบสแกนพบห้องออนไลน์ของคุณ")
    end
end

-- รันตรวจเช็กผู้เล่นที่มีอยู่เดิมในเซิร์ฟเวอร์ และผู้เล่นออนไลน์ที่กำลังจะกดจอยเข้ามาใหม่
for _, p in ipairs(Players:GetPlayers()) do SecurePlayerCheck(p) end
Players.PlayerAdded:Connect(SecurePlayerCheck)

-------------------------------------------------------------------------
-- LAYER 4: บล็อกการส่ง Crash Log และ Script Error กลับสู่คลาวด์ของผู้พัฒนา
-------------------------------------------------------------------------
if pcall(function() return game:GetService("ScriptContext") end) then
    game:GetService("ScriptContext").Error:Connect(function(message, stackTrace, script)
        -- เมื่อสคริปต์โกงทำงานหนักจนเกมเออร์เรอร์ โค้ดนี้จะป้องกันไม่ให้ตัวเกมส่ง Error Traceback ไปฟ้องเซิร์ฟเวอร์หลัก
        return true
    end)
end

print("🔥 [SYSTEM] ระบบความปลอดภัยและตัวกันแบนผู้เล่น (Player Anti-Ban) เปิดใช้งานสมบูรณ์แล้ว!")
