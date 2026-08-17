--// Chicken Farm Auto Farm + Anti-AFK
--// Delta Executor

local Players = game:GetService("Players")
local player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local EggDelay = 0.4
local EggWait = 0.2

local CollectInterval = 30
local CollectWait = 0.8

local SellInterval = 5
local SellWait = 0.8

local BuyInterval = 10
local BuyWait = 2

--==================================================
-- ANTI AFK
--==================================================

pcall(function()
    for _, connection in ipairs(getconnections(player.Idled)) do
        connection:Disable()
    end
end)

--==================================================
-- CHARACTER
--==================================================

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getRoot()
    local character = player.Character
    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

--==================================================
-- SAFE TELEPORT
--==================================================

local function tp(cframe)
    local root = getRoot()

    if root and cframe then
        root.CFrame = cframe
        return true
    end

    return false
end

--==================================================
-- GET PLOT
--==================================================

local function getPlot()
    local plots = workspace:FindFirstChild("Plots")

    if not plots then
        return nil
    end

    -- พยายามหา Plot ของผู้เล่นก่อน
    local plot = plots:FindFirstChild(player.Name)

    if plot then
        return plot
    end

    -- ถ้าชื่อ Plot ไม่ตรงกับชื่อผู้เล่น
    for _, obj in ipairs(plots:GetChildren()) do
        if obj:IsA("Folder") or obj:IsA("Model") then
            local owner = obj:GetAttribute("Owner")

            if owner == player.Name then
                return obj
            end
        end
    end

    -- fallback
    return plots:FindFirstChildOfClass("Folder")
        or plots:FindFirstChildOfClass("Model")
end

--==================================================
-- GET OBJECT CFRAME
--==================================================

local function getObjectCFrame(object)
    if not object then
        return nil
    end

    if object:IsA("BasePart") then
        return object.CFrame
    end

    if object:IsA("Model") then
        if object.PrimaryPart then
            return object.PrimaryPart.CFrame
        end

        local part = object:FindFirstChildWhichIsA("BasePart", true)

        if part then
            return part.CFrame
        end

        return object:GetPivot()
    end

    return nil
end

--==================================================
-- 1. AUTO COLLECT EGGS
--==================================================

task.spawn(function()
    while task.wait(EggDelay) do
        pcall(function()

            local leaderboards = workspace:FindFirstChild("Leaderboards")
            if not leaderboards then
                return
            end

            local eggs = leaderboards:FindFirstChild("Eggs")
            if not eggs then
                return
            end

            for _, item in ipairs(eggs:GetChildren()) do

                local position = getObjectCFrame(item)

                if position then
                    if tp(position) then
                        task.wait(EggWait)
                    end
                end

            end
        end)
    end
end)

--==================================================
-- 2. AUTO COLLECT MONEY
--==================================================

task.spawn(function()
    while task.wait(CollectInterval) do
        pcall(function()

            local root = getRoot()
            local plot = getPlot()

            if not root or not plot then
                return
            end

            local buttons = plot:FindFirstChild("Buttons")
            if not buttons then
                return
            end

            local collectFolder = buttons:FindFirstChild("CollectMoney")
            if not collectFolder then
                return
            end

            local collectButton = collectFolder:FindFirstChild("Button")
            local collectCFrame = getObjectCFrame(collectButton)

            if collectCFrame then
                local oldCFrame = root.CFrame

                if tp(collectCFrame) then
                    task.wait(CollectWait)

                    if getRoot() then
                        tp(oldCFrame)
                    end
                end
            end

        end)
    end
end)

--==================================================
-- 3. AUTO SELL / DEPOSIT EGGS
--==================================================

task.spawn(function()
    while task.wait(SellInterval) do
        pcall(function()

            local root = getRoot()
            local plot = getPlot()

            if not root or not plot then
                return
            end

            local buttons = plot:FindFirstChild("Buttons")
            if not buttons then
                return
            end

            local depositFolder = buttons:FindFirstChild("DepositEggs")
            if not depositFolder then
                return
            end

            local hitbox = depositFolder:FindFirstChild("Hitbox")
            local hitboxCFrame = getObjectCFrame(hitbox)

            if hitboxCFrame then
                local oldCFrame = root.CFrame

                if tp(hitboxCFrame) then
                    task.wait(SellWait)

                    if getRoot() then
                        tp(oldCFrame)
                    end
                end
            end

        end)
    end
end)

--==================================================
-- 4. AUTO BUY CHICKENS
--==================================================

task.spawn(function()
    while task.wait(BuyInterval) do
        pcall(function()

            local root = getRoot()
            local plot = getPlot()

            if not root or not plot then
                return
            end

            local buttons = plot:FindFirstChild("Buttons")
            if not buttons then
                return
            end

            local chickens = buttons:FindFirstChild("BuyChickens")
            if not chickens then
                return
            end

            local buy5 = chickens:FindFirstChild("Buy5")
            if not buy5 then
                return
            end

            local buyButton = buy5:FindFirstChild("Button")
            local buyCFrame = getObjectCFrame(buyButton)

            if buyCFrame then
                local oldCFrame = root.CFrame

                if tp(buyCFrame) then
                    task.wait(BuyWait)

                    if getRoot() then
                        tp(oldCFrame)
                    end
                end
            end

        end)
    end
end)

--==================================================
-- CHARACTER RESPAWN SUPPORT
--==================================================

player.CharacterAdded:Connect(function()
    task.wait(2)

    -- Anti-AFK ใหม่หลังเกิดใหม่
    pcall(function()
        for _, connection in ipairs(getconnections(player.Idled)) do
            connection:Disable()
        end
    end)
end)

print("Chicken Farm Auto Farm Loaded!")
