local module = {}
local enemies = workspace:WaitForChild("Enemies")
local debris = game:GetService("Debris")
local Animations = {
	Idle = game.ServerStorage.Animations.SoldierIdle,
	Walk = game.ServerStorage.Animations.SoldierWalk,
	Shoot = game.ServerStorage.Animations.SoldierShoot,
	ShootAc = game.ServerStorage.Animations.SoldierShootActive,
	Died = game.ServerStorage.Animations.Died
}

module.Troops = {
	"Soldier",
	"Pyro"
}

module.TroopsStats = {
	Soldier = {Attack = 2, Firerate = 0.3, Range = 30, HireCost = 150, Cost = "Free", Health = 10},
	Pyro = {Attack = 1, Firerate = 0.1, Range = 15, HireCost = 350, Cost = 300, Health = 5}
}

module.TroopLevels = {
	Soldier = 0,
	Pyro = 0
}

module.TroopLevelsStats = {
	Soldier = {
		Level1 = {Attack = 2, Firerate = 0.15, Range = 40, HireCost = 300, Cost = "Free", Health = 10},
		Level2 = {Attack = 5, Firerate = 0.15, Range = 40, HireCost = 1000, Cost = "Free", Health = 10},
		Level3 = {Attack = 5, Firerate = 0.15, Range = 40, HireCost = 2500, Cost = "Free", Health = 40},
		Level4 = {Attack = 20, Firerate = 0.1, Range = 80, HireCost = 10000, Cost = "Free", Health = 100}
	},
	Pyro = {
		Level1 = {Attack = 2, Firerate = 0.1, Range = 15, HireCost = 300, Cost = 300, Health = 10},
		Level2 = {Attack = 3, Firerate = 0.07, Range = 15, HireCost = 1000, Cost = 300, Health = 10},
		Level3 = {Attack = 5, Firerate = 0.05, Range = 15, HireCost = 2500, Cost = 300, Health = 15},
		Level4 = {Attack = 10, Firerate = 0.04, Range = 15, HireCost = 10000, Cost = 300, Health = 30}
	}
}

module.Upgrade = function(Troop, Player)
	if module.TroopLevelsStats[Troop]["Level"..module.TroopLevels[Troop]+1] then

		if Player.Cash.Value >= module.TroopLevelsStats[Troop]["Level"..module.TroopLevels[Troop]+1].HireCost then

			module.TroopsStats[Troop] = module.TroopLevelsStats[Troop]["Level"..module.TroopLevels[Troop]+1]
			Player.Cash.Value -= module.TroopLevelsStats[Troop]["Level"..module.TroopLevels[Troop]+1].HireCost

			module.TroopLevels[Troop] = module.TroopLevels[Troop]+1

		end

	end
end


function CreateBullet(startP, endP, troop)
	local Part = Instance.new("Part", troop)
	Part.Position = (startP + endP)/2 
	Part.CFrame = CFrame.lookAt(Part.Position, endP)
	Part.Size = Vector3.new(0.1,0.1,(startP - endP).Magnitude)
	Part.CanCollide = false
	Part.Anchored = true
	Part.BrickColor = BrickColor.Yellow()
	Part.Material = "Neon"
	Part.Name = "Bullet"
	
	debris:AddItem(Part, 0.07)
	
end

function StopAnims(hum)
	for i,v in pairs(hum:GetPlayingAnimationTracks()) do
		v:Stop()
	end
end

