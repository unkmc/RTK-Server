drain_rogue = {
	cast = function(player, target)
		if not distanceSquare(player, target, 6) then
			player:sendMinitext("Target is too far away!")
			return
		end

		local magicCost = 60

		if not player:canCast(1, 1, 0) then
			return
		end
		if target:checkIfCast(venoms) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if player.magic < magicCost then
			return
		end

		if target.blType == BL_MOB and target.health <= 1000 then
			target.attacker = player.ID
			player:addHealthExtend(target.health, 0, 0, 0, 0, 0)
			player:sendAnimation(5, 5)
			target:sendAnimation(1, 5)
			target:removeHealthExtend(target.health, 0, 0, 0, 0, 0)
		end
	end,

	requirements = function(player)
		local level = 80
		local item = {"acorn", "dark_amber", 0}
		local amounts = {190, 10, 5000}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Drain will drain all animals/summons less than 1000 vita and give to you their remaining life. Cannot be cast on other players."
		return level, item, amounts, desc
	end
}

drink_of_souls_rogue = {
	cast = function(player, target)
		if not distanceSquare(player, target, 6) then
			player:sendMinitext("Target is too far away!")
			return
		end

		local magicCost = 60

		if not player:canCast(1, 1, 0) then
			return
		end
		if target:checkIfCast(venoms) then
			player:sendMinitext("It doesn't work.")
			return
		end
		if player.magic < magicCost then
			return
		end

		if target.blType == BL_MOB and target.health <= 1000 then
			target.attacker = player.ID
			player:addHealthExtend(target.health, 0, 0, 0, 0, 0)
			player:sendAnimation(5, 5)
			target:sendAnimation(1, 5)
			target:removeHealthExtend(target.health, 0, 0, 0, 0, 0)
		end
	end,

	requirements = function(player)
		local level = 80
		local item = {"acorn", "dark_amber", 0}
		local amounts = {190, 10, 5000}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Drain will drain all animals/summons less than 1000 vita and give to you their remaining life. Cannot be cast on other players."
		return level, item, amounts, desc
	end
}

parasite_rogue = {
	cast = function(player, target)
		if not distanceSquare(player, target, 6) then
			player:sendMinitext("Target is too far away!")
			return
		end

		local magicCost = 60

		if not player:canCast(1, 1, 0) then
			return
		end
		if target:checkIfCast(venoms) then
			player:sendMinitext("It doesn't work.")
			return
		end
		if player.magic < magicCost then
			return
		end

		if target.blType == BL_MOB and target.health <= 1000 then
			target.attacker = player.ID
			player:addHealthExtend(target.health, 0, 0, 0, 0, 0)
			player:sendAnimation(5, 5)
			target:sendAnimation(1, 5)
			target:removeHealthExtend(target.health, 0, 0, 0, 0, 0)
		end
	end,

	requirements = function(player)
		local level = 80
		local item = {"acorn", "dark_amber", 0}
		local amounts = {190, 10, 5000}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Drain will drain all animals/summons less than 1000 vita and give to you their remaining life. Cannot be cast on other players."
		return level, item, amounts, desc
	end
}

absorb_rogue = {
	cast = function(player, target)
		if not distanceSquare(player, target, 6) then
			player:sendMinitext("Target is too far away!")
			return
		end

		local magicCost = 60

		if not player:canCast(1, 1, 0) then
			return
		end
		if target:checkIfCast(venoms) then
			player:sendMinitext("It doesn't work.")
			return
		end
		if player.magic < magicCost then
			return
		end

		if target.blType == BL_MOB and target.health <= 1000 then
			target.attacker = player.ID
			player:addHealthExtend(target.health, 0, 0, 0, 0, 0)
			player:sendAnimation(5, 5)
			target:sendAnimation(1, 5)
			target:removeHealthExtend(target.health, 0, 0, 0, 0, 0)
		end
	end,

	requirements = function(player)
		local level = 80
		local item = {"acorn", "dark_amber", 0}
		local amounts = {190, 10, 5000}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Drain will drain all animals/summons less than 1000 vita and give to you their remaining life. Cannot be cast on other players."
		return level, item, amounts, desc
	end
}
