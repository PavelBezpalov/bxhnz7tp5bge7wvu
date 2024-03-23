-- Marksmanship Hunter for 8.1 by Rotations - 8/2018
-- Talents: 
-- Holding Alt = Shield of Righteous
-- Holding Shift = Hammer of Justice

local addon, bxhnz7tp5bge7wvu = ...
local SB = bxhnz7tp5bge7wvu.rotation.spellbooks.hunter

local function combat()

  if target.alive and target.enemy and not player.channeling() then


	if modifier.shift and not modifier.alt and -spell(SB.FreezingTrap) == 0 then
      	return cast(SB.FreezingTrap, 'target')
    	end
	if modifier.alt and not modifier.shift and -spell(SB.ExplosiveTrap) == 0  then
      	return cast(SB.ExplosiveTrap, 'target')
    	end
    if modifier.alt and modifier.shift then
	    return cast(SB.Disengage)
	    end
    if -buff(SB.PreciseShots) then
	    --print 'ArcaneShot'
	    return cast(SB.ArcaneShot, 'target')
	    end
	if -buff(SB.LethalShots) and -spell(SB.RapidFire) == 0  then
		--print 'RapidFire'
		return cast(SB.RapidFire, 'target')
		end
    if spell(SB.AimedShot).charges > 1  then 
	    --print 'AimedShot'
	    return cast(SB.AimedShot, 'target')
	    end
	if toggle('cooldowns', false) and -spell(SB.AMurderOfCrowsMM) == 0 then
		return cast(SB.AMurderOfCrowsMM, 'target')
		end
		 	
    	
    	
    	
 
	print 'SteadyShots' 
    return cast(SB.SteadyShots, 'target')
    end
end

local function resting()

  -- Put great stuff here to do when your out of combat

end
function interface()
   bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
    name = 'aoe',
    on = {
      label = 'AOE',
      color = bxhnz7tp5bge7wvu.interface.color.orange,
      color2 = bxhnz7tp5bge7wvu.interface.color.ratio(bxhnz7tp5bge7wvu.interface.color.dark_orange, 0.7)
    },
    off = {
      label = 'AOE',
      color = bxhnz7tp5bge7wvu.interface.color.grey,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_grey
    }
  })

  bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
    name = 'place_holder1',
    on = {
      label = '??',
      color = bxhnz7tp5bge7wvu.interface.color.red,
      color2 = bxhnz7tp5bge7wvu.interface.color.ratio(bxhnz7tp5bge7wvu.interface.color.dark_orange, 0.7)
    },
    off = {
      label = '??',
      color = bxhnz7tp5bge7wvu.interface.color.grey,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_grey
    }
  })

  bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
    name = 'place_holder2',
    on = {
      label = '??',
      color = bxhnz7tp5bge7wvu.interface.color.green,
      color2 = bxhnz7tp5bge7wvu.interface.color.ratio(bxhnz7tp5bge7wvu.interface.color.green, 0.7)
    },
    off = {
      label = '??',
      color = bxhnz7tp5bge7wvu.interface.color.grey,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_grey
    }
  })
end

bxhnz7tp5bge7wvu.rotation.register('marksmanship', combat, resting, interface)


