local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SelectionPart = ReplicatedStorage:WaitForChild("SelectionPart")
local SelectedTroops = {}
local connections = {}
local RS = game:GetService("RunService")

function findtroopByValue(val)
	for i, v in pairs(workspace.Troops:GetChildren()) do
		if v:FindFirstChild("TroopId").Value == val then
			return v
		end
	end
end

function MoveTroops()
	ReplicatedStorage:WaitForChild("MoveRequest"):FireServer(SelectedTroops, mouse.Hit.Position)
	
	for _, troopVal in ipairs(SelectedTroops) do
		findtroopByValue(troopVal):WaitForChild("HumanoidRootPart").CFrame = CFrame.lookAt(findtroopByValue(troopVal):WaitForChild("HumanoidRootPart").Position, mouse.Hit.Position)
	end
	
end

function DestroySP()
	for i, v in pairs(workspace.Troops:GetChildren()) do
		if v:FindFirstChild("SelectionPart") then
			v:FindFirstChild("SelectionPart"):Destroy()
		end
	end
end

UIS.InputBegan:Connect(function(input)
	local connection
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		
		local ClickedOn = mouse.Target
		
		if ClickedOn and ClickedOn.Parent then
			if ClickedOn.Parent:FindFirstChild("Humanoid") then
				if ClickedOn.Parent.Parent.Name == workspace.Troops.Name then
					if table.find(SelectedTroops, ClickedOn.Parent:FindFirstChild("TroopId").Value) then else
						local HRP = ClickedOn.Parent:WaitForChild("HumanoidRootPart")

						local SP = SelectionPart:Clone()

						SP.Parent = ClickedOn.Parent
						SP.CFrame = HRP.CFrame * CFrame.new(0, -2, 0) * CFrame.Angles(0, math.rad(90), math.rad(90))

						connection = RS.Heartbeat:Connect(function()
							SP.CFrame = HRP.CFrame * CFrame.new(0, -2, 0) * CFrame.Angles(0, math.rad(90), math.rad(90))
						end)
						table.insert(connections, connection)
						
						
						table.insert(SelectedTroops, HRP.Parent:FindFirstChild("TroopId").Value)
					end
				else
					for i, v in ipairs(connections) do
						v:Disconnect()
					end
					MoveTroops()
					SelectedTroops = {}
					DestroySP()
				end
			else
				for i, v in ipairs(connections) do
					v:Disconnect()
				end
				MoveTroops()
				SelectedTroops = {}
				DestroySP()
			end
		end
	end
end)

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Q then
		for i, v in ipairs(connections) do
			v:Disconnect()
		end
		SelectedTroops = {}
		DestroySP()
	end
end)