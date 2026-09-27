-- ============================================================
-- 加载界面（无色液态玻璃 + 淡蓝点缀 + 大雪 + 动态模糊）
-- ============================================================
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "LoadingScreen"
LoadingGui.ResetOnSpawn = false
LoadingGui.IgnoreGuiInset = true
LoadingGui.DisplayOrder = 999999
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoadingGui.Parent = game:GetService("CoreGui")

-- ===== 背景动态模糊 =====
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 0
BlurEffect.Parent = game:GetService("Lighting")
TweenService:Create(BlurEffect, TweenInfo.new(0.5, Enum.EasingStyle.Quad), { Size = 26 }):Play()

-- ===== 雪花层（前 + 后两层，大雪效果） =====
local SnowBack = Instance.new("Frame")
SnowBack.Size = UDim2.new(1, 0, 1, 0)
SnowBack.BackgroundTransparency = 1
SnowBack.ZIndex = 2
SnowBack.Parent = LoadingGui

local SnowFront = Instance.new("Frame")
SnowFront.Size = UDim2.new(1, 0, 1, 0)
SnowFront.BackgroundTransparency = 1
SnowFront.ZIndex = 10
SnowFront.Parent = LoadingGui

local snowflakes = {}
local function createSnow(parent, count, sizeRange, transRange, speedRange, zIndex)
    for i = 1, count do
        local size = math.random(sizeRange[1], sizeRange[2])
        local flake = Instance.new("Frame")
        flake.Size = UDim2.new(0, size, 0, size)
        local startX = math.random()
        flake.Position = UDim2.new(startX, 0, math.random(-100, 0) / 100, 0)
        flake.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        flake.BackgroundTransparency = math.random(transRange[1], transRange[2]) / 100
        flake.BorderSizePixel = 0
        flake.ZIndex = zIndex
        flake.Parent = parent
        Instance.new("UICorner", flake).CornerRadius = UDim.new(1, 0)

        table.insert(snowflakes, {
            frame = flake,
            startX = startX,
            speed = math.random(speedRange[1], speedRange[2]) / 100,
            sway = math.random(-20, 20) / 10000,
            phase = math.random() * math.pi * 2,
        })
    end
end

createSnow(SnowBack,  90, {2, 4}, {25, 55}, {12, 30}, 2)
createSnow(SnowFront, 45, {4, 8}, {10, 40}, {30, 70}, 10)

local snowConn = RunService.RenderStepped:Connect(function(dt)
    for _, d in ipairs(snowflakes) do
        if d.frame and d.frame.Parent then
            local pos = d.frame.Position
            local newY = pos.Y.Scale + d.speed * dt
            if newY > 1.05 then
                newY = -0.05
                d.startX = math.random()
                d.frame.Position = UDim2.new(d.startX, 0, newY, 0)
            else
                local sx = d.startX + math.sin(tick() * 1.2 + d.phase) * d.sway
                d.frame.Position = UDim2.new(sx, 0, newY, 0)
            end
        end
    end
end)

-- ===== 玻璃面板外发光（极淡白蓝色） =====

-- 内层光晕
local GlowLayerInner = Instance.new("Frame")
GlowLayerInner.Size = UDim2.new(0, 456, 0, 336)
GlowLayerInner.Position = UDim2.new(0.5, 0, 0.5, 0)
GlowLayerInner.AnchorPoint = Vector2.new(0.5, 0.5)
GlowLayerInner.BackgroundTransparency = 1
GlowLayerInner.BorderSizePixel = 0
GlowLayerInner.ZIndex = 4
GlowLayerInner.Parent = LoadingGui
Instance.new("UICorner", GlowLayerInner).CornerRadius = UDim.new(0, 32)

local GlowInnerStroke = Instance.new("UIStroke")
GlowInnerStroke.Thickness = 10
GlowInnerStroke.Color = Color3.fromRGB(210, 230, 255)
GlowInnerStroke.Transparency = 0.65
GlowInnerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GlowInnerStroke.Parent = GlowLayerInner

local GlowInnerGrad = Instance.new("UIGradient")
GlowInnerGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(220, 235, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 210, 255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(220, 235, 255)),
})
GlowInnerGrad.Rotation = 90
GlowInnerGrad.Parent = GlowInnerStroke

-- 外层光晕
local GlowLayerOuter = Instance.new("Frame")
GlowLayerOuter.Size = UDim2.new(0, 476, 0, 356)
GlowLayerOuter.Position = UDim2.new(0.5, 0, 0.5, 0)
GlowLayerOuter.AnchorPoint = Vector2.new(0.5, 0.5)
GlowLayerOuter.BackgroundTransparency = 1
GlowLayerOuter.BorderSizePixel = 0
GlowLayerOuter.ZIndex = 3
GlowLayerOuter.Parent = LoadingGui
Instance.new("UICorner", GlowLayerOuter).CornerRadius = UDim.new(0, 38)

local GlowOuterStroke = Instance.new("UIStroke")
GlowOuterStroke.Thickness = 16
GlowOuterStroke.Color = Color3.fromRGB(180, 210, 250)
GlowOuterStroke.Transparency = 0.88
GlowOuterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GlowOuterStroke.Parent = GlowLayerOuter

local GlowOuterGrad = Instance.new("UIGradient")
GlowOuterGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(200, 220, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 195, 245)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(200, 220, 255)),
})
GlowOuterGrad.Rotation = 90
GlowOuterGrad.Parent = GlowOuterStroke

-- 呼吸脉动
task.spawn(function()
    while GlowLayerInner and GlowLayerInner.Parent do
        TweenService:Create(GlowInnerStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.8,
        }):Play()
        TweenService:Create(GlowOuterStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.95,
        }):Play()
        task.wait(2)
        if not GlowLayerInner or not GlowLayerInner.Parent then break end
        TweenService:Create(GlowInnerStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.6,
        }):Play()
        TweenService:Create(GlowOuterStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.85,
        }):Play()
        task.wait(2)
    end
end)

-- ===== 玻璃面板（几乎无色，只带一点点冷调） =====
local GlassPanel = Instance.new("Frame")
GlassPanel.Size = UDim2.new(0, 440, 0, 320)
GlassPanel.Position = UDim2.new(0.5, 0, 0.5, 20)
GlassPanel.AnchorPoint = Vector2.new(0.5, 0.5)
GlassPanel.BackgroundColor3 = Color3.fromRGB(200, 220, 250)
GlassPanel.BackgroundTransparency = 0.82
GlassPanel.BorderSizePixel = 0
GlassPanel.ZIndex = 5
GlassPanel.Parent = LoadingGui
Instance.new("UICorner", GlassPanel).CornerRadius = UDim.new(0, 28)

-- 主渐变（淡蓝 → 淡白 → 淡蓝，色差很小）
local PanelGrad = Instance.new("UIGradient")
PanelGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(210, 225, 255)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(185, 205, 250)),
    ColorSequenceKeypoint.new(0.7,  Color3.fromRGB(170, 195, 245)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(150, 180, 235)),
})
PanelGrad.Rotation = 135
PanelGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.72),
    NumberSequenceKeypoint.new(0.35, 0.78),
    NumberSequenceKeypoint.new(0.7, 0.84),
    NumberSequenceKeypoint.new(1, 0.88),
})
PanelGrad.Parent = GlassPanel

-- 顶部柔光叠加（很淡的冷白光）
local TopLight = Instance.new("Frame")
TopLight.Size = UDim2.new(1, 0, 0, 140)
TopLight.Position = UDim2.new(0.5, 0, 0, 0)
TopLight.AnchorPoint = Vector2.new(0.5, 0)
TopLight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopLight.BackgroundTransparency = 1
TopLight.BorderSizePixel = 0
TopLight.ZIndex = 6
TopLight.Parent = GlassPanel
Instance.new("UICorner", TopLight).CornerRadius = UDim.new(0, 28)

local TopLightGrad = Instance.new("UIGradient")
TopLightGrad.Color = ColorSequence.new(Color3.fromRGB(240, 245, 255))
TopLightGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.7),
    NumberSequenceKeypoint.new(1, 1),
})
TopLightGrad.Rotation = 90
TopLightGrad.Parent = TopLight

-- 玻璃描边（白 → 淡蓝 → 白）
local GlassStroke = Instance.new("UIStroke")
GlassStroke.Thickness = 1.5
GlassStroke.Color = Color3.fromRGB(255, 255, 255)
GlassStroke.Transparency = 0.35
GlassStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GlassStroke.Parent = GlassPanel

local StrokeGrad = Instance.new("UIGradient")
StrokeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(210, 230, 255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 255, 255)),
})
StrokeGrad.Rotation = 90
StrokeGrad.Parent = GlassStroke

-- ===== 图标区（带极淡呼吸光晕） =====
local IconWrap = Instance.new("Frame")
IconWrap.Size = UDim2.new(0, 130, 0, 130)
IconWrap.Position = UDim2.new(0.5, 0, 0, 20)
IconWrap.AnchorPoint = Vector2.new(0.5, 0)
IconWrap.BackgroundTransparency = 1
IconWrap.ZIndex = 7
IconWrap.Parent = GlassPanel

local IconGlow = Instance.new("Frame")
IconGlow.Size = UDim2.new(0, 110, 0, 110)
IconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
IconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
IconGlow.BackgroundColor3 = Color3.fromRGB(220, 235, 255)
IconGlow.BackgroundTransparency = 0.8
IconGlow.BorderSizePixel = 0
IconGlow.ZIndex = 7
IconGlow.Parent = IconWrap
Instance.new("UICorner", IconGlow).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    while IconGlow and IconGlow.Parent do
        TweenService:Create(IconGlow, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 122, 0, 122),
            BackgroundTransparency = 0.9,
        }):Play()
        task.wait(1.6)
        if not IconGlow or not IconGlow.Parent then break end
        TweenService:Create(IconGlow, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 105, 0, 105),
            BackgroundTransparency = 0.75,
        }):Play()
        task.wait(1.6)
    end
end)

local Splash = Instance.new("ImageLabel")
Splash.Size = UDim2.new(0, 78, 0, 78)
Splash.Position = UDim2.new(0.5, 0, 0.5, 0)
Splash.AnchorPoint = Vector2.new(0.5, 0.5)
Splash.BackgroundTransparency = 1
Splash.Image = "rbxassetid://81780048927282" -- 【替换成你的Logo】
Splash.ScaleType = Enum.ScaleType.Fit
Splash.ZIndex = 9
Splash.Parent = IconWrap

local SplashCorner = Instance.new("UICorner")
SplashCorner.CornerRadius = UDim.new(0, 18)
SplashCorner.Parent = Splash

local SplashStroke = Instance.new("UIStroke")
SplashStroke.Thickness = 1.2
SplashStroke.Color = Color3.fromRGB(255, 255, 255)
SplashStroke.Transparency = 0.35
SplashStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SplashStroke.Parent = Splash

