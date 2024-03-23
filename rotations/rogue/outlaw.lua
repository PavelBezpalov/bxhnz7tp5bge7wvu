-- Outlaw for 8.1 by Rotations - 10/2018
-- Talents: 2 1 1 2 3 2 2
-- Holding Alt = 
-- Holding Shift = 

local addon, bxhnz7tp5bge7wvu = ...
local SB = bxhnz7tp5bge7wvu.rotation.spellbooks.rogue

local function combat()

  if target.alive and target.enemy and player.alive then
    auto_attack()

  if -buff(SB.Opportunity) and -spell(SB.PistolShot) == 0 then
    return cast(SB.PistolShot)
  end
	if player.power.combopoints.actual > 3 and -spell(SB.RolltheBones) == 0 then
    return cast(SB.RolltheBones)
  end
  if player.power.combopoints.actual < 5 and -spell(SB.GhostlyStrike) == 0 and talent(1,3) then
    return cast(SB.GhostlyStrike)
  end
  if -spell(SB.KillingSpree) == 0 and talent(7,3) and not -buff(SB.AdrenalineRush) then
    print 'Killing Spree'
    return cast(SB.KillingSpree)
  end
  if -spell(SB.BladeRush) == 0 and talent(7,2) and not -buff(SB.AdrenalineRush) then
    return cast(SB.BladeRush)
  end
  if -spell(SB.AdrenalineRush) == 0 and toggle('cooldowns', false) then
    return cast(SB.AdrenalineRush)
  end
  if -spell(SB.MarkedforDeath) == 0 and toggle('cooldowns', false) and player.power.combopoints.actual <  2 and talent(3,3) then
    return cast(SB.MarkedforDeath)
  end
  if -spell(SB.BetweentheEyes) == 0 and player.power.combopoints.actual == 5 then 
    return cast(SB.BetweentheEyes)
  end
    if -spell(SB.Dispatch) == 0 and player.power.combopoints.actual == 5 then 
    return cast(SB.Dispatch)
  end

    return cast(SB.SinisterStrike)
    end
end

local function resting()

 if target.distance < 8 and -spell(SB.Ambush) == 0 and -buff(SB.Stealth) then
  return cast(SB.Ambush)
end

 if not -buff(SB.Stealth) and toggle('use_stealth', false) then 
 return cast(SB.Stealth)
 end
  -- Put great stuff here to do when your out of combat

end

function interface()
   bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
    name = 'use_stealth',
    on = {
      label = 'Stlth',
      color = bxhnz7tp5bge7wvu.interface.color.orange,
      color2 = bxhnz7tp5bge7wvu.interface.color.ratio(bxhnz7tp5bge7wvu.interface.color.dark_orange, 0.7)
    },
    off = {
      label = 'Stlth',
      color = bxhnz7tp5bge7wvu.interface.color.grey,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_grey
    }
  })

  bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
    name = 'open_2',
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
    name = 'open_3',
    on = {
      label = '??',
      color = bxhnz7tp5bge7wvu.interface.color.green,
      color2 = bxhnz7tp5bge7wvu.interface.color.ratio(bxhnz7tp5bge7wvu.interface.color.dark_orange, 0.7)
    },
    off = {
      label = '??',
      color = bxhnz7tp5bge7wvu.interface.color.grey,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_grey
    }
  })
end

bxhnz7tp5bge7wvu.rotation.register({
  spec = bxhnz7tp5bge7wvu.rotation.classes.rogue.outlaw,
  name = 'outlaw',
  label = 'Bundled Outlaw',
  combat = combat,
  resting = resting,
  interface = interface
})


