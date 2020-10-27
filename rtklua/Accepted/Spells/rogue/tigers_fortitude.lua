tigers_fortitude_rogue = {
	cast = function(player)
		local weap = player:getEquippedItem(EQ_WEAP)

		if not player:canCast(1, 1, 0) then
			return
		end

		if player:checkIfCast(enchants) or player.enchant > 1 then
			player:sendMinitext("This spell is already active.")
			return
		end

		player:sendAction(6, 35)
		player:sendMinitext(weap.name .. " shines with holy light.")
		player.enchant = 1.5
		player:sendStatus()
	end,
	recast = function(player)
		player.enchant = 1.5
		player:sendStatus()
	end,
	uncast = function(player)
		player.enchant = 1
		player:sendStatus()
		player:sendMinitext("The glimmer subsides into a throb and then vanishes.")
	end,
	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {300000}
		local description = "Infuse your weapon with energy, causing you to deal more damage."
		return level, items, itemAmounts, description
	end
}