-- ===== 标题 =====
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 34)
Title.Position = UDim2.new(0.5, 0, 0, 155)
Title.AnchorPoint = Vector2.new(0.5, 0)
Title.BackgroundTransparency = 1
Title.Text = "龙卷脚本" -- 【替换成你的标题】
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextStrokeTransparency = 0.8
Title.TextStrokeColor3 = Color3.fromRGB(60, 100, 180)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.ZIndex = 7
Title.Parent = GlassPanel

-- ===== 状态提示胶囊 =====
local StatusBox = Instance.new("Frame")
StatusBox.Size = UDim2.new(0, 360, 0, 28)
StatusBox.Position = UDim2.new(0.5, 0, 0, 197)
StatusBox.AnchorPoint = Vector2.new(0.5, 0)
StatusBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StatusBox.BackgroundTransparency = 0.9
StatusBox.BorderSizePixel = 0
StatusBox.ZIndex = 7
StatusBox.Parent = GlassPanel
Instance.new("UICorner", StatusBox).CornerRadius = UDim.new(1, 0)

local StatusStroke = Instance.new("UIStroke")
StatusStroke.Thickness = 1
StatusStroke.Color = Color3.fromRGB(255, 255, 255)
StatusStroke.Transparency = 0.6
StatusStroke.Parent = StatusBox

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -20, 1, 0)
StatusText.Position = UDim2.new(0.5, 0, 0.5, 0)
StatusText.AnchorPoint = Vector2.new(0.5, 0.5)
StatusText.BackgroundTransparency = 1
StatusText.Text = "正在加载 UI库  /  准备读取缓存和网络资源"
StatusText.TextColor3 = Color3.fromRGB(245, 248, 255)
StatusText.TextStrokeTransparency = 0.85
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 11
StatusText.ZIndex = 8
StatusText.Parent = StatusBox

-- ===== Owner 文字 =====
local OwnerText = Instance.new("TextLabel")
OwnerText.Size = UDim2.new(1, 0, 0, 20)
OwnerText.Position = UDim2.new(0.5, 0, 0, 232)
OwnerText.AnchorPoint = Vector2.new(0.5, 0)
OwnerText.BackgroundTransparency = 1
OwnerText.Text = "Owner CypTec" -- 【替换成你的署名】
OwnerText.TextColor3 = Color3.fromRGB(255, 255, 255)
OwnerText.TextTransparency = 0.4
OwnerText.TextStrokeTransparency = 0.85
OwnerText.Font = Enum.Font.GothamMedium
OwnerText.TextSize = 12
OwnerText.ZIndex = 7
OwnerText.Parent = GlassPanel

-- ===== 进度条 =====
local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(0, 260, 0, 4)
BarBg.Position = UDim2.new(0.5, -20, 0, 265)
BarBg.AnchorPoint = Vector2.new(0.5, 0)
BarBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BarBg.BackgroundTransparency = 0.75
BarBg.BorderSizePixel = 0
BarBg.ZIndex = 7
BarBg.Parent = GlassPanel
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BarFill.BorderSizePixel = 0
BarFill.ZIndex = 8
BarFill.Parent = BarBg
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)
BarFill.ClipsDescendants = true

local BarShine = Instance.new("Frame")
BarShine.Size = UDim2.new(0, 40, 1, 0)
BarShine.Position = UDim2.new(-1, 0, 0, 0)
BarShine.BackgroundColor3 = Color3.fromRGB(210, 230, 255)
BarShine.BackgroundTransparency = 0.2
BarShine.BorderSizePixel = 0
BarShine.ZIndex = 9
BarShine.Parent = BarFill
Instance.new("UICorner", BarShine).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    while BarShine and BarShine.Parent do
        BarShine.Position = UDim2.new(-1, 0, 0, 0)
        TweenService:Create(BarShine, TweenInfo.new(1.8, Enum.EasingStyle.Linear), {
            Position = UDim2.new(1, 0, 0, 0),
        }):Play()
        task.wait(1.8)
    end
end)

-- 百分比
local Percent = Instance.new("TextLabel")
Percent.Size = UDim2.new(0, 40, 0, 14)
Percent.Position = UDim2.new(0.5, 120, 0, 260)
Percent.AnchorPoint = Vector2.new(0, 0)
Percent.BackgroundTransparency = 1
Percent.Text = "0%"
Percent.TextColor3 = Color3.fromRGB(255, 255, 255)
Percent.TextTransparency = 0.25
Percent.TextStrokeTransparency = 0.85
Percent.Font = Enum.Font.GothamMedium
Percent.TextSize = 11
Percent.TextXAlignment = Enum.TextXAlignment.Left
Percent.ZIndex = 7
Percent.Parent = GlassPanel

-- ===== 底部状态胶囊 =====
local LoadingBadge = Instance.new("Frame")
LoadingBadge.Size = UDim2.new(0, 110, 0, 26)
LoadingBadge.Position = UDim2.new(0.5, 0, 1, -30)
LoadingBadge.AnchorPoint = Vector2.new(0.5, 1)
LoadingBadge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LoadingBadge.BackgroundTransparency = 0.9
LoadingBadge.BorderSizePixel = 0
LoadingBadge.ZIndex = 7
LoadingBadge.Parent = GlassPanel
Instance.new("UICorner", LoadingBadge).CornerRadius = UDim.new(1, 0)

local BadgeStroke = Instance.new("UIStroke")
BadgeStroke.Thickness = 1
BadgeStroke.Color = Color3.fromRGB(255, 255, 255)
BadgeStroke.Transparency = 0.7
BadgeStroke.Parent = LoadingBadge

local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 6, 0, 6)
Dot.Position = UDim2.new(0, 14, 0.5, 0)
Dot.AnchorPoint = Vector2.new(0, 0.5)
Dot.BackgroundColor3 = Color3.fromRGB(210, 230, 255)
Dot.BorderSizePixel = 0
Dot.ZIndex = 8
Dot.Parent = LoadingBadge
Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    while Dot and Dot.Parent do
        TweenService:Create(Dot, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.7,
            Size = UDim2.new(0, 8, 0, 8),
        }):Play()
        task.wait(0.7)
        if not Dot or not Dot.Parent then break end
        TweenService:Create(Dot, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0,
            Size = UDim2.new(0, 6, 0, 6),
        }):Play()
        task.wait(0.7)
    end
end)

local BadgeText = Instance.new("TextLabel")
BadgeText.Size = UDim2.new(1, -20, 1, 0)
BadgeText.Position = UDim2.new(0, 20, 0, 0)
BadgeText.BackgroundTransparency = 1
BadgeText.Text = "加载中"
BadgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
BadgeText.TextTransparency = 0.15
BadgeText.TextStrokeTransparency = 0.85
BadgeText.Font = Enum.Font.GothamMedium
BadgeText.TextSize = 12
BadgeText.TextXAlignment = Enum.TextXAlignment.Center
BadgeText.ZIndex = 8
BadgeText.Parent = LoadingBadge

-- ===== 面板浮现动画 =====
GlassPanel.Position = UDim2.new(0.5, 0, 0.5, 40)
GlassPanel.BackgroundTransparency = 1
GlowLayerInner.Position = UDim2.new(0.5, 0, 0.5, 40)
GlowLayerOuter.Position = UDim2.new(0.5, 0, 0.5, 40)

TweenService:Create(GlassPanel, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundTransparency = 0.82,
}):Play()
TweenService:Create(GlowLayerInner, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.5, 0),
}):Play()
TweenService:Create(GlowLayerOuter, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.5, 0),
}):Play()

-- ===== 进度条动画 =====
local barTween = TweenService:Create(BarFill, TweenInfo.new(15, Enum.EasingStyle.Linear), { Size = UDim2.new(0.85, 0, 1, 0) })
barTween:Play()

task.spawn(function()
    while LoadingGui and LoadingGui.Parent do
        if BarFill and BarFill.Parent then
            Percent.Text = math.floor(BarFill.Size.X.Scale * 100) .. "%"
        end
        task.wait(0.05)
    end
end)


-- ============================================================
-- 加载 WindUI
-- ============================================================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
    Name        = "GreenHairTheme",
    Accent      = "2E4A3D",
    Outline     = "3A6B4D",
    Text        = "FFFFFF",
    Placeholder = "A3D9B6",
})

if barTween then barTween:Cancel() end
local currentScale = BarFill.Size.X.Scale
local remaining = 1 - currentScale
local fillTime = math.clamp(remaining * 1.2, 0.3, 0.8)
TweenService:Create(BarFill, TweenInfo.new(fillTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 1, 0) }):Play()
StatusText.Text = "加载完成"
task.wait(fillTime + 0.3)

-- 背景模糊淡出
TweenService:Create(BlurEffect, TweenInfo.new(0.6, Enum.EasingStyle.Quad), { Size = 0 }):Play()
task.delay(0.8, function()
    if BlurEffect then BlurEffect:Destroy() end
end)

-- 平滑淡出
local fadeOutList = {
    {GlassPanel, "BackgroundTransparency"},
    {GlassStroke, "Transparency"},
    {GlowInnerStroke, "Transparency"},
    {GlowOuterStroke, "Transparency"},
    {TopLight, "BackgroundTransparency"},
    {Splash, "ImageTransparency"},
    {SplashStroke, "Transparency"},
    {IconGlow, "BackgroundTransparency"},
    {Title, "TextTransparency"},
    {StatusBox, "BackgroundTransparency"},
    {StatusStroke, "Transparency"},
    {StatusText, "TextTransparency"},
    {OwnerText, "TextTransparency"},
    {BarBg, "BackgroundTransparency"},
    {BarFill, "BackgroundTransparency"},
    {Percent, "TextTransparency"},
    {LoadingBadge, "BackgroundTransparency"},
    {BadgeStroke, "Transparency"},
    {BadgeText, "TextTransparency"},
    {Dot, "BackgroundTransparency"},
}

for _, item in ipairs(fadeOutList) do
    local obj, prop = item[1], item[2]
    if obj and obj.Parent then
        TweenService:Create(obj, TweenInfo.new(0.6), { [prop] = 1 }):Play()
    end
end

task.wait(0.6)
if snowConn then snowConn:Disconnect() end
LoadingGui:Destroy()

-- ============================================================
-- 加载 WindUI (绿色流光UI)
-- ============================================================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
WindUI.TransparencyValue = 0.2

WindUI:AddTheme({
    Name             = "GreenHairTheme",
    Accent           = "2E4A3D",
    Outline          = "3A6B4D",
    Text             = "FFFFFF",
    Placeholder      = "A3D9B6",
    Background       = Color3.fromRGB(20, 30, 25),
    ElementBackground= Color3.fromRGB(35, 50, 40),
    WindowBackground = Color3.fromRGB(20, 30, 25),
})
WindUI:SetTheme("GreenHairTheme")

local Window = WindUI:CreateWindow({
    Title = "龙卷",
    Icon = "rbxassetid://75100441864312",
    Author = "作者 CypTec",
    Folder = "LongJuan",
    Size = UDim2.fromOffset(620, 460),
    Theme = "GreenHairTheme",
    SideBarWidth = 220,
    ScrollBarEnabled = true,
    HasOutline = true,
    User = { Enabled = true, Anonymous = false },
})

