local module = {}

function CreateBullet(startP, endP)
	
	local Part = Instance.new("Part", workspace)
	Part.Position = (startP + endP)/2 
	Part.CFrame = CFrame.lookAt(Part.Position, endP)
	Part.Size = Vector3.new(0.1,0.1,(startP - endP).Magnitude)
	Part.CanCollide = false
	Part.Anchored = true
	Part.BrickColor = BrickColor.Blue()
	Part.Material = "Neon"
	Part.Name = "Line"
	
end

return module
