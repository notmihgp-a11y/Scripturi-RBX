local kyri = loadstring(game:HttpGet("https://kyrilib.dev/kyrilib/"))()

local w = kyri.new("M's Spawn Battle ", {
    GameName = "Spawn Battle ",
    AutoLoad = "default"
})

local main = w:tab("Main", "sword")

-- Organizarea coordonatelor pe echipe
local configuratie_echipe = {
    ["blue"] = {
        cuburi = Vector3.new(-55, 12, 172),
        destinatii = {
            ["basic"] = Vector3.new(-55, 11, 110),
            ["tank"]  = Vector3.new(-36, 11, 112),
            ["fast"]  = Vector3.new(-76, 11, 111)
        }
    },
    ["red"] = {
        cuburi = Vector3.new(-56, 12, -176),
        destinatii = {
            ["basic"] = Vector3.new(-56, 11, -118),
            ["fast"]  = Vector3.new(-35, 11, -118),
            ["tank"]  = Vector3.new(-75, 11, -118)
        }
    }
}

-- Variabile pentru starea curentă
local selectie_curenta = "basic"
local loop_activ = false
local antiafk_activ = false
local invizibil_activ = false
local noclip_activ = false

local player = game.Players.LocalPlayer
local vu = game:GetService("VirtualUser")
local runService = game:GetService("RunService")

-- Tabele pentru salvarea stării originale a corpului (pentru revenire la vizibil)
local originale_transparente = {}
local originale_billboard = {}
local noclip_conexiune = nil

main:section("Configurare Teleport")

-- Dropdown pentru selectarea destinației
main:dropdown("Destinatie", {"basic", "tank", "fast"}, "basic", function(val)
    selectie_curenta = val
end)

main:space()
main:section("Control Loop")

-- Switch (Toggle) pentru pornirea/oprirea buclei la infinit
main:toggle("Porneste Loop", false, function(state)
    loop_activ = state
    
    if loop_activ then
        w:notify("Teleport", "Bucla a fost pornita! Echipa se detecteaza automat.", 3)
        
        task.spawn(function()
            while loop_activ do
                local carac = player.Character
                if carac and carac:FindFirstChild("HumanoidRootPart") then
                    
                    -- DETECTARE AUTOMATĂ ECHIPĂ
                    local echipa_autodetectata = "blue"
                    
                    if player.Team then
                        local nume_echipa = string.lower(player.Team.Name)
                        if string.find(nume_echipa, "red") or string.find(nume_echipa, "ro") then
                            echipa_autodetectata = "red"
                        elseif string.find(nume_echipa, "blue") or string.find(nume_echipa, "al") then
                            echipa_autodetectata = "blue"
                        end
                    end
                    
                    -- Extreagem datele echipei detectate automat
                    local date_echipa = configuratie_echipe[echipa_autodetectata]
                    
                    if date_echipa then
                        -- Pasul 1: Teleportare la Cuburile echipei respective
                        carac:PivotTo(CFrame.new(date_echipa.cuburi))
                        task.wait(0.1)
                        
                        if not loop_activ then break end
                        
                        -- Pasul 2: Teleportare la destinația selectată din dropdown
                        local coord_destinatie = date_echipa.destinatii[selectie_curenta]
                        if coord_destinatie then
                            carac:PivotTo(CFrame.new(coord_destinatie))
                        end
                    end
                end
                
                task.wait(0.5) 
            end
        end)
    else
        w:notify("Teleport", "Bucla a fost oprita!", 2)
    end
end, "teleport_loop")

main:space()
main:section("Exploits")

-- Switch (Toggle) pentru Invizibilitate ON/OFF
main:toggle("Complet Invizibil", false, function(state)
    invizibil_activ = state
    local carac = player.Character
    
    if not carac or not carac:FindFirstChild("HumanoidRootPart") then
        w:notify("Eroare", "Caracterul nu a fost gasit!", 2)
        return
    end
    
    if invizibil_activ then
        task.spawn(function()
            local anim = carac:FindFirstChild("Animate")
            if anim then anim.Disabled = true end
            
            for _, v in pairs(carac:GetDescendants()) do
                if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                    originale_billboard[v] = v.Enabled
                    v.Enabled = false
                end
                
                if (v:IsA("BasePart") and v.Name ~= "HumanoidRootPart") or v:IsA("Decal") then
                    originale_transparente[v] = v.Transparency
                    v.Transparency = 1
                    
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
            
            carac.HumanoidRootPart.Transparency = 1
            w:notify("Invisible", "Esti complet invizibil!", 2.5)
        end)
    else
        task.spawn(function()
            local anim = carac:FindFirstChild("Animate")
            if anim then anim.Disabled = false end
            
            for gui, stareOriginala in pairs(originale_billboard) do
                if gui and gui.Parent then
                    gui.Enabled = stareOriginala
                end
            end
            
            for piesa, transparentaOriginala in pairs(originale_transparente) do
                if piesa and piesa.Parent then
                    piesa.Transparency = transparentaOriginala
                    if piesa:IsA("BasePart") and piesa.Name ~= "Torso" and piesa.Name ~= "HumanoidRootPart" then
                        piesa.CanCollide = true
                    end
                end
            end
            
            originale_transparente = {}
            originale_billboard = {}
            
            w:notify("Invisible", "Acum esti vizibil din nou!", 2.5)
        end)
    end
end, "complet_invizibil")

-- Switch (Toggle) pentru Noclip ON/OFF
main:toggle("Noclip", false, function(state)
    noclip_activ = state
    
    if noclip_activ then
        w:notify("Noclip", "Noclip Activat! Poti trece prin pereti.", 2.5)
        
        -- Pornim o conexiune rapidă care rulează la fiecare cadru (frame) din joc
        noclip_conexiune = runService.Stepped:Connect(function()
            local carac = player.Character
            if carac then
                for _, piesa in pairs(carac:GetChildren()) do
                    if piesa:IsA("BasePart") then
                        piesa.CanCollide = false
                    end
                end
            end
        end)
    else
        w:notify("Noclip", "Noclip Dezactivat.", 2)
        -- Oprim bucla de fundal a noclipului
        if noclip_conexiune then
            noclip_conexiune:Disconnect()
            noclip_conexiune = nil
        end
        
        -- Resetăm coliziunile la normal pentru picioare/mâini ca să nu cazi prin pământ
        local carac = player.Character
        if carac then
            for _, piesa in pairs(carac:GetChildren()) do
                if piesa:IsA("BasePart") and piesa.Name ~= "HumanoidRootPart" then
                    piesa.CanCollide = true
                end
            end
        end
    end
end, "noclip_toggle")

main:space()
main:section("Utilitati")

-- Switch (Toggle) pentru Anti-AFK
main:toggle("Anti AFK", false, function(state)
    antiafk_activ = state
    if antiafk_activ then
        w:notify("Anti-AFK", "Anti-AFK activat! Nu vei mai primi kick.", 3)
    else
        w:notify("Anti-AFK", "Anti-AFK dezactivat.", 2)
    end
end, "anti_afk")

player.Idled:Connect(function()
    if antiafk_activ then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)
