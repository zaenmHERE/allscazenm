--[[
    Zen Hub — Murder Mystery 2 (FINAL v4)
    Sidebar nav, wider hub, custom minimize logo
    Fitur: ESP, Friend, Teleport, Auto Coin, Movement, Auto Shoot,
           Hidden ke atap, Keybind, Notification, Config Save/Load,
           Auto Win, Anti-AFK, FPS Boost, Server Hop, Player Info
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

------------------------------------------------------------
-- KONFIG
------------------------------------------------------------
local Config = {
    ESP = true,
    ESPColor = {
        Murder   = Color3.fromRGB(255, 70, 70),
        Sheriff  = Color3.fromRGB(80, 160, 255),
        Innocent = Color3.fromRGB(80, 255, 140),
        Hero     = Color3.fromRGB(255, 215, 0),
        Friend   = Color3.fromRGB(80, 180, 255),
    },
    Friends = {},
    AutoCoin = false,
    AutoShoot = false,
    AutoWin = false,
    AntiAFK = true,
    Movement = { Enabled = false, WalkSpeed = 32, JumpPower = 80 },
    Hidden = false,
    HiddenOffsetY = 200,
    MinimizeLogo = "Z",
}

local Theme = {
    BgDark    = Color3.fromRGB(12, 18, 30),
    BgMid     = Color3.fromRGB(20, 30, 48),
    BgLight   = Color3.fromRGB(32, 48, 72),
    Accent    = Color3.fromRGB(80, 160, 255),
    AccentDim = Color3.fromRGB(40, 90, 150),
    Text      = Color3.fromRGB(220, 235, 255),
    TextDim   = Color3.fromRGB(140, 170, 210),
    Red       = Color3.fromRGB(200, 70, 70),
}

------------------------------------------------------------
-- HELPER
------------------------------------------------------------
local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Accent
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.4
    s.Parent = parent
    return s
end

------------------------------------------------------------
-- GUI ROOT
------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ZButton = Instance.new("TextButton")
ZButton.Size = UDim2.new(0, 48, 0, 48)
ZButton.Position = UDim2.new(0, 20, 0, 100)
ZButton.BackgroundColor3 = Theme.BgDark
ZButton.BackgroundTransparency = 0.15
ZButton.BorderSizePixel = 0
ZButton.Text = Config.MinimizeLogo
ZButton.TextColor3 = Theme.Accent
ZButton.Font = Enum.Font.GothamBold
ZButton.TextSize = 22
ZButton.Visible = false
ZButton.Active = true
ZButton.Draggable = true
ZButton.Parent = ScreenGui
corner(ZButton, 14)
stroke(ZButton, Theme.Accent, 1.5, 0.3)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 420, 0, 360)
Main.Position = UDim2.new(0, 20, 0, 100)
Main.BackgroundColor3 = Theme.BgDark
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
corner(Main, 14)
stroke(Main, Theme.Accent, 1, 0.5)

local grad = Instance.new("UIGradient")
grad.Rotation = 90
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.BgMid),
    ColorSequenceKeypoint.new(1, Theme.BgDark),
})
grad.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BackgroundColor3 = Theme.BgMid
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.Parent = Main
corner(Header, 14)

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, -100, 1, 0)
HeaderLabel.Position = UDim2.new(0, 14, 0, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "Zen Hub"
HeaderLabel.TextColor3 = Theme.Accent
HeaderLabel.Font = Enum.Font.GothamBold
HeaderLabel.TextSize = 16
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = Header

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 28, 0, 24)
MinButton.Position = UDim2.new(1, -66, 0, 6)
MinButton.BackgroundColor3 = Theme.BgLight
MinButton.BackgroundTransparency = 0.3
MinButton.BorderSizePixel = 0
MinButton.Text = "—"
MinButton.TextColor3 = Theme.Text
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 14
MinButton.Parent = Header
corner(MinButton, 6)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 24)
CloseButton.Position = UDim2.new(1, -34, 0, 6)
CloseButton.BackgroundColor3 = Theme.Red
CloseButton.BackgroundTransparency = 0.4
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 12
CloseButton.Parent = Header
corner(CloseButton, 6)

MinButton.MouseButton1Click:Connect(function()
    Main.Visible = false
    ZButton.Visible = true
    ZButton.Position = Main.Position
    ZButton.Text = Config.MinimizeLogo
end)

ZButton.MouseButton1Click:Connect(function()
    Main.Visible = true
    ZButton.Visible = false
    Main.Position = ZButton.Position
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

------------------------------------------------------------
-- SIDEBAR NAV
------------------------------------------------------------
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 100, 1, -48)
Sidebar.Position = UDim2.new(0, 8, 0, 44)
Sidebar.BackgroundColor3 = Theme.BgMid
Sidebar.BackgroundTransparency = 0.35
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
corner(Sidebar, 10)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 6)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 10)
SidePadding.Parent = Sidebar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -124, 1, -48)
ContentFrame.Position = UDim2.new(0, 116, 0, 44)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = Main

