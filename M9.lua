-- Super M9 Debug Script
local DebugM9 = {}

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

function DebugM9:CopyToClipboard(text)
    pcall(function()
        setclipboard(tostring(text))
    end)
end

function DebugM9:GetM9DebugInfo()
    local debugInfo = {}
    
    table.insert(debugInfo, "=== SUPER M9 DEBUG ===")
    table.insert(debugInfo, "Player: " .. player.Name)
    table.insert(debugInfo, "Team: " .. (player.Team and player.Team.Name or "None"))
    
    -- Character analysis
    local character = player.Character
    if not character then
        table.insert(debugInfo, "❌ No character found")
        return table.concat(debugInfo, "\n")
    end
    
    table.insert(debugInfo, "✅ Character found")
    
    -- Check for M9 in character
    local m9 = character:FindFirstChild("M9")
    if m9 then
        table.insert(debugInfo, "✅ M9 equipped in character")
        table.insert(debugInfo, "M9 Class: " .. m9.ClassName)
        
        -- Analyze M9 attributes
        table.insert(debugInfo, "\n[M9 ATTRIBUTES]")
        local attributes = {
            "ToolType", "CurrentAmmo", "MaxAmmo", "FireRate", "Spread", 
            "Range", "ProjectileCount", "AutoFire", "ReloadTime",
            "Local_CurrentAmmo", "Local_ReloadSession", "Local_IsShooting"
        }
        
        for _, attr in pairs(attributes) do
            local value = m9:GetAttribute(attr)
            table.insert(debugInfo, attr .. ": " .. tostring(value))
        end
        
        -- Check if M9 has required parts
        table.insert(debugInfo, "\n[M9 STRUCTURE]")
        table.insert(debugInfo, "Handle: " .. (m9:FindFirstChild("Handle") and "✅" or "❌"))
        table.insert(debugInfo, "Muzzle: " .. (m9:FindFirstChild("Muzzle") and "✅" or "❌"))
        
    else
        table.insert(debugInfo, "❌ M9 not equipped in character")
    end
    
    -- Check backpack for M9
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        local backpackM9 = backpack:FindFirstChild("M9")
        if backpackM9 then
            table.insert(debugInfo, "✅ M9 found in backpack")
            table.insert(debugInfo, "Backpack M9 Class: " .. backpackM9.ClassName)
        else
            table.insert(debugInfo, "❌ M9 not in backpack")
        end
    else
        table.insert(debugInfo, "❌ No backpack found")
    end
    
    -- Check gun remotes
    table.insert(debugInfo, "\n[GUN REMOTES]")
    local gunRemotes = ReplicatedStorage:FindFirstChild("GunRemotes")
    if gunRemotes then
        table.insert(debugInfo, "✅ GunRemotes folder found")
        local shootEvent = gunRemotes:FindFirstChild("ShootEvent")
        table.insert(debugInfo, "ShootEvent: " .. (shootEvent and "✅" or "❌"))
    else
        table.insert(debugInfo, "❌ GunRemotes folder not found")
    end
    
    return table.concat(debugInfo, "\n")
end

function DebugM9:TestAttributeModification()
    local testInfo = {}
    table.insert(testInfo, "=== ATTRIBUTE MODIFICATION TEST ===")
    
    local character = player.Character
    if not character then
        table.insert(testInfo, "❌ No character for test")
        return table.concat(testInfo, "\n")
    end
    
    local m9 = character:FindFirstChild("M9")
    if not m9 then
        table.insert(testInfo, "❌ No M9 equipped for test")
        return table.concat(testInfo, "\n")
    end
    
    table.insert(testInfo, "✅ M9 found, testing modification...")
    
    -- Test setting different types of attributes
    local testAttributes = {
        {"TestString", "HelloWorld"},
        {"TestNumber", 12345},
        {"TestBoolean", true},
        {"CurrentAmmo", 999},
        {"FireRate", 0.01}
    }
    
    for i, testAttr in ipairs(testAttributes) do
        local attrName, attrValue = testAttr[1], testAttr[2]
        
        -- Set attribute
        local successSet = pcall(function()
            m9:SetAttribute(attrName, attrValue)
        end)
        
        -- Read back attribute
        local readValue = m9:GetAttribute(attrName)
        
        table.insert(testInfo, string.format("Attribute %s: Set=%s, Read=%s", 
            attrName, successSet and "✅" or "❌", tostring(readValue)))
    end
    
    return table.concat(testInfo, "\n")
end

function DebugM9:TestToolEvents()
    local testInfo = {}
    table.insert(testInfo, "=== TOOL EVENT TEST ===")
    
    local character = player.Character
    if not character then
        table.insert(testInfo, "❌ No character for test")
        return table.concat(testInfo, "\n")
    end
    
    -- Monitor tool events
    local eventConnected = false
    local toolAddedConnection = character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            eventConnected = true
        end
    end)
    
    -- Test equipping from backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        local backpackM9 = backpack:FindFirstChild("M9")
        if backpackM9 then
            table.insert(testInfo, "✅ M9 in backpack, testing equip...")
            
            -- Try to equip
            local success = pcall(function()
                backpackM9.Parent = character
            end)
            
            table.insert(testInfo, "Equip result: " .. (success and "✅" or "❌"))
            
            wait(1)
            
            -- Check if equipped
            if character:FindFirstChild("M9") then
                table.insert(testInfo, "✅ M9 successfully equipped")
            else
                table.insert(testInfo, "❌ M9 failed to equip")
            end
        else
            table.insert(testInfo, "❌ No M9 in backpack to test")
        end
    else
        table.insert(testInfo, "❌ No backpack to test")
    end
    
    toolAddedConnection:Disconnect()
    
    return table.concat(testInfo, "\n")
