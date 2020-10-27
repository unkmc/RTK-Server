local _getWaypointId = function(player, npc)
	local waypointIdByMap = {
		[1144] = "thane"
	}

	local waypointId = waypointIdByMap[npc.m]

	if (not waypointId) then
		return "kugnae"
	end

	return waypointId
end

SmithNpc = {
	click = async(function(player, npc)
		Tools.configureDialog(player, npc)

		local options = {
			"Buy",
			"Sell",
			"Fix Item",
			"Fix All Items"
		}

		if npc.mapTitle == "Beard Smith" or npc.mapTitle == "Dok Smith" then
			table.insert(options, "Metal Refinement")
			table.insert(options, "Metalworking Devotion")
			table.insert(options, "Metal Preparation")
		end

		if npc.mapTitle == "Gruff Smith" then
			table.insert(options, "Crafting Skills")
			table.insert(options, "I'm Smelting!")
			table.insert(options, "Smelting Specialization")

			if (player.level >= 50) then
				table.insert(options,"Gruff ring")
			end
		end

		if npc.mapTitle == "Thane's Cave" then
			table.insert(options, "Crafting Skills")
			table.insert(options, "Mine, Mine, Mine")
		end

		local waypointId = _getWaypointId(player, npc)

		if (not Waypoint.isEnabled(player, waypointId)) then
			table.insert(opts, "Waypoint")
		end

		local choice = player:menuString(
			"Hello! How can I help you today?",
			options
		)

		if choice == "Buy" then
			SmithNpc.buy(player, npc)
		elseif choice == "Sell" then
			SmithNpc.sell(player, npc)
		elseif choice == "Fix Item" then
			player:repairExtend()
		elseif choice == "Fix All Items" then
			player:repairAll(npc)
		elseif choice == "Crafting Skills" then
			generalNPC.crafting_skills(player, npc)
		elseif choice == "I'm Smelting!" then
			SmithNpc.imsmelting(player, npc)
		elseif choice == "Smelting Specialization" then
			SmithNpc.smelting_specialization(player, npc)
		elseif choice == "Mine, Mine, Mine" then
			SmithNpc.mineminemine(player, npc)
		elseif choice == "Metal Refinement" then
			SmithNpc.metalRefinement(player, npc)
		elseif choice == "Metalworking Devotion" then
			SmithNpc.metalworkingDevotion(player, npc)
		elseif choice == "Gruff ring" then
			SmithNpc.gruffRing(player, npc)
		elseif choice == "Metal Preparation" then
			SmithNpc.metalPreparation(player, npc)
		elseif choice == "Waypoint" then
			Waypoint.add(player, npc, waypointId)
		end
	end),

	buy = function(player, npc)
		if npc.mapTitle == "Thane's Cave" then
			local items = {"mining_pick"}
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				items
			)
			return
		end

		local str = "I think I can accomodate some of the things you need. What would you like?"

		local buyopts = {
			"Projectiles",
			"Other items",
			"Peasant clothes",
			"Male helms",
			"Female helmets",
			"Warrior's platemail",
			"Rogue's armor",
			"Warrior's scalemail"
		}

		local pclothes = {
			"war_platemail",
			"spring_mail_dress",
			"spring_war_dress",
			"scale_mail",
			"merchant_armor",
			"spring_armor_dress"
		}

		local projectiles = {
			"spring_bow"
		}

		local others = {
			"wooden_saber",
			"wooden_sword",
			"viperhead_woodsaber",
			"viperhead_woodsword",
			"steel_dagger",
			"steel_saber",
			"steel_sword",
			"steel_blade"
		}

		local mhelms = {
			"merchant_helm",
			"farmer_helm",
			"royal_helm",
			"sky_helm",
			"ancient_helm",
			"blood_helm",
			"earth_helm"
		}

		local fhelmets = {
			"spring_helmet",
			"summer_helmet",
			"autumn_helmet",
			"winter_helmet",
			"ancient_helmet",
			"blood_helmet",
			"earth_helmet"
		}

		local warrior_platemail = {
			"jade_war_platemail",
			"royal_war_platemail",
			"sky_war_platemail",
			"ancient_war_platemail",
			"blood_war_platemail",
			"earth_war_platemail",
			"summer_war_dress",
			"autumn_war_dress",
			"winter_war_dress",
			"ancient_war_dress",
			"blood_war_dress",
			"earth_war_dress"
		}

		local rogue_armor = {
			"farmer_armor",
			"royal_armor",
			"sky_armor",
			"ancient_armor",
			"blood_armor",
			"earth_armor",
			"summer_armor_dress",
			"autumn_armor_dress",
			"winter_armor_dress",
			"ancient_armor_dress",
			"blood_armor_dress",
			"earth_armor_dress"
		}

		local warrior_scalemail = {
			"jade_scale_mail",
			"royal_scale_mail",
			"sky_scale_mail",
			"ancient_scale_mail",
			"blood_scale_mail",
			"earth_scale_mail",
			"summer_mail_dress",
			"autumn_mail_dress",
			"winter_mail_dress",
			"ancient_mail_dress",
			"blood_mail_dress",
			"earth_mail_dress"
		}

		local subchoice = player:menuString(
			"What do you want to buy today?",
			buyopts
		)

		if subchoice == "Peasant clothes" then
			player:buyExtend(str, pclothes)
		elseif subchoice == "Projectiles" then
			player:buyExtend(str, projectiles)
		elseif subchoice == "Other items" then
			player:buyExtend(str, others)
		elseif subchoice == "Male helms" then
			player:buyExtend(str, mhelms)
		elseif subchoice == "Female helmets" then
			player:buyExtend(str, fhelmets)
		elseif subchoice == "Warrior's platemail" then
			player:buyExtend(str, warrior_platemail)
		elseif subchoice == "Rogue's armor" then
			player:buyExtend(str, rogue_armor)
		elseif subchoice == "Warrior's scalemail" then
			player:buyExtend(str, warrior_scalemail)
		end
	end,

	sell = function(player, npc)
		local sellitems = SmithNpc.sellItems(npc)
		player:sellExtend("What are you willing to sell today?", sellitems)
	end,

	mineminemine = function(player, npc)
		Tools.configureDialog(player, npc)

		player:dialogSeq(
			{
				"A somewhat maniacal looking ragged man gleefully greets you. Well, hello! Sure, I can tell ya about mining.",
				"First, the best place to mine is in rocky areas, obviously. The mountains north and east of here are the best place.",
				"You need one thing to mine: a mining pick. Say, I happen to have that doo-hickey for sale. What luck!",
				"Mining is pretty simple. Swing your mining pick at ore.",
				"If you don't find anything, move around and try a different spot.",
				"Use your pick to free whatever you came across.",
				"There are a couple little tricks to the trade, so to speak, but I'll let you discover those yourself.",
				"Oh, one last thing. Sometimes your pick might break. Don't fear! Just come back here and buy a new one from me!"
			},
			0
		)

		return
	end,

	imsmelting = function(player, npc)
		Tools.configureDialog(player, npc)

		player:dialogSeq(
			{
				"You're interested in smelting, eh? Yeah, I can spare a couple minutes. Smelting isn't no wimpy craft. It's no coincidence that smelt and welt rhyme.",
				"But I'm not gonna be held responsible if you hurt youself, you hear? You'll need a smelting agreement before any smart smith will let you near the coals.",
				"Smithing turns ore or spent metal into useful metal bars. The higher the quality of ore, the better your luck will be.",
				"When you have some more to smelt, say 'smelt' to me and we'll get started."
			},
			0
		)

		return
	end,

	smelting_specialization = function(player, npc)
		Tools.configureDialog(player, npc)

		if crafting.checkSpecializationLegend(player, "smelting") then
			player:dialogSeq({"You have already specialized in Smelting."}, 0)
			return
		end

		crafting.checkSpecialization(player, npc, "weaving")
		crafting.checkSpecialization(player, npc, "gemcutting")

		player:dialogSeq({"Smelters make metal from ore. Do you want to specialize in smelting? ((You need to be specialized to become better than 'Accomplished'.))"}, 1)

		crafting.addSpecialization(player, npc, "smelting")
	end,

	metalRefinement = function(player, npc)
		Tools.configureDialog(player, npc)

		player:dialogSeq(
			{
				"Metalworking is extremely useful. With this fine skill, you can make valuable metal weapons. If you have some metal on you, tell me 'metal' and I'll help you out.",
				"Get together with a tailor and you'll be able to make armor as well. First you'll have to prepare the metal, and the tailor has to prepare the cloth."
			},
			1
		)

		player:dialogSeq({"I can help you prepare metal for armormaking. Tell me you want to 'smith armor' after you have prepared the metal and when your tailor is ready."}, 0)
	end,

	metalworkingDevotion = function(player, npc)
		Tools.configureDialog(player, npc)

		if (player.level < 25) then
			player:dialogSeq({"You are not ready to devote to a craft yet, come back later."}, 0)
			return
		end

		if crafting.checkSkillLegend(player, "metalworking") then
			player:dialogSeq({"You have already devoted yourself to the study of Metalworking."}, 0)
			return
		end

		crafting.checkSkill(player, npc, "woodworking")
		crafting.checkSkill(player, npc, "jewelry making")
		crafting.checkSkill(player, npc, "tailoring")

		player:dialogSeq({"Metalworkers can make metal weapons, and, with help from a tailor, can make armor. Do you wish to become a metalworker?"}, 1)

		crafting.addSkill(player, npc, "metalworking")
	end,

	buyItems = function(npc)
		local pclothes = {
			"war_platemail",
			"spring_mail_dress",
			"spring_war_dress",
			"scale_mail",
			"merchant_armor",
			"spring_armor_dress"
		}
		local projectiles = {"spring_bow"}

		local others = {
			"wooden_saber",
			"wooden_sword",
			"viperhead_woodsaber",
			"viperhead_woodsword",
			"steel_dagger",
			"steel_saber",
			"steel_sword",
			"steel_blade"
		}

		local mhelms = {
			"merchant_helm",
			"farmer_helm",
			"royal_helm",
			"sky_helm",
			"ancient_helm",
			"blood_helm",
			"earth_helm"
		}
		local fhelmets = {
			"spring_helmet",
			"summer_helmet",
			"autumn_helmet",
			"winter_helmet",
			"ancient_helmet",
			"blood_helmet",
			"earth_helmet"
		}
		local warrior_platemail = {
			"jade_war_platemail",
			"royal_war_platemail",
			"sky_war_platemail",
			"ancient_war_platemail",
			"blood_war_platemail",
			"earth_war_platemail",
			"summer_war_dress",
			"autumn_war_dress",
			"winter_war_dress",
			"ancient_war_dress",
			"blood_war_dress",
			"earth_war_dress"
		}
		local rogue_armor = {
			"farmer_armor",
			"royal_armor",
			"sky_armor",
			"ancient_armor",
			"blood_armor",
			"earth_armor",
			"summer_armor_dress",
			"autumn_armor_dress",
			"winter_armor_dress",
			"ancient_armor_dress",
			"blood_armor_dress",
			"earth_armor_dress"
		}
		local warrior_scalemail = {
			"jade_scale_mail",
			"royal_scale_mail",
			"sky_scale_mail",
			"ancient_scale_mail",
			"blood_scale_mail",
			"earth_scale_mail",
			"summer_mail_dress",
			"autumn_mail_dress",
			"winter_mail_dress",
			"ancient_mail_dress",
			"blood_mail_dress",
			"earth_mail_dress"
		}
		local items = {}

		if npc.mapTitle == "Thane's Cave" then
			table.insert(items, "mining_pick")
		end

		for i = 1, #pclothes do
			table.insert(items, pclothes[i])
		end
		for i = 1, #projectiles do
			table.insert(items, projectiles[i])
		end
		for i = 1, #others do
			table.insert(items, others[i])
		end
		for i = 1, #mhelms do
			table.insert(items, mhelms[i])
		end
		for i = 1, #fhelmets do
			table.insert(items, fhelmets[i])
		end
		for i = 1, #warrior_platemail do
			table.insert(items, warrior_platemail[i])
		end
		for i = 1, #rogue_armor do
			table.insert(items, rogue_armor[i])
		end
		for i = 1, #warrior_scalemail do
			table.insert(items, warrior_scalemail[i])
		end

		return items
	end,

	sellItems = function(npc)
		local items = SmithNpc.buyItems(npc)

		if (npc.mapTitle == "Thane's Cave") then
			-- Thane will only buy mining picks and ores
			items = {"mining_pick", "ore_poor", "ore_med", "ore_high", "ore_very_high", "silver_ore", "gold_ore"}
			return items
		end

		table.insert(items, "fine_steel_dagger")
		table.insert(items, "fine_steel_saber")
		table.insert(items, "fine_steel_sword")
		table.insert(items, "fine_steel_blade")
		table.insert(items, "slag")

		if (Config.bossDropSalesEnabled) then
			table.insert(items, "titanium_blade")
			table.insert(items, "swift_sword")
			table.insert(items, "star_helm")
			table.insert(items, "star_helmet")
			table.insert(items, "moon_helm")
			table.insert(items, "moon_helmet")
			table.insert(items, "sun_helm")
			table.insert(items, "sun_helmet")
			table.insert(items, "battle_helm")
		end

		return items
	end,

	gruffRing = function(player, npc)
		Tools.configureDialog(player, npc)

		if player.quest["gruff_ring"] == 0 then
			player.quest["gruff_ring"] = 1
			player:dialogSeq({"Hello, gruff one. I'm Gruff. I can make you a ring if you're gruff enough."}, 1)
			player:flushKills("trapdoor_spider")
			player:dialogSeq({"Find the Trapdoor spider. Slay it and bring me Hunang's axe."}, 1)
		end

		if player.quest["gruff_ring"] == 1 then
			if player:killCount("trapdoor_spider") == 0 or player:hasItem("hunangs_axe", 1) ~= true then
				player:dialogSeq({"Let me know when you've got that Hunang's axe and killed the Trapdoor spider."}, 0)
				return
			end

			player:removeItem("hunangs_axe", 1)
			player.quest["gruff_ring"] = 2
			player:dialogSeq({"Thank you! Now find the Monkey that holds onto an Ambrosia. Bring me the Ambrosia, but spare me the gruff details."}, 1)
		end

		if player.quest["gruff_ring"] == 2 then
			if player:hasItem("ambrosia", 1) ~= true then
				player:dialogSeq({"Return to me when you've found the Ambrosia."}, 0)
				return
			end

			player:removeItem("ambrosia", 1)
			player.quest["gruff_ring"] = 3
			player:dialogSeq({"Thank you! Now find Lan and spend some money in his shop. He's having a gruff of a month. Bring back two of his most spiritual rings."}, 1)
		end

		if player.quest["gruff_ring"] == 3 then
			if player:hasItem("exorcist_ring", 2) ~= true then
				player:dialogSeq({"Return to me when you've got the two rings from Lan."}, 0)
				return
			end

			player:removeItem("exorcist_ring", 2)
			player:dialogSeq({"Thank you. You're a gruff one, alright! Here's the ring I promised."}, 1)
			player:addItem("gruff_ring", 1)
			player.quest["gruff_ring"] = 0
		end
	end,

	metalPreparation = function(player, npc)
		local smithDialog = Tools.configureDialog(player, npc)
		local metalDialog = {graphic = convertGraphic(291, "item"), color = 0}

		if not crafting.checkSkillLegend(player, "metalworking") then
			player:dialogSeq({smithDialog, "You are not a smith."}, 0)
			return
		end

		if os.time() > player.quest["smith_metal_prepared"] then
			if player:hasItem("metal", 3) ~= true then
				player:dialogSeq({metalDialog, "You need three units of metal."}, 0)
				return
			end

			player:removeItem("metal", 3, 9)
			player.quest["smith_metal_prepared"] = os.time() + 3600

			-- 1 hr
			player:dialogSeq({metalDialog, "You have finished all of the necessary preparations. You still need to finish the task within the next hour."}, 0)
		end

		if os.time() < player.quest["smith_metal_prepared"] then
			player:dialogSeq({smithDialog, "You have already prepared some metal, you should use it first."}, 0)
			return
		end
	end,

	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)
		local smithDialog = Tools.configureDialog(player, npc)
		local angelDialog = {graphic = convertGraphic(49, "monster"), color = 30}

		if speech == "kimesh" and npc.mapTitle == "Runag Smith" then
			Tools.checkKarma(player)

			if player.class >= 10 or player.class < 5 then
				player:dialogSeq({angelDialog, "You must be a member of an NPC subpath to forge a weapon."}, 0)
				return
			end

			local choice = player:menuSeq(
				"To forge a weapon requires many sacrifices. Are you prepared?",
				{"It is my honor to sacrifice.", "I have made a mistake."},
				{}
			)

			if choice == 1 then
				if player.level < 99 then
					player:dialogSeq({smithDialog, "Return when you have reached the 99th insight."}, 0)
					return
				end

				if player.baseHealth < 100 or player.baseMagic < 100 then
					player:dialogSeq({smithDialog, "You need to increase your Vita and Mana to over 100 each."}, 0)
					return
				end

				if player.baseWill < 50 or player.baseMight < 50 or player.baseGrace < 50 then
					player:dialogSeq({smithDialog, "Come back when your base might, will, and grace stats are all at least 50 points each."}, 0)
					return
				end

				if player.exp < 200000000 then
					player:dialogSeq({angelDialog, "You do not have the experience to do this."}, 0)
					return
				end

				local items = {}

				if player.class == 6 then
					items = {
						"chung_ryong_scale",
						"enchanted_chung_ryong_scale",
						"il_san_chung_ryong_scale",
						"ee_san_chung_ryong_scale",
						"sam_san_chung_ryong_scale",
						"sa_san_chung_ryong_scale"
					}
				elseif player.class == 7 then
					items = {
						"nimble_blade",
						"enchanted_nimble_blade",
						"il_san_nimble_blade",
						"ee_san_nimble_blade",
						"sam_san_nimble_blade",
						"sa_san_nimble_blade"
					}
				elseif player.class == 8 then
					items = {
						"ju_jak_staff",
						"enchanted_ju_jak_staff",
						"il_san_ju_jak_staff",
						"ee_san_ju_jak_staff",
						"sam_san_ju_jak_staff",
						"sa_san_ju_jak_staff"
					}
				elseif player.class == 9 then
					items = {
						"life_lance",
						"enchanted_life_lance",
						"il_san_life_lance",
						"ee_san_life_lance",
						"sam_san_life_lance",
						"sa_san_life_lance"
					}
				end

				if (player.mark == 0 and (player.baseHealth >= 80000 or player.baseMagic >= 40000)) then
					item = items[2]
				elseif player.mark == 0 then
					item = items[1]
				elseif player.mark == 1 then
					item = items[3]
				elseif player.mark == 2 then
					item = items[4]
				elseif player.mark == 3 then
					item = items[5]
				elseif player.mark == 4 then
					item = items[6]
				end

				player:addItem(item, 1, 0, player.ID)

				player.baseHealth = player.baseHealth - 100
				player.baseMagic = player.baseMagic - 100

				player.registry["baseHealth"] = player.baseHealth
				player.registry["baseMagic"] = player.baseMagic

				player.baseWill = player.baseWill - 3
				player.baseGrace = player.baseGrace - 3
				player.baseMight = player.baseMight - 3

				player.registry["baseHealth"] = player.baseHealth
				player.registry["baseMagic"] = player.baseMagic
				player.registry["baseWill"] = player.baseWill
				player.registry["baseGrace"] = player.baseGrace
				player.registry["baseMight"] = player.baseMight

				player.exp = player.exp - 200000000
				player:sendStatus()
				player:calcStat()

				player:dialogSeq({angelDialog, "The sacrifice has been made. A weapon is forged."}, 0)
			elseif choice == 2 then
				player:dialogSeq(
					{angelDialog, "Call on me any time you need my help."}, 0)
			end
		end

		if speech == "special delivery" and npc.mapTitle == "Gruff Smith" and player.quest["spy_trials"] == 1 then
			player.quest["spy_trials"] = 2

			player:dialogSeq(
				{
					smithDialog,
					"** Gruff continues working, not looking up at you **",
					"Yeah, yeah, you can leave the 10 high ore right there on the counter.",
					" ** He returns his attention to his work **"
				},
				0
			)

		elseif speech == "special delivery" and npc.mapTitle == "Gruff Smith" and player.quest["spy_trials"] == 2 then
			if player:hasItem("ore_high", 10) == true then
				player:removeItem("ore_high", 10)
				player.quest["spy_trials"] = 3

				player:dialogSeq(
					{
						smithDialog,
						"** You place the ore on the counter along with the raven token **",
						"** Gruff quickly pockets the token, and looks nervously at the door and windows **",
						"Alright, so you might have found this token, but you still need the Guild's Sanhae branch codeword? You got that?"
					},
					0
				)
			else
				player:dialogSeq(
					{
						smithDialog,
						"** Gruff continues working, not looking up at you **",
						"Yeah, yeah, you can leave the 10 high ore right there on the counter.",
						" ** He returns his attention to his work **"
					},
					0
				)
			end
		elseif speech == "special delivery" and npc.mapTitle == "Gruff Smith" and player.quest["spy_trials"] == 3 then
			player:dialogSeq(
				{
					smithDialog,
					"So kid, what's the good word?",
					"** Gruff places one finger on his cheek **"
				},
				0
			)

			local response = player:inputSeq(
				"What is the codeword?",
				"",
				"",
				{},
				{}
			)

			local poisonedBraceletDialog = {
				graphic = Item("poisoned_bracelet").icon,
				color = Item("poisoned_bracelet").iconC
			}

			if string.lower(response) == "nightbreeze" then
				player.registry["spy_subterfuge"] = player.registry["spy_subterfuge"] + 1
				player.quest["spy_trials"] = 4
				player:removeItem("suspicious_note", 1)

				player:dialogSeq(
					{
						smithDialog,
						"Good, then you're indeed an affiliate of our guild, unlike that other guy who showed up recently. I don't know what his deal was.",
						"** The smith again shuts the door and locks, he peers out the windows before returning to the counter **",
						"This smith work is my cover, what I do by day so that I can do... other things in secrecy.",
						"Everyone in our guild has established a cover - I would imagine you have too.",
						"Covers help our other work stay in the shadow. My real name isn't even Gruff...",
						"No one suspects the simple farmer of being an assassin, or the aged librarian for being a smuggler.",
						"Our covers keep us safe and are the masks we wear to deflect attention. You will need a temporary one for what you are about to do."
					},
					0
				)

				player:addItem("poisoned_bracelet", 1)
				player:removeLegendbyName("spy_subterfuge")

				player:addLegend(
					"Deceived " .. player.registry["spy_subterfuge"] .. " times with subterfuge",
					"spy_subterfuge",
					22,
					128
				)

				player.quest["spy_trial_bracelet_time"] = os.time()

				player:dialogSeq(
					{
						poisonedBraceletDialog,
						"** Gruff hands you a small bracelet with a slightly protruding pointed end **",
						"Be careful with this and do not let the point pierce your skin."
					},
					0
				)

				player:dialogSeq(
					{
						smithDialog,
						"Our potion store associate Pitch did well in creating the deadly poison that is inside the bracelet.",
						"As soon as the tip enters the flesh, the poison will drain from the bracelet through the pointed tip.",
						"You are to deliver the bracelet, rather, its contents to a member of the Imperial Court who is a frequent gambler at the underground casino.",
						"He has crossed the Guild, threatening to blow covers of some of our associates here in Sanhae.",
						"This threat must be neutralized and would be a great start in proving yourself in the Guild.",
						"Head to our Guild's seamstress, Lin, dowm the path here and get measured for some clothes appropriate for this assignment.",
						"Tell her you need clothes for a 'Special Ocassion', and she will fill you in on the rest.",
						"If you need another bracelet, come back here and ask for one but it may take a bit of time and ore to make."
					},
					0
				)
			else
				if player.quest["spy_trial_note"] == 0 then
					player.quest["spy_trial_note"] = 1
					player:addItem("suspicious_note", 1)
					player:sendMinitext("A plain-looking messenger brushes past your shoulder as you feel something slip into your pocket.")
				end

				player:dialogSeq({smithDialog, "Just like I thought, I didn't think we had any business! Go back to the streets, kid..."}, 0)
			end
		end

		if speech == "coal" and npc.mapTitle == "Gruff Smith" then
			Tools.checkKarma(player)

			player:dialogSeq(
				{
					smithDialog,
					"You're looking for some coal?",
					"Sure, I got a ton of the stuff, need it to keep my furnace going."
				},
				1
			)

			local choice = player:menuSeq(
				"Would you like to buy a piece for 20 gold?",
				{"Yes, please.", "No, thanks."},
				{}
			)

			if choice == 1 then
				if player.money < 20 then
					player:dialogSeq({smithDialog, "Try to rob me, will ya? Get your poor carcass out of here before I give you a hot poker in the eye!"}, 0)
					return
				end

				player.money = player.money - 20
				player:sendStatus()
				player:addItem("coal", 1)

				local choice2 = player:menuSeq(
					"There you go... bet you need to know how to light it now, right?",
					{"Uhh.. yeah", "No, I already know!"},
					{}
				)

				if choice2 == 1 then
					player:dialogSeq({smithDialog, "Well, coal may be cheap, but knowledge isn't. It will cost you 5,000 for that secret."}, 1)

					local choice3 = player:menuSeq(
						"Do you want to buy the knowledge for 5,000 gold?",
						{"Fine, yes.", "No way!"},
						{}
					)

					if choice3 == 1 then
						if player.money < 5000 then
							player:dialogSeq({smithDialog, "Well, I have the knowledge, but you don't have the cash. Come back when you do."}, 0)
							return
						end

						player.money = player.money - 5000
						player:sendStatus()

						player:dialogSeq(
							{
								smithDialog,
								"Thanks for the gold, now for the secret... just mix the coal with some flash dust, that will light it right away!",
								"Good luck to ya, come back any time you need some coal."
							},
							0
						)
					elseif choice3 == 2 then
						player:dialogSeq({smithDialog, "Well, if you ever want to learn, come back to me."}, 0)
						return
					end
				elseif choice2 == 2 then
					player:dialogSeq({smithDialog, "Bah!"}, 0)
				end
			elseif choice == 2 then
				player:dialogSeq({smithDialog, "OK, don't need your stinking money anyways."}, 0)
			end
		end

		if ((speech == "gruff ring" or speech == "ring") and npc.mapTitle == "Gruff Smith") then
			Tools.checkKarma(player)

			if (player.level < 50) then
				return
			end

			SmithNpc.gruffRing(player,npc)
		end

		if speech == "virtue" and npc.mapTitle == "Chul Smith" then
			Tools.checkKarma(player)

			if player.quest["wind_armor"] ~= 0 and player.quest["min_clicked"] == 1 and player:hasItem("stardrop", 1) == true then
				player:dialogSeq(
					{
						smithDialog,
						"So Min sent you to me, I see she even told you to bring the Stardrop. You must be on the path to virtue.",
						"You look confused... I can imagine, Min and I, friends. You only know half the legend my friend, but you are on the path to learn the rest.",
						"In time you will understand.",
						"So, you need a sword of the stars. I see our old friend is still keeping guard after all this time.",
						"It has been so long, I never imagined the day would come that I would be in this situation.",
						"So let me have that Stardrop, and I will forge you one.",
						"Be warned! This sword is more of a sign, and not a weapon. It will not last long in battle, and is very fragile!",
						"Take care of it, if you make it through to the guard, you will have proven yourself careful, and trustworthy to have the secret that awaits you.",
						"I know the challenge is great, and I will make three such swords for you, but no more.",
						"I recommend you only take one at a time, until you get what you seek."
					},
					1
				)

				player:removeItem("stardrop", 1)

				if player.quest["star_swords"] <= 1 then
					player:addItem("star_sword", 1, 0, player.ID)
					player.quest["star_swords"] = player.quest["star_swords"] + 1
					player:dialogSeq({smithDialog, "There you go, isn't she beautiful? Take care now."}, 0)
					return
				elseif player.quest["star_swords"] == 2 then
					player:addItem("star_sword", 1, 0, player.ID)
					player.quest["star_swords"] = player.quest["star_swords"] + 1
					player:dialogSeq({smithDialog, "There you go, isn't she beautiful? Take care as this is the final sword I am going to make for you."}, 0)
					return
				elseif player.quest["star_swords"] >= 3 then
					player:dialogSeq({smithDialog, "I have made the sword for you three times now as I said I would. I am unable to make any more."}, 0)
					return
				end

				return
			else
				npc:talk(0, npc.name .. ": I have no idea what you're talking about.")
			end
		end

		if (speech == "shield" and npc.mapTitle == "Chul Smith") then
			Tools.checkKarma(player)

			local baseClass = player.baseClass

			if (baseClass < 1) then
				return
			end

			local legends = {"nagnang_warrior_trial", "dagger_guild_member", "family_nangen_mages", "destroyed_nagnang_evil"}
			local shieldQuest = legends[baseClass]

			if not player:hasLegend(shieldQuest) then
				player:dialogSeq({smithDialog, "You know nothing of shields. When you learn, perhaps I will help you."}, 1)
				return
			end

			player:dialogSeq(
				{
					smithDialog,
					"Greetings, I see you have come to get a new shield.",
					"These shields are special as only the Nagnang people know how to make them.",
					"However, the materials we need to make them are not available in these parts.",
					"If you would bring me a supply of the items I will use some to make a new shield for you."
				},
				1
			)

			local choice = player:menuSeq(
				"Will you give me 10 Ginko wood and one Metal?",
				{"Yes, I have it right here.", "Sorry, not now."},
				{}
			)

			if choice == 1 then
				if player:hasItem("ginko_wood", 10) ~= true or player:hasItem("metal", 1) ~= true then
					player:dialogSeq({smithDialog, "You do not have the items I need. Oh well."}, 0)
					return
				end

				player:removeItem("ginko_wood", 10)
				player:removeItem("metal", 1)

				local shields = {"tall_shield", "round_buckler", "magicians_ward", "essence_charm"}
				local shield = shields[baseClass]
				player:addItem(shield, 1, 0, player.ID)
				player:dialogSeq({smithDialog, "Good luck to you, and thanks for the materials."}, 0)
			elseif choice == 2 then
				player:dialogSeq({smithDialog, "Perhaps another time then. Farewell."}, 0)
				return
			end
		end

		if speech == "laptev" and npc.mapTitle == "Othotsk Blacksmith" then
			Tools.checkKarma(player)

			player:dialogSeq(
				{
					smithDialog,
					"Shhh! Not so loud, my friend. Yeah, I got some rare merchandise. The magic in 'em is a bit frail, like the ice where they're found.",
					"They'll bind to your soul, only permitting you to wield them. And after you've thrown your last snowball, if you catch my drift, they'll join you in the everafter."
				},
				1
			)

			local choice = player:menuSeq(
				"What can I offer you?",
				{"Giasomo stick (20,000 gold)", "Frozen spear (400,000 gold)"},
				{}
			)

			if choice == 1 then
				-- giasomo stick
				if os.time() < player.registry["othotsk_timer"] then
					player:dialogSeq({smithDialog, "Sorry, faithful customer. I don't have anything else for you right now. Mayhbe in a week or two."}, 0)
					return
				end

				if player.money < 20000 then
					player:dialogSeq({smithDialog, "Please come back when you have the money."}, 0)
					return
				end

				player.money = player.money - 20000
				player:sendStatus()
				player:addItem("giasomo_stick", 1, 0, player.ID)
				player.registry["othotsk_timer"] = os.time() + 604800

				player:dialogSeq({smithDialog, "Quite a bizarre little item, isn't it? There you go, your own Giasomo stick."}, 0)
			elseif choice == 2 then
				-- frozen spear
				if os.time() < player.registry["othotsk_timer"] then
					player:dialogSeq({smithDialog, "Sorry, faithful customer. I don't have anything else for you right now. Maybe in a week or two."}, 0)
					return
				end

				if player.money < 400000 then
					player:dialogSeq({smithDialog, "Please come back when you have the money."}, 0)
					return
				end

				player.money = player.money - 400000
				player:sendStatus()
				player:addItem("frozen_spear", 1, 0, player.ID)
				player.registry["othotsk_timer"] = os.time() + 604800 * 2

				player:dialogSeq({smithDialog, "I've never seen such a wacky weapon... Those ogres sure are strange ones. There is your Frozen spear. I hope you like it."}, 0)
			end
		end

		if speech == "forge metal" and npc.mapTitle == "Gruff Smith" then
			if player.quest["forgotten_path"] == 6 then
				player.quest["forgotten_path"] = 7
				player:dialogSeq(
					{
						smithDialog,
						"Yes, I can forge metal.\n\nFor what do you need forged metal?",
						"An orb you say, what kind of orb?",
						"You need some special metal for a magic orb, go talk to my friend Thane in the wilderness, maybe he can help you."
					},
					1
				)

				return
			end
		end

		if npc.mapTitle == "Thane's Cave" then
			if speech == "special metal" and player.quest["forgotten_path"] == 7 then
				player.quest["forgotten_path"] = 8

				player:dialogSeq(
					{
						smithDialog,
						"You need special metal?",
						"Well... I have this strange metal that I sometimes come across deep in the ground.",
						"It glows this odd blue color.\n\nWhat do you need it for?"
					},
					1
				)

				return
			end
			if speech == "metal orb" then
				if player.quest["forgotten_path"] == 8 then
					player.quest["forgotten_path"] = 9

					player:dialogSeq(
						{
							smithDialog,
							"Well, I will make you a deal.",
							"If you can gather me 5 poor, medium, and high ore, I'll give you this here strange metal.",
							"Sound like a deal?\n\nLet me know when you have all the ore."
						},
						1
					)

					return
				elseif player.quest["forgotten_path"] == 9 then
					if (player:hasItem("ore_poor", 5) == true and player:hasItem("ore_med", 5) == true and player:hasItem("ore_high", 5) == true) then
						player:removeItem("ore_poor", 5)
						player:removeItem("ore_med", 5)
						player:removeItem("ore_high", 5)
						player.quest["forgotten_path"] = 10

						player:dialogSeq({smithDialog, "Thanks, here you can have this strange metal. Good luck!"}, 0)

						return
					else
						player:dialogSeq({smithDialog, "Well... where is it?"}, 0)
						return
					end
				end
			end
		end

		if npc.mapTitle == "Gruff Smith" and speech == "smelt" then
			crafting.craftingDialog(player, npc, speech)
		end

		if (npc.mapTitle == "Beard Smith" or npc.mapTitle == "Dok Smith") and speech == "metal" then
			crafting.craftingDialog(player, npc, speech)
		end

		if (npc.mapTitle == "Beard Smith" or npc.mapTitle == "Dok Smith") and speech == "smith armor" then
			crafting.craftingDialog(player, npc, speech)
		end

		if (npc.mapTitle == "Beard Smith" or npc.mapTitle == "Dok Smith") and speech == "prepare" then
			SmithNpc.metalPreparation(player, npc)
		end

		local waypointId = _getWaypointId(player, npc)

		if (speech == "waypoint" and not Waypoint.isEnabled(player, waypointId)) then
			Waypoint.add(player, npc, waypointId)
			return
		end
	end)
}
