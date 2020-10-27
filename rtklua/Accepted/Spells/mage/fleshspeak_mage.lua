fleshspeak_mage = {
	cast = function(player, target)
		local spellName = "Fleshspeak"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 50, 60, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 11
		local items = {
			Item("acorn").id,
			Item("rabbit_meat").id,
			Item("book").id,
			0
		}
		local itemAmounts = {10, 10, 1, 10}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}

spiritsong_mage = {
	cast = function(player, target)
		local spellName = "Spiritsong"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 50, 60, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 11
		local items = {
			Item("acorn").id,
			Item("rabbit_meat").id,
			Item("book").id,
			0
		}
		local itemAmounts = {10, 10, 1, 10}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}

helping_hand_mage = {
	cast = function(player, target)
		local spellName = "Helping Hand"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 50, 60, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 11
		local items = {
			Item("acorn").id,
			Item("rabbit_meat").id,
			Item("book").id,
			0
		}
		local itemAmounts = {10, 10, 1, 10}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}

heal_others_mage = {
	cast = function(player, target)
		local spellName = "Heal Others"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 50, 60, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 11
		local items = {
			Item("acorn").id,
			Item("rabbit_meat").id,
			Item("book").id,
			0
		}
		local itemAmounts = {10, 10, 1, 10}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}
