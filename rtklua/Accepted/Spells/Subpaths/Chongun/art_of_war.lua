art_of_war = {
	cast = function(player, target)
		--[[
Art of war is a class taught by chonguns. 4 lessons with HW assignments. pass exam and you get Rp mark

"Trained the Art of War, by XXXX"

]]
		--
		local magic = 80
		if (not player:canCast(0, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if target.blType == BL_MOB then
			player:sendHealth(target.name .. " Max Health: " .. target.maxHealth)
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {"lean_beef", "ambrosia", 0}
		local itemAmounts = {20, 1, 25000}
		local description = "Attain mastery with a weapon."
		return level, items, itemAmounts, description
	end
}
