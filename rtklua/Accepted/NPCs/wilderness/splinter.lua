local _waypointId = "splinter"

SplinterNpc = {
	click = async(function(player, npc)
		Tools.configureDialog(player, npc)

		local opts = {
			"Buy",
			"Sell",
			"Crafting Skills",
			"Gathering Wood",
			"Don't Knock Woodworking",
			"Woodworking Devotion"
		}

		if (not Waypoint.isEnabled(player, _waypointId)) then
			table.insert(opts, "Waypoint")
		end

		local menu = player:menuString(
			"Hello! What would you like to do today?",
			opts
		)

		if menu == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				SplinterNpc.buyItems()
			)
		elseif menu == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				SplinterNpc.sellItems()
			)
		elseif menu == "Crafting Skills" then
			generalNPC.crafting_skills(player, npc)
		elseif menu == "Gathering Wood" then
			player:dialogSeq(
				{
					"Yup, I know about that. Go to a place with trees and hack at 'em with your axe.",
					"Sometimes you'll find stuff. You should find a 'grove' to cut lumber in. There are a few around in the different forests.",
					"For example, there's one near Buya at 46, 20 and one near Kugnae at 111, 178. I doubt you'll have much luck lumbering outside of the groves."
				},
				0
			)
			return
		elseif menu == "Don't Knock Woodworking" then
			player:dialogSeq(
				{
					"A fine skill. Sure, you can make any armor, or those so-called 'superior' metal weapons. But we woodworkers are much more versatile.",
					"Woodworking allows you to make wooden weapons and arrows. Also, woodworking is needed to make weaving tools. When you're ready, just tell me 'wood'.",
					"If you do poor work, you'll end up with wood scraps. Show them to me, ask me about 'scraps' and we'll see what we can salvage."
				},
				0
			)
			return
		elseif menu == "Woodworking Devotion" then
			SplinterNpc.woodworkingDevotion(player, npc)
		elseif menu == "Waypoint" then
			Waypoint.add(player, npc, _waypointId)
		end
	end),

	woodworkingDevotion = function(player, npc)
		Tools.configureDialog(player, npc)

		if (player.level < 25) then
			player:dialogSeq({"You are not ready to devote to a craft yet, come back later."}, 0)
			return
		end

		if crafting.checkSkillLegend(player, "woodworking") then
			player:dialogSeq({"You have already devoted yourself to the study of Woodworking."}, 0)
			return
		end

		crafting.checkSkill(player, npc, "jewelry making")
		crafting.checkSkill(player, npc, "tailoring")
		crafting.checkSkill(player, npc, "metalworking")

		player:dialogSeq({"Woodworkers can make wooden weapons, bows, arrows, and weaving tools. Do you wish to become a woodworker?"}, 1)

		crafting.addSkill(player, npc, "woodworking")
	end,

	buyItems = function()
		local buyItems = {"axe"}
		return buyItems
	end,

	sellItems = function()
		local sellItems = {
			"axe",
			"ginko_wood",
			"weaving_tools",
			"fine_weaving_tools",
			"spring_quiver",
			"summer_quiver",
			"wooden_sword",
			"viperhead_woodsaber",
			"viperhead_woodsword",
			"wooden_blade",
			"supple_wooden_sword",
			"supple_viperhead_woodsaber",
			"supple_viperhead_woodsword",
			"supple_wooden_blade",
			"oaken_sword",
			"supple_oaken_sword",
			"oaken_blade",
			"supple_oaken_blade"
		}
		return sellItems
	end,

	onSayClick = async(function(player, npc)
		Tools.configureDialog(player, npc)
		local speech = string.lower(player.speech)

		if speech == "wood" or speech == "scrap" or speech == "scraps" then
			crafting.craftingDialog(player, npc, speech)
		end

		if (speech == "waypoint" and not Waypoint.isEnabled(player, _waypointId)) then
			Waypoint.add(player, npc, _waypointId)
			return
		end
	end),
}