local tabs = {}

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 30)
    btn.BackgroundColor3 = Theme.BgLight
    btn.BackgroundTransparency = 0.4
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Theme.TextDim
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.Parent = Sidebar
    corner(btn, 8)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Theme.AccentDim
    page.Visible = false
    page.Parent = ContentFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    tabs[name] = { button = btn, page = page }

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.page.Visible = false
            t.button.TextColor3 = Theme.TextDim
            t.button.BackgroundColor3 = Theme.BgLight
            t.button.BackgroundTransparency = 0.4
        end
        page.Visible = true
        btn.TextColor3 = Theme.Accent
        btn.BackgroundColor3 = Theme.AccentDim
        btn.BackgroundTransparency = 0.2
    end)

    return page
end

------------------------------------------------------------
-- UI HELPERS
------------------------------------------------------------
local function makeToggle(parent, text, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 30)
    btn.BackgroundColor3 = Theme.BgMid
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = "  " .. text
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    corner(btn, 6)

    local state = default
    local function refresh()
        btn.TextColor3 = state and Theme.Accent or Theme.TextDim
    end
    refresh()

    btn.MouseButton1Click:Connect(function()
        state = not state
        refresh()
        callback(state)
    end)

    return btn
end

local function makeSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 46)
    frame.BackgroundColor3 = Theme.BgMid
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent
    corner(frame, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -16, 0, 8)
    bar.Position = UDim2.new(0, 8, 0, 30)
    bar.BackgroundColor3 = Theme.BgLight
    bar.BorderSizePixel = 0
    bar.Parent = frame
    corner(bar, 4)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = bar
    corner(fill, 4)

    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * rel)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        label.Text = text .. ": " .. val
        callback(val)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return frame
end

local function makeTextBox(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 50)
    frame.BackgroundColor3 = Theme.BgMid
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent
    corner(frame, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, 16)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -16, 0, 24)
    box.Position = UDim2.new(0, 8, 0, 22)
    box.BackgroundColor3 = Theme.BgLight
    box.BackgroundTransparency = 0.3
    box.BorderSizePixel = 0
    box.Text = default
    box.TextColor3 = Theme.Text
    box.PlaceholderText = "ketik di sini..."
    box.PlaceholderColor3 = Theme.TextDim
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.ClearTextOnFocus = false
    box.Parent = frame
    corner(box, 5)

    box.FocusLost:Connect(function()
        callback(box.Text)
    end)

    return frame
end

------------------------------------------------------------
-- NOTIFICATION
------------------------------------------------------------
local notifFrame = Instance.new("Frame")
notifFrame.Size = UDim2.new(0, 240, 0, 36)
notifFrame.Position = UDim2.new(0.5, -120, 0, -50)
notifFrame.BackgroundColor3 = Theme.BgDark
notifFrame.BackgroundTransparency = 0.15
notifFrame.BorderSizePixel = 0
notifFrame.ZIndex = 100
notifFrame.Parent = ScreenGui
corner(notifFrame, 8)
stroke(notifFrame, Theme.Accent, 1, 0.3)

local notifLabel = Instance.new("TextLabel")
notifLabel.Size = UDim2.new(1, -16, 1, 0)
notifLabel.Position = UDim2.new(0, 8, 0, 0)
notifLabel.BackgroundTransparency = 1
notifLabel.Text = ""
notifLabel.TextColor3 = Theme.Text
notifLabel.Font = Enum.Font.Gotham
notifLabel.TextSize = 12
notifLabel.ZIndex = 101
notifLabel.Parent = notifFrame

local notifToken = 0
local function notify(text)
    notifToken = notifToken + 1
    local myToken = notifToken
    notifLabel.Text = text
    TweenService:Create(notifFrame, TweenInfo.new(0.3), { Position = UDim2.new(0.5, -120, 0, 20) }):Play()
    task.delay(2, function()
        if myToken == notifToken then
            TweenService:Create(notifFrame, TweenInfo.new(0.3), { Position = UDim2.new(0.5, -120, 0, -50) }):Play()
        end
    end)
end

------------------------------------------------------------
-- ROLE
------------------------------------------------------------
local function getRole(plr)
    local char = plr.Character
    if not char then return "Innocent" end
    for _, tag in ipairs(char:GetChildren()) do
        if tag:IsA("ObjectValue") or tag:IsA("StringValue") then
            local n = tag.Name:lower()
            if n:find("murder") then return "Murder" end
            if n:find("sheriff") then return "Sheriff" end
            if n:find("hero") then return "Hero" end
        end
    end
    local bp = plr:FindFirstChild("Backpack")
    if bp then
        if bp:FindFirstChild("Knife") then return "Murder" end
        if bp:FindFirstChild("Gun") or bp:FindFirstChild("Revolver") then return "Sheriff" end
    end
    return "Innocent"
