local towerget = game.ReplicatedStorage:WaitForChild("TowerGet")
local ds = game:GetService("DataStoreService")
local data = ds:GetDataStore("PlayerGameInfo")

game.Players.PlayerAdded:Connect(function(player)
	
	local playerInfo
	local success, err = pcall(function()
		playerInfo = data:GetAsync(player.UserId)
	end)
	print(playerInfo)
	
	if not playerInfo then
		playerInfo = {
			Credits = 0,
			Slot1 = "Soldier",
			Slot2 = "Empty",
			Slot3 = "Empty",
			Slot4 = "Empty",
			Slot5 = "Empty",
			Inventory = {}
		}
	end
	
	towerget:FireClient(player, playerInfo)
	
	local cash = Instance.new("NumberValue", player)
	cash.Name = "Cash"
	cash.Value = 1000
	
end)

game.Players.PlayerRemoving:Connect(function(player)
	local playerInfo
	local success, err = pcall(function()
		playerInfo = data:GetAsync(player.UserId)
	end)
	
	if not playerInfo then
		playerInfo = {
			Credits = 0,
			Slot1 = "Soldier",
			Slot2 = "Empty",
			Slot3 = "Empty",
			Slot4 = "Empty",
			Slot5 = "Empty",
			Inventory = {}
		}
	end

	local playerInfonew = {
		Credits = playerInfo.Credits,
		Slot1 = playerInfo.Slot1,
		Slot2 = playerInfo.Slot2,
		Slot3 = playerInfo.Slot3,
		Slot4 = playerInfo.Slot4,
		Slot5 = playerInfo.Slot5,
		Inventory = playerInfo.Inventory
	}

	local success, errorMessage = pcall(function()
		data:SetAsync(player.UserId, playerInfo)
	end)
	if not success then
		print(errorMessage)
	end
end)