local kyri = loadstring(game:HttpGet("https://kyrilib.dev/kyrilib/"))()

-- Crearea ferestrei principale redenumită în "M's Sheeps"
local w = kyri.new("M's Sheeps", {
    GameName = "MsSheeps",
    AutoLoad = "default"
})

-- Stocarea coordonatelor pentru Grazing
local grazingLocations = {
    ["1. basic"] = Vector3.new(373, 29, -88),
    ["2. rich"] = Vector3.new(465, 35, -61),
    ["3. flower"] = Vector3.new(605, 45, -29),
    ["4. building"] = Vector3.new(594, 74, 218),
    ["5. alien"] = Vector3.new(404, 131, 326),
    ["6. heavenly"] = Vector3.new(254, 195, 368),
    ["7. Volcano"] = Vector3.new(-601, 30, 582)
}

-- Variabile de stare și configurare implicită
local selectedGrazingSpot = "1. basic"
local selectedDogIndex = 1 
local isGrazingFarmActive = false

local grazingDuration = 40  -- Modificabil prin slider (25 - 60 sec)
local sheepfoldDuration = 45 -- Modificabil prin slider (30 - 120 sec)

local isCurrentlyGrazingLoop = false -- Indică dacă execuția de grazing (pe câine) este activă
local isCurrentlyInSheepfold = false  -- Indică dacă oile se află în faza de grajd
local collecting = false
local antiAfkEnabled = false

-- Funcție internă utilă pentru teleportarea stabilă deasupra câinelui selectat
local function teleportToDog()
    local player = game.Players.LocalPlayer
    local heightOffset = Vector3.new(0, 0, 5) 
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local dogsFolder = workspace:FindFirstChild("Dogs")
        
        if dogsFolder then
            local dogs = dogsFolder:GetChildren()
            local targetDog = dogs[selectedDogIndex]
            
            if targetDog then
                if targetDog:IsA("BasePart") then
                    hrp.CFrame = CFrame.new(targetDog.Position + heightOffset)
                elseif targetDog:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = CFrame.new(targetDog.HumanoidRootPart.Position + heightOffset)
                elseif targetDog.PrimaryPart then
                    hrp.CFrame = CFrame.new(targetDog.PrimaryPart.Position + heightOffset)
                end
            end
        end
    end
end

-- ==========================================
-- FILA 1: AUTOFARM
-- ==========================================
local autofarmTab = w:tab("Autofarm", "flash")

autofarmTab:section("Grazing Settings")

-- Dropdown pentru selectarea locației de grazing
autofarmTab:dropdown("Select Grazing Spot", {"1. basic", "2. rich", "3. flower", "4. building", "5. alien", "6. heavenly", "7. Volcano"}, "1. basic", function(selected)
    selectedGrazingSpot = selected
    w:notify("Grazing", "Spot schimbat in: " .. selected, 1.5)
end, "grazing_spot_dropdown")

-- Dropdown pentru selectarea numărului câinelui
autofarmTab:dropdown("Select Dog Index", {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}, "1", function(selected)
    selectedDogIndex = tonumber(selected) or 1
    w:notify("Dogs", "Caine selectat: #" .. selected, 1.5)
end, "dog_index_dropdown")

-- Slider pentru timpul de grazing (25 la 60 secunde)
autofarmTab:slider("Grazing Duration (sec)", 25, 60, 40, function(value)
    grazingDuration = value
end, "grazing_duration_slider")

-- Slider pentru timpul petrecut în grajd (30 secunde la 120 secunde / 2 minute)
autofarmTab:slider("Sheepfold Duration (sec)", 30, 120, 45, function(value)
    sheepfoldDuration = value
end, "sheepfold_duration_slider")

