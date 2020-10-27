white_amber = {
	on_drop = function(player, item)
		if player.mapTitle ~= "Mythic Nexus" then
			return
		end

		if (player.x >= 28 and player.x <= 32 and player.y >= 30 and player.y <= 35) and not player:hasLegend("blessed_by_the_stars") then
			-- cloud & swirly graphic
			-- "Energy from the stars fills your body."
			-- "The white amber is absorbed in a flash of light."
			-- add legend "Was blessed by the stars (year, season)

			player:removeItem("white_amber", 1)
			player.fakeDrop = 1
			player:sendAnimation(18, 5)
			player:sendAnimation(11, 5)
			player:sendMinitext("Energy from the stars fills your body.")
			player:sendMinitext("The white amber is absorbed in a flash of light")

			player:addLegend(
				"Was blessed by the stars (" .. curT() .. ")",
				"blessed_by_the_stars",
				3,
				128
			)
		end
	end
}
