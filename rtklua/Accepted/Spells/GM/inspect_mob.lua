inspect_mob_gm = {
	cast = function(player, target)
		if target.blType == BL_MOB then
			if target.target ~= 0 then
				local focus = player:getBlock(target.target)
				target:talk(0, focus.name .. " (" .. target.target .. ")")
			else
				target:talk(0, "no target (" .. target.target .. ")")
			end

			player:sendMinitext("Target: " .. target.name .. "(" .. target.ID .. ") [" .. target.yname .. "] (" .. target.mobType .. "]")
			player:sendMinitext(" - Vita: [" .. target.health .. "/" .. target.maxHealth .. "]")
			player:sendMinitext(" - Mana: [" .. target.magic .. "/" .. target.maxMagic .. "]")
			player:sendMinitext(" Armor: " .. target.armor .. "(" .. target.protection .. ")")
			player:sendMinitext(" DMG: " .. target.minDam .. "/" .. target.maxDam .. " (" .. target.hit .. ") [M:" .. target.might .. " W:" .. target.will .. " G:" .. target.grace .. "]")
			player:sendMinitext(" Look: [" .. target.look .. "] Color: (" .. target.lookColor .. ")")
			player:sendMinitext(" starting map: " .. target.startM)
		elseif target.blType == BL_PC then
		end
	end,

	requirements = function(player)
		local level = 100
		local items = {"sa_san_war_axe", 0}
		local itemAmounts = {100, 1000000}
		local description = "Judge an opponent's strength."
		return level, items, itemAmounts, description
	end
}
