second_life = {
	cast = function(player, target)
		-- Spell programmed and verified to be working 100% same as NTK

		local magicCost = 6000
		local aethers = 1250000

		-- 1250s

		if player.gmLevel ~= 0 then
			aethers = 0
		end

		if (not player:canCast(0, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:setAether("second_life", aethers)

		player:sendAction(6, 30)
		player.magic = player.magic - magicCost
		player:sendStatus()

		if player:canPK(target) then
			player:sendMinitext("You can't do that.")
			return
		end

		player:sendMinitext("You cast Second life.")

		if target.state == 1 then
			target.state = 0
			target:sendAnimation(18, 3)
			target.health = target.health + 600
			target:sendMinitext(player.name .. " cast Second life on you.")
			target:updateState()
		end
	end
}
