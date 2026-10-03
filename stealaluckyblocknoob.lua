-- Steal a Lucky Block - Zone Selector dari folder "Zones"
-- Gabungan versi simpel + baca data dari workspace.Zones

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ============ STATE ============
local active = false
local basePosition = nil
local speedValue = 100
local heightValue = 60
local selectedZone = nil
local zoneList = {}

-- ============ GUI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoStealGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 420)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.BorderSizePixel = 0
Title.Text = "Auto Steal - Zones"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0, 38)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- ===== SPEED SLIDER =====
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -20, 0, 18)
SpeedLabel.Position = UDim2.new(0, 10, 0, 62)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Kecepatan: 100"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 12
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MainFrame

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Size = UDim2.new(1, -20, 0, 8)
SpeedSlider.Position = UDim2.new(0, 10, 0, 86)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Parent = MainFrame

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(1, 0)
SliderCorner.Parent = SpeedSlider

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.31, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SpeedSlider

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

local SliderKnob = Instance.new("Frame")
SliderKnob.Size = UDim2.new(0, 16, 0, 16)
SliderKnob.Position = UDim2.new(0.31, -8, 0.5, -8)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderKnob.BorderSizePixel = 0
SliderKnob.Parent = SpeedSlider

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1, 0)
KnobCorner.Parent = SliderKnob

-- ===== HEIGHT SLIDER =====
local HeightLabel = Instance.new("TextLabel")
HeightLabel.Size = UDim2.new(1, -20, 0, 18)
HeightLabel.Position = UDim2.new(0, 10, 0, 102)
HeightLabel.BackgroundTransparency = 1
HeightLabel.Text = "Tinggi Terbang: 60"
HeightLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
HeightLabel.Font = Enum.Font.Gotham
HeightLabel.TextSize = 12
HeightLabel.TextXAlignment = Enum.TextXAlignment.Left
HeightLabel.Parent = MainFrame

local HeightSlider = Instance.new("Frame")
HeightSlider.Size = UDim2.new(1, -20, 0, 8)
HeightSlider.Position = UDim2.new(0, 10, 0, 126)
HeightSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
HeightSlider.BorderSizePixel = 0
HeightSlider.Parent = MainFrame

local HSCorner = Instance.new("UICorner")
HSCorner.CornerRadius = UDim.new(1, 0)
HSCorner.Parent = HeightSlider

local HeightFill = Instance.new("Frame")
HeightFill.Size = UDim2.new(0.25, 0, 1, 0)
HeightFill.BackgroundColor3 = Color3.fromRGB(140, 80, 255)
HeightFill.BorderSizePixel = 0
HeightFill.Parent = HeightSlider

local HFCorner = Instance.new("UICorner")
HFCorner.CornerRadius = UDim.new(1, 0)
HFCorner.Parent = HeightFill

local HeightKnob = Instance.new("Frame")
HeightKnob.Size = UDim2.new(0, 16, 0, 16)
HeightKnob.Position = UDim2.new(0.25, -8, 0.5, -8)
HeightKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HeightKnob.BorderSizePixel = 0
HeightKnob.Parent = HeightSlider

local HKCorner = Instance.new("UICorner")
HKCorner.CornerRadius = UDim.new(1, 0)
HKCorner.Parent = HeightKnob

local minSpeed, maxSpeed = 10, 300
local minHeight, maxHeight = 20, 200
local dragSpeed, dragHeight = false, false

local function updateSpeedSlider(inputX)
	local rel = math.clamp((inputX - SpeedSlider.AbsolutePosition.X) / SpeedSlider.AbsoluteSize.X, 0, 1)
	SliderFill.Size = UDim2.new(rel, 0, 1, 0)
	SliderKnob.Position = UDim2.new(rel, -8, 0.5, -8)
	speedValue = math.floor(minSpeed + (maxSpeed - minSpeed) * rel)
	SpeedLabel.Text = "Kecepatan: " .. speedValue
end

local function updateHeightSlider(inputX)
	local rel = math.clamp((inputX - HeightSlider.AbsolutePosition.X) / HeightSlider.AbsoluteSize.X, 0, 1)
	HeightFill.Size = UDim2.new(rel, 0, 1, 0)
	HeightKnob.Position = UDim2.new(rel, -8, 0.5, -8)
	heightValue = math.floor(minHeight + (maxHeight - minHeight) * rel)
	HeightLabel.Text = "Tinggi Terbang: " .. heightValue
end

