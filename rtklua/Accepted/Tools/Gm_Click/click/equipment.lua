equipment = {
	items = function(player, target, npc)
		npc = core

		if target.gfxClone == 0 then
			clone.equip(target, npc)
		else
			clone.gfx(target, npc)
		end

		player.dialogType = 0
		local dialog = "<b>[" .. target.name .. "'s equipments]\n\nIt's all of target's equipped item.. Select one to continue..."
		local itemType = {
			"Armor      :",
			"Shield     :",
			"Helm       :",
			"Left Hand  :",
			"Right Hand :",
			"Left Acc   :",
			"Right Acc  :",
			"Face Acc   :",
			"Crown      :",
			"Mantle     :",
			"Necklace   :",
			"Boots      :",
			"Coat       :",
			"Face Acc (Hidden)  :"
		}
		local equipped = {}
		local equip
		local weapon = target:getEquippedItem(EQ_WEAP)
		if weapon ~= nil then
			table.insert(
				equipped,
				"Weapon     : " .. weapon.name .. " (" .. math.floor((weapon.dura / weapon.maxDura) * 100) .. "%)"
			)
		else
			table.insert(equipped, "Weapon     : none")
		end

		for i = 1, 14 do
			equip = target:getEquippedItem(i)
			if equip ~= nil then
				table.insert(
					equipped,
					itemType[i] .. " " .. equip.name .. " (" .. math.floor((equip.dura / equip.maxDura) * 100) .. "%)"
				)
			else
				table.insert(equipped, itemType[i] .. " none")
			end
		end

		menu = player:menuSeq(dialog, equipped, {})
		equipment.choice(player, target, npc, menu)
	end,

	choice = function(player, target, npc, num)
		local item = target:getEquippedItem(num - 1)
		local opts = {"Strip item", "View  status", "Take it", "Delete item"}

		if item ~= nil then
			local dialog = "<b>[" .. target.name .. "'s equipments]\n\n"
			icon = {graphic = item.icon, color = item.iconC}
			player.npcGraphic = icon.graphic
			player.npcColor = icon.color
			player.dialogType = 0

			menu = player:menuSeq(
				dialog .. "What would you do with target's " .. item.name .. "?",
				opts,
				{}
			)
			if menu == 1 then
				how = {
					"Force to unequip",
					"Unequip and put to target's bank",
					"Force to unequip & item'll drop on ground",
					"Delete item"
				}
				strip = player:menuSeq(
					dialog .. "How do want you strip this item from target?",
					how,
					{}
				)
				if strip == 1 then
					if target:hasSpace(item.id, 1) then
						target:stripEquip(num - 1, 0, 1)

						--anim(target)
						player:sendMinitext("Done!!")
						equipment.items(player, target, npc)
						return
					else
						full = player:menuString(
							dialog .. "Target's inventory is full!",
							{
								"Unequip and put to target's bank",
								"Force unequip & item'll drop on ground",
								"Delete item",
								"Look at target's inventory"
							}
						)
						if full == "Unequip and put to target's bank" then
							equipment.putToBank(player, target, item, npc)
						elseif full == "Force unequip & item'll drop on ground" then
							player:popUp("masih di kerjakan")
						elseif full == "Delete item" then
							target:stripEquip(num - 1, 1)
							player:sendMinitext("Done!!")
							equipment.items(player, target, npc)
						elseif full == "Look at target's inventory" then
							inventory.view(player, target)
						end
					end
				elseif strip == 2 then
					equipment.putToBank(player, target, item, npc)
				elseif strip == 3 then
					target:stripEquip(num - 1, 0, 1)
					anim(target)
					player:sendMinitext("Done!!")
					equipment.items(player, target, npc)
				elseif strip == 4 then
					target:stripEquip(num - 1, 1)
					anim(target)
					player:sendMinitext("Done!!")
					equipment.items(player, target, npc)
				end
			elseif menu == 2 then
				equipment.status(player, target, item)
			elseif menu == 3 then
				player:addItem(item.id, 1)
				target:stripEquip(num - 1, 1)
				player:sendMinitext("Done!!")
				equipment.items(player, target, npc)
			elseif menu == 4 then
				target:stripEquip(num - 1, 1)
				equipment.items(player, target, npc)
			end
		else
			equipment.items(player, target, npc)
		end
	end
}
