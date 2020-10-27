thunder_bolt_mage = {
	cast = function(player, target)
		local spellName = "Thunder Bolt"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.floor(player.level / 2)
		local worked = global_zap.cast(player, target, damage, 5, 10)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 5
		local items = {Item("acorn").id, Item("rabbit_meat").id, 0}
		local itemAmounts = {10, 10, 50}
		local desc = "A basic elemental attack."
		return level, items, itemAmounts, desc
	end
}
