-- Timebomb Duels: Safe Screen Buttons (Fixed Positions Side-by-Side)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

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

-- إنشاء واجهة المستخدم داخل مجلد الحماية المخفي لتخطي الحذف
local TargetParent = nil
if gethui then
    TargetParent = gethui()
elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
    TargetParent = game:GetService("CoreGui").RobloxGui
else
    TargetParent = LocalPlayer:WaitForChild("PlayerGui")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BypassPositions_" .. tostring(math.random(10000, 99999))
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

-- دالة عامة لإنشاء أزرار دائرية نيون ومحمية ضد نظام الماب
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

-- [1. زر تقليل الجودة - LQ]: تم نقله للأعلى بجانب شريط الـ Arenas لمنع تداخله
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

-- [2. زر القفل المهتز - JL]: تم إزاحته لليسار ليكون بجانب زر الـ ShiftLock الأزرق تماماً وليس فوقه
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

-- [3. زر الالتفاف البشري المقطع - AF]: تم إزاحته لليسار ليكون بجانب زر القفز (السهم للأعلى) بمسافة مريحة
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

print("تم تعديل توزيع الأزرار لتصبح بجانب أدوات التحكم الأصلية بنجاح!")
