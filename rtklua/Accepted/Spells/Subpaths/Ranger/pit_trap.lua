set_pit_trap = {
	cast = function(player)
		local magic = 1000
		--local aethers = 625000
		local aethers = 45000 -- unused variable

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:addNPC(
			"pit_trap",
			player.m,
			player.x,
			player.y,
			2,
			1000,
			20000,
			player.ID
		)

		-- will lsat for 20s before expiration

		player.magic = player.magic - magic
		player:playSound(0)
		player:sendStatus()
		player:sendAction(6, 35)

		player:sendMinitext("You cast Pit trap.")

		-- it only says this msg there is no "you set a trap!" like normal trap spells
	end,

	requirements = function(player)
		local level = 99
		local items = {"fine_rabbit_meat", 0}
		local itemAmounts = {2, 350}
		local description = "Set a pit trap."
		return level, items, itemAmounts, description
	end
}
