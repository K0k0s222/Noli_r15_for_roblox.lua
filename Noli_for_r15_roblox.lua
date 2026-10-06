-- ============================================
--  OBSERVANT GUI — v116
--  Save только по кнопке SAVE POSITIONS
--  + Chase Theme ON/OFF (1.4x)
-- ============================================

if _G.NoliTPTool then pcall(function() _G.NoliTPTool:Destroy() end) end
if _G.NoliTPModeGui then pcall(function() _G.NoliTPModeGui:Destroy() end) end
if _G.ObservantPunchGui then pcall(function() _G.ObservantPunchGui:Destroy() end) end
if _G.NoliGlitchGui then pcall(function() _G.NoliGlitchGui:Destroy() end) end
if _G.NoliVoidChargeGui then pcall(function() _G.NoliVoidChargeGui:Destroy() end) end
if _G.NoliVoidTextGui then pcall(function() _G.NoliVoidTextGui:Destroy() end) end
if _G.ObservantTeleportFolder then pcall(function() _G.ObservantTeleportFolder:Destroy() end) end
if _G.ObservantTPOverlayGui then pcall(function() _G.ObservantTPOverlayGui:Destroy() end) end
if _G.ObservantSoundFolder then pcall(function() _G.ObservantSoundFolder:Destroy() end) end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Screen = Camera.ViewportSize
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local function sc(v) return math.floor(v * (Screen.Y / 1080) * (isMobile and 1.9 or 1.2)) end

-- ============================================
--  НАСТРОЙКИ
-- ============================================
local EMOTE_PRAY    = 95606815249621
local EMOTE_FAST    = 4272351660
local EMOTE_HANDSUP = 108894965141226
local EMOTE_BOOM    = 10370934040
local EMOTE_PUNCH   = 110361063508944
local EMOTE_VOID    = 119380285634530
local EMOTE_CHARGE  = 16392120020
local EMOTE_BUMP    = 90814587101830
local EMOTE_FALL    = 100959333337151

local ANIM_IDLE   = "rbxassetid://112724398873969"
local ANIM_RUN    = "rbxassetid://90175656540190"

local FADE_PRAY       = 0.4
local FADE_IDLE_RUN   = 0.3
local FADE_CHAIN      = 0.3
local FADE_STOP       = 0.35
local FADE_PUNCH      = 0.15
local FADE_VOID       = 0.2
local FADE_CHARGE     = 0.2

local IDLE_WEIGHT     = 1.0
local RUN_WEIGHT      = 1.0
local IDLE_WEIGHT_MOV = 0.25
local RUN_WEIGHT_IDLE = 0.001

local WALK_SPEED    = 0.6
local DEFAULT_WALK  = 16
local RUN_WALK      = 28.5
local RUN_ANIM_SPEED= 1.0
local PRAY_SPEED    = 1.3
local PRAY_WEIGHT   = 0.55

local FAST_TIME          = 0.8
local FAST_ANIM_SPEED    = 0.6
local HANDSUP_TIME       = 0.4
local HANDSUP_ANIM_SPEED = 1.0
local BOOM_TIME          = 0.35
local BOOM_ANIM_SPEED    = 1.0

local PUNCH_DEBOUNCE = 0.3

local VOID_SPEED     = 50
local VOID_MAX_TIME  = 5
local VOID_DEBOUNCE  = 0.5
local VOID_HIT_RANGE = 4.0

local WALL_GRACE_TIME     = 0.1
local WALL_RAY_DISTANCE   = 3.0
local WALL_MOVE_RATIO     = 0.35
local WALL_CHECK_INTERVAL = 0.05

local CHARGE_FREEZE_TIME = 0.5
local CHARGE_SLOW_SPEED  = 0.02
local CHARGE_FAST_TURN   = 0.15
local CHARGE_TOTAL_TIME  = 1.0
local CHARGE_ROTATION    = 40

local BUMP_SPEED = 7.5
local FALL_SPEED = 0.2

local STAR_ROT_CHARGE  = 30
local STAR_ROT_FLIGHT  = 300

local TP_CUBE_SIZE        = 4
local TP_CUBE_DISTANCE    = 12
local TP_CUBE_ROT_SPEED   = 0.35
local TP_CUBE_COLOR       = Color3.fromRGB(170, 60, 255)
local TP_CUBE_OUTLINE     = Color3.fromRGB(220, 160, 255)
local TP_MARKER_SIZE      = 76

local HEALTH_GUARD_INTERVAL = 0.05

local TP_OFFSET     = 0.5
local TAP_MAX_DIST  = 15
local TAP_MAX_TIME  = 0.5

local GLITCH_DURATION     = 2.0
local GLITCH_LINE_COUNT   = 30
local GLITCH_LINE_THICK   = 0.08
local GLITCH_TRANSPARENCY = 0.95
local GLITCH_COLOR        = Color3.fromRGB(160, 0, 255)

local BAR_COLOR_NORMAL = Color3.fromRGB(60, 20, 100)
local BAR_COLOR_FILL   = Color3.fromRGB(255, 255, 255)
local BAR_COLOR_HIT    = Color3.fromRGB(70, 220, 110)
local BAR_COLOR_CRASH  = Color3.fromRGB(220, 60, 60)
local BAR_FADE_TIME    = 0.5

-- 🎵 CHASE THEME
local CHASE_SOUND_ID = "rbxassetid://127672367782566"
local CHASE_SPEED    = 1.4
local CHASE_VOLUME   = 2

-- 📝 ТЕКСТЫ
local TEXTS_CHARGE = {
    "Charging Void Rush... don't breathe.",
    "Hold it. Hold it. HOLD IT.",
    "Here we go again...",
    "You feel that? That's me.",
    "Shhh... it's coming.",
}

local TEXTS_FLIGHT = {
    "driving in my car...",
    "Let go if you dare.",
    "Too late to back out now.",
    "Say goodbye to your kneecaps.",
    "I'm already gone.",
    "Catch me if you can.",
}

local TEXTS_HIT = {
    "hell yeah >:)",
    "Wrong place, wrong time.",
    "Boop.",
    "Lights out.",
    "Sweet dreams.",
}

local TEXTS_WALL = {
    "Aw shuks",
    "ought",
    "NOOO >:$",
    "owwwww ;(",
    "My leg! MY LEG!",
}

local TEXTS_TIMEOUT = {
    "why so rude:(",
    "damn T_T",
    "too slow",
    "...awkward.",
    "Running on empty.",
}

local TEXTS_CANCEL = {
    "ok <;(",
    "Awww :(",
    "Changed my mind.",
    "Nope. Nope. Nope.",
    "Chickened out.",
    "Not today.",
}

local TEXTS_NOT_ENOUGH = {
    "you didn't charge it long enough <:((",
    "Patience, child.",
    "Almost had it.",
    "Try holding it longer.",
}