-- Butonul principal de Autofarm
autofarmTab:toggle("Autofarm", false, function(state)
    isGrazingFarmActive = state

    if isGrazingFarmActive then
        w:notify("Autofarm", "Autofarm Ciclul Complet Pornit", 2)
        
        -- BUCLA PRINCIPALĂ (Ciclul automat: Păscut -> Grajd -> Eliberare -> Păscut)
        task.spawn(function()
            local player = game.Players.LocalPlayer
            local sheepEvent = game:GetService("ReplicatedStorage").Events.SheepAction
            
            while isGrazingFarmActive do
                -- -------------------------------------------------------------
                -- FAZA 1: GRAZING (PĂSCUT)
                -- -------------------------------------------------------------
                isCurrentlyGrazingLoop = true
                isCurrentlyInSheepfold = false
                
                local centerCoords = grazingLocations[selectedGrazingSpot] or Vector3.new(373, 29, -88)
                
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(centerCoords)
                    w:notify("Autofarm", "Teleport la spot. Asteptare 2 secunde...", 1.5)
                end
                
                task.wait(2)
                if not isGrazingFarmActive then break end
                
                sheepEvent:FireServer("grazing")
                w:notify("Autofarm", "Grazing pornit! Teleportare deasupra cainelui #" .. selectedDogIndex, 2)
                
                local startTime = tick()
                
                -- Menținerea caracterului deasupra câinelui pe durata de grazing setată
                while isGrazingFarmActive and (tick() - startTime) < grazingDuration do
                    teleportToDog()
                    task.wait(0.3)
                end
                
                -- Oprim păscutul (stopgrazing), dar lăsăm caracterul pe poziție (fără teleport înapoi la centru)
                sheepEvent:FireServer("stopgrazing")
                w:notify("Autofarm", "Grazing terminat. Trimitere oili la Sheepfold!", 2)
                isCurrentlyGrazingLoop = false
                
                task.wait(1)
                if not isGrazingFarmActive then break end

                -- -------------------------------------------------------------
                -- FAZA 2: SHEEPFOLD (GRAJD)
                -- -------------------------------------------------------------
                isCurrentlyInSheepfold = true
                sheepEvent:FireServer("sheepfold") -- Trimite oile în grajd prima dată
                
                local foldStart = tick()
                -- Menținem oile în grajd conform slider-ului ȘI continuăm teleportarea pe câine
                while isGrazingFarmActive and (tick() - foldStart) < sheepfoldDuration do
                    teleportToDog()
                    task.wait(0.3)
                end
                
                isCurrentlyInSheepfold = false
                if not isGrazingFarmActive then break end
                
                -- -------------------------------------------------------------
                -- FAZA 3: RELEASE (ELIBERARE OILI DIN GRAJD)
                -- -------------------------------------------------------------
                w:notify("Autofarm", "Timpul in grajd a expirat! Se trimite Release (Out)...", 2)
                sheepEvent:FireServer("out") 
                
                task.wait(1.5) 
            end
            
            isCurrentlyGrazingLoop = false
            isCurrentlyInSheepfold = false
        end)
        
        -- BUCLA SECUNDARĂ (Anti-stuck / Spam la 5 secunde în funcție de starea curentă)
        task.spawn(function()
            local sheepEvent = game:GetService("ReplicatedStorage").Events.SheepAction
            while isGrazingFarmActive do
                task.wait(5)
                if not isGrazingFarmActive then break end
                
                -- Dacă suntem în faza de grajd (Sheepfold ON), trimitem stopgrazing și sheepfold la fiecare 5 secunde
                if isCurrentlyInSheepfold then
                    sheepEvent:FireServer("stopgrazing")
                    sheepEvent:FireServer("sheepfold")
                    
                -- Dacă ferma e pornită, dar nu suntem nici la păscut, nici în grajd, trimitem doar stopgrazing
                elseif not isCurrentlyGrazingLoop then
                    sheepEvent:FireServer("stopgrazing")
                end
            end
        end)

    else
        isCurrentlyGrazingLoop = false
        isCurrentlyInSheepfold = false
        w:notify("Autofarm", "Autofarm Dezactivat", 2)
    end
end, "autofarm_toggle")

-- Buton ON/OFF (Toggle) pentru lână, plasat direct sub butonul Autofarm
autofarmTab:toggle("Collect Wool", false, function(state)
    collecting = state

    if collecting then
        w:notify("Wool", "Auto-Collection Started", 2)
        
        task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").Events.E_CollectWool
            
            while collecting do
                local cubeSheep = workspace:FindFirstChild("CubeSheep")
                
                if cubeSheep then
                    local sheeps = cubeSheep:GetChildren()
                    
                    for i, sheep in ipairs(sheeps) do
                        if not collecting then break end
                        Event:FireServer(sheep)
                        task.wait(0.1)
                    end
                else
                    w:notify("Error", "CubeSheep not found!", 2)
                    task.wait(2)
                end
                task.wait(1)
            end
        end)
    else
        w:notify("Wool", "Auto-Collection Stopped", 2)
    end
end, "collect_wool_toggle")


-- ==========================================
-- FILA 2: CONTROLUL OILOR (SHEEP CONTROL)
-- ==========================================
local main = w:tab("Sheep Control", "paw")

