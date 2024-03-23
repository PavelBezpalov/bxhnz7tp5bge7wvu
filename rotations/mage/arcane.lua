-- Arcane Mage for 8.1 by Rotations - 8/2018
-- Talents: 2 2 1 2 2 2 1
-- Holding Alt = Missles
-- Holding Shift = Arcane Explosion

local addon, bxhnz7tp5bge7wvu = ...
local SB = bxhnz7tp5bge7wvu.rotation.spellbooks.mage

local function combat()

  if target.alive and target.enemy and not player.channeling() then

    if modifier.alt  then
      	return cast(SB.ArcaneMissiles, 'target')
    end

    if modifier.shift  then
      	return cast(SB.ArcaneExplosion, 'target')
    end

	if -spell(SB.PrismaticBarrier) == 0 and not -buff(SB.PrismaticBarrier) and player.moving then
    	return cast(SB.PrismaticBarrier, 'player')
	end

  	if -spell(SB.PrismaticBarrier) == 0 and not -buff(SB.PrismaticBarrier) and -player.health < 50 and toggle('prismatic_barrier', false) then
    	return cast(SB.PrismaticBarrier, 'player')
  	end
    if -power.arcanecharges == 0 and not player.spell(SB.ChargedUp).lastcast and toggle('cooldowns', false) and -spell(SB.ChargedUp) == 0 then
		return cast(SB.ChargedUp, 'player')
  	end

       if -spell(SB.ArcanePower) == 0 and  toggle('cooldowns', false) then
    return cast(SB.ArcanePower, 'player')
    end

    if -buff(SB.ClearcastingBuff) and player.moving then
     	return cast(SB.ArcaneMissiles)
    end


    if -buff(SB.ClearcastingBuff)  then
      	return cast(SB.ArcaneMissiles)
    end

    --if -spell(SB.PrecenseofMind) == 0 then
	  --  print 'predsense of mind is good '
      --return cast(SB.PrecenseofMind, 'player')
    --end

    if -power.arcanecharges < 4 then
		return cast(SB.ArcaneBlast, 'target')
    end

        if -power.arcanecharges == 4 then
		return cast(SB.ArcaneBarrage, 'target')
    end

        return cast(SB.ArcaneBlast, 'target')
    end

end

local function resting()
	if -spell(SB.PrismaticBarrier) == 0 and not -buff(SB.PrismaticBarrier) and toggle('prismatic_barrier', false) and player.moving then
    	return cast(SB.PrismaticBarrier, 'player')
  end

  -- Put great stuff here to do when your out of combat
end
function interface()
   bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
    name = 'prismatic_barrier',
    label = 'Ice Barrier Auto Cast',
    on = {
      label = 'PB',
      color = bxhnz7tp5bge7wvu.interface.color.orange,
      color2 = bxhnz7tp5bge7wvu.interface.color.ratio(bxhnz7tp5bge7wvu.interface.color.dark_orange, 0.7)
    },
    off = {
      label = 'PB',
      color = bxhnz7tp5bge7wvu.interface.color.grey,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_grey
    }
  })

  bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
    name = 'aoe',
    label = 'Use Frozen Orb Auto',
    on = {
      label = 'AOE',
      color = bxhnz7tp5bge7wvu.interface.color.red,
      color2 = bxhnz7tp5bge7wvu.interface.color.ratio(bxhnz7tp5bge7wvu.interface.color.dark_orange, 0.7)
    },
    off = {
      label = 'AOE',
      color = bxhnz7tp5bge7wvu.interface.color.grey,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_grey
    }
  })

  bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
    name = 'polymorph',
    on = {
      label = 'PM',
      color = bxhnz7tp5bge7wvu.interface.color.green,
      color2 = bxhnz7tp5bge7wvu.interface.color.ratio(bxhnz7tp5bge7wvu.interface.color.dark_orange, 0.7)
    },
    off = {
      label = 'PM',
      color = bxhnz7tp5bge7wvu.interface.color.grey,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_grey
    }
  })
end
bxhnz7tp5bge7wvu.rotation.register({
  spec = bxhnz7tp5bge7wvu.rotation.classes.mage.arcane,
  name = 'arcane',
  label = 'Bundled Arcane',
  combat = combat,
  resting = resting,
  interface = interface
})

--{ "Pyroblast", { "player.buff(Kael'thas's Ultimate Ability)", "!player.buff(48108)", "!modifier.last(Pyroblast)", "!player.moving"}},
-- "player.spell(Fire Blast).charges < 1"
