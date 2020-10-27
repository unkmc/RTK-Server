summon_spell = {
	cast = async(function(player, question)
		local magic = 30
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local targetName = player:inputLetterCheck(player.question)
		local target = Player(targetName)

		local failcheck = 0
		local found = false

		if (target == nil) then
			player:sendMinitext("Fizzle.")
			return
		end

		if target.m == 666 then
			player:sendMinitext("Fizzle.")
			return
		end
		if target.m == 4259 then
			player:sendMinitext("Fizzle.")
			return
		end
		if player.m >= 59000 or target.m >= 59000 then
			return
		end
		if player.ID == target.ID then
			player:sendMinitext("Fizzle.")
			return
		end
		if player.m == 1228 then
			player:sendMinitext("Fizzle.")
			return
		end
		if (player.canSummon == 0) then
			player:sendMinitext("Fizzle.")
			return
		end
		if (player.indoor == 1) then
			player:sendMinitext("Fizzle.")
			return
		end
		if target.mapTitle == "Buya Kan Shop" or target.mapTitle == "Kugnae Kan Shop" then
			player:sendMinitext("Fizzle.")
			return
		end
		if (target.state == 1) then
			player:sendMinitext("Fizzle.")
			return
		end
		if (target.level < player.reqLvl) then
			player:sendMinitext("Fizzle.")
			return
		end
		if (target.level > player.maxLvl) then
			player:sendMinitext("Fizzle.")
			return
		end
		if (target.baseHealth < player.reqVita and target.baseMagic < player.reqMana) then
			player:sendMinitext("Fizzle.")
			return
		end
		if (target.baseHealth > player.maxVita or target.baseMagic > player.maxMana) then
			player:sendMinitext("Fizzle.")
			return
		end
		if target.warpOut == 0 then
			player:sendMinitext("That does not work here.")
			return
		end
		if player.gmLevel == 0 and target.gmLevel ~= 0 then
			player:sendMinitext("Fizzle.")
			return
		end

		if player:canPK(target) then
			player:sendMinitext("Fizzle.")
			return
		end
		if player:canPK(player) then
			player:sendMinitext("Fizzle.")
			return
		end
		if player.m == 3010 or player.m == 3011 or player.m == 33 then
			player:sendMinitext("Fizzle.")
			return
		end
		if (player.m == 3042 or target.m == 3042) then
			player:sendMinitext("Fizzle.")
			return
		end
		if (player.m >= 3034 and player.m <= 3039) or (target.m >= 3034 and target.m <= 3039) then
			player:sendMinitext("Fizzle.")
			return
		end

		if #player.group > 1 then
			for i = 1, #player.group do
				if (target.ID == player.group[i]) then
					found = true
				end
			end
		else
			player:sendMinitext("Fizzle.")
			return
		end

		if not found then
			player:sendMinitext("Fizzle.")
			return
		end

		player.magic = player.magic - magic
		player:playSound(4)
		player:sendAnimation(11)
		player:sendStatus()
		player:sendAction(6, 35)

		local m, x, y = player:getOpenCellSummon()
		target:warp(m, x, y)
	end),

	requirements = function(player)
		local level = 50
		local items = {"acorn", 0}
		local itemAmounts = {100, 500}
		local desc = "This spell can be used to summon a group member to your location."
		return level, items, itemAmounts, desc
	end
}
