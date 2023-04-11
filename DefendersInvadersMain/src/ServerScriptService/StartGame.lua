local module = {}
local ds = game:GetService("DataStoreService")
local data = ds:GetDataStore("PlayerGameInfo")

local enemies = game.ServerStorage.Enemies

function waitnoenemies()
	repeat
		wait(1)
	until #workspace.Enemies:GetChildren() == 0
	workspace.CurrentWave.Value += 1
end

local EasyRewardCredits = 100
local MedRewardCredits = 300
local HardRewardCredits = 1000

module.SpawnEnemy = function(enemy, number)
	if enemies:FindFirstChild(enemy) then
		if number == 0 then
			local enemy = enemies[enemy]:Clone()
			enemy.HumanoidRootPart.Position = workspace.SpawnEnemy.Position + Vector3.new(math.random(1, 10), 0, math.random(1, 10))
			enemy.Parent = workspace.Enemies
		else
			repeat
				local enemy = enemies[enemy]:Clone()
				enemy.HumanoidRootPart.Position = workspace.SpawnEnemy.Position + Vector3.new(math.random(1, 10), 0, math.random(1, 10))
				enemy.Parent = workspace.Enemies
				number = number - 1
				wait(0.5)
			until number == 0
		end
	end
end

module.Easy = function()
	
	-- W1
	module.SpawnEnemy("V201", 4)
	waitnoenemies()
	
	-- W2
	 
	module.SpawnEnemy("V201", 7)
	waitnoenemies()
	
	--W3
	 
	module.SpawnEnemy("V201", 4)
	module.SpawnEnemy("V124", 2)
	waitnoenemies()
	
	--W4
	 
	module.SpawnEnemy("V201", 8)
	module.SpawnEnemy("V124", 3)
	waitnoenemies()
	
	--W5
	 
	module.SpawnEnemy("V124", 5)
	module.SpawnEnemy("V9", 1)
	waitnoenemies()
	
	--Finish & Rewards
	for i, player in pairs(game.Players:GetChildren()) do
		
		local playerInfo
		local success, err = pcall(function()
			playerInfo = data:GetAsync(player.UserId)
		end)
		if not playerInfo or type(playerInfo) == "table" then
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
			Credits = playerInfo.Credits+EasyRewardCredits,
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

		local ngui = game.ServerStorage.ScreenGui:Clone()
		ngui.Parent = player
		ngui.CoinsTxt.Text = "Earned: "..EasyRewardCredits.." Coins!"
		
	end
	
end

module.Medium = function()

end

module.Hard = function()

end

module.StartGame = function(diff)
	module[diff]()
end

return module
