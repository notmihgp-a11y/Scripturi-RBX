local kyri = loadstring(game:HttpGet("https://kyrilib.dev/kyrilib/"))()

local w = kyri.new("Necromancer", {
    GameName = "NecroScript",
    AutoLoad = "default"
})

-- ================= CATEGORII (TAB-URI) =================
local farm = w:tab("Farm", "sword")
farm:section("Farm Control")

local spawns = w:tab("Spawns", "shield")
spawns:section("Spawns Control")

-- ================= EVENIMENTE JOC =================
local Event14 = game:GetService("ReplicatedStorage").Necro.NecSkill14Local
local Event12 = game:GetService("ReplicatedStorage").Necro.NecSkill12Local
local Event6 = game:GetService("ReplicatedStorage").Necro.NecSkill6Local
local Event2 = game:GetService("ReplicatedStorage").Necro.NecSkill2Local
local Event3 = game:GetService("ReplicatedStorage").Necro.NecSkill3Local
local WaveSkipEvent = game:GetService("ReplicatedStorage"):WaitForChild("WaveSkipRemote", 10)

local isToggled14 = false
local isToggled12 = false
local isToggled6 = false
local isToggled2 = false
local isToggled3 = false
local waveSkipConnection = nil


-- ==================== CATEGORIA: FARM ====================

-- 1. purple circle
farm:toggle("purple circle", false, function(state)
    isToggled12 = state
    w:notify("purple circle", state and "Activat" or "Dezactivat", 2)
    
    if isToggled12 then
        task.spawn(function()
            local minX, maxX = 4892, 5099
            local minZ, maxZ = -6, 138
            
            while isToggled12 do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        
                        if hrp then
                            local deathSpell = hrp:FindFirstChild("Death Spell")
                            local blackMagic = hrp:FindFirstChild("BlackMagic")
                            
                            if deathSpell and blackMagic then
                                for i = 1, 5 do 
                                    local randomX = math.random(minX, maxX)
                                    local randomZ = math.random(minZ, maxZ)
                                    local randomY = math.random(20, 50) / 10 
                                    
                                    Event12:FireServer(
                                        47,
                                        randomX,
                                        randomY,
                                        randomZ,
                                        deathSpell,
                                        38.6,
                                        blackMagic
                                    )
                                end
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end, "skill12_toggle")

-- 2. Auto Skip Wave
farm:toggle("Auto Skip Wave", false, function(state)
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


-- ==================== CATEGORIA: SPAWNS ====================

-- 1. big skelly
spawns:toggle("big skelly", false, function(state)
    isToggled14 = state
    w:notify("big skelly", state and "Activat" or "Dezactivat", 2)
    
    if isToggled14 then
        task.spawn(function()
            while isToggled14 do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    
                    if character then
                        local spawnPlatform = character:FindFirstChild("SpawnPlatform")
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        
                        if spawnPlatform and hrp then
                            local deathSpell = hrp:FindFirstChild("Death Spell")
                            local blackMagic = hrp:FindFirstChild("BlackMagic")
                            
                            if deathSpell and blackMagic then
                                Event14:FireServer(
                                    3700,
                                    146,
                                    313487822,
                                    spawnPlatform,
                                    deathSpell,
                                    blackMagic
                                )
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end, "skill14_toggle")

-- 2. skelly
spawns:toggle("skelly", false, function(state)
    isToggled3 = state
    w:notify("skelly", state and "Activat" or "Dezactivat", 2)
    
    if isToggled3 then
        task.spawn(function()
            while isToggled3 do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    
                    if character then
                        local spawnPlatform = character:FindFirstChild("SpawnPlatform")
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        
                        if spawnPlatform and hrp then
                            local deathSpell = hrp:FindFirstChild("Death Spell")
                            local blackMagic = hrp:FindFirstChild("BlackMagic")
                            
                            if deathSpell and blackMagic then
                                Event3:FireServer(
                                    562,
                                    89,
                                    313487822,
                                    spawnPlatform,
                                    deathSpell,
                                    blackMagic
                                )
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end, "skill3_toggle")

-- 3. archer
spawns:toggle("archer", false, function(state)
    isToggled6 = state
    w:notify("archer", state and "Activat" or "Dezactivat", 2)
    
    if isToggled6 then
        task.spawn(function()
            while isToggled6 do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    
                    if character then
                        local spawnPlatform = character:FindFirstChild("SpawnPlatform")
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        
                        if spawnPlatform and hrp then
                            local deathSpell = hrp:FindFirstChild("Death Spell")
                            local blackMagic = hrp:FindFirstChild("BlackMagic")
                            
                            if deathSpell and blackMagic then
                                Event6:FireServer(
                                    410,
                                    79,
                                    313487822,
                                    spawnPlatform,
                                    deathSpell,
                                    blackMagic
                                )
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end, "skill6_toggle")

-- 4. zombie
spawns:toggle("zombie", false, function(state)
    isToggled2 = state
    w:notify("zombie", state and "Activat" or "Dezactivat", 2)
    
    if isToggled2 then
        task.spawn(function()
            while isToggled2 do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    
                    if character then
                        local spawnPlatform = character:FindFirstChild("SpawnPlatform")
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        
                        if spawnPlatform and hrp then
                            local deathSpell = hrp:FindFirstChild("Death Spell")
                            local blackMagic = hrp:FindFirstChild("BlackMagic")
                            
                            if deathSpell and blackMagic then
                                Event2:FireServer(
                                    348,
                                    69,
                                    313487822,
                                    spawnPlatform,
                                    deathSpell,
                                    blackMagic
                                )
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end, "skill2_toggle")
