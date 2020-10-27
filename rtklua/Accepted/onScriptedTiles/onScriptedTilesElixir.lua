onScriptedTilesElixir = function(player)
	if player.mapTitle == "Elixir Hall" then
		if player.y == 6 then
			local m = core.gameRegistry["elixirMap"]

			if player.registry["elixirTeam"] == 0 then
				player:warp(player.m, player.x, player.y + 5)
				player:sendMinitext("Not on an elixir team.")
				return
			end

			player.gfxWeap = 20000
			player.registry["elixir_arrows"] = 0
			player:updateState()
			elixir.warpToSidelines(player)
		end
	end

	if core.gameRegistry["elixirState"] > 0 then
		elixir.walk(player)
	end
end
