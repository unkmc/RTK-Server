carve_arrow = {
	cast = async(function(player)
		local t = {}

		player.npcGraphic = 0
		player.npcColor = 0
		player.dialogType = 0
		player.lastClick = player.ID

		local aethers = 10000000

		-- 10,000s
		local magic = 8000

		if player.gmLevel > 0 then
			magic = 0
			aethers = 0
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:sendMinitext("You cast Carve arrow.")
		player:setAether("carve_arrow", aethers)

		local choice = ""

		local arrowChoices = {
			"Basic wooden",
			"Split head",
			"Cursed head",
			"Flame head",
			"Steel tip"
		}

		if player.mark >= 1 then
			table.insert(arrowChoices, "Sleep")
		end
		if player.mark >= 2 then
			table.insert(arrowChoices, "Explosive")
		end
		if player.mark >= 3 then
			table.insert(arrowChoices, "Dark")
		end
		if player.mark >= 4 then
			table.insert(arrowChoices, "Deamon")
		end

		local regeant = ""
		local craftedItem = ""

		local str = "buffer"

		while str == "buffer" do
			choice = player:menuString(
				"What do you wish to make, Ranger?",
				arrowChoices,
				{}
			)

			-- Creates type arrow [30], requires 3 ginko wood and a reagant based on the arrow type.

			if choice == "Basic wooden" then
				-- made Ranger arrows [30]
				regeant = "chestnut"
				craftedItem = "ranger_arrows"
			elseif choice == "Split head" then
				-- made Split head arrows [30]
				regeant = "chestnut"
				craftedItem = "split_head_arrows"
			elseif choice == "Cursed head" then
				-- made Cursed arrows [30] -- used 1 chestnut and 3 ginko wood -- "You need a chestnut to make this arrow."
				regeant = "chestnut"
				craftedItem = "cursed_head_arrows"
			elseif choice == "Flame head" then
				-- gave dialog box "You need a pebble to make this arrow."
				regeant = "pebble"
				craftedItem = "flame_head_arrows"
			elseif choice == "Steel tip" then
				-- gave dialog box "You need some metal to make this arrow."
				regeant = "metal"
				craftedItem = "steel_tip_arrows"
			elseif choice == "Sleep" then
				-- regeant = limestone
				regeant = "limestone"
				craftedItem = "sleep_arrows"
			elseif choice == "Explosive" then
				regeant = "limestone"
				craftedItem = "explosive_arrows"
			elseif choice == "Dark" then
				-- regeant = tainted staff
				regeant = "tainted_staff"
				craftedItem = "dark_arrows"
			elseif choice == "Deamon" then
				regeant = "tainted_staff"
				craftedItem = "deamon_arrows"
			end

			if player:hasItem("ginko_wood", 3) ~= true then
				player:dialogSeq(
					{t, "You need some ginko wood to make this arrow."},
					0
				)
				return
			end

			if player:hasItem(regeant, 1) ~= true then
				player:dialogSeq(
					{
						t,
						"You need a " .. Item(regeant).name .. " to make this arrow."
					},
					0
				)
				return
			end

			player:removeItem("ginko_wood", 3)
			player:removeItem(regeant, 1)

			player:addItem(craftedItem, 1)
		end
	end)
}
