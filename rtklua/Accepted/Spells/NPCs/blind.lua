blind = {
	cast = function(player, target)
		local duration = 10000
		local magicCost = 300

		if player.blType == BL_PC then
			if (not player:canCast(1, 1, 0)) then
				return
			end

			if (player.magic < magicCost) then
				player:sendMinitext("Your will is too weak.")
				return
			end

			if (target.state == 1) then
				player:sendMinitext("That is no longer useful.")
				return
			end

			if (target.blType == BL_PC and not player:canPK(target)) then
				player:sendMinitext("You cannot attack that target.")
				return
			end

			if target:checkIfCast(blinds) then
				player:sendMinitext("Another spell of this type is in effect.")
				return
			end

			player:sendAction(6, 20)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:playSound(43)
			player:sendMinitext("You cast Blind.")
			player:sendMinitext("Calling Blind.")
		elseif player.blType == BL_MOB then
			if target:checkIfCast(blinds) then
				return
			end
		end

		if target.blType == BL_PC then
			target:sendMinitext(player.name .. " attacks you with Blind spell.")
		end

		target:setDuration("blind", duration)
		target.blind = true
		target:updateState()
	end,

	while_cast = function(block)
		block.blind = true
	end,

	--[[on_takedamage_while_cast = function(block)
	block:removeDuras(blinds)
end,]]
	--

	uncast = function(block)
		block.blind = false
		block:updateState()
	end
}
