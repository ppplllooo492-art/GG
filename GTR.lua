--// DELTA HUB // NO KEY EDITION
--// Fixed / Stable Version

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- CHARACTER
--==================================================

local character
local humanoid
local rootPart

local function setupCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid", 10)
	rootPart = char:WaitForChild("HumanoidRootPart", 10)
end

if player.Character then
	setupCharacter(player.Character)
end

player.CharacterAdded:Connect(function(char)
	setupCharacter(char)
end)

--==================================================
-- LEADERSTATS
--==================================================

local leaderstats = player:WaitForChild("leaderstats", 5)

local moneyValue

local function findMoneyValue()
	if not leaderstats then
		return nil
	end

	return leaderstats:FindFirstChild("Money")
		or leaderstats:FindFirstChild("Cash")
		or leaderstats:FindFirstChild("Coins")
end

moneyValue = findMoneyValue()

if leaderstats then
	leaderstats.ChildAdded:Connect(function()
		moneyValue = findMoneyValue()
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

local config = {
	AutoEggs = false,
	AutoMoney = false,
	AutoBuy = false,
	AutoLucky = false,
	PullBuyButton = false,
	AntiAFK = true
}

local chickenCost1 = 20
local chickenCost5 = 100
local maxEggs = 30

local eggCount = 0
local fps = 0

--==================================================
-- SAFE HELPERS
--==================================================

local function getRoot()
	if not rootPart or not rootPart.Parent then
		character = player.Character

		if character then
			rootPart = character:FindFirstChild("HumanoidRootPart")
		end
	end

	return rootPart
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

local function getButton(name)
	local buttons = getButtons()

	if not buttons then
		return nil
	end

	return buttons:FindFirstChild(name)
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

		local part = object:FindFirstChildWhichIsA("BasePart", true)

		if part then
			return part
		end
	end

	return nil
end

local function teleportTo(target)
	local root = getRoot()
	local targetPart = getBasePart(target)

	if not root or not targetPart then
		return false
	end

	pcall(function()
		root.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
	end)

	return true
end

local function isButtonRed(button)
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

local function invokeRemote(...)
	if not remoteFunction then
		return false
	end

	local success = pcall(function(...)
		remoteFunction:InvokeServer(...)
	end, ...)

	return success
end

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaUltimateFarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

--==================================================
-- MAIN FRAME
--==================================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -210)
MainFrame.Size = UDim2.new(0, 380, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(
		0,
		Color3.fromRGB(18, 18, 26)
	),
	ColorSequenceKeypoint.new(
		1,
		Color3.fromRGB(8, 8, 12)
	)
})
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

--==================================================
-- TOGGLE ICON
--==================================================

local ToggleIconButton = Instance.new("TextButton")
ToggleIconButton.Name = "ToggleIconButton"
ToggleIconButton.Parent = ScreenGui
ToggleIconButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ToggleIconButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleIconButton.Size = UDim2.new(0, 45, 0, 45)
ToggleIconButton.Font = Enum.Font.GothamBold
ToggleIconButton.Text = "⚡"
ToggleIconButton.TextColor3 = Color3.fromRGB(255, 204, 0)
ToggleIconButton.TextSize = 22
ToggleIconButton.Active = true
ToggleIconButton.Draggable = true
ToggleIconButton.Visible = true

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 12)
IconCorner.Parent = ToggleIconButton

ToggleIconButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

--==================================================
-- TITLE
--==================================================

local DashboardTitle = Instance.new("TextLabel")
DashboardTitle.Parent = MainFrame
DashboardTitle.BackgroundTransparency = 1
DashboardTitle.Position = UDim2.new(0.06, 0, 0.03, 0)
DashboardTitle.Size = UDim2.new(0.88, 0, 0, 30)
DashboardTitle.Font = Enum.Font.GothamBold
DashboardTitle.Text = "DELTA HUB // NO KEY EDITION"
DashboardTitle.TextColor3 = Color3.fromRGB(255, 204, 0)
DashboardTitle.TextSize = 16
DashboardTitle.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- STATS
--==================================================

