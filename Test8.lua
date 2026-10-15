-- file: main.lua, target: Roblox MM2, executor: Delta (mobile)
-- CapybaraMM2 v6.1 — Silent Aim + ESP
-- loadstring(game:HttpGet("URL"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

for _, n in ipairs({"CapybaraMM2"}) do
    if game.CoreGui:FindFirstChild(n) then game.CoreGui[n]:Destroy() end
    if LP:FindFirstChild(n) then LP[n]:Destroy() end
end

local function mk(cls, props, parent)
    local o = Instance.new(cls)
    for k, v in pairs(props) do o[k] = v end
    o.Parent = parent
    return o
end

local gui = mk("ScreenGui", {
    Name = "CapybaraMM2", ResetOnSpawn = false,
    IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, game.CoreGui)

local icon = mk("TextButton", {
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(0, 15, 0.5, -20),
    BackgroundColor3 = Color3.fromRGB(25, 25, 35),
    Text = "C", TextColor3 = Color3.fromRGB(220, 80, 80),
    Font = Enum.Font.GothamBold, TextSize = 16,
    BorderSizePixel = 0, AutoButtonColor = false
}, gui)
mk("UICorner", {CornerRadius = UDim.new(0, 10)}, icon)
mk("UIStroke", {Color = Color3.fromRGB(220, 80, 80), Thickness = 2}, icon)

local frame = mk("Frame", {
    Size = UDim2.new(0, 240, 0, 300),
    Position = UDim2.new(0.5, -120, 0.5, -150),
    BackgroundColor3 = Color3.fromRGB(18, 18, 24),
    BorderSizePixel = 0, Active = true, Visible = false
}, gui)
mk("UICorner", {CornerRadius = UDim.new(0, 10)}, frame)
mk("UIStroke", {Color = Color3.fromRGB(60, 60, 80), Thickness = 1}, frame)

mk("TextLabel", {
    Size = UDim2.new(1, -36, 0, 26), Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1, Text = "CapybaraMM2",
    TextColor3 = Color3.fromRGB(230, 230, 235),
    Font = Enum.Font.GothamBold, TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left
}, frame)

local close = mk("TextButton", {
    Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -28, 0, 2),
    BackgroundColor3 = Color3.fromRGB(200, 60, 60), Text = "X",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold, TextSize = 12, BorderSizePixel = 0
}, frame)
mk("UICorner", {CornerRadius = UDim.new(0, 5)}, close)

local scroll = mk("ScrollingFrame", {
    Size = UDim2.new(1, -16, 1, -38), Position = UDim2.new(0, 8, 0, 32),
    BackgroundColor3 = Color3.fromRGB(26, 26, 32), BorderSizePixel = 0,
    ScrollBarThickness = 4, CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y
}, frame)
mk("UICorner", {CornerRadius = UDim.new(0, 6)}, scroll)
mk("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, scroll)
mk("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}, scroll)

local function addToggle(text, default, cb)
    local on = default or false
    local b = mk("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = on and Color3.fromRGB(55, 125, 85) or Color3.fromRGB(40, 40, 50),
        Text = text .. ": " .. (on and "ON" or "OFF"),
        TextColor3 = Color3.fromRGB(220, 220, 230),
        Font = Enum.Font.Gotham, TextSize = 11, BorderSizePixel = 0
    }, scroll)
    mk("UICorner", {CornerRadius = UDim.new(0, 5)}, b)
    b.MouseButton1Click:Connect(function()
        on = not on
        b.BackgroundColor3 = on and Color3.fromRGB(55, 125, 85) or Color3.fromRGB(40, 40, 50)
        b.Text = text .. ": " .. (on and "ON" or "OFF")
        if cb then cb(on) end
    end)
    return b
end

local function addSlider(text, minV, maxV, default, cb)
    local holder = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0
    }, scroll)
    mk("UICorner", {CornerRadius = UDim.new(0, 5)}, holder)

    local lbl = mk("TextLabel", {
        Size = UDim2.new(1, -10, 0, 16), Position = UDim2.new(0, 5, 0, 2),
        BackgroundTransparency = 1,
        Text = text .. ": " .. default,
        TextColor3 = Color3.fromRGB(220, 220, 230),
        Font = Enum.Font.Gotham, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, holder)

    local bar = mk("Frame", {
        Size = UDim2.new(1, -20, 0, 8), Position = UDim2.new(0, 10, 0, 24),
        BackgroundColor3 = Color3.fromRGB(20, 20, 26),
        BorderSizePixel = 0
    }, holder)
    mk("UICorner", {CornerRadius = UDim.new(0, 4)}, bar)

    local fill = mk("Frame", {
        Size = UDim2.new((default - minV) / (maxV - minV), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(80, 160, 220),
        BorderSizePixel = 0
    }, bar)
    mk("UICorner", {CornerRadius = UDim.new(0, 4)}, fill)

    local dragging = false
    local function update(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(minV + rel * (maxV - minV))
        fill.Size = UDim2.new(rel, 0, 1, 0)
        lbl.Text = text .. ": " .. val
        if cb then cb(val) end
    end

    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; update(i.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then
            update(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return holder
end

local function makeDraggable(handle, target, onShortClick)
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    local DRAG_THRESHOLD = 6
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; moved = false
            dragStart = i.Position; startPos = target.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement
        and i.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = i.Position - dragStart
        if math.abs(d.X) > DRAG_THRESHOLD or math.abs(d.Y) > DRAG_THRESHOLD then
            moved = true
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if not dragging then return end
        if i.UserInputType ~= Enum.UserInputType.MouseButton1
        and i.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = false
        if not moved and onShortClick then onShortClick() end
    end)
end

makeDraggable(icon, icon, function() frame.Visible = true; icon.Visible = false end)
makeDraggable(frame, frame, nil)

close.MouseButton1Click:Connect(function()
    frame.Visible = false; icon.Visible = true
end)

-- ===== ROLES =====
local function roleOf(p)
    if not p or not p.Character then return "innocent" end
    local bp, ch = p:FindFirstChild("Backpack"), p.Character
    if (bp and bp:FindFirstChild("Knife")) or ch:FindFirstChild("Knife") then
        return "murderer"
    end
    if (bp and bp:FindFirstChild("Gun")) or ch:FindFirstChild("Gun") then
        return "sheriff"
    end
    return "innocent"
end

local COLORS = {
    murderer = Color3.fromRGB(255, 60, 60),
    sheriff  = Color3.fromRGB(60, 140, 255),
    innocent = Color3.fromRGB(60, 220, 90)
}

-- ===== ESP (ВХ) =====
local espOn = false
local drawings = {}

local function makeDrawing(player)
    if drawings[player] then return end
    local line = Drawing.new("Line")
    line.Thickness = 1.5; line.Transparency = 1; line.Visible = false
    local label = Drawing.new("Text")
    label.Size = 13; label.Center = true; label.Outline = true
    label.OutlineColor = Color3.fromRGB(0, 0, 0); label.Visible = false
    drawings[player] = {line = line, label = label, hl = nil}
end

local function removeDrawing(player)
    local d = drawings[player]
    if not d then return end
    if d.line then d.line:Remove() end
    if d.label then d.label:Remove() end
    if d.hl then d.hl:Destroy() end
    drawings[player] = nil
end

local function updateESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then
            if drawings[p] then removeDrawing(p) end
        else
            makeDrawing(p)
            local d = drawings[p]
            local ch = p.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            local head = ch and ch:FindFirstChild("Head")
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if not espOn or not hrp or not head or not hum or hum.Health <= 0 then
                d.line.Visible = false; d.label.Visible = false
                if d.hl then d.hl.Enabled = false end
            else
                local role = roleOf(p)
                local color = COLORS[role]
                local headPos, onScreen = Cam:WorldToViewportPoint(head.Position)
                local rootPos = Cam:WorldToViewportPoint(hrp.Position)
                local dist = math.floor((Cam.CFrame.Position - hrp.Position).Magnitude)
                local screenBottom = Vector2.new(rootPos.X, Cam.ViewportSize.Y)
                if onScreen then
                    d.line.From = screenBottom
                    d.line.To = Vector2.new(headPos.X, headPos.Y)
                    d.line.Color = color; d.line.Visible = true
                    d.label.Text = p.Name .. " | " .. role .. " | " .. dist .. "m"
                    d.label.Position = Vector2.new(headPos.X, headPos.Y - 18)
                    d.label.Color = color; d.label.Visible = true
                else
                    d.line.Visible = false; d.label.Visible = false
                end
                if d.hl and d.hl.Adornee ~= ch then
                    d.hl:Destroy(); d.hl = nil
                end
                if not d.hl then
                    d.hl = Instance.new("Highlight")
                    d.hl.Adornee = ch
                    d.hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    d.hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    d.hl.Parent = ch
                end
                d.hl.FillColor = color
                d.hl.Enabled = true
            end
        end
    end
end

Players.PlayerRemoving:Connect(removeDrawing)
addToggle("ESP (ВХ)", false, function(s)
    espOn = s
    if not s then
        for _, p in ipairs(Players:GetPlayers()) do
            local d = drawings[p]
            if d then
                d.line.Visible = false; d.label.Visible = false
                if d.hl then d.hl.Enabled = false end
            end
        end
    end
end)
RunService.RenderStepped:Connect(updateESP)

-- ===== SILENT AIM =====
local silentAimOn = false

local function getMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and roleOf(p) == "murderer" then
            local ch = p.Character
            if ch then
                local hum = ch:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then return p end
            end
        end
    end
    return nil
end

local hooked = false
local function setupHook()
    if hooked then return true end
    if not hookmetamethod or not getrawmetatable then return false end
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if silentAimOn and method == "Activate" and self and self.Name == "Gun" then
            local murderer = getMurderer()
            if murderer and murderer.Character then
                local mHead = murderer.Character:FindFirstChild("Head")
                if mHead then
                    local camPos = Cam.CFrame.Position
                    Cam.CFrame = CFrame.new(camPos, mHead.Position)
                    local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if myHrp then
                        myHrp.CFrame = CFrame.new(
                            myHrp.Position,
                            Vector3.new(mHead.Position.X, myHrp.Position.Y, mHead.Position.Z)
                        )
                    end
                end
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
    hooked = true
    return true
end

local lastAim = 0
UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if not silentAimOn then return end
    if i.UserInputType ~= Enum.UserInputType.Touch
    and i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if tick() - lastAim < 0.15 then return end
    lastAim = tick()

    local murderer = getMurderer()
    if not murderer or not murderer.Character then return end
    local mHead = murderer.Character:FindFirstChild("Head")
    if not mHead then return end

    local camPos = Cam.CFrame.Position
    Cam.CFrame = CFrame.new(camPos, mHead.Position)
    local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if myHrp then
        myHrp.CFrame = CFrame.new(
            myHrp.Position,
            Vector3.new(mHead.Position.X, myHrp.Position.Y, mHead.Position.Z)
        )
    end
end)

addToggle("Silent Aim (в убийцу)", false, function(s)
    silentAimOn = s
    if s then setupHook() end
end)

local aimCircle = Drawing.new("Circle")
aimCircle.Thickness = 1.5
aimCircle.Color = Color3.fromRGB(255, 60, 60)
aimCircle.Transparency = 0.8
aimCircle.Filled = false
aimCircle.NumSides = 60
aimCircle.Visible = false

RunService.RenderStepped:Connect(function()
    aimCircle.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
    aimCircle.Radius = 200
    aimCircle.Visible = silentAimOn
end)

UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        if frame.Visible then
            frame.Visible = false; icon.Visible = true
        else
            frame.Visible = true; icon.Visible = false
        end
    end
end)

print("[CapybaraMM2 v6.1] loaded. ESP + Silent Aim.")
