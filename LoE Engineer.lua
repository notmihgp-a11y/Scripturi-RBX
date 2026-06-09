local kyri = loadstring(game:HttpGet("https://kyrilib.dev/kyrilib/"))()

local w = kyri.new("M's Engineer", {
    GameName = "NecroScript",
    AutoLoad = "default"
})

-- ================= CATEGORII (TAB-URI) =================
local farm = w:tab("Farm", "sword")
local mech = w:tab("Mech", "shield")
local miscTab = w:tab("Misc", "settings")

-- ================= SECTIUNI =================
farm:section("Farm Control")
mech:section("Mech Customization & Spawn")
miscTab:section("Miscellaneous")

-- Variables pentru stările butoanelor
local autoValueBuild = false -- Folosit pentru Auto Build
local autoSkill16 = false
local autoArcherTower = false
local autoSkill9 = false
local autoCatapult = false
local autoWallOil = false -- Nou variabilă pentru sistemul de Zid + Ulei
local autoSpawnMechs = false

-- Variabile pentru Auto Skip Wave (Integrate din al doilea script)
local WaveSkipEvent = game:GetService("ReplicatedStorage"):WaitForChild("WaveSkipRemote", 10)
local waveSkipConnection = nil

-- Variabile pentru selecția Robotului
local selectedLeftArm = 1   
local selectedRightArm = 1  
local selectedBackpack = 2  
local selectedColor = {false, true, false, false, false, false} -- Default: Alb

-- Dicționare pentru traducere
local armValues = { ["Minigun"] = 1, ["Flamethrower"] = 2, ["Plasma Gun"] = 3 }
local backpackValues = { ["Shield"] = 1, ["Rockets"] = 2 }

-- Culorile calibrate perfect
local colorValues = {
    ["Maro"]     = {false, false, false, false, false, false},
    ["Alb"]      = {false, true, false, false, false, false},
    ["Negru"]    = {false, false, true, false, false, false},
    ["Rosu"]     = {false, false, false, true, false, false},
    ["Albastru"] = {false, false, false, false, true, false},
    ["Verde"]    = {false, false, false, false, false, true}
}

-- Funcție dedicată pentru ProximityPrompt (Auto Build)
local function FireTargetPrompt()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.ObjectText == "Under Construction" then
            fireproximityprompt(v)
            task.wait()
        end
    end
    
    local getnil = getnilinstances or get_nil_instances
    if getnil then
        for _, v in pairs(getnil()) do
            if v:IsA("ProximityPrompt") and v.ObjectText == "Under Construction" then
                fireproximityprompt(v)
                task.wait()
            end
        end
    end
end

-- ==================== CATEGORIA: FARM ====================

-- 1. Auto Build
farm:toggle("Auto Build", false, function(state)
    autoValueBuild = state
    w:notify("Auto Build", state and "Activat" or "Dezactivat", 2)
    
    if autoValueBuild then
        task.spawn(function()
            while autoValueBuild do
                pcall(function() FireTargetPrompt() end)
                task.wait(0.05)
            end
        end)
    end
end, "auto_build_toggle")