local StatLabel = Instance.new("TextLabel")
StatLabel.Parent = MainFrame
StatLabel.BackgroundTransparency = 1
StatLabel.Position = UDim2.new(0.06, 0, 0.10, 0)
StatLabel.Size = UDim2.new(0.88, 0, 0, 18)
StatLabel.Font = Enum.Font.GothamMedium
StatLabel.Text = "FPS: 0 | Ping: 0 ms"
StatLabel.TextColor3 = Color3.fromRGB(0, 229, 255)
StatLabel.TextSize = 11
StatLabel.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- STATUS
--==================================================

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.06, 0, 0.15, 0)
StatusLabel.Size = UDim2.new(0.88, 0, 0, 22)

-- FIXED: Enum.Font.GothamStatusLabel ไม่มี
StatusLabel.Font = Enum.Font.Gotham

StatusLabel.Text = "Status: Operational"
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

--==================================================
-- BUTTON CREATOR
--==================================================

local function createButton(posY, text)
	local btn = Instance.new("TextButton")
	local corner = Instance.new("UICorner")

	btn.Parent = MainFrame
	btn.Position = UDim2.new(0.06, 0, posY, 0)
	btn.Size = UDim2.new(0.88, 0, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	btn.Font = Enum.Font.GothamBold
	btn.Text = text .. " [OFF]"
	btn.TextColor3 = Color3.fromRGB(230, 230, 250)
	btn.TextSize = 12

	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	return btn
end

local BtnEggs = createButton(
	0.23,
	"Auto Farm Eggs"
)

local BtnMoney = createButton(
	0.32,
	"Auto Collect Money"
)

local BtnBuy = createButton(
	0.41,
	"AI Smart Buy Chicken"
)

local BtnLucky = createButton(
	0.50,
	"Auto Open Lucky Block"
)

local BtnPull = createButton(
	0.59,
	"Pull BuyChicken to Me"
)

--==================================================
-- TOGGLE
--==================================================

local function toggleState(button, configKey, name)
	config[configKey] = not config[configKey]

	if config[configKey] then
		button.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
		button.Text = name .. " [ON]"
	else
		button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
		button.Text = name .. " [OFF]"
	end
end

BtnEggs.MouseButton1Click:Connect(function()
	toggleState(
		BtnEggs,
		"AutoEggs",
		"Auto Farm Eggs"
	)
end)

BtnMoney.MouseButton1Click:Connect(function()
	toggleState(
		BtnMoney,
		"AutoMoney",
		"Auto Collect Money"
	)
end)

BtnBuy.MouseButton1Click:Connect(function()
	toggleState(
		BtnBuy,
		"AutoBuy",
		"AI Smart Buy Chicken"
	)
end)

BtnLucky.MouseButton1Click:Connect(function()
	toggleState(
		BtnLucky,
		"AutoLucky",
		"Auto Open Lucky Block"
	)
end)

BtnPull.MouseButton1Click:Connect(function()
	toggleState(
		BtnPull,
		"PullBuyButton",
		"Pull BuyChicken to Me"
	)
end)

--==================================================
-- FPS / PING
--==================================================

task.spawn(function()
	local lastTime = os.clock()
	local frameCount = 0

	RunService.RenderStepped:Connect(function()
		frameCount += 1
	end)

	while task.wait(1) do
		local currentTime = os.clock()

		if currentTime - lastTime >= 1 then
			fps = frameCount
			frameCount = 0
			lastTime = currentTime

			local ping = 0

			pcall(function()
				ping = math.floor(
					player:GetNetworkPing() * 1000
				)
			end)

			StatLabel.Text =
				"FPS: "
				.. tostring(fps)
				.. " | Ping: "
				.. tostring(ping)
				.. " ms"
		end
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
		VirtualUser:ClickButton2(
			Vector2.new(0, 0)
		)
	end)
end)

task.spawn(function()
	while task.wait(120) do
		if config.AntiAFK then
			local root = getRoot()

			if root then
				pcall(function()
					root.CFrame =
						root.CFrame
						* CFrame.new(0, 0.01, 0)
				end)
			end
		end
	end
end)

--==================================================
-- PULL BUY CHICKEN
--==================================================

task.spawn(function()
	while task.wait(0.2) do
		if config.PullBuyButton then
			pcall(function()
				local buyTarget =
					getButton("BuyChickens")

				local root = getRoot()

				if not buyTarget or not root then
					return
				end

				local targetPart =
					getBasePart(buyTarget)

				if targetPart then
					targetPart.CFrame =
						root.CFrame
				end
			end)
		end
	end
end)

--==================================================
-- AUTO LUCKY
--==================================================

