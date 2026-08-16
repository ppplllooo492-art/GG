--// DELTA CHICKEN FARMER - FIXED VERSION
--// LocalScript

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- CHARACTER
--==================================================

local character
local rootPart
local humanoid

local function updateCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid", 10)
	rootPart = char:WaitForChild("HumanoidRootPart", 10)
end

if player.Character then
	updateCharacter(player.Character)
end

player.CharacterAdded:Connect(function(char)
	updateCharacter(char)
end)

--==================================================
-- LEADERSTATS
--==================================================

local leaderstats = player:WaitForChild("leaderstats", 5)

local moneyValue

if leaderstats then
	moneyValue =
		leaderstats:FindFirstChild("Money")
		or leaderstats:FindFirstChild("Cash")
		or leaderstats:FindFirstChild("Coins")
end

if leaderstats then
	leaderstats.ChildAdded:Connect(function(child)
		if not moneyValue then
			if child.Name == "Money"
				or child.Name == "Cash"
				or child.Name == "Coins" then
				moneyValue = child
			end
		end
	end)
end

--==================================================
-- REMOTE
--==================================================

local remoteFunction

pcall(function()
	remoteFunction = ReplicatedStorage
		:WaitForChild("Paper", 10)
		:WaitForChild("Remotes", 10)
		:WaitForChild("__remotefunction", 10)
end)

--==================================================
-- CONFIG
--==================================================

local correctKey = "GGGR@23LO"

local config = {
	AutoEggs = false,
	AutoMoney = false,
	AutoBuy = false,
	AutoLucky = false,
	AutoBuy5 = false,
	AntiAFK = true
}

local chickenCost1 = 20
local chickenCost5 = 100

local maxEggs = 30
local eggCount = 0

local fps = 0
local ping = 0

--==================================================
-- HELPERS
--==================================================

local function safeInvoke(...)
	if not remoteFunction then
		return false
	end

	local args = {...}

	local success = pcall(function()
		remoteFunction:InvokeServer(unpack(args))
	end)

	return success
end

local function getBasePart(object)
	if not object then
		return nil
	end

	if object:IsA("BasePart") then
		return object
	end

	if object:IsA("Model") then
		if object.PrimaryPart then
			return object.PrimaryPart
		end

		local part =
			object:FindFirstChild("Hitbox")
			or object:FindFirstChild("Button")
			or object:FindFirstChildWhichIsA("BasePart", true)

		if part and part:IsA("BasePart") then
			return part
		end
	end

	return nil
end

local function teleportTo(target)
	if not rootPart or not target then
		return false
	end

	local targetPart = getBasePart(target)

	if not targetPart then
		return false
	end

	local success = pcall(function()
		rootPart.CFrame =
			targetPart.CFrame + Vector3.new(0, 3, 0)
	end)

	return success
end

local function isButtonRed(button)
	if not button then
		return false
	end

	local part = getBasePart(button)

	if not part then
		return false
	end

	local color = part.Color

	if part.BrickColor == BrickColor.new("Bright red") then
		return true
	end

	if color.R > 0.7
		and color.G < 0.3
		and color.B < 0.3 then
		return true
	end

	return false
end

local function getPlot()
	local plots = workspace:FindFirstChild("Plots")

	if not plots then
		return nil
	end

	return plots:FindFirstChild("BBBR17k")
end

local function getButtons()
	local plot = getPlot()

	if not plot then
		return nil
	end

	return plot:FindFirstChild("Buttons")
end

--==================================================
-- GUI
--==================================================

local oldGui = playerGui:FindFirstChild("DeltaUltimateFarmGUI")

if oldGui then
	oldGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaUltimateFarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

--==================================================
-- KEY FRAME
--==================================================

local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = ScreenGui
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
KeyFrame.Size = UDim2.new(0, 320, 0, 220)
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Visible = true

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 14)
KeyCorner.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Parent = KeyFrame
KeyTitle.BackgroundTransparency = 1
KeyTitle.Position = UDim2.new(0, 0, 0.08, 0)
KeyTitle.Size = UDim2.new(1, 0, 0, 25)
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.Text = "DELTA KEY SYSTEM"
KeyTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
KeyTitle.TextSize = 20

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Parent = KeyFrame
KeyTextBox.Position = UDim2.new(0.1, 0, 0.32, 0)
KeyTextBox.Size = UDim2.new(0.8, 0, 0, 40)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
KeyTextBox.Font = Enum.Font.SourceSans
KeyTextBox.PlaceholderText = "Paste Your Key Here..."
KeyTextBox.Text = ""
KeyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTextBox.TextSize = 15

