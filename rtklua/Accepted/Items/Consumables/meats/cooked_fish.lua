cooked_fish = {
	use = function(player)
		local health = 20
		local partner

		local anim = 8

		if player.partner ~= 0 then
			partner = Player(player.partner)
		end

		if partner ~= nil then
			if partner.partner == player.ID and player.m == partner.m and distanceSquare(
				player,
				partner,
				0
			) then
				health = 900

				if player.x > partner.x then
					player.side = 3
					player:sendSide()
					partner.side = 1
					partner:sendSide()
				end
				if player.x < partner.x then
					player.side = 1
					player:sendSide()
					partner.side = 3
					partner:sendSide()
				end
				if player.y > partner.y then
					player.side = 0
					player:sendSide()
					partner.side = 2
					partner:sendSide()
				end
				if player.y < partner.y then
					player.side = 2
					player:sendSide()
					partner.side = 0
					partner:sendSide()
				end

				player:sendAction(24, 400)
				partner:sendAction(24, 400)

				player.attacker = player.ID
				player:addHealthExtend(health, 0, 0, 0, 0, 0)

				if player.health == player.maxHealth then
					player:sendMinitext("You feel satiated.")
				end

				partner.attacker = partner.ID
				partner:addHealthExtend(health, 0, 0, 0, 0, 0)

				if partner.health == partner.maxHealth then
					partner:sendMinitext("You feel satiated.")
				end

				return
			end
		else
			player:sendAction(8, 25)
			player.attacker = player.ID
			player:addHealthExtend(health, 0, 0, 0, 0, 0)

			if player.health == player.maxHealth then
				player:sendMinitext("You feel satiated.")
			end
		end
	end
}