task.spawn(function()
	while task.wait(0.3) do
		if config.AutoLucky then
			StatusLabel.Text =
				"Status: Opening Lucky Block"

			pcall(function()
				invokeRemote(
					"Open Lucky Block"
				)
			end)
		end
	end
end)

--==================================================
-- AUTO EGGS
--==================================================

task.spawn(function()
	while task.wait(0.5) do
		if config.AutoEggs then
			StatusLabel.Text =
				"Status: Farming Eggs"

			local eggsFolder =
				workspace:FindFirstChild("Eggs")

			if eggsFolder then
				local eggs =
					eggsFolder:GetChildren()

				if #eggs > 0 then
					for _, egg in ipairs(eggs) do
						if not config.AutoEggs then
							break
						end

						local target =
							getBasePart(egg)

						if target then
							teleportTo(target)

							eggCount += 1

							task.wait(0.35)

							if eggCount >= maxEggs then
								StatusLabel.Text =
									"Status: Depositing Eggs"

								local depositButton =
									getButton("DepositEggs")

								if depositButton then
									local hitbox =
										depositButton:FindFirstChild(
											"Hitbox",
											true
										)

									if hitbox then
										teleportTo(hitbox)
									else
										teleportTo(
											depositButton
										)
									end
								end

								task.wait(1.2)

								eggCount = 0
							end
						end
					end
				end
			end
		end
	end
end)

--==================================================
-- AUTO MONEY
--==================================================

task.spawn(function()
	while task.wait(0.5) do
		if config.AutoMoney then
			StatusLabel.Text =
				"Status: Collecting Money"

			local collectButton =
				getButton("CollectMoney")

			if collectButton then
				local target =
					collectButton:FindFirstChild(
						"Button",
						true
					)

				if target then
					teleportTo(target)
				else
					teleportTo(collectButton)
				end

				task.wait(1.5)
			end

			-- รอประมาณ 60 วินาที แต่สามารถปิดได้ระหว่างรอ
			for _ = 1, 120 do
				if not config.AutoMoney then
					break
				end

				task.wait(0.5)
			end
		end
	end
end)

--==================================================
-- AUTO BUY CHICKEN
--==================================================

task.spawn(function()
	while task.wait(1) do
		if config.AutoBuy then
			moneyValue = moneyValue or findMoneyValue()

			if not moneyValue then
				StatusLabel.Text =
					"Status: Money Not Found"

				continue
			end

			pcall(function()
				local buyButton =
					getButton("BuyChickens")

				if not buyButton then
					StatusLabel.Text =
						"Status: Buy Button Not Found"

					return
				end

				-- ถ้าปุ่มแดง ให้หยุด
				if isButtonRed(buyButton) then
					StatusLabel.Text =
						"Status: Chicken Button RED"

					return
				end

				-- เงินไม่พอ
				if moneyValue.Value < chickenCost1 then
					StatusLabel.Text =
						"Status: Not Enough Money"

					return
				end

				while
					config.AutoBuy
					and moneyValue
					and moneyValue.Value >= chickenCost1
				do
					-- เช็คปุ่มทุกครั้ง
					if isButtonRed(buyButton) then
						StatusLabel.Text =
							"Status: Chicken Button RED"

						break
					end

					StatusLabel.Text =
						"Status: Upgrading Chicken"

					teleportTo(buyButton)

					task.wait(0.3)

					if not config.AutoBuy then
						break
					end

					if moneyValue.Value >= chickenCost5 then
						invokeRemote(
							"Buy Chickens",
							5
						)
					else
						invokeRemote(
							"Buy Chickens",
							1
						)
					end

					task.wait(0.5)
				end
			end)
		end
	end
end)

--==================================================
-- CHARACTER RESPAWN STATUS
--==================================================

player.CharacterAdded:Connect(function()
	StatusLabel.Text =
		"Status: Character Respawned"

	task.wait(2)

	if config.AutoEggs then
		StatusLabel.Text =
			"Status: Farming Eggs"
	elseif config.AutoMoney then
		StatusLabel.Text =
			"Status: Collecting Money"
	elseif config.AutoBuy then
		StatusLabel.Text =
			"Status: Upgrading Chicken"
	elseif config.AutoLucky then
		StatusLabel.Text =
			"Status: Opening Lucky Block"
	else
		StatusLabel.Text =
			"Status: Operational"
	end
end)

--==================================================
-- FINAL STATUS
--==================================================

StatusLabel.Text =
	"Status: Operational"
