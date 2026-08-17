getgenv().AutoScriptRunning = false
task.wait(0.5)
getgenv().AutoScriptRunning = true

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ป้องกันสคริปต์เก่าทำงานซ้อน
if getgenv().AutoScriptConnection then
    pcall(function()
        getgenv().AutoScriptConnection:Disconnect()
    end)
    getgenv().AutoScriptConnection = nil
end

-- =========================
-- SETTINGS
-- =========================

local SETTINGS = {
    EggInterval = 0.1,
    MoneyInterval = 30,
    DepositInterval = 20,
    BuyInterval = 10,

    -- เวลารอสั้น ๆ หลังวาร์ปไปยังปุ่ม
    ActionDelay = 0.15,

    -- ระยะถอยหลังหลังซื้อไก่
    BuyBackOffset = Vector3.new(0, 0, 5),
}

-- =========================
-- CHARACTER
-- =========================

local character
local root

local function updateCharacter(char)
    character = char
    root = char:WaitForChild("HumanoidRootPart", 10)
end

if player.Character then
    task.spawn(function()
        updateCharacter(player.Character)
    end)
end

getgenv().AutoScriptConnection = player.CharacterAdded:Connect(function(char)
    updateCharacter(char)
end)

local function getRootPart()
    if not player.Character then
        return nil
    end

    if character ~= player.Character then
        character = player.Character
        root = character:FindFirstChild("HumanoidRootPart")
    end

    if not root or not root.Parent then
        root = character:FindFirstChild("HumanoidRootPart")
    end

    return root
end

-- =========================
-- TARGET CFRAME
-- =========================

local function getTargetCFrame(target)
    if not target or not target.Parent then
        return nil
    end

    if target:IsA("BasePart") then
        return target.CFrame
    end

    if target:IsA("Model") then
        -- ใช้ Pivot ถ้ามี
        local success, cf = pcall(function()
            return target:GetPivot()
        end)

        if success and cf then
            return cf
        end

        -- fallback
        if target.PrimaryPart then
            return target.PrimaryPart.CFrame
        end

        local part = target:FindFirstChildWhichIsA("BasePart", true)

        if part then
            return part.CFrame
        end
    end

    return nil
end

-- =========================
-- SAFE TELEPORT
-- =========================

local function teleportTo(target)
    local currentRoot = getRootPart()

    if not currentRoot then
        return false
    end

    local targetCF = getTargetCFrame(target)

    if not targetCF then
        return false
    end

    local success = pcall(function()
        currentRoot.CFrame = targetCF
    end)

    return success
end

-- =========================
-- FIND TARGETS
-- =========================

local function getEgg()
    local leaderboards = workspace:FindFirstChild("Leaderboards")

    if not leaderboards then
        return nil
    end

    return leaderboards:FindFirstChild("Eggs")
end

local function getMoneyButton()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then
        return nil
    end

    local plot = plots:FindFirstChild("BBBR17k")
    if not plot then
        return nil
    end

    local buttons = plot:FindFirstChild("Buttons")
    if not buttons then
        return nil
    end

    local collectMoney = buttons:FindFirstChild("CollectMoney")
    if not collectMoney then
        return nil
    end

    return collectMoney:FindFirstChild("Button")
end

local function getDepositButton()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then
        return nil
    end

    local plot = plots:FindFirstChild("BBBR17k")
    if not plot then
        return nil
    end

    local buttons = plot:FindFirstChild("Buttons")
    if not buttons then
        return nil
    end

    local depositEggs = buttons:FindFirstChild("DepositEggs")
    if not depositEggs then
        return nil
    end

    return depositEggs:FindFirstChild("Hitbox")
end

local function getBuyButton()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then
        return nil
    end

    local plot = plots:FindFirstChild("BBBR17k")
    if not plot then
        return nil
    end

    local buttons = plot:FindFirstChild("Buttons")
    if not buttons then
        return nil
    end

    local buyChickens = buttons:FindFirstChild("BuyChickens")
    if not buyChickens then
        return nil
    end

    local buy5 = buyChickens:FindFirstChild("Buy5")
    if not buy5 then
        return nil
    end

    return buy5:FindFirstChild("Button")
end

-- =========================
-- ACTIONS
-- =========================

local function collectEgg()
    pcall(function()
        local egg = getEgg()

        if teleportTo(egg) then
            task.wait(SETTINGS.ActionDelay)
        end
    end)
end

local function collectMoney()
    pcall(function()
        local button = getMoneyButton()

        if teleportTo(button) then
            task.wait(SETTINGS.ActionDelay)
        end
    end)
end

local function depositEggs()
    pcall(function()
        local hitbox = getDepositButton()

        if teleportTo(hitbox) then
            task.wait(SETTINGS.ActionDelay)
        end
    end)
end

local function buyChickens()
    pcall(function()
        local button = getBuyButton()

        if teleportTo(button) then
            task.wait(2)

            local currentRoot = getRootPart()

            if currentRoot and currentRoot.Parent then
                currentRoot.CFrame =
                    currentRoot.CFrame + SETTINGS.BuyBackOffset
            end
        end
    end)
end

-- =========================
-- MAIN LOOP
-- =========================

task.spawn(function()
    local lastEgg = 0
    local lastMoney = 0
    local lastDeposit = 0
    local lastBuy = 0

    while getgenv().AutoScriptRunning do
        local now = os.clock()

        -- ไข่
        if now - lastEgg >= SETTINGS.EggInterval then
            lastEgg = now
            collectEgg()
        end

        -- เงิน
        if now - lastMoney >= SETTINGS.MoneyInterval then
            lastMoney = now
            collectMoney()
        end

        -- ฝากไข่
        if now - lastDeposit >= SETTINGS.DepositInterval then
            lastDeposit = now
            depositEggs()
        end

        -- ซื้อไก่
        if now - lastBuy >= SETTINGS.BuyInterval then
            lastBuy = now
            buyChickens()
        end

        task.wait(0.05)
    end
end)

-- =========================
-- STOP FUNCTION
-- =========================

getgenv().StopAutoScript = function()
    getgenv().AutoScriptRunning = false

    if getgenv().AutoScriptConnection then
        pcall(function()
            getgenv().AutoScriptConnection:Disconnect()
        end)

        getgenv().AutoScriptConnection = nil
    end
end

print("Auto Script Started")
