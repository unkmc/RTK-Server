generate_json = function()
	local version = os.date("%y%m%d-%H%M%S")

	local dir1 = "../itemshop/itemshop.json"
	local dir2 = "../itemshop/itemshop.ver"

	local file1 = io.open(dir1, "w+")
	local file2 = io.open(dir2, "w+")

	file2:write("{\n\t\"version\": \"" .. version .. "\"\n}")
	file2:flush()

	local main = {}
	local usableItems = {}

	--
	local weapons = {}

	--
	local mounts = {}

	--
	local face = {}

	--
	local head = {}
	local mantle = {}
	local necklaces = {}

	--
	local coats = {}

	--
	local shoes = {}
	local specialtySets = {}

	for i = 15000, 15270 do
		local item = Item(i)
		if item ~= nil then
			if item.type == 24 then
				table.insert(mounts, item)
			end
		end
	end

	for i = 16000, 18100 do
		local item = Item(i)

		if item ~= nil then
			if (item.type == 1 or item.type == 2 or item.type == 18 or item.type == 28) and item.name ~= "??" then
				table.insert(usableItems, item)
			end
			if item.type == 27 then
				table.insert(weapons, item)
			end
			if item.type == 11 or item.type == 25 or item.type == 29 then
				table.insert(face, item)
			end
			if item.type == 12 then
				table.insert(head, item)
			end
			if item.type == 13 then
				table.insert(mantle, item)
			end
			if item.type == 14 then
				table.insert(necklaces, item)
			end
			if item.type == 15 then
				table.insert(shoes, item)
			end
			if item.type == 16 then
				table.insert(coats, item)
			end
		end
	end

	local text = ""

	text = text .. "{" .. "\n"
	text = text .. "\t\"version\": \"" .. version .. "\"," .. "\n"

	text = text .. "\t\"main\": [" .. "\n"
	text = text .. "\t]," .. "\n"

	-------------------------------
	text = text .. "\t\"usable_items\": [" .. "\n"

	for i = 1, #usableItems do
		local part = 0

		if usableItems[i].type == 28 then
			part = 32
		end

		local icon = 0
		if usableItems[i].icon > 49152 then
			icon = usableItems[i].icon - 49152
		else
			icon = usableItems[i].icon
		end

		text = text .. "\t\t{" .. "\n"
		text = text .. "\t\t\t\"name\": \"" .. usableItems[i].name .. "\"\," .. "\n"

		text = text .. "\t\t\t\"tile\": " .. icon .. "\," .. "\n"
		text = text .. "\t\t\t\"color\": " .. usableItems[i].iconC .. "\," .. "\n"
		text = text .. "\t\t\t\"items\": [" .. "\n"
		text = text .. "\t\t\t{" .. "\n"
		text = text .. "\t\t\t\t\"part\": " .. part .. "," .. "\n"
		text = text .. "\t\t\t\t\"tile\": " .. usableItems[i].look .. "," .. "\n"
		text = text .. "\t\t\t\t\"color\": " .. usableItems[i].lookC .. "," .. "\n"
		text = text .. "\t\t\t\t\"gender\": " .. usableItems[i].sex .. "\n"
		text = text .. "\t\t\t}" .. "\n"
		text = text .. "\t\t\t]" .. "\n"

		if i == #usableItems then
			text = text .. "\t\t}" .. "\n"
		else
			text = text .. "\t\t}," .. "\n"
		end
	end

	text = text .. "\t]," .. "\n"

	-------------------------

	-------------------------------
	text = text .. "\t\"coats\": [" .. "\n"

	for i = 1, #coats do
		local part = 16
		local icon = 0
		if coats[i].icon > 49152 then
			icon = coats[i].icon - 49152
		else
			icon = coats[i].icon
		end

		text = text .. "\t\t{" .. "\n"
		text = text .. "\t\t\t\"name\": \"" .. coats[i].name .. "\"\," .. "\n"
		text = text .. "\t\t\t\"tile\": " .. icon .. "\," .. "\n"
		text = text .. "\t\t\t\"color\": " .. coats[i].iconC .. "\," .. "\n"
		text = text .. "\t\t\t\"items\": [" .. "\n"
		text = text .. "\t\t\t{" .. "\n"
		text = text .. "\t\t\t\t\"part\": " .. part .. "," .. "\n"
		text = text .. "\t\t\t\t\"tile\": " .. coats[i].look .. "," .. "\n"
		text = text .. "\t\t\t\t\"color\": " .. coats[i].lookC .. "," .. "\n"
		text = text .. "\t\t\t\t\"gender\": " .. coats[i].sex .. "\n"
		text = text .. "\t\t\t}" .. "\n"
		text = text .. "\t\t\t]" .. "\n"

		if i == #coats then
			text = text .. "\t\t}" .. "\n"
		else
			text = text .. "\t\t}," .. "\n"
		end
	end

	text = text .. "\t]," .. "\n"

	-------------------------

	-------------------------------
	text = text .. "\t\"weapons\": [" .. "\n"

	for i = 1, #weapons do
		local part = 1
		local icon = 0
		if weapons[i].icon > 49152 then
			icon = weapons[i].icon - 49152
		else
			icon = weapons[i].icon
		end

		text = text .. "\t\t{" .. "\n"
		text = text .. "\t\t\t\"name\": \"" .. weapons[i].name .. "\"\," .. "\n"
		text = text .. "\t\t\t\"tile\": " .. icon .. "\," .. "\n"
		text = text .. "\t\t\t\"color\": " .. weapons[i].iconC .. "\," .. "\n"
		text = text .. "\t\t\t\"items\": [" .. "\n"
		text = text .. "\t\t\t{" .. "\n"
		text = text .. "\t\t\t\t\"part\": " .. part .. "," .. "\n"
		text = text .. "\t\t\t\t\"tile\": " .. weapons[i].look .. "," .. "\n"
		text = text .. "\t\t\t\t\"color\": " .. weapons[i].lookC .. "," .. "\n"
		text = text .. "\t\t\t\t\"gender\": " .. weapons[i].sex .. "\n"
		text = text .. "\t\t\t}" .. "\n"
		text = text .. "\t\t\t]" .. "\n"

		if i == #weapons then
			text = text .. "\t\t}" .. "\n"
		else
			text = text .. "\t\t}," .. "\n"
		end
	end

	text = text .. "\t]," .. "\n"

	-------------------------

	-------------------------------
	text = text .. "\t\"necklaces\": [" .. "\n"

	for i = 1, #necklaces do
		local part = 6
		local icon = 0
		if necklaces[i].icon > 49152 then
			icon = necklaces[i].icon - 49152
		else
			icon = necklaces[i].icon
		end

		text = text .. "\t\t{" .. "\n"
		text = text .. "\t\t\t\"name\": \"" .. necklaces[i].name .. "\"\," .. "\n"
		text = text .. "\t\t\t\"tile\": " .. icon .. "\," .. "\n"
		text = text .. "\t\t\t\"color\": " .. necklaces[i].iconC .. "\," .. "\n"
		text = text .. "\t\t\t\"items\": [" .. "\n"
		text = text .. "\t\t\t{" .. "\n"
		text = text .. "\t\t\t\t\"part\": " .. part .. "," .. "\n"
		text = text .. "\t\t\t\t\"tile\": " .. necklaces[i].look .. "," .. "\n"
		text = text .. "\t\t\t\t\"color\": " .. necklaces[i].lookC .. "," .. "\n"
		text = text .. "\t\t\t\t\"gender\": " .. necklaces[i].sex .. "\n"
		text = text .. "\t\t\t}" .. "\n"
		text = text .. "\t\t\t]" .. "\n"

		if i == #necklaces then
			text = text .. "\t\t}" .. "\n"
		else
			text = text .. "\t\t}," .. "\n"
		end
	end

	text = text .. "\t]," .. "\n"

	-------------------------

	-------------------------------
	text = text .. "\t\"mounts\": [" .. "\n"

	for i = 1, #mounts do
		local part = 33
		local icon = 0
		if mounts[i].icon > 49152 then
			icon = mounts[i].icon - 49152
		else
			icon = mounts[i].icon
		end

		text = text .. "\t\t{" .. "\n"
		text = text .. "\t\t\t\"name\": \"" .. mounts[i].name .. "\"\," .. "\n"
		text = text .. "\t\t\t\"tile\": " .. icon .. "\," .. "\n"
		text = text .. "\t\t\t\"color\": " .. mounts[i].iconC .. "\," .. "\n"
		text = text .. "\t\t\t\"items\": [" .. "\n"
		text = text .. "\t\t\t{" .. "\n"
		text = text .. "\t\t\t\t\"part\": " .. part .. "," .. "\n"
		text = text .. "\t\t\t\t\"tile\": " .. math.floor(mounts[i].look / 32) .. "," .. "\n"
		text = text .. "\t\t\t\t\"color\": " .. ((mounts[i].look % 32) - 1) .. "," .. "\n"
		text = text .. "\t\t\t\t\"gender\": " .. mounts[i].sex .. "\n"
		text = text .. "\t\t\t}" .. "\n"
		text = text .. "\t\t\t]" .. "\n"

		if i == #mounts then
			text = text .. "\t\t}" .. "\n"
		else
			text = text .. "\t\t}," .. "\n"
		end
	end

	text = text .. "\t]," .. "\n"

	-------------------------

	-------------------------------
	text = text .. "\t\"face\": [" .. "\n"

	for i = 1, #face do
		local part = 22
		local icon = 0
		if face[i].icon > 49152 then
			icon = face[i].icon - 49152
		else
			icon = face[i].icon
		end

		if face[i].type == 11 then
			part = 22
		end

		-- shades
		if face[i].type == 29 then
			part = 22
		end

		if face[i].type == 25 then
			part = 30
		end

		-- face

		text = text .. "\t\t{" .. "\n"
		text = text .. "\t\t\t\"name\": \"" .. face[i].name .. "\"\," .. "\n"
		text = text .. "\t\t\t\"tile\": " .. icon .. "\," .. "\n"
		text = text .. "\t\t\t\"color\": " .. face[i].iconC .. "\," .. "\n"
		text = text .. "\t\t\t\"items\": [" .. "\n"
		text = text .. "\t\t\t{" .. "\n"
		text = text .. "\t\t\t\t\"part\": " .. part .. "," .. "\n"
		text = text .. "\t\t\t\t\"tile\": " .. face[i].look .. "," .. "\n"
		text = text .. "\t\t\t\t\"color\": " .. face[i].lookC .. "," .. "\n"
		text = text .. "\t\t\t\t\"gender\": " .. face[i].sex .. "\n"
		text = text .. "\t\t\t}" .. "\n"
		text = text .. "\t\t\t]" .. "\n"

		if i == #face then
			text = text .. "\t\t}" .. "\n"
		else
			text = text .. "\t\t}," .. "\n"
		end
	end

	text = text .. "\t]," .. "\n"

	-------------------------

	-------------------------------
	text = text .. "\t\"head\": [" .. "\n"

	for i = 1, #head do
		local part = 23
		local icon = 0
		if head[i].icon > 49152 then
			icon = head[i].icon - 49152
		else
			icon = head[i].icon
		end

		text = text .. "\t\t{" .. "\n"
		text = text .. "\t\t\t\"name\": \"" .. head[i].name .. "\"\," .. "\n"
		text = text .. "\t\t\t\"tile\": " .. icon .. "\," .. "\n"
		text = text .. "\t\t\t\"color\": " .. head[i].iconC .. "\," .. "\n"
		text = text .. "\t\t\t\"items\": [" .. "\n"
		text = text .. "\t\t\t{" .. "\n"
		text = text .. "\t\t\t\t\"part\": " .. part .. "," .. "\n"
		text = text .. "\t\t\t\t\"tile\": " .. head[i].look .. "," .. "\n"
		text = text .. "\t\t\t\t\"color\": " .. head[i].lookC .. "," .. "\n"
		text = text .. "\t\t\t\t\"gender\": " .. head[i].sex .. "\n"
		text = text .. "\t\t\t}" .. "\n"
		text = text .. "\t\t\t]" .. "\n"

		if i == #head then
			text = text .. "\t\t}" .. "\n"
		else
			text = text .. "\t\t}," .. "\n"
		end
	end

	text = text .. "\t]," .. "\n"

	-------------------------

	-------------------------------
	text = text .. "\t\"mantle\": [" .. "\n"

	for i = 1, #mantle do
		local part = 14
		local icon = 0
		if mantle[i].icon > 49152 then
			icon = mantle[i].icon - 49152
		else
			icon = mantle[i].icon
		end

		text = text .. "\t\t{" .. "\n"
		text = text .. "\t\t\t\"name\": \"" .. mantle[i].name .. "\"\," .. "\n"
		text = text .. "\t\t\t\"tile\": " .. icon .. "\," .. "\n"
		text = text .. "\t\t\t\"color\": " .. mantle[i].iconC .. "\," .. "\n"
		text = text .. "\t\t\t\"items\": [" .. "\n"
		text = text .. "\t\t\t{" .. "\n"
		text = text .. "\t\t\t\t\"part\": " .. part .. "," .. "\n"
		text = text .. "\t\t\t\t\"tile\": " .. mantle[i].look .. "," .. "\n"
		text = text .. "\t\t\t\t\"color\": " .. mantle[i].lookC .. "," .. "\n"
		text = text .. "\t\t\t\t\"gender\": " .. mantle[i].sex .. "\n"
		text = text .. "\t\t\t}" .. "\n"
		text = text .. "\t\t\t]" .. "\n"

		if i == #mantle then
			text = text .. "\t\t}" .. "\n"
		else
			text = text .. "\t\t}," .. "\n"
		end
	end

	text = text .. "\t]," .. "\n"

	-------------------------

	-------------------------------
	text = text .. "\t\"shoes\": [" .. "\n"

	for i = 1, #shoes do
		local part = 13
		local icon = 0
		if shoes[i].icon > 49152 then
			icon = shoes[i].icon - 49152
		else
			icon = shoes[i].icon
		end

		text = text .. "\t\t{" .. "\n"
		text = text .. "\t\t\t\"name\": \"" .. shoes[i].name .. "\"\," .. "\n"
		text = text .. "\t\t\t\"tile\": " .. icon .. "\," .. "\n"
		text = text .. "\t\t\t\"color\": " .. shoes[i].iconC .. "\," .. "\n"
		text = text .. "\t\t\t\"items\": [" .. "\n"
		text = text .. "\t\t\t{" .. "\n"
		text = text .. "\t\t\t\t\"part\": " .. part .. "," .. "\n"
		text = text .. "\t\t\t\t\"tile\": " .. shoes[i].look .. "," .. "\n"
		text = text .. "\t\t\t\t\"color\": " .. shoes[i].lookC .. "," .. "\n"
		text = text .. "\t\t\t\t\"gender\": " .. shoes[i].sex .. "\n"
		text = text .. "\t\t\t}" .. "\n"
		text = text .. "\t\t\t]" .. "\n"

		if i == #shoes then
			text = text .. "\t\t}" .. "\n"
		else
			text = text .. "\t\t}," .. "\n"
		end
	end

	text = text .. "\t]" .. "\n"

	text = text .. "}" .. "\n"

	-------------------------

	file1:write(text)

	file1:flush()
end