local borderAnimation
local animationSpeed = 3
local function createGradientBorder(window)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    local existingStroke = mainFrame:FindFirstChild("GradientStroke")
    if existingStroke then existingStroke:Destroy() end
    if not mainFrame:FindFirstChildOfClass("UICorner") then Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16) end
    local gradientStroke = Instance.new("UIStroke")
    gradientStroke.Name = "GradientStroke"
    gradientStroke.Thickness = 2
    gradientStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    gradientStroke.LineJoinMode = Enum.LineJoinMode.Round
    gradientStroke.Parent = mainFrame
    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    glowEffect.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("3A6B4D")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("A3D9B6")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("3A6B4D"))
    })
    glowEffect.Parent = gradientStroke
    return gradientStroke
end
local function startBorderAnimation(window, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end
    local gradientStroke = mainFrame:FindFirstChild("GradientStroke")
    if not gradientStroke then return nil end
    local glowEffect = gradientStroke:FindFirstChild("GlowEffect")
    if not glowEffect then return nil end
    return game:GetService("RunService").Heartbeat:Connect(function()
        if not gradientStroke or gradientStroke.Parent == nil then return end
        glowEffect.Rotation = (tick() * speed * 60) % 360
    end)
end
local gradientStroke = createGradientBorder(Window)
if gradientStroke then borderAnimation = startBorderAnimation(Window, animationSpeed) end

Window:EditOpenButton({
    Title = "", Icon = "rbxassetid://90581686679780", CornerRadius = UDim.new(0, 16), StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("3A6B4D"), Color3.fromHex("A3D9B6")), Draggable = true,
})
task.spawn(function()
    local t = 0
    while Window do
        task.wait(0.05)
        t = t + 0.05
        local wave = (math.sin(t * 2) + 1) / 2
        local c1 = Color3.fromHex("3A6B4D"):Lerp(Color3.fromHex("A3D9B6"), wave)
        local c2 = Color3.fromHex("A3D9B6"):Lerp(Color3.fromHex("3A6B4D"), wave)
        pcall(function()
            Window:EditOpenButton({
                Title = "", Icon = "rbxassetid://90581686679780", CornerRadius = UDim.new(0, 16), StrokeThickness = 2,
                Color = ColorSequence.new(c1, c2), Draggable = true,
            })
        end)
    end
end)

task.spawn(function()
    task.wait(2)
    for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("ImageLabel") and (obj.Name == "Icon" or obj.Name == "Image") then
                    obj.Image = "rbxassetid://90581686679780"
                    obj.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    obj.ScaleType = Enum.ScaleType.Fit
                end
            end
        end
    end
end)

Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
end, 990)

task.spawn(function()
    task.wait(2)
    local CoreGui = game:GetService("CoreGui")
    local GREEN_LIGHT = Color3.fromHex("A3D9B6")
    local ICON_COLOR  = Color3.fromRGB(255, 255, 255)
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    local name = (obj.Name or ""):lower()
                    if name:find("minim") or name:find("minus") then obj:Destroy()
                    elseif name:find("close") or name:find("exit") or name == "x" then
                        obj.BackgroundColor3 = GREEN_LIGHT
                        if obj.Parent and obj.Parent:IsA("Frame") then obj.Parent.BackgroundColor3 = GREEN_LIGHT end
                        for _, d in ipairs(obj:GetDescendants()) do
                            if d:IsA("ImageLabel") or d:IsA("ImageButton") then d.ImageColor3 = ICON_COLOR end
                        end
                    end
                end
            end
        end
    end
end)

Window:SetToggleKey(Enum.KeyCode.K)

-- ============================================================
-- 标签页
-- ============================================================
local Tabs = {
    Main       = Window:Tab({ Title = "主页",       Icon = "house" }),
    Player     = Window:Tab({ Title = "玩家功能",   Icon = "zap" }),
    Common     = Window:Tab({ Title = "通用",       Icon = "toolbox" }),
    Visual     = Window:Tab({ Title = "透视",       Icon = "eye" }),
    Fling      = Window:Tab({ Title = "甩飞",       Icon = "send" }),
    Chat       = Window:Tab({ Title = "消息",       Icon = "message-circle" }),
    Interact   = Window:Tab({ Title = "互动",       Icon = "zap" }),
    Light      = Window:Tab({ Title = "滤镜与光影", Icon = "sun" }),
    Night      = Window:Tab({ Title = "夜视",       Icon = "moon" }),
    Fun        = Window:Tab({ Title = "娱乐",       Icon = "gamepad-2" }),
    Music      = Window:Tab({ Title = "音乐",       Icon = "music" }),
    Animation  = Window:Tab({ Title = "动画",       Icon = "star" }),
    Misc       = Window:Tab({ Title = "杂项",       Icon = "toolbox" }),
    Scripts    = Window:Tab({ Title = "脚本大全",   Icon = "download" }),
    Server     = Window:Tab({ Title = "服务器脚本", Icon = "server" }),
}
Window:SelectTab(1)


-- ============================================================
-- 主页
-- ============================================================
Tabs.Main:Paragraph({
    Title = "欢迎使用龙卷脚本",
    Desc = "新手制作",
    Image = "rbxassetid://81780048927282",
    ImageSize = 34,
    Thumbnail = "rbxassetid://83309978374356",
    ThumbnailSize = 120,
})

local copyButtons = {}
for _, item in ipairs(CopyItems) do
    table.insert(copyButtons, {
        Title = item.Title,
        Variant = "Primary",
        Icon = item.Icon,
        Callback = function()
            if CopyToClipboard(item.Text) then
                WindUI:Notify({ Title = "复制成功", Content = item.Text, Icon = "check", Duration = 3 })
            else
                WindUI:Notify({ Title = "复制失败", Content = "请手动复制：" .. item.Text, Icon = "triangle-alert", Duration = 5 })
            end
        end,
    })
end

Tabs.Main:Paragraph({
    Title = "此脚本免费禁止倒卖",
    Desc = "作者：CypTec",
    Image = "rbxassetid://114856747961077",
    ImageSize = 34,
    Thumbnail = "rbxassetid://112493898480660",
    ThumbnailSize = 120,
    Buttons = copyButtons,
})


-- ============================================================
-- 玩家功能 - 本地玩家
-- ============================================================
local LPS = Tabs.Player:Section({ Title = "本地玩家" })

LPS:Toggle({
    Title = "开启速度修改", Default = false,
    Callback = function(v)
        SpeedEnabled = v
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if v then hum.WalkSpeed = TargetWalkSpeed else hum.WalkSpeed = OriginalWalkSpeed end
        end
    end
})

LPS:Input({
    Title = "速度数值", Desc = "0 - 400", Placeholder = "默认 16",
    Callback = function(value)
        local n = tonumber(value)
        if n then
            TargetWalkSpeed = math.clamp(n, 0, 400)
            if SpeedEnabled then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = TargetWalkSpeed end
            end
        end
    end
})

LPS:Toggle({
    Title = "开启快速跑步", Default = false,
    Callback = function(enabled)
        if enabled then
            if sudu then sudu:Disconnect() end
            sudu = RunService.Heartbeat:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
                    LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection * Speed / 0.5)
                end
            end)
        else
            if sudu then sudu:Disconnect() sudu = nil end
        end
    end
})

LPS:Input({
    Title = "快速跑步强度", Placeholder = "0-200", Default = tostring(Speed or 0),
    Callback = function(text)
        local n = tonumber(text)
        if n then Speed = math.clamp(n, 0, 200) end
    end
})

LPS:Toggle({
    Title = "开启跳跃修改", Default = false,
    Callback = function(v)
        CustomJumpEnabled = v
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if v then
                hum.UseJumpPower = true
                hum.JumpPower = CustomJumpValue
            else
                hum.JumpPower = OriginalJump
            end
        end
    end
})

LPS:Slider({
    Title = "跳跃高度",
    Value = { Min = 50, Max = 600, Default = 50 },
    Increment = 1,
    Callback = function(value)
        CustomJumpValue = value
        if CustomJumpEnabled then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = value
            end
        end
    end
})

local GravityEnabled  = false
local CustomGravity   = 196.2
local OriginalGravity = workspace.Gravity

RunService.RenderStepped:Connect(function()
    if not GravityEnabled then return end
    if workspace.Gravity ~= CustomGravity then workspace.Gravity = CustomGravity end
end)

LPS:Toggle({
    Title = "重力控制", Desc = "开启后可自定义重力", Default = false,
    Callback = function(state)
        if state then
            OriginalGravity = workspace.Gravity
            workspace.Gravity = CustomGravity
            GravityEnabled = true
        else
            GravityEnabled = false
            workspace.Gravity = OriginalGravity or 196.2
        end
    end
})

LPS:Input({
    Title = "重力数值", Desc = "默认196.2", Placeholder = "196.2",
    Callback = function(val)
        local n = tonumber(val)
        if not n then return end
        CustomGravity = math.clamp(n, 0, 500)
        if GravityEnabled then workspace.Gravity = CustomGravity end
    end
})

LPS:Toggle({
    Title = "无限跳跃", Default = false,
    Callback = function(v) InfiniteJumpEnabled = v end
})

UIS.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState("Jumping") end
        end
    end
end)

local NoclipConnection    = nil
local CharacterConnection = nil
local OriginalCollision   = {}

LPS:Toggle({
    Title = "穿墙", Default = false,
    Callback = function(enabled)
        if enabled then
            OriginalCollision = {}
            if CharacterConnection then CharacterConnection:Disconnect() end
            CharacterConnection = LocalPlayer.CharacterAdded:Connect(function() OriginalCollision = {} end)
            if NoclipConnection then NoclipConnection:Disconnect() end
            NoclipConnection = RunService.Stepped:Connect(function()
                local character = LocalPlayer.Character
                if not character then return end
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if OriginalCollision[part] == nil then OriginalCollision[part] = part.CanCollide end
                        part.CanCollide = false
                    end
                end
            end)
        else
            if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil end
            if CharacterConnection then CharacterConnection:Disconnect() CharacterConnection = nil end
            for part, state in pairs(OriginalCollision) do
                if typeof(part) == "Instance" and part.Parent then part.CanCollide = state end
            end
            OriginalCollision = {}
        end
    end
})

LPS:Toggle({
    Title = "防摔落伤害", Default = false,
    Callback = function(v) ToggleAntiFall(v) end
})

LPS:Toggle({
    Title = "防摔落伤害2（1没用再开）", Default = false,
    Callback = function(state)
        AntiFall2Enabled = state
        if state then
            Notify("防摔落伤害2", "已开启", 3)
            local char = LocalPlayer.Character
            if char then StartAntiFall2(char) end
        else
            Notify("防摔落伤害2", "已关闭", 3)
        end
    end
})


-- ============================================================
-- 通用标签页
-- ============================================================
Tabs.Common:Button({
    Title = "飞行",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/z1mFBr9I/raw"))()
    end,
})

Tabs.Common:Button({
    Title = "飞车",
    Icon = "car",
    Callback = function()
        Notify("通用", "正在加载飞车...", 3)
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-SILLY-CAR-V1-48227"))()
        end)
        if ok then
            Notify("通用", "飞车加载成功！", 3)
        else
            Notify("加载失败", tostring(err):sub(1, 80), 5)
        end
    end
})