-- Secțiunea numită simplu "Actions"
main:section("Actions")

-- Buton Simplu (1-Time) pentru Start Grazing manual
main:button("Start Grazing", function()
    local Event = game:GetService("ReplicatedStorage").Events.SheepAction
    Event:FireServer("grazing")
    w:notify("Sheep", "Start Grazing Sent", 2)
end)

-- Buton Simplu (1-Time)
main:button("Stop Grazing", function()
    local Event = game:GetService("ReplicatedStorage").Events.SheepAction
    Event:FireServer("stopgrazing")
    w:notify("Sheep", "Stop Grazing Sent", 2)
end)

-- Redenumit în Bring in (1-Time)
main:button("Bring in", function()
    local Event = game:GetService("ReplicatedStorage").Events.SheepAction
    Event:FireServer("sheepfold")
    w:notify("Sheep", "Bring in Sent", 2)
end)

-- Redenumit în Bring out (1-Time)
main:button("Bring out", function()
    local Event = game:GetService("ReplicatedStorage").Events.SheepAction
    Event:FireServer("out")
    w:notify("Sheep", "Bring out Sent", 2)
end)


-- ==========================================
-- FILA 3: TELEPORTĂRI (TELEPORTS)
-- ==========================================
local teleportsTab = w:tab("Teleports", "map")

teleportsTab:section("Locations")

local function instantTeleport(coords, locationName)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(coords)
        w:notify("Teleport", "Teleported to " .. locationName .. "!", 1.5)
    else
        w:notify("Error", "Character not found!", 2)
    end
end

teleportsTab:button("Spawn", function()
    instantTeleport(Vector3.new(71, 5, -78), "Spawn")
end)

teleportsTab:button("Sea Traveler", function()
    instantTeleport(Vector3.new(-158, 5, -128), "Sea Traveler")
end)

teleportsTab:button("Pet store", function()
    instantTeleport(Vector3.new(214, 5, -78), "Pet store")
end)

teleportsTab:button("Volcano", function()
    instantTeleport(Vector3.new(-601, 30, 582), "Volcano")
end)

teleportsTab:button("Chill spot", function()
    instantTeleport(Vector3.new(214, 253, 305), "Chill spot")
end)


-- ==========================================
-- FILA 4: JUCĂTOR (PLAYER)
-- ==========================================
local playerTab = w:tab("Player", "user")

playerTab:section("LocalPlayer Modifications")

local defaultWalkSpeed = 16
local defaultJumpPower = 50

local customWalkSpeed = defaultWalkSpeed
local customJumpPower = defaultJumpPower
local noclipEnabled = false

local function applyPlayerSettings(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = customWalkSpeed
        humanoid.UseJumpPower = true
        humanoid.JumpPower = customJumpPower
    end
end

local lp = game.Players.LocalPlayer
if lp.Character then
    task.spawn(applyPlayerSettings, lp.Character)
end
lp.CharacterAdded:Connect(function(char)
    task.spawn(applyPlayerSettings, char)
end)

playerTab:slider("WalkSpeed", 16, 250, defaultWalkSpeed, function(value)
    customWalkSpeed = value
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = value
    end
end, "walkspeed_slider")

playerTab:slider("Jump Power", 50, 350, defaultJumpPower, function(value)
    customJumpPower = value
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        hud = lp.Character.Humanoid
        hud.UseJumpPower = true
        hud.JumpPower = value
    end
end, "jumppower_slider")

playerTab:toggle("Noclip", false, function(state)
    noclipEnabled = state
    if state then
        w:notify("Player", "Noclip Activat", 1.5)
    else
        w:notify("Player", "Noclip Dezactivat", 1.5)
    end
end, "noclip_toggle")

-- NOUĂ SECȚIUNE: Security pentru protecție Anti-AFK
playerTab:section("Security")

playerTab:toggle("Anti-AFK", false, function(state)
    antiAfkEnabled = state
    if antiAfkEnabled then
        w:notify("Security", "Anti-AFK Activat. Nu vei primi kick!", 2)
    else
        w:notify("Security", "Anti-AFK Dezactivat", 2)
    end
end, "anti_afk_toggle")

-- Conexiunea nativă pentru blocarea IDLE kick-ului de 20 de minute
local vu = game:GetService("VirtualUser")
lp.Idled:Connect(function()
    if antiAfkEnabled then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- Pasul RunService pentru Noclip
game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled and lp.Character then
        for _, part in ipairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)
