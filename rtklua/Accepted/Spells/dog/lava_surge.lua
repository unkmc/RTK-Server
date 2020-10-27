lava_surge = {
	cast = function(player, target)
		local spellName = "Lava Surge"
		local damage = 400
		local x = {0, -1, 0, 1, 0}
		local y = {0, 0, -1, 0, 1}

		if not player:canCast(1, 1, 0) then
			return
		end
		if (player.magic < 210) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 210
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
		local level = 80
		local items = {"star_staff", "tao_stone"}
		local itemAmounts = {1, 1}
		local description = "Blast your enemy with a powerful eruption of lava."
		return level, items, itemAmounts, description
	end
}
