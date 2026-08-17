--// Ultimate Auto Farm
--// Version: Stable

if getgenv().UltimateAutoFarm then
    getgenv().UltimateAutoFarm = false
    task.wait(1)
end

getgenv().UltimateAutoFarm = true

local Players = game:GetService("Players")
local player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    EggDelay = 0.1,
    MoneyDelay = 30,
    DepositDelay = 20,
    ChickenDelay = 10,
    ChickenStandTime = 2,
    MoveOffset = Vector3.new(0, 0, 5),
}

--==================================================
-- CHARACTER
--==================================================

local function getCharacter()
    local character = player.Character

    if not character or not character.Parent then
        character = player.CharacterAdded:Wait()
    end

    return character
end

local function getRootPart()
    local character = getCharacter()

    return character:FindFirstChild("HumanoidRootPart")
        or character:WaitForChild("HumanoidRootPart", 5)
end

--==================================================
-- GET CFRAME
--==================================================

local function getTargetCFrame(target)
    if not target or not target.Parent then
        return nil
    end

    -- BasePart
    if target:IsA("BasePart") then
        return target.CFrame
    end

    -- Model
    if target:IsA("Model") then
        if target.PrimaryPart then
            return target.PrimaryPart.CFrame
        end

        local part = target:FindFirstChildWhichIsA("BasePart", true)

        if part then
            return part.CFrame
        end
    end

    -- Folder / other container
    local part = target:FindFirstChildWhichIsA("BasePart", true)

    if part then
        return part.CFrame
    end

    return nil
end

--==================================================
-- SAFE FIND
--==================================================

local function findChild(parent, ...)
    if not parent then
        return nil
    end

    local current = parent

    for _, name in ipairs({...}) do
        current = current:FindFirstChild(name)

        if not current then
            return nil
        end
    end

    return current
end

--==================================================
-- TELEPORT
--==================================================

local function teleportTo(target)
    local root = getRootPart()

    if not root then
        return false
    end

    local targetCF = getTargetCFrame(target)

    if not targetCF then
        return false
    end

    root.CFrame = targetCF

    return true
end

--==================================================
-- ANTI AFK
--==================================================

pcall(function()
    local connections = getconnections(player.Idled)

    for _, connection in ipairs(connections) do
        pcall(function()
            connection:Disable()
        end)
    end
end)

--==================================================
-- FIND PLOT
--==================================================

local function getPlot()
    local plots = workspace:FindFirstChild("Plots")

    if not plots then
        return nil
    end

    return plots:FindFirstChild("BBBR17k")
end

--==================================================
-- 1. AUTO COLLECT EGGS
--==================================================

task.spawn(function()
    while getgenv().UltimateAutoFarm do
        pcall(function()
            local eggs = workspace:FindFirstChild("Eggs")

            if eggs then
                teleportTo(eggs)
            end
        end)

        task.wait(CONFIG.EggDelay)
    end
end)

--==================================================
-- 2. COLLECT MONEY
--==================================================

task.spawn(function()
    while getgenv().UltimateAutoFarm do
        pcall(function()
            local plot = getPlot()

            if plot then
                local moneyButton = findChild(
                    plot,
                    "Buttons",
                    "CollectMoney",
                    "Button"
                )

                if moneyButton then
                    teleportTo(moneyButton)
                end
            end
        end)

        task.wait(CONFIG.MoneyDelay)
    end
end)

--==================================================
-- 3. DEPOSIT EGGS
--==================================================

task.spawn(function()
    while getgenv().UltimateAutoFarm do
        pcall(function()
            local plot = getPlot()

            if plot then
                local depositHitbox = findChild(
                    plot,
                    "Buttons",
                    "DepositEggs",
                    "Hitbox"
                )

                if depositHitbox then
                    teleportTo(depositHitbox)
                end
            end
        end)

        task.wait(CONFIG.DepositDelay)
    end
end)

--==================================================
-- 4. BUY CHICKENS
--==================================================

task.spawn(function()
    while getgenv().UltimateAutoFarm do
        pcall(function()
            local plot = getPlot()

            if plot then
                local buttons = plot:FindFirstChild("Buttons")

                if buttons then
                    local buyChickens = buttons:FindFirstChild("BuyChickens")

                    if buyChickens then
                        local buy5 = buyChickens:FindFirstChild("Buy5")

                        if buy5 then
                            local button = buy5:FindFirstChild("Button")

                            if button then
                                local success = teleportTo(button)

                                if success then
                                    task.wait(CONFIG.ChickenStandTime)

                                    local root = getRootPart()

                                    if root then
                                        root.CFrame =
                                            root.CFrame + CONFIG.MoveOffset
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)

        task.wait(CONFIG.ChickenDelay)
    end
end)

--==================================================
-- CHARACTER RESPAWN SUPPORT
--==================================================

player.CharacterAdded:Connect(function(character)
    if not getgenv().UltimateAutoFarm then
        return
    end

    character:WaitForChild("HumanoidRootPart", 10)
end)

print("[UltimateAutoFarm] Started successfully.")