end

------------------------------------------------------------
-- ESP
------------------------------------------------------------
local espFolder = Instance.new("Folder")
espFolder.Name = "ZenHub_ESP"
espFolder.Parent = Workspace

local espCache = {}

local function createESP(plr)
    local box = Instance.new("Highlight")
    box.FillTransparency = 0.6
    box.OutlineTransparency = 0
    box.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    box.Parent = espFolder

    local label = Instance.new("BillboardGui")
    label.Size = UDim2.new(0, 130, 0, 22)
    label.StudsOffset = Vector3.new(0, 3, 0)
    label.AlwaysOnTop = true
    label.Parent = espFolder

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Font = Enum.Font.GothamBold
    text.TextSize = 12
    text.TextStrokeTransparency = 0
    text.Parent = label

    return box, label, text
end

local function updateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        if not espCache[plr] then
            local box, label, text = createESP(plr)
            espCache[plr] = { box = box, label = label, text = text }
        end

        local data = espCache[plr]
        local isFriend = Config.Friends[plr.UserId]
        local role = getRole(plr)
        local color = isFriend and Config.ESPColor.Friend or (Config.ESPColor[role] or Config.ESPColor.Innocent)

        data.box.Adornee = char
        data.box.FillColor = color
        data.box.OutlineColor = color
        data.box.FillTransparency = isFriend and 0.8 or 0.6
        data.box.Enabled = Config.ESP

        data.label.Adornee = hrp
        data.label.Enabled = Config.ESP
        data.text.Text = string.format("%s [%s]%s", plr.Name, role, isFriend and " ★" or "")
        data.text.TextColor3 = color
    end

    for plr, data in pairs(espCache) do
        if not plr.Parent or not plr.Character then
            data.box:Destroy()
            data.label:Destroy()
            espCache[plr] = nil
        end
    end
end

------------------------------------------------------------
-- HIDDEN KE ATAP
------------------------------------------------------------
local function findRoofPosition()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local origin = hrp.Position
    local bestY = origin.Y
    local bestPos = origin

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj ~= hrp then
            local dist = (obj.Position - origin).Magnitude
            if dist < 150 and obj.Position.Y > bestY then
                local top = obj.Position + Vector3.new(0, obj.Size.Y / 2 + 3, 0)
                if top.Y > bestY and top.Y < origin.Y + Config.HiddenOffsetY then
                    bestY = top.Y
                    bestPos = top
                end
            end
        end
    end

    if bestY > origin.Y + 5 then
        return bestPos
    end

    return origin + Vector3.new(0, Config.HiddenOffsetY, 0)
end

local function setHidden(state)
    Config.Hidden = state
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if state then
        local target = findRoofPosition()
        if target then
            hrp.Anchored = false
            local tween = TweenService:Create(
                hrp,
                TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { CFrame = CFrame.new(target) }
            )
            tween:Play()
            tween.Completed:Connect(function()
                if Config.Hidden then hrp.Anchored = true end
            end)
        end
    else
        hrp.Anchored = false
        hrp.CFrame = CFrame.new(hrp.Position.X, 5, hrp.Position.Z)
    end
end

------------------------------------------------------------
-- TELEPORT DROPDOWN
------------------------------------------------------------
local tpFrame = Instance.new("ScrollingFrame")
tpFrame.Size = UDim2.new(0, 200, 0, 140)
tpFrame.Position = UDim2.new(0, 20, 0, 480)
tpFrame.BackgroundColor3 = Theme.BgDark
tpFrame.BackgroundTransparency = 0.1
tpFrame.BorderSizePixel = 0
tpFrame.Visible = false
tpFrame.ZIndex = 50
tpFrame.ScrollBarThickness = 4
tpFrame.ScrollBarImageColor3 = Theme.AccentDim
tpFrame.Active = true
tpFrame.Draggable = true
tpFrame.Parent = ScreenGui
corner(tpFrame, 8)
stroke(tpFrame, Theme.Accent, 1, 0.4)

local tpHeader = Instance.new("TextLabel")
tpHeader.Size = UDim2.new(1, 0, 0, 24)
tpHeader.BackgroundColor3 = Theme.BgMid
tpHeader.BackgroundTransparency = 0.2
tpHeader.BorderSizePixel = 0
tpHeader.Text = "Teleport"
tpHeader.TextColor3 = Theme.Accent
tpHeader.Font = Enum.Font.GothamBold
tpHeader.TextSize = 12
tpHeader.ZIndex = 51
tpHeader.Parent = tpFrame
corner(tpHeader, 8)

