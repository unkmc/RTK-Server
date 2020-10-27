SeamstressNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {"Buy", "Sell", "Unengrave cashshop item"}
		local buyopts = {
			"Peasant clothes",
			"Rogue's clothes",
			"Mage's dress",
			"Mage's skirt",
			"Poet's draperies",
			"Other items"
		}

		if npc.mapTitle == "Blossom Seams" then
			table.insert(opts, "Commission a job 2")
			table.insert(opts, "Suit of invisibility")
		end

		if npc.mapTitle == "Lin Cloth" then
			table.insert(opts, "Crafting Skills")
			table.insert(opts, "The Art of Tailoring")
			table.insert(opts, "Tailoring Devotion")
			table.insert(opts, "Cloth Preparation")
		end

		local choice

		local pclothes = {
			Item("spring_dress").id,
			Item("spring_blouse").id,
			Item("spring_skirt").id,
			Item("spring_gown").id
		}
		local rclothes = {
			Item("summer_blouse").id,
			Item("autumn_blouse").id,
			Item("winter_blouse").id,
			Item("leather_blouse").id,
			Item("ancient_blouse").id,
			Item("earth_blouse").id
		}
		local mdress = {
			Item("summer_dress").id,
			Item("autumn_dress").id,
			Item("winter_dress").id,
			Item("leather_dress").id,
			Item("ancient_dress").id,
			Item("earth_dress").id
		}
		local mskirt = {
			Item("summer_skirt").id,
			Item("autumn_skirt").id,
			Item("winter_skirt").id,
			Item("leather_skirt").id,
			Item("heart_skirt").id,
			Item("earth_skirt").id
		}
		local pdraperies = {
			Item("summer_drapery").id,
			Item("autumn_drapery").id,
			Item("winter_drapery").id,
			Item("leather_drapery").id,
			Item("ancient_drapery").id,
			Item("earth_drapery").id
		}
		local pgowns = {
			Item("summer_gown").id,
			Item("autumn_gown").id,
			Item("winter_gown").id,
			Item("leather_gown").id,
			Item("ancient_gown").id,
			Item("earth_gown").id
		}
		local oitems = {Item("wedding_dress").id}

		local menu = player:menuString(
			"Hello! What would you like to do today?",
			opts
		)

		if menu == "Buy" then
			choice = player:menuString(
				"What do you want to buy today?",
				buyopts,
				{}
			)

			local choice2 = {}

			if choice == "Peasant clothes" then
				choice2 = pclothes
			elseif choice == "Rogue's clothes" then
				choice2 = rclothes
			elseif choice == "Mage's dress" then
				choice2 = mdress
			elseif choice == "Mage's skirt" then
				choice2 = mskirt
			elseif choice == "Poet's gown" then
				choice2 = pgowns
			elseif choice == "Poet's draperies" then
				choice2 = pdraperies
			elseif choice == "Other items" then
				choice2 = oitems
			end

			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				choice2
			)
		elseif menu == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				SeamstressNpc.sellItems()
			)

			--[[ this is a subpath quest and part of an event in tk that is not active here
	elseif menu == "Commission a job 2" then
	elseif menu == "Suit of invisibility" then
		player:dialogSeq({t,"Hello there! I think I misheard you, did you actually you're looking for a suit of..invisibility?!?!...",
				"Oh my, I wouldn't know where to begin!",
				"*You tell "..npc.name.." the steps that Treilsaare taught you.*"},1)
		player:dialogSeq({t,"But you don't have the items I need.."},1)
		]]
			--
		elseif menu == "Crafting Skills" then
			generalNPC.crafting_skills(player, npc)
		elseif menu == "The Art of Tailoring" then
			player:dialogSeq(
				{
					t,
					"So, you think you're cut out to be a tailor? Tailoring is a necessity for making any type of garment.",
					"Many types of clothing can be made by a tailor working alone, though some types require the assistance of a metalworker.",
					"When you attempt to create a garment, the quality ((i.e., Spring, Summer, etc.)) of the product depends upon your skill, your cloth, and your luck.",
					"Say 'tailor' to me when you are ready to make something. I can also help you with Cloth Preparation, which is needed before you can make armor."
				},
				0
			)
			return
		elseif menu == "Tailoring Devotion" then
			SeamstressNpc.tailoringDevotion(player, npc)
		elseif menu == "Cloth Preparation" then
			SeamstressNpc.clothPreparation(player, npc)
		end
	end),

	tailoringDevotion = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if crafting.checkSkillLegend(player, "tailoring") then
			player:dialogSeq(
				{
					t,
					"You have already devoted yourself to the study of Tailoring."
				},
				0
			)
			return
		end

		crafting.checkSkill(player, npc, "woodworking")
		crafting.checkSkill(player, npc, "jewelry making")
		crafting.checkSkill(player, npc, "metalworking")

		player:dialogSeq(
			{
				t,
				"Tailors can make clothing, and, with help from a metalworker, can make armor. Do you wish to become a tailor?"
			},
			1
		)

		crafting.addSkill(player, npc, "tailoring")
	end,

	clothPreparation = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		local tcloth = {graphic = convertGraphic(1632, "item"), color = 0}

		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if not crafting.checkSkillLegend(player, "tailoring") then
			player:dialogSeq({t, "You are not a tailor."}, 0)
			return
		end

		if os.time() > player.quest["tailor_cloth_prepared"] then
			if player:hasItem("cloth", 2) ~= true then
				player:dialogSeq({tcloth, "You need two pieces of cloth."}, 0)
				return
			end

			player:removeItem("cloth", 2)
			player.quest["tailor_cloth_prepared"] = os.time() + 3600

			-- 1 hr
			player:dialogSeq(
				{
					tcloth,
					"You have finished all of the necessary preparations. You still need to finish the task within the next hour."
				},
				0
			)
		end

		if os.time() < player.quest["tailor_cloth_prepared"] then
			player:dialogSeq(
				{
					t,
					"You have already prepared some cloth, you should use it first."
				},
				0
			)
			return
		end
	end,

	onSayClick = async(function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local speech = string.lower(player.speech)

		if speech == "special occasion" and npc.mapTitle == "Lin Cloth" and player.quest[
			"spy_trials"
		] == 4 then
			local choices = {
				"To make me look fancy",
				"To keep warm through a cold night breeze",
				"Something light and dyable"
			}
			local choice = player:menuSeq(
				"Hey honey, what kind of occassion are you looking to dress for?",
				choices,
				{}
			)
			if choice == 1 then
				if player.sex == 0 then
					player:addItem("farmer_clothes", 1)
				else
					player:addItem("spring_dress", 1)
				end
				player:dialogSeq({t, "Here you go!"}, 0)
			elseif choice == 2 then
				player.quest["spy_trial_outfit_timer"] = os.time()
				player.quest["spy_trials"] = 5
				player:dialogSeq(
					{
						t,
						"Well, why didn't you say so! Someone else came in here earlier with a similar request.",
						"** The seamstress steps from behind the counter, locks the door, and returns with a measurement tape **",
						"Going to the casino huh? Nasty crowd. Those Imperial courtiers are always threatening to blow all of our covers up here in Sanhae",
						"The Guild has secured employment for an extra food server at the underground casino, and that will be your temporary cover for this task",
						"Okay! All measured up. I'll have your outfit ready in two days. Come back then and bring me some of that good soup they have in the Koguryian Taverns!"
					},
					0
				)
			elseif choice == 3 then
				if player.sex == 0 then
					player:addItem("farmer_clothes", 1)
				else
					player:addItem("spring_dress", 1)
				end
				player:dialogSeq({t, "Here you go!"}, 0)
			end
		elseif speech == "special occasion" and npc.mapTitle == "Lin Cloth" and player.quest[
			"spy_trials"
		] == 5 then
			if os.time() > player.quest["spy_trial_outfit_timer"] + 60 then
				player.quest["spy_trials"] = 6
				player:dialogSeq(
					{
						t,
						"Guild informants have relayed that the next Underground Casino will happen beneath the Nagnang Marketplace.",
						"You'll need to go there and ask the marketplace manager for any Special Deals.",
						"Be careful, but do this well and I'm sure you'll find more stable employment with us."
					},
					0
				)
			else
				player:dialogSeq(
					{t, "It's not quite ready yet. Check back soon."},
					0
				)
			end
		end

		if speech == "tailor" then
			if npc.mapTitle == "Blossom Seams" or npc.mapTitle == "Lin Cloth" then
				crafting.craftingDialog(player, npc, speech)
			end
		end

		if speech == "prepare" then
			if npc.mapTitle == "Blossom Seams" or npc.mapTitle == "Lin Cloth" then
				SeamstressNpc.clothPreparation(player, npc)
			end
		end
	end),

	buyItems = function()
		local buyItems = {}

		local pclothes = {
			Item("spring_dress").id,
			Item("spring_blouse").id,
			Item("spring_skirt").id,
			Item("spring_gown").id
		}
		local rclothes = {
			Item("summer_blouse").id,
			Item("autumn_blouse").id,
			Item("winter_blouse").id,
			Item("leather_blouse").id,
			Item("ancient_blouse").id,
			Item("earth_blouse").id
		}
		local mdress = {
			Item("summer_dress").id,
			Item("autumn_dress").id,
			Item("winter_dress").id,
			Item("leather_dress").id,
			Item("ancient_dress").id,
			Item("earth_dress").id
		}
		local mskirt = {
			Item("summer_skirt").id,
			Item("autumn_skirt").id,
			Item("winter_skirt").id,
			Item("leather_skirt").id,
			Item("heart_skirt").id,
			Item("earth_skirt").id
		}
		local pdraperies = {
			Item("summer_drapery").id,
			Item("autumn_drapery").id,
			Item("winter_drapery").id,
			Item("leather_drapery").id,
			Item("ancient_drapery").id,
			Item("earth_drapery").id
		}
		local pgowns = {
			Item("summer_gown").id,
			Item("autumn_gown").id,
			Item("winter_gown").id,
			Item("leather_gown").id,
			Item("ancient_gown").id,
			Item("earth_gown").id
		}
		local oitems = {Item("wedding_dress").id}

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
		for i = 1, #pgowns do
			table.insert(buyItems, pgowns[i])
		end
		for i = 1, #oitems do
			table.insert(buyItems, oitems[i])
		end

		return buyItems
	end,

	sellItems = function()
		local sellItems = SeamstressNpc.buyItems()

		return sellItems
	end
}
