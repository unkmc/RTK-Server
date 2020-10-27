confuse_mage = {
	cast = function(player, target)
		local magicCost = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			return
		end

		if target.blType == BL_MOB then
			target:setDuration("confuse_mage", 20000)
			target:sendAnimation(39, 5)

			local mobs = target:getObjectsInSameMap(BL_MOB)

			if #mobs > 0 then
				local i = 1
				while i <= #mobs do
					if mobs[i].ID == target.ID or not distanceSquare(target, mobs[i], 10) then
						table.remove(mobs, i)
						i = i - 1
					end
					i = i + 1
				end

				if #mobs > 0 then
					local rand = math.random(1, #mobs)

					target.confused = true

					local oldTarget = target:getBlock(target.target)
					local newTarget = target:getBlock(mobs[rand].ID)

					target.target = newTarget.ID
					target.attacker = newTarget.ID
					target:setThreat(oldTarget.ID, 0)
					target.target = newTarget.ID

					local threat = threat.getHighestThreat(oldTarget)
					oldTarget:setThreat(newTarget.ID, 100)
				end
			end

			player:sendAction(6, 25)
			player.magic = player.magic - magicCost
			player:sendStatus()
		end
	end,

	uncast = function(mob)
		mob.confused = false
		mob.confusedTarget = 0
	end,

	requirements = function(player)
		local level = 65
		local item = {Item("amber").id, Item("deaths_head").id, 0}
		local amounts = {2, 1, 600}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Causes animals to attack each other. Can be cast on players but has no effect."
		return level, item, amounts, desc
	end
}
curse_of_the_void_mage = {
	cast = function(player, target)
		local magicCost = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			return
		end

		if target.blType == BL_MOB then
			target:setDuration("curse_of_the_void_mage", 20000)
			target:sendAnimation(39, 5)

			local mobs = target:getObjectsInSameMap(BL_MOB)

			if #mobs > 0 then
				local i = 1
				while i <= #mobs do
					if mobs[i].ID == target.ID or not distanceSquare(target, mobs[i], 10) then
						table.remove(mobs, i)
						i = i - 1
					end
					i = i + 1
				end

				if #mobs > 0 then
					local rand = math.random(1, #mobs)

					target.confused = true

					local oldTarget = target:getBlock(target.target)
					local newTarget = target:getBlock(mobs[rand].ID)

					target.target = newTarget.ID
					target.attacker = newTarget.ID
					target:setThreat(oldTarget.ID, 0)
					target.target = newTarget.ID

					local threat = threat.getHighestThreat(oldTarget)
					oldTarget:setThreat(newTarget.ID, 100)
				end
			end

			player:sendAction(6, 25)
			player.magic = player.magic - magicCost
			player:sendStatus()
		end
	end,

	uncast = function(mob)
		mob.confused = false
		mob.confusedTarget = 0
	end,

	requirements = function(player)
		local level = 65
		local item = {Item("amber").id, Item("deaths_head").id, 0}
		local amounts = {2, 1, 600}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Causes animals to attack each other. Can be cast on players but has no effect."
		return level, item, amounts, desc
	end
}
despise_friend_mage = {
	cast = function(player, target)
		local magicCost = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			return
		end

		if target.blType == BL_MOB then
			target:setDuration("despise_friend_mage", 20000)
			target:sendAnimation(39, 5)

			local mobs = target:getObjectsInSameMap(BL_MOB)

			if #mobs > 0 then
				local i = 1
				while i <= #mobs do
					if mobs[i].ID == target.ID or not distanceSquare(target, mobs[i], 10) then
						table.remove(mobs, i)
						i = i - 1
					end
					i = i + 1
				end

				if #mobs > 0 then
					local rand = math.random(1, #mobs)

					target.confused = true

					local oldTarget = target:getBlock(target.target)
					local newTarget = target:getBlock(mobs[rand].ID)

					target.target = newTarget.ID
					target.attacker = newTarget.ID
					target:setThreat(oldTarget.ID, 0)
					target.target = newTarget.ID

					local threat = threat.getHighestThreat(oldTarget)
					oldTarget:setThreat(newTarget.ID, 100)
				end
			end

			player:sendAction(6, 25)
			player.magic = player.magic - magicCost
			player:sendStatus()
		end
	end,

	uncast = function(mob)
		mob.confused = false
		mob.confusedTarget = 0
	end,

	requirements = function(player)
		local level = 65
		local item = {Item("amber").id, Item("deaths_head").id, 0}
		local amounts = {2, 1, 600}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Causes animals to attack each other. Can be cast on players but has no effect."
		return level, item, amounts, desc
	end
}
chaos_rain_mage = {
	cast = function(player, target)
		local magicCost = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			return
		end

		if target.blType == BL_MOB then
			target:setDuration("chaos_rain_mage", 20000)
			target:sendAnimation(39, 5)

			local mobs = target:getObjectsInSameMap(BL_MOB)

			if #mobs > 0 then
				local i = 1
				while i <= #mobs do
					if mobs[i].ID == target.ID or not distanceSquare(target, mobs[i], 10) then
						table.remove(mobs, i)
						i = i - 1
					end
					i = i + 1
				end

				if #mobs > 0 then
					local rand = math.random(1, #mobs)

					target.confused = true

					local oldTarget = target:getBlock(target.target)
					local newTarget = target:getBlock(mobs[rand].ID)

					target.target = newTarget.ID
					target.attacker = newTarget.ID
					target:setThreat(oldTarget.ID, 0)
					target.target = newTarget.ID

					local threat = threat.getHighestThreat(oldTarget)
					oldTarget:setThreat(newTarget.ID, 100)
				end
			end

			player:sendAction(6, 25)
			player.magic = player.magic - magicCost
			player:sendStatus()
		end
	end,

	uncast = function(mob)
		mob.confused = false
		mob.confusedTarget = 0
	end,

	requirements = function(player)
		local level = 65
		local item = {Item("amber").id, Item("deaths_head").id, 0}
		local amounts = {2, 1, 600}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Causes animals to attack each other. Can be cast on players but has no effect."
		return level, item, amounts, desc
	end
}