local KeyTextBoxCorner = Instance.new("UICorner")
KeyTextBoxCorner.CornerRadius = UDim.new(0, 8)
KeyTextBoxCorner.Parent = KeyTextBox

local BtnCheckKey = Instance.new("TextButton")
BtnCheckKey.Parent = KeyFrame
BtnCheckKey.Position = UDim2.new(0.1, 0, 0.58, 0)
BtnCheckKey.Size = UDim2.new(0.8, 0, 0, 40)
BtnCheckKey.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
BtnCheckKey.Font = Enum.Font.SourceSansBold
BtnCheckKey.Text = "Check Key"
BtnCheckKey.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnCheckKey.TextSize = 16

local BtnCheckCorner = Instance.new("UICorner")
BtnCheckCorner.CornerRadius = UDim.new(0, 8)
BtnCheckCorner.Parent = BtnCheckKey

local KeyStatus = Instance.new("TextLabel")
KeyStatus.Parent = KeyFrame
KeyStatus.BackgroundTransparency = 1
KeyStatus.Position = UDim2.new(0, 0, 0.82, 0)
KeyStatus.Size = UDim2.new(1, 0, 0, 20)
KeyStatus.Font = Enum.Font.SourceSansItalic
KeyStatus.Text = "Please enter valid key to proceed"
KeyStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
KeyStatus.TextSize = 13

--==================================================
-- MAIN FRAME
--==================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -205)
MainFrame.Size = UDim2.new(0, 360, 0, 410)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

--==================================================
-- TOGGLE ICON
--==================================================

local ToggleIconButton = Instance.new("TextButton")
ToggleIconButton.Name = "ToggleIconButton"
ToggleIconButton.Parent = ScreenGui
ToggleIconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleIconButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleIconButton.Size = UDim2.new(0, 45, 0, 45)
ToggleIconButton.Font = Enum.Font.SourceSansBold
ToggleIconButton.Text = "⚙️"
ToggleIconButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleIconButton.TextSize = 24
ToggleIconButton.Active = true
ToggleIconButton.Draggable = true
ToggleIconButton.Visible = false

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 10)
IconCorner.Parent = ToggleIconButton

ToggleIconButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

--==================================================
-- TITLE / STATUS
--==================================================

local DashboardTitle = Instance.new("TextLabel")
DashboardTitle.Parent = MainFrame
DashboardTitle.BackgroundTransparency = 1
DashboardTitle.Position = UDim2.new(0.05, 0, 0.02, 0)
DashboardTitle.Size = UDim2.new(0.9, 0, 0, 28)
DashboardTitle.Font = Enum.Font.SourceSansBold
DashboardTitle.Text = "DELTA CHICKEN FARMER - FIXED"
DashboardTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
DashboardTitle.TextSize = 18
DashboardTitle.TextXAlignment = Enum.TextXAlignment.Left

local StatLabel = Instance.new("TextLabel")
StatLabel.Parent = MainFrame
StatLabel.BackgroundTransparency = 1
StatLabel.Position = UDim2.new(0.05, 0, 0.09, 0)
StatLabel.Size = UDim2.new(0.9, 0, 0, 18)
StatLabel.Font = Enum.Font.SourceSansItalic
StatLabel.Text = "FPS: Checking... | Ping: Checking..."
StatLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
StatLabel.TextSize = 12
StatLabel.TextXAlignment = Enum.TextXAlignment.Left

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.05, 0, 0.14, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 22)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 13
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- BUTTON CREATOR
--==================================================

local function createButton(posY, text)
	local btn = Instance.new("TextButton")

	btn.Parent = MainFrame
	btn.Position = UDim2.new(0.05, 0, posY, 0)
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
	btn.Font = Enum.Font.SourceSansBold
	btn.Text = text .. ": OFF"
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 13

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

	return btn
end

local BtnEggs = createButton(0.21, "Auto Farm Eggs")
local BtnMoney = createButton(0.31, "Auto Collect Money")
local BtnBuy = createButton(0.41, "AI Smart Buy Chicken")
local BtnLucky = createButton(0.51, "Auto Open Lucky Block")
local BtnBuy5 = createButton(0.61, "Auto Buy5")