Tabs.Common:Toggle({
    Title = "自由视角", Default = false,
    Callback = function(v)
        if v then
            StartFreecam()
            Notify("自由视角", "已开启", 2)
        else
            StopFreecam()
            Notify("自由视角", "已关闭", 2)
        end
    end
})

Tabs.Common:Slider({
    Title = "自由视角速度",
    Value = { Min = 1, Max = 20, Default = 2 },
    Increment = 0.5,
    Callback = function(value) Freecam.Speed = value end
})

Tabs.Common:Toggle({
    Title = "定点传送", Default = false,
    Callback = function(v)
        if v then
            EnableTPUI()
            Notify("定点传送", "已开启", 2)
        else
            DisableTPUI()
            Notify("定点传送", "已关闭", 2)
        end
    end
})

-- ===== 强制第三人称 =====
Tabs.Common:Toggle({
    Title = "强制第三人称", Default = false,
    Callback = function(v)
        if v then EnableUnlock() Notify("相机", "已强制第三人称", 2)
        else DisableUnlock() Notify("相机", "已关闭强制", 2) end
    end
})

Tabs.Common:Input({
    Title = "最大视距", Placeholder = "默认 128，如 500",
    Callback = function(t)
        local n = tonumber(t)
        if n then LocalPlayer.CameraMaxZoomDistance = n Notify("相机", "最大视距 " .. n, 2) end
    end
})

Tabs.Common:Button({
    Title = "普京比例",
    Callback = function() ApplyPutinRatio(0.65) end
})

Tabs.Common:Button({
    Title = "恢复比例",
    Callback = function() RestoreRatio() end
})

