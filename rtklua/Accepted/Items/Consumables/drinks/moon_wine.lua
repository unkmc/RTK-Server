moon_wine = {
	use = function(player)
		local mana = 80
		local health = 5

		if not player:canAction(1, 1, 1) then
			return
		end

		if player.state == 1 then
			player:sendMinitext("You need a physical body in order to eat.")
			return
		end

		player.attacker = player.ID
		player:sendAction(7, 20)
		player:addMana(100)
		player:removeHealthExtend(health, 0, 0, 0, 0, 0)
		player:playSound(22)
		player:sendStatus()
	end
}
