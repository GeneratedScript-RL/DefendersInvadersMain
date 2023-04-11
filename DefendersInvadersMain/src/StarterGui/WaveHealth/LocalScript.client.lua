local Health = workspace:WaitForChild("Health")
local wave = 0
local selectedDiff = nil
local player = game.Players.LocalPlayer
wait(1)

script.Parent.RFRame.HFRame.Size = UDim2.new(1, 0, Health.Value/100, 0)

Health:GetPropertyChangedSignal("Value"):Connect(function()
	script.Parent.RFRame.HFRame.Size = UDim2.new(1, 0, Health.Value/100, 0)
end)

function TimerWait(seconds)
	task.spawn(function()
		local timetowait = seconds
		script.Parent.Timer.Text = timetowait
		repeat
			wait(1)
			timetowait = timetowait-1
			
			script.Parent.Timer.Text = timetowait
			
		until timetowait == 0
		script.Parent.Timer.Text = 0
		if selectedDiff == nil then
			game.ReplicatedStorage.SelectDifficulty:FireServer("Easy")
		else
			game.ReplicatedStorage.SelectDifficulty:FireServer(selectedDiff)
		end
		script.Parent.Timer:Destroy()
		script.Parent.Easy:Destroy()
		script.Parent.Hard:Destroy()
		script.Parent.Medium:Destroy()
	end)
end

for i, v in pairs(script.Parent:GetChildren()) do
	if v:IsA("TextButton") then
		v.MouseButton1Down:Connect(function()
			script.Parent.Easy:Destroy()
			script.Parent.Hard:Destroy()
			script.Parent.Medium:Destroy()
			
			selectedDiff = v.Name
			
		end)
	end
end

script.Parent.Cash.Text = player:WaitForChild("Cash").Value
player:WaitForChild("Cash"):GetPropertyChangedSignal("Value"):Connect(function()
	script.Parent.Cash.Text = player:WaitForChild("Cash").Value
end)

script.Parent.Wave.Text = "Wave "..workspace.CurrentWave.Value
workspace.CurrentWave:GetPropertyChangedSignal("Value"):Connect(function()
	script.Parent.Wave.Text = "Wave "..workspace.CurrentWave.Value
end)

TimerWait(10)