healers_revenge_poet = {
	cast = function(player, target)
		local spellName = "Healer's Revenge"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 800 + (player.level * 12) + math.ceil(((player.will + 1) / 2) * 12)
		local worked = global_zap.cast(player, target, damage, 300, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {
			Item("il_san_charm").id,
			Item("fragile_rose").id,
			Item("jolt_trident").id,
			0
		}
		local itemAmounts = {1, 2, 2, 40000}
		local description = "A powerful elemental strike."
		return level, items, itemAmounts, description
	end
}