-- ===== 踏空行走 =====
Tabs.Common:Button({
    Title = "踏空行走",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))() end)
        if ok then Notify("踏空", "启动成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

-- ===== 点击传送工具 =====
Tabs.Common:Button({
    Title = "获取点击传送工具",
    Callback = function()
        local ok, err = pcall(function()
            local mouse = LocalPlayer:GetMouse()
            local tool = Instance.new("Tool")
            tool.RequiresHandle = false
            tool.Name = "[FE] 点击传送"
            tool.Activated:Connect(function()
                local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
                pos = CFrame.new(pos.X, pos.Y, pos.Z)
                local c = LocalPlayer.Character
                if c then
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.CFrame = pos end
                end
            end)
            tool.Parent = LocalPlayer:WaitForChild("Backpack")
        end)
        if ok then Notify("传送工具", "已放入背包", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

-- ===== 旋转恶搞 =====
Tabs.Common:Button({
    Title = "快速旋转",
    Callback = function() TXH_Spin(30) end
})

Tabs.Common:Button({
    Title = "极速旋转",
    Callback = function() TXH_Spin(500) end
})

Tabs.Common:Button({
    Title = "停止旋转",
    Callback = function() StopSpin() end
})

-- ===== 防甩飞 =====
Tabs.Common:Toggle({
    Title = "防甩飞", Default = false,
    Callback = function(s)
        if s then EnableAntiFling() Notify("防甩飞", "已开启", 2)
        else DisableAntiFling() Notify("防甩飞", "已关闭", 2) end
    end
})


-- ============================================================
-- ⭐ 透视标签页（夜脚本高清版缝合）
-- ============================================================
Tabs.Visual:Paragraph({
    Title = "提示",
    Desc = "旧版互动少但中文，新版更多但英文"
})

-- ================= 【第一类：玩家透视】变量与逻辑 =================
local PLAYER_ESP = {
    Enabled = false, HighlightEnabled = false, BoxEnabled = false,
    TeamCheck = false, ShowName = false, ShowHealth = false, ShowDist = false
}

local function ClearPlayerESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "PlayerESP_Highlight" or obj.Name == "PlayerESP_Info" or obj.Name == "PlayerESP_Box" then
            obj:Destroy()
        end
    end
end

local function UpdatePlayerESP()
    if not PLAYER_ESP.Enabled then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")
            local root = char:FindFirstChild("HumanoidRootPart")

            if hum and head and root and hum.Health > -500 then
                local isTeam = (p.Team == LocalPlayer.Team)
                local filtered = PLAYER_ESP.TeamCheck and isTeam
                local color = p.TeamColor.Color

                -- 高亮
                local high = char:FindFirstChild("PlayerESP_Highlight")
                if PLAYER_ESP.HighlightEnabled then
                    if not high then
                        high = Instance.new("Highlight", char)
                        high.Name = "PlayerESP_Highlight"
                    end
                    high.FillColor = color
                    high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                elseif high then
                    high:Destroy()
                end

                -- 方框
                local box = char:FindFirstChild("PlayerESP_Box")
                if PLAYER_ESP.BoxEnabled and not filtered then
                    if not box then
                        box = Instance.new("BillboardGui", char)
                        box.Name = "PlayerESP_Box"
                        box.Size = UDim2.new(4.5,0,6,0)
                        box.AlwaysOnTop = true
                        box.Adornee = root
                        local f = Instance.new("Frame", box)
                        f.Size = UDim2.new(1,0,1,0)
                        f.BackgroundTransparency = 1
                        local s = Instance.new("UIStroke", f)
                        s.Thickness = 1.5
                    end
                    box.Frame.UIStroke.Color = color
                elseif box then
                    box:Destroy()
                end

                -- 信息
                local info = char:FindFirstChild("PlayerESP_Info")
                if not filtered then
                    if not info then
                        info = Instance.new("BillboardGui", char)
                        info.Name = "PlayerESP_Info"
                        info.Size = UDim2.new(0,200,0,50)
                        info.AlwaysOnTop = true
                        info.Adornee = head
                        info.ExtentsOffset = Vector3.new(0,3.5,0)
                        local txt = Instance.new("TextLabel", info)
                        txt.Name = "Label"
                        txt.Size = UDim2.new(1,0,1,0)
                        txt.BackgroundTransparency = 1
                        txt.RichText = true
                        txt.TextStrokeTransparency = 0.5
                        txt.Font = Enum.Font.GothamMedium
                    end
                    local text = ""
                    if PLAYER_ESP.ShowName then
                        text = "<font color='#ffffff'><b>"..p.DisplayName.."</b></font>\n"
                    end
                    if PLAYER_ESP.ShowHealth then
                        local hp = math.floor(hum.Health)
                        local hpColor = (hp > 50 and "#55ff55" or "#ff5555")
                        text = text .. "<font color='"..hpColor.."'>HP: "..hp.."</font> "
                    end
                    if PLAYER_ESP.ShowDist then
                        local dist = math.floor((Camera.CFrame.Position - root.Position).Magnitude)
                        text = text .. "<font color='#ffffff'>| "..dist.."m</font>"
                    end
                    info.Label.Text = text
                elseif info then
                    info:Destroy()
                end
            end
        end
    end
end

-- ================= 【第二类：NPC透视】变量与逻辑 =================
local NPCESP = { Enabled = false, Color = Color3.fromRGB(0,162,255), Highlights = {} }

local function GetNPCPart(model)
    if not model then return nil end
    if model:FindFirstChild("HumanoidRootPart") then return model.HumanoidRootPart end
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") then return part end
    end
    return nil
end

local function AddNPCESP(model)
    if not model or NPCESP.Highlights[model] then return end
    if not model:FindFirstChildWhichIsA("Humanoid") then return end
    if game.Players:GetPlayerFromCharacter(model) then return end
    local part = GetNPCPart(model)
    if not part then return end
    
    local h = Instance.new("Highlight")
    h.Name = "NPCESP"
    h.Adornee = model
    h.FillColor = NPCESP.Color
    h.OutlineColor = Color3.fromRGB(255,255,255)
    h.FillTransparency = 0.4
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = game.CoreGui
    NPCESP.Highlights[model] = h
end

local function RemoveNPCESP(model)
    if NPCESP.Highlights[model] then
        NPCESP.Highlights[model]:Destroy()
        NPCESP.Highlights[model] = nil
    end
end

local function ToggleNPCESP(state)
    NPCESP.Enabled = state
    if state then
        task.spawn(function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") then task.spawn(AddNPCESP, obj) end
            end
        end)
        if not _G.NPCConn then
            _G.NPCConn = workspace.DescendantAdded:Connect(function(child)
                task.delay(0.5, function()
                    if child:IsA("Model") then AddNPCESP(child) 
                    elseif child:IsA("Humanoid") then AddNPCESP(child.Parent) end
                end)
            end)
        end
    else
        for model, _ in pairs(NPCESP.Highlights) do RemoveNPCESP(model) end
        if _G.NPCConn then _G.NPCConn:Disconnect() _G.NPCConn = nil end
    end
end

-- ================= 【第三类：互动透视】变量与逻辑 =================
-- 1. 旧版互动
local InteractESP = { Enabled = false, Color = Color3.fromRGB(0,255,0), Highlights = {} }
local function IsInteractive_Old(obj) return obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") end

local function AddInteractESP(target)
    if not target or InteractESP.Highlights[target] then return end
    if not (target:IsA("BasePart") or target:IsA("Model")) then return end
    local h = Instance.new("Highlight")
    h.Name = "InteractESP"
    h.Adornee = target
    h.FillColor = InteractESP.Color
    h.OutlineColor = Color3.fromRGB(255,255,255)
    h.FillTransparency = 0.5
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = target
    InteractESP.Highlights[target] = h
end

local function ToggleInteractESP(state)
    InteractESP.Enabled = state
    if state then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if IsInteractive_Old(obj) and obj.Parent then AddInteractESP(obj.Parent) end
        end
        if not _G.IntConn then
            _G.IntConn = workspace.DescendantAdded:Connect(function(child)
                task.delay(1, function()
                    if child and IsInteractive_Old(child) and child.Parent then AddInteractESP(child.Parent) end
                end)
            end)
        end
    else
        -- 👇 这里是修复后的代码：只销毁高亮，不销毁游戏实体 👇
        for target, hl in pairs(InteractESP.Highlights) do
            if hl then hl:Destroy() end
            InteractESP.Highlights[target] = nil
        end
        -- 👆 修复结束 👆
        InteractESP.Highlights = {}
        if _G.IntConn then _G.IntConn:Disconnect() _G.IntConn = nil end
    end
end

-- 2. 新版互动
local NewInteractESP = { Enabled = false, Color = Color3.fromRGB(0,255,0), Highlights = {} }
local function IsInteractive_New(o) return o and (o:IsA("ProximityPrompt") or o:IsA("ClickDetector")) end
local function GetInteractiveTarget(node)
    local p = node
    while p do if p:IsA("BasePart") or p:IsA("Model") then return p end p = p.Parent end
    return nil
end

local function AddNewInteractESP(target)
    if not target or NewInteractESP.Highlights[target] then return end
    local hl = Instance.new("Highlight")
    hl.Name = "NewInteractESP"
    hl.Adornee = target
    hl.FillColor = NewInteractESP.Color
    hl.OutlineColor = Color3.new(1,1,1)
    hl.FillTransparency = .5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = target
    NewInteractESP.Highlights[target] = hl
end

local function ToggleNewInteractESP(state)
    NewInteractESP.Enabled = state
    if state then
        task.spawn(function()
            for _, v in ipairs(workspace:GetDescendants()) do
                if IsInteractive_New(v) then
                    local t = GetInteractiveTarget(v)
                    if t then AddNewInteractESP(t) end
                end
            end
        end)
        if not _G.NewIntConn then
            _G.NewIntConn = workspace.DescendantAdded:Connect(function(c)
                task.delay(0.05, function()
                    if c and c.GetDescendants then
                        for _, d in pairs(c:GetDescendants()) do
                            if IsInteractive_New(d) then
                                local t = GetInteractiveTarget(d)
                                if t then AddNewInteractESP(t) end
                            end
                        end
                    end
                end)
            end)
        end
    else
        for t, h in pairs(NewInteractESP.Highlights) do if h then h:Destroy() end end
        NewInteractESP.Highlights = {}
        if _G.NewIntConn then _G.NewIntConn:Disconnect() _G.NewIntConn = nil end
    end
end

-- 主循环更新玩家透视
RunService.RenderStepped:Connect(function()
    if PLAYER_ESP.Enabled then
        UpdatePlayerESP()
    end
end)

-- ================= 【UI 控制面板】 =================
Tabs.Visual:Toggle({ Title = "玩家透视 (总开关)", Default = false, Callback = function(v)
    PLAYER_ESP.Enabled = v
    if not v then ClearPlayerESP() end
end })
Tabs.Visual:Toggle({ Title = "玩家高亮", Default = false, Callback = function(v) PLAYER_ESP.HighlightEnabled = v end })
Tabs.Visual:Toggle({ Title = "玩家方框", Default = false, Callback = function(v) PLAYER_ESP.BoxEnabled = v end })
Tabs.Visual:Toggle({ Title = "显示名字", Default = false, Callback = function(v) PLAYER_ESP.ShowName = v end })
Tabs.Visual:Toggle({ Title = "显示血量", Default = false, Callback = function(v) PLAYER_ESP.ShowHealth = v end })
Tabs.Visual:Toggle({ Title = "显示距离", Default = false, Callback = function(v) PLAYER_ESP.ShowDist = v end })
Tabs.Visual:Toggle({ Title = "玩家队伍检测", Default = false, Callback = function(v) PLAYER_ESP.TeamCheck = v end })

Tabs.Visual:Toggle({ Title = "NPC透视", Default = false, Callback = function(v)
    ToggleNPCESP(v)
end })

Tabs.Visual:Toggle({ Title = "旧版互动透视", Default = false, Callback = function(v)
    ToggleInteractESP(v)
end })

Tabs.Visual:Toggle({ Title = "新版互动透视", Default = false, Callback = function(v)
    ToggleNewInteractESP(v)
end })

Tabs.Visual:Button({ Title = "刷新新版ESP", Callback = function()
    ToggleNewInteractESP(false)
    task.wait(0.2)
    ToggleNewInteractESP(true)
end })
-- ============================================================
-- ⭐ 透视结束
-- ============================================================

-- ============================================================
-- ⭐ 甩飞标签页
-- ============================================================
Tabs.Fling:Paragraph({
    Title = "警告",
    Desc = "不要在循环甩飞时手动重生，否则可能报错"
})

local Fling_Dropdown = nil

local function CreateFlingDropdown(lastSel)
    local list = {"所有人"}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    if Fling_Dropdown then
        Fling_Dropdown:Refresh(list, lastSel)
    else
        Fling_Dropdown = Tabs.Fling:Dropdown({
            Title = "选择玩家",
            Values = list,
            Default = lastSel,
            Callback = function(v)
                if typeof(v) == "table" then v = v.Value or v[1] end
                if not v then return end
                if v == "所有人" then
                    TP_SelectedPlayer = "ALL"
                    SelectedTarget = nil
                    return
                end
                local plr = Players:FindFirstChild(v)
                if plr then
                    TP_SelectedPlayer = plr
                    SelectedTarget = plr
                end
            end
        })
    end
end

Tabs.Fling:Button({
    Title = "刷新玩家列表",
    Callback = function()
        local last = nil
        if typeof(TP_SelectedPlayer) == "Instance" then last = TP_SelectedPlayer.Name
        elseif TP_SelectedPlayer == "ALL" then last = "所有人" end
        CreateFlingDropdown(last)
    end
})

Tabs.Fling:Button({
    Title = "甩飞一次",
    Callback = function()
        if TP_SelectedPlayer == "ALL" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    SkidFling(p)
                    repeat task.wait() until not Flinging
                    task.wait(0.1)
                end
            end
        else
            local t = TP_SelectedPlayer or SelectedTarget
            if t then SkidFling(t) end
        end
    end
})

Tabs.Fling:Toggle({
    Title = "循环甩飞", Default = false,
    Callback = function(v)
        if v then StartFlingLoop() else StopFlingLoop() end
    end
})

Tabs.Fling:Toggle({
    Title = "观战玩家", Default = false,
    Callback = function(v)
        if v then
            local t = TP_SelectedPlayer or SelectedTarget
            if t then SpectatePlayer(t) end
        else
            StopSpectate()
        end
    end
})

Tabs.Fling:Button({
    Title = "传送到玩家",
    Callback = function()
        local t = TP_SelectedPlayer
        if t then TeleportToPlayer(t) end
    end
})

Tabs.Fling:Button({
    Title = "拉到身边",
    Callback = function()
        local t = TP_SelectedPlayer
        if t then PullPlayerToSelf(t) end
    end
})

local Fling_LoopConn = nil
Tabs.Fling:Toggle({
    Title = "循环传送", Default = false,
    Callback = function(v)
        TP_Loop = v
        if v then
            AlreadyNotified = {}
            Fling_LoopConn = RunService.Heartbeat:Connect(function()
                local target = TP_SelectedPlayer or SelectedTarget
                if target then TeleportToPlayer(target) end
            end)
        else
            if Fling_LoopConn then
                Fling_LoopConn:Disconnect()
                Fling_LoopConn = nil
            end
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    end
})

task.delay(1, function()
    CreateFlingDropdown(nil)
end)


-- ============================================================
-- ⭐ 消息标签页
-- ============================================================
Tabs.Chat:Section({ Title = "自动发言设置" })

Tabs.Chat:Input({
    Title = "消息内容", Placeholder = "输入你要说的话",
    Callback = function(txt) sayMessage = txt end
})

Tabs.Chat:Input({
    Title = "发言次数", Placeholder = "默认 1",
    Callback = function(txt) sayCount = tonumber(txt) or 1 end
})

Tabs.Chat:Toggle({
    Title = "发言开关", Default = false,
    Callback = function(s)
        isSpeaking = s
        if s then
            if sayMessage == "" then Notify("错误", "请先输入要说的内容", 3) isSpeaking = false return end
            speakThread = task.spawn(function()
                for i = 1, sayCount do
                    if not isSpeaking then break end
                    SendChatMessage(sayMessage)
                    task.wait(0.5)
                end
                isSpeaking = false
            end)
            Notify("消息", "开始发送", 2)
        else
            if speakThread then task.cancel(speakThread) speakThread = nil end
            Notify("消息", "已停止", 2)
        end
    end
})


-- ============================================================
-- ⭐ 互动标签页
-- ============================================================
Tabs.Interact:Section({ Title = "快捷互动" })

Tabs.Interact:Toggle({
    Title = "快速互动", Default = false,
    Callback = function(s)
        if s then EnableQuickInteract() Notify("互动", "快速互动已开启", 2)
        else DisableQuickInteract() Notify("互动", "快速互动已关闭", 2) end
    end
})

Tabs.Interact:Toggle({
    Title = "自动互动", Default = false,
    Callback = function(state)
        if state then EnableAutoInteract() Notify("互动", "自动互动已开启", 2)
        else DisableAutoInteract() Notify("互动", "自动互动已关闭", 2) end
    end
})

Tabs.Interact:Input({
    Title = "互动距离", Placeholder = "默认 10，如 20",
    Callback = function(t)
        local n = tonumber(t)
        if not n or n <= 0 then return end
        interactRangeValue = n
        if interactRangeEnabled then
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("ProximityPrompt") then ApplyInteractRange(d) end
            end
        end
        Notify("互动", "互动距离 = " .. n, 1)
    end
})

Tabs.Interact:Toggle({
    Title = "启用互动距离", Default = false,
    Callback = function(s)
        if s then EnableInteractRange() Notify("互动", "互动距离 " .. interactRangeValue .. " 已开启", 2)
        else DisableInteractRange() Notify("互动", "互动距离已关闭", 2) end
    end
})


-- ============================================================
-- ⭐ 滤镜与光影标签页
-- ============================================================
Tabs.Light:Section({ Title = "画质设置" })

Tabs.Light:Button({
    Title = "自定义画质包",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet('https://pastefy.app/xXkUxA0P/raw', true))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "巨好看光影",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml"))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "高亮全图",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/4LDKiJ5a"))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "着色器",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/JeckAsChristopher/h/refs/heads/main/loader.lua"))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "自定义光影",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/lyraEz/gvb/refs/heads/main/DeepGraphicsHub.lua'))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "白光影",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E7%99%BD%E5%85%89%E5%BD%B1.txt"))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "夜晚",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/%E5%A4%9C%E6%99%9A.txt"))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Button({
    Title = "RTX光影V1",
    Callback = function()
        local ok, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/RTXv1.txt"))() end)
        if ok then Notify("光影", "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
    end
})

Tabs.Light:Section({ Title = "环境光颜色" })

Tabs.Light:Button({ Title = "恢复默认", Callback = function() Lighting.Ambient = Color3.new(0, 0, 0) Notify("滤镜", "已恢复默认", 2) end })
Tabs.Light:Button({ Title = "全亮", Callback = function() Lighting.Ambient = Color3.new(1, 1, 1) Notify("滤镜", "全亮", 2) end })
Tabs.Light:Button({ Title = "超亮", Callback = function() Lighting.Ambient = Color3.new(2, 2, 2) Notify("滤镜", "超亮", 2) end })
Tabs.Light:Button({ Title = "红色", Callback = function() Lighting.Ambient = Color3.new(1, 0, 0) end })
Tabs.Light:Button({ Title = "绿色", Callback = function() Lighting.Ambient = Color3.new(0, 1, 0) end })
Tabs.Light:Button({ Title = "蓝色", Callback = function() Lighting.Ambient = Color3.new(0, 0, 1) end })

Tabs.Light:Section({ Title = "一键滤镜" })

Tabs.Light:Button({ Title = "电影感", Callback = function() ApplyFilterMovie() end })
Tabs.Light:Button({ Title = "鲜艳", Callback = function() ApplyFilterVivid() end })
Tabs.Light:Button({ Title = "暗黑", Callback = function() ApplyFilterDark() end })
Tabs.Light:Button({ Title = "复古", Callback = function() ApplyFilterRetro() end })
Tabs.Light:Button({ Title = "霓虹", Callback = function() ApplyFilterNeon() end })
Tabs.Light:Button({ Title = "恢复原状", Callback = function() RestoreFilter() end })


