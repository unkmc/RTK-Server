donor_scroll = {
	use = function(player)
		local invItem = player:getInventoryItem(player.invSlot)

		local scrollName = invItem.name
		if not player:canAction(1, 1, 1) then
			return
		end

		if player.state == 1 then
			player:sendMinitext("How can you open this with no hands?")
			return
		end

		if player:hasLegend("donor_tierone") then
			player:sendMinitext("Thanks for your contribution, but you already have the legend mark!")
			player:removeItemSlot(player.invSlot, 1, 9)
			return
		end
		if player:hasLegend("donor_tiertwo") then
			player:sendMinitext("Thanks for your contribution, but you already have the legend mark!")
			player:removeItemSlot(player.invSlot, 1, 9)
			return
		end
		if player:hasLegend("donor_tierthree") then
			player:sendMinitext("Thanks for your contribution, but you already have the legend mark!")
			player:removeItemSlot(player.invSlot, 1, 9)
			return
		end
		if player:hasLegend("donor_tierfour") then
			player:sendMinitext("Thanks for your contribution, but you already have the legend mark!")
			player:removeItemSlot(player.invSlot, 1, 9)
			return
		end
		if player:hasLegend("donor_tierfive") then
			player:sendMinitext("Thanks for your contribution, but you already have the legend mark!")
			player:removeItemSlot(player.invSlot, 1, 9)
			return
		end

		if scrollName == "Donor Scroll 1" then
			player:sendAnimation(278)
			player:sendAnimation(251)
			player:playSound(739)
			player:playSound(123)
			broadcast(
				-1,
				"[RTK Team] A huge thank you to " .. player.name .. " for their donation!"
			)
			player:addLegend(
				"Supporter of the Kingdoms (" .. curT() .. ")",
				"donor_tierone",
				20,
				9
			)
			player:removeItemSlot(player.invSlot, 1, 9)
		end

		if scrollName == "Donor Scroll 2" then
			player:sendAnimation(278)
			player:sendAnimation(251)
			player:playSound(739)
			player:playSound(123)
			broadcast(
				-1,
				"[RTK Team] A huge thank you to " .. player.name .. " for their great donation!"
			)
			player:addLegend(
				"Patron of the Kingdoms (" .. curT() .. ")",
				"donor_tiertwo",
				20,
				9
			)
			player:removeItemSlot(player.invSlot, 1, 9)
		end

		if scrollName == "Donor Scroll 3" then
			player:sendAnimation(278)
			player:sendAnimation(251)
			player:playSound(739)
			player:playSound(123)
			broadcast(
				-1,
				"[RTK Team] A huge thank you to " .. player.name .. " for their amazing donation!"
			)
			player:addLegend(
				"Benefactor of the Kingdoms (" .. curT() .. ")",
				"donor_tierthree",
				20,
				9
			)
			player:removeItemSlot(player.invSlot, 1, 9)
		end

		if scrollName == "Donor Scroll 4" then
			player:sendAnimation(278)
			player:sendAnimation(251)
			player:playSound(739)
			player:playSound(123)
			broadcast(
				-1,
				"[RTK Team] A huge thank you to " .. player.name .. " for their fantastic donation!"
			)
			player:addLegend(
				"Curator of the Kingdoms (" .. curT() .. ")",
				"donor_tierfour",
				20,
				9
			)
			player:removeItemSlot(player.invSlot, 1, 9)
		end

		if scrollName == "Donor Scroll 5" then
			player:sendAnimation(278)
			player:sendAnimation(251)
			player:playSound(739)
			player:playSound(123)
			broadcast(
				-1,
				"[RTK Team] A huge thank you to " .. player.name .. " for their astounding donation!"
			)
			player:addLegend(
				"Saviour of the Kingdoms (" .. curT() .. ")",
				"donor_tierfive",
				20,
				9
			)
			player:removeItemSlot(player.invSlot, 1, 9)
		end
	end
}

consumable = {
	cast = function(player)
		player:setAether("consumable", 1000)
		return
	end
}
