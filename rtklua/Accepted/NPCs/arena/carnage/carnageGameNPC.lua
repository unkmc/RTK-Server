CarnageGameNpc = {
	click = async(function(player, npc)
		local opts = {"Send me back"}

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts
		)

		if choice == "Send me back" then
			if player.state == 1 then
				--dead

				player.state = 0
				player.disguise = 0
				player.speed = 90
				player:calcStat()
				player.health = player.maxHealth
				player.magic = player.maxMagic
				player:flushDuration(1)
				player:updateState()

				if (player.gfxDye == 63) then
					player:warp(3010, 4, 20)
				elseif (player.gfxDye == 60) then
					player:warp(3010, 20, 20)
				elseif (player.gfxDye == 61) then
					player:warp(3010, 12, 20)
				elseif (player.gfxDye == 66) then
					player:warp(3010, 28, 20)
				end
			else
				local confirm = player:menuSeq(
					"You are abandoning your team! Are you sure you wish to leave?",
					{"Yes", "No"},
					{}
				)

				if confirm == 1 then
					player.state = 0
					player.disguise = 0
					player.speed = 90
					player:calcStat()
					player.health = player.maxHealth
					player.magic = player.maxMagic
					player:flushDuration(1)
					player:updateState()

					if (player.gfxDye == 63) then
						player:warp(3010, 4, 20)
					elseif (player.gfxDye == 60) then
						player:warp(3010, 20, 20)
					elseif (player.gfxDye == 61) then
						player:warp(3010, 12, 20)
					elseif (player.gfxDye == 66) then
						player:warp(3010, 28, 20)
					end
				end
			end
		end
	end),

	buyItems = function(npc)
		local buyItems = {"bears_liver", "antler", "herb_pipe"}

		return buyItems
	end,

	sellItems = function(npc)
		local buyItems = CarnageHallShopNpc.buyItems(npc)
		return buyItems
	end
}
