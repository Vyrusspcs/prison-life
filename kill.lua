local targetPlayer = game:GetService("Players"):FindFirstChild("Zetoxyon")

if targetPlayer and targetPlayer.Character then
    local targetCharacter = targetPlayer.Character
    local humanoid = targetCharacter:FindFirstChild("Humanoid")
    local torso = targetCharacter:FindFirstChild("Torso") or targetCharacter:FindFirstChild("UpperTorso")
    
    if humanoid and humanoid.Health > 0 and torso then
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart then
            local originalCFrame = humanoidRootPart.CFrame

            for i = 1, 12 do
                local backOffset = -5 
                local targetLookVector = torso.CFrame.LookVector
                local newPosition = torso.Position + targetLookVector * backOffset
                humanoidRootPart.CFrame = CFrame.new(newPosition, torso.Position)

                wait(0.1)

                local origin = humanoidRootPart.Position
                local spread = Vector3.new(
                    math.random(-2, 2),
                    math.random(-2, 2),
                    math.random(-2, 2)
                )
                local spreadTarget = torso.Position + spread

                local args = {
                    {
                        origin,
                        spreadTarget,
                        torso
                    }
                }

                local success = pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("GunRemotes"):WaitForChild("ShootEvent"):FireServer(args)
                end)

                if success then
                    print("true Shot " .. i .. "/12 fired!")
                else
                    print("false Shot " .. i .. "/12 failed")
                end

                wait(0.1)
            end

            humanoidRootPart.CFrame = originalCFrame
            print("ll 12 shots fired! Returned to original position.")
        else
            print("Your character doesn't have a HumanoidRootPart")
        end
    else
        print("KempaBoss is not alive or doesn't have a torso")
    end
else
    print("KempaBoss not found or no character")
end
