questtracker = {
	displayquest = function(player)
		local text = ""

		local showQuestTracker = true

		if player:canPK(player) then
			showQuestTracker = false
		end

		if showQuestTracker then
			if player.baseClass == 1 then
				if (player.quest["star_armor"] == 1) then
					if (player.m >= 160 and player.m <= 169) then
						local mob1 = player:killCount("spry_monkey")
						local mob2 = player:killCount("agile_monkey")
						local mob3 = player:killCount("fast_monkey")
						local killCount = mob1 + mob2 + mob3
						local maxKills = 18

						if (killCount > maxKills) then
							killCount = maxKills
						end

						text = text .. "==Warrior Star 1==\n"
						text = text .. "Fast Monkeys         " .. killCount .. "/" .. maxKills .. "\n\n"
					end
				end
				if (player.quest["star_armor"] == 2) then
					local item1 = player:hasItem("titanium_glove", 2)
					local item1max = 2
					if (item1 == true) then
						item1 = item1max
					end

					text = text .. "==Warrior Star 2==\n"
					text = text .. "Titanium Glove           " .. item1 .. "/" .. item1max .. "\n"
				end
				if (player.quest["star_armor"] == 3) then
					local item1 = player:hasItem("electra", 1)
					local item1max = 1
					if (item1 == true) then
						item1 = item1max
					end

					text = text .. "==Warrior Star 3==\n"
					text = text .. "Electra                  " .. item1 .. "/" .. item1max .. "\n"
				end

				if (player.quest["moon_armor"] == 1) then
					if (player.m >= 181 and player.m <= 190) then
						local mob1 = player:killCount("boar_champion")
						local mob2 = player:killCount("pig_champion")
						local mob3 = player:killCount("pig_avenger")
						local killCount = mob1 + mob2 + mob3
						local maxKills = 1

						if (killCount > maxKills) then
							killCount = maxKills
						end

						text = text .. "==Warrior Moon 1==\n"
						text = text .. "Glowing Pig          " .. killCount .. "/" .. maxKills .. "\n\n"
					end
				end
				if (player.quest["moon_armor"] == 2) then
					if (player.m >= 191 and player.m <= 200) then
						local mob1 = player:killCount("mad_dog")
						local mob2 = player:killCount("crazed_mongrel")
						local mob3 = player:killCount("frothing_mutt")
						local killCount = mob1 + mob2 + mob3
						local maxKills = 30

						if (killCount > maxKills) then
							killCount = maxKills
						end

						text = text .. "==Warrior Moon 2==\n"
						text = text .. "Dogs                 " .. killCount .. "/" .. maxKills .. "\n\n"
					end
				end
				if (player.quest["moon_armor"] == 3) then
					if (player.m >= 141 and player.m <= 150) then
						local mob1 = player:killCount(155)
						local killCount = mob1
						local maxKills = 20
						local item1 = player:hasItem("amber", 20)
						local item1max = 20
						if (item1 == true) then
							item1 = item1max
						end

						if (killCount > maxKills) then
							killCount = maxKills
						end

						text = text .. "==Warrior Moon 3==\n"
						text = text .. "Grim Ogres           " .. killCount .. "/" .. maxKills .. "\n"
						text = text .. "Amber                " .. item1 .. "/" .. item1max .. "\n"
					end
				end
				if (player.quest["moon_armor"] == 4) then
					local item1 = player:hasItem("electra", 1)
					local item1max = 3
					if (item1 == true) then
						item1 = item1max
					end

					local item2 = player:hasItem("titanium_glove", 1)
					local item2max = 1
					if (item2 == true) then
						item2 = item2max
					end

					text = text .. "==Warrior Moon 4==\n"
					text = text .. "Electra                  " .. item1 .. "/" .. item1max .. "\n"
					text = text .. "Titanium Glove           " .. item2 .. "/" .. item2max .. "\n"
				end

				--[[
		if(player.registry["squirrelquest"] == 1) then
			local mob2 = player:killCount(2)
			local mob3 = player:killCount(3)
			local mob4 = player:killCount(4)
			local mob2max = 75
			local mob3max = 50
			local mob4max = 1
			local acorn = player:hasItem(5,200)
			local acornmax = 200

			if(acorn == true) then acorn=acornmax end
			if(mob2 > mob2max) then mob2=mob2max end
			if(mob3 > mob3max) then mob3=mob3max end
			if(mob4 > mob4max) then mob4=mob4max end

			text = text.."==Squirrel Extermination==\n"
			text = text.."Acorns                "..acorn.."/"..acornmax.."\n"
			text = text.."Brown Squirrel        "..mob2.."/"..mob2max.."\n"
			text = text.."Red Squirrel          "..mob3.."/"..mob3max.."\n"
			text = text.."Squirrel King         "..mob4.."/"..mob4max.."\n\n"
		end
		if(player.registry["sewerquest"] == 1) then
			local mob17 = player:killCount(17)
			local mob16 = player:killCount(16)
			local mob17max = 1
			local mob16max = 1

			if(mob17 > mob17max) then mob17=mob17max end
			if(mob16 > mob16max) then mob16=mob16max end

			text = text.."==Sewer Clean Up==\n"
			text = text.."Ammatar              "..mob17.."/"..mob17max.."\n"
			text = text.."Drazok               "..mob16.."/"..mob16max.."\n\n"
		end
		if(player.registry["westquest"] == 1) then
			local mob17 = player:killCount(14)
			local mob17max = 200

			if(mob17 > mob17max) then mob17=mob17max end

			text = text.."==Stop The Fighting==\n"
			text = text.."West Cave Fighters  "..mob17.."/"..mob17max.."\n\n"
		end
		if(player.registry["havarthquest"] == 1) then
			local mob17 = player:killCount(15)
			local mob17max = 1

			if(mob17 > mob17max) then mob17=mob17max end

			text = text.."==A Really Bad Guy==\n"
			text = text.."Havarth             "..mob17.."/"..mob17max.."\n\n"
		end
		if(player.registry["wellquest"] == 1) then
			local mob2 = player:killCount(20)
			local mob3 = player:killCount(21)
			local mob4 = player:killCount(22)
			local mob2max = 50
			local mob3max = 50
			local mob4max = 1

			if(mob2 > mob2max) then mob2=mob2max end
			if(mob3 > mob3max) then mob3=mob3max end
			if(mob4 > mob4max) then mob4=mob4max end

			text = text.."==Thwarting Alligator Aggression==\n"
			text = text.."Green Alligator       "..mob2.."/"..mob2max.."\n"
			text = text.."Gray Alligator        "..mob3.."/"..mob3max.."\n"
			text = text.."Sobek                 "..mob4.."/"..mob4max.."\n\n"
		end
		if(player.registry["batquest"] == 1) then
			local batmeat = player:hasItem(10628,30)
			local batmeatmax = 30

			if(batmeat == true) then batmeat=batmeatmax end

			text = text.."==Bat Meat Stew==\n"
			text = text.."Bat meat              "..batmeat.."/"..batmeatmax.."\n\n"
		end
		if(player.registry["plaguequest"] == 1) then
			local mob2 = player:killCount(25)
			local mob2max = 1

			if(mob2 > mob2max) then mob2=mob2max end

			text = text.."==Curbing The Plague==\n"
			text = text.."Plague Bat            "..mob2.."/"..mob2max.."\n\n"
		end
		if(player.registry["monkeyquest"] == 1) then
			local mob2 = player:killCount(77)
			local mob3 = player:killCount(78)
			local mob4 = player:killCount(79)
			local mob2max = 30
			local mob3max = 30
			local mob4max = 30
			local banana = player:hasItem(10634,12)
			local bananamax = 12

			if(mob2 > mob2max) then mob2=mob2max end
			if(mob3 > mob3max) then mob3=mob3max end
			if(mob4 > mob4max) then mob4=mob4max end
			if(banana == true) then banana=bananamax end

			text = text.."==Monkey Business==\n"
			text = text.."Brown Monkey          "..mob2.."/"..mob2max.."\n"
			text = text.."Yellow Monkey         "..mob3.."/"..mob3max.."\n"
			text = text.."Red Monkey            "..mob4.."/"..mob4max.."\n"
			text = text.."Banana                "..banana.."/"..bananamax.."\n\n"
		end
		if(player.registry["bananaquest"] == 1) then
			local banana = player:hasItem(10634,12)
			local bananamax = 12

			if(banana == true) then banana=bananamax end

			text = text.."==Bunches of Bananas==\n"
			text = text.."Banana                "..banana.."/"..bananamax.."\n\n"
		end
		if(player.registry["monkeybossquest"] == 1) then
			local mob4 = player:killCount(81)
			local mob4max = 1

			if(mob4 > mob4max) then mob4=mob4max end

			text = text.."==King of the Jungle==\n"
			text = text.."Monkey Lord           "..mob4.."/"..mob4max.."\n\n"
		end
		if(player.registry["bearquest"] == 1) then
			local mob4 = player:killCount(87)
			local mob4max = 75

			if(mob4 > mob4max) then mob4=mob4max end

			text = text.."==Bear Threat==\n"
			text = text.."Brown Bear           "..mob4.."/"..mob4max.."\n\n"
		end
		if(player.registry["slagquest"] == 1) then
			local slag = player:hasItem(10718,100)
			local slagmax = 100

			if(slag == true) then slag=slagmax end

			text = text.."==Slag Mines==\n"
			text = text.."Earth Slag            "..slag.."/"..slagmax.."\n\n"
		end
		if(player.registry["catquest"] == 1) then
			local banana = player:hasItem(11104,5)
			local bananamax = 5

			if(banana == true) then banana=bananamax end

			text = text.."==Golden Sphinx==\n"
			text = text.."Gold coin             "..banana.."/"..bananamax.."\n\n"
		end
		if(player.registry["beequest"] == 1) then
			local honey = player:hasItem(10652,75)
			local honeymax = 75

			if(honey == true) then honey=honeymax end

			text = text.."==Sweet as Honey==\n"
			text = text.."Raw Honey            "..honey.."/"..honeymax.."\n\n"
		end
		if(player.m >= 2200 and player.m <= 2299) then
			if(player.registry["mansionquest"] == 1) then
				local bone = player:hasItem(11110,20)
				local bonemax = 20

				if(bone == true) then bone=bonemax end

				text = text.."==Bones, Many Bones!==\n"
				text = text.."Scourged Bones            "..bone.."/"..bonemax.."\n\n"
			end
		end
		if(player.m >= 2300 and player.m <= 2399) then
			if(player.registry["turtlequest"] == 1) then
				local total = player:killCount(111) + player:killCount(112) + player:killCount(113) + player:killCount(114)
				totalmax = 125

				if(total > totalmax) then total=totalmax end

				text = text.."==Turtle Eradication==\n"
				text = text.."Hard Shells         "..total.."/"..totalmax.."\n"
			end
		end
]]
				--
			end

			--player:guitext(text)
		end
	end
}