local function pickRandom(pool)
    if not pool or #pool == 0 then return "" end
    return pool[math.random(1, #pool)]
end

local C = {
    bg = Color3.fromRGB(14, 14, 20), bg2 = Color3.fromRGB(22, 22, 32), bg3 = Color3.fromRGB(34, 34, 48),
    line = Color3.fromRGB(50, 50, 70), accent = Color3.fromRGB(100, 180, 255), accent2 = Color3.fromRGB(200, 120, 255),
    text = Color3.fromRGB(235, 235, 245), sub = Color3.fromRGB(130, 130, 160),
    green = Color3.fromRGB(70, 190, 110), red = Color3.fromRGB(220, 70, 80), gold = Color3.fromRGB(230, 190, 70),
    charge = BAR_COLOR_NORMAL, chargeBg = Color3.fromRGB(40, 10, 60),
}

-- ============================================
--  💾 SAVE/LOAD (только по кнопке)
-- ============================================
local SAVE_FILE = "observant_gui_save.json"
local saveTargets = {}

local function encodeUDim2(u)
    return {XS = u.X.Scale, XO = u.X.Offset, YS = u.Y.Scale, YO = u.Y.Offset}
end

local function decodeUDim2(t)
    if type(t) ~= "table" then return nil end
    return UDim2.new(t.XS or 0, t.XO or 0, t.YS or 0, t.YO or 0)
end

local function doSave()
    if not writefile then return end
    local data = {}
    for key, obj in pairs(saveTargets) do
        if obj then
            data[key] = encodeUDim2(obj.Position)
        end
    end
    pcall(function()
        writefile(SAVE_FILE, HttpService:JSONEncode(data))
    end)
end

local function doLoad()
    if not (isfile and readfile) then return end
    if not isfile(SAVE_FILE) then return end
    local ok, raw = pcall(readfile, SAVE_FILE)
    if not ok or not raw or raw == "" then return end
    local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok2 or type(data) ~= "table" then return end
    for key, t in pairs(data) do
        local obj = saveTargets[key]
        if obj then
            local pos = decodeUDim2(t)
            if pos then obj.Position = pos end
        end
    end
end

-- ============================================
--  БАЗОВЫЕ ФУНКЦИИ
-- ============================================
local function getHum()
    local char = LP.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function getHRP()
    local char = LP.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function getAnimator()
    local hum = getHum()
    if not hum then return nil end
    return hum:FindFirstChildOfClass("Animator")
end

local function silenceAnimate()
    local char = LP.Character
    if not char then return end
    local a = char:FindFirstChild("Animate")
    if a and a:IsA("BaseScript") then
        a.Disabled = true
    end
end

-- ============================================
--  FORCE FIELD
-- ============================================
local currentFF = nil

local function enableForceField()
    if currentFF then return end
    local char = LP.Character
    if not char then return end
    local ff = Instance.new("ForceField")
    ff.Name = "NoliFlingShield"
    ff.Visible = false
    ff.Parent = char
    currentFF = ff
end

local function disableForceField()
    if currentFF then
        pcall(function() currentFF:Destroy() end)
        currentFF = nil
    end
end

-- ============================================
--  🛡 HEALTH GUARD
-- ============================================
local healthGuardActive = false
local healthGuardThread = nil
local savedBreakJoints = nil

local function enableHealthGuard()
    if healthGuardActive then return end
    healthGuardActive = true

    local hum = getHum()
    if hum then
        savedBreakJoints = hum.BreakJointsOnDeath
        pcall(function() hum.BreakJointsOnDeath = false end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        pcall(function() hum.Health = hum.MaxHealth end)
    end

    healthGuardThread = task.spawn(function()
        while healthGuardActive do
            local h = getHum()
            if h then
                if h.Health < h.MaxHealth then
                    pcall(function() h.Health = h.MaxHealth end)
                end
                local creator = h:FindFirstChild("creator")
                if creator then
                    pcall(function() creator:Destroy() end)
                end
            end
            task.wait(HEALTH_GUARD_INTERVAL)
        end
    end)
end

local function disableHealthGuard()
    if not healthGuardActive then return end
    healthGuardActive = false

    if healthGuardThread then
        pcall(function() task.cancel(healthGuardThread) end)
        healthGuardThread = nil
    end

    local hum = getHum()
    if hum then
        if savedBreakJoints ~= nil then
            pcall(function() hum.BreakJointsOnDeath = savedBreakJoints end)
            savedBreakJoints = nil
        end
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
    end
end

-- ============================================
--  🎨 noliGlitch
-- ============================================
local activeGlitch = nil

local function noliGlitch(duration)
    duration = duration or GLITCH_DURATION

    if activeGlitch then
        pcall(function()
            if activeGlitch.cleanup then activeGlitch.cleanup() end
        end)
        activeGlitch = nil
    end

    local char = LP.Character
    if not char then return end

    local glitchState = {
        highlight = nil,
        originalTransparency = {},
        cleanup = nil,
        pool = {},
    }

    local highlight = Instance.new("Highlight")
    highlight.Name = "NoliGlitchHL"
    highlight.Adornee = char
    highlight.FillColor = GLITCH_COLOR
    highlight.OutlineColor = Color3.fromRGB(255, 200, 255)
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 1
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.Parent = CoreGui
    glitchState.highlight = highlight

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            glitchState.originalTransparency[part] = part.Transparency
        end
    end

    local lineFolder = Instance.new("Folder")
    lineFolder.Name = "NoliGlitchLines"
    lineFolder.Parent = workspace
    glitchState.lineFolder = lineFolder

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        pcall(function() highlight:Destroy() end)
        lineFolder:Destroy()
        return
    end

    for i = 1, GLITCH_LINE_COUNT do
        local line = Instance.new("Part")
        line.Name = "GlitchLine"
        line.Anchored = true
        line.CanCollide = false
        line.CanQuery = false
        line.CanTouch = false
        line.Material = Enum.Material.SmoothPlastic
        line.Color = Color3.fromRGB(0, 0, 0)
        line.Size = Vector3.new(1, GLITCH_LINE_THICK, 1)
        line.Transparency = 1
        line.CFrame = CFrame.new(hrp.Position)
        line.Parent = lineFolder
        table.insert(glitchState.pool, line)
    end

    local startTime = tick()
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        if not c or c ~= char then
            if glitchState.cleanup then glitchState.cleanup() end
            return
        end

        local h = c:FindFirstChild("HumanoidRootPart")
        if not h then return end

        local elapsed = tick() - startTime
        local intensity = math.clamp(elapsed / duration, 0, 1)

        local activeLines = math.floor(GLITCH_LINE_COUNT * intensity)
        for i, line in ipairs(glitchState.pool) do
            if line and line.Parent then
                if i <= activeLines then
                    line.CFrame = CFrame.new(h.Position + Vector3.new(
                        math.random(-30, 30) / 10,
                        math.random(-30, 30) / 10,
                        math.random(-30, 30) / 10
                    ))
                    line.Size = Vector3.new(math.random(1, 4), GLITCH_LINE_THICK, math.random(1, 4))
                    local baseT = 0.9 - (0.7 * intensity)
                    line.Transparency = math.clamp(baseT + math.random(-15, 15) / 100, 0, 1)
                else
                    line.Transparency = 1
                end
            end
        end

        if glitchState.highlight and glitchState.highlight.Parent then
            local baseFill = 1 - (0.6 * intensity)
            local baseOutline = 1 - (0.7 * intensity)
            glitchState.highlight.FillTransparency = math.clamp(baseFill + math.random(-10, 10) / 100, 0, 1)
            glitchState.highlight.OutlineTransparency = math.clamp(baseOutline + math.random(-10, 10) / 100, 0, 1)
        end

        for part, origTr in pairs(glitchState.originalTransparency) do
            if part and part.Parent then
                local targetTr = origTr + (GLITCH_TRANSPARENCY - origTr) * intensity
                local jitter = (math.random(-10, 10) / 100) * intensity
                part.Transparency = math.clamp(targetTr + jitter, 0, 1)
            end
        end

        if elapsed >= duration then
            if glitchState.cleanup then glitchState.cleanup() end
        end
    end)

    glitchState.cleanup = function()
        if conn then
            pcall(function() conn:Disconnect() end)
            conn = nil
        end

        for part, origTr in pairs(glitchState.originalTransparency) do
            if part and part.Parent then
                pcall(function() part.Transparency = origTr end)
            end
        end

        if glitchState.lineFolder then
            pcall(function() glitchState.lineFolder:Destroy() end)
            glitchState.lineFolder = nil
        end

        if glitchState.highlight then
            pcall(function() glitchState.highlight:Destroy() end)
            glitchState.highlight = nil
        end

        if activeGlitch == glitchState then
            activeGlitch = nil
        end
    end

    activeGlitch = glitchState
end

-- ============================================
--  📝 ТЕКСТ
-- ============================================
local TextGui = Instance.new("ScreenGui")
TextGui.Name = "NoliVoidTextGui"
TextGui.ResetOnSpawn = false
TextGui.IgnoreGuiInset = true
TextGui.DisplayOrder = 5001
TextGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
TextGui.Enabled = true
TextGui.Parent = CoreGui
_G.NoliVoidTextGui = TextGui

local TEXT_BELOW_CENTER = sc(240)

local chargeText = Instance.new("TextLabel", TextGui)
chargeText.Name = "ChargeText"
chargeText.AnchorPoint = Vector2.new(0.5, 0)
chargeText.Size = UDim2.new(0, sc(340), 0, sc(50))
chargeText.Position = UDim2.new(0.5, 0, 0.5, TEXT_BELOW_CENTER)
chargeText.BackgroundTransparency = 1
chargeText.Text = ""
chargeText.TextColor3 = C.text
chargeText.Font = Enum.Font.GothamBold
chargeText.TextSize = sc(16)
chargeText.TextXAlignment = Enum.TextXAlignment.Center
chargeText.TextYAlignment = Enum.TextYAlignment.Top
chargeText.TextWrapped = true
chargeText.TextScaled = false
chargeText.RichText = false
chargeText.ZIndex = 10

local textHideToken = 0

local function showText(text)
    textHideToken = textHideToken + 1
    local myToken = textHideToken

    chargeText.Text = text or ""
    chargeText.TextTransparency = 1

    local t0 = tick()
    task.spawn(function()
        while true do
            if textHideToken ~= myToken then return end
            local dt = tick() - t0
            local p = math.clamp(dt / 0.15, 0, 1)
            chargeText.TextTransparency = 1 - p
            if p >= 1 then break end
            task.wait(0.02)
        end
    end)
end

local function fadeTextOut(duration)
    duration = duration or BAR_FADE_TIME
    local myToken = textHideToken

    task.spawn(function()
        local t0 = tick()
        while true do
            if textHideToken ~= myToken then return end
            local dt = tick() - t0
            local p = math.clamp(dt / duration, 0, 1)
            chargeText.TextTransparency = p
            if p >= 1 then break end
            task.wait(0.02)
        end
        if textHideToken == myToken then
            chargeText.Text = ""
            chargeText.TextTransparency = 0
        end
    end)
end

local function clearText()
    textHideToken = textHideToken + 1
    chargeText.Text = ""
    chargeText.TextTransparency = 0
end

clearText()

-- ============================================
--  🌈 CHARGE BAR
-- ============================================
local ChargeGui = Instance.new("ScreenGui")
ChargeGui.Name = "NoliVoidChargeGui"
ChargeGui.ResetOnSpawn = false
ChargeGui.IgnoreGuiInset = true
ChargeGui.DisplayOrder = 5000
ChargeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ChargeGui.Enabled = false
ChargeGui.Parent = CoreGui
_G.NoliVoidChargeGui = ChargeGui

local ARC_RADIUS    = sc(90)
local ARC_THICKNESS = sc(24)

local ARC_TOTAL_DEG = 216
local ARC_START_DEG = 180 + (ARC_TOTAL_DEG - 180) / 2
local ARC_END_DEG   = 0   - (ARC_TOTAL_DEG - 180) / 2

local CHARGE_FRAME_W = ARC_RADIUS * 2 + sc(60)
local CHARGE_FRAME_H = ARC_RADIUS + sc(60)

local chargeFrame = Instance.new("Frame", ChargeGui)
chargeFrame.Name = "ChargeFrame"
chargeFrame.AnchorPoint = Vector2.new(0.5, 1)
chargeFrame.Size = UDim2.new(0, CHARGE_FRAME_W, 0, CHARGE_FRAME_H)
chargeFrame.Position = UDim2.new(0.5, 0, 1, -sc(50))
chargeFrame.BackgroundTransparency = 1
chargeFrame.BorderSizePixel = 0

local ARC_CENTER_X = CHARGE_FRAME_W / 2
local ARC_CENTER_Y = sc(30)

local CHARGE_SEGMENTS = 60
local chargeSegments = {}

local function layoutSegment(seg, i)
    local t = (i - 1) / (CHARGE_SEGMENTS - 1)
    local angleDeg = ARC_START_DEG + (ARC_END_DEG - ARC_START_DEG) * t
    local angleRad = math.rad(angleDeg)

    local x = ARC_CENTER_X + math.cos(angleRad) * ARC_RADIUS
    local y = ARC_CENTER_Y + math.sin(angleRad) * ARC_RADIUS

    seg.Position = UDim2.new(0, x, 0, y)
    seg.Rotation = -(angleDeg - 90)
end

for i = 1, CHARGE_SEGMENTS do
    local seg = Instance.new("Frame", chargeFrame)
    seg.Name = "Seg" .. i
    seg.BackgroundColor3 = BAR_COLOR_FILL
    seg.BorderSizePixel = 0
    seg.AnchorPoint = Vector2.new(0.5, 0.5)
    seg.Size = UDim2.new(0, ARC_THICKNESS, 0, ARC_THICKNESS)
    seg.ZIndex = 2
    seg.BackgroundTransparency = 1

    local corner = Instance.new("UICorner", seg)
    corner.CornerRadius = UDim.new(1, 0)

    layoutSegment(seg, i)
    chargeSegments[i] = seg
end

local BACK_EXTRA = sc(8)
for i, seg in ipairs(chargeSegments) do
    local back = Instance.new("Frame", chargeFrame)
    back.Name = "Back" .. i
    back.BackgroundColor3 = BAR_COLOR_NORMAL
    back.BorderSizePixel = 0
    back.AnchorPoint = Vector2.new(0.5, 0.5)
    back.Size = UDim2.new(0, ARC_THICKNESS + BACK_EXTRA * 2, 0, ARC_THICKNESS + BACK_EXTRA * 2)
    back.ZIndex = 1
    back.Position = seg.Position
    back.Rotation = seg.Rotation
    Instance.new("UICorner", back).CornerRadius = UDim.new(1, 0)
end

local STAR_BACK_CHAR  = "✴️"
local STAR_FRONT_CHAR = "✴"

local starFrame = Instance.new("Frame", chargeFrame)
starFrame.Name = "StarFrame"
starFrame.AnchorPoint = Vector2.new(0.5, 0.5)
starFrame.Size = UDim2.new(0, sc(70), 0, sc(70))
starFrame.Position = UDim2.new(0, ARC_CENTER_X, 0, ARC_CENTER_Y + sc(15))
starFrame.BackgroundTransparency = 1
starFrame.ZIndex = 5

local starBack = Instance.new("TextLabel", starFrame)
starBack.Name = "StarBack"
starBack.AnchorPoint = Vector2.new(0.5, 0.5)
starBack.Size = UDim2.new(1.4, 0, 1.4, 0)
starBack.Position = UDim2.new(0.5, 0, 0.5, 0)
starBack.BackgroundTransparency = 1
starBack.Text = STAR_BACK_CHAR
starBack.TextColor3 = Color3.fromRGB(255, 255, 255)
starBack.Font = Enum.Font.GothamBold
starBack.TextScaled = true
starBack.RichText = true
starBack.ZIndex = 5

local starFront = Instance.new("TextLabel", starFrame)
starFront.Name = "StarFront"
starFront.AnchorPoint = Vector2.new(0.5, 0.5)
starFront.Size = UDim2.new(1.3, 0, 1.3, 0)
starFront.Position = UDim2.new(0.5, 0, 0.5, 0)
starFront.BackgroundTransparency = 1
starFront.Text = STAR_FRONT_CHAR
starFront.TextColor3 = Color3.fromRGB(255, 255, 255)
starFront.Font = Enum.Font.GothamBold
starFront.TextScaled = true
starFront.RichText = true
starFront.ZIndex = 6

local starBackAngle  = 0
local starFrontAngle = 0

local function setChargeProgress(progress)
    progress = math.clamp(progress, 0, 1)
    local filled = progress * CHARGE_SEGMENTS
    for i, seg in ipairs(chargeSegments) do
        if i <= filled then
            seg.BackgroundTransparency = 0
        else
            seg.BackgroundTransparency = 1
        end
    end
end

local starRotationActive = false
local starRotationSpeed = 0
local starRotationConn = nil

local function startStarRotation(speedDegPerSec)
    starRotationSpeed = speedDegPerSec
    if starRotationActive then return end
    starRotationActive = true

    local lastT = tick()
    starRotationConn = RunService.RenderStepped:Connect(function()
        if not starRotationActive then return end
        local now = tick()
        local dt = now - lastT
        lastT = now

        starFrontAngle = starFrontAngle + starRotationSpeed * dt
        if starFrontAngle >= 360 then starFrontAngle = starFrontAngle - 360 end

        starBackAngle = starBackAngle - starRotationSpeed * dt
        if starBackAngle <= -360 then starBackAngle = starBackAngle + 360 end

        pcall(function() starFront.Rotation = starFrontAngle end)
        pcall(function() starBack.Rotation = starBackAngle end)
    end)
end

local function stopStarRotation()
    starRotationActive = false
    if starRotationConn then
        pcall(function() starRotationConn:Disconnect() end)
        starRotationConn = nil
    end
    starFrontAngle = 0
    starBackAngle = 0
    pcall(function() starFront.Rotation = 0 end)
    pcall(function() starBack.Rotation = 0 end)
end

local function flashBarAndFade(color, text)
    setChargeProgress(1)
    for _, seg in ipairs(chargeSegments) do
        seg.BackgroundColor3 = color
    end
    showText(text or "")

    task.spawn(function()
        local t0 = tick()
        while true do
            local dt = tick() - t0
            local p = math.clamp(dt / BAR_FADE_TIME, 0, 1)
            for _, seg in ipairs(chargeSegments) do
                seg.BackgroundTransparency = p
            end
            starFront.TextTransparency = p
            starBack.TextTransparency = p
            if p >= 1 then break end
            task.wait(0.02)
        end

        stopStarRotation()
        for _, seg in ipairs(chargeSegments) do
            seg.BackgroundColor3 = BAR_COLOR_FILL
            seg.BackgroundTransparency = 1
        end
        starFront.TextTransparency = 0
        starBack.TextTransparency = 0

        ChargeGui.Enabled = false
        fadeTextOut(BAR_FADE_TIME)
    end)
end

setChargeProgress(0)

-- ============================================
--  IDLE + RUN
-- ============================================
local idleTrack = nil
local runTrack  = nil
local heartbeatConn = nil
local curIdleW = IDLE_WEIGHT
local curRunW  = RUN_WEIGHT_IDLE

local function startIdleRun()
    local animator = getAnimator()
    if not animator then return end

    if idleTrack then pcall(function() idleTrack:Stop(FADE_STOP) end) end
    if runTrack then pcall(function() runTrack:Stop(FADE_STOP) end) end

    local a1 = Instance.new("Animation")
    a1.AnimationId = ANIM_IDLE
    local ok1, t1 = pcall(function() return animator:LoadAnimation(a1) end)
    if ok1 and t1 then
        t1.Looped = true
        t1.Priority = Enum.AnimationPriority.Movement
        t1:Play(FADE_IDLE_RUN)
        pcall(function() t1:AdjustWeight(IDLE_WEIGHT, FADE_IDLE_RUN) end)
        idleTrack = t1
    end

    local a2 = Instance.new("Animation")
    a2.AnimationId = ANIM_RUN
    local ok2, t2 = pcall(function() return animator:LoadAnimation(a2) end)
    if ok2 and t2 then
        t2.Looped = true
        t2.Priority = Enum.AnimationPriority.Movement
        t2:Play(FADE_IDLE_RUN)
        pcall(function() t2:AdjustWeight(RUN_WEIGHT_IDLE, 0) end)
        runTrack = t2
    end

    curIdleW = IDLE_WEIGHT
    curRunW  = RUN_WEIGHT_IDLE

    if heartbeatConn then heartbeatConn:Disconnect() end
    heartbeatConn = RunService.Heartbeat:Connect(function()
        if not idleTrack or not runTrack then return end
        local hum = getHum()
        if not hum then return end

        local moving = hum.MoveDirection.Magnitude > 0.1
        local tIdle = moving and IDLE_WEIGHT_MOV or IDLE_WEIGHT
        local tRun  = moving and RUN_WEIGHT      or RUN_WEIGHT_IDLE

        local k = 0.1
        curIdleW = curIdleW + (tIdle - curIdleW) * k
        curRunW  = curRunW  + (tRun  - curRunW)  * k

        pcall(function() idleTrack:AdjustWeight(curIdleW, 0.05) end)
        pcall(function() runTrack:AdjustWeight(curRunW, 0.05) end)

        if not voidRunning and not chainRunning then
            local ws = hum.WalkSpeed or DEFAULT_WALK
            local ratio = ws / DEFAULT_WALK
            local target = math.clamp(ratio, 0.5, 3.0) * RUN_ANIM_SPEED
            pcall(function() runTrack:AdjustSpeed(target) end)
        end
    end)
end

local function stopIdleRun()
    if heartbeatConn then heartbeatConn:Disconnect(); heartbeatConn = nil end
    if idleTrack then pcall(function() idleTrack:Stop(FADE_STOP) end); idleTrack = nil end
    if runTrack then pcall(function() runTrack:Stop(FADE_STOP) end); runTrack = nil end
end

-- ============================================
--  ФЛАЖОК
-- ============================================
local currentFlag = nil
local FLAG_NAME = "NoliTP_Flag"

local function removeFlag()
    if currentFlag then
        pcall(function() currentFlag:Destroy() end)
        currentFlag = nil
    end
end

local function spawnFlag(pos)
    removeFlag()

    local model = Instance.new("Model")
    model.Name = FLAG_NAME

    local poleHeight = 4
    local poleThickness = 0.12

    local pole = Instance.new("Part")
    pole.Name = "Pole"
    pole.Anchored = true
    pole.CanCollide = false
    pole.CanQuery = false
    pole.CanTouch = false
    pole.Material = Enum.Material.SmoothPlastic
    pole.Color = Color3.fromRGB(255, 255, 255)
    pole.Size = Vector3.new(poleThickness, poleHeight, poleThickness)
    pole.CFrame = CFrame.new(pos + Vector3.new(0, poleHeight/2, 0))
    pole.Parent = model

    local flag = Instance.new("WedgePart")
    flag.Name = "Flag"
    flag.Anchored = true
    flag.CanCollide = false
    flag.CanQuery = false
    flag.CanTouch = false
    flag.Material = Enum.Material.SmoothPlastic
    flag.Color = Color3.fromRGB(220, 40, 40)
    flag.Size = Vector3.new(1.4, 0.9, 0.08)
    flag.CFrame = CFrame.new(pos + Vector3.new(0.7, poleHeight - 0.5, 0))
    flag.Parent = model

    local light = Instance.new("PointLight")
    light.Brightness = 1.2
    light.Range = 8
    light.Color = Color3.fromRGB(255, 90, 90)
    light.Parent = pole

    model.Parent = workspace
    currentFlag = model
end

-- ============================================
--  ЭМОЦИИ
-- ============================================
local function playEmote(rawId, opts)
    opts = opts or {}
    local animator = getAnimator()
    if not animator then return nil end

    local finalId = "rbxassetid://" .. tostring(rawId)
    if not opts.skipResolve then
        local ok, result = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(rawId))
        end)
        if ok and result and #result > 0 then
            local obj = result[1]
            if typeof(obj) == "Instance" and obj:IsA("Animation") and obj.AnimationId and obj.AnimationId ~= "" then
                finalId = obj.AnimationId
            end
        end
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = finalId

    local success, track = pcall(function() return animator:LoadAnimation(anim) end)
    if not success or not track then return nil end

    track.Looped   = opts.looped or false
    track.Priority = opts.priority or Enum.AnimationPriority.Action
    track:Play(opts.fadeIn or FADE_PRAY)

    if opts.weight then
        pcall(function() track:AdjustWeight(opts.weight, opts.fadeIn or FADE_PRAY) end)
    end
    if opts.speed and opts.speed ~= 1 then
        pcall(function() track:AdjustSpeed(opts.speed) end)
    end

    return track
