read_karma_diviner = {
	cast = async(function(player)
		local t = {}

		player.npcGraphic = 0
		player.npcColor = 0
		player.dialogType = 0
		player.lastClick = player.ID

		local magicCost = 250

		if (not player:canCast(0, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local input = player:inputLetterCheck(player:inputSeq(
			"Who's karma shall you read?",
			"The one known as",
			"shall be examined.",
			{},
			{}
		))
		local target = Player(input)

		if target == nil then
			player:dialogSeq({t, "Player is not online or unavailable."}, 0)
			return
		end

		--if target.ID == player.ID then player:dialogSeq({t,"You cannot assess your own karma."},0) return end

		player.magic = player.magic - magicCost
		player:sendStatus()

		local karma = target.karma
		local text = ""
		local text2 = ""

		--t = {graphic = convertGraphic(111, "monster"), color = 0}

		if karma <= -3 then
			-- snake
			t = {graphic = convertGraphic(184, "monster"), color = 25}
			text = target.name .. " is among the cursed of the earth; they crawl alone in shame."
			text2 = "You are among the cursed of the earth; you crawl alone in shame."
		elseif karma > -3 and karma < 0 then
			-- rat
			t = {graphic = convertGraphic(91, "monster"), color = 10}
			text = target.name .. " is out of favor with the Gods; they must purify their soul and cleanse their spirit."
			text2 = "You are out of favor with the Gods; you must purify your soul and cleanse your spirit."
		elseif karma >= 0 and karma < 1 then
			-- cat
			t = {graphic = convertGraphic(182, "monster"), color = 30}
			text = target.name .. " has begun the journey to perfection."
			text2 = "You have begun the journey to perfection."
		elseif karma >= 1 and karma < 2 then
			-- squirrel
			t = {graphic = convertGraphic(25, "monster"), color = 9}
			text = target.name .. "'s education progresses; they store knowledge for the ordeals to come."
			text2 = "Your education progresses; you store knowledge for the ordeals to come."
		elseif karma >= 2 and karma < 3 then
			-- rabbit
			t = {graphic = convertGraphic(21, "monster"), color = 3}
			text = target.name .. "'s soul moves ever quicker toward its goal."
			text2 = "Your soul moves ever quicker toward its goal."
		elseif karma >= 3 and karma < 4 then
			-- dog
			t = {graphic = convertGraphic(18, "monster"), color = 12}
			text = target.name .. " is faithful to the teachings of the Gods."
			text2 = "You are faithful to the teachings of the Gods."
		elseif karma >= 4 and karma < 6 then
			-- monkey
			t = {graphic = convertGraphic(126, "monster"), color = 5}
			text = target.name .. " is clever and good-hearted; the Gods smile upon them."
			text2 = "You are clever and good-hearted; the Gods smile upon you."
		elseif karma >= 6 and karma < 8 then
			-- ox
			t = {graphic = convertGraphic(27, "monster"), color = 9}
			text = target.name .. " is stalwart and honest, worthy of trust, strong of heart."
			text2 = "You are stalwart and honest, worthy of trust, strong of heart."
		elseif karma >= 8 and karma < 11 then
			-- bear
			t = {graphic = convertGraphic(24, "monster"), color = 9}
			text = target.name .. " holds quiet power and and great wisdom, confidence and fortitude."
			text2 = "You hold quiet power and and great wisdom, confidence and fortitude."
		elseif karma >= 11 and karma < 14 then
			-- tiger
			t = {graphic = convertGraphic(29, "monster"), color = 9}
			text = target.name .. " has entered the nobility of souls -- fierce, wise and just."
			text2 = "You have entered the nobility of souls -- fierce, wise and just."
		elseif karma >= 14 and karma < 19 then
			-- dragon
			t = {graphic = convertGraphic(108, "monster"), color = 2}
			text = target.name .. " is at the pinnacle of mortal grace; their soul is noble, beautiful and fearsome to behold."
			text2 = "You are at the pinnacle of mortal grace; your soul is noble, beautiful and fearsome to behold."
		elseif karma >= 19 and karma < 24 then
			-- spirit
			t = {graphic = convertGraphic(167, "monster"), color = 24}
			text = target.name .. " has reached the threshold of immortality; they put aside mortal possessions and passions."
			text2 = "You have reached the threshold of immortality; you put aside mortal possessions and passions."
		elseif karma >= 24 and karma < 30 then
			-- angel's tear
			t = {graphic = convertGraphic(428, "item"), color = 0}
			text = target.name .. "'s journey has been long; they have achieved inner peace and tranquility; they speak with the Gods."
			text2 = "Your journey has been long; you have achieved inner peace and tranquility; you speak with the Gods."
		elseif karma >= 30 then
			-- angel
			t = {graphic = convertGraphic(49, "monster"), color = 5}
			text = target.name .. " is one with the Gods, and their soul is worthy to dwell among them."
			text2 = "You are one with the Gods, and your soul is worthy to dwell among them."
		end

		player:setAether("read_karma_diviner", 88000)

		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = player.ID

		player:dialogSeq({t, text}, 1)

		target.npcGraphic = t.graphic
		target.npcColor = t.color
		target.dialogType = 0
		target.lastClick = player.ID

		target:freeAsync()
		target:dialogSeq({t, text2}, 0)
	end),

	requirements = function(player)
		local level = 60
		local items = {Item("acorn").id, Item("light_fox_fur").id, 0}
		local itemAmounts = {70, 20, 50}
		local description = "Assess target karma"
		return level, items, itemAmounts, description
	end
}