local tpList = Instance.new("Frame")
tpList.Size = UDim2.new(1, 0, 1, -26)
tpList.Position = UDim2.new(0, 0, 0, 26)
tpList.BackgroundTransparency = 1
tpList.ZIndex = 51
tpList.Parent = tpFrame

local tpLayout = Instance.new("UIListLayout")
tpLayout.Padding = UDim.new(0, 4)
tpLayout.Parent = tpList

local function teleportTo(plr)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstCarChild("HumanoidRootPart")
    local target = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp and target then
        hrp.CFrame = target.CFrame * CFrame.new(0, 0, 3)
    end
end

local function refreshTPList()
    for _, c in ipairs(tpList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -8, 0, 22)
        b.BackgroundColor3 = Theme.BgLight
        b.BackgroundTransparency = 0.4
        b.BorderSizePixel = 0
        b.Text = "  " .. plr.Name
        b.TextColor3 = Theme.Text
        b.Font = Enum.Font.Gotham
        b.TextSize = 11
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.ZIndex = 52
        b.Parent = tpList
        corner(b, 5)
        b.MouseButton1Click:Connect(function() teleportTo(plr) end)
    end
end

------------------------------------------------------------
-- AUTO COIN
------------------------------------------------------------
local function isCoin(obj)
    if not obj or not obj:IsA("BasePart") then return false end
    local n = obj.Name:lower()
    return n == "coin" or n:find("coin")
end

local function getAllCoins()
    local list = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isCoin(obj) then table.insert(list, obj) end
    end
    return list
end

local collectMode = firetouchinterest and 1 or 3

RunService.Heartbeat:Connect(function()
    if not Config.AutoCoin then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp then return end

    local coins = getAllCoins()
    if #coins == 0 then return end
    table.sort(coins, function(a, b)
        return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
    end)
    local coin = coins[1]
    if not coin then return end

    if collectMode == 1 and firetouchinterest then
        pcall(function()
            firetouchinterest(hrp, coin, 0)
            task.wait()
            firetouchinterest(hrp, coin, 1)
        end)
    elseif collectMode == 2 then
        hrp.CFrame = coin.CFrame
    else
        if hum then hum:MoveTo(coin.Position) end
    end
end)

------------------------------------------------------------
-- MOVEMENT
------------------------------------------------------------
local function applyMovement()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = Config.Movement.Enabled and Config.Movement.WalkSpeed or 16
        hum.JumpPower = Config.Movement.Enabled and Config.Movement.JumpPower or 50
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    applyMovement()
end)

------------------------------------------------------------
-- AUTO SHOOT
------------------------------------------------------------
local function getMurder()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and getRole(plr) == "Murder" and not Config.Friends[plr.UserId] then
            return plr
        end
    end
    return nil
end

local function getEquippedGun()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("revolver")) then
            return tool
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if not Config.AutoShoot then return end
    if getRole(LocalPlayer) ~= "Sheriff" then return end
    local murder = getMurder()
    if not murder or not murder.Character then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = murder.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not targetHRP then return end
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHRP.Position)
    local gun = getEquippedGun()
    if gun then pcall(function() gun:Activate() end) end
end)

------------------------------------------------------------
-- AUTO WIN
------------------------------------------------------------
local function getInnocent()
    local best, bestDist = nil, math.huge
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and getRole(plr) ~= "Murder" and not Config.Friends[plr.UserId] then
            local t = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if t then
                local d = (t.Position - hrp.Position).Magnitude
                if d < bestDist then
                    bestDist = d
                    best = plr
                end
            end
        end
    end
    return best
end

RunService.Heartbeat:Connect(function()
    if not Config.AutoWin then return end
    if getRole(LocalPlayer) ~= "Murder" then return end
    local target = getInnocent()
    if not target or not target.Character then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if hrp and tHRP then
        hrp.CFrame = tHRP.CFrame * CFrame.new(0, 0, 2)
    end
end)

------------------------------------------------------------
-- ANTI-AFK
------------------------------------------------------------
LocalPlayer.Idled:Connect(function()
    if not Config.AntiAFK then return end
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

------------------------------------------------------------
-- FPS BOOST
------------------------------------------------------------
local function applyFPSBoost(state)
    if state then
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end
        end
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
    else
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end)
    end
end

------------------------------------------------------------
-- SERVER HOP
------------------------------------------------------------
local function serverHop()
    local placeId = game.PlaceId
    local ok, result = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
    end)
    if ok and result then
        local data = HttpService:JSONDecode(result)
        for _, srv in ipairs(data.data) do
            if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(placeId, srv.id, LocalPlayer)
                return
            end
        end
        notify("Server penuh semua")
    else
        notify("Gagal ambil server list")
    end
