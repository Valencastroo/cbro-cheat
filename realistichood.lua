-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
 
-- Speed Hack Configuration
local SpeedMultiplier = 5
 
-- Aimbot Configuration
local AimbotEnabled = true
local FOVRadius = 100
local Smoothness = 0.05
 
-- ESP Configuration
local ESPEnabled = true
local ESP_COLOR = Color3.new(0, 1, 0) -- Green color
local TEXT_FONT = Enum.Font.Gotham
local TEXT_SIZE = 14
 
-- UI for FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = FOVRadius
FOVCircle.Color = Color3.new(0, 1, 0) -- Green
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Visible = true
 
local function updateFOVCircle()
    local mousePosition = UserInputService:GetMouseLocation()
    FOVCircle.Position = Vector2.new(mousePosition.X, mousePosition.Y)
    FOVCircle.Radius = FOVRadius
end
 
-- Function to find the nearest target within the FOV
local function getNearestTarget()
    local mousePosition = UserInputService:GetMouseLocation()
    local closestPlayer = nil
    local shortestDistance = FOVRadius
 
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPosition, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
 
            if onScreen then
                local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mousePosition).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
 
    return closestPlayer
end
 
-- Aimbot Logic
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then return end
 
    updateFOVCircle()
 
    local target = getNearestTarget()
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local head = target.Character.Head
        local camera = workspace.CurrentCamera
        local currentCFrame = camera.CFrame
        local targetCFrame = CFrame.new(camera.CFrame.Position, head.Position)
 
        workspace.CurrentCamera.CFrame = currentCFrame:Lerp(targetCFrame, Smoothness)
    end
end)
 
-- Function to create ESP with Chams
local function createESP(player)
    if player == LocalPlayer then return end
 
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head", 5)
    if not head then return end
 
    -- Billboard GUI for names
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 150, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
 
    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = ESP_COLOR
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Font = TEXT_FONT
    textLabel.TextSize = TEXT_SIZE
    textLabel.Text = player.Name
 
    billboard.Parent = head
 
    -- Chams (Highlight)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillColor = ESP_COLOR
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = ESP_COLOR
    highlight.OutlineTransparency = 0
    highlight.Parent = character
end
 
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and not player.Character:FindFirstChild("Highlight") then
                createESP(player)
            end
        end
    end
end)
 
-- Speed Hack Logic
local function applySpeedHack()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16 * SpeedMultiplier
    end
end
 
RunService.Heartbeat:Connect(applySpeedHack)
 
-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
 
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "Cheat Control Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
 
-- Speed Hack Slider
local SpeedHackSlider = Instance.new("TextBox", MainFrame)
SpeedHackSlider.Size = UDim2.new(0.9, 0, 0, 40)
SpeedHackSlider.Position = UDim2.new(0.05, 0, 0.15, 0)
SpeedHackSlider.PlaceholderText = "Speed Multiplier: " .. SpeedMultiplier
SpeedHackSlider.Font = Enum.Font.Gotham
SpeedHackSlider.TextSize = 16
SpeedHackSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedHackSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
 
SpeedHackSlider.FocusLost:Connect(function()
    local newSpeed = tonumber(SpeedHackSlider.Text)
    if newSpeed then
        SpeedMultiplier = newSpeed
        SpeedHackSlider.PlaceholderText = "Speed Multiplier: " .. SpeedMultiplier
    end
end)
 
-- Aimbot Toggle
local AimbotToggle = Instance.new("TextButton", MainFrame)
AimbotToggle.Size = UDim2.new(0.9, 0, 0, 40)
AimbotToggle.Position = UDim2.new(0.05, 0, 0.25, 0)
AimbotToggle.Text = "Toggle Aimbot"
AimbotToggle.Font = Enum.Font.Gotham
AimbotToggle.TextSize = 16
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
 
AimbotToggle.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimbotToggle.Text = AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
end)
 
-- FOV Slider
local FOVSlider = Instance.new("TextBox", MainFrame)
FOVSlider.Size = UDim2.new(0.9, 0, 0, 40)
FOVSlider.Position = UDim2.new(0.05, 0, 0.35, 0)
FOVSlider.PlaceholderText = "FOV Radius: " .. FOVRadius
 
FOVSlider.FocusLost:Connect(function()
    local newFOV = tonumber(FOVSlider.Text)
    if newFOV then
        FOVRadius = newFOV
        FOVSlider.PlaceholderText = "FOV Radius: " .. FOVRadius
    end
end)
 
-- Smoothness Slider
local SmoothnessSlider = Instance.new("TextBox", MainFrame)
SmoothnessSlider.Size = UDim2.new(0.9, 0, 0, 40)
SmoothnessSlider.Position = UDim2.new(0.05, 0, 0.45, 0)
SmoothnessSlider.PlaceholderText = "Smoothness: " .. Smoothness
 
SmoothnessSlider.FocusLost:Connect(function()
    local newSmoothness = tonumber(SmoothnessSlider.Text)
    if newSmoothness then
        Smoothness = newSmoothness
        SmoothnessSlider.PlaceholderText = "Smoothness: " .. Smoothness
    end
end)
 
-- ESP Toggle
local ESPToggle = Instance.new("TextButton", MainFrame)
ESPToggle.Size = UDim2.new(0.9, 0, 0, 40)
ESPToggle.Position = UDim2.new(0.05, 0, 0.55, 0)
ESPToggle.Text = "Toggle ESP"
ESPToggle.Font = Enum.Font.Gotham
ESPToggle.TextSize = 16
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
 
ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggle.Text = ESPEnabled and "ESP: ON" or "ESP: OFF"
end)
 
-- Toggle GUI Visibility
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
 
