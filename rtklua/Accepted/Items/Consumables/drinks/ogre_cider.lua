ogre_cider = {
	use = function(player)
		local mana = 100
		local health = 10

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

ogre_drought = {
	use = function(player)
		local mana = 325
		local health = 25

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