end

-- ============================================
--  СТАН
-- ============================================
local stunState = { savedWalk = nil, savedJump = nil, savedJumpH = nil,
                    runningOff = false, jumpingOff = false }

local function freezeCharacter()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    stunState.savedWalk  = hum.WalkSpeed
    stunState.savedJump  = hum.JumpPower
    stunState.savedJumpH = hum.JumpHeight

    hum.WalkSpeed = 0
    hum.JumpPower = 0
    hum.JumpHeight = 0

    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Running, false) end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false) end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false) end)
    stunState.runningOff = true
    stunState.jumpingOff = true

    local animate = char:FindFirstChild("Animate")
    if animate and animate:IsA("BaseScript") then
        animate.Disabled = true
    end

    pcall(function()
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            t:Stop(0.2)
        end
    end)
end

local function unfreezeCharacter()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    hum.WalkSpeed = stunState.savedWalk or DEFAULT_WALK
    hum.JumpPower = stunState.savedJump or 50
    pcall(function() hum.JumpHeight = stunState.savedJumpH or 7.2 end)

    if stunState.runningOff then
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Running, true) end)
        stunState.runningOff = false
    end
    if stunState.jumpingOff then
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true) end)
        stunState.jumpingOff = false
    end

    stunState.savedWalk  = nil
    stunState.savedJump  = nil
    stunState.savedJumpH = nil