SpeedSlider.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragSpeed = true
		updateSpeedSlider(input.Position.X)
	end
end)
SpeedSlider.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragSpeed = false
	end
end)

HeightSlider.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragHeight = true
		updateHeightSlider(input.Position.X)
	end
end)
HeightSlider.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragHeight = false
	end
end)

RunService.RenderStepped:Connect(function()
	if dragSpeed or dragHeight then
		local mouse = LocalPlayer:GetMouse()
		if dragSpeed then updateSpeedSlider(mouse.X) end
		if dragHeight then updateHeightSlider(mouse.X) end
	end
end)

-- ===== REFRESH ZONES =====
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(1, -20, 0, 26)
RefreshBtn.Position = UDim2.new(0, 10, 0, 142)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 100)
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Text = "REFRESH ZONES (0)"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 11
RefreshBtn.Parent = MainFrame

local RBCorner = Instance.new("UICorner")
RBCorner.CornerRadius = UDim.new(0, 6)
RBCorner.Parent = RefreshBtn

-- ===== ZONE LIST =====
local ZoneLabel = Instance.new("TextLabel")
ZoneLabel.Size = UDim2.new(1, -20, 0, 16)
ZoneLabel.Position = UDim2.new(0, 10, 0, 172)
ZoneLabel.BackgroundTransparency = 1
ZoneLabel.Text = "Pilih Zone:"
ZoneLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
ZoneLabel.Font = Enum.Font.GothamBold
ZoneLabel.TextSize = 11
ZoneLabel.TextXAlignment = Enum.TextXAlignment.Left
ZoneLabel.Parent = MainFrame

local ZoneScroll = Instance.new("ScrollingFrame")
ZoneScroll.Size = UDim2.new(1, -20, 0, 120)
ZoneScroll.Position = UDim2.new(0, 10, 0, 190)
ZoneScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ZoneScroll.BorderSizePixel = 0
ZoneScroll.ScrollBarThickness = 5
ZoneScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ZoneScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ZoneScroll.Parent = MainFrame

local ZoneCorner = Instance.new("UICorner")
ZoneCorner.CornerRadius = UDim.new(0, 6)
ZoneCorner.Parent = ZoneScroll

local ZoneLayout = Instance.new("UIListLayout")
ZoneLayout.Padding = UDim.new(0, 3)
ZoneLayout.Parent = ZoneScroll

local ZonePad = Instance.new("UIPadding")
ZonePad.PaddingTop = UDim.new(0, 5)
ZonePad.PaddingLeft = UDim.new(0, 5)
ZonePad.PaddingRight = UDim.new(0, 5)
ZonePad.Parent = ZoneScroll

-- ===== BASE BUTTONS =====
local SetBaseBtn = Instance.new("TextButton")
SetBaseBtn.Size = UDim2.new(0.5, -15, 0, 28)
SetBaseBtn.Position = UDim2.new(0, 10, 0, 316)
SetBaseBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 130)
SetBaseBtn.BorderSizePixel = 0
SetBaseBtn.Text = "SET BASE"
SetBaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SetBaseBtn.Font = Enum.Font.GothamBold
SetBaseBtn.TextSize = 11
SetBaseBtn.Parent = MainFrame

local SetBaseCorner = Instance.new("UICorner")
SetBaseCorner.CornerRadius = UDim.new(0, 6)
SetBaseCorner.Parent = SetBaseBtn

local GoBaseBtn = Instance.new("TextButton")
GoBaseBtn.Size = UDim2.new(0.5, -15, 0, 28)
GoBaseBtn.Position = UDim2.new(0.5, 5, 0, 316)
GoBaseBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 130)
GoBaseBtn.BorderSizePixel = 0
GoBaseBtn.Text = "KE BASE"
GoBaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GoBaseBtn.Font = Enum.Font.GothamBold
GoBaseBtn.TextSize = 11
GoBaseBtn.Parent = MainFrame

local GoBaseCorner = Instance.new("UICorner")
GoBaseCorner.CornerRadius = UDim.new(0, 6)
GoBaseCorner.Parent = GoBaseBtn

local BaseLabel = Instance.new("TextLabel")
BaseLabel.Size = UDim2.new(1, -20, 0, 16)
BaseLabel.Position = UDim2.new(0, 10, 0, 348)
BaseLabel.BackgroundTransparency = 1
BaseLabel.Text = "Base: belum di-set"
BaseLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
BaseLabel.Font = Enum.Font.Gotham
BaseLabel.TextSize = 10
BaseLabel.TextXAlignment = Enum.TextXAlignment.Left
BaseLabel.Parent = MainFrame

