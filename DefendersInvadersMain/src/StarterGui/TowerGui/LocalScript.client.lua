
game.ReplicatedStorage:WaitForChild("TowerGet").OnClientEvent:Connect(function(towers)
	for i, v in pairs(script.Parent:GetChildren()) do
		if v:IsA("TextButton") then
			v.Text = towers[v.Name]
			
			v.MouseButton1Down:Connect(function()
				game.ReplicatedStorage.Spawntower:FireServer(towers[v.Name])
			end)
			
		end
		
	end
end)