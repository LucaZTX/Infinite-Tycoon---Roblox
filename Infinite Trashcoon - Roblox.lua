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
local screenGui = nil -- Guardamos la UI para no recrearla varias veces

-- 🔄 Función para obtener el HumanoidRootPart
local function updateCharacter()
    local character = player.Character or player.CharacterAdded:Wait()
    rootPart = character:WaitForChild("HumanoidRootPart") -- Espera a que cargue el nuevo rootPart
end

-- 🖥️ Crear UI (persistente)
local function createUI()
    -- Si la UI ya existe, no la vuelve a crear
    if screenGui then return end

    screenGui = Instance.new("ScreenGui")
    screenGui.ResetOnSpawn = false -- 🔥 Hace que la UI NO desaparezca al morir
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local button = Instance.new("TextButton")
    button.Parent = screenGui
    button.Size = UDim2.new(0, 150, 0, 50)
    button.Position = UDim2.new(0.05, 0, 0.1, 0) -- Ajusta la posición
    button.Text = "TP: OFF"
    button.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Rojo (apagado)
    button.TextScaled = true

    -- 🔘 Toggle al tocar el botón
    button.MouseButton1Click:Connect(function()
        teleportEnabled = not teleportEnabled
        button.Text = teleportEnabled and "TP: ON" or "TP: OFF"
        button.BackgroundColor3 = teleportEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) -- Verde o Rojo

        if teleportEnabled and not running then
            task.spawn(teleportLoop) -- 🔥 Inicia el TP en un nuevo hilo
        end
    end)
end

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

-- 🛠️ Detectar cuando el personaje reaparece
player.CharacterAdded:Connect(function()
    updateCharacter()
    createUI() -- 🔥 Re-crea la UI solo si no existe
end)

-- 🔄 Inicialización
updateCharacter()
createUI()
