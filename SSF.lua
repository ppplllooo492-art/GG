local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCyberpunkUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local function addCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
end

local function addGradient(parent, color1, color2, rotation)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color1),
		ColorSequenceKeypoint.new(1, color2)
	})
	gradient.Rotation = rotation or 45
	gradient.Parent = parent
end

local function addStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness or 1.5
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
end

-- KEY WINDOW
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.fromOffset(380, 240)
KeyFrame.Position = UDim2.new(0.5, -190, 0.5, -120)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = ScreenGui

addCorner(KeyFrame, 18)
addGradient(
	KeyFrame,
	Color3.fromRGB(50, 10, 80),
	Color3.fromRGB(12, 12, 18),
	90
)
addStroke(KeyFrame, Color3.fromRGB(255, 0, 128), 2)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 55)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "💎 DELTA X CYBERPUNK 💎"
KeyTitle.TextColor3 = Color3.new(1, 1, 1)
KeyTitle.TextSize = 22
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.fromOffset(300, 46)
KeyInput.Position = UDim2.new(0.5, -150, 0.45, -10)
KeyInput.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
KeyInput.PlaceholderText = "⚡ ENTER SECRET KEY ⚡"
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(0, 255, 200)
KeyInput.TextSize = 14
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.Parent = KeyFrame

addCorner(KeyInput, 10)
addStroke(KeyInput, Color3.fromRGB(0, 170, 255), 1.5)

local CheckBtn = Instance.new("TextButton")
CheckBtn.Size = UDim2.fromOffset(180, 44)
CheckBtn.Position = UDim2.new(0.5, -90, 0.78, -5)
CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
CheckBtn.Text = "🚀 UNLOCK"
CheckBtn.TextColor3 = Color3.fromRGB(15, 15, 22)
CheckBtn.TextSize = 14
CheckBtn.Font = Enum.Font.GothamBold
CheckBtn.Parent = KeyFrame

addCorner(CheckBtn, 12)
addGradient(
	CheckBtn,
	Color3.fromRGB(0, 255, 150),
	Color3.fromRGB(0, 180, 80),
	45
)

-- MAIN WINDOW
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(520, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

addCorner(MainFrame, 16)
addGradient(
	MainFrame,
	Color3.fromRGB(20, 10, 40),
	Color3.fromRGB(10, 10, 15),
	90
)
addStroke(MainFrame, Color3.fromRGB(0, 255, 200), 2)

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
TopBar.Parent = MainFrame

addCorner(TopBar, 16)

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, -60, 1, 0)
MainTitle.Position = UDim2.fromOffset(15, 0)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "🔥 DELTA ULTRA HUB [UI]"
MainTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
MainTitle.TextSize = 16
MainTitle.Font = Enum.Font.GothamBold
MainTitle.TextXAlignment = Enum.TextXAlignment.Left
MainTitle.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(32, 32)
CloseBtn.Position = UDim2.new(1, -40, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 80)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

addCorner(CloseBtn, 8)

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- TABS
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -24, 0, 40)
TabBar.Position = UDim2.fromOffset(12, 56)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
TabBar.Parent = MainFrame

addCorner(TabBar, 10)

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -24, 1, -114)
ContentFrame.Position = UDim2.fromOffset(12, 104)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local flags = {
	AutoEgg = false,
	AutoCollect = false,
	AutoDeposit = false,
	AutoBuyChicken = false,
	AutoDiscardLucky = false,
	AutoOpenLucky = false
}

local tabs = {}
local pages = {}
local currentTab = nil

local function createTab(name, order)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(0, 160, 1, -6)
	tabBtn.Position = UDim2.new(0, 4 + ((order - 1) * 164), 0, 3)
	tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
	tabBtn.Text = name
	tabBtn.TextColor3 = Color3.fromRGB(150, 150, 180)
	tabBtn.TextSize = 13
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.Parent = TabBar

	addCorner(tabBtn, 8)

	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.ScrollBarThickness = 3
	page.Parent = ContentFrame

	local uiList = Instance.new("UIListLayout")
	uiList.SortOrder = Enum.SortOrder.LayoutOrder
	uiList.Padding = UDim.new(0, 8)
	uiList.Parent = page

	tabs[name] = tabBtn
	pages[name] = page

	tabBtn.MouseButton1Click:Connect(function()
		for _, p in pairs(pages) do
			p.Visible = false
		end

		for _, t in pairs(tabs) do
			t.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
			t.TextColor3 = Color3.fromRGB(150, 150, 180)
		end

		page.Visible = true
		tabBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 220)
		tabBtn.TextColor3 = Color3.new(1, 1, 1)
	end)

	if currentTab == nil then
		currentTab = name
		page.Visible = true
		tabBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 220)
		tabBtn.TextColor3 = Color3.new(1, 1, 1)
	end

	return page
end

local farmPage = createTab("🚀 MAIN FARM", 1)
local itemPage = createTab("📦 ITEM SETTING", 2)
local infoPage = createTab("👑 HUB CREDITS", 3)

local function createToggle(page, text, flagName)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -4, 0, 46)
	container.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	container.Parent = page

	addCorner(container, 10)
	addStroke(container, Color3.fromRGB(50, 50, 80), 1)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -80, 1, 0)
	label.Position = UDim2.fromOffset(15, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(240, 240, 255)
	label.TextSize = 13
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Size = UDim2.fromOffset(52, 26)
	toggleBtn.Position = UDim2.new(1, -65, 0.5, -13)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
	toggleBtn.Text = ""
	toggleBtn.Parent = container

	addCorner(toggleBtn, 13)

	local circle = Instance.new("Frame")
	circle.Size = UDim2.fromOffset(20, 20)
	circle.Position = UDim2.fromOffset(3, 3)
	circle.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
	circle.Parent = toggleBtn

	addCorner(circle, 10)

	toggleBtn.MouseButton1Click:Connect(function()
		flags[flagName] = not flags[flagName]

		if flags[flagName] then
			toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 130)
			circle:TweenPosition(
				UDim2.new(1, -23, 0.5, -10),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.15,
				true
			)
			circle.BackgroundColor3 = Color3.new(1, 1, 1)
		else
			toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
			circle:TweenPosition(
				UDim2.new(0, 3, 0.5, -10),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.15,
				true
			)
			circle.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
		end
	end)
end

createToggle(farmPage, "Auto Bring Eggs", "AutoEgg")
createToggle(farmPage, "Auto Collect Money", "AutoCollect")
createToggle(farmPage, "Auto Deposit Eggs", "AutoDeposit")
createToggle(farmPage, "Auto Buy Chickens x5", "AutoBuyChicken")

createToggle(itemPage, "Auto Discard Lucky Block", "AutoDiscardLucky")
createToggle(itemPage, "Auto Open Lucky Block", "AutoOpenLucky")

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -4, 0, 100)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text =
	"👑 DELTA CYBERPUNK UI\n\n" ..
	"🟢 Status: UI READY\n" ..
	"🎨 Cyberpunk Edition\n" ..
	"❌ Press X to close"
InfoLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
InfoLabel.TextSize = 12
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.Parent = infoPage

-- DEMO KEY
local CORRECT_KEY = "GG.GR"

CheckBtn.MouseButton1Click:Connect(function()
	if KeyInput.Text == CORRECT_KEY then
		KeyFrame.Visible = false
		MainFrame.Visible = true
	else
		CheckBtn.Text = "❌ ACCESS DENIED!"
		CheckBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 80)

		task.wait(1.5)

		CheckBtn.Text = "🚀 UNLOCK"
		CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
	end
end)
