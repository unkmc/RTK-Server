forgive = {
	cast = async(function(player, target)
		-- TODO:   fix legend mark to say "Has been forgiven x times, recently by xxxx"

		local karma = target.karma
		player.npcGraphic = 0
		player.npcColor = 0
		player.dialogType = 0
		player.lastClick = player.ID

		local magicCost = 0

		if (not player:canCast(0, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if not player:karmaCheck("dragon") then
			player:dialogSeq(
				{
					t,
					"Your soul is too impure restore karma. Improve your karma first."
				},
				0
			)
			return
		end

		local penalty = math.random() + 1
		local choice

		if karma <= -3 then
			-- snake karma
			if target.ID == player.ID then
				player:dialogSeq({t, "You cannot restore your own karma."}, 0)
				return
			end

			choice = player:menuSeq(
				"Are you sure you want to restore " .. player.name .. "'s karma? It will cost between 1 and 2 points of karma to do so.",
				{"Yes, I want to restore them.", "No, nevermind."},
				{}
			)

			if choice == 1 then
				--Yes
				player:removeKarma(penalty)
				target:sendAnimation(49)
				target.karma = 0
				target:sendMinitext("Your karma has been restored.")

				target.registry["been_forgiven"] = target.registry[
					"been_forgiven"
				] + 1

				if not target:hasLegend("been_forgiven") then
					target:addLegend(
						"Has been forgiven",
						"been_forgiven",
						12,
						128
					)
				else
					target:removeLegendbyName("been_forgiven")
					target:addLegend(
						"Has been forgiven " .. target.registry["been_forgiven"] .. " times",
						"been_forgiven",
						12,
						128
					)
				end

				player:dialogSeq(
					{t, target.name .. "'s karma has been restored to Cat."},
					0
				)
			elseif choice == 2 then
				-- No
				player:dialogSeq({t, "Very well."}, 0)
			end
		else
			player:dialogSeq(
				{t, target.name .. "'s karma is not Snake level."},
				0
			)
		end
	end),

	requirements = function(player)
		local level = 60
		local items = {Item("acorn").id, Item("light_fox_fur").id, 0}
		local itemAmounts = {70, 20, 50}
		local description = "4 way invisible blockade that surrounds the caster. Any mobs in one of those 4 spaces will be paralyzed until the barrier wears off."
		return level, items, itemAmounts, description
	end
}
