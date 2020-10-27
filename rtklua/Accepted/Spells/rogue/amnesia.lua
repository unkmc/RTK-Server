amnesia_rogue = {
	cast = function(player, target)
		local duration = 60000 * 15

		-- 15 mins
		local magicCost = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			return
		end

		if target.blType == BL_MOB then
			if target.isBoss == 1 then
				duration = 5000
			end

			player:sendAction(6, 35)
			target:sendAnimation(39, 5)
			target:setDuration("amnesia_rogue", duration)
			player:sendMinitext("You cast Amnesia on " .. target.name)

			target.amnesia = player.ID
			target.attacker = player.ID
		end
	end,

	while_cast = function(mob)
		if mob.target == mob.amnesia then
			local target = Player(mob.amnesia)
			if target ~= nil then
				target:setThreat(mob.ID, 0)
				threat.calcHighestThreat(mob)
				mob.target = 0
				mob.attacker = 0
				mob.state = MOB_ALIVE
			end
		end
	end,

	on_takedamage_while_cast = function(mob, attacker)
		if mob.attacker == mob.amnesia then
			mob:removeDuras(amnesias)
		end
	end,

	uncast = function(mob)
		if mob.amnesia ~= 0 then
			local target = Player(mob.amnesia)

			if target ~= nil then
				target:setThreat(mob.ID, 100)
			end
		end
	end,

	requirements = function(player)
		local level = 43
		local item = {"acorn", "fox_fur", "lucky_coin", 0}
		local amounts = {50, 20, 1, 1200}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Cast Amnesia on your target to make them attack someone else"
		return level, item, amounts, desc
	end
}

forgetfulness_rogue = {
	cast = function(player, target)
		local duration = 60000 * 15

		-- 15 mins
		local magicCost = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			return
		end

		if target.blType == BL_MOB then
			if target.isBoss == 1 then
				duration = 5000
			end

			player:sendAction(6, 35)
			target:sendAnimation(39, 5)
			target:setDuration("forgetfulness_rogue", duration)
			player:sendMinitext("You cast Forgetfulness on " .. target.name)

			target.amnesia = player.ID
			target.attacker = player.ID
		end
	end,

	while_cast = function(mob)
		if mob.target == mob.amnesia then
			local target = Player(mob.amnesia)
			if target ~= nil then
				target:setThreat(mob.ID, 0)
				threat.calcHighestThreat(mob)
				mob.target = 0
				mob.attacker = 0
				mob.state = MOB_ALIVE
			end
		end
	end,

	on_takedamage_while_cast = function(mob, attacker)
		if mob.attacker == mob.amnesia then
			mob:removeDuras(amnesias)
		end
	end,

	uncast = function(mob)
		if mob.amnesia ~= 0 then
			local target = Player(mob.amnesia)

			if target ~= nil then
				target:setThreat(mob.ID, 100)
			end
		end
	end,

	requirements = function(player)
		local level = 43
		local item = {"acorn", "fox_fur", "lucky_coin", 0}
		local amounts = {50, 20, 1, 1200}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Cast Amnesia on your target to make them attack someone else"
		return level, item, amounts, desc
	end
}

free_spirit_rogue = {
	cast = function(player, target)
		local duration = 60000 * 15

		-- 15 mins
		local magicCost = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			return
		end

		if target.blType == BL_MOB then
			if target.isBoss == 1 then
				duration = 5000
			end

			player:sendAction(6, 35)
			target:sendAnimation(39, 5)
			target:setDuration("free_spirit_rogue", duration)
			player:sendMinitext("You cast Free spirit on " .. target.name)

			target.amnesia = player.ID
			target.attacker = player.ID
		end
	end,

	while_cast = function(mob)
		if mob.target == mob.amnesia then
			local target = Player(mob.amnesia)
			if target ~= nil then
				target:setThreat(mob.ID, 0)
				threat.calcHighestThreat(mob)
				mob.target = 0
				mob.attacker = 0
				mob.state = MOB_ALIVE
			end
		end
	end,

	on_takedamage_while_cast = function(mob, attacker)
		if mob.attacker == mob.amnesia then
			mob:removeDuras(amnesias)
		end
	end,

	uncast = function(mob)
		if mob.amnesia ~= 0 then
			local target = Player(mob.amnesia)

			if target ~= nil then
				target:setThreat(mob.ID, 100)
			end
		end
	end,

	requirements = function(player)
		local level = 43
		local item = {"acorn", "fox_fur", "lucky_coin", 0}
		local amounts = {50, 20, 1, 1200}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Cast Amnesia on your target to make them attack someone else"
		return level, item, amounts, desc
	end
}

mislead_rogue = {
	cast = function(player, target)
		local duration = 60000 * 15

		-- 15 mins
		local magicCost = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			return
		end

		if target.blType == BL_MOB then
			if target.isBoss == 1 then
				duration = 5000
			end

			player:sendAction(6, 35)
			target:sendAnimation(39, 5)
			target:setDuration("mislead_rogue", duration)
			player:sendMinitext("You cast Mislead on " .. target.name)

			target.amnesia = player.ID
			target.attacker = player.ID
		end
	end,

	while_cast = function(mob)
		if mob.target == mob.amnesia then
			local target = Player(mob.amnesia)
			if target ~= nil then
				target:setThreat(mob.ID, 0)
				threat.calcHighestThreat(mob)
				mob.target = 0
				mob.attacker = 0
				mob.state = MOB_ALIVE
			end
		end
	end,

	on_takedamage_while_cast = function(mob, attacker)
		if mob.attacker == mob.amnesia then
			mob:removeDuras(amnesias)
		end
	end,

	uncast = function(mob)
		if mob.amnesia ~= 0 then
			local target = Player(mob.amnesia)

			if target ~= nil then
				target:setThreat(mob.ID, 100)
			end
		end
	end,

	requirements = function(player)
		local level = 43
		local item = {"acorn", "fox_fur", "lucky_coin", 0}
		local amounts = {50, 20, 1, 1200}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Cast Amnesia on your target to make them attack someone else"
		return level, item, amounts, desc
	end
}
