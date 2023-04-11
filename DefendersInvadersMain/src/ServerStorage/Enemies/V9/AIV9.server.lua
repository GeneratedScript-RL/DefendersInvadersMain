local anims = game.ServerStorage.Animations
local walk = script.Parent.Humanoid:LoadAnimation(anims.EnemWalkBasic)
walk:Play()
local swing = script.Parent.Humanoid:LoadAnimation(anims.EnemSwingV9)
local Range = 30
local closestMag = 101023912391923
local closest = nil

script.Parent.Humanoid.HealthChanged:Connect(function()
	if script.Parent.Humanoid.Health < 1 then
		for i, v in pairs(game.Players:GetChildren()) do
			v.Cash.Value += script.Parent.Humanoid.MaxHealth/2
		end
		script.Parent:Destroy()
	end
end)

while wait(1) do
	for i, v in pairs(workspace.Troops:GetChildren()) do
		local hrp = v:FindFirstChild("HumanoidRootPart")
		local hum = v:FindFirstChild("Humanoid")
		
		if (script.Parent.HumanoidRootPart.Position - hrp.Position).Magnitude <= 4 then
			swing:Play()
			hum:TakeDamage(5)
			hrp.CFrame *= CFrame.new(0, 0, 6)
			wait(5)
		end
		
		if (script.Parent.HumanoidRootPart.Position - hrp.Position).Magnitude < closestMag then
			closestMag = (script.Parent.HumanoidRootPart.Position - hrp.Position).Magnitude
			closest = v
			script.Parent.Humanoid:MoveTo(hrp.Position, hrp)
		end
	end
	closest = nil
	closest = math.huge
end