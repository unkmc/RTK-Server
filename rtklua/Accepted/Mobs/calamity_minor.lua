calamity_minor = {
	on_spawn = function(mob)
		mob:sendAnimation(3)
		mob:playSound(18)
		mob:talk(1, "HAHAHA, FOOLS. MONTY HAS MADE THIS SO EASY FOR ME.")
		mob:talk(1, "HIS SHARED HATRED FOR YOU ALL HAS ALLOWED ME TO... JOIN")
		mob:talk(1, "THESE FESTIVITIES.")
	end,

	move = function(mob, target)
		if target ~= nil then
			if math.random(1, 20) == 10 then
				mob:talk(2, "RUNNING AWAY? PATHETIC!")
			end
		end

		if mob.paralyzed == true then
			mob.paralyzed = false
			mob:sendAnimation(5)
			mob:playSound(708)
			mob:talk(2, "FOOLS, YOU CANNOT BIND ME!")
			return
		end

		mob_ai_basic.move(mob, target)
	end,

	after_death = function(mob)
		mob:talk(2, "This...  this is not possible! Defeated by mortals?")
	end,

	attack = function(mob, target)
		if math.random(1, 5) == 1 then
			mob:talk(143, "INTO THE VOID!")
			mob:playSound(96)
			target:sendAnimation(6)
			target:removeHealthExtend(9999999, 1, 1, 1, 1, 0)
		end

		if math.random(1, 40) == 11 then
			mob:talk(143, "INTO THE VOID!")
			mob:playSound(96)
			target:sendAnimation(6)
			target:removeHealthExtend(9999999, 1, 1, 1, 1, 0)
		end

		if math.random(1, 5) == 2 then
			mob:talk(143, "AWAY YOU GO!")
			mob:playSound(14)
			target:sendAnimation(352)
			target:removeHealthExtend(9999999, 1, 1, 1, 1, 0)
		end

		if math.random(1, 40) == 13 then
			mob:talk(143, "AWAY YOU GO!")
			mob:playSound(14)
			target:sendAnimation(352)
			target:removeHealthExtend(9999999, 1, 1, 1, 1, 0)
		end

		if math.random(1, 5) == 3 then
			mob:talk(2, "Calamity: HMPH!")
			mob:playSound(20)
			target:sendAnimation(202)
			target:removeHealthExtend(9999999, 1, 1, 1, 1, 0)
		end

		if math.random(1, 40) == 7 then
			mob:talk(2, "Calamity: HMPH!")
			mob:playSound(20)
			target:sendAnimation(202)
			target:removeHealthExtend(9999999, 1, 1, 1, 1, 0)
		end

		if math.random(1, 5) == 4 then
			mob:talk(2, "KA-BOOM! BUWAHAHA!")
			mob:playSound(116)
			target:sendAnimation(93)
			target:removeHealthExtend(9999999, 1, 1, 1, 1, 0)
		end

		if math.random(1, 40) == 6 then
			mob:talk(2, "KA-BOOM! BUWAHAHA!")
			mob:playSound(116)
			target:sendAnimation(93)
			target:removeHealthExtend(9999999, 1, 1, 1, 1, 0)
		end

		if math.random(1, 40) == 15 then
			mob:talk(2, "AHAHAHA! TOO EASY! DELICIOUS!")
			scourge.cast(mob, target)
		end
		if mob.paralyzed == true then
			mob.paralyzed = false
			mob:sendAnimation(5)
			mob:playSound(708)
			mob:talk(2, "FOOLS, YOU CANNOT BIND ME!")
			return
		end
		mob_ai_basic.attack(mob, target)
	end,

	on_attacked = function(mob, attacker)
		if math.random(1, 75) == 15 then
			mob:talk(2, "Pathetic WEAKLINGS!!")
		end
		if mob.paralyzed == true then
			mob.paralyzed = false
			mob:sendAnimation(5)
			mob:playSound(708)
			mob:talk(2, "FOOLS, YOU CANNOT BIND ME!")
			return
		end
		mob_ai_basic.on_attacked(mob, attacker)
	end
}
