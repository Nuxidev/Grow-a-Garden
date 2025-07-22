    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

    local Window = Fluent:CreateWindow({
        Title = "Nuxi Hub | Grow a Garden 🌱",
        SubTitle = "Mobile & PC GUI Hack",
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

    local speedEnabled, jumpEnabled, infJump = false, false, false
    local speedValue, jumpValue = 50, 100
    local autoCollect, autoWater, autoRebirth = false, false, false

    task.spawn(function()
        while task.wait(0.2) do
            local char = player.Character
            if char then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if hum then
                    hum.WalkSpeed = speedEnabled and speedValue or 16
                    hum.JumpPower = jumpEnabled and jumpValue or 50
                end
            end
        end
    end)

    UIS.JumpRequest:Connect(function()
        if infJump and player.Character then
            local hum = player.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then hum:ChangeState("Jumping") end
        end
    end)

    for _, v in pairs(getconnections(player.Idled)) do
        v:Disable()
    end

    task.spawn(function()
        while task.wait(1) do
            local char = player.Character
            if not char then continue end
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if autoCollect and hrp then
                for _, part in pairs(workspace:GetDescendants()) do
                    if part:IsA("TouchTransmitter") or (part:IsA("BasePart") and part.Name == "TouchInterest") then
                        local parent = part:IsA("TouchTransmitter") and part.Parent or part
                        if parent and parent:IsA("BasePart") and hrp then
                            pcall(function()
                                hrp.CFrame = parent.CFrame + Vector3.new(0, 3, 0)
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
                    if tool:FindFirstChild("Activate") then
                        tool:Activate()
                    end
                end)
            end

            if autoRebirth then
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Rebirth") or workspace:FindFirstChild("Rebirth")
                if remote and remote:IsA("RemoteEvent") then
                    pcall(function()
                        remote:FireServer()
                    end)
                end
            end
        end
    end)

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
        Callback = function(value) speedValue = value end
    })

    Tab:AddToggle("JumpBoost", {
        Title = "Enable Jump Boost",
        Default = false,
        Callback = function(state) jumpEnabled = state end
    })

    Tab:AddSlider("JumpValue", {
        Title = "Jump Power",
        Min = 50,
        Max = 300,
        Default = 100,
        Callback = function(value) jumpValue = value end
    })

    Tab:AddToggle("InfiniteJump", {
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

    Tab:AddButton({
        Title = "Unlock Zoom Distance",
        Description = "Remove zoom camera limits",
        Callback = function()
            pcall(function()
                player.CameraMaxZoomDistance = 1000
                player.CameraMinZoomDistance = 5
            end)
        end
    })

    Tab:AddButton({
        Title = "Remove Fog & Shadows",
        Description = "Better visibility",
        Callback = function()
            local lighting = game:GetService("Lighting")
            lighting.FogEnd = 999999
            lighting.GlobalShadows = false
            lighting.Brightness = 2
        end
    })

    Fluent:Notify({
        Title = "Nuxi Hub Loaded!",
        Content = "Grow a Garden UI is ready 🌱",
        SubContent = "Press Right Ctrl to toggle the menu",
        Duration = 8
    })
else
    game.StarterGui:SetCore("SendNotification", {
        Title = "Nuxi Hub",
        Text = "This script only works on Grow a Garden!",
        Duration = 6
    })
end
