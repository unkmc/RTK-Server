evaluate_opponent = {
	cast = function(player, target)
		local magic = 200

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if target.blType == BL_MOB then
			player:sendMinitext("[" .. target.name .. "] VIT: " .. target.maxHealth)
		end

		if target.blType == BL_PC then
			player:sendMinitext("[" .. target.classNameMark .. " " .. target.name .. "]")
			player:sendMinitext("VIT: " .. Tools.formatValue(target.health))
			player:sendMinitext("MANA: " .. Tools.formatValue(target.magic))
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {"red_fox_fur", "fine_rabbit_meat", "fox_blade", 0}
		local itemAmounts = {80, 5, 3, 5000}
		local description = "Judge an opponent's strength."
		return level, items, itemAmounts, description
	end
}
