local _waypointId = "sel"

SelNpc = {
	click = async(function(player, npc)
		Tools.configureDialog(player, npc)

		local opts = {
			"Crafting Skills",
			"Facets of Gemcutting",
			"Gemcutting Specialization",
			"Jewelry Devotion"
		}

		if (not Waypoint.isEnabled(player, _waypointId)) then
			table.insert(opts, "Waypoint")
		end

		local menu = player:menuString(
			"Hello! What would you like to do today?",
			opts
		)

		if menu == "Crafting Skills" then
			generalNPC.crafting_skills(player, npc)
		elseif menu == "Facets of Gemcutting" then
			player:dialogSeq(
				{
					"Hi there. You want to learn about Gemcutting? Sure, I can tell you a bit more about that.",
					"Gemcutting is a manufacturing skill. You start with an amber and try to craft it into a pretty form.",
					"Sometimes, gemcutters make mistakes. An amber might become tarnished, and thus less valuable. On really bad days, the amber will be completely ruined.",
					"But a crafted amber sells for quite a bit more, so the risk of failure is well worth it. As with any skill, it takes a lot of work to become really good at.",
					"There are many kinds of ambers, though, and some take quite a bit of skill to craft."
				},
				0
			)
			return
		elseif menu == "Gemcutting Specialization" then
			SelNpc.gemcutting_specialization(player, npc)
		elseif menu == "Jewelry Devotion" then
			SelNpc.jewelryDevotion(player, npc)
		elseif menu == "Waypoint" then
			Waypoint.add(player, npc, _waypointId)
		end
	end),

	gemcutting_specialization = function(player, npc)
		Tools.configureDialog(player, npc)

		if crafting.checkSpecializationLegend(player, "gemcutting") then
			player:dialogSeq({"You have already specialized in Gemcutting."}, 0)
			return
		end

		crafting.checkSpecialization(player, npc, "smelting")
		crafting.checkSpecialization(player, npc, "weaving")

		player:dialogSeq({"Gemcutters refine rare stones. Do you want to specialize in gemcutting? ((You need to be specialized to become better than 'Accomplished.'))"}, 1)

		crafting.addSpecialization(player, npc, "gemcutting")
	end,

	jewelryDevotion = function(player, npc)
		Tools.configureDialog(player, npc)

		if (player.level < 25) then
			player:dialogSeq({"You are not ready to devote to a craft yet, come back later."}, 0)
			return
		end

		if crafting.checkSkillLegend(player, "jewelry making") then
			player:dialogSeq({"You have already devoted yourself to the study of Jewelry making."}, 0)
			return
		end

		crafting.checkSkill(player, npc, "woodworking")
		crafting.checkSkill(player, npc, "tailoring")
		crafting.checkSkill(player, npc, "metalworking")

		player:dialogSeq({"Jewelers can make beautiful pieces of jewelry from crafted ambers and gold. Do you wish to become a jeweler?"}, 1)

		crafting.addSkill(player, npc, "jewelry making")
	end,

	onSayClick = async(function(player, npc)
		Tools.configureDialog(player, npc)
		local speech = string.lower(player.speech)

		if (speech == "gem" or speech == "jewel") then
			crafting.craftingDialog(player, npc, speech)
			return
		end

		if (speech == "waypoint" and not Waypoint.isEnabled(player, _waypointId)) then
			Waypoint.add(player, npc, _waypointId)
			return
		end
	end),

	buyItems = function()
		local buyItems = {}

		local pclothes = {
			"spring_dress",
			"spring_blouse",
			"spring_skirt",
			"spring_gown"
		}
		local rclothes = {
			"summer_blouse",
			"autumn_blouse",
			"winter_blouse",
			"leather_blouse",
			"ancient_blouse",
			"earth_blouse"
		}
		local mdress = {
			"summer_dress",
			"autumn_dress",
			"winter_dress",
			"leather_dress",
			"ancient_dress",
			"earth_dress"
		}
		local mskirt = {
			"summer_skirt",
			"autumn_skirt",
			"winter_skirt",
			"leather_skirt",
			"heart_skirt",
			"earth_skirt"
		}
		local pdraperies = {
			"summer_gown",
			"autumn_gown",
			"winter_gown",
			"leather_gown",
			"ancient_gown",
			"earth_gown"
		}
		local oitems = {"wedding_dress"}

		for i = 1, #pclothes do
			table.insert(buyItems, pclothes[i])
		end
		for i = 1, #rclothes do
			table.insert(buyItems, rclothes[i])
		end
		for i = 1, #mdress do
			table.insert(buyItems, mdress[i])
		end
		for i = 1, #mskirt do
			table.insert(buyItems, mskirt[i])
		end
		for i = 1, #pdraperies do
			table.insert(buyItems, pdraperies[i])
		end
		for i = 1, #oitems do
			table.insert(buyItems, oitems[i])
		end

		return buyItems
	end,

	sellItems = function()
		local sellItems = SelNpc.buyItems()
		return sellItems
	end
}
