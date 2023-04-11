local hum = script.Parent.Parent.Parent.Humanoid

script.Parent.BFrame.MBar.TextLabel.Text = hum.Health.."/"..hum.MaxHealth
hum.HealthChanged:Connect(function(Damage)
	script.Parent.BFrame.MBar.TextLabel.Text = hum.Health.."/"..hum.MaxHealth
	script.Parent.BFrame.MBar.Size = UDim2.new(Damage / hum.MaxHealth, 0, 1, 0)
end)