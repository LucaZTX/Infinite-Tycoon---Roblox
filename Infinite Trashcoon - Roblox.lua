--  LucaZTX, Github: https://github.com/LucaZTX

local player = game.Players.LocalPlayer
local cratesFolder = workspace:FindFirstChild("CrateFolder")
local keysFolder = workspace:FindFirstChild("KeyFolder")

if not cratesFolder or not keysFolder then
    warn("No se encontró CrateFolder o KeyFolder en Workspace.")
    return
end

local teleportEnabled = false -- Estado del TP
local running = false -- Para evitar múltiples loops al activarlo
local rootPart = nil -- Se actualizará dinámicamente

-- 🔄 Función para obtener el HumanoidRootPart
local function updateCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    rootPart = character:WaitForChild("HumanoidRootPart") -- Espera a que cargue el nuevo rootPart
end

-- 🖥️ Crear UI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0.05, 0, 0.1, 0) -- Ajusta la posición
button.Text = "TP: OFF"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Rojo (apagado)
button.TextScaled = true

-- 🚀 Función del TP
local function teleportLoop()
    running = true
    while teleportEnabled do
        if not rootPart then break end -- 🔴 Si rootPart no existe, detiene el TP

        -- 🔹 Buscar Cajas
        for _, crate in ipairs(cratesFolder:GetChildren()) do
            if not teleportEnabled then running = false return end

            local crateName = crate.Name:lower()
            if crate:IsA("BasePart") and crateName:match("crate$") and crateName ~= "wooden crate" then
                rootPart.CFrame = crate.CFrame + Vector3.new(0, 3, 0) -- TP sobre la caja
                wait(0.5)
            end
        end

        -- 🔑 Buscar Llaves
        for _, key in ipairs(keysFolder:GetChildren()) do
            if not teleportEnabled then running = false return end

            local keyName = key.Name:lower()
            if key:IsA("BasePart") and keyName:match("key$") then
                rootPart.CFrame = key.CFrame + Vector3.new(0, 3, 0) -- TP sobre la llave
                wait(0.5)
            end
        end

        wait(1)
    end
    running = false
end

-- 🔘 Toggle al tocar el botón
button.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    button.Text = teleportEnabled and "TP: ON" or "TP: OFF"
    button.BackgroundColor3 = teleportEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) -- Verde o Rojo

    if teleportEnabled and not running then
        task.spawn(teleportLoop) -- 🔥 Inicia el TP en un nuevo hilo
    end
end)

-- 🛠️ Detectar cuando el personaje reaparece
player.CharacterAdded:Connect(updateCharacter)

-- 🔄 Llamar a la función al inicio
updateCharacter()

--Roblox Anti Afk Script--
-- Made by aoki0x--
--RemiAPE On Top!--
 
wait(0.5)
local Main = Instance.new("ScreenGui")
local Title = Instance.new("TextLabel")
local MainFrame = Instance.new("Frame")
local EndTItle = Instance.new("TextLabel")
local AfkStatus = Instance.new("TextLabel")
 
Main.Parent = game.CoreGui
 
Main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
 
Title.Parent = Main;
 
Title.Active = true
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.BorderColor3 = Color3.fromRGB(0, 0, 255)
Title.Draggable = true
Title.Position = UDim2.new(0.698610067, 0, 0.098096624, 0)
Title.Size = UDim2.new(0, 370, 0, 52)
Title.Font = Enum.Font.SourceSansBold;
Title.Text = "Anti Afk | by aoki0x"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22;
 
MainFrame.Parent = Title
 
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 255)
MainFrame.Position = UDim2.new(0, 0, 1.0192306, 0)
MainFrame.Size = UDim2.new(0, 370, 0, 107)
 
EndTItle.Parent = MainFrame
EndTItle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
EndTItle.BorderColor3 = Color3.fromRGB(0, 0, 255)
EndTItle.Position = UDim2.new(0, 0, 0.800455689, 0)
EndTItle.Size = UDim2.new(0, 370, 0, 21)
EndTItle.Font = Enum.Font.SourceSansBold;
EndTItle.Text = "RemiAPE"
EndTItle.TextColor3 = Color3.fromRGB(255, 255, 255)
EndTItle.TextSize = 20;
 
AfkStatus.Parent = MainFrame
 
AfkStatus.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AfkStatus.BorderColor3 = Color3.fromRGB(0, 0, 255)
AfkStatus.Position = UDim2.new(0, 0, 0.158377, 0)
AfkStatus.Size = UDim2.new(0, 370, 0 ,44)
AfkStatus.Font = Enum.Font.SourceSansBold;
AfkStatus.Text = "Anti Afk Status: Active"
AfkStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
AfkStatus.TextSize = 20;
 
local abc = game:service'VirtualUser'
 
game:service'Players'.LocalPlayer.Idled:connect(function()
 
    AfkStatus:CaptureController()
    AfkStatus:ClickButton2(Vector2.new())
 
    AfkStatus.Text = "Roblox Tried To Kick You."
    wait(2)
    AfkStatus.Text = "Anti Afk Status: Active"
end)
