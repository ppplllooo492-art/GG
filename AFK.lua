-- [[ Anti-AFK + GUI ]]

-- โหลด OrionLib
local OrionLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/shlexware/Orion/main/source"
))()

-- 1. สร้างหน้าต่างเมนูหลัก
local Window = OrionLib:MakeWindow({
    Name = "😎 Anti-AFK & Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "NaSudLhorConfig"
})

-- 2. สร้างแท็บ
local Tab = Window:MakeTab({
    Name = "ระบบกันหลุด",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- 3. Anti-AFK
local AntiAFKEnabled = false
local AntiAFKConnection

Tab:AddButton({
    Name = "🚀 เปิดระบบ Anti-AFK",
    Callback = function()
        if AntiAFKEnabled then
            OrionLib:MakeNotification({
                Name = "แจ้งเตือน",
                Content = "Anti-AFK เปิดใช้งานอยู่แล้ว",
                Time = 3
            })
            return
        end

        AntiAFKEnabled = true

        local Players = game:GetService("Players")
        local VirtualUser = game:GetService("VirtualUser")
        local LocalPlayer = Players.LocalPlayer

        AntiAFKConnection = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)

        OrionLib:MakeNotification({
            Name = "ระบบทำงาน!",
            Content = "เปิด Anti-AFK เรียบร้อย",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
})

-- 4. White Screen
local WhiteScreenOn = false
local AntiLagGui

Tab:AddToggle({
    Name = "❄️ เปิดโหมดประหยัด GPU",
    Default = false,

    Callback = function(Value)
        WhiteScreenOn = Value

        if WhiteScreenOn then
            if AntiLagGui then
                AntiLagGui:Destroy()
            end

            AntiLagGui = Instance.new("ScreenGui")
            AntiLagGui.Name = "AntiLagGui"
            AntiLagGui.IgnoreGuiInset = true
            AntiLagGui.ResetOnSpawn = false
            AntiLagGui.Parent = game:GetService("CoreGui")

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 1, 0)
            Frame.Position = UDim2.new(0, 0, 0, 0)
            Frame.BackgroundColor3 = Color3.new(1, 1, 1)
            Frame.BorderSizePixel = 0
            Frame.Parent = AntiLagGui

            OrionLib:MakeNotification({
                Name = "โหมดประหยัดพลังงาน",
                Content = "เปิด White Screen แล้ว",
                Time = 3
            })
        else
            if AntiLagGui then
                AntiLagGui:Destroy()
                AntiLagGui = nil
            end
        end
    end
})

-- 5. Rejoin
Tab:AddButton({
    Name = "🔄 Rejoin",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")

        TeleportService:Teleport(
            game.PlaceId,
            Players.LocalPlayer
        )
    end
})

-- 6. Server Hop
Tab:AddButton({
    Name = "🌍 Server Hop",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")

        local PlaceId = game.PlaceId

        local Url =
            "https://games.roblox.com/v1/games/"
            .. PlaceId
            .. "/servers/Public?sortOrder=Asc&limit=100"

        local Success, Result = pcall(function()
            return game:HttpGet(Url)
        end)

        if not Success then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "ไม่สามารถโหลดรายการเซิร์ฟเวอร์ได้",
                Time = 5
            })
            return
        end

        local Data
        local DecodeSuccess = pcall(function()
            Data = HttpService:JSONDecode(Result)
        end)

        if not DecodeSuccess or not Data or not Data.data then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "ข้อมูลเซิร์ฟเวอร์ไม่ถูกต้อง",
                Time = 5
            })
            return
        end

        for _, Server in ipairs(Data.data) do
            if Server.id ~= game.JobId
                and Server.playing
                and Server.maxPlayers
                and Server.playing < Server.maxPlayers then

                TeleportService:TeleportToPlaceInstance(
                    PlaceId,
                    Server.id,
                    Players.LocalPlayer
                )

                break
            end
        end
    end
})

-- เริ่มต้น GUI
OrionLib:Init()
