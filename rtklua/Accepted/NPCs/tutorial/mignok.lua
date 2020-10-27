MignokNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player:hasSpell("soothe") then
			player:dialogSeq({t, "You already have the spell Soothe."}, {})
			return
		end

		if (player:hasItem("acorn", 5) == true and player:hasItem("rabbit_meat", 5) == true) then
			player:dialogSeq(
				{
					t,
					"Thank you young one. You have shown me that you are of sound mind and conscience. I will teach you your first spell."
				},
				1
			)

			player:removeItem("acorn", 5, 9)
			player:removeItem("rabbit_meat", 5, 9)

			if (not player:hasSpell("soothe")) then
				player:addSpell("soothe")
				player:giveXP(50)
			end

			player:dialogSeq(
				{
					t,
					"Use this spell Soothe with great wisdom.",
					"Once you learn a spell you will be able to see it on your spell list ((Press + or click on the Spell tab to see this list)).",
					"((You will see that each of the spells will have a letter next to them. These letters will be important to remember when casting the spell.))",
					"((To cast a spell press shift z or Z and then the letter of the spell. You can also just double-click it.))",
					"As you grow, so will the amount you will be able to control the aethers, allowing you to cast more powerful spells. Some spells will consume a great deal of your energy, and you will need to allow the aethers around you to settle before you can cast them again.",
					"This is all I will teach you for now. Good luck young one and remember to use your spells wisely."
				},
				1
			)
			return
		end

		player:dialogSeq(
			{
				t,
				"The magical forces in this world are controlled by what are called aetheers. If you can learn to control and use them, you too will be able to harness the power of casting magical spells.",
				"If this is knowledge which you seek to attain, you must show me that your mind carries the diligence and patience required to control the aethers.",
				"Slay the creatures in this area to gather five acorns and five rabbit meat. Once you have done this, return to me and I will teach you."
			},
			1
		)
		if (player.registry["mignokexp"] == 0) then
			player:giveXP(15)
			player.registry["mignokexp"] = 1
		end
	end),

	move = function(npc, owner)
		--npc_ai.move(npc,owner)
	end
}
