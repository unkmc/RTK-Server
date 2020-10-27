hyun_moo_spite_poet = {
	cast = function(player, target)
		local spellName = "Hyun Moo Spite"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 3500
		local worked = global_zap.cast(player, target, damage, 600, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {"ee_san_charm", "fragile_rose", "frozen_spear", 0} -- @TODO: Maybe replace Frozen spear once you have an entry level Enchanted weapon figured out
		local itemAmounts = {1, 4, 4, 60000}
		local description = "A deadly elemental strike."
		return level, items, itemAmounts, description
	end
}
