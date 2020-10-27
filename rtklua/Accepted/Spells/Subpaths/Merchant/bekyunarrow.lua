bekyunarrow = {
	cast = function(player)
		local aethers = 10000000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if player.gmLevel ~= 0 then
			aethers = 0
		end

		local item = Item("bekyuns_spear")

		local t = {graphic = item.icon, color = item.iconC}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		player:sendMinitext("You cast BekyunArrow.")
		player:setAether("bekyunarrow", aethers)

		player.attacker = player.ID
		player.health = player.health + math.floor(player.health * 0.025)
		player.magic = player.magic + math.floor(player.magic * 0.025)
		player:sendStatus()

		if player:hasItem(item.yname, 1) ~= true then
			player:dialogSeq({t, "You need his spear to craft arrows from."}, 0)
			return
		end

		if not player:hasSpace("bekyuns_set", 5) then
			player:sendMinitext("Your inventory is full.")
			return
		end

		player:removeItem(item.yname, 1, 9)
		player:addItem("bekyuns_set", 5)
	end,

	requirements = function(player)
		local level = 99
		local items = {"blood", "scribes_book", "merchant_token", 0}
		local itemAmounts = {1, 1, 1, 100000}
		local description = "Marks a treasure spot to be found."
		return level, items, itemAmounts, description
	end
}