end

------------------------------------------------------------
-- MUSIC
------------------------------------------------------------
local SoundService = game:GetService("SoundService")

local Music = {
    sound = nil,
    volume = 0.5,
    loop = true,
    playing = false,
    currentId = "",
    playlist = {},
    currentIndex = 0,
}

local function ensureSound()
    if Music.sound and Music.sound.Parent then return Music.sound end
    local s = Instance.new("Sound")
    s.Name = "ZenHub_Music"
    s.Volume = Music.volume
    s.Looped = Music.loop
    s.Parent = SoundService
    Music.sound = s
    return s
end

local function playSound(id)
    if not id or id == "" then
        notify("Sound ID kosong")
        return
    end
    local s = ensureSound()
    Music.currentId = tostring(id)
    s.SoundId = "rbxassetid://" .. Music.currentId
    s.Volume = Music.volume
    s.Looped = Music.loop
    local ok, err = pcall(function() s:Play() end)
    if ok then
        Music.playing = true
        notify("Muter: " .. Music.currentId)
    else
        notify("Gagal muter: " .. tostring(err))
    end
end

local function stopSound()
    if Music.sound then
        Music.sound:Stop()
        Music.playing = false
        notify("Musik distop")
    end
end

local function pauseSound()
    if Music.sound then
        Music.sound:Pause()
        Music.playing = false
        notify("Musik dipause")
    end
end

local function resumeSound()
    if Music.sound and Music.currentId ~= "" then
        Music.sound:Resume()
        Music.playing = true
        notify("Musik dilanjut")
    end
end

local function nextTrack()
    if #Music.playlist == 0 then
        notify("Playlist kosong")
        return
    end
    Music.currentIndex = Music.currentIndex + 1
    if Music.currentIndex > #Music.playlist then
        Music.currentIndex = 1
    end
    playSound(Music.playlist[Music.currentIndex])
end

local function prevTrack()
    if #Music.playlist == 0 then
        notify("Playlist kosong")
        return
    end
    Music.currentIndex = Music.currentIndex - 1
    if Music.currentIndex < 1 then
        Music.currentIndex = #Music.playlist
    end
    playSound(Music.playlist[Music.currentIndex])
end

------------------------------------------------------------
-- CONFIG SAVE / LOAD
------------------------------------------------------------
local CONFIG_PATH = "zenhub_config.json"

local function saveConfig()
    local data = {
        ESP = Config.ESP,
        AutoCoin = Config.AutoCoin,
        AutoShoot = Config.AutoShoot,
        AutoWin = Config.AutoWin,
        AntiAFK = Config.AntiAFK,
        Movement = Config.Movement,
        MinimizeLogo = Config.MinimizeLogo,
        Music = {
            volume = Music.volume,
            loop = Music.loop,
            currentId = Music.currentId,
            playlist = Music.playlist,
        },
    }
    if writefile then
        writefile(CONFIG_PATH, HttpService:JSONEncode(data))
        notify("Config disimpan")
    else
        notify("Executor nggak support writefile")
    end
end

local function loadConfig()
    if isfile and isfile(CONFIG_PATH) then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_PATH))
        end)
        if ok and data then
            Config.ESP = data.ESP or Config.ESP
            Config.AutoCoin = data.AutoCoin or Config.AutoCoin
            Config.AutoShoot = data.AutoShoot or Config.AutoShoot
            Config.AutoWin = data.AutoWin or Config.AutoWin
            Config.AntiAFK = data.AntiAFK ~= nil and data.AntiAFK or Config.AntiAFK
            Config.Movement = data.Movement or Config.Movement
            Config.MinimizeLogo = data.MinimizeLogo or Config.MinimizeLogo
            if data.Music then
                Music.volume = data.Music.volume or Music.volume
                Music.loop = data.Music.loop ~= nil and data.Music.loop or Music.loop
                Music.currentId = data.Music.currentId or Music.currentId
                Music.playlist = data.Music.playlist or Music.playlist
            end
            ZButton.Text = Config.MinimizeLogo
            notify("Config dimuat")
        end
    end
end

loadConfig()

------------------------------------------------------------
-- KEYBIND
------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        Main.Visible = not Main.Visible
        if not Main.Visible then
            ZButton.Visible = true
            ZButton.Position = Main.Position
        else
            ZButton.Visible = false
        end
    elseif input.KeyCode == Enum.KeyCode.F2 then
        Config.ESP = not Config.ESP
        notify("ESP: " .. (Config.ESP and "ON" or "OFF"))
    elseif input.KeyCode == Enum.KeyCode.F3 then
        setHidden(not Config.Hidden)
        notify("Hidden: " .. (Config.Hidden and "ON" or "OFF"))
    elseif input.KeyCode == Enum.KeyCode.F4 then
        if Music.playing then pauseSound() else resumeSound() end
    end
