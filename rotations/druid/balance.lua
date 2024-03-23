-- Balance Druid for 8.1 by Tacotits - 9/2018
-- Talents: 2000231
-- Holding Alt =
-- Holding Shift =

local addon, bxhnz7tp5bge7wvu = ...
local SB = bxhnz7tp5bge7wvu.rotation.spellbooks.druid
local TB = bxhnz7tp5bge7wvu.rotation.talentbooks.druid

--- Consumables
-- potion=potion_of_rising_death
-- flask=endless_fathoms
-- food=bountiful_captains_feast
-- augmentation=battle_scarred

--- Pre-Combat Rotation
-- actions.precombat=flask
-- actions.precombat+=/food
-- actions.precombat+=/augmentation
-- actions.precombat+=/moonkin_form
-- # Snapshot raid buffed stats before combat begins and pre-potting is done.
-- actions.precombat+=/snapshot_stats
-- actions.precombat+=/potion
-- actions.precombat+=/solar_wrath

local function combat()
  if GetShapeshiftForm() == 3  then return end

  --- Healing
  -- Swiftmend
  if player.castable(SB.Swiftmend) and player.health.percent < 50 and (not player.buff(SB.MoonkinForm).exists or player.health.percent < 30) then
    return cast(SB.Swiftmend, player)
  end
  -- Rejuvenation
  if player.castable(SB.Rejuvenation) and not (player.buff(SB.Rejuvenation).up or player.buff(SB.RejuvenationGermination).up) and player.health.percent < 75 and not player.buff(SB.MoonkinForm).exists then
    return cast(SB.Rejuvenation, player)
  end
  -- Regrowth
  if player.castable(SB.Regrowth) and ((player.health.percent < 75 and not player.buff(SB.Regrowth).up) or player.health.percent < 30) then
    return cast(SB.Regrowth, player)
  end
  if lowest.castable(SB.Regrowth) and ((lowest.health.percent < 30 and not lowest.buff(SB.Regrowth).up) or lowest.health.percent < 20) then
    return cast(SB.Regrowth, player)
  end
  -- Barkskin
  if player.castable(SB.Barkskin) and player.health.percent < 50 then
    return cast(SB.Barkskin, player)
  end

  --- Combat Rotation
  if not target.alive or not target.enemy then return end

  -- Moonkin Form
  if not lastcast(SB.MoonkinForm) and GetShapeshiftForm() ~= 4 then
    return cast(SB.MoonkinForm, player)
  end
  -- actions=potion,if=buff.celestial_alignment.up|buff.incarnation.up
  -- actions+=/blood_fury,if=buff.celestial_alignment.up|buff.incarnation.up
  if target.castable(SB.BloodFury) and player.buff(SB.CelestialAlignment).exists or player.buff(SB.Incarnation).exists then
    return cast(SB.BloodFury, 'target')
  end
  -- actions+=/berserking,if=buff.celestial_alignment.up|buff.incarnation.up
  if target.castable(SB.Berserking) and player.buff(SB.CelestialAlignment).exists or player.buff(SB.Incarnation).exists then
    return cast(SB.Berserking, 'target')
  end
  -- actions+=/lights_judgment,if=buff.celestial_alignment.up|buff.incarnation.up
  if target.castable(SB.LightsJudgement) and player.buff(SB.CelestialAlignment).exists or player.buff(SB.Incarnation).exists then
    return cast(SB.LightsJudgement, 'target')
  end
  -- actions+=/fireblood,if=buff.celestial_alignment.up|buff.incarnation.up
  -- actions+=/ancestral_call,if=buff.celestial_alignment.up|buff.incarnation.up
  -- actions+=/use_items
  -- actions+=/warrior_of_elune
  -- actions+=/run_action_list,name=ed,if=equipped.the_emerald_dreamcatcher&active_enemies<=1
    --- Emerald Dreamcatcher Rotation
    -- actions.ed=incarnation,if=astral_power>=30
    -- actions.ed+=/celestial_alignment,if=astral_power>=30
    -- actions.ed+=/fury_of_elune,if=(buff.celestial_alignment.up|buff.incarnation.up)|(cooldown.celestial_alignment.remains>30|cooldown.incarnation.remains>30)&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
    -- actions.ed+=/force_of_nature,if=(buff.celestial_alignment.up|buff.incarnation.up)|(cooldown.celestial_alignment.remains>30|cooldown.incarnation.remains>30)&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
    -- actions.ed+=/starsurge,if=(gcd.max*astral_power%30)>target.time_to_die
    -- actions.ed+=/moonfire,target_if=refreshable,if=buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up
    -- actions.ed+=/sunfire,target_if=refreshable,if=buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up
    -- actions.ed+=/stellar_flare,target_if=refreshable,if=buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up
    -- actions.ed+=/starfall,if=buff.oneths_overconfidence.up&(buff.the_emerald_dreamcatcher.remains>gcd.max|!buff.the_emerald_dreamcatcher.up)
    -- actions.ed+=/new_moon,if=buff.the_emerald_dreamcatcher.remains>execute_time|!buff.the_emerald_dreamcatcher.up
    -- actions.ed+=/half_moon,if=astral_power.deficit>=20&(buff.the_emerald_dreamcatcher.remains>execute_time|!buff.the_emerald_dreamcatcher.up)
    -- actions.ed+=/full_moon,if=astral_power.deficit>=40&(buff.the_emerald_dreamcatcher.remains>execute_time|!buff.the_emerald_dreamcatcher.up)
    -- actions.ed+=/lunar_strike,,if=buff.lunar_empowerment.up&buff.the_emerald_dreamcatcher.remains>execute_time
    -- actions.ed+=/solar_wrath,if=buff.solar_empowerment.up&buff.the_emerald_dreamcatcher.remains>execute_time
    -- actions.ed+=/starsurge,if=(buff.the_emerald_dreamcatcher.up&buff.the_emerald_dreamcatcher.remains<gcd.max)|astral_power>=50
    -- actions.ed+=/solar_wrath
  -- actions+=/innervate,if=azerite.lively_spirit.enabled&(cooldown.incarnation.up|cooldown.celestial_alignment.remains<12)&(((raid_event.adds.duration%15)*(4)<(raid_event.adds.in%180))|(raid_event.adds.up))
  -- actions+=/incarnation,if=astral_power>=40&(((raid_event.adds.duration%30)*(4)<(raid_event.adds.in%180))|(raid_event.adds.up))
  -- actions+=/celestial_alignment,if=astral_power>=40&(!azerite.lively_spirit.enabled|buff.lively_spirit.up)&(((raid_event.adds.duration%15)*(4)<(raid_event.adds.in%180))|(raid_event.adds.up))
  if toggle('cooldowns') and player.castable(SB.CelestialAlignment) and power.astral.actual >= 40 then
    return cast(SB.CelestialAlignment, 'player')
  end

  --- AOE Rotation
  if toggle('multitarget') then -- if number of enemies around target within 15 yards is >= 3
    -- actions.aoe=fury_of_elune,if=(((raid_event.adds.duration%8)*(4)<(raid_event.adds.in%60))|(raid_event.adds.up))&((buff.celestial_alignment.up|buff.incarnation.up)|(cooldown.celestial_alignment.remains>30|cooldown.incarnation.remains>30))
    -- actions.aoe+=/force_of_nature,if=(buff.celestial_alignment.up|buff.incarnation.up)|(cooldown.celestial_alignment.remains>30|cooldown.incarnation.remains>30)
    -- actions.aoe+=/sunfire,target_if=refreshable,if=astral_power.deficit>7&target.time_to_die>4
    if target.castable(SB.Sunfire) and not target.debuff(SB.SunfireDebuff).exists and power.astral.deficit > 7 then
      return cast(SB.Sunfire, 'target')
    end
    -- actions.aoe+=/moonfire,target_if=refreshable,if=astral_power.deficit>7&target.time_to_die>4
    if target.castable(SB.Moonfire) and not target.debuff(SB.MoonfireDebuff).exists and power.astral.deficit > 7 then
      return cast(SB.Moonfire, 'target')
    end
    -- actions.aoe+=/stellar_flare,target_if=refreshable,if=target.time_to_die>10
    if target.castable(SB.StellarFlare) and not target.debuff(SB.StellarFlare).exists then
      return cast(SB.StellarFlare, 'target')
    end
    -- actions.aoe+=/lunar_strike,if=(buff.lunar_empowerment.stack=3|buff.solar_empowerment.stack=2&buff.lunar_empowerment.stack=2&astral_power>=40)&astral_power.deficit>14
    if target.castable(SB.LunarStrike) and (player.buff(SB.LunarEmpowerment).count == 3 or player.buff(SB.SolarEmpowerment).count == 2 and player.buff(SB.LunarEmpowerment).count == 2 and power.astral.actual >= 40) and power.astral.deficit > 14 then
      return cast(SB.LunarStrike, 'target')
    end
    -- actions.aoe+=/solar_wrath,if=buff.solar_empowerment.stack=3&astral_power.deficit>10
    if target.castable(SB.SolarWrath) and player.buff(SB.SolarEmpowerment).count == 3 and power.astral.deficit > 10 then
      return cast(SB.SolarWrath, 'target')
    end
        -- actions.aoe+=/starfall,if=!buff.starlord.up|buff.starlord.remains>=4
    if modifier.shift and power.astral.actual > 40 and (not player.buff(SB.Starlord).up or player.buff(SB.Starlord).remains >= 4) then
      return cast(SB.Starfall, 'target')
    end
    -- actions.aoe+=/starsurge,if=buff.oneths_intuition.react|target.time_to_die<=4
    if target.castable(SB.Starsurge) and power.astral.actual > 40 then
      return cast(SB.Starsurge, 'target')
    end

    -- actions.aoe+=/solar_wrath,if=(buff.solar_empowerment.up&!buff.warrior_of_elune.up|buff.solar_empowerment.stack>=3)&buff.lunar_empowerment.stack<3
    if castable(SB.SolarWrath) and (player.buff(SB.SolarEmpowerment).up and not player.buff(SB.WarriorOfElune).up or player.buff(SB.SolarEmpowerment).count >= 3) and player.buff(SB.LunarEmpowerment).count < 3 then
      return cast(SB.SolarWrath, 'target')
    end
    -- actions.aoe+=/lunar_strike
    if castable(SB.LunarStrike) then
      return cast(SB.LunarStrike, 'target')
    end
    -- actions.aoe+=/moonfire
    if castable(SB.Moonfire, 'target') then
      return cast(SB.Moonfire, 'target')
    end
  else
  --- Single Target Rotation
    -- actions.st=fury_of_elune,if=(((raid_event.adds.duration%8)*(4)<(raid_event.adds.in%60))|(raid_event.adds.up))&((buff.celestial_alignment.up|buff.incarnation.up)|(cooldown.celestial_alignment.remains>30|cooldown.incarnation.remains>30))
    -- actions.st+=/force_of_nature,if=(buff.celestial_alignment.up|buff.incarnation.up)|(cooldown.celestial_alignment.remains>30|cooldown.incarnation.remains>30)
    -- actions.st+=/moonfire,target_if=refreshable,if=target.time_to_die>8
    if target.castable(SB.Moonfire) and not target.debuff(SB.MoonfireDebuff).exists then
      return cast(SB.Moonfire, 'target')
    end
    -- actions.st+=/sunfire,target_if=refreshable,if=target.time_to_die>8
    if target.castable(SB.Sunfire) and not target.debuff(SB.SunfireDebuff).exists then
      return cast(SB.Sunfire, 'target')
    end
    -- actions.st+=/stellar_flare,target_if=refreshable,if=target.time_to_die>10
    if target.castable(SB.StellarFlare) and not target.debuff(SB.StellarFlare).exists then
      return cast(SB.StellarFlare, 'target')
    end
    -- actions.st+=/solar_wrath,if=(buff.solar_empowerment.stack=3|buff.solar_empowerment.stack=2&buff.lunar_empowerment.stack=2&astral_power>=40)&astral_power.deficit>10
    if target.castable(SB.SolarWrath) and (player.buff(SB.SolarEmpowerment).count == 3 or player.buff(SB.SolarEmpowerment).count == 2 and power.astral.actual >= 40) and power.astral.deficit > 10 then
      return cast(SB.SolarWrath, 'target')
    end
    -- actions.st+=/lunar_strike,if=buff.lunar_empowerment.stack=3&astral_power.deficit>14
    if target.castable(SB.LunarStrike) and player.buff(SB.SolarEmpowerment).count == 3 and power.astral.deficit > 14 then
      return cast(SB.LunarStrike, 'target')
    end
    -- actions.st+=/starfall,if=buff.oneths_overconfidence.react
    if modifier.shift and power.astral.actual > 50 then
      return cast(SB.Starfall, 'target')
    end
    -- actions.st+=/starsurge,if=!buff.starlord.up|buff.starlord.remains>=4|(gcd.max*(astral_power%40))>target.time_to_die
    if target.castable(SB.Starsurge) and power.astral.actual > 40 and (not player.buff(SB.Starlord).up or player.buff(SB.Starlord).remains >= 4) then
      return cast(SB.Starsurge, 'target')
    end
    -- actions.st+=/lunar_strike,if=(buff.warrior_of_elune.up|!buff.solar_empowerment.up)&buff.lunar_empowerment.up
    if target.castable(SB.LunarStrike) and (player.buff(SB.WarriorOfElune).up or not player.buff(SB.SolarEmpowerment).up) and player.buff(SB.LunarEmpowerment).up then
      return cast(SB.LunarStrike, 'target')
    end
    -- actions.st+=/solar_wrath
    if target.castable(SB.SolarWrath) and power.astral.deficit >= 8 then
      return cast(SB.SolarWrath, 'target')
    end
    -- actions.st+=/moonfire
    if target.castable(SB.Moonfire) and power.astral.deficit >= 3 then
      return cast(SB.Moonfire, 'target')
    end
  end
end

local function resting()
  if GetShapeshiftForm() == 3 then return end
end

--bxhnz7tp5bge7wvu.environment.hook(your_func)
bxhnz7tp5bge7wvu.rotation.register({
  spec = bxhnz7tp5bge7wvu.rotation.classes.druid.balance,
  name = 'balance',
  label = 'Bundled Balance',
  combat = combat,
  resting = resting
})
