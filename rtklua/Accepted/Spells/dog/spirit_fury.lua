spirit_fury = {
	cast = function(player)
		local magic = 500
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(furies)

		if (player.rage > 1) then
			player:sendMinitext("This spell is already active.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(4)
		player:setDuration("spirit_fury", 625000)
		player:sendAnimation(11)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 5
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 80
		local items = {"titanium_glove", 0}
		local itemAmounts = {1, 10000}
		local description = "Increases your weapon damage x5."
		return level, items, itemAmounts, description
	end
}
