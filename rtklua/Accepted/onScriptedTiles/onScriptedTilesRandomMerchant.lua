onScriptedTilesRandomMerchant = function(player)
	if (player.mapTitle == "Kugnae" or player.mapTitle == "Buya") then
		local x, y = player.x, player.y

		local chance = 10000
		local foundMerchant = false
		local roll = math.random(1, chance)
		if roll == 1 then
			foundMerchant = true
		end

		if foundMerchant then
			player:freeAsync()
			RandomMerchantNpc.click(player, NPC("Random Merchant"))
		end
	end
end
