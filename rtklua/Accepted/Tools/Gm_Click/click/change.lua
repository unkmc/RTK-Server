change = {
	status = function(player, target, npc, type)
		local found, dialog, value, spouse, info, titlestats = 0, "", "", "", "", ""
		local number = {
			"level",
			"vita",
			"mana",
			"might",
			"will",
			"grace",
			"exp",
			"gold",
			"speed",
			"gmLevel"
		}
		if player.gmLevel > 0 then
			location = target.mapTitle .. "\n" .. target.m .. ", " .. target.x .. ", " .. target.y
		end
		if target.className == target:baseClassName(target.baseClass) then
			subpath = "None"
		else
			subpath = target.className
		end
		if target.spouse > 0 then
			spouse = Player(target.spouse).name
		else
			spouse = "None"
		end
		if target.registry["show_title"] == 0 then
			titlestats = "Hide"
		else
			titlestats = "Show"
		end
		info = "Totem   : " .. target:getTotemName(target.totem) .. "\n"
		info = info .. "Partner : " .. spouse .. ""
		local dialog = "<b>[" .. target.name .. "'s Status]\n\nClass    : " .. target:baseClassName(target.baseClass) .. "\nTotem    : " .. target:getTotemName(target.totem) .. "\nSubpath  : " .. subpath

		for i = 1, #number do
			if type == number[i] then
				change.choice(player, target, npc, type)
				return
			end
		end

		if type == "title" then
			titleC = {
				"Title  : " .. target.title,
				"Title Status (" .. titlestats .. ")"
			}
			titleM = player:menuString(
				"<b>[" .. target.name .. "'s Title]\n\nWhat to do with target's title?",
				titleC
			)
			if titleM == "Title  : " .. target.title then
				title = player:input("<b>[" .. target.name .. "'s Title]\n\nType a new title for " .. target.name .. ":\n\n<b>Note:\nType 'empty' to clear/remove target's title")
				if string.lower(title) == "empty" then
					target.title = ""
					target:sendStatus()
					target:sendMinitext("Your title has changed!")
					player:sendMinitext("Done!!")
					gm_click.status(player, target, npc, dialog)
					return
				else
					confirm = player:menuString(
						"<b>[" .. target.name .. "'s Title]\n\nAre you sure to change " .. target.name .. "'s title to:\n'" .. title .. "' ?",
						{"Yes", "No"}
					)
					if confirm == "Yes" then
						target.title = title
						target:sendStatus()
						target:sendMinitext("Your title has changed!")
						player:sendMinitext("Done!!")
						gm_click.status(player, target, npc, dialog)
					end
				end
			elseif titleM == "Title Status (" .. titlestats .. ")" then
				if target.registry["show_title"] == 0 then
					target.registry["show_title"] = 1
					target:sendMinitext("Show title : ON")
				else
					target.registry["show_title"] = 0
					target:sendMinitext("Show title : OFF")
				end
				target:updateState()
				player:sendMinitext("Done!!")
				gm_click.status(player, target, npc, dialog)
			end
			return
		end

		if type == "country" then
			menu = player:menuString(
				"<b>[" .. target.name .. "'s Country]\n\nCountry : " .. target:countryName(target.country) .. "\n\nChange " .. target.name .. "'s country to?",
				{"Buya", "Kugnae"}
			)
			if menu ~= nil then
				if menu == "Buya" then
					target.country = 2
				elseif menu == "Kugnae" then
					target.country = 1
				end
				target:calcStat()
				target:sendMinitext("Country changed to " .. target:countryName(target.country) .. "!")
				player:sendMinitext("Done!!")
				gm_click.status(player, target, npc, dialog)
			end
			return
		end

		if type == "clan" then
			local clan
			if target.clan > 0 then
				clan = target.clanName
			else
				clan = "None"
			end
			local clanC = {}
			if target.clan > 0 and target.clanName ~= nil then
				table.insert(clanC, "Clan info")
			end
			table.insert(clanC, "Move " .. target.name .. " to specified clan")
			table.insert(clanC, "Clan title : " .. target.clanTitle)
			menu = player:menuString(
				"<b>[" .. target.name .. "'s Clan]\n\nClan : " .. clan .. "\n\nWhat to do?",
				clanC
			)
			if menu ~= nil then
				if menu == "Clan info" then
				elseif menu == "Move " .. target.name .. " to specified clan" then
				elseif menu == "Clan title : " .. target.clanTitle then
				end
				player:popUp("Not implemented yet!")
				return
			end
		end
	end,

	choice = function(player, target, npc, type)
		if not player.ID == 2 and not player.ID == 4 and not player.ID == 7 then
			player:popUp("You don't have a permission to change stats")
			return false
		else
			player.dialogType = 2
			local change, value, dialog = 0, 0, "<b>[" .. target.name .. "'s " .. type .. "]\n\n"
			if type == "level" then
				value = target.level
			end
			if type == "vita" then
				value = target.baseHealth
			end
			if type == "mana" then
				value = target.baseMagic
			end
			if type == "might" then
				value = target.basemight
			end
			if type == "will" then
				value = target.basewill
			end
			if type == "grace" then
				value = target.basegrace
			end
			if type == "armor" then
				value = target.basearmor
			end
			if type == "exp" then
				value = target.exp
			end

			if type == "gold" then
				value = target.money
			end
			if type == "speed" then
				value = target.speed
			end
			if type == "fury" then
				value = target.fury
			end

			local opts = {"Add/Increase", "Remove/Decrease", "Change value"}
			local confirmC = {"Confirm", "Cancel"}
			how = player:menuSeq(
				dialog .. "" .. type .. ": " .. Tools.formatNumber(value) .. "\n\nHow do you to want change " .. target.name .. "'s " .. type .. "?",
				opts,
				{}
			)
			if how == 1 then
				increase = tonumber(math.floor(player:input(dialog .. "Current : " .. Tools.formatNumber(value) .. "\n\nHow much of " .. type .. " should be added to " .. target.name .. "?")))
				if value + increase > 4294967295 then
					anim(player)
					player:sendMinitext("Error value!")
					click.status(player, target, npc, dialog)
					return
				elseif type == "level" and value + increase > 99 then
					anim(player)
					player:sendMinitext("Error value!")
					click.status(player, target, npc, dialog)
					return
				elseif increase > 0 then
					confirm = player:menuString(
						dialog .. "Before   : " .. Tools.formatNumber(value) .. "\nIncrease : " .. Tools.formatNumber(increase) .. "\n------------------ +\nAfter >> " .. Tools.formatNumber(value + increase) .. "\nConfirm your choice",
						confirmC
					)
					if confirm == "Confirm" then
						historyWrite(player, target, type, increase, "add")
						click.status(player, target, npc, dialog)
						return
					end
				end
			elseif how == 2 then
				decrease = tonumber(math.floor(player:input(dialog .. "Current : " .. Tools.formatNumber(value) .. "\nHow much of " .. type .. " should be decreased from " .. target.name .. "?")))
				if value - decrease <= 0 then
					if type == "vita" or type == "mana" or type == "level" then
						anim(player)
						player:sendMinitext("You may not change value to negative/zero(0) number")
						click.status(player, target, npc, dialog)
					end
					return
				else
					confirm = player:menuString(
						dialog .. "Before   : " .. Tools.formatNumber(value) .. "\nDecrease : " .. Tools.formatNumber(decrease) .. "\n------------------ -\nAfter >> " .. Tools.formatNumber(value - decrease) .. "\nConfirm your choice",
						confirmC
					)
					if confirm == "Confirm" then
						historyWrite(player, target, type, decrease, "remove")
						click.status(player, target, npc, dialog)
						return
					end
				end
			elseif how == 3 then
				input = tonumber(math.floor(player:input(dialog .. "Current : " .. Tools.formatNumber(value) .. "\n\nChange " .. target.name .. "'s " .. type .. " to: ")))
				if input >= 0 then
					confirm = player:menuString(
						dialog .. "Before : " .. Tools.formatNumber(value) .. "\nChange to : " .. Tools.formatNumber(input) .. "\n\nConfirm your choice",
						confirmC
					)
					if confirm == "Confirm" then
						historyWrite(player, target, type, input, "change")
						click.status(player, target, npc, dialog)
					end
				end
			end
		end
	end
}

