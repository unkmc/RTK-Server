bow = {
	checkEquip = function(player)
		local val = false
		local bow, quiver = player:getEquippedItem(EQ_WEAP), player:getEquippedItem(EQ_SHIELD)

		if bow ~= nil and bow.thrown then
			if quiver ~= nil and quiver.thrown then
				val = true
			end
		end
		return val
	end,

	thrown = function(player)
		local weap, quiver = player:getEquippedItem(EQ_WEAP), player:getEquippedItem(EQ_SHIELD)
		local m, x, y, side = player.m, player.x, player.y, player.side
		local pc, mob, threat
		local damage = 0

		if player.registry["elixir_team"] > 0 and player.m == 15000 then
			elixir.shoot(player)
		else
			if weap ~= nil and weap.commonScript == "bow" then
				if quiver ~= nil and quiver.commonScript == "quiver" then
					player:playSound(716)
					player:bowShoot(8, player.side + 6, 0)
				else
					anim(player, "You don't have any arrow to shot")
				end
			end
		end
	end
}
