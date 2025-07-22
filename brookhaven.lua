local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Nuxi Hub | Brookhaven 🏡",
    SubTitle = "Merci d'utilisé Nuxi Hub! ❤",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = true,
    Theme = "Ocean",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tab = Window:AddTab({ Title = "Main", Icon = "🏠" })

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Variables
local speedEnabled, jumpEnabled, infJump = false, false, false
local speedValue, jumpValue = 50, 100

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

-- Teleport to House
local function teleportToHouse()
    local house = workspace:FindFirstChild("House") or workspace:FindFirstChild("HouseBase") or workspace:FindFirstChild("House1")
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if house and hrp then
        hrp.CFrame = house.PrimaryPart and house.PrimaryPart.CFrame + Vector3.new(0,5,0) or house.CFrame + Vector3.new(0,5,0)
    else
        Fluent:Notify({
            Title = "Erreur",
            Content = "Maison introuvable",
            Duration = 4
        })
    end
end

-- Teleport to Car (example, adapt selon la voiture)
local function teleportToCar()
    local car = workspace:FindFirstChild("Car") or workspace:FindFirstChild("Vehicle")
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if car and hrp then
        hrp.CFrame = car.PrimaryPart and car.PrimaryPart.CFrame + Vector3.new(0,5,0) or car.CFrame + Vector3.new(0,5,0)
    else
        Fluent:Notify({
            Title = "Erreur",
            Content = "Voiture introuvable",
            Duration = 4
        })
    end
end

-- UI Toggles & Sliders
Tab:AddToggle("SpeedBoost", {
    Title = "Activer Speed Boost",
    Default = false,
    Callback = function(state) speedEnabled = state end
})
Tab:AddSlider("SpeedValue", {
    Title = "Valeur Speed",
    Min = 16,
    Max = 200,
    Default = 50,
    Callback = function(val) speedValue = val end
})

Tab:AddToggle("JumpBoost", {
    Title = "Activer Jump Boost",
    Default = false,
    Callback = function(state) jumpEnabled = state end
})
Tab:AddSlider("JumpPower", {
    Title = "Puissance Jump",
    Min = 50,
    Max = 300,
    Default = 100,
    Callback = function(val) jumpValue = val end
})

Tab:AddToggle("InfJump", {
    Title = "Saut Infini",
    Default = false,
    Callback = function(state) infJump = state end
})

-- Teleport Buttons
Tab:AddButton({
    Title = "Téléporter à la Maison",
    Description = "Va instantanément à ta maison",
    Callback = teleportToHouse
})
Tab:AddButton({
    Title = "Téléporter à la Voiture",
    Description = "Va instantanément à ta voiture",
    Callback = teleportToCar
})

-- Utility Buttons
Tab:AddButton({
    Title = "Débloquer Zoom Caméra",
    Description = "Zoomer très loin pour mieux voir",
    Callback = function()
        player.CameraMaxZoomDistance = 1000
        player.CameraMinZoomDistance = 5
    end
})
Tab:AddButton({
    Title = "Supprimer Brouillard & Ombres",
    Description = "Améliorer la visibilité et les performances",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.FogEnd = 999999
        lighting.GlobalShadows = false
        lighting.Brightness = 2
    end
})

-- Notification
Fluent:Notify({
    Title = "Nuxi Hub prêt!",
    Content = "Brookhaven GUI chargé 🏡",
    SubContent = "Merci d'utilisé Nuxi Hub! ❤",
    Duration = 8
})
