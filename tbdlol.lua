

-- Timebomb Duels: 100% Fixed & Sealed Code Block
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- جداول حفظ النسخة الاحتياطية للماب لإعادة الألوان الطبيعية
local materialBackup = {}
local colorBackup = {}
local texturesBackup = {}
local lightsBackup = {}

-- نظام الأمان: الطرد التلقائي عند استشعار خطر البند
local function secureLeave(reason)
    pcall(function()
        LocalPlayer:Kick("\n[نظام الأمان]: تم الخروج تلقائياً لحماية حسابك!\nالسبب: " .. reason)
    end)
end

task.spawn(function()
    while task.wait(0.5) do
        local success, err = pcall(function()
            if LocalPlayer:FindFirstChild("BanReason") or LocalPlayer:FindFirstChild("KickReason") then
                secureLeave("اشتباه في نظام حظر الماب")
            end
        end)
        if not success then secureLeave("رصد فحص حماية مفاجئ") end
    end
end)

-- استخدام المجلد المستقر والمضمون للواجهات
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Timebomb_Final_Fix_" .. tostring(math.random(10000, 99999))
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================================
-- 🎬 النافذة المتحركة الترحيبية مع الإطار المترمش
-- ==========================================================
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "IntroFrame"
IntroFrame.Size = UDim2.new(0, 310, 0, 110)
IntroFrame.Position = UDim2.new(0.5, -155, -0.3, 0) -- تبدأ خارج الشاشة من الأعلى
IntroFrame.BackgroundColor3 = Color3.fromRGB(12, 11, 16)
IntroFrame.BackgroundTransparency = 0.15
IntroFrame.Parent = ScreenGui

local UICornerIntro = Instance.new("UICorner")
UICornerIntro.CornerRadius = UDim.new(0, 14)
UICornerIntro.Parent = IntroFrame

-- إطار النافذة الترحيبية
local UIStrokeIntro = Instance.new("UIStroke")
UIStrokeIntro.Thickness = 2.5
UIStrokeIntro.Color = Color3.fromRGB(140, 50, 255)
UIStrokeIntro.Parent = IntroFrame

-- عنوان LOL HOP الفخم
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 55)
TitleLabel.Position = UDim2.new(0, 0, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "LOL HOP"
TitleLabel.TextColor3 = Color3.fromRGB(180, 70, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 34
TitleLabel.Parent = IntroFrame

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(255, 255, 255)
TitleStroke.Thickness = 0.5
TitleStroke.Parent = TitleLabel

-- نص اليوزر التيك توك المطلوب بالأسفل
local UserLabel = Instance.new("TextLabel")
UserLabel.Size = UDim2.new(1, 0, 0, 30)
UserLabel.Position = UDim2.new(0, 0, 0, 65)
UserLabel.BackgroundTransparency = 1
UserLabel.Text = "TikTok @lolhopsc"
UserLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
UserLabel.Font = Enum.Font.SourceSans
UserLabel.TextSize = 16
UserLabel.Parent = IntroFrame

-- أنيميشن نزول النافذة وسلاستها من الأعلى إلى المنتصف
local dropTween = TweenService:Create(IntroFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -155, 0.15, 0)
})
dropTween:Play()

-- تشغيل أنيميشن الوميض والترمش المتبادل بشكل معزول ومحمي بالكامل
task.spawn(function()
    while IntroFrame and IntroFrame.Parent do
        local toWhite = TweenService:Create(UIStrokeIntro, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Color = Color3.fromRGB(255, 255, 255)
        })
        toWhite:Play()
        toWhite.Completed:Wait()
        
        local toPurple = TweenService:Create(UIStrokeIntro, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Color = Color3.fromRGB(140, 50, 255)
        })
        toPurple:Play()
        toPurple.Completed:Wait()
    end
end)

-- اختفاء النافذة تماماً بعد 4 ثوانٍ وصعودها للأعلى كالمحترفين
task.delay(4, function()
    if IntroFrame and IntroFrame.Parent then
        local raiseTween = TweenService:Create(IntroFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -155, -0.3, 0),
            BackgroundTransparency = 1
        })
        raiseTween:Play()
        raiseTween.Completed:Connect(function()
            if IntroFrame then IntroFrame:Destroy() end
        end)
    end
end)

-- ==========================================================
-- 🛠️ أزرار التحكم والقتال الأصلية (المواقع المريحة الجانبية)
-- ==========================================================
local function createSafeButton(name, text, position, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 48, 0, 48)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.Text = text
    btn.TextColor3 = color
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 1.5
    stroke.Parent = btn
    
    return btn
