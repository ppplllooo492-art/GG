-================================================
-- PvP Lock System + Highlight
-- PART 1/3 : UI SYSTEM
--================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera


------------------------------------------------
-- SETTINGS
------------------------------------------------

local Enabled = false
local ESPEnabled = false

local LockPart = "HumanoidRootPart"
local Target = nil

local FOVSize = 150
local MinFOV = 60
local MaxFOV = 300

local SmoothSpeed = 0.85

local ESPDistance = 500
local ESPObjects = {}


------------------------------------------------
-- CREATE UI
------------------------------------------------

local Gui = Instance.new("ScreenGui")
Gui.Name = "PvPSystemUI"
Gui.ResetOnSpawn = false
Gui.Parent = Player:WaitForChild("PlayerGui")


local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(0,240,0,420)

Frame.Position = UDim2.new(0,20,0.5,-210)

Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

Frame.Parent = Gui



------------------------------------------------
-- CREATE BUTTON FUNCTION
------------------------------------------------

local function CreateButton(Text,Y)

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(0,200,0,40)

	Button.Position = UDim2.new(0,20,0,Y)

	Button.Text = Text

	Button.TextSize = 18

	Button.BackgroundColor3 = Color3.fromRGB(70,70,70)

	Button.TextColor3 = Color3.new(1,1,1)

	Button.Parent = Frame

	return Button

end



------------------------------------------------
-- BUTTONS
------------------------------------------------

local LockButton =
	CreateButton(
		"LOCK : OFF",
		20
	)


local HeadButton =
	CreateButton(
		"LOCK HEAD",
		70
	)


local BodyButton =
	CreateButton(
		"LOCK BODY",
		120
	)


local PlusButton =
	CreateButton(
		"+ Increase FOV",
		170
	)


local MinusButton =
	CreateButton(
		"- Decrease FOV",
		220
	)


local ESPButton =
	CreateButton(
		"ESP : OFF",
		270
	)


local HideButton =
	CreateButton(
		"Hide UI",
		320
	)



------------------------------------------------
-- FOV TEXT
------------------------------------------------

local FOVText = Instance.new("TextLabel")

FOVText.Size = UDim2.new(0,200,0,30)

FOVText.Position = UDim2.new(0,20,0,370)

FOVText.BackgroundTransparency = 1

FOVText.TextColor3 = Color3.new(1,1,1)

FOVText.TextSize = 18

FOVText.Text = "FOV : "..FOVSize

FOVText.Parent = Frame



------------------------------------------------
-- FOV CIRCLE
------------------------------------------------

local Circle = Instance.new("Frame")

Circle.AnchorPoint = Vector2.new(0.5,0.5)

Circle.Position =
	UDim2.new(0.5,0,0.5,0)

Circle.BackgroundTransparency = 1

Circle.Parent = Gui



local Corner = Instance.new("UICorner")

Corner.CornerRadius = UDim.new(1,0)

Corner.Parent = Circle



local Stroke = Instance.new("UIStroke")

Stroke.Color = Color3.fromRGB(255,255,255)

Stroke.Thickness = 2

Stroke.Parent = Circle



local function UpdateFOV()

	Circle.Size =
		UDim2.new(
			0,
			FOVSize * 2,
			0,
			FOVSize * 2
		)


	FOVText.Text =
		"FOV : "..FOVSize

end


UpdateFOV()



------------------------------------------------
-- DRAG SYSTEM
------------------------------------------------

local function MakeDrag(Object)

	local Dragging = false

	local StartPos

	local ObjectPos



	Object.InputBegan:Connect(function(Input)

		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or
			Input.UserInputType ==
			Enum.UserInputType.Touch then


			Dragging = true

			StartPos = Input.Position

			ObjectPos = Object.Position

		end

	end)



	UserInputService.InputChanged:Connect(function(Input)

		if Dragging then


			local Delta =
				Input.Position - StartPos



			Object.Position =
				UDim2.new(

					ObjectPos.X.Scale,

					ObjectPos.X.Offset + Delta.X,

					ObjectPos.Y.Scale,

					ObjectPos.Y.Offset + Delta.Y

				)

		end

	end)



	UserInputService.InputEnded:Connect(function(Input)

		if Input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or
			Input.UserInputType ==
			Enum.UserInputType.Touch then


			Dragging = false

		end

	end)

end



MakeDrag(Frame)



------------------------------------------------
-- MINI BUTTON
------------------------------------------------

local MiniButton = Instance.new("TextButton")

MiniButton.Size =
	UDim2.new(0,50,0,50)

MiniButton.Position =
	UDim2.new(0,20,0.5,0)

MiniButton.Text = "O"

MiniButton.TextSize = 25

MiniButton.BackgroundColor3 =
	Color3.fromRGB(70,70,70)