end

function DebugM9:TestShooting()
    local testInfo = {}
    table.insert(testInfo, "=== SHOOTING TEST ===")
    
    local character = player.Character
    if not character then
        table.insert(testInfo, "❌ No character for test")
        return table.concat(testInfo, "\n")
    end
    
    local m9 = character:FindFirstChild("M9")
    if not m9 then
        table.insert(testInfo, "❌ No M9 equipped for shooting test")
        return table.concat(testInfo, "\n")
    end
    
    table.insert(testInfo, "✅ M9 equipped, testing shoot...")
    
    local gunRemotes = ReplicatedStorage:FindFirstChild("GunRemotes")
    if not gunRemotes then
        table.insert(testInfo, "❌ GunRemotes not found")
        return table.concat(testInfo, "\n")
    end
    
    local shootEvent = gunRemotes:FindFirstChild("ShootEvent")
    if not shootEvent then
        table.insert(testInfo, "❌ ShootEvent not found")
        return table.concat(testInfo, "\n")
    end
    
    table.insert(testInfo, "✅ ShootEvent found")
    
    -- Test shooting parameters
    local origin = character.Head.Position
    local target = origin + Vector3.new(0, 0, 50)
    
    local args = {
        {origin, target, nil}
    }
    
    -- Test firing
    local fireSuccess, fireError = pcall(function()
        shootEvent:FireServer(args)
    end)
    
    table.insert(testInfo, "ShootEvent fire: " .. (fireSuccess and "✅" or "❌ " .. fireError))
    
    -- Check ammo after shooting
    local ammoAfter = m9:GetAttribute("CurrentAmmo")
    table.insert(testInfo, "Ammo after shot: " .. tostring(ammoAfter))
    
    return table.concat(testInfo, "\n")
end

function DebugM9:TestSuperM9Modification()
    local testInfo = {}
    table.insert(testInfo, "=== SUPER M9 MODIFICATION TEST ===")
    
    local SUPER_M9_CONFIG = {
        FireRate = 0.01,
        MaxAmmo = 999,
        CurrentAmmo = 999,
        Spread = 0.001,
        Range = 1000,
        ProjectileCount = 10,
        AutoFire = true,
        ReloadTime = 0.1
    }
    
    local character = player.Character
    if not character then
        table.insert(testInfo, "❌ No character")
        return table.concat(testInfo, "\n")
    end
    
    local m9 = character:FindFirstChild("M9")
    if not m9 then
        table.insert(testInfo, "❌ No M9 equipped")
        return table.concat(testInfo, "\n")
    end
    
    table.insert(testInfo, "✅ M9 found, applying super modifications...")
    
    -- Apply modifications
    local appliedCount = 0
    local totalCount = 0
    
    for attribute, value in pairs(SUPER_M9_CONFIG) do
        totalCount = totalCount + 1
        local success = pcall(function()
            m9:SetAttribute(attribute, value)
        end)
        
        if success then
            appliedCount = appliedCount + 1
            table.insert(testInfo, "✅ " .. attribute .. " = " .. tostring(value))
        else
            table.insert(testInfo, "❌ " .. attribute .. " = FAILED")
        end
    end
    
    table.insert(testInfo, string.format("\nModification Results: %d/%d attributes applied", appliedCount, totalCount))
    
    -- Verify modifications
    table.insert(testInfo, "\n[VERIFICATION]")
    for attribute, expectedValue in pairs(SUPER_M9_CONFIG) do
        local actualValue = m9:GetAttribute(attribute)
        local match = tostring(actualValue) == tostring(expectedValue)
        table.insert(testInfo, string.format("%s: Expected=%s, Got=%s %s", 
            attribute, tostring(expectedValue), tostring(actualValue), match and "✅" or "❌"))
    end
    
    return table.concat(testInfo, "\n")
end

-- Main debug functions
function DebugM9:RunFullDebug()
    local fullDebug = {}
    
    table.insert(fullDebug, self:GetM9DebugInfo())
    table.insert(fullDebug, "\n" .. self:TestAttributeModification())
    table.insert(fullDebug, "\n" .. self:TestSuperM9Modification())
    table.insert(fullDebug, "\n" .. self:TestShooting())
    
    local result = table.concat(fullDebug, "\n")
    self:CopyToClipboard(result)
    print("✅ Full debug completed - copied to clipboard!")
end

function DebugM9:QuickDebug()
    local result = self:GetM9DebugInfo()
    self:CopyToClipboard(result)
    print("✅ Quick debug completed - copied to clipboard!")
end

-- Auto-run quick debug
wait(2)
DebugM9:QuickDebug()

-- Return functions for manual use
return DebugM9
