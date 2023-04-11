wait(3)

for i, v in pairs(workspace.Trees:GetDescendants()) do
	if v:IsA("BasePart") then
		v.CanCollide = false
	end
end