end

local LQ_Btn = createSafeButton("LQ_Mode", "LQ:OFF", UDim2.new(0.76, 0, 0.35, 0), Color3.fromRGB(255, 50, 50))
local lqEnabled = false
LQ_Btn.MouseButton1Click:Connect(function()
    lqEnabled = not lqEnabled
    if lqEnabled then
        LQ_Btn.Text = "LQ:ON"
        LQ_Btn.TextColor3 = Color3.fromRGB(50, 255, 50)
        LQ_Btn.UIStroke.Color = Color3.fromRGB(50, 255, 50)
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                if not materialBackup[v] then materialBackup[v] = v.Material end
                if not colorBackup[v] then colorBackup[v] = v.Color end
                v.Material = Enum.Material.SmoothPlastic
                v.Color = Color3.fromRGB(120, 120, 120)
            elseif v:IsA("Texture") or v:IsA("Decal") then
                if not texturesBackup[v] then texturesBackup[v] = v.Parent end
                v.Parent = nil
            elseif v:IsA("Light") or v:IsA("ShadowEffect") or v:IsA("PostEffect") then
                if not lightsBackup[v] then lightsBackup[v] = v.Enabled end
                v.Enabled = false
            end
        end
    else
        LQ_Btn.Text = "LQ:OFF"
        LQ_Btn.TextColor3 = Color3.fromRGB(255, 50, 50)
        LQ_Btn.UIStroke.Color = Color3.fromRGB(255, 50, 50)
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        for part, mat in pairs(materialBackup) do if part and part.Parent then part.Material = mat end end
        for part, col in pairs(colorBackup) do if part and part.Parent then part.Color = col end end
        for tex, parent in pairs(texturesBackup) do if tex then tex.Parent = parent end end
        for light, state in pairs(lightsBackup) do if light then light.Enabled = state end end
        materialBackup = {} colorBackup = {} texturesBackup = {} lightsBackup = {}
    end
end)

local JL_Btn = createSafeButton("JL_Mode", "Lock", UDim2.new(0.74, 0, 0.48, 0), Color3.fromRGB(0, 180, 255))
local lockEnabled = false
local lockConnection = nil

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

JL_Btn.MouseButton1Click:Connect(function()
    if lockEnabled then return end
    lockEnabled = true
    JL_Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    local startTime = tick()
    local duration = 1.7
    local jiggleDirection = 1
    lockConnection = RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPlayer = getClosestPlayer()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = targetPlayer.Character.HumanoidRootPart.Position
                local cameraPos = Camera.CFrame.Position
                local targetCFrame = CFrame.new(cameraPos, Vector3.new(targetPos.X, cameraPos.Y, targetPos.Z))
                jiggleDirection = -jiggleDirection
                local jiggleAngle = math.rad(math.random(8, 14) * jiggleDirection)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame * CFrame.Angles(0, jiggleAngle, 0), 0.25)
            end
        end
    end)
    task.wait(duration)
    if lockConnection then lockConnection:Disconnect() lockConnection = nil end
    JL_Btn.TextColor3 = Color3.fromRGB(0, 180, 255)
    lockEnabled = false
end)

local AF_Btn = createSafeButton("AF_Mode", "Flick", UDim2.new(0.74, 0, 0.62, 0), Color3.fromRGB(255, 180, 0))
local isFlicking = false
local flickConnection = nil
AF_Btn.MouseButton1Click:Connect(function()
    if isFlicking then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    isFlicking = true
    AF_Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local startTime = tick()
local duration = 1.5
local cycleCounter = 0
local currentDirection = 1
flickConnection = RunService.RenderStepped:Connect(function()
if hrp and hrp.Parent then
cycleCounter = cycleCounter + 1
if cycleCounter % 5 == 0 then
task.wait(math.random(1, 3) / 100)
if math.random(1, 10) > 7 then currentDirection = -currentDirection end
end
local humanizer = math.random(36, 42) * currentDirection
hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(humanizer), 0)
end
end)
task.wait(duration)
if flickConnection then flickConnection:Disconnect() flickConnection = nil end
AF_Btn.TextColor3 = Color3.fromRGB(255, 180, 0)
isFlicking = false
end)
print("تم تقفيل الكود البرمجي بالكامل داخل صندوق النسخ بنجاح!")