local BtnAFK = Instance.new("TextButton")
BtnAFK.Parent = MainFrame
BtnAFK.Position = UDim2.new(0.05, 0, 0.73, 0)
BtnAFK.Size = UDim2.new(0.9, 0, 0, 35)
BtnAFK.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
BtnAFK.Font = Enum.Font.SourceSansBold
BtnAFK.Text = "100% Anti-AFK Bypass: ACTIVE"
BtnAFK.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnAFK.TextSize = 14

local AFKCorner = Instance.new("UICorner")
AFKCorner.CornerRadius = UDim.new(0, 6)
AFKCorner.Parent = BtnAFK

--==================================================
-- TOGGLE
--==================================================

local function toggleState(button, configKey, name)
	config[configKey] = not config[configKey]

	if config[configKey] then
		button.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
		button.Text = name .. ": ON"
	else
		button.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		button.Text = name .. ": OFF"
	end
end

BtnEggs.MouseButton1Click:Connect(function()
	toggleState(BtnEggs, "AutoEggs", "Auto Farm Eggs")
end)

BtnMoney.MouseButton1Click:Connect(function()
	toggleState(BtnMoney, "AutoMoney", "Auto Collect Money")
end)

BtnBuy.MouseButton1Click:Connect(function()
	toggleState(BtnBuy, "AutoBuy", "AI Smart Buy Chicken")
end)

BtnLucky.MouseButton1Click:Connect(function()
	toggleState(BtnLucky, "AutoLucky", "Auto Open Lucky Block")
end)

BtnBuy5.MouseButton1Click:Connect(function()
	toggleState(BtnBuy5, "AutoBuy5", "Auto Buy5")
end)

--==================================================
-- FPS / PING
--==================================================

task.spawn(function()
	local frameCount = 0
	local lastTime = os.clock()

	while ScreenGui.Parent do
		frameCount += 1

		local currentTime = os.clock()

		if currentTime - lastTime >= 1 then
			fps = frameCount
			frameCount = 0
			lastTime = currentTime

			pcall(function()
				ping = math.floor(player:GetNetworkPing() * 1000)
			end)

			StatLabel.Text =
				"FPS: "
				.. tostring(fps)
				.. " | Ping: "
				.. tostring(ping)
				.. " ms"

			if ping > 250 then
				StatLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
			elseif ping > 100 then
				StatLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
			else
				StatLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
			end
		end

		RunService.RenderStepped:Wait()
	end
end)

--==================================================
-- ANTI AFK
--==================================================

player.Idled:Connect(function()
	if not config.AntiAFK then
		return
	end

	pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new(0, 0))
	end)
end)

task.spawn(function()
	while ScreenGui.Parent do
		task.wait(120)

		if config.AntiAFK and rootPart then
			pcall(function()
				local oldCFrame = rootPart.CFrame

				rootPart.CFrame =
					oldCFrame * CFrame.new(0, 0.05, 0)

				task.wait(0.1)

				if rootPart then
					rootPart.CFrame = oldCFrame
				end
			end)
		end
	end
end)

--==================================================
-- AUTO LUCKY
--==================================================

task.spawn(function()
	while ScreenGui.Parent do
		task.wait(0.5)

		if config.AutoLucky then
			StatusLabel.Text = "Status: Opening Lucky Block..."

			safeInvoke("Open Lucky Block")
		end
	end
end)

--==================================================
-- AUTO BUY5
--==================================================

task.spawn(function()
	while ScreenGui.Parent do
		task.wait(0.5)

		if config.AutoBuy5 then
			local buttons = getButtons()

			if not buttons then
				StatusLabel.Text = "Status: Buttons not found"
				continue
			end

			local buyChickens = buttons:FindFirstChild("BuyChickens")

			if buyChickens then
				StatusLabel.Text = "Status: Going to Buy5..."

				teleportTo(buyChickens)

				task.wait(0.5)

				if config.AutoBuy5 then
					if moneyValue and moneyValue.Value >= chickenCost5 then
						StatusLabel.Text = "Status: Buying 5 Chickens"

						safeInvoke("Buy Chickens", 5)
					else
						StatusLabel.Text = "Status: Not enough money for Buy5"
					end
				end
			end

			local timer = 30

			while timer > 0 and config.AutoBuy5 do
				StatusLabel.Text =
					"Status: Next Buy5 in "
					.. tostring(timer)
					.. "s"

				task.wait(1)
				timer -= 1
			end
		end
	end
end)

