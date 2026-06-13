--// Kyri Library Initialization
local kyri = loadstring(game:HttpGet("https://kyrilib.dev/kyrilib/"))()

local w = kyri.new("Lemon Sells", {
    GameName = "LemonSells",
    AutoLoad = "default"
})

local main = w:tab("Main", "home")

--// Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--// Find Tycoon
local userTycoon = (function()
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Folder") and v.Name:match("Tycoon%d") then
            if v:FindFirstChild("Owner") and v.Owner.Value == LocalPlayer then
                return v
            end
        end
    end
end)()

if not userTycoon then
    w:notify("Error", "Tycoon not found!", 5)
    return
end

--// Variables
local AutoBuy = false
local AutoUpgrade = false
local AutoFruit = false
local Buying = false

--// Functions for Auto Buy
local function getButtons()
    local Buttons = {}

    for _, obj in ipairs(userTycoon.Purchases:GetDescendants()) do
        if obj:IsA("Model") then
            local shown = obj:GetAttribute("Shown")
            local purchased = obj:GetAttribute("Purchased")

            if shown == true and purchased ~= true then
                local buttonPart = obj:FindFirstChild("Button")
                if buttonPart and buttonPart:IsA("BasePart") then
                    table.insert(Buttons, {
                        Name = obj.Name,
                        Button = buttonPart,
                    })
                end
            end
        end
    end

    return Buttons
end

local function buyButton(buttonData)
    if Buying then return end
    Buying = true

    local character = LocalPlayer.Character
    if not character then Buying = false return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then Buying = false return end

    local buttonPart = buttonData.Button

    pcall(function()
        firetouchinterest(hrp, buttonPart, 0)
        firetouchinterest(hrp, buttonPart, 1)
    end)

    Buying = false
end

task.spawn(function()
    while true do
        task.wait(0.0000001)
        if AutoBuy then
            local Buttons = getButtons()
            for _, button in ipairs(Buttons) do
                pcall(function()
                    buyButton(button)
                end)
            end
        end
    end
end)

--// Functions for Auto Upgrade
local function upgradeMachines()
    for _, obj in ipairs(userTycoon.Purchases:GetDescendants()) do
        if obj:IsA("RemoteFunction") and obj.Name == "Upgrade" then
            pcall(function()
                for level = 1, 100 do
                    obj:InvokeServer(level)
                end
            end)
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.00001)
        if AutoUpgrade then
            pcall(function()
                upgradeMachines()
            end)
        end
    end
end)

--// Functions for Auto Fruit
local Trees = {}

local function addTree(obj)
    if obj:IsA("Model") and obj.Name == "LemonTree" then
        if not table.find(Trees, obj) then
            table.insert(Trees, obj)
        end
    end
end

local function removeTree(obj)
    local index = table.find(Trees, obj)
    if index then
        table.remove(Trees, index)
    end
end

-- Initial scan
for _, v in ipairs(workspace:GetDescendants()) do
    addTree(v)
end

-- Realtime update
workspace.DescendantAdded:Connect(addTree)
workspace.DescendantRemoving:Connect(removeTree)

local function noCollisionTree(tree)
    for _, obj in ipairs(tree:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CanCollide = false
        end
    end
end

local function teleportToTree(tree)
    local character = LocalPlayer.Character
    if not character then return false end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local cf = tree:GetPivot()
    hrp.CFrame = cf + Vector3.new(0, 5, 0)
    return true
end

local function collectFruit(tree)
    noCollisionTree(tree)
    local success = teleportToTree(tree)
    if not success then return end

    for _, obj in ipairs(tree:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Fruit" then
            obj.CanCollide = false
            local clickPart = obj:FindFirstChild("ClickPart")
            if clickPart then
                local detector = clickPart:FindFirstChildOfClass("ClickDetector")
                if detector then
                    task.wait(0.45)
                    pcall(function()
                        fireclickdetector(detector)
                    end)
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoFruit then
            for _, tree in ipairs(Trees) do
                if not AutoFruit then break end
                if tree and tree.Parent then
                    pcall(function()
                        collectFruit(tree)
                    end)
                end
            end
        end
    end
end)

--// Kyri GUI Elements
main:section("Autofarm Controls")

main:toggle("Auto Buy", false, function(state)
    AutoBuy = state
    w:notify("Auto Buy", state and "Enabled" or "Disabled", 3)
end, "AutoBuy")

main:toggle("Auto Upgrade", false, function(state)
    AutoUpgrade = state
    w:notify("Auto Upgrade", state and "Enabled" or "Disabled", 3)
end, "AutoUpgrade")

main:toggle("Auto Fruit", false, function(state)
    AutoFruit = state
    w:notify("Auto Fruit", state and "Enabled" or "Disabled", 3)
end, "AutoFruit")

main:space()
main:section("Settings")

main:button("Destroy GUI", function()
    pcall(function()
        w:destroy()
    end)
end)

--// Load Notification
w:notify("Loaded", "Tycoon Autofarm Loaded Successfully", 5)
