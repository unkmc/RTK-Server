baekhos_rage_rogue = {
	cast = function(player)
		local magic = 2000
		local duration = 188000
		if not player:canCast(1, 1, 0) then
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
		player.rage = 5
		player:playSound(4)
		player:setDuration("baekhos_rage_rogue", duration)
		player:sendAnimation(11)
		player:sendStatus()
		player:sendAction(6, 35)
	end,
	recast = function(player)
		player.rage = 5
	end,
	uncast = function(player)
		player.rage = 1
	end,
	requirements = function(player)
		local level = 99
		local items = {"il_san_blood", "flamefang", "magical_dust", 0}
		local itemAmounts = {1, 2, 2, 40000}
		local description = "Increases your weapon damage x5."
		return level, items, itemAmounts, description
	end
}
