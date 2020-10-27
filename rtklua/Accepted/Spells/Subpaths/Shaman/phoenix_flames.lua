phoenix_flames = {
	-- tested with Harue Shaman, 141 will. 3080 dmg against rabbit AC = 100. Our damage matches 100%.
	cast = function(player)
		local magicCost = 880
		local anim = 8
		local aethers = 1000

		local damage = 1030 + (player.level * 3) + math.floor(((player.will + 1) / 2) * 3)

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - magicCost
		player:sendStatus()
		player:sendMinitext("You cast Phoenix flames.")
		player:setAether("phoenix_flame", aethers)

		local targets = getTargetsAround(player, BL_ALL)

		if #targets > 0 then
			for i = 1, #targets do
				if targets[i].blType == BL_PC or targets[i].blType == BL_MOB then
					if player:canPK(targets[i]) then
						targets[i]:sendAnimation(anim)
						targets[i].attacker = player.ID
						targets[i]:removeHealthExtend(damage, 1, 1, 1, 1, 0)
						targets[i]:sendMinitext(player.name .. " casts Hailstorm on you.")
					end
				end
			end
			player:sendAction(6, 35)
			player:playSound(1)
			player:playSound(708)
		end
	end,

	requirements = function(player)
		local level = 64
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {70, 1, 500}
		local description = "Strike your surroundings with a strong lightning attack."
		return level, items, itemAmounts, description
	end
}