end)

------------------------------------------------------------
-- TAB: ESP
------------------------------------------------------------
local espPage = createTab("ESP")
makeToggle(espPage, "Enable ESP", Config.ESP, function(v) Config.ESP = v end)

------------------------------------------------------------
-- TAB: FRIENDS
------------------------------------------------------------
local friendPage = createTab("Friends")
local friendList = Instance.new("Frame")
friendList.Size = UDim2.new(1, -8, 0, 240)
friendList.BackgroundColor3 = Theme.BgMid
friendList.BackgroundTransparency = 0.3
friendList.BorderSizePixel = 0
friendList.Parent = friendPage
corner(friendList, 6)

local flLayout = Instance.new("UIListLayout")
flLayout.Padding = UDim.new(0, 4)
flLayout.Parent = friendList

local function refreshFriendList()
    for _, c in ipairs(friendList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -8, 0, 24)
        b.BackgroundColor3 = Config.Friends[plr.UserId] and Theme.AccentDim or Theme.BgLight
        b.BackgroundTransparency = 0.4
        b.BorderSizePixel = 0
        b.Text = "  " .. plr.Name .. (Config.Friends[plr.UserId] and "  ★" or "")
        b.TextColor3 = Theme.Text
        b.Font = Enum.Font.Gotham
        b.TextSize = 11
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.Parent = friendList
        corner(b, 5)
        b.MouseButton1Click:Connect(function()
            Config.Friends[plr.UserId] = not Config.Friends[plr.UserId]
            refreshFriendList()
            notify(plr.Name .. (Config.Friends[plr.UserId] and " ditambah" or " dihapus"))
        end)
    end
end

------------------------------------------------------------
-- TAB: PLAYER
------------------------------------------------------------
local tpPage = createTab("Player")
makeToggle(tpPage, "Teleport Menu", false, function(v)
    tpFrame.Visible = v
    if v then refreshTPList() end
end)

------------------------------------------------------------
-- TAB: INFO
------------------------------------------------------------
local infoPage = createTab("Info")
local infoList = Instance.new("Frame")
infoList.Size = UDim2.new(1, -8, 0, 260)
infoList.BackgroundColor3 = Theme.BgMid
infoList.BackgroundTransparency = 0.3
infoList.BorderSizePixel = 0
infoList.Parent = infoPage
corner(infoList, 6)

local infoLayout = Instance.new("UIListLayout")
infoLayout.Padding = UDim.new(0, 4)
infoLayout.Parent = infoList

local function refreshInfoList()
    for _, c in ipairs(infoList:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local role = getRole(plr)
        local dist = "?"
        if hrp and plr.Character then
            local t = plr.Character:FindFirstChild("HumanoidRootPart")
            if t then dist = math.floor((t.Position - hrp.Position).Magnitude) .. " studs" end
        end
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -8, 0, 22)
        lbl.BackgroundTransparency = 1
        lbl.Text = string.format("  %s  [%s]  %s", plr.Name, role, dist)
        lbl.TextColor3 = Config.ESPColor[role] or Theme.Text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = infoList
    end
end

task.spawn(function()
    while task.wait(1) do
        if tabs["Info"] and tabs["Info"].page.Visible then
            refreshInfoList()
        end
    end
end)

------------------------------------------------------------
-- TAB: MISC
------------------------------------------------------------
local miscPage = createTab("Misc")
makeToggle(miscPage, "Auto Coin", Config.AutoCoin, function(v) Config.AutoCoin = v; notify("Auto Coin: " .. (v and "ON" or "OFF")) end)
makeToggle(miscPage, "Auto Shoot", Config.AutoShoot, function(v) Config.AutoShoot = v; notify("Auto Shoot: " .. (v and "ON" or "OFF")) end)
makeToggle(miscPage, "Auto Win (Murder)", Config.AutoWin, function(v) Config.AutoWin = v; notify("Auto Win: " .. (v and "ON" or "OFF")) end)
makeToggle(miscPage, "Movement Enabled", Config.Movement.Enabled, function(v)
    Config.Movement.Enabled = v
    applyMovement()
end)
makeToggle(miscPage, "Hidden (ke atap)", Config.Hidden, function(v) setHidden(v) end)
makeToggle(miscPage, "Anti-AFK", Config.AntiAFK, function(v) Config.AntiAFK = v end)
makeToggle(miscPage, "FPS Boost", false, function(v) applyFPSBoost(v); notify("FPS Boost: " .. (v and "ON" or "OFF")) end)

