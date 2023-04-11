local template = game.ReplicatedStorage:WaitForChild("Template")
local upRem = game.ReplicatedStorage:WaitForChild("Upgrade")
local player = game.Players.LocalPlayer
local hasAddedSol = false
local hasAddedPyro = false

local tls = {
	Soldier = {
		Level1 = {Attack = 2, Firerate = 0.15, Range = 40, HireCost = 300, Cost = "Free", Health = 10},
		Level2 = {Attack = 5, Firerate = 0.15, Range = 40, HireCost = 1000, Cost = "Free", Health = 10},
		Level3 = {Attack = 5, Firerate = 0.15, Range = 40, HireCost = 2500, Cost = "Free", Health = 40},
		Level4 = {Attack = 20, Firerate = 0.1, Range = 80, HireCost = 10000, Cost = "Free", Health = 100}
	},
	Pyro = {
		Level1 = {Attack = 2, Firerate = 0.1, Range = 15, HireCost = 300, Cost = 300, Health = 10},
		Level2 = {Attack = 3, Firerate = 0.07, Range = 20, HireCost = 1000, Cost = 300, Health = 10},
		Level3 = {Attack = 5, Firerate = 0.05, Range = 30, HireCost = 2500, Cost = 300, Health = 15},
		Level4 = {Attack = 10, Firerate = 0.04, Range = 55, HireCost = 10000, Cost = 300, Health = 30}
	}
}

local tl = {
	Soldier = 0,
	Pyro = 0
}

workspace.Troops.ChildAdded:Connect(function(child)
	if script.Parent.Frame.ScrollingFrame:FindFirstChild(child.Name) then else
		local newUpgradeOption = template:Clone()
		newUpgradeOption.Text = child.Name.." Upgrade - "..tls[child.Name]["Level"..tl[child.Name]+1].HireCost
		newUpgradeOption.Name = child.Name
		newUpgradeOption.Parent = script.Parent.Frame.ScrollingFrame

		newUpgradeOption.MouseButton1Down:Connect(function()
			upRem:FireServer(newUpgradeOption.Name)
			if tls[child.Name]["Level"..tl[child.Name]+1] then
				if player.Cash.Value >= tls[child.Name]["Level"..tl[child.Name]+1].HireCost then
					tl[child.Name] = tl[child.Name] + 1
					if tls[child.Name]["Level"..tl[child.Name]+1] then
						newUpgradeOption.Text = child.Name.." Upgrade - "..tls[child.Name]["Level"..tl[child.Name]+1].HireCost
					else
						newUpgradeOption.Text = child.Name.." Maxxed"
					end
				end
			end
		end)	
	end
end)

script.Parent.TextButton.MouseButton1Down:Connect(function()
	if script.Parent.Frame.Visible == true then
		script.Parent.Frame.Visible = false
	else
		script.Parent.Frame.Visible = true
	end
end)