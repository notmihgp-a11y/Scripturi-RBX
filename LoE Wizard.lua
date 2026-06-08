local kyri = loadstring(game:HttpGet("https://kyrilib.dev/kyrilib/"))()

local w = kyri.new("M's Wizard", {
    GameName = "WizardFarm",
    AutoLoad = "default"
})

-- ================= CATEGORII (TAB-URI) =================
local farm = w:tab("Farm", "sword")
local playerTab = w:tab("Player", "user")
local miscTab = w:tab("Misc", "settings")

farm:section("Farm Control")
playerTab:section("Player Buffs")
miscTab:section("Miscellaneous")

-- ================= EVENIMENTE JOC =================
local WaveSkipEvent = game:GetService("ReplicatedStorage"):WaitForChild("WaveSkipRemote", 10)

local isToggledGolem = false
local isToggledBlizzard = false
local isToggledFirewall = false 
local isToggledRupture = false 
local isToggledStarfall = false 
local isToggledMissile = false 
local isToggledHaste = false 
local isToggledMageArmor = false 
local isToggledShieldBarrier = false 
local waveSkipConnection = nil

-- Coordonatele globale generale
local minX, maxX = 4800, 5200
local minZ, maxZ = -130, 160

-- ==================== CATEGORIA: FARM ====================