-- ============================================================
-- ⭐ 夜视标签页
-- ============================================================
Tabs.Night:Section({ Title = "夜视" })

Tabs.Night:Toggle({
    Title = "夜视", Default = false,
    Callback = function(s) ToggleNightVision(s) end
})

Tabs.Night:Toggle({
    Title = "去雾", Default = false,
    Callback = function(s) ToggleFog(s) end
})

Tabs.Night:Toggle({
    Title = "去阴影", Default = false,
    Callback = function(s)
        if s then EnableNoShadow() else DisableNoShadow() end
    end
})


-- ============================================================
-- ⭐ 动作功能标签页 (独立 Tab)
-- ============================================================
local TabFE = Window:Tab({
    Title = "动作功能",
    Icon = "eye",
    Locked = false,
})

TabFE:Paragraph({
    Title = "提示",
    Desc = "实测下面动作全部是别人可见，如果那个人是新进来的，需要重新开动作他才会可见。\n所有动作来自bs源码，感谢bs脚本！\n部分不可用是正常的，可能是动作代码被原作者删了。"
})

local player = Players.LocalPlayer
local currentTrack = nil

player.CharacterAdded:Connect(function()
    currentTrack = nil
end)

local function GetAnimator()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end
    return animator
end

local function PlayAnim(animId)
    local animator = GetAnimator()
    if currentTrack then
        currentTrack:Stop()
        currentTrack:Destroy()
        currentTrack = nil
    end
    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    local track = animator:LoadAnimation(anim)
    anim:Destroy()
    track.Priority = Enum.AnimationPriority.Action
    track.Looped = true
    track:Play()
    currentTrack = track
end

local function StopAllAnim()
    if currentTrack then
        currentTrack:Stop()
        currentTrack:Destroy()
        currentTrack = nil
    end
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
            end
        end
    end
end

TabFE:Button({
    Title = "关闭所有动作",
    Callback = function()
        StopAllAnim()
    end
})

TabFE:Button({ Title = "环绕身体动作", Callback = function() PlayAnim("rbxassetid://109873544976020") end })
TabFE:Button({ Title = "无头", Callback = function() PlayAnim("rbxassetid://78837807518622") end })
TabFE:Button({ Title = "直升机", Callback = function() PlayAnim("rbxassetid://95301257497525") end })
TabFE:Button({ Title = "飞机", Callback = function() PlayAnim("rbxassetid://82135680487389") end })
TabFE:Button({ Title = "坦克", Callback = function() PlayAnim("rbxassetid://94915612757079") end })
TabFE:Button({ Title = "假死", Callback = function() PlayAnim("rbxassetid://88130117312312") end })
TabFE:Button({ Title = "投降", Callback = function() PlayAnim("rbxassetid://100537772865440") end })
TabFE:Button({ Title = "加州女孩", Callback = function() PlayAnim("rbxassetid://124982597491660") end })
TabFE:Button({ Title = "直升机2", Callback = function() PlayAnim("rbxassetid://122951149300674") end })
TabFE:Button({ Title = "直升机3", Callback = function() PlayAnim("rbxassetid://91257498644328") end })
TabFE:Button({ Title = "街头舞蹈", Callback = function() PlayAnim("rbxassetid://108171959207138") end })
TabFE:Button({ Title = "街头跺脚", Callback = function() PlayAnim("rbxassetid://115048845533448") end })
TabFE:Button({ Title = "扑腾的鱼", Callback = function() PlayAnim("rbxassetid://79075971527754") end })
TabFE:Button({ Title = "江南Style", Callback = function() PlayAnim("rbxassetid://100531289776679") end })
TabFE:Button({ Title = "苹果糖舞", Callback = function() PlayAnim("rbxassetid://88315693621494") end })
TabFE:Button({ Title = "空中转圈", Callback = function() PlayAnim("rbxassetid://94324173536622") end })
TabFE:Button({ Title = "比心(左)", Callback = function() PlayAnim("rbxassetid://110936682778213") end })
TabFE:Button({ Title = "比心(右)", Callback = function() PlayAnim("rbxassetid://84671941093489") end })
TabFE:Button({ Title = "67", Callback = function() PlayAnim("rbxassetid://115439144505157") end })
TabFE:Button({ Title = "6", Callback = function() PlayAnim("rbxassetid://115439144505157") end })
TabFE:Button({ Title = "7", Callback = function() PlayAnim("rbxassetid://115439144505157") end })
TabFE:Button({ Title = "狗狗", Callback = function() PlayAnim("rbxassetid://78195344190486") end })
TabFE:Button({ Title = "MM2禅", Callback = function() PlayAnim("rbxassetid://86872878957632") end })
TabFE:Button({ Title = "默认舞蹈", Callback = function() PlayAnim("rbxassetid://88455578674030") end })
TabFE:Button({ Title = "坐下", Callback = function() PlayAnim("rbxassetid://97185364700038") end })
TabFE:Button({ Title = "哥萨克踢", Callback = function() PlayAnim("rbxassetid://119264600441310") end })
TabFE:Button({ Title = "战斗姿态", Callback = function() PlayAnim("rbxassetid://116763940575803") end })
TabFE:Button({ Title = "你是谁", Callback = function() PlayAnim("rbxassetid://81389876138766") end })
TabFE:Button({ Title = "摇摆坐", Callback = function() PlayAnim("rbxassetid://130995344283026") end })
TabFE:Button({ Title = "摇摆坐2", Callback = function() PlayAnim("rbxassetid://131836270858895") end })
TabFE:Button({ Title = "蠕虫舞", Callback = function() PlayAnim("rbxassetid://90333292347820") end })
TabFE:Button({ Title = "蛇", Callback = function() PlayAnim("rbxassetid://98476854035224") end })
TabFE:Button({ Title = "彼得死亡", Callback = function() PlayAnim("rbxassetid://129787664584610") end })
TabFE:Button({ Title = "沃尔特场景", Callback = function() PlayAnim("rbxassetid://113475147402830") end })
TabFE:Button({ Title = "可爱躺姿", Callback = function() PlayAnim("rbxassetid://80754582835479") end })
TabFE:Button({ Title = "暗影迪奥", Callback = function() PlayAnim("rbxassetid://92266904563270") end })
TabFE:Button({ Title = "承太郎姿势", Callback = function() PlayAnim("rbxassetid://122120443600865") end })
TabFE:Button({ Title = "JOJO姿势", Callback = function() PlayAnim("rbxassetid://120629563851640") end })
TabFE:Button({ Title = "漂浮躺", Callback = function() PlayAnim("rbxassetid://77840765435893") end })
TabFE:Button({ Title = "圣经天使", Callback = function() PlayAnim("rbxassetid://109873544976020") end })
TabFE:Button({ Title = "ME!ME!ME!", Callback = function() PlayAnim("rbxassetid://103235915424832") end })
TabFE:Button({ Title = "Xavier舞", Callback = function() PlayAnim("rbxassetid://90802740360125") end })
TabFE:Button({ Title = "中国舞", Callback = function() PlayAnim("rbxassetid://131758838511368") end })
TabFE:Button({ Title = "背头", Callback = function() PlayAnim("rbxassetid://74288964113793") end })
TabFE:Button({ Title = "车辆1", Callback = function() PlayAnim("rbxassetid://108747312576405") end })
TabFE:Button({ Title = "车辆2", Callback = function() PlayAnim("rbxassetid://76503595759461") end })
TabFE:Button({ Title = "车辆3", Callback = function() PlayAnim("rbxassetid://115245341767944") end })
TabFE:Button({ Title = "车辆4", Callback = function() PlayAnim("rbxassetid://127805235430271") end })
TabFE:Button({ Title = "车辆5", Callback = function() PlayAnim("rbxassetid://138003068153218") end })
TabFE:Button({ Title = "车辆6", Callback = function() PlayAnim("rbxassetid://116772752010894") end })
TabFE:Button({ Title = "车辆7", Callback = function() PlayAnim("rbxassetid://116625361313832") end })
TabFE:Button({ Title = "车辆8", Callback = function() PlayAnim("rbxassetid://81388785824317") end })
TabFE:Button({ Title = "车辆9", Callback = function() PlayAnim("rbxassetid://113181071290859") end })
TabFE:Button({ Title = "车辆10", Callback = function() PlayAnim("rbxassetid://134681712937413") end })
TabFE:Button({ Title = "车辆11", Callback = function() PlayAnim("rbxassetid://115260380433565") end })
TabFE:Button({ Title = "车辆12", Callback = function() PlayAnim("rbxassetid://72382226286301") end })
TabFE:Button({ Title = "击败Koto", Callback = function() PlayAnim("rbxassetid://93497729736287") end })
TabFE:Button({ Title = "经典行走", Callback = function() PlayAnim("rbxassetid://107806791584829") end })
TabFE:Button({ Title = "奇怪生物", Callback = function() PlayAnim("rbxassetid://87025086742503") end })
TabFE:Button({ Title = "马桶人", Callback = function() PlayAnim("rbxassetid://127154705636043") end })
TabFE:Button({ Title = "滚动哭宝", Callback = function() PlayAnim("rbxassetid://129699431093711") end })
TabFE:Button({ Title = "思考", Callback = function() PlayAnim("rbxassetid://127088545449493") end })
TabFE:Button({ Title = "迷幻", Callback = function() PlayAnim("rbxassetid://135611169366768") end })
TabFE:Button({ Title = "穿搭检查", Callback = function() PlayAnim("rbxassetid://81176957565811") end })
TabFE:Button({ Title = "假设", Callback = function() PlayAnim("rbxassetid://91294374426630") end })
TabFE:Button({ Title = "Griddy舞", Callback = function() PlayAnim("rbxassetid://121966805049108") end })
TabFE:Button({ Title = "认输", Callback = function() PlayAnim("rbxassetid://78653596566468") end })
TabFE:Button({ Title = "篮球头转", Callback = function() PlayAnim("rbxassetid://92854797386719") end })
TabFE:Button({ Title = "鹦鹉舞", Callback = function() PlayAnim("rbxassetid://101810746304426") end })
TabFE:Button({ Title = "射击", Callback = function() PlayAnim("rbxassetid://102691551292124") end })
TabFE:Button({ Title = "布娃娃", Callback = function() PlayAnim("rbxassetid://136224735234038") end })
TabFE:Button({ Title = "悲伤坐", Callback = function() PlayAnim("rbxassetid://100798804992348") end })
TabFE:Button({ Title = "汽水", Callback = function() PlayAnim("rbxassetid://105459130960429") end })
TabFE:Button({ Title = "比利弹跳", Callback = function() PlayAnim("rbxassetid://137501135905857") end })
TabFE:Button({ Title = "篮球", Callback = function() PlayAnim("rbxassetid://119242308765484") end })
TabFE:Button({ Title = "打桩机", Callback = function() PlayAnim("rbxassetid://91423662648449") end })
TabFE:Button({ Title = "怪物捣碎", Callback = function() PlayAnim("rbxassetid://137883764619555") end })
TabFE:Button({ Title = "芙兰玩偶", Callback = function() PlayAnim("rbxassetid://107217181254431") end })
TabFE:Button({ Title = "后空翻", Callback = function() PlayAnim("rbxassetid://131205329995035") end })
TabFE:Button({ Title = "漂浮", Callback = function() PlayAnim("rbxassetid://89523370947906") end })
TabFE:Button({ Title = "你好", Callback = function() PlayAnim("rbxassetid://103041144411206") end })
TabFE:Button({ Title = "附身", Callback = function() PlayAnim("rbxassetid://90708290447388") end })
TabFE:Button({ Title = "去你的!", Callback = function() PlayAnim("rbxassetid://98289978017308") end })
TabFE:Button({ Title = "摸头", Callback = function() PlayAnim("rbxassetid://85422671683973") end })
TabFE:Button({ Title = "上帝山羊漂浮", Callback = function() PlayAnim("rbxassetid://100405715895755") end })
TabFE:Button({ Title = "直升机4", Callback = function() PlayAnim("rbxassetid://115417853064013") end })
TabFE:Button({ Title = "网格舞", Callback = function() PlayAnim("rbxassetid://85588129788692") end })
TabFE:Button({ Title = "破碎", Callback = function() PlayAnim("rbxassetid://79757971761739") end })
TabFE:Button({ Title = "认输2", Callback = function() PlayAnim("rbxassetid://83265734904502") end })
TabFE:Button({ Title = "江南StyleV2", Callback = function() PlayAnim("rbxassetid://129764254213842") end })
TabFE:Button({ Title = "180°翻转", Callback = function() PlayAnim("rbxassetid://114400428765989") end })
TabFE:Button({ Title = "马桶舞", Callback = function() PlayAnim("rbxassetid://128334204821841") end })
TabFE:Button({ Title = "吾乃天命唯一", Callback = function() PlayAnim("rbxassetid://138433137191760") end })
TabFE:Button({ Title = "橙色正义", Callback = function() PlayAnim("rbxassetid://110146282544198") end })
TabFE:Button({ Title = "牙线舞", Callback = function() PlayAnim("rbxassetid://10714340543") end })
TabFE:Button({ Title = "三角符文舞蹈", Callback = function() PlayAnim("rbxassetid://77984841414450") end })
TabFE:Button({ Title = "圣经级准确表情", Callback = function() PlayAnim("rbxassetid://109873544976020") end })
TabFE:Button({ Title = "呃呃呃", Callback = function() PlayAnim("rbxassetid://111251252458517") end })
TabFE:Button({ Title = "彼得不要啊", Callback = function() PlayAnim("rbxassetid://84623954062978") end })
TabFE:Button({ Title = "我变成敞篷车了", Callback = function() PlayAnim("rbxassetid://124756446017361") end })
TabFE:Button({ Title = "加里舞蹈", Callback = function() PlayAnim("rbxassetid://93014787120483") end })
TabFE:Button({ Title = "IShowSpeed舞蹈", Callback = function() PlayAnim("rbxassetid://92618727772186") end })
TabFE:Button({ Title = "光环农场", Callback = function() PlayAnim("rbxassetid://99499783161907") end })
TabFE:Button({ Title = "雪天使", Callback = function() PlayAnim("rbxassetid://80177289449617") end })
TabFE:Button({ Title = "被皮行者附身", Callback = function() PlayAnim("rbxassetid://70432904702322") end })
TabFE:Button({ Title = "老鼠舞", Callback = function() PlayAnim("rbxassetid://123916423751437") end })
TabFE:Button({ Title = "花生酱果冻时间", Callback = function() PlayAnim("rbxassetid://129537633250603") end })
TabFE:Button({ Title = "撒尿狗", Callback = function() PlayAnim("rbxassetid://130059214239749") end })
TabFE:Button({ Title = "玛卡雷娜", Callback = function() PlayAnim("rbxassetid://91047682123297") end })
TabFE:Button({ Title = "严肃全能侠", Callback = function() PlayAnim("rbxassetid://130019914905925") end })
TabFE:Button({ Title = "翻滚", Callback = function() PlayAnim("rbxassetid://133612047483255") end })
TabFE:Button({ Title = "恐怖月份到啦", Callback = function() PlayAnim("rbxassetid://99637983789946") end })
TabFE:Button({ Title = "怪物混搭", Callback = function() PlayAnim("rbxassetid://88971195093161") end })
TabFE:Button({ Title = "无人机模式", Callback = function() PlayAnim("rbxassetid://118592095684994") end })
TabFE:Button({ Title = "植物大战僵尸向日葵", Callback = function() PlayAnim("rbxassetid://95894948496521") end })
TabFE:Button({ Title = "鱼类模式", Callback = function() PlayAnim("rbxassetid://137969542385356") end })
TabFE:Button({ Title = "拉屎", Callback = function() PlayAnim("rbxassetid://132399051509976") end })
TabFE:Button({ Title = "足球杂耍", Callback = function() PlayAnim("rbxassetid://122583653807009") end })
TabFE:Button({ Title = "工程师舞蹈", Callback = function() PlayAnim("rbxassetid://107355541549056") end })
TabFE:Button({ Title = "小鸡舞", Callback = function() PlayAnim("rbxassetid://126960077574956") end })
TabFE:Button({ Title = "他掏出了鸡儿", Callback = function() PlayAnim("rbxassetid://78347793265211") end })
TabFE:Button({ Title = "俄罗斯舞蹈", Callback = function() PlayAnim("rbxassetid://97148848007002") end })
TabFE:Button({ Title = "爬行者模式", Callback = function() PlayAnim("rbxassetid://114687548971893") end })
TabFE:Button({ Title = "灭霸舞蹈", Callback = function() PlayAnim("rbxassetid://106389948045296") end })
TabFE:Button({ Title = "俯卧撑", Callback = function() PlayAnim("rbxassetid://108313130500811") end })
TabFE:Button({ Title = "云端漂浮", Callback = function() PlayAnim("rbxassetid://106022089542174") end })
TabFE:Button({ Title = "椅子模式2", Callback = function() PlayAnim("rbxassetid://114140630538674") end })
TabFE:Button({ Title = "AI猫舞", Callback = function() PlayAnim("rbxassetid://108865839239307") end })
TabFE:Button({ Title = "蔬菜舞蹈", Callback = function() PlayAnim("rbxassetid://84352128203419") end })
TabFE:Button({ Title = "DJ哈立德", Callback = function() PlayAnim("rbxassetid://82293338535013") end })