-- ===== TOGGLE =====
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -20, 0, 32)
ToggleBtn.Position = UDim2.new(0, 10, 0, 370)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "AKTIFKAN"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

-- ============ FLY ============
local flying = false
local bodyVelocity, bodyGyro

local function startFly()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	flying = true
	hrp.Anchored = false

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = hrp

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bodyGyro.P = 10000
	bodyGyro.D = 500
	bodyGyro.Parent = hrp
end

local function stopFly()
	flying = false
	if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
	if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
end

local function flyTo(targetPos, speed, tolerance)
	local char = LocalPlayer.Character
	if not char then return false end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end

	tolerance = tolerance or 4
	local startTime = tick()
	local timeout = 20

	while flying and active do
		local current = hrp.Position
		local diff = targetPos - current
		local dist = diff.Magnitude

		if dist <= tolerance then
			bodyVelocity.Velocity = Vector3.zero
			return true
		end

		if tick() - startTime > timeout then return false end

		local v = diff.Unit * speed
		if dist < 30 then
			v = diff.Unit * math.min(speed, 50)
		end

		bodyVelocity.Velocity = v
		bodyGyro.CFrame = CFrame.new(current, current + diff.Unit)

		RunService.Heartbeat:Wait()
	end
	return false
end

-- ============ TARGET FINDER ============
local function normalize(s)
	return string.lower(s):gsub("[^%w]", "")
end

local function isEggSpot(part)
	if not part or not part:IsA("BasePart") then return false end
	return normalize(part.Name):find("eggspot") ~= nil
end

local function hasProximityPrompt(part)
	if not part or not part:IsA("BasePart") then return false end
	return part:FindFirstChildOfClass("ProximityPrompt") ~= nil
end

local function isLocalCharacter(part)
	local char = LocalPlayer.Character
	if not char then return false end
	return part:IsDescendantOf(char)
end

-- ============ READ ZONES FROM FOLDER ============
local function getZoneFolder()
	-- cari folder bernama "Zones" / "Zone" di workspace
	for _, obj in ipairs(workspace:GetChildren()) do
		local n = normalize(obj.Name)
		if n == "zones" or n == "zone" then
			return obj
		end
	end
	return nil
end

local function getZonePosition(zoneObj)
	if not zoneObj then return nil end
	if zoneObj:IsA("Model") and zoneObj.PrimaryPart then
		return zoneObj.PrimaryPart.Position
	elseif zoneObj:IsA("Model") then
		local ok, cf = pcall(function() return zoneObj:GetModelCFrame() end)
		if ok and cf then return cf.Position end
		-- fallback: ambil posisi part pertama
		for _, c in ipairs(zoneObj:GetChildren()) do
			if c:IsA("BasePart") then return c.Position end
		end
	elseif zoneObj:IsA("BasePart") then
		return zoneObj.Position
	end
	return nil
end

local function detectZones()
	local result = {}
	local folder = getZoneFolder()
	if not folder then
		return result, "Folder 'Zones' gak ketemu di workspace"
	end

	for _, zoneObj in ipairs(folder:GetChildren()) do
		local pos = getZonePosition(zoneObj)
		if pos then
			table.insert(result, {
				name = zoneObj.Name,
				center = pos,
				object = zoneObj,
			})
		end
	end

	return result, nil
end

local function renderZones()
	for _, c in ipairs(ZoneScroll:GetChildren()) do
		if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
	end

	local err
	zoneList, err = detectZones()
	RefreshBtn.Text = "REFRESH ZONES (" .. #zoneList .. ")"

	if err or #zoneList == 0 then
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1, -10, 0, 40)
		lbl.BackgroundTransparency = 1
		lbl.Text = err or "Gak ada zone di folder Zones"
		lbl.TextColor3 = Color3.fromRGB(255, 120, 120)
		lbl.Font = Enum.Font.Gotham
		lbl.TextSize = 11
		lbl.TextWrapped = true
		lbl.Parent = ZoneScroll
		return
	end

	for i, z in ipairs(zoneList) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -10, 0, 26)
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
		btn.BorderSizePixel = 0
		btn.Text = string.format("%d. %s", i, z.name)
		btn.TextColor3 = Color3.fromRGB(220, 220, 220)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 10
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.Parent = ZoneScroll

		local bc = Instance.new("UICorner")
		bc.CornerRadius = UDim.new(0, 5)
		bc.Parent = btn

		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0, 8)
		pad.Parent = btn

		btn.MouseButton1Click:Connect(function()
			selectedZone = z
			for _, other in ipairs(ZoneScroll:GetChildren()) do
				if other:IsA("TextButton") then
					other.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
				end
			end
			btn.BackgroundColor3 = Color3.fromRGB(80, 140, 80)
			StatusLabel.Text = "Status: zone dipilih → " .. z.name
			StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
		end)
	end