-- 1. Iron Golem
farm:toggle("Iron Golem", false, function(state)
    isToggledGolem = state
    w:notify("Iron Golem", state and "Activat" or "Dezactivat", 2)
    
    if isToggledGolem then
        task.spawn(function()
            while isToggledGolem do
                pcall(function()
                    local char = game:GetService("Players").LocalPlayer.Character
                    if char then
                        local hrp = char:WaitForChild("HumanoidRootPart", 2)
                        local particle = char:WaitForChild("Particle", 2)
                        
                        local WizardEvent = game:GetService("ReplicatedStorage"):FindFirstChild("WizardSummonIronGolem")
                        if WizardEvent and hrp and particle then
                            for i = 1, 5 do 
                                local randomX = math.random(minX, maxX)
                                local randomZ = math.random(minZ, maxZ)
                                
                                WizardEvent:FireServer(
                                    randomX,
                                    8.2726215362549,
                                    randomZ,
                                    hrp:FindFirstChild("Fire Spell") or hrp,
                                    particle:FindFirstChild("Particles") or particle,
                                    particle:FindFirstChild("ParticleEmitter") or particle,
                                    particle:FindFirstChild("PointLight") or particle,
                                    105,
                                    200,
                                    1400,
                                    hrp:FindFirstChild("Spell Fail") or hrp
                                )
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end, "golem_toggle")

-- 2. Blizzard Storm
farm:toggle("Blizzard Storm", false, function(state)
    isToggledBlizzard = state
    w:notify("Blizzard Storm", state and "Activat" or "Dezactivat", 2)
    
    if isToggledBlizzard then
        task.spawn(function()
            local blizzardMinZ, blizzardMaxZ = 100, 150
            
            while isToggledBlizzard do
                pcall(function()
                    local char = game:GetService("Players").LocalPlayer.Character
                    if char then
                        local hrp = char:WaitForChild("HumanoidRootPart", 2)
                        local particle = char:WaitForChild("Particle", 2)
                        
                        local BlizzardEvent = game:GetService("ReplicatedStorage"):FindFirstChild("WizardBlizzardLocal")
                        if BlizzardEvent and hrp and particle then
                            for i = 1, 5 do 
                                local randomX = math.random(minX, maxX)
                                local randomZ = math.random(blizzardMinZ, blizzardMaxZ)
                                
                                BlizzardEvent:FireServer(
                                    randomX,
                                    3.8000106811523,
                                    randomZ,
                                    hrp:FindFirstChild("ui_star_impact_1") or hrp,
                                    particle:FindFirstChild("Particles") or particle,
                                    particle:FindFirstChild("ParticleEmitter") or particle,
                                    particle:FindFirstChild("PointLight") or particle,
                                    25,
                                    17.5,
                                    11.5,
                                    4
                                )
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end, "blizzard_toggle")

-- 3. Firewall Skill
farm:toggle("Firewall Skill", false, function(state)
    isToggledFirewall = state
    w:notify("Firewall Skill", state and "Activat" or "Dezactivat", 2)
    
    if isToggledFirewall then
        task.spawn(function()
            local firewallMinZ, firewallMaxZ = -10, 10
            
            while isToggledFirewall do
                pcall(function()
                    local char = game:GetService("Players").LocalPlayer.Character
                    if char then
                        local hrp = char:WaitForChild("HumanoidRootPart", 2)
                        local particle = char:WaitForChild("Particle", 2)
                        
                        local FirewallEvent = game:GetService("ReplicatedStorage"):FindFirstChild("WizardFirewallSkill")
                        if FirewallEvent and hrp and particle then
                            for i = 1, 5 do 
                                local randomX = math.random(minX, maxX)
                                local randomZ = math.random(firewallMinZ, firewallMaxZ)
                                
                                FirewallEvent:FireServer(
                                    randomX,
                                    3.7999992370605,
                                    randomZ,
                                    particle:FindFirstChild("PointLightHeal") or particle,
                                    particle:FindFirstChild("Fireball1") or particle,
                                    particle:FindFirstChild("Fireball2") or particle,
                                    hrp:FindFirstChild("Magic") or hrp,
                                    30,
                                    35,
                                    9.5,
                                    8
                                )
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end, "firewall_toggle")

-- 4. Rupture Skill
farm:toggle("Rupture Skill", false, function(state)
    isToggledRupture = state
    w:notify("Rupture Skill", state and "Activat" or "Dezactivat", 2)
    
    if isToggledRupture then
        task.spawn(function()
            local ruptureMinZ, ruptureMaxZ = 100, 150
            
            while isToggledRupture do
                pcall(function()
                    local char = game:GetService("Players").LocalPlayer.Character
                    if char then
                        local hrp = char:WaitForChild("HumanoidRootPart", 2)
                        local particle = char:WaitForChild("Particle", 2)
                        
                        local RuptureEvent = game:GetService("ReplicatedStorage"):FindFirstChild("WizardRuptureLocal")
                        if RuptureEvent and hrp and particle then
                            for i = 1, 5 do 
                                local randomX = math.random(minX, maxX)
                                local randomZ = math.random(ruptureMinZ, ruptureMaxZ)
                                
                                RuptureEvent:FireServer(
                                    randomX,
                                    7.5,
                                    randomZ,
                                    hrp:FindFirstChild("ui_star_impact_1") or hrp,
                                    particle:FindFirstChild("Rupture1") or particle,
                                    particle:FindFirstChild("Rupture2") or particle,
                                    particle:FindFirstChild("PointLight") or particle,
                                    150
                                )
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end, "rupture_toggle")

-- 5. Starfall Skill
farm:toggle("Starfall Skill", false, function(state)
    isToggledStarfall = state
    w:notify("Starfall Skill", state and "Activat" or "Dezactivat", 2)
    
    if isToggledStarfall then
        task.spawn(function()
            while isToggledStarfall do
                pcall(function()
                    local char = game:GetService("Players").LocalPlayer.Character
                    if char then
                        local hrp = char:WaitForChild("HumanoidRootPart", 2)
                        local particle = char:WaitForChild("Particle", 2)
                        
                        local StarfallEvent = game:GetService("ReplicatedStorage"):FindFirstChild("WizardStarfallLocal")
                        if StarfallEvent and hrp and particle then
                            for i = 1, 10 do
                                if not isToggledStarfall then break end
                                
                                StarfallEvent:FireServer(
                                    hrp:FindFirstChild("BRAAAMS-Sample Blaster") or hrp,
                                    particle:FindFirstChild("Particles") or particle,
                                    particle:FindFirstChild("ParticleEmitter") or particle,
                                    particle:FindFirstChild("PointLight") or particle,
                                    300,
                                    22.8
                                )
                            end
                        end
                    end
                end)
                task.wait(60)
            end
        end)
    end
end, "starfall_toggle")

-- 6. Magic Missile
farm:toggle("Magic Missile", false, function(state)
    isToggledMissile = state
    w:notify("Magic Missile", state and "Activat" or "Dezactivat", 2)
    
    if isToggledMissile then
        task.spawn(function()
            local missileMinX, missileMaxX = 4800, 5200
            local missileMinZ, missileMaxZ = -130, 160
            
            while isToggledMissile do
                pcall(function()
                    local char = game:GetService("Players").LocalPlayer.Character
                    if char then
                        local hrp = char:WaitForChild("HumanoidRootPart", 2)
                        local particle = char:WaitForChild("Particle", 2)
                        
                        local MissileEvent = game:GetService("ReplicatedStorage"):FindFirstChild("WizardMagicMissileLocal")
                        if MissileEvent and hrp and particle then
                            for i = 1, 5 do 
                                local randomX = math.random(missileMinX, missileMaxX)
                                local randomZ = math.random(missileMinZ, missileMaxZ)
                                local targetVector = Vector3.new(randomX, 4.9468388557434, randomZ)
                                
                                MissileEvent:FireServer(
                                    hrp:FindFirstChild("ui_star_impact_1") or hrp,
                                    particle:FindFirstChild("Particles") or particle,
                                    particle:FindFirstChild("ParticleEmitter") or particle,
                                    particle:FindFirstChild("PointLight") or particle,
                                    60,
                                    targetVector,
                                    130
                                )
                            end
                        end
                    end
                end)
                task.wait(0.20)
            end
        end)
    end
end, "missile_toggle")


-- ==================== CATEGORIA: PLAYER ====================

-- 1. Wizard Haste
playerTab:toggle("Wizard Haste", false, function(state)
    isToggledHaste = state
    w:notify("Wizard Haste", state and "Activat" or "Dezactivat", 2)
    
    if isToggledHaste then
        task.spawn(function()
            while isToggledHaste do
                pcall(function()
                    local char = game:GetService("Players").LocalPlayer.Character
                    if char then
                        local hrp = char:WaitForChild("HumanoidRootPart", 2)
                        local particle = char:WaitForChild("Particle", 2)
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        
                        local HasteEvent = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteWizardHasteLocal")
                        if HasteEvent and hrp and particle and humanoid then
                            HasteEvent:FireServer(
                                particle:FindFirstChild("PointLightHeal") or particle,
                                particle:FindFirstChild("TurnToStone1") or particle,
                                particle:FindFirstChild("TurnToStone2") or particle,
                                hrp:FindFirstChild("ui_star_impact_1") or hrp,
                                humanoid,
                                24.75,
                                19.75
                            )
                        end
                    end
                end)
                task.wait(24)
            end
        end)
    end
end, "haste_toggle")

-- 2. Mage Armor
playerTab:toggle("Mage Armor", false, function(state)
    isToggledMageArmor = state
    w:notify("Mage Armor", state and "Activat" or "Dezactivat", 2)
    
    if isToggledMageArmor then
        task.spawn(function()
            while isToggledMageArmor do
                pcall(function()
                    local char = game:GetService("Players").LocalPlayer.Character
                    if char then
                        local hrp = char:WaitForChild("HumanoidRootPart", 2)
                        local particle = char:WaitForChild("Particle", 2)
                        
                        local MageArmorEvent = game:GetService("ReplicatedStorage"):FindFirstChild("WizardMageArmorLocal")
                        if MageArmorEvent and hrp and particle then
                            local playerX = hrp.Position.X
                            local playerY = hrp.Position.Y
                            local playerZ = hrp.Position.Z
                            
                            MageArmorEvent:FireServer(
                                playerX,
                                playerY,
                                playerZ,
                                hrp:FindFirstChild("healed") or hrp,
                                particle:FindFirstChild("MA") or particle,
                                particle:FindFirstChild("MA1") or particle,
                                particle:FindFirstChild("PointLightHeal") or particle,
                                39.75
                            )
                        end
                    end
                end)
                task.wait(5)
            end
        end)
    end
end, "magearmor_toggle")

-- 3. Shield Barrier
playerTab:toggle("Shield Barrier", false, function(state)
    isToggledShieldBarrier = state
    w:notify("Shield Barrier", state and "Activat" or "Dezactivat", 2)
    
    if isToggledShieldBarrier then
        task.spawn(function()
            while isToggledShieldBarrier do
                pcall(function()
                    local char = game:GetService("Players").LocalPlayer.Character
                    if char then
                        local hrp = char:WaitForChild("HumanoidRootPart", 2)
                        local particle = char:WaitForChild("Particle", 2)
                        
                        local ShieldEvent = game:GetService("ReplicatedStorage"):FindFirstChild("WizardShieldBarrierRemote")
                        if ShieldEvent and hrp and particle then
                            local playerX = hrp.Position.X
                            local playerY = hrp.Position.Y
                            local playerZ = hrp.Position.Z
                            
                            ShieldEvent:FireServer(
                                playerX,
                                playerY,
                                playerZ,
                                hrp:FindFirstChild("healed") or hrp,
                                particle:FindFirstChild("Shield1") or particle,
                                particle:FindFirstChild("Shield2") or particle,
                                particle:FindFirstChild("PointLight") or particle,
                                13.9
                            )
                        end
                    end
                end)
                task.wait(5)
            end
        end)
    end
end, "shieldbarrier_toggle")


-- ==================== CATEGORIA: MISC ====================

-- 1. Auto Skip Wave
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
