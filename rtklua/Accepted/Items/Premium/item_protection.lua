item_protection = {
	use = async(function(player)
		local t = {graphic = convertGraphic(1439, "monster"), color = 0}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local item = player:getInventoryItem(player.invSlot)

		local opts = {}

		local weap = player:getEquippedItem(EQ_WEAP)
		local armor = player:getEquippedItem(EQ_ARMOR)
		local shield = player:getEquippedItem(EQ_SHIELD)
		local mantle = player:getEquippedItem(EQ_MANTLE)
		local helm = player:getEquippedItem(EQ_HELM)
		local crown = player:getEquippedItem(EQ_CROWN)
		local necklace = player:getEquippedItem(EQ_NECKLACE)
		local boots = player:getEquippedItem(EQ_BOOTS)
		local left = player:getEquippedItem(EQ_LEFT)
		local right = player:getEquippedItem(EQ_RIGHT)
		local subLeft = player:getEquippedItem(EQ_SUBLEFT)
		local subRight = player:getEquippedItem(EQ_SUBRIGHT)

		if (weap ~= nil) then
			table.insert(opts, "Weapon")
		end
		if (armor ~= nil) then
			table.insert(opts, "Armor")
		end
		if (shield ~= nil) then
			table.insert(opts, "Shield")
		end
		if (mantle ~= nil) then
			table.insert(opts, "Mantle")
		end
		if (crown ~= nil) then
			table.insert(opts, "Crown")
		end
		if (helm ~= nil) then
			table.insert(opts, "Helm")
		end
		if (necklace ~= nil) then
			table.insert(opts, "Necklace")
		end
		if (boots ~= nil) then
			table.insert(opts, "Boots")
		end
		if (left ~= nil) then
			table.insert(opts, "LHand")
		end
		if (right ~= nil) then
			table.insert(opts, "RHand")
		end
		if (subLeft ~= nil) then
			table.insert(opts, "SubAccessory(l)")
		end
		if (subRight ~= nil) then
			table.insert(opts, "SubAccessory(r)")
		end

		if (item.dura > item.maxDura) then
			item.dura = item.maxDura
		end

		--item.engrave = "Item Protection ["..item.dura.."/"..item.maxDura.."]"

		local uses = "You have " .. item.dura .. " out of " .. item.maxDura .. " uses remaining\n\n"

		local choice = player:menuString(
			"Hello " .. player.name .. ", please select an applicable equipment slot.\nNote: " .. uses,
			opts
		)

		local confirmation = player:menuString(
			uses .. "Are you sure you want to apply the item protection?",
			{"Yes", "No"}
		)

		local maxProtError = "Your " .. choice .. " already has maximum protections of 10."

		if (confirmation == "No") then
			return
		end

		-- Protections can not exceed 10 per Item--
		if (choice == "Weapon" and weap.protected + 1 > 10) then
			player:popUp(maxProtError)
			return
		elseif (choice == "Armor" and armor.protected + 1 > 10) then
			player:popUp(maxProtError)
			return
		elseif (choice == "Shield" and shield.protected + 1 > 10) then
			player:popUp(maxProtError)
			return
		elseif (choice == "Mantle" and mantle.protected + 1 > 10) then
			player:popUp(maxProtError)
			return
		elseif (choice == "Crown" and crown.protected + 1 > 10) then
			player:popUp(maxProtError)
			return
		elseif (choice == "Helm" and helm.protected + 1 > 10) then
			player:popUp(maxProtError)
			return
		elseif (choice == "Necklace" and necklace.protected + 1 > 10) then
			player:popUp(maxProtError)
			return
		elseif (choice == "Boots" and boots.protected + 1 > 10) then
			player:popUp(maxProtError)
			return
		elseif (choice == "LHand" and left.protected + 1 > 10) then
			player:popUp(maxProtError)
			return
		elseif (choice == "RHand" and right.protected + 1 > 10) then
			player:popUp(maxProtError)
			return
		elseif (choice == "SubAccessory(l)" and subLeft.protected + 1 > 10) then
			player:popUp(maxProtError)
			return
		elseif (choice == "SubAccessory(r)" and subRight.protected + 1 > 10) then
			player:popUp(maxProtError)
			return
		end

		if (choice == "Weapon") then
			weap.protected = weap.protected + 1
		elseif (choice == "Armor") then
			armor.protected = armor.protected + 1
		elseif (choice == "Shield") then
			shield.protected = shield.protected + 1
		elseif (choice == "Mantle") then
			mantle.protected = mantle.protected + 1
		elseif (choice == "Crown") then
			crown.protected = crown.protected + 1
		elseif (choice == "Helm") then
			helm.protected = helm.protected + 1
		elseif (choice == "Necklace") then
			necklace.protected = necklace.protected + 1
		elseif (choice == "Boots") then
			boots.protected = boots.protected + 1
		elseif (choice == "LHand") then
			left.protected = left.protected + 1
		elseif (choice == "RHand") then
			right.protected = right.protected + 1
		elseif (choice == "SubAccessory(l)") then
			subLeft.protected = subLeft.protected + 1
		elseif (choice == "SubAccessory(r)") then
			subRight.protected = subRight.protected + 1
		end

		item.dura = item.dura - 1

		if (item.dura <= 0) then
			player:removeItemSlot(player.invSlot, 1, 6)
		else
			player:sendMinitext("Your have applied item protection to your " .. choice .. ".\nYou have " .. item.dura .. " out of " .. item.maxDura .. " uses remaining")
		end
	end)
}

item_protection_i = {
	use = function(player)
		item_protection.use(player)
	end
}

item_protection_ii = {
	use = function(player)
		item_protection.use(player)
	end
}

item_protection_iii = {
	use = function(player)
		item_protection.use(player)
	end
}

item_protection_v = {
	use = function(player)
		item_protection.use(player)
	end
}
