barrier_poet = {
	cast = function(player)
		local magicCost = 0
		local duration = 22000
		local anim = 2

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if player:hasDuration("barrier_poet") then
			return
		end
		player:sendAction(6, 35)
		player:setDuration("barrier_poet", duration)
		player:sendAnimation(anim)
		player.magic = player.magic - magicCost
		player.snare = true
		player:sendStatus()

		-- scan those 4 spaces and set para on any mobs that are in those spaces

		local targets = getTargetsAround(player, BL_MOB)

		if #targets > 0 then
			for i = 1, #targets do
				targets[i].attacker = player.ID
				if not targets[i]:checkIfCast(snares) then
					targets[i]:setDuration("snare", duration)
				end
			end
		end
	end,

	uncast = function(player)
		player.snare = false
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 60
		local items = {Item("acorn").id, Item("light_fox_fur").id, 0}
		local itemAmounts = {70, 20, 50}
		local description = "4 way invisible blockade that surrounds the caster. Any mobs in one of those 4 spaces will be paralyzed until the barrier wears off."
		return level, items, itemAmounts, description
	end
}

spirit_barrier_poet = {
	cast = function(player)
		local magicCost = 0
		local duration = 22000
		local anim = 2

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if player:hasDuration("spirit_barrier_poet") then
			return
		end
		player:sendAction(6, 35)
		player:setDuration("spirit_barrier_poet", duration)
		player:sendAnimation(anim)
		player.magic = player.magic - magicCost
		player.snare = true
		player:sendStatus()

		-- scan those 4 spaces and set para on any mobs that are in those spaces

		local targets = getTargetsAround(player, BL_MOB)

		if #targets > 0 then
			for i = 1, #targets do
				targets[i].attacker = player.ID
				if not targets[i]:checkIfCast(snares) then
					targets[i]:setDuration("snare", duration)
				end
			end
		end
	end,

	uncast = function(player)
		player.snare = false
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 60
		local items = {Item("acorn").id, Item("light_fox_fur").id, 0}
		local itemAmounts = {70, 20, 50}
		local description = "4 way invisible blockade that surrounds the caster. Any mobs in one of those 4 spaces will be paralyzed until the barrier wears off."
		return level, items, itemAmounts, description
	end
}

life_barrier_poet = {
	cast = function(player)
		local magicCost = 0
		local duration = 22000
		local anim = 2

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if player:hasDuration("life_barrier_poet") == true then
			return
		end
		player:sendAction(6, 35)
		player:setDuration("life_barrier_poet", duration)
		player:sendAnimation(anim)
		player.magic = player.magic - magicCost
		player.snare = true
		player:sendStatus()

		-- scan those 4 spaces and set para on any mobs that are in those spaces

		local targets = getTargetsAround(player, BL_MOB)

		if #targets > 0 then
			for i = 1, #targets do
				targets[i].attacker = player.ID
				if not targets[i]:checkIfCast(snares) then
					targets[i]:setDuration("snare", duration)
				end
			end
		end
	end,

	uncast = function(player)
		player.snare = false
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 60
		local items = {Item("acorn").id, Item("light_fox_fur").id, 0}
		local itemAmounts = {70, 20, 50}
		local description = "4 way invisible blockade that surrounds the caster. Any mobs in one of those 4 spaces will be paralyzed until the barrier wears off."
		return level, items, itemAmounts, description
	end
}

balance_barrier_poet = {
	cast = function(player)
		local magicCost = 0
		local duration = 22000
		local anim = 2

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if player:hasDuration("balance_barrier_poet") == true then
			return
		end
		player:sendAction(6, 35)
		player:setDuration("balance_barrier_poet", duration)
		player:sendAnimation(anim)
		player.magic = player.magic - magicCost
		player.snare = true
		player:sendStatus()

		-- scan those 4 spaces and set para on any mobs that are in those spaces

		local targets = getTargetsAround(player, BL_MOB)

		if #targets > 0 then
			for i = 1, #targets do
				targets[i].attacker = player.ID
				if not targets[i]:checkIfCast(snares) then
					targets[i]:setDuration("snare", duration)
				end
			end
		end
	end,

	uncast = function(player)
		player.snare = false
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 60
		local items = {Item("acorn").id, Item("light_fox_fur").id, 0}
		local itemAmounts = {70, 20, 50}
		local description = "4 way invisible blockade that surrounds the caster. Any mobs in one of those 4 spaces will be paralyzed until the barrier wears off."
		return level, items, itemAmounts, description
	end
}