historyWrite = function(player, target, stats, value, type)
	local dir, text = "../mornalua/History/status_changed.txt", ""
	local file = io.open(dir, "a+")
	local class = {
		"level",
		"vita",
		"mana",
		"might",
		"will",
		"grace",
		"armor",
		"exp",
		"gold",
		"speed",
		"gmLevel",
		"PP",
		"EP",
		"BP",
		"FP"
	}
	local change = {
		target.level,
		target.baseHealth,
		target.baseMagic,
		target.might,
		target.will,
		target.grace,
		target.exp,
		target.money,
		target.speed,
		target.gmLevel,
		target.pp,
		target.ep,
		target.bp,
		target.fp
	}
	local x = 0

	for i = 1, #class do
		if stats == class[i] then
			x = i
			break
		end
	end
	if x == 0 then
		return nil
	else
		target.registry[stats .. "_before"] = change[x]
		if type == "add" then
			if stats == "level" or stats == "speed" or stats == "gmLevel" then
				if change[x] + value > 99 then
					player:msg(
						4,
						"[Error] " .. player.name .. " -> Target: " .. target.name .. " (Max " .. stats .. ": 99) " .. os.date(),
						player.ID
					)
					print("[Error] " .. player.name .. " -> Target: " .. target.name .. " (Max " .. stats .. ": 99) " .. os.date())
					return
				else
					change[x] = change[x] + value
				end
			else
				if change[x] + value > core.ID then
					player:msg(
						4,
						"[Error] " .. player.name .. " -> Target: " .. target.name .. " (Max " .. stats .. ": " .. core.ID .. ") " .. os.date(),
						player.ID
					)
					print("[Error] " .. player.name .. " -> Target: " .. target.name .. " (Max " .. stats .. ": " .. core.ID .. ") " .. os.date())
					return
				else
					change[x] = change[x] + value
				end
			end
		elseif type == "remove" then
			if stats == "level" or stats == "vita" or stats == "mana" then
				if change[x] - value < 0 then
					player:msg(
						4,
						"[Error] " .. player.name .. " -> Target: " .. target.name .. " (Min " .. stats .. ": 1) " .. os.date(),
						player.ID
					)
					print("[Error] " .. player.name .. " -> Target: " .. target.name .. " (Min " .. stats .. ": 1) " .. os.date())
					return
				else
					change[x] = change[x] - value
				end
			else
				change[x] = change[x] - value
			end
		elseif type == "change" then
			if value == 0 then
				if stats == "level" or stats == "vita" or stats == "mana" then
					player:msg(
						4,
						"[Error] " .. player.name .. " -> Target: " .. target.name .. " (Min " .. stats .. ": 1) " .. os.date(),
						player.ID
					)
					print("[Error] " .. player.name .. " -> Target: " .. target.name .. " (Min " .. stats .. ": 1) " .. os.date())
					return
				end
			else
				change[x] = value
			end
		end
		if stats == "level" then
			target.level = change[x]
		end
		if stats == "vita" then
			target.baseHealth = change[x]
		end
		if stats == "mana" then
			target.baseMagic = change[x]
		end
		if stats == "might" then
			target.basemight = change[x]
		end
		if stats == "will" then
			target.basewill = change[x]
		end
		if stats == "grace" then
			target.basegrace = change[x]
		end
		if stats == "armor" then
			target.basearmor = change[x]
		end
		if stats == "exp" then
			target.exp = change[x]
		end
		if stats == "gold" then
			target.money = change[x]
		end
		if stats == "speed" then
			target.speed = change[x]
		end
		if stats == "PP" then
			target.pp = change[x]
		end
		if stats == "EP" then
			target.ep = change[x]
		end
		if stats == "FP" then
			target.fp = change[x]
		end
		if stats == "BP" then
			target.bp = change[x]
		end
		if stats == "gmLevel" and player.ID == 2 then
			target.gmLevel = change[x]
		end

		target:calcStat()
		target:sendStatus()
		target:updateState()

		text = "--- [" .. string.upper(stats) .. " CHANGE] --------------------------------------------------------- >> " .. os.date() .. "\n"
		text = text .. "Target : " .. target.name .. " =======> (changed by : " .. player.name .. ")\n"
		text = text .. "" .. string.upper(stats) .. " Before  : " .. Tools.formatNumber(target.registry[stats .. "_before"]) .. "\n"
		text = text .. "" .. string.upper(stats) .. " After   : " .. Tools.formatNumber(change[x]) .. "\n\n"

		text = "==== [" .. stats .. " change] ================================================================[ by: " .. player.name .. " ]===\n"
		text = text .. "Target          : " .. target.name .. "\n"
		text = text .. "" .. stats .. " before      : " .. Tools.formatNumber(target.registry[stats .. "_before"]) .. "\n"
		text = text .. "" .. stats .. " after       : " .. Tools.formatNumber(change[x]) .. "\n"
		text = text .. "Date & Time     : " .. os.date() .. "\n\n"

		file:write(text .. "")
		file:flush()
		print([[  ========================= [Character status edit] =========================]])
		print([[  =                                                                         =]])
		print([[  =           Added changed status information and details to :             =]])
		print([[  =        ('/root/Morna/mornalua/History/status_changed.txt')              =]])
		print([[  =                                                                         =]])
		print([[  ===========================================================================]])

		if Player(2) ~= nil then
			god = Player(2)
			god:msg(
				4,
				"[Status Edit] " .. player.name .. " just change " .. target.name .. "'s " .. stats .. "!",
				god.ID
			)
			god:msg(
				4,
				target.name .. "'s " .. stats .. " before(" .. Tools.formatNumber(target.registry[stats .. "_before"]) .. ") ~> (" .. Tools.formatNumber(change[x]) .. ")",
				god.ID
			)
		end

		target:sendMinitext("Your " .. stats .. " changed!")
		player:sendMinitext("Done!!")
	end
end
