local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer


local gui = Instance.new("ScreenGui")
gui.Name = "KML_FLY"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui


local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,250,0,200)
frame.Position = UDim2.new(0.05,0,0.3,0)
frame.Parent = gui



-- X / O
local close = Instance.new("TextButton")
close.Text = "X"
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(0.85,0,0,0)
close.Parent = frame


local open = Instance.new("TextButton")
open.Text = "O"
open.Size = UDim2.new(0,50,0,50)
open.Position = UDim2.new(0.05,0,0.3,0)
open.Visible = false
open.Parent = gui


close.MouseButton1Click:Connect(function()
	frame.Visible = false
	open.Visible = true
end)

open.MouseButton1Click:Connect(function()
	frame.Visible = true
	open.Visible = false
end)



-- ลาก UI
local dragging=false
local dragStart
local startPos

frame.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging=true
		dragStart=i.Position
		startPos=frame.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then

		local d=i.Position-dragStart

		frame.Position=UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+d.X,
			startPos.Y.Scale,
			startPos.Y.Offset+d.Y
		)

	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging=false
	end
end)



local title=Instance.new("TextLabel")
title.Text="KML"
title.Size=UDim2.new(1,0,0,30)
title.Parent=frame



local speed=40

local speedText=Instance.new("TextLabel")
speedText.Text="Speed : 40"
speedText.Size=UDim2.new(1,0,0,25)
speedText.Position=UDim2.new(0,0,0.25,0)
speedText.Parent=frame



local plus=Instance.new("TextButton")
plus.Text="+"
plus.Size=UDim2.new(.4,0,0,30)
plus.Position=UDim2.new(.05,0,.45,0)
plus.Parent=frame


local minus=Instance.new("TextButton")
minus.Text="-"
minus.Size=UDim2.new(.4,0,0,30)
minus.Position=UDim2.new(.55,0,.45,0)
minus.Parent=frame



local flyBtn=Instance.new("TextButton")
flyBtn.Text="Fly : OFF"
flyBtn.Size=UDim2.new(1,0,0,30)
flyBtn.Position=UDim2.new(0,0,.65,0)
flyBtn.Parent=frame



local noclipBtn=Instance.new("TextButton")
noclipBtn.Text="Noclip : OFF"
noclipBtn.Size=UDim2.new(1,0,0,30)
noclipBtn.Position=UDim2.new(0,0,.82,0)
noclipBtn.Parent=frame



plus.MouseButton1Click:Connect(function()
	speed += 10
	speedText.Text="Speed : "..speed
end)


minus.MouseButton1Click:Connect(function()
	speed = math.max(10,speed-10)
	speedText.Text="Speed : "..speed
end)



local function noclip(state)

	local char=player.Character

	if char then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = not state
			end
		end
	end
end



local flying=false
local noclipOn=false

local bv
local bg



noclipBtn.MouseButton1Click:Connect(function()

	noclipOn = not noclipOn

	if noclipOn then
		noclipBtn.Text="Noclip : ON"
	else
		noclipBtn.Text="Noclip : OFF"
	end

end)



flyBtn.MouseButton1Click:Connect(function()

	local char=player.Character
	if not char then return end

	local root=char:WaitForChild("HumanoidRootPart")
	local hum=char:WaitForChild("Humanoid")


	flying = not flying


	if flying then

		flyBtn.Text="Fly : ON"

		hum.PlatformStand=true


		bv=Instance.new("BodyVelocity")
		bv.MaxForce=Vector3.new(999999,999999,999999)
		bv.Velocity=Vector3.zero
		bv.Parent=root


		bg=Instance.new("BodyGyro")
		bg.MaxTorque=Vector3.new(999999,999999,999999)
		bg.Parent=root


	else

		flyBtn.Text="Fly : OFF"

		hum.PlatformStand=false


		if bv then bv:Destroy() end
		if bg then bg:Destroy() end

	end

end)



RunService.RenderStepped:Connect(function()

	if noclipOn or flying then
		noclip(true)
	else
		noclip(false)
	end


	if flying and bv and bg then

		local char=player.Character
		if not char then return end

		local root=char:FindFirstChild("HumanoidRootPart")
		local hum=char:FindFirstChild("Humanoid")

		if root and hum then


			local cam=workspace.CurrentCamera

			bg.CFrame=cam.CFrame


			local direction=cam.CFrame.LookVector

			local move=hum.MoveDirection


			if move.Magnitude > 0 then

				bv.Velocity = direction * speed

			else

				-- เปิดแล้วอยู่นิ่ง
				bv.Velocity = Vector3.zero

			end


		end

	end

end)



player.CharacterAdded:Connect(function()

	flying=false
	noclipOn=false

	task.wait(1)

	noclip(false)

end)
