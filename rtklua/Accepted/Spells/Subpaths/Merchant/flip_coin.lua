flip_coin = {
	cast = function(player, target)
		local magic = 1000 + player.maxMagic *.01
		player:sendAction(6, 35)

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < player.maxMagic *.025) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		player.magic = player.magic - magic

		local rand = math.random(1, 2)
		if (rand == 1) then
			player:setAether("lethal_strike_rogue", 0)
			player:setAether("afterlifes_embrace_rogue", 0)
			player:setAether("mingkens_judgement_rogue", 0)
			player:setAether("calculating_blow_rogue", 0)
			player:sendMinitext("Your lucky day! :)")
			player:talk(2, "It's my lucky day!")
			player:playSound(85)
			player:sendAnimation(11)
		else
			player:sendMinitext("No luck :{")
		end
		player:setAether("flip_coin", 45000)
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {1000}
		local description = "A simple game of chance."
		return level, items, itemAmounts, description
	end
}