end

-- ============================================
--  СОСТОЯНИЕ
-- ============================================
local tpMode = "none"
local prayTrack = nil
local chainRunning = false
local tapConn = nil
local punchRunning = false
local voidRunning = false
local voidCharging = false
local runEnabled = false
local btnsLocked = false
local chargeTrack = nil

-- ============================================
--  GUI #1 — МЕНЮ РЕЖИМОВ
-- ============================================
local ModeGui = Instance.new("ScreenGui")
ModeGui.Name = "ObservantGui"
ModeGui.ResetOnSpawn = false
ModeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ModeGui.DisplayOrder = 1001
ModeGui.Enabled = true
ModeGui.Parent = CoreGui
_G.NoliTPModeGui = ModeGui

local MPanel = Instance.new("Frame", ModeGui)
MPanel.Size = UDim2.new(0, sc(200), 0, sc(240))
MPanel.Position = UDim2.new(0.5, -sc(100), 0.5, -sc(120))
MPanel.BackgroundColor3 = C.bg
MPanel.BackgroundTransparency = 0.05
MPanel.BorderSizePixel = 0
MPanel.Active = true
Instance.new("UICorner", MPanel).CornerRadius = UDim.new(0, sc(12))
local mpStroke = Instance.new("UIStroke", MPanel)
mpStroke.Color = C.accent
mpStroke.Thickness = 1.5

local MHeader = Instance.new("Frame", MPanel)
MHeader.Size = UDim2.new(1, 0, 0, sc(30))
MHeader.BackgroundColor3 = C.bg2
MHeader.BorderSizePixel = 0
Instance.new("UICorner", MHeader).CornerRadius = UDim.new(0, sc(12))
local mFix = Instance.new("Frame", MHeader)
mFix.Size = UDim2.new(1, 0, 0, sc(12))
mFix.Position = UDim2.new(0, 0, 1, -sc(12))
mFix.BackgroundColor3 = C.bg2
mFix.BorderSizePixel = 0

local MTitle = Instance.new("TextLabel", MHeader)
MTitle.Size = UDim2.new(1, -sc(20), 1, 0)
MTitle.Position = UDim2.new(0, sc(10), 0, 0)
MTitle.BackgroundTransparency = 1
MTitle.Text = "Observant GUI"
MTitle.TextColor3 = C.text
MTitle.Font = Enum.Font.GothamBold
MTitle.TextSize = sc(12)
MTitle.TextXAlignment = Enum.TextXAlignment.Left

local mDrag, mDS, mSP
MHeader.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        mDrag = true; mDS = i.Position; mSP = MPanel.Position
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then mDrag = false end end)
    end
end)
UIS.InputChanged:Connect(function(i)
    if mDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - mDS
        MPanel.Position = UDim2.new(mSP.X.Scale, mSP.X.Offset + d.X, mSP.Y.Scale, mSP.Y.Offset + d.Y)
    end
end)

local modeDefs = {
    {id = "none",     label = "🚫  NONE"},
    {id = "players",  label = "👥  PLAYERS"},
    {id = "tap",      label = "👆  TAP"},
    {id = "teleport", label = "🧊  TELEPORT"},
}
local modeBtns = {}

for i, m in ipairs(modeDefs) do
    local b = Instance.new("TextButton", MPanel)
    b.Size = UDim2.new(1, -sc(20), 0, sc(30))
    b.Position = UDim2.new(0, sc(10), 0, sc(38 + (i-1) * sc(34)))
    b.BackgroundColor3 = C.bg2
    b.Text = m.label
    b.TextColor3 = C.text
    b.Font = Enum.Font.GothamBold
    b.TextSize = sc(11)
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, sc(6))
    modeBtns[m.id] = b
end

-- ============================================
--  💾 SAVE BUTTON
-- ============================================
local SaveBtn = Instance.new("TextButton", MPanel)
SaveBtn.Size = UDim2.new(1, -sc(20), 0, sc(30))
SaveBtn.Position = UDim2.new(0, sc(10), 0, sc(38 + #modeDefs * sc(34) + sc(6)))
SaveBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 60)
SaveBtn.Text = "💾  SAVE POSITIONS"
SaveBtn.TextColor3 = C.text
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = sc(11)
SaveBtn.BorderSizePixel = 0
SaveBtn.AutoButtonColor = false
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, sc(6))
local saveStroke = Instance.new("UIStroke", SaveBtn)
saveStroke.Color = Color3.fromRGB(120, 220, 160)
saveStroke.Thickness = 1.2
saveStroke.Transparency = 0.3

SaveBtn.MouseButton1Click:Connect(function()
    doSave()
    local oldText = SaveBtn.Text
    SaveBtn.Text = "💾  SAVED!"
    task.delay(1, function()
        if SaveBtn then SaveBtn.Text = oldText end
    end)
end)

-- ============================================
--  Панель игроков
-- ============================================
local PlayerPanel = Instance.new("Frame", ModeGui)
PlayerPanel.Size = UDim2.new(0, sc(200), 0, sc(280))
PlayerPanel.Position = UDim2.new(0.5, sc(120), 0.5, -sc(140))
PlayerPanel.BackgroundColor3 = C.bg
PlayerPanel.BackgroundTransparency = 0.05
PlayerPanel.BorderSizePixel = 0
PlayerPanel.Active = true
PlayerPanel.Visible = false
Instance.new("UICorner", PlayerPanel).CornerRadius = UDim.new(0, sc(12))
local ppStroke = Instance.new("UIStroke", PlayerPanel)
ppStroke.Color = C.accent
ppStroke.Thickness = 1.5

local PPHeader = Instance.new("Frame", PlayerPanel)
PPHeader.Size = UDim2.new(1, 0, 0, sc(30))
PPHeader.BackgroundColor3 = C.bg2
PPHeader.BorderSizePixel = 0
Instance.new("UICorner", PPHeader).CornerRadius = UDim.new(0, sc(12))
local ppFix = Instance.new("Frame", PPHeader)
ppFix.Size = UDim2.new(1, 0, 0, sc(12))
ppFix.Position = UDim2.new(0, 0, 1, -sc(12))
ppFix.BackgroundColor3 = C.bg2
ppFix.BorderSizePixel = 0

local PPTitle = Instance.new("TextLabel", PPHeader)
PPTitle.Size = UDim2.new(1, -sc(20), 1, 0)
PPTitle.Position = UDim2.new(0, sc(10), 0, 0)
PPTitle.BackgroundTransparency = 1
PPTitle.Text = "👥 Игроки"
PPTitle.TextColor3 = C.text
PPTitle.Font = Enum.Font.GothamBold
PPTitle.TextSize = sc(12)
PPTitle.TextXAlignment = Enum.TextXAlignment.Left

local ppDrag, ppDS, ppSP
PPHeader.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        ppDrag = true; ppDS = i.Position; ppSP = PlayerPanel.Position
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then ppDrag = false end end)
    end
end)
UIS.InputChanged:Connect(function(i)
    if ppDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - ppDS
        PlayerPanel.Position = UDim2.new(ppSP.X.Scale, ppSP.X.Offset + d.X, ppSP.Y.Scale, ppSP.Y.Offset + d.Y)
    end
end)

local PPList = Instance.new("ScrollingFrame", PlayerPanel)
PPList.Size = UDim2.new(1, -sc(12), 1, -sc(38))
PPList.Position = UDim2.new(0, sc(6), 0, sc(34))
PPList.BackgroundTransparency = 1
PPList.BorderSizePixel = 0
PPList.ScrollBarThickness = 3
PPList.ScrollBarImageColor3 = C.accent
PPList.CanvasSize = UDim2.new(0, 0, 0, 0)

local ppLayout = Instance.new("UIListLayout", PPList)
ppLayout.Padding = UDim.new(0, sc(4))
ppLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function refreshPlayers()
    for _, ch in ipairs(PPList:GetChildren()) do
        if ch:IsA("TextButton") then ch:Destroy() end
    end
    local count = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            count = count + 1
            local b = Instance.new("TextButton", PPList)
            b.Size = UDim2.new(1, 0, 0, sc(28))
            b.BackgroundColor3 = C.bg2
            b.Text = "  " .. plr.DisplayName .. "  (@" .. plr.Name .. ")"
            b.TextColor3 = C.text
            b.Font = Enum.Font.GothamSemibold
            b.TextSize = sc(10)
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.TextTruncate = Enum.TextTruncate.AtEnd
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.LayoutOrder = count
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, sc(6))
            b.MouseButton1Click:Connect(function()
                if chainRunning then return end
                startTPChain(function()
                    local tgt = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if not tgt then return end
                    local myChar = LP.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then return end
                    local behind = -tgt.CFrame.LookVector * TP_OFFSET
                    local newPos = tgt.Position + behind
                    myRoot.CFrame = CFrame.new(newPos, tgt.Position)
                end)
            end)
        end
    end
    if count == 0 then
        local empty = Instance.new("TextLabel", PPList)
        empty.Size = UDim2.new(1, 0, 0, sc(30))
        empty.BackgroundTransparency = 1
        empty.Text = "Нет игроков"
        empty.TextColor3 = C.sub
        empty.Font = Enum.Font.Gotham
        empty.TextSize = sc(11)
    end
    task.wait()
    PPList.CanvasSize = UDim2.new(0, 0, 0, ppLayout.AbsoluteContentSize.Y + sc(10))
