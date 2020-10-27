Backflow = {
	Cast = function(player, amount, startingHealth, startingMagic)
		if (amount < 1) then
				return
		end

		local healthBackflow = math.ceil(amount / 2)
		local magicBackflow = healthBackflow
		local healthBackflowCap = math.ceil(startingHealth / 2)
		local magicBackflowCap = math.ceil(startingMagic / 2)

		healthBackflow = math.min(healthBackflow, healthBackflowCap)
		magicBackflow = math.min(magicBackflow, magicBackflowCap)

		player.health = player.health + healthBackflow
		player.magic = player.magic + magicBackflow

		player.health = math.min(player.health, player.maxHealth)
		player.magic = math.min(player.magic, player.maxMagic)

		player:sendAnimation(11)
	end
}
