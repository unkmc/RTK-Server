golden_fist = {
	cast = function(player)
		local magic = 90
		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if player:checkIfCast(lesserFuries) or player.rage > 1 then
			player:sendMinitext("This spell is already active.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(4)
		player:sendMinitext("You cast Golden fist.")
		player:setDuration("golden_fist", 625000)
		player:sendAnimation(11)
		player:sendAction(6, 35)
		player:calcStat()
	end,
	recast = function(player)
		player.rage = 4
		player:sendStatus()
	end,
	uncast = function(player)
		player.rage = 1
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 99
		local items = {"blood", "steelthorn", "magical_dust", 0}
		local itemAmounts = {1, 1, 1, 20000}
		local description = "Increase your fighting ability."
		return level, items, itemAmounts, description
	end
}
