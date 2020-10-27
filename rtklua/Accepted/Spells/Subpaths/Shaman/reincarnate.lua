reincarnate = {
	-- working 100% like ntk.. person brought back to life is returned with 5% health. 750s aethers, 10k cast.

	cast = function(player)
		local magicCost = 10000
		local anim = 96
		local aethers = 7500000

		if player.gmLevel > 0 then
			aethers = 0
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - magicCost
		player:sendStatus()
		player:sendMinitext("You cast Reincarnate.")
		player:setAether("reincarnate", aethers)

		local targets = getTargetsAround(player, BL_PC)

		if #targets > 0 then
			for i = 1, #targets do
				if targets[i].state == 1 then
					--dead
					targets[i]:sendAnimation(anim)
					targets[i].state = 0
					targets[i].health = math.floor(targets[i].maxHealth * 0.10)
					targets[i]:sendStatus()
					targets[i]:updateState()
					targets[i]:sendMinitext(player.name .. " casts Reincarnate on you.")
				end
			end
			player:sendAction(6, 35)
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