MiniButton.Visible = false

MiniButton.Parent = Gui



MakeDrag(MiniButton)



HideButton.Activated:Connect(function()

	Frame.Visible = false

	MiniButton.Visible = true

end)



MiniButton.Activated:Connect(function()

	Frame.Visible = true

	MiniButton.Visible = false

end)
--================================================
-- PART 2/3 : LOCK SYSTEM
--================================================


------------------------------------------------
-- CHECK VISIBILITY
------------------------------------------------

local function CanSee(TargetPart)

	local Character = Player.Character

	if not Character then
		return false
	end


	local Root = Character:FindFirstChild("HumanoidRootPart")

	if not Root then
		return false
	end



	local Params = RaycastParams.new()

	Params.FilterType =
		Enum.RaycastFilterType.Exclude


	Params.FilterDescendantsInstances =
		{
			Character
		}



	local Result =
		workspace:Raycast(
			Root.Position,
			TargetPart.Position - Root.Position,
			Params
		)



	if Result then

		return Result.Instance:IsDescendantOf(
			TargetPart.Parent
		)

	end


	return true

end



------------------------------------------------
-- FIND CLOSEST TARGET
------------------------------------------------

local function FindTarget()


	local Best = nil

	local Closest = math.huge



	local Character = Player.Character

	if not Character then
		return nil
	end



	local Root =
		Character:FindFirstChild(
			"HumanoidRootPart"
		)


	if not Root then
		return nil
	end



	local Center =
		Vector2.new(
			Camera.ViewportSize.X / 2,
			Camera.ViewportSize.Y / 2
		)



	for _,Enemy in pairs(Players:GetPlayers()) do


		if Enemy ~= Player
			and Enemy.Character then



			local Part =
				Enemy.Character:FindFirstChild(
					LockPart
				)



			local Humanoid =
				Enemy.Character:FindFirstChildOfClass(
					"Humanoid"
				)



			if Part
				and Humanoid
				and Humanoid.Health > 0 then



				local Distance =
					(
						Part.Position -
						Root.Position
					).Magnitude



				if Distance <= 500 then



					local ScreenPosition,Visible =
						Camera:WorldToViewportPoint(
							Part.Position
						)



					if Visible then



						local Offset =
							(
								Vector2.new(
									ScreenPosition.X,
									ScreenPosition.Y
								)
								-
								Center
							).Magnitude



						if Offset <= FOVSize
							and Offset < Closest
							and CanSee(Part) then



							Closest = Offset

							Best = Enemy


						end

					end

				end

			end

		end

	end



	return Best

end




------------------------------------------------
-- BUTTON EVENTS
------------------------------------------------


LockButton.Activated:Connect(function()


	Enabled = not Enabled



	if Enabled then


		LockButton.Text =
			"LOCK : ON"



		Target =
			FindTarget()



	else


		LockButton.Text =
			"LOCK : OFF"



		Target = nil


	end


end)




HeadButton.Activated:Connect(function()

	LockPart = "Head"

end)




BodyButton.Activated:Connect(function()

	LockPart = "HumanoidRootPart"

end)




PlusButton.Activated:Connect(function()


	FOVSize =
		math.min(
			MaxFOV,
			FOVSize + 20
		)


	UpdateFOV()


end)




MinusButton.Activated:Connect(function()


	FOVSize =
		math.max(
			MinFOV,
			FOVSize - 20
		)


	UpdateFOV()


end)





------------------------------------------------
-- CAMERA LOCK
------------------------------------------------

RunService.RenderStepped:Connect(function()


	if not Enabled then
		return
	end



	if Target
		and Target.Character then



		local Part =
			Target.Character:FindFirstChild(
				LockPart
			)



		if Part then



			local Screen,Visible =
				Camera:WorldToViewportPoint(
					Part.Position
				)



			local Center =
				Vector2.new(
					Camera.ViewportSize.X / 2,
					Camera.ViewportSize.Y / 2
				)



			local Offset =
				(
					Vector2.new(
						Screen.X,
						Screen.Y
					)
					-
					Center
				).Magnitude




			if Offset > FOVSize
				or not CanSee(Part) then


				Target = nil

				return


			end





			Camera.CFrame =
				Camera.CFrame:Lerp(

					CFrame.lookAt(

						Camera.CFrame.Position,

						Part.Position

					),

					SmoothSpeed

				)




		else


			Target = nil


		end




	else


		Target =
			FindTarget()



	end


end)
--================================================
-- PART 3/3 : PLAYER HIGHLIGHT + TRACER SYSTEM
--================================================

local ESPObjects = {}
local TracerObjects = {}


------------------------------------------------
-- CREATE HIGHLIGHT
------------------------------------------------

