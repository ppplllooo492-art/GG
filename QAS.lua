--// Roblox Instant Teleport Auto Farm + Anti-AFK
--// Improved / Error-Resistant Version

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local EGG_DELAY = 0.3
local EGG_STEP_DELAY = 0.15

local COLLECT_MONEY_INTERVAL = 30
local COLLECT_MONEY_WAIT = 0.8

local DEPOSIT_INTERVAL = 5
local DEPOSIT_WAIT = 0.8

local BUY_CHICKEN_INTERVAL = 10
local BUY_CHICKEN_WAIT = 2

-- เปลี่ยนเป็นชื่อ Plot ของคุณ
local PLOT_NAME = "BBBR17k"

--==================================================
-- ANTI-AFK
--==================================================

pcall(function()
    if getconnections then
        for _, connection in ipairs(getconnections(player.Idled)) do
            pcall(function()
                connection:Disable()
            end)
        end
    end
end)

--==================================================
-- CHARACTER / ROOT
--==================================================

local function getCharacter()
    return player.Character
end

local function getRoot()
    local character = getCharacter()

    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function waitForRoot(timeout)
    timeout = timeout or 5

    local startTime = os.clock()

    repeat
        local root = getRoot()

        if root then
            return root
        end

        task.wait(0.1)
    until os.clock() - startTime >= timeout

    return nil
end

--==================================================
-- SAFE FIND
--==================================================

local function findChild(parent, name)
    if not parent then
        return nil
    end

    return parent:FindFirstChild(name)
end

local function getPlot()
    local plots = Workspace:FindFirstChild("Plots")

    if not plots then
        return nil
    end

    return plots:FindFirstChild(PLOT_NAME)
end

--==================================================
-- GET CFRAME
--==================================================

local function getObjectCFrame(object)
    if not object then
        return nil
    end

    if object:IsA("BasePart") then
        return object.CFrame
    end

    if object:IsA("Model") then
        local success, result = pcall(function()
            return object:GetPivot()
        end)

        if success then
            return result
        end
    end

    if object:IsA("Attachment") then
        return object.WorldCFrame
    end

    return nil
end

--==================================================
-- TELEPORT
--==================================================

local function teleportTo(cframe)
    if not cframe then
        return false
    end

    local root = getRoot()

    if not root then
        root = waitForRoot(2)
    end

    if not root then
        return false
    end

    local success = pcall(function()
        root.CFrame = cframe
    end)

    return success
end

--==================================================
-- TELEPORT + RETURN
--==================================================

local function teleportAndReturn(target, waitTime)
    local root = getRoot()

    if not root then
        root = waitForRoot(2)
    end

    if not root then
        return
    end

    local targetCFrame = getObjectCFrame(target)

    if not targetCFrame then
        return
    end

    local oldCFrame

    pcall(function()
        oldCFrame = root.CFrame
    end)

    if not oldCFrame then
        return
    end

    if teleportTo(targetCFrame) then
        task.wait(waitTime or 0.5)

        local currentRoot = getRoot()

        if currentRoot then
            pcall(function()
                currentRoot.CFrame = oldCFrame
            end)
        end
    end
end

--==================================================
-- SYSTEM 1
-- AUTO COLLECT EGGS
--==================================================

task.spawn(function()
    while task.wait(EGG_DELAY) do
        pcall(function()

            local leaderboards = Workspace:FindFirstChild("Leaderboards")

            if not leaderboards then
                return
            end

            local eggs = leaderboards:FindFirstChild("Eggs")

            if not eggs then
                return
            end

            for _, item in ipairs(eggs:GetChildren()) do

                -- เช็กตัวละครทุกครั้ง เผื่อเกิดใหม่
                if not getRoot() then
                    waitForRoot(3)
                end

                local targetCFrame = getObjectCFrame(item)

                if targetCFrame then
                    teleportTo(targetCFrame)
                    task.wait(EGG_STEP_DELAY)
                end
            end
        end)
    end
end)

--==================================================
-- SYSTEM 2
-- COLLECT MONEY EVERY 30 SECONDS
--==================================================

task.spawn(function()
    while true do
        task.wait(COLLECT_MONEY_INTERVAL)

        pcall(function()

            local plot = getPlot()

            if not plot then
                return
            end

            local buttons = plot:FindFirstChild("Buttons")

            if not buttons then
                return
            end

            local collectMoney = buttons:FindFirstChild("CollectMoney")

            if not collectMoney then
                return
            end

            local button = collectMoney:FindFirstChild("Button")

            if not button then
                return
            end

            teleportAndReturn(
                button,
                COLLECT_MONEY_WAIT
            )
        end)
    end
end)

--==================================================
-- SYSTEM 3
-- DEPOSIT / SELL EGGS EVERY 5 SECONDS
--==================================================

task.spawn(function()
    while task.wait(DEPOSIT_INTERVAL) do

        pcall(function()

            local plot = getPlot()

            if not plot then
                return
            end

            local buttons = plot:FindFirstChild("Buttons")

            if not buttons then
                return
            end

            local depositEggs = buttons:FindFirstChild("DepositEggs")

            if not depositEggs then
                return
            end

            local hitbox = depositEggs:FindFirstChild("Hitbox")

            if not hitbox then
                return
            end

            teleportAndReturn(
                hitbox,
                DEPOSIT_WAIT
            )
        end)
    end
end)

--==================================================
-- SYSTEM 4
-- BUY CHICKENS (BUY5) EVERY 10 SECONDS
--==================================================

task.spawn(function()
    while true do
        task.wait(BUY_CHICKEN_INTERVAL)

        pcall(function()

            local plot = getPlot()

            if not plot then
                return
            end

            local buttons = plot:FindFirstChild("Buttons")

            if not buttons then
                return
            end

            local buyChickens = buttons:FindFirstChild("BuyChickens")

            if not buyChickens then
                return
            end

            local buy5 = buyChickens:FindFirstChild("Buy5")

            if not buy5 then
                return
            end

            local button = buy5:FindFirstChild("Button")

            if not button then
                return
            end

            teleportAndReturn(
                button,
                BUY_CHICKEN_WAIT
            )
        end)
    end
end)

--==================================================
-- CHARACTER RESPAWN HANDLER
--==================================================

player.CharacterAdded:Connect(function(character)
    pcall(function()
        character:WaitForChild("HumanoidRootPart", 10)
    end)
end)

print("[AutoFarm] Loaded successfully.")
