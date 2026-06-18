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

-- Locația selectată implicit din dropdown
local selectedGrazingSpot = "1. basic"

-- ==========================================
-- FILA 1: CONTROLUL OILOR (SHEEP CONTROL)
-- ==========================================
local main = w:tab("Sheep Control", "paw")

main:section("Actions")

-- Dropdown pentru selectarea locației de grazing
main:dropdown("Select Grazing Spot", {"1. basic", "2. rich", "3. flower", "4. building", "5. alien", "6. heavenly", "7. Volcano"}, "1. basic", function(selected)
    selectedGrazingSpot = selected
    w:notify("Grazing", "Spot schimbat in: " .. selected, 1.5)
end, "grazing_spot_dropdown")

-- Starea globală pentru a controla acțiunea
local isGrazingFarmActive = false

-- Butonul Start Grazing modificat pentru a folosi dropdown-ul
main:toggle("Start Grazing", false, function(state)
    isGrazingFarmActive = state

    if isGrazingFarmActive then
        task.spawn(function()
            local player = game.Players.LocalPlayer
            local sheepEvent = game:GetService("ReplicatedStorage").Events.SheepAction
            
            -- Preluăm coordonata din tabel în funcție de ce e selectat în dropdown
            local centerCoords = grazingLocations[selectedGrazingSpot] or Vector3.new(373, 29, -88)
            
            -- 1. Teleportare inițială instantanee direct în locația aleasă
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(centerCoords)
                w:notify("Sheep", "Teleported to " .. selectedGrazingSpot .. "! Waiting 2 seconds...", 1.5)
            end
            
            -- 2. Așteaptă 2 secunde inițiale
            task.wait(2)
            if not isGrazingFarmActive then return end
            
            -- 3. Pornește grazing
            sheepEvent:FireServer("grazing")
            w:notify("Sheep", "Grazing started! Active for 20s.", 2)
            
            -- 4. Așteaptă 20 de secunde
            task.wait(20)
            
            -- 5. După 20s, oprește grazing-ul automat
            if isGrazingFarmActive then
                isGrazingFarmActive = false
                sheepEvent:FireServer("stopgrazing")
                w:notify("Sheep", "Time up! Stop Grazing trimis.", 2)
                w:update_toggle("start_grazing_toggle", false)
            end
        end)
    else
        w:notify("Sheep", "Automation Stopped Manually", 2)
    end
end, "start_grazing_toggle")

-- Buton ON/OFF pentru Stop Grazing
main:toggle("Stop Grazing", false, function(state)
    if state then
        local Event = game:GetService("ReplicatedStorage").Events.SheepAction
        Event:FireServer("stopgrazing")
        w:notify("Sheep", "Stop Grazing: ON", 2)
    else
        w:notify("Sheep", "Stop Grazing: OFF", 2)
    end
end, "stop_grazing_toggle")

-- Buton ON/OFF pentru Sheepfold
main:toggle("Sheepfold", false, function(state)
    if state then
        local Event = game:GetService("ReplicatedStorage").Events.SheepAction
        Event:FireServer("sheepfold")
        w:notify("Sheep", "Sheepfold: ON", 2)
    else
        w:notify("Sheep", "Sheepfold: OFF", 2)
    end
end, "sheepfold_toggle")

-- Buton ON/OFF pentru Out
main:toggle("Release (Out)", false, function(state)
    if state then
        local Event = game:GetService("ReplicatedStorage").Events.SheepAction
        Event:FireServer("out")
        w:notify("Sheep", "Release (Out): ON", 2)
    else
        w:notify("Sheep", "Release (Out): OFF", 2)
    end
end, "sheep_out_toggle")

main:space()
main:section("Collection")

-- Buton ON/OFF pentru Colectare Automată
local collecting = false
main:toggle("Collect Wool", false, function(state)
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
-- FILA 2: TELEPORTĂRI (TELEPORTS)
-- ==========================================
local teleportsTab = w:tab("Teleports", "map")

teleportsTab:section("Locations")

-- Funcție ajutătoare internă pentru a efectua teleportarea instantă în siguranță
local function instantTeleport(coords, locationName)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(coords)
        w:notify("Teleport", "Teleported to " .. locationName .. "!", 1.5)
    else
        w:notify("Error", "Character not found!", 2)
    end
end

-- Butoane Teleport implicite
teleportsTab:button("Spawn", function()
    instantTeleport(Vector3.new(71, 5, -78), "Spawn")
end)

teleportsTab:button("Sea Traveler", function()
    instantTeleport(Vector3.new(-158, 5, -128), "Sea Traveler")
end)

teleportsTab:button("Pet store", function()
    instantTeleport(Vector3.new(214, 5, -78), "Pet store")
end)

-- Noile butoane de teleportare adăugate la cerere
teleportsTab:button("Volcano", function()
    instantTeleport(Vector3.new(-601, 30, 582), "Volcano")
end)

teleportsTab:button("Chill spot", function()
    instantTeleport(Vector3.new(214, 253, 305), "Chill spot")
end)

-- ==========================================
-- FILA 3: JUCĂTOR (PLAYER)
-- ==========================================
local playerTab = w:tab("Player", "user")

playerTab:section("LocalPlayer Modifications")

local defaultWalkSpeed = 16
local defaultJumpPower = 50

-- Variabile ce păstrează opțiunile tale pe tot parcursul sesiunii
local customWalkSpeed = defaultWalkSpeed
local customJumpPower = defaultJumpPower
local noclipEnabled = false

-- Funcție ajutătoare pentru a aplica din nou setările pe noul Humanoid
local function applyPlayerSettings(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = customWalkSpeed
        humanoid.UseJumpPower = true
        humanoid.JumpPower = customJumpPower
    end
end

-- Monitorizăm când se schimbă caracterul sau dă respawn
local lp = game.Players.LocalPlayer
if lp.Character then
    task.spawn(applyPlayerSettings, lp.Character)
end
lp.CharacterAdded:Connect(function(char)
    task.spawn(applyPlayerSettings, char)
end)

-- Slider pentru WalkSpeed
playerTab:slider("WalkSpeed", 16, 250, defaultWalkSpeed, function(value)
    customWalkSpeed = value
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = value
    end
end, "walkspeed_slider")

-- Slider pentru JumpPower
playerTab:slider("Jump Power", 50, 350, defaultJumpPower, function(value)
    customJumpPower = value
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.UseJumpPower = true
        lp.Character.Humanoid.JumpPower = value
    end
end, "jumppower_slider")

-- Buton ON/OFF pentru Noclip
playerTab:toggle("Noclip", false, function(state)
    noclipEnabled = state
    if state then
        w:notify("Player", "Noclip Activat", 1.5)
    else
        w:notify("Player", "Noclip Dezactivat", 1.5)
    end
end, "noclip_toggle")

-- Loop pentru Noclip rulat în fundal
game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled and lp.Character then
        for _, part in ipairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)
