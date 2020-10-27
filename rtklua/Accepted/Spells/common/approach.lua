approach_spell = {
	cast = function(player, question)
		local magic = 30
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		--local choice = player:input("Who would you like to approach?")

		local targetName = player:inputLetterCheck(player.question)

		local target = Player(targetName)

		local found = false

		if (target == nil) then
			player:sendMinitext("Fizzle.")
			return
		end

		if player.m == 666 then
			player:sendMinitext("Fizzle.")
			return
		end
		if player.ID == target.ID then
			player:sendMinitext("Fizzle.")
			return
		end
		if target.m == 1228 then
			player:sendMinitext("Fizzle.")
			return
		end
		if (target.canSummon == 0) then
			player:sendMinitext("Fizzle.")
			return
		end
		if (player.state == 1) then
			player:sendMinitext("Fizzle.")
			return
		end
		if (target.indoor == 1) then
			player:sendMinitext("Fizzle.")
			return
		end
		if (player.level < target.reqLvl) then
			player:sendMinitext("Fizzle.")
			return
		end
		if (player.level > target.maxLvl) then
			player:sendMinitext("Fizzle.")
			return
		end
		if (player.baseHealth < target.reqVita and player.baseMagic < target.reqMana) then
			player:sendMinitext("Fizzle.")
			return
		end
		if (player.baseHealth > target.maxVita or player.baseMagic > target.maxMana) then
			player:sendMinitext("Fizzle.")
			return
		end
		if player.warpOut == 0 then
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
		if target.m == 3010 or target.m == 3011 or target.m == 33 then
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
		player:sendStatus()
		player:sendAction(6, 35)
		player:playSound(4)
		player:sendAnimation(11)

		local m, x, y = target:getOpenCellApproach()
		player:warp(m, x, y)
	end,

	requirements = function(player)
		local level = 40
		local items = {"acorn", "fox_fur", 0}
		local itemAmounts = {100, 10, 100}
		local desc = "This spell is used to approach a group member."
		return level, items, itemAmounts, desc
	end
}
