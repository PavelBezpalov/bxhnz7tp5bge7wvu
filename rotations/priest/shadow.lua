-- Shadow Priest for 8.1 by Rotations - 9/2018
-- Talents: 1 1 3 3 1 2 2
-- Holding 
-- Holding 


local addon, dark_rotation = ...
local SB = dark_rotation.rotation.spellbooks.priest

local function combat()

   if target.alive and target.enemy and player.alive and not player.channeling() and not -player.buff(SB.Dispersion) then

    -- Lets heal the party

    if toggle('heal_tank', false)  and not -lowest.buff(SB.PowerWordFortitude) and lowest.health.percent <= 90 then
      return cast(SB.PowerWordFortitude, lowest)
    end
    if toggle('heal_tank', false)  and not -lowest.buff(SB.PowerWordShield) and lowest.health.percent <= 90 then
      return cast(SB.PowerWordShield, lowest)
    end
    if toggle('heal_tank', false) and -lowest.health.percent <= 90 and player.power.mana.percent >= 10 then
      return cast(SB.FlashHeal, lowest)
    end

    -- Ok lets get busy with some DPS

    if castable(SB.Silence, 'target') and target.interrupt(100, false) then
      return cast(SB.Silence, 'target')
    end
    if castable(SB.PsychicScream, 'target') and target.interrupt(100, false) and player.spell(SB.Silence).cooldown > 0 then
      return cast(SB.PsychicScream, 'target')
    end
    if castable(SB.PsychicHorror, 'target') and target.interrupt(100, false) and player.spell(SB.PsychicScream).cooldown > 0 and  player.spell(SB.Silence).cooldown > 0 then
      return cast(SB.PsychicHorror, 'target')
    end
    if -player.health < 70 and player.spell(SB.PowerWordShield) == 0 then
      return cast(SB.PowerWordShield, 'player')
    end
    if -player.health < 20 and player.spell(SB.Dispersion) == 0 then
      return cast(SB.Dispersion, 'player')
    end
    if -player.buff(SB.Voidform) and player.spell(SB.VoidBolt).cooldown == 0 then 
      return cast(SB.VoidBolt)
    end
    if toggle('multitarget', false) and player.spell(SB.DarkAscension).cooldown == 0 and talent (7,2) then
      return cast(SB.DarkAscension, 'target')
    end
    if toggle('multitarget', false) and player.spell(SB.MindbenderShadow).cooldown == 0 then
      return cast(SB.MindbenderShadow, 'target')
    end
    if not -target.debuff(SB.ShadowWordPain) then
      return cast(SB.ShadowWordPain, 'target')
    end
    if not -target.debuff(SB.VampiricTouch) and not player.spell(SB.VampiricTouch).lastcast then
      return cast(SB.VampiricTouch, 'target')
    end
    if player.spell(SB.DarkVoid).cooldown == 0  then
      return cast(SB.DarkVoid, 'target')
    end
    if player.spell(SB.VoidEruption).cooldown == 0 and player.power.insanity.actual > 90 then
      return cast(SB.VoidEruption, 'target')
    end
    if player.spell(SB.MindBlast).cooldown == 0  then
      return cast(SB.MindBlast, 'target')
    end
    if player.spell(SB.MindFlay).cooldown == 0  then
      return cast(SB.MindFlay, 'target')
    end
 end
end

local function resting()

  -- Put great stuff here to do when your out of combat
    if not -player.buff(SB.PowerWordFortitude) and player.moving and player.alive then
      return cast(SB.PowerWordFortitude, 'player')
 end
end

local function interface()
   dark_rotation.interface.buttons.add_toggle({
    name = 'heal_tank',
    label = 'Shit just got real, time to heal!',
    on = {
      label = 'Heal',
      color = dark_rotation.interface.color.orange,
      color2 = dark_rotation.interface.color.ratio(dark_rotation.interface.color.dark_orange, 0.7)
    },
    off = {
      label = 'Heal',
      color = dark_rotation.interface.color.grey,
      color2 = dark_rotation.interface.color.dark_grey
    }
  })

 
end


dark_rotation.rotation.register({
  spec = dark_rotation.rotation.classes.priest.shadow,
  name = 'shadow',
  label = 'Bundled Shadow',
  combat = combat,
  resting = resting,
  interface = interface  -- Put back in for buttons
})


