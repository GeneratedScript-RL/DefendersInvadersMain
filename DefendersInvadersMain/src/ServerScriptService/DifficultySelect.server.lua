game.ReplicatedStorage.SelectDifficulty.OnServerEvent:Connect(function(player, diff)
	require(script.Parent.StartGame).StartGame(diff)
end)