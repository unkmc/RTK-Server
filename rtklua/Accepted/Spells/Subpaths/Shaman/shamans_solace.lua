shamans_solace = {
	-- spell function verified, spell reqs need verified

	cast = function(player, target)
		local magicCost = 600
		local heal = 2200

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if not distanceSquare(player, target, 10) then
			return
		end

		-- maximum 10 tiles away in either direction (verified on NTK)

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("You need a different type of cure.")
			return
		end

		player:sendAction(6, 35)
		player.magic = player.magic - magicCost
		player:sendStatus()

		player:playSound(708)
		target:sendAnimation(5, 25)
		player:sendMinitext("You cast Shaman's solace.")
		target:sendMinitext(player.name .. " cast Shaman's solace on you.")
		target.attacker = player.ID
		target:addHealthExtend(heal, 0, 0, 0, 0, 0)
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 10000}
		local description = "Heals a target for 2000."
		return level, items, itemAmounts, description
	end
}
