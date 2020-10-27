greater_blessing = {
	cast = function(player)
		local magic = 60

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(blessings)

		player.magic = player.magic - magic
		player:setDuration("greater_blessing", 625000)

		-- we increased this to 625000 to match blessing and furies
		player.hit = player.hit + 4
		player:playSound(4)
		player:sendAnimation(2)
		player:sendStatus()
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.hit = player.hit + 4
		player:sendStatus()
	end,
	uncast = function(player)
		player.hit = player.hit - 4
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 60
		local items = {}
		local itemAmounts = {}
		local description = "Increases your chance to strike an enemy."
		return level, items, itemAmounts, description
	end
}