module.Soldier = function(troop)
	
	local closestTargetMag = math.huge
	local THum = troop:WaitForChild("Humanoid")
	local THRP = troop:WaitForChild("HumanoidRootPart")
	
	local TroopId = Instance.new("NumberValue")
	TroopId.Name = "TroopId"
	TroopId.Value = #workspace.Troops:GetChildren()
	TroopId.Parent = troop
	
	local IsMoving = Instance.new("BoolValue")
	IsMoving.Name = "IsMoving"
	IsMoving.Value = false
	IsMoving.Parent = troop
	
	local IdleAnim = THum:LoadAnimation(Animations.Idle)
	local WalkAnim = THum:LoadAnimation(Animations.Walk)
	local ShootAnim = THum:LoadAnimation(Animations.Shoot)
	local shootanimActive = THum:LoadAnimation(Animations.ShootAc)
	local died = THum:LoadAnimation(Animations.Died)
	local isplayings = false
	local isplayingw = false
	local canshoot = true
	local hasTargetInRange = false
	local currTarget = nil
	local TargetFound = false
	local hasDied = false
	
	IdleAnim:Play()
	
	THum.Died:Connect(function()
		THum.Parent:Destroy()
	end)
	
	IsMoving:GetPropertyChangedSignal("Value"):Connect(function()
		if IsMoving.Value == true then
			canshoot = false
			isplayingw = true
			StopAnims(THum)
			WalkAnim:Play()
		elseif IsMoving.Value == false then
			canshoot = true
			StopAnims(THum)	
			wait()
			
			if TargetFound == true then
				ShootAnim:Play()
			else
				IdleAnim:Play()
			end
			
		end
	end)
	
	while wait(module.TroopsStats.Soldier.Firerate) do
		
		if THum.Health > 0 then
			if THum.MaxHealth == THum.Health then
				THum.MaxHealth = module.TroopsStats.Soldier.Health
				THum.Health = THum.MaxHealth
			else
				THum.MaxHealth = module.TroopsStats.Soldier.Health
			end

			if currTarget then 
				if currTarget:FindFirstChild("Humanoid") then else
					closestTargetMag =  math.huge
				end
			else
				closestTargetMag =  math.huge
			end

			local foundtarget2 = false
			for i, enems in pairs(enemies:GetChildren()) do
				local EHRP = enems:WaitForChild("HumanoidRootPart")
				local EHUM = enems:WaitForChild("Humanoid")
				local mag = (EHRP.Position - THRP.Position).Magnitude


				if mag <= module.TroopsStats.Soldier.Range then
					if mag < closestTargetMag or enems == currTarget and EHUM.Health > 0 then
						TargetFound = true
						foundtarget2 = true
						if canshoot == true then
							closestTargetMag = mag
							currTarget = enems

							CreateBullet(troop:WaitForChild("Gun").Shoot.Position, EHRP.Position, troop)
							local hptempt = EHUM.Health

							if (hptempt - module.TroopsStats.Soldier.Attack) < 1 then
								currTarget = nil
								closestTargetMag = math.huge
							end

							EHUM:TakeDamage(module.TroopsStats.Soldier.Attack)
							THRP.CFrame = CFrame.lookAt(THRP.Position, EHRP.Position)
							shootanimActive:Play()
							ShootAnim:Play()
							isplayings = true
						end
					end
				end
			end
			TargetFound = foundtarget2

			if foundtarget2 == false then
				currTarget = nil
				if canshoot == true then
					IdleAnim:Play()
				end
			end
		end
		
	end
end

module.Pyro = function(troop)
	
	local closestTargetMag = math.huge
	local THum = troop:WaitForChild("Humanoid")
	local THRP = troop:WaitForChild("HumanoidRootPart")

	local TroopId = Instance.new("NumberValue")
	TroopId.Name = "TroopId"
	TroopId.Value = #workspace.Troops:GetChildren()
	TroopId.Parent = troop

	local IsMoving = Instance.new("BoolValue")
	IsMoving.Name = "IsMoving"
	IsMoving.Value = false
	IsMoving.Parent = troop

	local WalkAnim = THum:LoadAnimation(Animations.Walk)
	local ShootAnim = THum:LoadAnimation(Animations.Shoot)
	local isplayings = false
	local isplayingw = false
	local canshoot = true
	local hasTargetInRange = false
	local currTarget = nil
	local TargetFound = false
	local hasDied = false

	ShootAnim:Play()

	THum.Died:Connect(function()
		THum.Parent:Destroy()
	end)

	IsMoving:GetPropertyChangedSignal("Value"):Connect(function()
		if IsMoving.Value == true then
			canshoot = false
			isplayingw = true
			StopAnims(THum)
			WalkAnim:Play()
		elseif IsMoving.Value == false then
			canshoot = true
			StopAnims(THum)	
			wait()

			ShootAnim:Play()
			isplayings = true

		end
	end)

	while wait(module.TroopsStats.Pyro.Firerate) do
		if THum.Health > 0 then
			if THum.MaxHealth == THum.Health then
				THum.MaxHealth = module.TroopsStats.Pyro.Health
				THum.Health = THum.MaxHealth
			else
				THum.MaxHealth = module.TroopsStats.Pyro.Health
			end

			if currTarget then 
				if currTarget:FindFirstChild("Humanoid") then else
					closestTargetMag =  math.huge
				end
			else
				closestTargetMag =  math.huge
			end

			local foundtarget2 = false
			for i, enems in pairs(enemies:GetChildren()) do
				local EHRP = enems:WaitForChild("HumanoidRootPart")
				local EHUM = enems:WaitForChild("Humanoid")
				local mag = (EHRP.Position - THRP.Position).Magnitude


				if mag <= module.TroopsStats.Pyro.Range then
					troop.Flamethrower.Handle.Part.ParticleEmitter.Transparency = NumberSequence.new(0)
					if mag < closestTargetMag or enems == currTarget and EHUM.Health > 0 then
						TargetFound = true
						foundtarget2 = true
						if canshoot == true then
							closestTargetMag = mag
							currTarget = enems
							local hptempt = EHUM.Health

							if (hptempt - module.TroopsStats.Pyro.Attack) < 1 then
								currTarget = nil
								closestTargetMag = math.huge
							end

							EHUM:TakeDamage(module.TroopsStats.Pyro.Attack)
							THRP.CFrame = CFrame.lookAt(THRP.Position, EHRP.Position)
						end
					end
				end
			end
			TargetFound = foundtarget2

			if foundtarget2 == false then
				currTarget = nil
				troop.Flamethrower.Handle.Part.ParticleEmitter.Transparency = NumberSequence.new(1)
				if canshoot == true then
					ShootAnim:Play()
				end
			end
			
		end
	
	end
	
end

return module