-- ============================================================
-- ⭐ 动画标签页
-- ============================================================
Tabs.Animation:Section({ Title = "动画包" })

for _, pack in ipairs(AnimationPacks) do
    Tabs.Animation:Button({
        Title = pack.name,
        Callback = function()
            local c = LocalPlayer.Character
            if c and c:FindFirstChild("Animate") then
                local ok, err = pcall(SetAnimations, pack.data, pack.name)
                if not ok then Notify("错误", tostring(err):sub(1, 80), 4) end
            else
                Notify("错误", "角色未加载完成，请稍后再试", 3)
            end
        end
    })
end

Tabs.Animation:Section({ Title = "自定义动画" })

local animIdInput = ""
Tabs.Animation:Input({
    Title = "输入动画ID", Placeholder = "如 507776043",
    Callback = function(v) animIdInput = v end
})

Tabs.Animation:Button({
    Title = "播放动画",
    Callback = function()
        if animIdInput == "" then Notify("错误", "请输入动画ID", 2) return end
        local id = string.match(animIdInput, "id=(%d+)") or string.match(animIdInput, "rbxassetid://(%d+)") or animIdInput
        if not tonumber(id) then Notify("错误", "ID无效", 2) return end
        pcall(playAnimation, tostring(id), animSpeed, 0)
    end
})

Tabs.Animation:Button({
    Title = "停止所有动画",
    Callback = function()
        pcall(function()
            local c = LocalPlayer.Character
            if c then
                local hum = c:FindFirstChildOfClass("Humanoid")
                if hum then
                    for _, t in pairs(hum:GetPlayingAnimationTracks()) do t:Stop() end
                end
            end
        end)
        activeAnims = {} curAnimTrack = nil
        Notify("动画", "已停止", 2)
    end
})

Tabs.Animation:Toggle({
    Title = "循环播放", Default = true,
    Callback = function(s)
        animLooped = s
        if curAnimTrack then curAnimTrack.Looped = s end
    end
})

Tabs.Animation:Slider({
    Title = "动画速度",
    Value = { Min = 0, Max = 10, Default = 1 },
    Increment = 0.5,
    Callback = function(v)
        animSpeed = v
        if curAnimTrack then pcall(function() curAnimTrack:AdjustSpeed(v) end) end
    end
})

