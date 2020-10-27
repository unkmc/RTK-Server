iron_statue = {
	use = function(player)
		local item = player:getInventoryItem(player.invSlot)

		if not player:canAction(1, 1, 1) then
			return
		end

		if player.state == 1 then
			player:sendMinitext("You need a physical body in order to eat.")
			return
		end

		if item.dura > 0 then
			player.attacker = player.ID
			player:sendAction(7, 20)
			player:addMana(250)
			player:playSound(22)
			player:sendStatus()
		end
	end
}
