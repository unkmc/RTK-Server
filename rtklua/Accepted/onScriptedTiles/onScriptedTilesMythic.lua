onScriptedTilesMythic = function(player)
	local map = player.m
	local x = player.x
	local y = player.y

	if (map ~= 41) then
		return
	end

	local mobName = nil

	if ((x == 49 or x == 50) and (y == 12)) then
		mobName = "Rabbit"
	elseif ((x == 43 or x == 44) and (y == 48)) then
		mobName = "Monkey"
	elseif ((x == 18 or x == 19) and (y == 25)) then
		mobName = "Dog"
	elseif ((x == 48 or x == 49) and (y == 30)) then
		mobName = "Rooster"
	elseif ((x == 9 or x == 10) and (y == 12)) then
		mobName = "Rat"
	elseif ((x == 15 or x == 16) and (y == 48)) then
		mobName = "Horse"
	elseif ((x == 29 or x == 30) and (y == 45)) then
		mobName = "Ox"
	elseif ((x == 17 or x == 18) and (y == 39)) then
		mobName = "Pig"
	elseif ((x == 40 or x == 41) and (y == 25)) then
		mobName = "Snake"
	elseif ((x == 41 or x == 42) and (y == 39)) then
		mobName = "Sheep"
	elseif ((x == 10 or x == 11) and (y == 30)) then
		mobName = "Tiger"
	elseif ((x == 29 or x == 30) and (y == 19)) then
		mobName = "Dragon"
	end

	if (mobName == nil) then
		return
	end

	local maxCaveLevel = player:mythicCaveReqCheck(mobName)
	player:freeAsync()
	MythicCaveSelector.click(player, mobName, maxCaveLevel)
end