-- 2. Cannon
farm:toggle("Cannon", false, function(state)
    autoSkill16 = state
    w:notify("Cannon", state and "Activat" or "Dezactivat", 2)
    if autoSkill16 then
        task.spawn(function()
            local Event = game:GetService("ReplicatedStorage"):WaitForChild("EngSkill16Local", 5)
            while autoSkill16 do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    if character and Event then
                        local head = character:FindFirstChild("Head")
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if head and hrp then
                            local hammering = head:FindFirstChild("Hammering")
                            local sfx = head:FindFirstChild("Wood Drop Boards Planks Falling To Ground 33 (SFX)")
                            if hammering and sfx then
                                Event:FireServer(539, 5017, 1.8000011444092, -112, 11.5, hammering, sfx, 300, hrp)
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end, "auto_engskill16_toggle")

-- 3. Archer Tower
farm:toggle("Archer Tower", false, function(state)
    autoArcherTower = state
    w:notify("Archer Tower", state and "Activat" or "Dezactivat", 2)
    if autoArcherTower then
        task.spawn(function()
            local Event = game:GetService("ReplicatedStorage"):WaitForChild("EngSkillArcherTower", 5)
            while autoArcherTower do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    if character and Event then
                        local head = character:FindFirstChild("Head")
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if head and hrp then
                            local hammering = head:FindFirstChild("Hammering")
                            local sfx = head:FindFirstChild("Wood Drop Boards Planks Falling To Ground 33 (SFX)")
                            if hammering and sfx then
                                Event:FireServer(156, 5015, 1.8000030517578, -58, 8, hammering, sfx, 200, hrp)
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end, "auto_archer_tower_toggle")

-- 4. Drone
farm:toggle("Drone", false, function(state)
    autoSkill9 = state
    w:notify("Drone", state and "Activat" or "Dezactivat", 2)
    if autoSkill9 then
        task.spawn(function()
            local Event = game:GetService("ReplicatedStorage"):WaitForChild("EngSkill9Local", 5)
            while autoSkill9 do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    if character and Event then
                        local head = character:FindFirstChild("Head")
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if head and hrp then
                            local hammering = head:FindFirstChild("Hammering")
                            local sfx = head:FindFirstChild("Wood Drop Boards Planks Falling To Ground 33 (SFX)")
                            if hammering and sfx then
                                Event:FireServer(5052.1235351562, -97.859977722168, 340, hammering, sfx, 19, hrp, 680, 1.1)
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end, "auto_engskill9_toggle")

-- 5. Catapult
farm:toggle("Catapult", false, function(state)
    autoCatapult = state
    w:notify("Catapult", state and "Activat" or "Dezactivat", 2)
    if autoCatapult then
        task.spawn(function()
            local Event = game:GetService("ReplicatedStorage"):WaitForChild("EngineerSkill8Local", 5)
            while autoCatapult do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    if character and Event then
                        local head = character:FindFirstChild("Head")
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if head and hrp then
                            local hammering = head:FindFirstChild("Hammering")
                            local sfx = head:FindFirstChild("Wood Drop Boards Planks Falling To Ground 33 (SFX)")
                            if hammering and sfx then
                                Event:FireServer(287, 5039, 2.0000019073486, -113, 11.5, hammering, sfx, 150, hrp)
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end, "auto_catapult_toggle")

-- 6. Auto Wall & Oil
farm:toggle("Auto Wall & Oil", false, function(state)
    autoWallOil = state
    w:notify("Wall & Oil", state and "Activat" or "Dezactivat", 2)
    
    if autoWallOil then
        -- Thread 1: Spawnează Zidul (EngineerSkill5Local)
        task.spawn(function()
            local WallEvent = game:GetService("ReplicatedStorage"):WaitForChild("EngineerSkill5Local", 5)
            while autoWallOil do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    if character and WallEvent then
                        local head = character:FindFirstChild("Head")
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if head and hrp then
                            local hammering = head:FindFirstChild("Hammering")
                            local sfx = head:FindFirstChild("Wood Drop Boards Planks Falling To Ground 33 (SFX)")
                            if hammering and sfx then
                                WallEvent:FireServer(5016, 1.8416976928711, 13, 10, hammering, sfx, 1500, hrp)
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
        
        -- Thread 2: Pune Ulei automat pe Ziduri (EngSkill15Local)
        task.spawn(function()
            local OilEvent = game:GetService("ReplicatedStorage"):WaitForChild("EngSkill15Local", 5)
            local clonedSummons = workspace:WaitForChild("ClonedSummons", 5)
            
            while autoWallOil do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    if character and OilEvent and clonedSummons then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local oilSfx = hrp:FindFirstChild("Hammering 6 (SFX)")
                            if oilSfx then
                                -- Caută toate zidurile din folder și le pune ulei
                                for _, obj in pairs(clonedSummons:GetChildren()) do
                                    if obj.Name == "Engineer Stone Wall" then
                                        OilEvent:FireServer(obj, oilSfx, 93, 1)
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end, "auto_wall_oil_toggle")


-- ==================== CATEGORIA: MECH ====================

mech:dropdown("Arma Stanga", {"Minigun", "Flamethrower", "Plasma Gun"}, "Minigun", function(choice)
    selectedLeftArm = armValues[choice] or 1
end, "robot_left_arm_dropdown")

mech:dropdown("Arma Dreapta", {"Minigun", "Flamethrower", "Plasma Gun"}, "Minigun", function(choice)
    selectedRightArm = armValues[choice] or 1
end, "robot_right_arm_dropdown")

mech:dropdown("Selecteaza Rucsac (Backpack)", {"Shield", "Rockets"}, "Rockets", function(choice)
    selectedBackpack = backpackValues[choice] or 2
end, "robot_backpack_dropdown")

mech:dropdown("Selecteaza Culoare", {"Maro", "Alb", "Negru", "Rosu", "Albastru", "Verde"}, "Alb", function(choice)
    selectedColor = colorValues[choice] or {false, true, false, false, false, false}
end, "robot_color_dropdown")

mech:toggle("Spawn Mechs", false, function(state)
    autoSpawnMechs = state
    w:notify("Mech Spawner", state and "Activat" or "Dezactivat", 2)
    
    if autoSpawnMechs then
        task.spawn(function()
            local Event = game:GetService("ReplicatedStorage"):WaitForChild("EngSkill18Local", 5)
            while autoSpawnMechs do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    if character and Event then
                        local head = character:FindFirstChild("Head")
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if head and hrp then
                            local hammering = head:FindFirstChild("Hammering")
                            local sfx = head:FindFirstChild("Wood Drop Boards Planks Falling To Ground 33 (SFX)")
                            
                            local currentX = hrp.Position.X
                            local currentZ = hrp.Position.Z
                            
                            if hammering and sfx then
                                Event:FireServer(
                                    currentX, 
                                    currentZ, 
                                    hammering, 
                                    sfx, 
                                    19, 
                                    hrp, 
                                    680, 
                                    340, 
                                    selectedLeftArm,   
                                    selectedLeftArm,   
                                    1250, 
                                    1625, 
                                    selectedColor[1],  
                                    selectedColor[2], 
                                    selectedColor[3], 
                                    selectedColor[4], 
                                    selectedColor[5], 
                                    selectedColor[6], 
                                    selectedLeftArm,   
                                    selectedRightArm,  
                                    selectedBackpack,  
                                    selectedRightArm   
                                )
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end, "spawn_mechs_toggle")


-- ==================== CATEGORIA: MISC ====================

-- 1. Use Rocket Boots
miscTab:button("Use Rocket Boots", function()
    pcall(function()
        local Event = game:GetService("ReplicatedStorage"):FindFirstChild("EngSkill13Local")
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        
        if character and Event then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local rightBoot = character:FindFirstChild("RocketBootRight")
            local leftBoot = character:FindFirstChild("RocketBootLeft")
            
            if hrp and rightBoot and leftBoot then
                local sfx = hrp:FindFirstChild("Spaceship Interior Rocket Engine Constant 2 (SFX)")
                if sfx then
                    Event:FireServer(sfx, 50, 6000, rightBoot, leftBoot)
                    w:notify("Rocket Boots", "Activat o singură dată!", 2)
                else
                    w:notify("Eroare", "Lipsesc efectele SFX din caracter!", 2)
                end
            else
                w:notify("Eroare", "Nu ai Rocket Boots echipate!", 2)
            end
        end
    end)
end, "use_rocket_boots_button")

-- 2. Auto Skip Wave (Integrat cu succes din al doilea script)
miscTab:toggle("Auto Skip Wave", false, function(state)
    w:notify("Auto Skip", state and "Activat" or "Dezactivat", 2)
    
    if state then
        if WaveSkipEvent then
            waveSkipConnection = WaveSkipEvent.OnClientEvent:Connect(function()
                WaveSkipEvent:FireServer()
            end)
        end
    else
        if waveSkipConnection then
            waveSkipConnection:Disconnect()
            waveSkipConnection = nil
        end
    end
end, "waveskip_toggle")