-- ============================================================
-- ⭐ 娱乐标签页
-- ============================================================
Tabs.Fun:Section({ Title = "跳跃特效" })
local JumpEffectEnabled = false
local jumpEffectConnections = {}
local jumpEffectHalos = {}
Tabs.Fun:Toggle({
    Title = "跳跃光环特效", Default = false,
    Callback = function(state)
        JumpEffectEnabled = state
        if state then
            Notify("娱乐", "跳跃特效已开启", 2)
            local CONFIG = { Segments = 120, MaxRadius = 6, TubeRadius = 0.6, Overlap = 1.2, GrowTime = 0.5, HoldTime = 0.2, FadeTime = 0.3, Cooldown = 0.3, Color = Color3.fromRGB(0, 180, 255), LightBrightness = 2.5, LightRange = 15 }
            local TUBE_HEIGHT = CONFIG.TubeRadius * 2 * CONFIG.Overlap
            local GROUND_OFFSET = CONFIG.TubeRadius / 2
            local lastSpawn = 0
            local function getGroundY(hrp, char)
                local origin = hrp.Position + Vector3.new(0, 2, 0)
                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Blacklist
                local filter = {char}
                for _, m in ipairs(jumpEffectHalos) do if m and m.Parent then table.insert(filter, m) end end
                params.FilterDescendantsInstances = filter
                local hit = workspace:Raycast(origin, Vector3.new(0, -200, 0), params)
                if hit then return hit.Position.Y end
                local hum = char:FindFirstChild("Humanoid")
                local hip = 2
                if hum and hum.HipHeight and hum.HipHeight > 0 then hip = hum.HipHeight end
                return hrp.Position.Y - hip - (hrp.Size.Y / 2)
            end
            local function spawnHalo(centerPos)
                local model = Instance.new("Model")
                model.Name = "JumpHalo"
                model.Parent = workspace
                table.insert(jumpEffectHalos, model)
                local parts = {}
                local up = Vector3.new(0, 1, 0)
                for i = 1, CONFIG.Segments do
                    local angle = (i / CONFIG.Segments) * 2 * math.pi
                    local pos = centerPos + Vector3.new(CONFIG.MaxRadius * math.cos(angle), 0, CONFIG.MaxRadius * math.sin(angle))
                    local tangent = Vector3.new(-math.sin(angle), 0, math.cos(angle))
                    local vZ = up:Cross(tangent)
                    local finalCF = CFrame.fromMatrix(pos, up, tangent, vZ)
                    local part = Instance.new("Part")
                    part.Shape = Enum.PartType.Cylinder
                    part.Size = Vector3.new(0.1, 0.1, 0.1)
                    part.CFrame = CFrame.new(centerPos)
                    part.Anchored = true
                    part.CanCollide = false
                    part.CastShadow = false
                    part.Material = Enum.Material.Neon
                    part.Color = CONFIG.Color
                    part.Parent = model
                    table.insert(parts, { part = part, finalCF = finalCF, finalSize = Vector3.new(CONFIG.TubeRadius, TUBE_HEIGHT, CONFIG.TubeRadius) })
                end
                local lightPart = Instance.new("Part")
                lightPart.Size = Vector3.new(0.2, 0.2, 0.2)
                lightPart.CFrame = CFrame.new(centerPos)
                lightPart.Anchored = true
                lightPart.CanCollide = false
                lightPart.CastShadow = false
                lightPart.Transparency = 1
                lightPart.Parent = model
                local light = Instance.new("PointLight")
                light.Parent = lightPart
                light.Brightness = 0
                light.Range = CONFIG.LightRange
                light.Color = CONFIG.Color
                local growInfo = TweenInfo.new(CONFIG.GrowTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                for _, data in ipairs(parts) do
                    TweenService:Create(data.part, growInfo, { CFrame = data.finalCF, Size = data.finalSize }):Play()
                end
                TweenService:Create(light, growInfo, { Brightness = CONFIG.LightBrightness }):Play()
                task.wait(CONFIG.GrowTime + CONFIG.HoldTime)
                local fadeInfo = TweenInfo.new(CONFIG.FadeTime, Enum.EasingStyle.Linear)
                for _, data in ipairs(parts) do TweenService:Create(data.part, fadeInfo, { Transparency = 1 }):Play() end
                TweenService:Create(light, fadeInfo, { Brightness = 0 }):Play()
                task.wait(CONFIG.FadeTime + 0.1)
                for i, m in ipairs(jumpEffectHalos) do if m == model then table.remove(jumpEffectHalos, i) break end end
                model:Destroy()
            end
            local function setupCharacter(char)
                local humanoid = char:FindFirstChild("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not humanoid or not hrp then return end
                if jumpEffectConnections[char] then jumpEffectConnections[char]:Disconnect() end
                jumpEffectConnections[char] = humanoid.StateChanged:Connect(function(oldState, newState)
                    if newState == Enum.HumanoidStateType.Jumping or newState == Enum.HumanoidStateType.Freefall then
                        local now = tick()
                        if now - lastSpawn >= CONFIG.Cooldown then
                            lastSpawn = now
                            local groundY = getGroundY(hrp, char)
                            local pos = Vector3.new(hrp.Position.X, groundY + GROUND_OFFSET, hrp.Position.Z)
                            task.spawn(function() spawnHalo(pos) end)
                        end
                    end
                end)
            end
            local function onCharacterAdded(char)
                char:WaitForChild("Humanoid") char:WaitForChild("HumanoidRootPart")
                setupCharacter(char)
                char.AncestryChanged:Connect(function()
                    if not char.Parent then
                        if jumpEffectConnections[char] then jumpEffectConnections[char]:Disconnect() jumpEffectConnections[char] = nil end
                    end
                end)
            end
            if LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end
            LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        else
            Notify("娱乐", "跳跃特效已关闭", 2)
            for char, conn in pairs(jumpEffectConnections) do if conn then conn:Disconnect() end end
            jumpEffectConnections = {}
            for _, m in ipairs(jumpEffectHalos) do if m and m.Parent then m:Destroy() end end
            jumpEffectHalos = {}
        end
    end
})
Tabs.Fun:Section({ Title = "角色外观" })

Tabs.Fun:Button({
    Title = "无头 & 断腿",
    Icon = "user",
    Callback = function()
        Notify("娱乐", "正在加载无头 & 断腿...", 3)
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/cwmen755-ai/abc/refs/heads/main/Korblox%20And%20Headless"))()
        end)
        if ok then
            Notify("娱乐", "无头 & 断腿已加载", 3)
        else
            Notify("加载失败", tostring(err):sub(1, 80), 5)
        end
    end
})
Tabs.Fun:Section({ Title = "恶搞功能" })
Tabs.Fun:Button({
    Title = "⚠️ 移动就踢 (仅对自己生效)", Variant = "Destructive", Icon = "triangle-alert",
    Callback = function()
        local confirm = WindUI:Dialog({
            Title = "警告",
            Content = "这个功能开启后，你只要在游戏里移动，就会被立刻踢出游戏！确定要开启吗？",
            Buttons = {
                { Title = "取消", Variant = "Secondary" },
                { Title = "确定开启", Variant = "Primary", Callback = function()
                    Notify("娱乐", "已开启移动检测，千万别动！", 5)
                    local alreadyKicked = false
                    local moveKickConn = RunService.RenderStepped:Connect(function()
                        if alreadyKicked then return end
                        local char = LocalPlayer.Character
                        if char then
                            local hum = char:FindFirstChildOfClass("Humanoid")
                            if hum and hum.MoveDirection.Magnitude > 0 then
                                alreadyKicked = true
                                pcall(function() LocalPlayer:Kick("\n不要移动") end)
                                if moveKickConn then moveKickConn:Disconnect() end
                            end
                        end
                    end)
                end}
            }
        })
    end
})
-- ============================================================
-- ⭐ 音乐标签页
-- ============================================================
Tabs.Music:Section({ Title = "网易云音乐" })
Tabs.Music:Paragraph({ Title = "网易云音乐 Roblox 内置版", Desc = "点击下方按钮启动，稍等片刻会出现独立悬浮窗" })
Tabs.Music:Button({
    Title = "启动网易云音乐", Variant = "Primary", Icon = "music",
    Callback = function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://gist.githubusercontent.com/meisdad321-cloud/dda158cf8ec9d771c7764bd08e8d19cb/raw/NeteaseCloudMusicForRoblox.lua"))()
        end)
        if ok then Notify("音乐", "网易云音乐加载成功！", 3)
        else Notify("加载失败", tostring(err):sub(1, 80), 5) end
    end,
})
-- ============================================================
-- ⭐ 杂项标签页
-- ============================================================
Tabs.Misc:Section({ Title = "快捷操作" })

Tabs.Misc:Button({
    Title = "刷新角色",
    Callback = function()
        if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
    end
})

Tabs.Misc:Button({
    Title = "重新加入",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})

Tabs.Misc:Toggle({
    Title = "显示时间", Default = false,
    Callback = function(s)
        if s then EnableTimeDisplay() else DisableTimeDisplay() end
    end
})

Tabs.Misc:Toggle({
    Title = "显示FPS", Default = false,
    Callback = function(s)
        if s then EnableFPS() else DisableFPS() end
    end
})


-- ============================================================
-- ⭐ 脚本大全标签页
-- ============================================================
Tabs.Scripts:Section({ Title = "外部脚本加载器" })

local function LoadExternalScript(name, url)
    local ok, err = pcall(function() loadstring(game:HttpGet(url))() end)
    if ok then Notify("脚本大全", name .. "加载成功", 2) else Notify("失败", tostring(err):sub(1, 80), 4) end
end

Tabs.Scripts:Button({ Title = "XA脚本", Callback = function() LoadExternalScript("XA脚本", "https://raw.gitcode.com/Xingtaiduan/Scripts/raw/main/Loader.lua") end })
Tabs.Scripts:Button({ Title = "夜脚本", Callback = function() LoadExternalScript("夜脚本", "https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/yejiaoben") end })
Tabs.Scripts:Button({ Title = "R6🦌管", Callback = function() LoadExternalScript("R6", "https://pastefy.app/wa3v2Vgm/raw") end })
Tabs.Scripts:Button({ Title = "R15🦌管", Callback = function() LoadExternalScript("R15", "https://pastefy.app/YZoglOyJ/raw") end })
Tabs.Scripts:Button({ Title = "皮脚本", Callback = function() LoadExternalScript("皮脚本", "https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua") end })
Tabs.Scripts:Button({ Title = "BS黑洞脚本", Callback = function() LoadExternalScript("BS黑洞", "https://gitee.com/BS_script/script/raw/master/BS_Script.Lua") end })
Tabs.Scripts:Button({ Title = "恐脚本😱", Callback = function() LoadExternalScript("恐脚本😱", "https://raw.githubusercontent.com/kongbaNB/9178/refs/heads/main/恐脚本.NB") end })
Tabs.Scripts:Button({ Title = "黑白脚本", Callback = function() LoadExternalScript("黑白脚本", "https://raw.githubusercontent.com/tfcygvunbind/Apple/main/黑白脚本加载器") end })

Tabs.Scripts:Paragraph({
    Title = "说明",
    Desc = "所有脚本均来自网络，用之前请用小号测试"
})

-- ============================================================
-- ⭐ 服务器脚本标签页
-- ============================================================
Tabs.Server:Section({ Title = "服务器脚本" })

Tabs.Server:Button({
    Title = "二狗子森林 99 夜",
    Icon = "moon",
    Callback = function()
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/shenqin/refs/heads/main/99day.lua"))()
        end)
        if ok then Notify("服务器脚本", "二狗子森林 99 夜加载成功！", 3)
        else Notify("加载失败", tostring(err):sub(1, 80), 5) end
    end
})

Tabs.Server:Button({
    Title = "破坏者谜团 2",
    Icon = "sword",
    Callback = function()
        Notify("服务器脚本", "正在加载破坏者谜团 2...", 3)
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xv3gasx/Murder-Mystery-2/refs/heads/main/Release.lua"))()
        end)
        if ok then
            Notify("服务器脚本", "破坏者谜团 2 加载成功！", 3)
        else
            Notify("加载失败", tostring(err):sub(1, 80), 5)
        end
    end
})

Tabs.Server:Button({
    Title = "皮脚本-圣奥里",
    Icon = "star",
    Callback = function()
        Notify("服务器脚本", "正在加载皮脚本-圣奥里...", 3)
        local ok, err = pcall(function()
            getgenv().XiaoPi = "皮脚本-圣奥里"
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/refs/heads/main/Roblox-Pi-Script-SaintOrie.lua"))()
        end)
        if ok then
            Notify("服务器脚本", "皮脚本-圣奥里加载成功！", 3)
        else
            Notify("加载失败", tostring(err):sub(1, 80), 5)
        end
    end
})

Tabs.Server:Button({
    Title = "逃跑者",
    Icon = "play",
    Callback = function()
        Notify("服务器脚本", "正在加载逃跑者...", 3)
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://scriptkeysystem.com/loader/c15e031fb1fccfdb9928.lua"))()
        end)
        if ok then
            Notify("服务器脚本", "逃跑者加载成功！", 3)
        else
            Notify("加载失败", tostring(err):sub(1, 80), 5)
        end
    end
})

-- ============================================================
-- 完成通知
-- ============================================================
task.wait(0.3)
WindUI:Notify({
    Title = "脚本加载成功",
    Content = "感谢使用龙卷脚本",
    Icon = "bird",
    Duration = 3,
})