makeSlider(miscPage, "WalkSpeed", 16, 200, Config.Movement.WalkSpeed, function(v)
    Config.Movement.WalkSpeed = v
    applyMovement()
end)

makeSlider(miscPage, "JumpPower", 50, 300, Config.Movement.JumpPower, function(v)
    Config.Movement.JumpPower = v
    applyMovement()
end)

local hopBtn = Instance.new("TextButton")
hopBtn.Size = UDim2.new(1, -8, 0, 30)
hopBtn.BackgroundColor3 = Theme.AccentDim
hopBtn.BackgroundTransparency = 0.3
hopBtn.BorderSizePixel = 0
hopBtn.Text = "Server Hop"
hopBtn.TextColor3 = Theme.Text
hopBtn.Font = Enum.Font.GothamBold
hopBtn.TextSize = 12
hopBtn.Parent = miscPage
corner(hopBtn, 6)
hopBtn.MouseButton1Click:Connect(function()
    notify("Nyari server...")
    serverHop()
end)

------------------------------------------------------------
-- TAB: MUSIC
------------------------------------------------------------
local musicPage = createTab("Music")

makeTextBox(musicPage, "Sound ID (contoh: 1837879082)", "", function(text)
    Music.currentId = text
end)

local musicBtnRow = Instance.new("Frame")
musicBtnRow.Size = UDim2.new(1, -8, 0, 30)
musicBtnRow.BackgroundTransparency = 1
musicBtnRow.Parent = musicPage

local musicBtnLayout = Instance.new("UIListLayout")
musicBtnLayout.FillDirection = Enum.FillDirection.Horizontal
musicBtnLayout.Padding = UDim.new(0, 4)
musicBtnLayout.Parent = musicBtnRow

local function makeMusicBtn(text, width, color, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, width, 1, 0)
    b.BackgroundColor3 = color
    b.BackgroundTransparency = 0.3
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Theme.Text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.Parent = musicBtnRow
    corner(b, 6)
    b.MouseButton1Click:Connect(callback)
    return b
end

makeMusicBtn("Play", 70, Theme.AccentDim, function() playSound(Music.currentId) end)
makeMusicBtn("Stop", 70, Theme.BgLight, stopSound)
makeMusicBtn("Pause", 70, Theme.BgLight, pauseSound)
makeMusicBtn("Resume", 70, Theme.AccentDim, resumeSound)

local navRow = Instance.new("Frame")
navRow.Size = UDim2.new(1, -8, 0, 30)
navRow.BackgroundTransparency = 1
navRow.Parent = musicPage

local navLayout = Instance.new("UIListLayout")
navLayout.FillDirection = Enum.FillDirection.Horizontal
navLayout.Padding = UDim.new(0, 4)
navLayout.Parent = navRow

local function makeNavBtn(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 100, 1, 0)
    b.BackgroundColor3 = Theme.BgLight
    b.BackgroundTransparency = 0.3
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Theme.Text
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.Parent = navRow
    corner(b, 6)
    b.MouseButton1Click:Connect(callback)
    return b
end

makeNavBtn("◀ Prev", prevTrack)
makeNavBtn("Next ▶", nextTrack)

makeSlider(musicPage, "Volume", 0, 100, Music.volume * 100, function(v)
    Music.volume = v / 100
    if Music.sound then Music.sound.Volume = Music.volume end
end)

makeToggle(musicPage, "Loop", Music.loop, function(v)
    Music.loop = v
    if Music.sound then Music.sound.Looped = v end
end)

local playlistFrame = Instance.new("Frame")
playlistFrame.Size = UDim2.new(1, -8, 0, 160)
playlistFrame.BackgroundColor3 = Theme.BgMid
playlistFrame.BackgroundTransparency = 0.3
playlistFrame.BorderSizePixel = 0
playlistFrame.Parent = musicPage
corner(playlistFrame, 6)

local plLabel = Instance.new("TextLabel")
plLabel.Size = UDim2.new(1, -12, 0, 18)
plLabel.Position = UDim2.new(0, 8, 0, 4)
plLabel.BackgroundTransparency = 1
plLabel.Text = "Playlist"
plLabel.TextColor3 = Theme.Accent
plLabel.Font = Enum.Font.GothamBold
plLabel.TextSize = 12
plLabel.TextXAlignment = Enum.TextXAlignment.Left
plLabel.Parent = playlistFrame

local plList = Instance.new("Frame")
plList.Size = UDim2.new(1, -8, 1, -28)
plList.Position = UDim2.new(0, 4, 0, 24)
plList.BackgroundTransparency = 1
plList.Parent = playlistFrame

local plLayout = Instance.new("UIListLayout")
plLayout.Padding = UDim.new(0, 3)
plLayout.Parent = plList

