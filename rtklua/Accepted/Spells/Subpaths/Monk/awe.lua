awe = {
	cast = function(player)
		local aether = 125000
		local duration = 10000
		local magicCost = 2000

		if player.gmLevel ~= 0 then
			aether = 0
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:setAether("awe", aether)
		player:sendAction(6, 30)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(70)
		player:sendMinitext("You cast Awe.")

		local mobs = player:getObjectsInSameMap(BL_MOB)

		for i = 1, #mobs do
			if not mobs[i].paralyzed and distanceSquare(player, mobs[i], 10) then
				-- mob not paralyzed already and within -10,10 tiles
				mobs[i]:setDuration("awe", duration)
				mobs[i]:sendAnimation(11, 3)
				mobs[i].paralyzed = true
			end
		end
	end,

	uncast = function(target)
		target.paralyzed = false
	end,

	requirements = function(player)
		local level = 62
		local items = {Item("ambrosia").id, Item("antler").id, 0}
		local itemAmounts = {1, 20, 500}
		local description = "Room paralyze."
		return level, items, itemAmounts, description
	end
}
