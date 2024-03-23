-- Firemage for 8.1 by Rotations - 8/2018
-- Talents: 2 2 1 3 2 2 1
-- Holding Alt = DragonsBreath
-- Holding Shift = Flamestrike

local addon, bxhnz7tp5bge7wvu = ...
local SB = bxhnz7tp5bge7wvu.rotation.spellbooks.mage

local function combat()

  if target.alive and target.enemy and player.alive then

local inRange = 0
    for i = 1, 40 do
      if UnitExists('nameplate' .. i) and IsSpellInRange('Ebonbolt', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then 
        inRange = inRange + 1
      end 
end
   bxhnz7tp5bge7wvu.interface.status_extra('R:' .. bxhnz7tp5bge7wvu.version .. '   T#:' .. inRange .. ' |cff5BFF33 D:|r ' .. target.distance)
   
     -- added
    if castable(SB.Counterspell, 'target') and target.interrupt(100, false) then
      return cast(SB.Counterspell, 'target')
    end

	 if toggle('polymorph', false) and not -target.debuff(SB.Polymorph) then
		return cast(SB.Polymorph, 'target')
		end

	if modifier.alt and -spell(SB.DragonsBreath) == 0 then
      return cast(SB.DragonsBreath, 'target')
    end
    if modifier.shift and -spell(SB.Flamestrike) == 0 and -buff(SB.HotStreak) then
      return cast(SB.Flamestrike, 'ground')
    end

    if -buff(SB.HotStreak) then
      return cast(SB.Pyroblast, 'target')
    end
    if -buff(SB.HeatingUp) and spell(SB.FireBlast).charges > 0 and toggle('phoenix_flames', false) then
      return cast(SB.FireBlast)
	  end
    if -buff(SB.HeatingUp) and spell(SB.PhoenixFlames).charges > 0 and toggle('phoenix_flames', false) then
      return cast(SB.PhoenixFlames)
	  end

    if player.moving  then
      return cast(SB.Scorch, 'target')
    end
    if -spell(SB.BlazingBarrier) == 0 and not -buff(SB.BlazingBarrier) and toggle('blazing_barrier', false) then
      return cast(SB.BlazingBarrier, 'player')
    end
    if -spell(SB.Combustion) == 0 and toggle('cooldowns', false) then
      return cast(SB.Combustion, 'player')
    end

    if -buff(SB.Combustion) then
	    return cast(SB.Scorch)
	   end


    return cast(SB.Fireball, 'target')
    end
end

local function resting()

  local inRange = 0
    for i = 1, 40 do
      if UnitExists('nameplate' .. i) and IsSpellInRange('Ebonbolt', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then 
        inRange = inRange + 1
      end 
end
   bxhnz7tp5bge7wvu.interface.status_extra('R:' .. bxhnz7tp5bge7wvu.version .. '   T#:' .. inRange .. ' |cff5BFF33 D:|r ' .. target.distance)

	if toggle('blazing_barrier', false) and -spell(SB.BlazingBarrier) == 0 and not -buff(SB.BlazingBarrier) and player.moving then
    return cast(SB.BlazingBarrier, 'player')
  end

  if player.spell(SB.Shimmer).lastcast and ugh==nil then
     PlaySoundFile("Interface\\AddOns\\WeakAuras\\PowerAurasMedia\\Sounds\\sonar.ogg", "Master")
     ugh = 1
     return cast(SB.ArcaneInt, player)
   end

   if ugh == 1 then
    ugh = nil
  end

  -- Put great stuff here to do when your out of combat
end

local function interface()
   bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
    name = 'blazing_barrier',
    label = 'Blazing Barrier',
    font = 'bxhnz7tp5bge7wvu_icon',
    on = {
      label = bxhnz7tp5bge7wvu.interface.icon('globe'),
      color = bxhnz7tp5bge7wvu.interface.color.blue,
      color2 = bxhnz7tp5bge7wvu.interface.color.ratio(bxhnz7tp5bge7wvu.interface.color.dark_blue, 0.7)
    },
    off = {
      label = bxhnz7tp5bge7wvu.interface.icon('globe'),
      color = bxhnz7tp5bge7wvu.interface.color.grey,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_grey
    }
  })

  bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
    name = 'phoenix_flames',
    on = {
      label = 'PF',
      color = bxhnz7tp5bge7wvu.interface.color.red,
      color2 = bxhnz7tp5bge7wvu.interface.color.ratio(bxhnz7tp5bge7wvu.interface.color.dark_orange, 0.7)
    },
    off = {
      label = 'PF',
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
  spec = bxhnz7tp5bge7wvu.rotation.classes.mage.fire,
  name = 'fire',
  label = 'Bundled Fire',
  combat = combat,
  resting = resting,
  interface = interface
})

--{ "Pyroblast", { "player.buff(Kael'thas's Ultimate Ability)", "!player.buff(48108)", "!modifier.last(Pyroblast)", "!player.moving"}},
-- "player.spell(Fire Blast).charges < 1"
