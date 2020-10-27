basic_sickle = {
	equip = function(player)
		local legend = crafting.checkSkillLegend(player, "farming")

		if legend == false then
			local t = {
				graphic = convertGraphic(NPC("SsalNpc").look, "monster"),
				color = NPC("SsalNpc").lookColor
			}
			player:dialogSeq(
				{
					t,
					"The crops outside must each be cut in a different way, I hope you can figure it out! "
				},
				1
			)
		end
	end

	--[[on_hit = function(player,target)

	if target.blType == BL_MOB then
                local yNames = {"bent_grain","tall_wheat","very_tall_wheat","damp_wheat"}
                local random = 0
                for i=1,#yNames do
                    if target.yname == yNames[i] then random = 1 end
                end
                if random == 0 then return end

                if target.owner == 0 then target.owner = player.ID end

                if target.owner ~= player.ID then return end

                local grass = { "It's very tall wheat!", "The rains were heavy.",
                                "Barely tall wheat...", "This grain is bent." }
                local message = grass[target.side+1]

                random = math.random(1,15)
                if (player.side ~= target.side) and random == 1 then
                        player:sendMinitext(message)
                end
                if random == 15 then random = math.random(1,15) end

                if random > 10 and (player.side == target.side) then
                     crafting.skillChanceIncrease(player,NPC("SsalNpc"),"farming")
                elseif random == 15 then
                     crafting.skillChanceIncrease(player,NPC("SsalNpc"),"farming")
                end

        end
	end]]
	--
}
