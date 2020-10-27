ki_strike = {
	cast = function(player, target)
		local magicCost = 250
		local anim = 122

		local aethers = 7000

		-- 7s

		local damage = 250 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 3)

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 250

		player:setAether("ki_strike", aethers)
		player:sendStatus()
		player:sendMinitext("You cast Ki strike.")
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
					targets[i]:sendMinitext(player.name .. " casts Ki strike on you.")
				end
			end
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {70, 1, 500}
		local description = "Strike your surroundings with a strong lightning attack."
		return level, items, itemAmounts, description
	end
}