end

RefreshBtn.MouseButton1Click:Connect(renderZones)

-- ============ STEAL ============
local function performSteal(part)
	if not part then return end
	local prompt = part:FindFirstChildOfClass("ProximityPrompt")
	if prompt then
		pcall(function() fireproximityprompt(prompt) end)
		return
	end
	prompt = part:FindFirstChildWhichIsA("ProximityPrompt", true)
	if prompt then
		pcall(function() fireproximityprompt(prompt) end)
	end
end

-- cari eggspot di sekitar zone yang dipilih
local function findEggSpotInZone(zonePos, maxRange)
	local char = LocalPlayer.Character
	if not char then return nil end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	local closest, closestDist = nil, math.huge
	maxRange = maxRange or 500

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and not isLocalCharacter(obj) then
			local isTarget = isEggSpot(obj) or hasProximityPrompt(obj)
			if isTarget then
				local zoneDist = (obj.Position - zonePos).Magnitude
				if zoneDist <= maxRange then
					local d = (obj.Position - hrp.Position).Magnitude
					if d < closestDist then
						closest = obj
						closestDist = d
					end
				end
			end
		end
	end
	return closest
end

-- ============ MAIN LOOP ============
local function mainLoop()
	while active do
		if not selectedZone then
			StatusLabel.Text = "Pilih zone dulu!"
			StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
			task.wait(0.5)
		else
			local target = findEggSpotInZone(selectedZone.center, 500)

			if target and active then
				-- 1. naik tinggi ke atas target
				StatusLabel.Text = "Status: naik tinggi..."
				StatusLabel.TextColor3 = Color3.fromRGB(255, 220, 80)

				local highPos = Vector3.new(target.Position.X, target.Position.Y + heightValue, target.Position.Z)
				flyTo(highPos, speedValue, 5)

				-- 2. turun ke target
				if active then
					StatusLabel.Text = "Status: turun ke " .. target.Name
					StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
					local reached = flyTo(target.Position + Vector3.new(0, 2, 0), speedValue, 4)

					if reached and active then
						StatusLabel.Text = "Status: stealing..."
						StatusLabel.TextColor3 = Color3.fromRGB(80, 200, 255)
						for i = 1, 3 do
							performSteal(target)
							task.wait(0.15)
						end
					end
				end

				-- 3. balik base
				if basePosition and active then
					StatusLabel.Text = "Status: kembali ke base..."
					StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 80)
					flyTo(basePosition, speedValue, 4)
				end
			else
				StatusLabel.Text = "Status: nyari EggSpot di " .. selectedZone.name .. "..."
				StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 100)
			end
		end
		task.wait(0.5)
	end
end

-- ============ BUTTON HANDLERS ============
SetBaseBtn.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	basePosition = hrp.Position
	BaseLabel.Text = string.format("Base: (%.0f, %.0f, %.0f)", basePosition.X, basePosition.Y, basePosition.Z)
end)

GoBaseBtn.MouseButton1Click:Connect(function()
	if not basePosition then
		BaseLabel.Text = "Base belum di-set!"
		return
	end
	startFly()
	task.spawn(function()
		StatusLabel.Text = "Status: menuju base..."
		StatusLabel.TextColor3 = Color3.fromRGB(80, 200, 255)
		flyTo(basePosition, speedValue, 4)
		stopFly()
	end)
end)

ToggleBtn.MouseButton1Click:Connect(function()
	active = not active
	if active then
		if not selectedZone then
			StatusLabel.Text = "Pilih zone dulu!"
			StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
			active = false
			return
		end
		ToggleBtn.Text = "MATIKAN"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
		StatusLabel.Text = "Status: ON"
		StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
				startFly()
		task.spawn(mainLoop)
	else
		ToggleBtn.Text = "AKTIFKAN"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
		StatusLabel.Text = "Status: OFF"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
		stopFly()
	end
end)

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	if active then startFly() end
end)

-- auto detect zones pas start
task.wait(1)
pcall(renderZones)
