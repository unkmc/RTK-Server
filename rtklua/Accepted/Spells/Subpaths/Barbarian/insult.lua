insult = {
	cast = function(player)
		local magicCost = 200
		local aethers = 150000
		local duration = 425000

		if player.gmLevel > 0 then
			aethers = 0
		end

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - magicCost
		player:sendStatus()

		player:sendAction(19, 25)
		player:sendMinitext("You cast Insult.")

		local targets = getTargetsAround(player, BL_ALL)

		if #targets > 0 then
			for i = 1, #targets do
				if targets[i].state == 1 then
					return
				end

				if targets[i].blType == BL_MOB then
					if not targets[i]:checkIfCast(curses) and targets[i].cursed == 0 and not targets[
						i
					]:checkIfCast(protections) then
						if targets[i]:hasDuration("snare_trap") then
							targets[i]:setDuration("snare_trap", 0)
						end
						targets[i]:sendAnimation(1)
						targets[i]:setDuration("insult", duration)
						targets[i].armor = target.armor + 30
						targets[i].cursed = 1
					end
				elseif targets[i].blType == BL_PC and player:canPK(targets[i]) then
					if not targets[i]:checkIfCast(curses) and targets[i].cursed == 0 and not targets[
						i
					]:checkIfCast(protections) then
						if targets[i]:hasDuration("snare_trap") then
							targets[i]:setDuration("snare_trap", 0)
						end
						targets[i]:sendAnimation(1)
						targets[i]:setDuration("insult", duration)
						targets[i]:sendMinitext(player.name .. " attacks you with Insult spell.")
						targets[i]:calcStat()
					end
				end
			end
		end
	end,

	while_cast = function(block)
		if (block.blType == BL_MOB and block.charState ~= 2) then
			block:sendAnimation(34, 0)
		elseif (block.blType == BL_PC and block.state ~= 2) then
			block:sendAnimation(34, 0)
		end
	end,
	recast = function(target)
		target.armor = target.armor + 30
		target.cursed = 1
		target:sendStatus()
	end,
	uncast = function(target)
		target.armor = target.armor - 30
		target.cursed = 0
		target:sendStatus()

		if target.blType == BL_PC then
			target:sendMinitext("Insult end.")
		end
	end,

	requirements = function(player)
		local level = 70
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {80, 2, 1000}
		local description = "Raises target +30 AC"
		return level, items, itemAmounts, description
	end
}