end

-- ============================================
--  🧊 TELEPORT — 2D OVERLAY
-- ============================================
local teleportCubes = {}
local teleportFolder = Instance.new("Folder")
teleportFolder.Name = "ObservantTeleportFolder"
teleportFolder.Parent = workspace
_G.ObservantTeleportFolder = teleportFolder

local TPOverlayGui = Instance.new("ScreenGui")
TPOverlayGui.Name = "ObservantTPOverlayGui"
TPOverlayGui.ResetOnSpawn = false
TPOverlayGui.IgnoreGuiInset = true
TPOverlayGui.DisplayOrder = 3000
TPOverlayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
TPOverlayGui.Enabled = false
TPOverlayGui.Parent = CoreGui
_G.ObservantTPOverlayGui = TPOverlayGui

local TeleportPanel = Instance.new("Frame", ModeGui)
TeleportPanel.Name = "ObservantTeleportPanel"
TeleportPanel.Size = UDim2.new(0, sc(200), 0, sc(110))
TeleportPanel.Position = UDim2.new(0.5, -sc(100), 0.5, sc(140))
TeleportPanel.BackgroundColor3 = C.bg
TeleportPanel.BackgroundTransparency = 0.05
TeleportPanel.BorderSizePixel = 0
TeleportPanel.Active = true
TeleportPanel.Visible = false
Instance.new("UICorner", TeleportPanel).CornerRadius = UDim.new(0, sc(12))
local tpStroke = Instance.new("UIStroke", TeleportPanel)
tpStroke.Color = C.accent2
tpStroke.Thickness = 1.5
_G.ObservantTeleportPanel = TeleportPanel

local TPHeader = Instance.new("Frame", TeleportPanel)
TPHeader.Size = UDim2.new(1, 0, 0, sc(28))
TPHeader.BackgroundColor3 = C.bg2
TPHeader.BorderSizePixel = 0
Instance.new("UICorner", TPHeader).CornerRadius = UDim.new(0, sc(12))
local tpFix = Instance.new("Frame", TPHeader)
tpFix.Size = UDim2.new(1, 0, 0, sc(12))
tpFix.Position = UDim2.new(0, 0, 1, -sc(12))
tpFix.BackgroundColor3 = C.bg2
tpFix.BorderSizePixel = 0

local TPTitle = Instance.new("TextLabel", TPHeader)
TPTitle.Size = UDim2.new(1, -sc(20), 1, 0)
TPTitle.Position = UDim2.new(0, sc(10), 0, 0)
TPTitle.BackgroundTransparency = 1
TPTitle.Text = "🧊 Teleport"
TPTitle.TextColor3 = C.text
TPTitle.Font = Enum.Font.GothamBold
TPTitle.TextSize = sc(12)
TPTitle.TextXAlignment = Enum.TextXAlignment.Left

local tpDrag, tpDS, tpSP
TPHeader.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        tpDrag = true; tpDS = i.Position; tpSP = TeleportPanel.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then tpDrag = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(i)
    if tpDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - tpDS
        TeleportPanel.Position = UDim2.new(tpSP.X.Scale, tpSP.X.Offset + d.X, tpSP.Y.Scale, tpSP.Y.Offset + d.Y)
    end
end)

local function makeTPButton(text, y, color)
    local b = Instance.new("TextButton", TeleportPanel)
    b.Size = UDim2.new(1, -sc(20), 0, sc(28))
    b.Position = UDim2.new(0, sc(10), 0, sc(y))
    b.BackgroundColor3 = color or C.bg2
    b.Text = text
    b.TextColor3 = C.text
    b.Font = Enum.Font.GothamBold
    b.TextSize = sc(11)
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, sc(6))
    return b
end

local TPSetBtn = makeTPButton("  SET UP", 36, Color3.fromRGB(70, 40, 120))
local TPdelBtn = makeTPButton("  DELETE LAST", 70, Color3.fromRGB(90, 40, 50))

local function teleportTo(cubePos)
    if chainRunning then return end
    startTPChain(function()
        local ch = LP.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(cubePos + Vector3.new(0, TP_CUBE_SIZE/2 + 3, 0))
        end
    end)
end

local function createMarker(data)
    local marker = Instance.new("ImageButton", TPOverlayGui)
    marker.Name = "TPMarker"
    marker.Size = UDim2.new(0, sc(TP_MARKER_SIZE), 0, sc(TP_MARKER_SIZE))
    marker.AnchorPoint = Vector2.new(0.5, 0.5)
    marker.BackgroundColor3 = Color3.fromRGB(140, 60, 220)
    marker.BackgroundTransparency = 0.25
    marker.BorderSizePixel = 0
    marker.AutoButtonColor = false
    marker.Image = "rbxassetid://109297778405631"
    marker.ImageColor3 = Color3.fromRGB(255, 255, 255)
    marker.ImageTransparency = 0
    marker.ScaleType = Enum.ScaleType.Fit
    marker.ZIndex = 5

    Instance.new("UICorner", marker).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", marker)
    stroke.Color = TP_CUBE_OUTLINE
    stroke.Thickness = 3
    stroke.Transparency = 0

    local label = Instance.new("TextLabel", marker)
    label.Name = "DistLbl"
    label.Size = UDim2.new(1, 0, 0, sc(18))
    label.Position = UDim2.new(0, 0, 1, sc(2))
    label.BackgroundTransparency = 1
    label.Text = ""
    label.TextColor3 = Color3.fromRGB(235, 200, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = sc(14)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.ZIndex = 6

    marker.MouseButton1Click:Connect(function()
        teleportTo(data.basePos)
    end)

    data.marker = marker
    data.markerStroke = stroke
    data.markerLabel = label
end

local function removeMarker(data)
    if data.marker then pcall(function() data.marker:Destroy() end); data.marker = nil end
    data.markerStroke = nil
    data.markerLabel = nil
end

local function placeTeleportCube()
    local hrp = getHRP()
    if not hrp then return end

    local look = Camera.CFrame.LookVector
    local flat = Vector3.new(look.X, 0, look.Z)
    if flat.Magnitude < 0.01 then flat = Vector3.new(0, 0, -1) end
    flat = flat.Unit

    local basePos = hrp.Position + flat * TP_CUBE_DISTANCE

    local cube = Instance.new("Part")
    cube.Name = "ObservantTPCube"
    cube.Anchored = true
    cube.CanCollide = false
    cube.CanQuery = false
    cube.CanTouch = false
    cube.Massless = true
    cube.Material = Enum.Material.SmoothPlastic
    cube.Color = TP_CUBE_COLOR
    cube.Transparency = 0.35
    cube.Size = Vector3.new(TP_CUBE_SIZE, TP_CUBE_SIZE, TP_CUBE_SIZE)
    cube.CFrame = CFrame.new(basePos)
    cube.Parent = teleportFolder

    local light = Instance.new("PointLight")
    light.Brightness = 2
    light.Range = 16
    light.Color = TP_CUBE_COLOR
    light.Parent = cube

    local data = {
        part = cube,
        basePos = basePos,
        rotAxis = Vector3.new(
            math.random(-100, 100) / 100,
            math.random(-100, 100) / 100,
            math.random(-100, 100) / 100
        ),
        rotAngle = 0,
        conn = nil,
    }
    if data.rotAxis.Magnitude < 0.1 then data.rotAxis = Vector3.new(0, 1, 0) end
    data.rotAxis = data.rotAxis.Unit

    data.conn = RunService.Heartbeat:Connect(function(dt)
        if not cube or not cube.Parent then
            if data.conn then data.conn:Disconnect() data.conn = nil end
            return
        end
        data.rotAngle = data.rotAngle + dt * TP_CUBE_ROT_SPEED
        cube.CFrame = CFrame.new(data.basePos)
            * CFrame.fromAxisAngle(data.rotAxis, data.rotAngle)
    end)

    createMarker(data)

    table.insert(teleportCubes, data)
end

local function deleteLastTeleportCube()
    if #teleportCubes == 0 then return end
    local data = table.remove(teleportCubes, #teleportCubes)
    if data.conn then pcall(function() data.conn:Disconnect() end) end
    removeMarker(data)
    if data.part then pcall(function() data.part:Destroy() end) end
end

TPSetBtn.MouseButton1Click:Connect(function()
    placeTeleportCube()
end)

TPdelBtn.MouseButton1Click:Connect(function()
    deleteLastTeleportCube()
end)

local markerUpdateConn = RunService.RenderStepped:Connect(function()
    if not TPOverlayGui.Enabled then return end
    if #teleportCubes == 0 then return end

    local myPos = getHRP() and getHRP().Position or Vector3.new()

    for _, data in ipairs(teleportCubes) do
        if data.marker and data.marker.Parent and data.part and data.part.Parent then
            local worldPos = data.basePos + Vector3.new(0, TP_CUBE_SIZE/2, 0)
            local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)

            if onScreen and screenPos.Z > 0 then
                data.marker.Visible = true
                data.marker.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                local dist = (worldPos - myPos).Magnitude
                if data.markerLabel then
                    data.markerLabel.Text = string.format("%dm", math.floor(dist))
                end
            else
                data.marker.Visible = false
            end
        end
    end
end)

-- ============================================
--  GUI #2 — КНОПКИ у прыжка
-- ============================================
local PunchGui = Instance.new("ScreenGui")
PunchGui.Name = "ObservantPunchGui"
PunchGui.ResetOnSpawn = false
PunchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
PunchGui.DisplayOrder = 1002
PunchGui.Enabled = true
PunchGui.Parent = CoreGui
_G.ObservantPunchGui = PunchGui

local VoidBtn = Instance.new("TextButton")
VoidBtn.Size = UDim2.new(0, sc(64), 0, sc(64))
VoidBtn.Position = UDim2.new(1, -sc(220), 1, -sc(220))
VoidBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 150)
VoidBtn.Text = "🌀"
VoidBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VoidBtn.Font = Enum.Font.GothamBlack
VoidBtn.TextSize = sc(28)
VoidBtn.BorderSizePixel = 0
VoidBtn.AutoButtonColor = false
VoidBtn.Parent = PunchGui
Instance.new("UICorner", VoidBtn).CornerRadius = UDim.new(1, 0)
local voidStroke = Instance.new("UIStroke", VoidBtn)
voidStroke.Color = Color3.fromRGB(180, 100, 255)
voidStroke.Thickness = 2
voidStroke.Transparency = 0.2

