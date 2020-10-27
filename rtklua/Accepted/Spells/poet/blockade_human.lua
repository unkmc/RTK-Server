blockade_human_poet = {
	cast = function(player)
		local magicCost = 300
		local duration = 22000
		local aethers = 56000

		if player.gmLevel == 99 then
			aethers = 0
		end

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local targets = getTargetsAround(player, BL_PC)

		if #targets > 0 then
			for i = 1, #targets do
				if player:canPK(targets[i]) then
					targets[i].attacker = player.ID
					if not targets[i]:checkIfCast(snares) then
						targets[i]:setDuration("snare", duration)
					end
				end
			end
		end

		player:sendAction(6, 35)
		player:setDuration("blockade_human_poet", duration)
		player:setAether("blockade_human_poet", aethers)
		player:sendAnimation(2)
		player.magic = player.magic - magicCost
		player.snare = true
		player:sendMinitext("You cast Blockade Human.")
		player:sendStatus()
	end,

	uncast = function(player)
		player.snare = false
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 75
		local items = {Item("acorn").id, Item("dark_amber").id, 0}
		local itemAmounts = {50, 1, 500}
		local description = "4 way invisible blockade that surrounds the caster. Any players in one of those 4 spaces will be paralyzed until the barrier wears off."
		return level, items, itemAmounts, description
	end
}

block_entry_poet = {
	cast = function(player)
		local magicCost = 300
		local duration = 22000
		local aethers = 56000

		if player.gmLevel == 99 then
			aethers = 0
		end

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local targets = getTargetsAround(player, BL_PC)

		if #targets > 0 then
			for i = 1, #targets do
				if player:canPK(targets[i]) then
					targets[i].attacker = player.ID
					if not targets[i]:checkIfCast(snares) then
						targets[i]:setDuration("snare", duration)
					end
				end
			end
		end

		player:sendAction(6, 35)
		player:setDuration("blockade_human_poet", duration)
		player:setAether("blockade_human_poet", aethers)
		player:sendAnimation(2)
		player.magic = player.magic - magicCost
		player.snare = true
		player:sendMinitext("You cast Blockade Human.")
		player:sendStatus()
	end,

	uncast = function(player)
		player.snare = false
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 75
		local items = {Item("acorn").id, Item("dark_amber").id, 0}
		local itemAmounts = {50, 1, 500}
		local description = "4 way invisible blockade that surrounds the caster. Any players in one of those 4 spaces will be paralyzed until the barrier wears off."
		return level, items, itemAmounts, description
	end
}

distance_self_poet = {
	cast = function(player)
		local magicCost = 300
		local duration = 22000
		local aethers = 56000

		if player.gmLevel == 99 then
			aethers = 0
		end

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local targets = getTargetsAround(player, BL_PC)

		if #targets > 0 then
			for i = 1, #targets do
				if player:canPK(targets[i]) then
					targets[i].attacker = player.ID
					if not targets[i]:checkIfCast(snares) then
						targets[i]:setDuration("snare", duration)
					end
				end
			end
		end

		player:sendAction(6, 35)
		player:setDuration("blockade_human_poet", duration)
		player:setAether("blockade_human_poet", aethers)
		player:sendAnimation(2)
		player.magic = player.magic - magicCost
		player.snare = true
		player:sendMinitext("You cast Blockade Human.")
		player:sendStatus()
	end,

	uncast = function(player)
		player.snare = false
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 75
		local items = {Item("acorn").id, Item("dark_amber").id, 0}
		local itemAmounts = {50, 1, 500}
		local description = "4 way invisible blockade that surrounds the caster. Any players in one of those 4 spaces will be paralyzed until the barrier wears off."
		return level, items, itemAmounts, description
	end
}

protect_sides_poet = {
	cast = function(player)
		local magicCost = 300
		local duration = 22000
		local aethers = 56000

		if player.gmLevel == 99 then
			aethers = 0
		end

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local targets = getTargetsAround(player, BL_PC)

		if #targets > 0 then
			for i = 1, #targets do
				if player:canPK(targets[i]) then
					targets[i].attacker = player.ID
					if not targets[i]:checkIfCast(snares) then
						targets[i]:setDuration("snare", duration)
					end
				end
			end
		end

		player:sendAction(6, 35)
		player:setDuration("blockade_human_poet", duration)
		player:setAether("blockade_human_poet", aethers)
		player:sendAnimation(2)
		player.magic = player.magic - magicCost
		player.snare = true
		player:sendMinitext("You cast Blockade Human.")
		player:sendStatus()
	end,

	uncast = function(player)
		player.snare = false
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 75
		local items = {Item("acorn").id, Item("dark_amber").id, 0}
		local itemAmounts = {50, 1, 500}
		local description = "4 way invisible blockade that surrounds the caster. Any players in one of those 4 spaces will be paralyzed until the barrier wears off."
		return level, items, itemAmounts, description
	end
}