local function refreshPlaylist()
    for _, c in ipairs(plList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for i, id in ipairs(Music.playlist) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -4, 0, 22)
        b.BackgroundColor3 = (i == Music.currentIndex) and Theme.AccentDim or Theme.BgLight
        b.BackgroundTransparency = 0.4
        b.BorderSizePixel = 0
        b.Text = "  " .. i .. ". " .. id
        b.TextColor3 = Theme.Text
        b.Font = Enum.Font.Gotham
        b.TextSize = 11
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.Parent = plList
        corner(b, 5)
        b.MouseButton1Click:Connect(function()
            Music.currentIndex = i
            playSound(id)
            refreshPlaylist()
        end)
    end
end

local addRow = Instance.new("Frame")
addRow.Size = UDim2.new(1, -8, 0, 30)
addRow.BackgroundTransparency = 1
addRow.Parent = musicPage

local addLayout = Instance.new("UIListLayout")
addLayout.FillDirection = Enum.FillDirection.Horizontal
addLayout.Padding = UDim.new(0, 4)
addLayout.Parent = addRow

local addBox = Instance.new("TextBox")
addBox.Size = UDim2.new(0, 160, 1, 0)
addBox.BackgroundColor3 = Theme.BgLight
addBox.BackgroundTransparency = 0.3
addBox.BorderSizePixel = 0
addBox.PlaceholderText = "id lagu..."
addBox.PlaceholderColor3 = Theme.TextDim
addBox.Text = ""
addBox.TextColor3 = Theme.Text
addBox.Font = Enum.Font.Gotham
addBox.TextSize = 12
addBox.ClearTextOnFocus = false
addBox.Parent = addRow
corner(addBox, 6)

local addBtn = Instance.new("TextButton")
addBtn.Size = UDim2.new(0, 60, 1, 0)
addBtn.BackgroundColor3 = Theme.AccentDim
addBtn.BackgroundTransparency = 0.3
addBtn.BorderSizePixel = 0
addBtn.Text = "Tambah"
addBtn.TextColor3 = Theme.Text
addBtn.Font = Enum.Font.GothamBold
addBtn.TextSize = 12
addBtn.Parent = addRow
corner(addBtn, 6)
addBtn.MouseButton1Click:Connect(function()
    if addBox.Text ~= "" then
        table.insert(Music.playlist, addBox.Text)
        addBox.Text = ""
        refreshPlaylist()
        notify("Lagu ditambah ke playlist")
    end
end)

------------------------------------------------------------
-- TAB: CUSTOM
------------------------------------------------------------
local customPage = createTab("Custom")

makeTextBox(customPage, "Logo Minimize", Config.MinimizeLogo, function(text)
    Config.MinimizeLogo = text ~= "" and text or "Z"
    ZButton.Text = Config.MinimizeLogo
    notify("Logo: " .. Config.MinimizeLogo)
end)

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(1, -8, 0, 30)
saveBtn.BackgroundColor3 = Theme.AccentDim
saveBtn.BackgroundTransparency = 0.3
saveBtn.BorderSizePixel = 0
saveBtn.Text = "Simpan Config"
saveBtn.TextColor3 = Theme.Text
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 12
saveBtn.Parent = customPage
corner(saveBtn, 6)
saveBtn.MouseButton1Click:Connect(saveConfig)

local loadBtn = Instance.new("TextButton")
loadBtn.Size = UDim2.new(1, -8, 0, 30)
loadBtn.BackgroundColor3 = Theme.BgLight
loadBtn.BackgroundTransparency = 0.3
loadBtn.BorderSizePixel = 0
loadBtn.Text = "Muat Config"
loadBtn.TextColor3 = Theme.Text
loadBtn.Font = Enum.Font.GothamBold
loadBtn.TextSize = 12
loadBtn.Parent = customPage
corner(loadBtn, 6)
loadBtn.MouseButton1Click:Connect(function()
    loadConfig()
    applyMovement()
end)

------------------------------------------------------------
-- INIT
------------------------------------------------------------
tabs["ESP"].page.Visible = true
tabs["ESP"].button.TextColor3 = Theme.Accent
tabs["ESP"].button.BackgroundColor3 = Theme.AccentDim
tabs["ESP"].button.BackgroundTransparency = 0.2

refreshPlaylist()

RunService.RenderStepped:Connect(updateESP)

Players.PlayerAdded:Connect(function()
    refreshTPList()
    refreshFriendList()
end)

Players.PlayerRemoving:Connect(function(plr)
    if espCache[plr] then
        espCache[plr].box:Destroy()
        espCache[plr].label:Destroy()
        espCache[plr] = nil
    end
    refreshTPList()
    refreshFriendList()
end)

refreshFriendList()
refreshTPList()

notify("Zen Hub loaded")
print("[Zen Hub] v4 loaded.")