--==================================================
-- AUTO EGGS
--==================================================

task.spawn(function()
	while ScreenGui.Parent do
		task.wait(0.5)

		if config.AutoEggs then
			StatusLabel.Text = "Status: Farming Eggs..."

			local eggsFolder = workspace:FindFirstChild("Eggs")

			if eggsFolder then
				local eggs = eggsFolder:GetChildren()

				for _, egg in ipairs(eggs) do
					if not config.AutoEggs then
						break
					end

					local target = getBasePart(egg)

					if target then
						teleportTo(target)

						eggCount += 1

						task.wait(0.35)

						if eggCount >= maxEggs then
							StatusLabel.Text = "Status: Depositing Eggs..."

							local buttons = getButtons()

							if buttons then
								local deposit =
									buttons:FindFirstChild("DepositEggs")

								if deposit then
									teleportTo(deposit)
								end
							end

							task.wait(1.2)

							eggCount = 0
						end
					end
				end
			else
				StatusLabel.Text = "Status: Eggs folder not found"
			end
		end
	end
end)

--==================================================
-- AUTO MONEY
--==================================================

task.spawn(function()
	while ScreenGui.Parent do
		if config.AutoMoney then
			StatusLabel.Text = "Status: Waiting for Money..."

			for i = 1, 60 do
				if not config.AutoMoney then
					break
				end

				task.wait(1)
			end

			if config.AutoMoney then
				StatusLabel.Text = "Status: Collecting Money..."

				local buttons = getButtons()

				if buttons then
					local collect =
						buttons:FindFirstChild("CollectMoney")

					if collect then
						teleportTo(collect)
						task.wait(1.5)
					else
						StatusLabel.Text = "Status: CollectMoney not found"
					end
				else
					StatusLabel.Text = "Status: Buttons not found"
				end
			end
		else
			task.wait(1)
		end
	end
end)

--==================================================
-- AUTO BUY CHICKEN
--==================================================

task.spawn(function()
	while ScreenGui.Parent do
		task.wait(1)

		if config.AutoBuy then
			if not moneyValue then
				StatusLabel.Text = "Status: Money value not found"
				continue
			end

			local buttons = getButtons()

			if not buttons then
				StatusLabel.Text = "Status: Buy buttons not found"
				continue
			end

			local buyChickens =
				buttons:FindFirstChild("BuyChickens")

			if not buyChickens then
				StatusLabel.Text = "Status: BuyChickens not found"
				continue
			end

			if isButtonRed(buyChickens) then
				StatusLabel.Text = "Status: Chicken Button RED"
				continue
			end

			while config.AutoBuy
				and moneyValue
				and moneyValue.Value >= chickenCost1
				and not isButtonRed(buyChickens) do

				StatusLabel.Text = "Status: Buying Chickens..."

				teleportTo(buyChickens)

				task.wait(0.3)

				if not config.AutoBuy then
					break
				end

				if moneyValue.Value >= chickenCost5 then
					safeInvoke("Buy Chickens", 5)
				elseif moneyValue.Value >= chickenCost1 then
					safeInvoke("Buy Chickens", 1)
				end

				task.wait(0.5)
			end
		end
	end
end)

--==================================================
-- KEY CHECK
--==================================================

BtnCheckKey.MouseButton1Click:Connect(function()
	local enteredKey = KeyTextBox.Text

	if enteredKey == correctKey then
		KeyStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
		KeyStatus.Text = "Key Correct! Loading..."

		BtnCheckKey.Active = false
		KeyTextBox.Active = false

		task.wait(1)

		KeyFrame.Visible = false
		MainFrame.Visible = true
		ToggleIconButton.Visible = true
	else
		KeyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
		KeyStatus.Text = "Invalid Key! Try again."

		KeyTextBox.Text = ""
	end
end)

--==================================================
-- START
--==================================================

MainFrame.Visible = false
ToggleIconButton.Visible = false
KeyFrame.Visible = true

print("Delta Chicken Farmer loaded successfully.")
