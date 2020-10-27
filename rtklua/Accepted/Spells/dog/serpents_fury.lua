serpents_fury = {
	cast = function(player)
		local magic = 800
		if not player:canCast(1, 1, 0) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		if (player.rage > 1) then
			player:sendMinitext("This spell is already active.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(4)
		player:setDuration("serpents_fury", 625000)
		player:setAether("serpents_fury", 25000)
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
		local level = 80
		local items = {"whisper_bracelet"}
		local itemAmounts = {1}
		local description = "Increases your weapon damage x4."
		return level, items, itemAmounts, description
	end
}