local function AddHighlight(TargetPlayer)

	if TargetPlayer == Player then
		return
	end

	local Character = TargetPlayer.Character
	if not Character then
		return
	end


	if ESPObjects[TargetPlayer] then
		ESPObjects[TargetPlayer]:Destroy()
		ESPObjects[TargetPlayer] = nil
	end


	local Highlight = Instance.new("Highlight")

	Highlight.Name = "PlayerHighlight"

	Highlight.FillColor =
		Color3.fromRGB(0,255,255)

	Highlight.OutlineColor =
		Color3.fromRGB(255,255,255)

	Highlight.FillTransparency = 0.25

	Highlight.OutlineTransparency = 0

	Highlight.DepthMode =
		Enum.HighlightDepthMode.AlwaysOnTop


	Highlight.Parent = Character


	ESPObjects[TargetPlayer] = Highlight

end



------------------------------------------------
-- CREATE TRACER
------------------------------------------------

local function AddTracer(TargetPlayer)

	if TracerObjects[TargetPlayer] then
		return
	end


	local MyCharacter = Player.Character
	local EnemyCharacter = TargetPlayer.Character

	if not MyCharacter or not EnemyCharacter then
		return
	end


	local MyRoot =
		MyCharacter:FindFirstChild("HumanoidRootPart")


	local EnemyRoot =
		EnemyCharacter:FindFirstChild("HumanoidRootPart")


	if not MyRoot or not EnemyRoot then
		return
	end



	local StartAttachment =
		Instance.new("Attachment")

	StartAttachment.Parent = MyRoot



	local EndAttachment =
		Instance.new("Attachment")

	EndAttachment.Parent = EnemyRoot



	local Beam =
		Instance.new("Beam")


	Beam.Name = "PlayerTracer"


	Beam.Attachment0 =
		StartAttachment

	Beam.Attachment1 =
		EndAttachment


	Beam.Color =
		ColorSequence.new(
			Color3.fromRGB(0,255,255)
		)


	Beam.Width0 = 0.18
	Beam.Width1 = 0.18


	-- เธ—เธณเนเธซเนเน€เธชเนเธเธชเธงเนเธฒเธ
	Beam.LightEmission = 1
	Beam.LightInfluence = 0


	Beam.FaceCamera = true


	Beam.Parent = MyRoot



	TracerObjects[TargetPlayer] =
		{
			Beam,
			StartAttachment,
			EndAttachment
		}

end



------------------------------------------------
-- REMOVE
------------------------------------------------

local function RemoveESP(TargetPlayer)


	if ESPObjects[TargetPlayer] then

		ESPObjects[TargetPlayer]:Destroy()

		ESPObjects[TargetPlayer] = nil

	end



	if TracerObjects[TargetPlayer] then

		for _,Object in pairs(TracerObjects[TargetPlayer]) do
			Object:Destroy()
		end


		TracerObjects[TargetPlayer] = nil

	end

end



------------------------------------------------
-- ESP BUTTON
------------------------------------------------

ESPButton.Activated:Connect(function()

	ESPEnabled = not ESPEnabled


	if ESPEnabled then

		ESPButton.Text =
			"ESP : ON"


		for _,TargetPlayer in pairs(Players:GetPlayers()) do

			if TargetPlayer ~= Player then

				AddHighlight(TargetPlayer)
				AddTracer(TargetPlayer)

			end

		end


	else


		ESPButton.Text =
			"ESP : OFF"


		for TargetPlayer,_ in pairs(ESPObjects) do

			RemoveESP(TargetPlayer)

		end


	end

end)



------------------------------------------------
-- UPDATE
------------------------------------------------

RunService.RenderStepped:Connect(function()

	if not ESPEnabled then
		return
	end


	for _,Enemy in pairs(Players:GetPlayers()) do

		if Enemy ~= Player then


			if Enemy.Character then

				AddHighlight(Enemy)
				AddTracer(Enemy)

			end

		end

	end

end)



------------------------------------------------
-- RESPAWN SUPPORT
------------------------------------------------

local function SetupPlayer(TargetPlayer)


	if TargetPlayer == Player then
		return
	end


	TargetPlayer.CharacterAdded:Connect(function()

		task.wait(1)


		if ESPEnabled then

			AddHighlight(TargetPlayer)

			task.wait(0.2)

			AddTracer(TargetPlayer)

		end

	end)

end



for _,TargetPlayer in pairs(Players:GetPlayers()) do

	SetupPlayer(TargetPlayer)

end



Players.PlayerAdded:Connect(function(NewPlayer)

	SetupPlayer(NewPlayer)

end)



Players.PlayerRemoving:Connect(function(LeavingPlayer)

	RemoveESP(LeavingPlayer)

end)
