set_repeating_dart_trap = {
	cast = function(player)
		local magic = 120
		local duration = 10000
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if (player:hasDuration("set_repeating_dart_trap")) then
			return
		end

		player:setDuration("set_repeating_dart_trap", duration)

		player:addNPC(
			"RepeatingDartTrapNpc",
			player.m,
			player.x,
			player.y,
			2,
			1000,
			10000,
			player.ID
		)

		player.magic = player.magic - magic
		player:playSound(0)
		player:sendStatus()
		player:sendAction(6, 35)

		player:sendMinitext("You set a trap!")
	end,

	requirements = function(player)
		local level = 44
		local items = {"fine_rabbit_meat", 0}
		local itemAmounts = {2, 300}
		local description = "Set a repeating dart trap."
		return level, items, itemAmounts, description
	end
}
