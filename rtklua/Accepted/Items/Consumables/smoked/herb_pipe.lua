herb_pipe = {
	use = function(player)
		local mana = 1000
		local health = 15

		local item = player:getInventoryItem(player.invSlot)

		if not player:canAction(1, 0, 0) then
			return
		end

		if player.state == 1 then
			player:sendMinitext("Spirits can't do that.")
			return
		end

		if item.dura > 0 then
			player.attacker = player.ID
			if player.health - health < 0 then
				return
			end

			player:sendAction(7, 20)
			player:addMana(300)
			player:removeHealthExtend(health, 0, 0, 0, 0, 0)
			player:playSound(22)
			player:sendStatus()
		end
	end
}

sonhi_pipe = {
	use = function(player)
		local mana = 1000
		local health = 50

		local item = player:getInventoryItem(player.invSlot)

		if not player:canAction(1, 0, 0) then
			return
		end

		if player.state == 1 then
			player:sendMinitext("Spirits can't do that.")
			return
		end

		if item.dura > 0 then
			player.attacker = player.ID
			if player.health - health < 0 then
				return
			end
			player:sendAction(7, 20)
			player:addMana(450)
			player:removeHealthExtend(health, 0, 0, 0, 0, 0)
			player:playSound(22)
			player:sendStatus()
		end
	end
}
