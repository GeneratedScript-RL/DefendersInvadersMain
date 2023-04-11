
local module = require(script.Parent.TroopsScript)
local Troops = game.ServerStorage.Troops

game.ReplicatedStorage.Spawntower.OnServerEvent:Connect(function(player, Troop)
	if Troops:FindFirstChild(Troop) then
		
		local cash = player.Cash.Value
		
		if cash >= module.TroopsStats[Troop].HireCost then
			
			player.Cash.Value -= module.TroopsStats[Troop].HireCost
			
			local troopnew = Troops[Troop]:Clone()
			
			troopnew:WaitForChild("HumanoidRootPart").Position = workspace.SpawnTroops.Position
			troopnew.Parent = workspace.Troops
			
		end
		
	end
	
end)

workspace:WaitForChild("Troops").ChildAdded:Connect(function(child)
	module[child.Name](child)
end)

function findtroopByValue(val)
	for i, v in pairs(workspace.Troops:GetChildren()) do
		if v:FindFirstChild("TroopId").Value == val then
			return v
		end
	end
end

game.ReplicatedStorage.MoveRequest.OnServerEvent:Connect(function(player, Table, Pos)
	for _, troopVal in ipairs(Table) do
		findtroopByValue(troopVal):FindFirstChild("IsMoving").Value = true
		findtroopByValue(troopVal):WaitForChild("HumanoidRootPart").CFrame = CFrame.lookAt(findtroopByValue(troopVal):WaitForChild("HumanoidRootPart").Position, Pos)
		findtroopByValue(troopVal):WaitForChild("Humanoid"):MoveTo(Pos + Vector3.new(0, findtroopByValue(troopVal):WaitForChild("HumanoidRootPart").Position.Y, 0))
		
		findtroopByValue(troopVal):WaitForChild("Humanoid").MoveToFinished:Connect(function()
			findtroopByValue(troopVal):FindFirstChild("IsMoving").Value = false
			
			game.ReplicatedStorage.MoveRequest:FireClient(player, findtroopByValue(troopVal))
			for i,v in pairs(findtroopByValue(troopVal).Humanoid:GetPlayingAnimationTracks()) do
				v:Stop()
			end
		end)
		
	end
end)