spot_traps = {
	cast = function(player)
		local magic = 100
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(0)
		player:setAether("spot_traps", 6000)
		seeSpotTraps(player)
		player:sendStatus()
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 60
		local items = {}
		local itemAmounts = {}
		local description = "Spot Traps on ground and marks them off as Steel daggers.  Daggers will remain on screen for as long as you want, but are not persistent upon logoff. This spell detects traps such as explosive, dart, and flash traps."
		return level, items, itemAmounts, description
	end
}
