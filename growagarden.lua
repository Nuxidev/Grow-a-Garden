local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Nuxi Hub | Grow a Garden 🌱",
    SubTitle = "Mobile + PC Script UI",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = true,
    Theme = "Ocean",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tab = Window:AddTab({ Title = "Main", Icon = "🌿" })

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Variables
local speedEnabled, jumpEnabled, infJump = false, false, false
local speedValue, jumpValue = 50, 100
local autoCollect, autoWater, autoRebirth = false, false, false

-- Speed / Jump loop
task.spawn(function()
    while task.wait(0.2) do
        local hum = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum.WalkSpeed = speedEnabled and speedValue or 16
            hum.JumpPower = jumpEnabled and jumpValue or 50
        end
    end
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if infJump and player.Character then
        local hum = player.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Anti AFK
for _, v in pairs(getconnections(player.Idled)) do
    v:Disable()
end

-- Auto functions
task.spawn(function()
    while task.wait(0.8) do
        local char = player.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if autoCollect and hrp then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("TouchTransmitter") or (obj:IsA("BasePart") and obj.Name == "TouchInterest") then
                    local part = obj:IsA("TouchTransmitter") and obj.Parent or obj
                    if part:IsA("BasePart") then
                        pcall(function()
                            hrp.CFrame = part.CFrame + Vector3.new(0, 2.5, 0)
                        end)
                        task.wait(0.1)
                    end
                end
            end
        end

        if autoWater and player.Backpack:FindFirstChild("WateringCan") then
            local tool = player.Backpack:FindFirstChild("WateringCan")
            pcall(function()
                tool.Parent = char
                tool:Activate()
            end)
        end

        if autoRebirth then
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Rebirth") or workspace:FindFirstChild("Rebirth")
            if remote and remote:IsA("RemoteEvent") then
                pcall(function() remote:FireServer() end)
            end
        end
    end
end)

-- UI Toggles & Sliders
Tab:AddToggle("SpeedBoost", {
    Title = "Enable Speed Boost",
    Default = false,
    Callback = function(state) speedEnabled = state end
})
Tab:AddSlider("SpeedValue", {
    Title = "Speed Value",
    Min = 16,
    Max = 200,
    Default = 50,
    Callback = function(val) speedValue = val end
})

Tab:AddToggle("JumpBoost", {
    Title = "Enable Jump Boost",
    Default = false,
    Callback = function(state) jumpEnabled = state end
})
Tab:AddSlider("JumpPower", {
    Title = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 100,
    Callback = function(val) jumpValue = val end
})

Tab:AddToggle("InfJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state) infJump = state end
})

Tab:AddToggle("AutoCollect", {
    Title = "Auto Collect Fruits",
    Default = false,
    Callback = function(state) autoCollect = state end
})
Tab:AddToggle("AutoWater", {
    Title = "Auto Water Plants",
    Default = false,
    Callback = function(state) autoWater = state end
})
Tab:AddToggle("AutoRebirth", {
    Title = "Auto Rebirth",
    Default = false,
    Callback = function(state) autoRebirth = state end
})

-- Utility Buttons
Tab:AddButton({
    Title = "Unlock Camera Zoom",
    Description = "Zoom far out for better view",
    Callback = function()
        player.CameraMaxZoomDistance = 1000
        player.CameraMinZoomDistance = 5
    end
})
Tab:AddButton({
    Title = "Remove Fog & Shadows",
    Description = "Improve performance and vision",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.FogEnd = 999999
        lighting.GlobalShadows = false
        lighting.Brightness = 2
    end
})

-- Notification
Fluent:Notify({
    Title = "Nuxi Hub Ready!",
    Content = "Grow a Garden GUI loaded 🌿",
    SubContent = "Mobile & PC Supported",
    Duration = 8
})
