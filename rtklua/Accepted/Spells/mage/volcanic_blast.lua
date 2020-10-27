volcanic_blast_mage = {
	cast = function(player, target)
		local spellName = "Volcanic Blast"

		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 971 + math.ceil(((player.will + 4) / 5) * 18.325)
		local x = {0, -1, 0, 1, 0}
		local y = {0, 0, -1, 0, 1}

		if (not player:canCast(0, 1, 0)) then
			return
		end
		if (player.magic < 120) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 120
		player:sendStatus()

		for i = 1, 5 do
			local hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_MOB
			)
			if #hits > 0 then
				global_zap.cast(player, hits[1], damage, 0, 35)
			end
			hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_PC
			)
			if #hits > 0 then
				local worked = global_zap.cast(player, hits[1], damage, 0, 35)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {600000}
		local description = "Rupture the ground beneath your foe."
		return level, items, itemAmounts, description
	end
}
