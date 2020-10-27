master_weapon = {
	cast = function(player)
		local magic = 25000
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if player:checkIfCast(enchants) or player.enchant > 1 then
			player:sendMinitext("This spell is already active.")
			return
		end

		player:sendMinitext("Your weapon shines with holy light.")
		player.magic = player.magic - magic
		player.enchant = 20
		player:sendStatus()
		player:sendAction(6, 35)
	end,

	recast = function(player)
		player.enchant = 20
	end,
	uncast = function(player)
		player.enchant = 1
	end,
	requirements = function(player)
		local level = 99
		local items = {"ee_san_spike", "electra", "dragons_liver", 0}
		local itemAmounts = {1, 4, 4, 60000}
		local description = "Prepares your weapon for battle."
		return level, items, itemAmounts, description
	end
}
