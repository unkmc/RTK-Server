hailstorm = {
	cast = function(player, target)
		local magicCost = 190
		local anim = 26

		local damage = 1000 + (player.level * 3) + math.floor(((player.will + 1) / 2) * 3)

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 190

		player:sendStatus()
		player:sendMinitext("You cast Hailstorm.")
		player:sendAction(6, 35)

		if target.blType == BL_MOB then
			target:sendAnimation(anim)
			target.attacker = player.ID
			target:removeHealthExtend(damage, 1, 1, 1, 1, 0)
		elseif target.blType == BL_PC and player:canPK(target) then
			target:sendAnimation(anim)
			target.attacker = player.ID
			target:removeHealthExtend(damage, 1, 1, 1, 1, 0)
		end

		local targets = getTargetsAround(target, BL_ALL)

		if #targets > 0 then
			for i = 1, #targets do
				if targets[i].blType == BL_MOB then
					targets[i]:sendAnimation(anim)
					targets[i].attacker = player.ID
					targets[i]:removeHealthExtend(damage, 1, 1, 1, 1, 0)
				elseif targets[i].blType == BL_PC and player:canPK(targets[i]) then
					targets[i]:sendAnimation(anim)
					targets[i].attacker = player.ID
					targets[i]:removeHealthExtend(damage, 1, 1, 1, 1, 0)
					targets[i]:sendMinitext(player.name .. " casts Hailstorm on you.")
				end
			end
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