local VoidLbl = Instance.new("TextLabel", PunchGui)
VoidLbl.Size = UDim2.new(0, sc(64), 0, sc(12))
VoidLbl.Position = UDim2.new(1, -sc(220), 1, -sc(152))
VoidLbl.BackgroundTransparency = 1
VoidLbl.Text = "VOID"
VoidLbl.TextColor3 = C.text
VoidLbl.Font = Enum.Font.GothamBold
VoidLbl.TextSize = sc(9)

local RunBtn = Instance.new("TextButton")
RunBtn.Size = UDim2.new(0, sc(64), 0, sc(64))
RunBtn.Position = UDim2.new(1, -sc(150), 1, -sc(300))
RunBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
RunBtn.Text = "🏃"
RunBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RunBtn.Font = Enum.Font.GothamBlack
RunBtn.TextSize = sc(28)
RunBtn.BorderSizePixel = 0
RunBtn.AutoButtonColor = false
RunBtn.Parent = PunchGui
Instance.new("UICorner", RunBtn).CornerRadius = UDim.new(1, 0)
local runStroke = Instance.new("UIStroke", RunBtn)
runStroke.Color = Color3.fromRGB(120, 230, 160)
runStroke.Thickness = 2
runStroke.Transparency = 0.2

local RunLbl = Instance.new("TextLabel", PunchGui)
RunLbl.Size = UDim2.new(0, sc(64), 0, sc(12))
RunLbl.Position = UDim2.new(1, -sc(150), 1, -sc(232))
RunLbl.BackgroundTransparency = 1
RunLbl.Text = "RUN"
RunLbl.TextColor3 = C.text
RunLbl.Font = Enum.Font.GothamBold
RunLbl.TextSize = sc(9)

local PunchBtn = Instance.new("TextButton")
PunchBtn.Size = UDim2.new(0, sc(64), 0, sc(64))
PunchBtn.Position = UDim2.new(1, -sc(300), 1, -sc(220))
PunchBtn.BackgroundColor3 = Color3.fromRGB(220, 130, 220)
PunchBtn.Text = "🥊"
PunchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PunchBtn.Font = Enum.Font.GothamBlack
PunchBtn.TextSize = sc(28)
PunchBtn.BorderSizePixel = 0
PunchBtn.AutoButtonColor = false
PunchBtn.Parent = PunchGui
Instance.new("UICorner", PunchBtn).CornerRadius = UDim.new(1, 0)
local punchStroke = Instance.new("UIStroke", PunchBtn)
punchStroke.Color = Color3.fromRGB(255, 180, 255)
punchStroke.Thickness = 2
punchStroke.Transparency = 0.2

local PunchLbl = Instance.new("TextLabel", PunchGui)
PunchLbl.Size = UDim2.new(0, sc(64), 0, sc(12))
PunchLbl.Position = UDim2.new(1, -sc(300), 1, -sc(152))
PunchLbl.BackgroundTransparency = 1
PunchLbl.Text = "PUNCH"
PunchLbl.TextColor3 = C.text
PunchLbl.Font = Enum.Font.GothamBold
PunchLbl.TextSize = sc(9)

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0, sc(26), 0, sc(26))
LockBtn.Position = UDim2.new(1, -sc(152), 1, -sc(212))
LockBtn.BackgroundColor3 = C.bg2
LockBtn.Text = "🔓"
LockBtn.TextColor3 = C.text
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextSize = sc(13)
LockBtn.BorderSizePixel = 0
LockBtn.AutoButtonColor = false
LockBtn.Parent = PunchGui
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, sc(6))
local lockStroke = Instance.new("UIStroke", LockBtn)
lockStroke.Color = C.accent
lockStroke.Thickness = 1.5
lockStroke.Transparency = 0.3

-- ============================================
--  🎵 CHASE THEME (ON/OFF)
-- ============================================
local chaseEnabled = false
local chaseSound = nil

local ChaseBtn = Instance.new("TextButton")
ChaseBtn.Size = UDim2.new(0, sc(64), 0, sc(64))
ChaseBtn.Position = UDim2.new(1, -sc(150), 1, -sc(380))
ChaseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
ChaseBtn.Text = "🎵"
ChaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ChaseBtn.Font = Enum.Font.GothamBlack
ChaseBtn.TextSize = sc(28)
ChaseBtn.BorderSizePixel = 0
ChaseBtn.AutoButtonColor = false
ChaseBtn.Parent = PunchGui
Instance.new("UICorner", ChaseBtn).CornerRadius = UDim.new(1, 0)
local chaseStroke = Instance.new("UIStroke", ChaseBtn)
chaseStroke.Color = Color3.fromRGB(160, 160, 255)
chaseStroke.Thickness = 2
chaseStroke.Transparency = 0.2

local ChaseLbl = Instance.new("TextLabel", PunchGui)
ChaseLbl.Size = UDim2.new(0, sc(64), 0, sc(12))
ChaseLbl.Position = UDim2.new(1, -sc(150), 1, -sc(312))
ChaseLbl.BackgroundTransparency = 1
ChaseLbl.Text = "THEME"
ChaseLbl.TextColor3 = C.text
ChaseLbl.Font = Enum.Font.GothamBold
ChaseLbl.TextSize = sc(9)

-- Контейнер для звука (в CoreGui, чтобы не удалялся при респавне)
local SoundFolder = Instance.new("Folder")
SoundFolder.Name = "ObservantSoundFolder"
SoundFolder.Parent = CoreGui
_G.ObservantSoundFolder = SoundFolder

local function stopChaseTheme()
    if chaseSound then
        pcall(function() chaseSound:Stop() end)
        pcall(function() chaseSound:Destroy() end)
        chaseSound = nil
    end
end

local function startChaseTheme()
    stopChaseTheme()
    local s = Instance.new("Sound")
    s.Name = "ChaseTheme"
    s.SoundId = CHASE_SOUND_ID
    s.Looped = true
    s.Volume = CHASE_VOLUME
    s.PlaybackSpeed = CHASE_SPEED
    s.Parent = SoundFolder
    chaseSound = s
    pcall(function() s:Play() end)
end

local function applyChaseState()
    if chaseEnabled then
        ChaseBtn.BackgroundColor3 = Color3.fromRGB(120, 90, 220)
        chaseStroke.Color = Color3.fromRGB(200, 180, 255)
        ChaseLbl.Text = "THEME ON"
        ChaseLbl.TextColor3 = C.accent2
        startChaseTheme()
    else
        ChaseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
        chaseStroke.Color = Color3.fromRGB(160, 160, 255)
        ChaseLbl.Text = "THEME"
        ChaseLbl.TextColor3 = C.text
        stopChaseTheme()
    end
end

ChaseBtn.MouseButton1Click:Connect(function()
    chaseEnabled = not chaseEnabled
    applyChaseState()
end)

-- ============================================
--  🎯 DRAG
-- ============================================
local draggableItems = {
    {btn = VoidBtn,  lbl = VoidLbl},
    {btn = RunBtn,   lbl = RunLbl},
    {btn = PunchBtn, lbl = PunchLbl},
    {btn = LockBtn,  lbl = nil},
    {btn = ChaseBtn, lbl = ChaseLbl},
}

local dragData = nil

for _, item in ipairs(draggableItems) do
    item.btn.InputBegan:Connect(function(input)
        if btnsLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragData = {
                input = input,
                item = item,
                startPos = input.Position,
                startBtnPos = item.btn.Position,
                startLblPos = item.lbl and item.lbl.Position or nil,
            }

            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragData = nil
                    if conn then conn:Disconnect() end
                end
            end)
        end
    end)
end

UIS.InputChanged:Connect(function(input)
    if btnsLocked then return end
    if not dragData then return end
    if input ~= dragData.input then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then return end

    local d = input.Position - dragData.startPos
    local item = dragData.item

    item.btn.Position = UDim2.new(
        dragData.startBtnPos.X.Scale,
        dragData.startBtnPos.X.Offset + d.X,
        dragData.startBtnPos.Y.Scale,
        dragData.startBtnPos.Y.Offset + d.Y
    )

    if item.lbl and dragData.startLblPos then
        item.lbl.Position = UDim2.new(
            dragData.startLblPos.X.Scale,
            dragData.startLblPos.X.Offset + d.X,
            dragData.startLblPos.Y.Scale,
            dragData.startLblPos.Y.Offset + d.Y
        )
    end
end)

LockBtn.MouseButton1Click:Connect(function()
    btnsLocked = not btnsLocked
    if btnsLocked then
        LockBtn.Text = "🔒"
        LockBtn.BackgroundColor3 = C.gold
        LockBtn.TextColor3 = C.bg
        lockStroke.Color = C.gold
    else
        LockBtn.Text = "🔓"
        LockBtn.BackgroundColor3 = C.bg2
        LockBtn.TextColor3 = C.text
        lockStroke.Color = C.accent
    end
end)

-- ============================================
--  PUNCH
-- ============================================
local function doPunch()
    if punchRunning then return end
    if chainRunning then return end
    if voidRunning or voidCharging then return end

    punchRunning = true

    enableForceField()
    enableHealthGuard()

    local orig = PunchBtn.BackgroundColor3
    PunchBtn.BackgroundColor3 = C.gold
    task.delay(0.15, function()
        pcall(function() PunchBtn.BackgroundColor3 = orig end)
    end)

    local t = playEmote(EMOTE_PUNCH, {
        looped = false,
        priority = Enum.AnimationPriority.Action4,
        fadeIn = FADE_PUNCH,
    })

    if t then
        local elapsed = 0
        while t.IsPlaying and elapsed < 2 do
            task.wait(0.05)
            elapsed = elapsed + 0.05
        end
        pcall(function() t:Stop(FADE_PUNCH) end)
    else
        task.wait(0.3)
    end

    task.wait(1)

    disableHealthGuard()
    disableForceField()

    task.wait(PUNCH_DEBOUNCE)
    punchRunning = false
