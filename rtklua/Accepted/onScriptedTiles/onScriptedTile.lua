onScriptedTile = function(player)
	-- on walk exp counter resets to 0 (used to catch botters automatically)
	--local start = os.time()*1000+timeMS()
	--local expCounter = player.registry["expCounter"]
	--expCounter = expCounter - math.random(3,8)
	--if expCounter < 0 then expCounter = 0 end
	--player.registry["expCounter"] = expCounter

	onSign(player, 2)

	onScriptedTilesQuest(player)
	onScriptedTilesNagnangShieldQuest(player)
	onScriptedTilesMap(player)
	onScriptedTilesBushTree(player)
	onScriptedTilesKanShop(player)
	onScriptedTilesRandomMerchant(player)
	onScriptedTilesArena(player)
	onScriptedTilesElixir(player)
	onScriptedTilesCarnage(player)
	onScriptedTilesPathHalls(player)
	onScriptedTilesTutorsHaven(player)
	onScriptedTilesMythic(player)
	onScriptedTilesMythicFallRooms(player)
	onScriptedTilesSubpath(player)
	onScriptedTilesSubpathCircle(player)
	onScriptedTilesMarket(player)

	--onScriptedTilesJadeCitadel(player)

	onWalk(player)

	--broadcast(4,"Scripted Tile: "..(os.time()*1000+timeMS())-start)
end
