last_stand = {
	cast = function(mob, level)
		local magic = 100

		if (mob.magic < magic) then
			return
		end

		mob:removeDuras(curses)

		mob.magic = mob.magic - magic
		mob:sendAnimation(11)
		mob:setDuration("last_stand", 8000)
		mob.paralyzed = true
	end,

	uncast = function(mob)
		mob.paralyzed = false
	end
}
