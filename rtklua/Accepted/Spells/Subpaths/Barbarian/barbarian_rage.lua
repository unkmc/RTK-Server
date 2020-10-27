barbarian_rage = {
	cast = function(player)
		local magic = 90
		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if player:checkIfCast(lesserFuries) or player.rage > 1 then
			player:sendMinitext("This spell is already active.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(4)
		player:sendMinitext("You cast Barbarian rage.")
		player:setDuration("barbarian_rage", 625000)
		player:sendAnimation(11)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 3
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 99
		local items = {"spike", "dragons_liver", "electra", 0}
		local itemAmounts = {1, 1, 1, 20000}
		local description = "Increase your fighting ability."
		return level, items, itemAmounts, description
	end
}
