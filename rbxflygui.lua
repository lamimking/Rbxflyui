local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- Variables
local flying = false
local currentSpeed = 50
local bv, bg

-- 1. MAIN UI SETUP
local main = Instance.new("ScreenGui")
main.Name = "MainUI"
main.Parent = pgui
main.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Parent = main
frame.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
frame.BackgroundTransparency = 0.2
frame.Position = UDim2.new(0.5, -95, 0.5, -105)
frame.Size = UDim2.new(0, 190, 0, 210)
frame.Active = true
frame.Draggable = true

-- Speed Display
local speedShow = Instance.new("TextLabel")
speedShow.Size = UDim2.new(0, 70, 0, 25)
speedShow.Position = UDim2.new(0, 5, 0, 5)
speedShow.BackgroundColor3 = Color3.new(0,0,0)
speedShow.BackgroundTransparency = 0.6
speedShow.TextColor3 = Color3.new(1,1,1)
speedShow.Text = "SPD: " .. currentSpeed
speedShow.Parent = frame

-- Close Button (X)
local closeX = Instance.new("TextButton")
closeX.Size = UDim2.new(0, 25, 0, 25)
closeX.Position = UDim2.new(1, -30, 0, 5)
closeX.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
closeX.Text = "X"
closeX.TextColor3 = Color3.new(1,1,1)
closeX.Parent = frame

-- 2. BUTTONS GRID
local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(1, 0, 0.6, 0)
btnContainer.Position = UDim2.new(0, 0, 0.18, 0)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = frame

local grid = Instance.new("UIGridLayout")
grid.Parent = btnContainer
grid.CellSize = UDim2.new(0, 80, 0, 50)
grid.CellPadding = UDim2.new(0, 8, 0, 8)
grid.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createBtn(txt, color)
	local b = Instance.new("TextButton")
	b.Text = txt
	b.BackgroundColor3 = color
	b.Font = Enum.Font.SourceSansBold
	b.Parent = btnContainer
	return b
end

local flyBtn = createBtn("FLY", Color3.fromRGB(255, 170, 0))
local plusBtn = createBtn("+", Color3.fromRGB(165, 124, 105))
local minusBtn = createBtn("-", Color3.fromRGB(0, 170, 255))
local advBtn = createBtn("/", Color3.fromRGB(85, 255, 127))

-- 3. THE ADVANCE (SET SPEED) WINDOW
local advFrame = Instance.new("Frame")
advFrame.Size = UDim2.new(0, 140, 0, 90)
advFrame.Position = UDim2.new(1.05, 0, 0, 0)
advFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
advFrame.Visible = false -- Hidden until / is clicked
advFrame.Parent = frame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.9, 0, 0.4, 0)
speedInput.Position = UDim2.new(0.05, 0, 0.1, 0)
speedInput.PlaceholderText = "Enter Speed"
speedInput.Text = ""
speedInput.Parent = advFrame

local setBtn = Instance.new("TextButton")
setBtn.Size = UDim2.new(0.9, 0, 0.4, 0)
setBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
setBtn.Text = "SET"
setBtn.BackgroundColor3 = Color3.new(0, 0.7, 0)
setBtn.Parent = advFrame

-- 4. CONFIRM EXIT WINDOW
local confirmWin = Instance.new("Frame")
confirmWin.Size = UDim2.new(0, 150, 0, 80)
confirmWin.Position = UDim2.new(0.5, -75, 0.5, -40)
confirmWin.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
confirmWin.Visible = false
confirmWin.Parent = main

local yesBtn = Instance.new("TextButton")
yesBtn.Size = UDim2.new(0.4, 0, 0.4, 0)
yesBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
yesBtn.Text = "YES"
yesBtn.BackgroundColor3 = Color3.new(0.7, 0, 0)
yesBtn.Parent = confirmWin

local noBtn = Instance.new("TextButton")
noBtn.Size = UDim2.new(0.4, 0, 0.4, 0)
noBtn.Position = UDim2.new(0.55, 0, 0.5, 0)
noBtn.Text = "NO"
noBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
noBtn.Parent = confirmWin

-- 5. LOGIC & BUTTON CLICKS
local function updateSpeedUI(val)
	currentSpeed = math.clamp(val, 1, 1000)
	speedShow.Text = "SPD: " .. currentSpeed
end

plusBtn.MouseButton1Click:Connect(function() updateSpeedUI(currentSpeed + 10) end)
minusBtn.MouseButton1Click:Connect(function() updateSpeedUI(currentSpeed - 10) end)

-- FIX: Make "/" open the window
advBtn.MouseButton1Click:Connect(function()
	advFrame.Visible = not advFrame.Visible
end)

setBtn.MouseButton1Click:Connect(function()
	local n = tonumber(speedInput.Text)
	if n then updateSpeedUI(n) end
	advFrame.Visible = false
end)

-- Exit Logic
closeX.MouseButton1Click:Connect(function() confirmWin.Visible = true end)
noBtn.MouseButton1Click:Connect(function() confirmWin.Visible = false end)
yesBtn.MouseButton1Click:Connect(function() main:Destroy() end)

-- Toggle Fly
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if flying and root then
		flyBtn.Text = "ON"
		bg = Instance.new("BodyGyro", root)
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bv = Instance.new("BodyVelocity", root)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		char.Humanoid.PlatformStand = true
	else
		flyBtn.Text = "FLY"
		if bg then bg:Destroy() end
		if bv then bv:Destroy() end
		if char then char.Humanoid.PlatformStand = false end
	end
end)

-- 6. IMPROVED MOVEMENT (Up/Down by looking)
RunService.RenderStepped:Connect(function()
	if flying and bv and bg and player.Character then
		local hum = player.Character:FindFirstChild("Humanoid")
		local cam = workspace.CurrentCamera
		
		if hum and hum.MoveDirection.Magnitude > 0 then
			-- Instead of hum.MoveDirection (which is flat), we use the Camera's LookVector
			-- This allows you to fly UP by looking UP and DOWN by looking DOWN
			bv.velocity = cam.CFrame.LookVector * currentSpeed
		else
			bv.velocity = Vector3.new(0, 0, 0)
		end
		bg.cframe = cam.CFrame
	end
end)

-- Credit Bar (Bottom)
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, -20, 0, 40)
credit.Position = UDim2.new(0, 10, 1, -45)
credit.BackgroundColor3 = Color3.fromRGB(255, 45, 70)
credit.Text = "Credit @Lamimking"
credit.TextColor3 = Color3.new(1,1,1)
credit.Parent = frame