mass_resurrect = {
	cast = function(player)
		local magicCost = 15000
		local aethers = 15 * 60 * 1000

		-- 15 mins?

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:setAether("mass_resurrect", aethers)
		player.magic = player.magic - magicCost
		player:sendStatus()

		player:sendAction(6, 35)
		player:sendMinitext("You cast Mass resurrect.")

		local pcs = player:getObjectsInSameMap(BL_PC)

		if #pcs > 0 then
			for i = 1, #pcs do
				if pcs[i].state == 1 and not player:canPK(pcs[i]) then
					-- target must be dead and NOT in a PK zone.
					pcs[i].state = 0
					pcs[i].health = pcs[i].maxHealth
					pcs[i].magic = pcs[i].maxMagic
					pcs[i]:sendAnimation(11)
					pcs[i]:playSound(112)
					pcs[i]:updateState()
					pcs[i]:sendStatus()
					pcs[i]:sendMinitext(player.name .. " cast Mass resurrect on you.")
				end
			end
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {
			Item("acorn").id,
			Item("dark_amber").id,
			Item("red_potion").id,
			0
		}
		local itemAmounts = {200, 5, 2, 10000}
		local description = "Brings a dead player back to life at full health."
		return level, items, itemAmounts, description
	end
}
