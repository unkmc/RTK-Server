scroll_of_immortality = {
	use = function(player)
		if not player:canCast(1, 1, 0) then
			return
		end

		if player:checkIfCast(hardBodies) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		local armor = 0

		if player.armor < -80 then
			armor = -80
		elseif player.armor > 70 then
			armor = 70
		else
			armor = player.armor
		end

		local successRate = math.ceil((120 + armor) / 2)

		local random = math.random(1, 100)

		if random > successRate then
			player:sendMinitext("Something went wrong.")
			return
		end

		player:sendAction(6, 20)
		player:playSound(5)
		player:sendMinitext("You cast Harden Body.")
		player:setDuration("harden_body", 16000)
		player:sendAnimation(11, 3)

		player:removeItem("scroll_of_immortality", 1, 6)
	end
}
