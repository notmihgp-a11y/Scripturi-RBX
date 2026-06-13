local kyri = loadstring(game:HttpGet("https://kyrilib.dev/kyrilib/"))()

local player = game.Players.LocalPlayer
if not player then return end

local TweenService = game:GetService("TweenService")
local running = true

-- [[ CONFIGURAȚII LOGICĂ ]]
local enabled = false
local noclipEnabled = false
local selectedStage = 8
local delayTime = 0
local speedMultiplier = 1

------------------------------------------------
-- CHECKPOINTS & DESTINATIONS
------------------------------------------------
local stage1 = { Vector3.new(-399, 505, -50) }
local stage2 = { Vector3.new(-397, 500, 211) }
local stage3 = {
    Vector3.new(-397, 502, 454), Vector3.new(-349, 502, 468), Vector3.new(-348, 526, 579),
    Vector3.new(-454, 525, 576), Vector3.new(-452, 553, 464), Vector3.new(-351, 554, 467),
    Vector3.new(-347, 580, 576), Vector3.new(-451, 580, 575), Vector3.new(-451, 606, 467),
    Vector3.new(-398, 606, 470), Vector3.new(-400, 607, 629)
}
local stage4 = {
    Vector3.new(-401, 609, 671), Vector3.new(-422, 608, 709), Vector3.new(-422, 605, 738),
    Vector3.new(-400, 607, 785), Vector3.new(-402, 608, 839)
}
local stage5 = { Vector3.new(-401, 608, 865), Vector3.new(-402, 609, 1259) }
local stage6 = {
    Vector3.new(-402, 606, 1284), Vector3.new(-401, 618, 1333), Vector3.new(-412, 607, 1474),
    Vector3.new(-440, 628, 1542), Vector3.new(-440, 629, 1602), Vector3.new(-442, 604, 1699),
    Vector3.new(-440, 615, 1791), Vector3.new(-403, 607, 1863), Vector3.new(-402, 617, 1958),
    Vector3.new(-402, 606, 2043), Vector3.new(-401, 617, 2139), Vector3.new(-403, 606, 2223),
    Vector3.new(-402, 617, 2316), Vector3.new(-401, 622, 2368)
}
local stage7 = { Vector3.new(-401, 623, 2437), Vector3.new(-401, 623, 2634) }
local stage8 = { Vector3.new(-400, 623, 2672), Vector3.new(-400, 624, 3133) }

local destinations = {
    [1] = Vector3.new(-413, 500, 188),
    [2] = Vector3.new(-414, 500, 432),
    [3] = Vector3.new(-419, 605, 608),
    [4] = Vector3.new(-418, 605, 839),
    [5] = Vector3.new(-417, 605, 1263),
    [6] = Vector3.new(-416, 620, 2414),
    [7] = Vector3.new(-416, 620, 2649),
    [8] = Vector3.new(-416, 620, 3159),
}

local function buildPath(stage)
    local path = {}
    if stage >= 1 then for _, p in ipairs(stage1) do table.insert(path, p) end end
    if stage >= 2 then for _, p in ipairs(stage2) do table.insert(path, p) end end
    if stage >= 3 then for _, p in ipairs(stage3) do table.insert(path, p) end end
    if stage >= 4 then for _, p in ipairs(stage4) do table.insert(path, p) end end
    if stage >= 5 then for _, p in ipairs(stage5) do table.insert(path, p) end end
    if stage >= 6 then for _, p in ipairs(stage6) do table.insert(path, p) end end
    if stage >= 7 then for _, p in ipairs(stage7) do table.insert(path, p) end end
    if stage >= 8 then for _, p in ipairs(stage8) do table.insert(path, p) end end
    table.insert(path, destinations[stage])
    return path
end

------------------------------------------------
-- CREARE INTERFAȚĂ ORIZONTALĂ (KYRILIB)
------------------------------------------------
local w = kyri.new("M's Keyboard, {
    GameName = "AutofarmStage",
    AutoLoad = "default"
})

local main = w:tab("Main", "sword")

main:section("Moduri")

-- 1. Toggle Fly
main:toggle("Fly Auto", false, function(state)
    enabled = state
    w:notify("Autofarm", enabled and "Activat" or "Deactivat", 2)
end, "fly_auto")

-- 2. Toggle Noclip
main:toggle("Noclip", false, function(state)
    noclipEnabled = state
    w:notify("Noclip", noclipEnabled and "Activat" or "Deactivat", 2)
end, "noclip_auto")

main:space()
main:section("Configurații")

-- 3. Dropdown Stage
main:dropdown("Select Stage", {"1", "2", "3", "4", "5", "6", "7", "8"}, "8", function(val)
    selectedStage = tonumber(val)
end)

-- 4. Slider Delay
main:slider("Delay (secunde)", 0, 10, 0, function(val)
    delayTime = val
end, "delay_time")

-- 5. Slider Viteză (Convertit din întreg în zecimal)
main:slider("Viteză (Multiplier x10)", 1, 25, 10, function(val)
    speedMultiplier = val / 10
end, "speed_multiplier")

------------------------------------------------
-- LOGICĂ LOOPS
------------------------------------------------
task.spawn(function()
    while running do
        if noclipEnabled then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if char and hrp then
                local currentDestination = destinations[selectedStage]
                local distToDest = (hrp.Position - currentDestination).Magnitude
                local nearDestination = distToDest <= 10

                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                        v.CanTouch = nearDestination and true or false
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

local function flyTo(hrp, pos)
    local dist = (hrp.Position - pos).Magnitude
    local time = math.clamp((dist / 120) / speedMultiplier, 0.1, 6)

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(pos)}
    )

    tween:Play()
    tween.Completed:Wait()
end

task.spawn(function()
    while running do
        if enabled then
            task.wait(delayTime)

            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if hrp then
                local currentPath = buildPath(selectedStage)

                for _, point in ipairs(currentPath) do
                    if not enabled or not running then break end
                    flyTo(hrp, point)
                end
            end
        end
        task.wait(0.3)
    end
end)
