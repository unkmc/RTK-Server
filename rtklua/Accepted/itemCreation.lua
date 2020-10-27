itemCreation = async(function(player)
	local items = {}
	local itemAmounts = {}

	local i = 1
	while i < #creationItems do
		table.insert(items, Item(creationItems[i]).yname)
		table.insert(itemAmounts, creationItems[i + 1])
		i = i + 2
	end

	local itemsCreated = {
		"wings_of_fury",
		"plate_of_metal",
		"hot_coal",
		"lantern",
		"silk_skin",
		"wing_eye",
		"evil_warlord_armor"
	}

	local maps = {"desert_map"}

	for i = 1, #maps do
		table.insert(itemsCreated, maps[i])
	end

	--polished stone: 35 grain of sand, 5 heavy rock, 3 rock

	local itemHaveMats = ""

	local itemReq = {}
	local itemAmountReq = {}
	local takeItem = {}
	local takeAmountReq = {}
	local giveItem = ""
	local giveItemAmount = 1

	for i = 1, #itemsCreated do
		itemReq, itemAmountReq = getItemsForItemCreation(itemsCreated[i])

		if itemReq ~= nil then
			local count = 0
			for j = 1, #itemReq do
				for k = 1, #items do
					if items[k] == itemReq[j] and itemAmounts[k] == itemAmountReq[j] then
						count = count + 1
					end

					if count == #itemReq then
						-- we matched what is needed
						takeItem = itemReq
						takeAmountReq = itemAmountReq
						giveItem = itemsCreated[i]
						break
					end
				end
			end
		end
	end

	if #takeItem > 0 then
		for i = 1, #takeItem do
			player:removeItem(takeItem[i], takeAmountReq[i])
		end

		player:addItem(giveItem, 1)
		player:sendMinitext("You were successful!")
	else
		player:sendMinitext("You were unsuccessful.")
	end
end)

getItemsForItemCreation = function(itemsCreated)
	local items = {}
	local itemAmounts = {}

	if itemsCreated == "wings_of_fury" then
		items = {"bird_wing", "dragon_fan"}
		itemAmounts = {5, 1}
	elseif itemsCreated == "plate_of_metal" then
		items = {"plated_armor", "fine_metal", "armor_plated_skin", "hot_coal"}
		itemAmounts = {15, 10, 8, 3}
	elseif itemsCreated == "hot_coal" then
		items = {"coal", "flash_dust"}
		itemAmounts = {1, 1}
	elseif itemsCreated == "lantern" then
		items = {"hot_coal", "white_paper", "beef", "ginko_wood"}
		itemAmounts = {1, 1, 1, 1}
	elseif itemsCreated == "silk_skin" then
		items = {
			"corrupted_cloth",
			"scaled_leather",
			"splendid_silk",
			"wicked_wool",
			"scorpions_stinger"
		}
		itemAmounts = {1, 1, 1, 1, 1}
	elseif itemsCreated == "wing_eye" then
		items = {"crystal_fly_eye", "prism_amber", "unleashed_anger"}
		itemAmounts = {1, 1, 1}
	elseif itemsCreated == "evil_warlord_armor" then
		items = {
			"wings_of_fury",
			"plate_of_metal",
			"wing_eye",
			"silk_skin",
			"fighter_essence",
			"dark_essense",
			"wind_armor"
		}
		itemAmounts = {1, 1, 1, 1, 1, 1, 1}
	end

	if itemsCreated == "desert_map" then
		items = {"desert_map_fragment"}
		itemAmounts = {10}
	end

	return items, itemAmounts
end
