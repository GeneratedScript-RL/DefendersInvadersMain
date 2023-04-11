local anims = game.ServerStorage.Animations
local walk = script.Parent.Humanoid:LoadAnimation(anims.EnemWalkBasic)
walk:Play()

wait(0.5)

script.Parent.Humanoid.HealthChanged:Connect(function()
	if script.Parent.Humanoid.Health < 1 then
		for i, v in pairs(game.Players:GetChildren()) do
			v.Cash.Value += script.Parent.Humanoid.MaxHealth
		end
		script.Parent:Destroy()
	end
end)

while wait(1) do
	script.Parent.Humanoid:MoveTo(workspace.SpawnTroops.Position)
end