local UpRemote = game.ReplicatedStorage.Upgrade
local UpMod = require(game.ServerScriptService.TroopsScript)

UpRemote.OnServerEvent:Connect(function(player, Troop)
	UpMod.Upgrade(Troop, player)
end)