end

PunchBtn.MouseButton1Click:Connect(doPunch)

-- ============================================
--  🧱 playAnim
-- ============================================
local function playAnim(rawId, speed)
    local animator = getAnimator()
    if not animator then return end

    speed = speed or 1

    local finalId = "rbxassetid://" .. tostring(rawId)
    local ok, result = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(rawId))
    end)
    if ok and result and #result > 0 then
        local obj = result[1]
        if typeof(obj) == "Instance" and obj:IsA("Animation") and obj.AnimationId and obj.AnimationId ~= "" then
            finalId = obj.AnimationId
        end
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = finalId

    local success, track = pcall(function() return animator:LoadAnimation(anim) end)
    if not success or not track then return end

    track.Looped   = false
    track.Priority = Enum.AnimationPriority.Action4

    pcall(function() track:AdjustSpeed(speed) end)
    track:Play(0.03)

    task.spawn(function()
        while track.IsPlaying do
            pcall(function() track:AdjustSpeed(speed) end)
            task.wait()
        end
    end)
end

-- ============================================
--  VOID RUSH
-- ============================================
local voidCleanup = nil

local function startVoidRush()
    local hum = getHum()
    local hrp = getHRP()
    if not hum or not hrp then return end

    voidRunning = true
    voidCharging = false
    chargeHolding = false

    enableForceField()
    enableHealthGuard()

    local orig = VoidBtn.BackgroundColor3
    VoidBtn.BackgroundColor3 = Color3.fromRGB(230, 80, 255)

    hum.WalkSpeed = VOID_SPEED
    hum.AutoRotate = false

    local voidTrack = playEmote(EMOTE_VOID, {
        looped = true,
        priority = Enum.AnimationPriority.Action4,
        fadeIn = FADE_VOID,
        speed = 1,
    })

    local bv = Instance.new("BodyVelocity")
    bv.Name = "NoliVoidBV"
    bv.MaxForce = Vector3.new(1e5, 0, 1e5)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp

    startStarRotation(STAR_ROT_FLIGHT)

    local startTime = tick()
    local lastPos = hrp.Position
    local lastCheckTime = tick()
    local wallHits = 0
    local heartbeatConn = nil
    local finished = false

    local function cleanup(reason)
        if finished then return end
        finished = true

        stopStarRotation()

        if heartbeatConn then pcall(function() heartbeatConn:Disconnect() end); heartbeatConn = nil end

        if bv then
            pcall(function()
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.MaxForce = Vector3.new(0, 0, 0)
            end)
            pcall(function() bv:Destroy() end)
        end

        if voidTrack then
            pcall(function() voidTrack:Stop(FADE_VOID) end)
        end

        local r = getHRP()
        if r then
            pcall(function()
                local v = r.Velocity
                r.Velocity = Vector3.new(v.X, 0, v.Z)
            end)
        end

        local h = getHum()
        if h then
            h.AutoRotate = true
            if tpMode == "none" or tpMode == "teleport" then
                h.WalkSpeed = runEnabled and RUN_WALK or DEFAULT_WALK
            else
                h.WalkSpeed = runEnabled and (RUN_WALK * WALK_SPEED) or (DEFAULT_WALK * WALK_SPEED)
            end
            pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end)
        end

        if reason == "hit" then
            flashBarAndFade(BAR_COLOR_HIT, pickRandom(TEXTS_HIT))
        elseif reason == "wall" then
            flashBarAndFade(BAR_COLOR_CRASH, pickRandom(TEXTS_WALL))
            playAnim(EMOTE_BUMP, BUMP_SPEED)
        elseif reason == "timeout" then
            flashBarAndFade(BAR_COLOR_CRASH, pickRandom(TEXTS_TIMEOUT))
            playAnim(EMOTE_FALL, FALL_SPEED)
        else
            flashBarAndFade(BAR_COLOR_CRASH, pickRandom(TEXTS_CANCEL))
            playAnim(EMOTE_FALL, FALL_SPEED)
        end

        task.wait(0.5)

        disableHealthGuard()
        disableForceField()

        if tpMode == "none" or tpMode == "teleport" then
            silenceAnimate()
            startIdleRun()
        else
            silenceAnimate()
            startIdleRun()
            startPray()
        end

        VoidBtn.BackgroundColor3 = orig

        task.wait(VOID_DEBOUNCE)
        voidRunning = false
        voidCleanup = nil
    end

    voidCleanup = function()
        cleanup("cancel")
    end

    task.delay(VOID_MAX_TIME, function()
        if not finished then
            cleanup("timeout")
        end
    end)

    local ignoreList = {}
    local char = LP.Character
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                table.insert(ignoreList, p)
            end
        end
    end
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = ignoreList
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    heartbeatConn = RunService.Heartbeat:Connect(function()
        if finished then return end
        if not voidRunning then cleanup("cancel") return end

        local h = getHum()
        local r = getHRP()
        if not h or not r then cleanup("timeout") return end

        local camDir = Camera.CFrame.LookVector
        local flat = Vector3.new(camDir.X, 0, camDir.Z)
        if flat.Magnitude > 0.01 then
            flat = flat.Unit
            if bv and bv.Parent then
                bv.Velocity = flat * VOID_SPEED
            end
            local lookAt = CFrame.lookAt(r.Position, r.Position + flat)
            r.CFrame = CFrame.new(r.Position) * (lookAt - lookAt.Position)
        end

        local now = tick()
        local dt = now - lastCheckTime
        if dt >= WALL_CHECK_INTERVAL and (now - startTime) > WALL_GRACE_TIME then
            local moved = (r.Position - lastPos).Magnitude
            local expected = VOID_SPEED * dt
            local ratio = moved / math.max(expected, 0.001)

            if ratio < WALL_MOVE_RATIO then
                wallHits = wallHits + 1
                if wallHits >= 2 then
                    cleanup("wall")
                    return
                end
            else
                wallHits = 0
            end

            if flat and flat.Magnitude > 0.01 then
                local origin = r.Position + flat * 1.5
                local result = workspace:Raycast(origin, flat * WALL_RAY_DISTANCE, rayParams)
                if result and result.Instance then
                    local hitPart = result.Instance
                    if hitPart.CanCollide and hitPart.Transparency > 0.5 then
                        cleanup("wall")
                        return
                    end
                end
            end

            lastPos = r.Position
            lastCheckTime = now
        end

        local myPos = r.Position
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local otherHum = plr.Character:FindFirstChildOfClass("Humanoid")
                local otherRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if otherHum and otherRoot and otherHum.Health > 0 then
                    local d = (otherRoot.Position - myPos).Magnitude
                    if d <= VOID_HIT_RANGE then
                        cleanup("hit")
                        return
                    end
                end
            end
        end
    end)

    task.spawn(function()
        local t0 = tick()
        while not finished and voidRunning do
            local dt = tick() - t0
            local progress = 1 - math.clamp(dt / VOID_MAX_TIME, 0, 1)
            setChargeProgress(progress)
            if progress <= 0 then break end
            task.wait(0.03)
        end
    end)
end

-- ============================================
--  VOID CHARGE
-- ============================================
local chargeStartTime = 0
local chargeHolding = false

local function startVoidCharge()
    if voidCharging or voidRunning then return end
    if chainRunning or punchRunning then return end

    local hum = getHum()
    local hrp = getHRP()
    if not hum or not hrp then return end

    voidCharging = true
    chargeHolding = true
    chargeStartTime = tick()

    stopIdleRun()
    if prayTrack then
        pcall(function() prayTrack:Stop(FADE_VOID) end)
        prayTrack = nil
    end

    ChargeGui.Enabled = true
    setChargeProgress(0)
    showText(pickRandom(TEXTS_CHARGE))

    startStarRotation(STAR_ROT_CHARGE)

    chargeTrack = playEmote(EMOTE_CHARGE, {
        looped = false,
        priority = Enum.AnimationPriority.Action4,
        fadeIn = FADE_CHARGE,
        speed = 1,
    })

    task.delay(CHARGE_FREEZE_TIME, function()
        if chargeTrack then
            pcall(function() chargeTrack:AdjustSpeed(CHARGE_SLOW_SPEED) end)
        end
    end)

    local baseCFrame = hrp.CFrame
    local basePos = baseCFrame.Position

    task.spawn(function()
        local t0 = tick()
        while voidCharging and (tick() - t0) < CHARGE_FAST_TURN do
            local p = (tick() - t0) / CHARGE_FAST_TURN
            local ease = p * p * (3 - 2 * p)
            local yawRad = -math.rad(CHARGE_ROTATION) * ease
            local r = getHRP()
            if r then
                local pos = r.Position
                r.CFrame = CFrame.new(pos) * CFrame.Angles(0, yawRad, 0) * (baseCFrame - baseCFrame.Position)
            end
            task.wait()
        end

        local returnDuration = math.max(0.05, CHARGE_FREEZE_TIME - CHARGE_FAST_TURN)
        local t1 = tick()
        while voidCharging and (tick() - t1) < returnDuration do
            local p = (tick() - t1) / returnDuration
            local ease = p * p * (3 - 2 * p)
            local yawRad = -math.rad(CHARGE_ROTATION) * (1 - ease)
            local r = getHRP()
            if r then
                local pos = r.Position
                r.CFrame = CFrame.new(pos) * CFrame.Angles(0, yawRad, 0) * (baseCFrame - baseCFrame.Position)
            end
            task.wait()
        end

        local r = getHRP()
        if r then
            local pos = r.Position
            r.CFrame = CFrame.new(pos) * (baseCFrame - baseCFrame.Position)
        end
    end)

    task.spawn(function()
        while voidCharging do
            local dt = tick() - chargeStartTime
            local progress = math.clamp(dt / CHARGE_TOTAL_TIME, 0, 1)
            setChargeProgress(progress)
            if progress >= 1 then
                if voidCharging then
                    voidCharging = false
                    if chargeTrack then
                        pcall(function() chargeTrack:Stop(FADE_VOID) end)
                        chargeTrack = nil
                    end
                    showText(pickRandom(TEXTS_FLIGHT))
                    startVoidRush()
                end
                break
            end
            task.wait(0.03)
        end
    end)
end

local function releaseVoidCharge()
    if not voidCharging then return end
    if not chargeHolding then return end

    chargeHolding = false
    voidCharging = false
    if chargeTrack then
        pcall(function() chargeTrack:Stop(FADE_VOID) end)
        chargeTrack = nil
    end
    stopStarRotation()
    flashBarAndFade(BAR_COLOR_CRASH, pickRandom(TEXTS_NOT_ENOUGH))
    task.wait(0.1)
    startIdleRun()
