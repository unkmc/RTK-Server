wine = {
	use = function(player)
		local mana = 25
		local health = 5

		if not player:canAction(1, 1, 1) then
			return
		end

		if player.state == 1 then
			player:sendMinitext("Spirits can't do that.")
			return
		end

		player.attacker = player.ID
		player:sendAction(7, 20)
		player:addMana(mana)
		player:removeHealthExtend(health, 0, 0, 0, 0, 0)
		player:playSound(22)
		player:sendStatus()
	end
}

thick_wine = {
	use = function(player)
		local mana = 40
		local health = 5

		if not player:canAction(1, 1, 1) then
			return
		end

		if player.state == 1 then
			player:sendMinitext("Spirits can't do that.")
			return
		end

		player.attacker = player.ID
		player:sendAction(7, 20)
		player:addMana(mana)
		player:removeHealthExtend(health, 0, 0, 0, 0, 0)
		player:playSound(22)
		player:sendStatus()
	end
}

rice_wine = {
	use = function(player)
		local mana = 30

		if not player:canAction(1, 1, 1) then
			return
		end

		if player.state == 1 then
			player:sendMinitext("Spirits can't do that.")
			return
		end

		player.attacker = player.ID
		player:sendAction(7, 20)
		player:addMana(mana)
		player:playSound(22)
		player:sendStatus()
	end
}
