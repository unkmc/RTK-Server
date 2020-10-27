skill_up_merchant = {
	cast = function(player)
		if (not player:canCast(0, 1, 0)) then
			return
		end

		local duration = 938000
		local aethers = 150000
		local anim = 250

		if player.gmLevel ~= 0 then
			aethers = 0
		end

		player:removeDuras(lesserFuries)

		if (player:hasDuration("skill_up_merchant") == true and player.rage == 6) then
			-- cast cunning 2
			if (player.magic < 4711) then
				player:sendMinitext("You do not have enough mana.")
				return
			end
			player.rage = 7
			player.magic = player.magic - 4711
			player:setAether("skill_up_merchant", aethers)
			player:sendAnimation(anim)
			player:playSound(705)
			player:sendMinitext("[Skill up 2] You hone your skills.")
			player:sendAction(6, 35)
			player:sendStatus()
		elseif (player:hasDuration("skill_up_merchant") == true and player.rage == 7) then
			-- cast cunning 3
			if (player.magic < 17960) then
				player:sendMinitext("You do not have enough mana.")
				return
			end
			player.rage = 9
			player.magic = player.magic - 17960
			player:setAether("skill_up_merchant", aethers)
			player:sendAnimation(anim)
			player:playSound(705)
			player:sendMinitext("[Skill up 3] Agility becomes your strongest suit..")
			player:sendAction(6, 35)
			player:sendStatus()
		elseif (player:hasDuration("skill_up_merchant") == true and player.rage == 9) then
			-- cast cunning 4
			if (player.magic < 53646) then
				player:sendMinitext("You do not have enough mana.")
				return
			end
			player.rage = 10
			player.magic = player.magic - 53646
			player:setAether("skill_up_merchant", aethers)
			player:sendAnimation(anim)
			player:playSound(705)
			player:sendMinitext("[Skill up 4] Acquiring cat-like reflex.")
			player:sendAction(6, 35)
			player:sendStatus()
		elseif (player:hasDuration("skill_up_merchant") == true and player.rage == 10) then
			-- cast cunning 5
			if (player.magic < 135327) then
				player:sendMinitext("You do not have enough mana.")
				return
			end
			player.rage = 12
			player.magic = player.magic - 135327
			player:setAether("skill_up_merchant", aethers)
			player:sendAnimation(anim)
			player:playSound(705)
			player:sendMinitext("[Skill up 5] Incredible skill!")
			player:sendAction(6, 35)
			player:sendStatus()
		elseif (player:hasDuration("skill_up_merchant") == true and player.rage == 12) then
			-- cast cunning 6 TESTING ONLY
			if (player.magic < 269420) then
				player:sendMinitext("You do not have enough mana.")
				return
			end
			player.rage = 14
			player.magic = player.magic - 269420
			player:setAether("skill_up_merchant", aethers)
			player:sendAnimation(anim)
			player:playSound(705)
			player:sendMinitext("[Skill up 6] Sagat would be jealous.")
			player:sendAction(6, 35)
			player:sendStatus()
		elseif (player:hasDuration("skill_up_merchant") == false) then
			if (player.magic < 3000) then
				player:sendMinitext("You do not have enough mana.")
				return
			end
			player:setDuration("tigers_fury_rogue", 0)
			player:setDuration("wolves_fury_rogue", 0)
			player:setDuration("dragons_fury_rogue", 0)
			player:setDuration("baekhos_rage", 0)
			player:setDuration("spirit_fury", 0)
			player.rage = 6
			player.magic = player.magic - 3000
			player:sendAnimation(anim)
			player:playSound(705)
			player:setDuration("skill_up_merchant", duration)
			player:setAether("skill_up_merchant", aethers)
			player:sendMinitext("[Skill up 1] Your senses sharpen.")
			player:sendAction(6, 35)
			player:sendStatus()
		else
			player:sendMinitext("You have reached your max potential.")
		end
	end,

	uncast = function(player)
		player.rage = 1
	end
}