end

-- ============================================
--  VOID кнопка
-- ============================================
VoidBtn.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
    and input.UserInputType ~= Enum.UserInputType.Touch then return end

    if voidRunning then
        if voidCleanup then pcall(voidCleanup) end
        return
    end

    if chainRunning then return end
    if punchRunning then return end
    if voidCharging then return end

    startVoidCharge()
end)

VoidBtn.InputEnded:Connect(function(input)
    if voidRunning then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        releaseVoidCharge()
    end
end)

UIS.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    if voidRunning then return end
    if not voidCharging then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        releaseVoidCharge()
    end
end)

-- ============================================
--  🏃 RUN
-- ============================================
local function applyRunSpeed()
    local hum = getHum()
    if not hum then return end
    if voidRunning or voidCharging or chainRunning then return end

    if tpMode == "none" or tpMode == "teleport" then
        hum.WalkSpeed = runEnabled and RUN_WALK or DEFAULT_WALK
    else
        hum.WalkSpeed = runEnabled and (RUN_WALK * WALK_SPEED) or (DEFAULT_WALK * WALK_SPEED)
    end
end

local function toggleRun()
    runEnabled = not runEnabled

    if runEnabled then
        RunBtn.BackgroundColor3 = Color3.fromRGB(80, 220, 130)
        runStroke.Color = Color3.fromRGB(180, 255, 210)
        RunLbl.Text = "RUN ON"
        RunLbl.TextColor3 = C.green
    else
        RunBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
        runStroke.Color = Color3.fromRGB(120, 230, 160)
        RunLbl.Text = "RUN"
        RunLbl.TextColor3 = C.text
    end

    applyRunSpeed()
end

RunBtn.MouseButton1Click:Connect(toggleRun)

-- ============================================
--  ЦЕПОЧКА TP + ГЛИТЧ
-- ============================================
local function playOnce(rawId, dur, animSpeed)
    animSpeed = animSpeed or 1
    local t = playEmote(rawId, {
        looped = false,
        priority = Enum.AnimationPriority.Action4,
        speed = animSpeed,
        fadeIn = FADE_CHAIN,
    })
    if t then
        task.wait((dur or 0.3) / animSpeed)
        pcall(function() t:Stop(FADE_CHAIN) end)
    else
        task.wait(dur or 0.3)
    end
end

function startTPChain(onFinish)
    if chainRunning then return end
    chainRunning = true

    if voidCleanup then
        pcall(voidCleanup)
    end

    task.spawn(function()
        pcall(function() setMode("none") end)

        if prayTrack then
            pcall(function() prayTrack:Stop(FADE_STOP) end)
            prayTrack = nil
        end

        task.wait(0.15)

        pcall(freezeCharacter)

        pcall(function() noliGlitch(GLITCH_DURATION) end)

        pcall(function() playOnce(EMOTE_FAST, FAST_TIME, FAST_ANIM_SPEED) end)
        pcall(function() playOnce(EMOTE_HANDSUP, HANDSUP_TIME, HANDSUP_ANIM_SPEED) end)
        pcall(function() playOnce(EMOTE_BOOM, BOOM_TIME, BOOM_ANIM_SPEED) end)

        if onFinish then pcall(onFinish) end

        pcall(removeFlag)
        pcall(unfreezeCharacter)

        chainRunning = false

        task.wait(0.05)
        silenceAnimate()
        startIdleRun()

        applyRunSpeed()
    end)
end

-- ============================================
--  TAP
-- ============================================
local function disableTap()
    if tapConn then
        if tapConn.beg then pcall(function() tapConn.beg:Disconnect() end) end
        if tapConn.end_ then pcall(function() tapConn.end_:Disconnect() end) end
        tapConn = nil
    end
end

local function enableTap()
    disableTap()

    local startPos = nil
    local startTime = nil
    local begC = UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if tpMode ~= "tap" then return end
        if chainRunning then return end

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            if input.UserInputType == Enum.UserInputType.Touch then
                local g2 = ModeGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
                local g3 = PunchGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
                if (#g2 > 0) or (#g3 > 0) then
                    startPos = nil; startTime = nil
                    return
                end
            end
            startPos = input.Position
            startTime = tick()
        end
    end)

    local endC = UIS.InputEnded:Connect(function(input, gpe)
        if gpe then return end
        if tpMode ~= "tap" then return end
        if chainRunning then return end

        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            if not startPos or not startTime then return end

            local endPos = input.Position
            local elapsed = tick() - startTime
            local dx = endPos.X - startPos.X
            local dy = endPos.Y - startPos.Y
            local dist = math.sqrt(dx*dx + dy*dy)

            local wasTap = (dist <= TAP_MAX_DIST) and (elapsed <= TAP_MAX_TIME)

            startPos = nil
            startTime = nil

            if not wasTap then return end

            local mp = endPos
            local ray = Camera:ScreenPointToRay(mp.X, mp.Y)
            local ignore = {}
            local char = LP.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then table.insert(ignore, p) end
                end
            end
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = ignore
            params.FilterType = Enum.RaycastFilterType.Exclude
            local result = workspace:Raycast(ray.Origin, ray.Direction * 5000, params)
            local targetPos = result and result.Position or (ray.Origin + ray.Direction * 200)

            spawnFlag(targetPos)

            startTPChain(function()
                local ch = LP.Character
                local root = ch and ch:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                end
            end)
        end
    end)

    tapConn = { beg = begC, end_ = endC }
end

-- ============================================
--  РЕЖИМЫ
-- ============================================
local function startPray()
    prayTrack = playEmote(EMOTE_PRAY, {
        looped = true,
        priority = Enum.AnimationPriority.Action,
        weight = PRAY_WEIGHT,
        speed = PRAY_SPEED,
        fadeIn = FADE_PRAY,
    })
end

local function stopPray()
    if prayTrack then
        pcall(function() prayTrack:Stop(FADE_STOP) end)
        prayTrack = nil
    end
end

function setMode(mode)
    tpMode = mode

    for id, b in pairs(modeBtns) do
        if id == mode then
            b.BackgroundColor3 = C.accent
            b.TextColor3 = C.bg
        else
            b.BackgroundColor3 = C.bg2
            b.TextColor3 = C.text
        end
    end

    local hum = getHum()

    if mode == "none" then
        stopPray()
        stopIdleRun()
        PlayerPanel.Visible = false
        TeleportPanel.Visible = false
        TPOverlayGui.Enabled = false
        disableTap()
        task.wait(0.1)
        silenceAnimate()
        startIdleRun()
        if hum then hum.WalkSpeed = runEnabled and RUN_WALK or DEFAULT_WALK end
    elseif mode == "players" then
        stopPray()
        stopIdleRun()
        task.wait(0.1)
        silenceAnimate()
        startIdleRun()
        startPray()
        if hum then hum.WalkSpeed = runEnabled and (RUN_WALK * WALK_SPEED) or (DEFAULT_WALK * WALK_SPEED) end
        PlayerPanel.Visible = true
        TeleportPanel.Visible = false
        TPOverlayGui.Enabled = false
        refreshPlayers()
        disableTap()
    elseif mode == "tap" then
        stopPray()
        stopIdleRun()
        task.wait(0.1)
        silenceAnimate()
        startIdleRun()
        startPray()
        if hum then hum.WalkSpeed = runEnabled and (RUN_WALK * WALK_SPEED) or (DEFAULT_WALK * WALK_SPEED) end
        PlayerPanel.Visible = false
        TeleportPanel.Visible = false
        TPOverlayGui.Enabled = false
        enableTap()
    elseif mode == "teleport" then
        stopPray()
        stopIdleRun()
        task.wait(0.1)
        silenceAnimate()
        startIdleRun()
        startPray()
        if hum then hum.WalkSpeed = runEnabled and (RUN_WALK * WALK_SPEED) or (DEFAULT_WALK * WALK_SPEED) end
        PlayerPanel.Visible = false
        TeleportPanel.Visible = true
        TPOverlayGui.Enabled = true
        disableTap()
    end
end

for id, b in pairs(modeBtns) do
    b.MouseButton1Click:Connect(function() setMode(id) end)
end

Players.PlayerAdded:Connect(function() if tpMode == "players" then refreshPlayers() end end)
Players.PlayerRemoving:Connect(function() if tpMode == "players" then refreshPlayers() end end)

-- ============================================
--  РЕСПАВН
-- ============================================
LP.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid", 5)
    char:WaitForChild("Animate", 5)
    prayTrack = nil
    chainRunning = false
    punchRunning = false
    voidRunning = false
    voidCharging = false
    chargeHolding = false
    voidCleanup = nil
    chargeTrack = nil
    if activeGlitch and activeGlitch.cleanup then
        pcall(function() activeGlitch.cleanup() end)
    end
    disableHealthGuard()
    disableForceField()
    stopIdleRun()
    disableTap()
    removeFlag()
    setChargeProgress(0)
    clearText()
    ChargeGui.Enabled = false
    stopStarRotation()

    -- перезапуск chase theme после респавна
    if chaseEnabled then
        startChaseTheme()
    end

    task.wait(0.5)
    setMode("none")
end)

-- ============================================
--  СТАРТ
-- ============================================
task.spawn(function()
    task.wait(1)
    local char = LP.Character or LP.CharacterAdded:Wait()
    char:WaitForChild("Humanoid", 5)
    char:WaitForChild("Animate", 5)
    task.wait(0.3)

    -- регистрируем объекты для сохранения
    saveTargets.MPanel = MPanel
    saveTargets.PlayerPanel = PlayerPanel
    saveTargets.TeleportPanel = TeleportPanel
    saveTargets.VoidBtn = VoidBtn
    saveTargets.VoidLbl = VoidLbl
    saveTargets.RunBtn = RunBtn
    saveTargets.RunLbl = RunLbl
    saveTargets.PunchBtn = PunchBtn
    saveTargets.PunchLbl = PunchLbl
    saveTargets.LockBtn = LockBtn
    saveTargets.ChaseBtn = ChaseBtn
    saveTargets.ChaseLbl = ChaseLbl

    -- подгружаем сохранённые позиции
    doLoad()

    setMode("none")
end)

print("[Observant GUI v116] + Chase Theme (1.4x) | Save только по кнопке SAVE POSITIONS.")
