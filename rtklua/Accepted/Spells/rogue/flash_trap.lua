set_flash_trap = {
	cast = function(player)
		local magic = 320
		local aether = 20000
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if player:canPK(player) then
			player:setAether("set_flash_trap", aether)
		end

		player:addNPC(
			"FlashTrapNpc",
			player.m,
			player.x,
			player.y,
			2,
			0,
			0,
			player.ID
		)

		player.magic = player.magic - magic
		player:playSound(0)
		player:sendStatus()
		player:sendAction(6, 35)

		player:sendMinitext("You set a trap!")
	end,

	requirements = function(player)
		local level = 55
		local items = {"fine_rabbit_meat", 0}
		local itemAmounts = {1, 250}
		local description = "Set a flash trap."
		return level, items, itemAmounts, description
	end
}
