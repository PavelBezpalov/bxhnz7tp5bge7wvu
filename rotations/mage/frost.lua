-- Frost Mage for 8.1 by Rotations - 1/2019
-- Talents: Any
-- Holding Alt = IceBarrier
-- Holding Shift = Blizzard
local race = UnitRace("player")
local realmName = GetRealmName()
local addon, bxhnz7tp5bge7wvu = ...
local SB = bxhnz7tp5bge7wvu.rotation.spellbooks.mage

local function gcd()

end

local function combat()

  if target.alive and target.enemy and player.alive and not -player.buff(SB.IceBlock) and not -target.debuff(SB.Polymorph) then

   if player.castingpercent <= 70 and spell(SB.GlacialSpike).current and toggle('sounds', false) then
     macro('/cast Flurry')
     PlaySoundFile("Interface\\AddOns\\WeakAuras\\PowerAurasMedia\\Sounds\\BITE.ogg", "Master")
   end

   if player.castingpercent <= 70 and spell(SB.GlacialSpike).current and not toggle('sounds', false) then
     macro('/cast Flurry')
   end

   if player.castingpercent <= 100 and spell(SB.Frostbolt).current and -buff(SB.BrainFreeze) and player.spell(SB.Frostbolt).lastcast and toggle('sounds', false) and buff(SB.Icicles).count <= 2 and not player.spell(SB.Flurry).lastcast then
      macro('/cast Flurry')
      PlaySoundFile("Interface\\AddOns\\WeakAuras\\PowerAurasMedia\\Sounds\\BITE.ogg", "Master")
   end

   if player.castingpercent <= 100 and spell(SB.Frostbolt).current and -buff(SB.BrainFreeze) and player.spell(SB.Frostbolt).lastcast and not toggle('sounds', false) and buff(SB.Icicles).count <= 2 and not player.spell(SB.Flurry).lastcast then
      macro('/cast Flurry')
   end

 -- if -spell(SB.CometStorm) <= 3 and ugh==nil and not -buff(SB.BrainFreeze) and  target.distance <= 40 and buff(SB.Icicles).count <= 3 and toggle('multitarget', false) then
  --   PlaySoundFile("Interface\\AddOns\\WeakAuras\\PowerAurasMedia\\Sounds\\sonar.ogg", "Master")
  --   ugh = 1
     
 --  end

  -- if ugh == 1 then
  --  ugh = nil
--  end   


    -- Let's read what the GUI has to say
    local spellcasting, _, _, _, endTimeloc = UnitCastingInfo("player")
    local blowup = bxhnz7tp5bge7wvu.settings.fetch('dr_example_blowup')
    local multinumber = bxhnz7tp5bge7wvu.settings.fetch('dr_example_multi')
    local intpercent = bxhnz7tp5bge7wvu.settings.fetch('dr_example_spinner')
    local usehealthstone = bxhnz7tp5bge7wvu.settings.fetch('dr_example_healthstone.check')
    local healthstonepercent = bxhnz7tp5bge7wvu.settings.fetch('dr_example_healthstone.spin')
    local callpet = bxhnz7tp5bge7wvu.settings.fetch('dr_example_callpet')
    local usepoly = bxhnz7tp5bge7wvu.settings.fetch('dr_example_usepolymorph')
    local usefrostnova = bxhnz7tp5bge7wvu.settings.fetch('dr_example_usefrostnova')
    local heavymove = bxhnz7tp5bge7wvu.settings.fetch('dr_example_heavymovement')
    local usespellsteal = bxhnz7tp5bge7wvu.settings.fetch('dr_example_usespellsteal')
    local nameplates = bxhnz7tp5bge7wvu.settings.fetch('dr_example_usenameplates')
    local critChance = GetCritChance() -- in development for future use

if target.has_stealable and usespellsteal == true and castable(SB.SpellSteal, 'target') then
    return cast(SB.SpellSteal, 'target') 
end

if modifier.control and not -player.buff(SB.IceBlock) and -spell(SB.IceBlock) == 0 and toggle('iceblockon', false) then
    return cast(SB.IceBlock)
end

if player.buff(SB.BrainFreeze).remains <= 2 and -buff(SB.BrainFreeze) and  player.moving and target.distance <= 40 then
  return cast(SB.Flurry)
end

if -spell(SB.CometStorm) == 0 and player.moving and target.distance <= 40 and talent(6,3) then
  return cast(SB.CometStorm)
end

if player.buff(SB.FingersofFrost).remains <= 2 and -buff(SB.FingersofFrost) and player.moving and target.distance <= 40 then
  return cast(SB.IceLance)
end

if spell(SB.Frostbolt).current and buff(SB.Icicles).count >= 5 and -buff(SB.BrainFreeze) then
      stopcast()
end

if spell(SB.Ebonbolt).current and  -buff(SB.BrainFreeze) then
      stopcast()
end

if spell(SB.Flurry).current  then
      stopcast()
end

if not player.moving and  talent(7,3) and castable(SB.GlacialSpike, 'target') and -buff(SB.BrainFreeze) and -spell(SB.GlacialSpike) == 0 then 
  return cast(SB.GlacialSpike) 
end

    local inRange = 0
    for i = 1, 40 do
      if UnitExists('nameplate' .. i) and IsSpellInRange('Ebonbolt', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then 
        inRange = inRange + 1
      end 
    end
   bxhnz7tp5bge7wvu.interface.status_extra('R:' .. bxhnz7tp5bge7wvu.version ..  '      T#:' .. inRange .. ' |cff5BFF33   D:|r ' .. target.distance)
   
    if player.spell(SB.Flurry).lastcast then
      return cast(SB.IceLance, 'target')
    end

    if player.spell(SB.Freeze).lastcast and talent(6,3) then
      return cast(SB.CometStorm)
    end

    if castable(SB.IcyVeins) and toggle('cooldowns', false) and not -buff(SB.BrainFreeze) and not -buff(SB.FingersofFrost) and -spell(SB.IcyVeins) == 0 then
      return cast(SB.IcyVeins, 'player')
    end

    -- heavymovement logic from GUI
    if heavymove == true and player.moving then
          if -buff(SB.BrainFreeze) and not player.spell(SB.Flurry).lastcast and buff(SB.Icicles).count <= 2 and not player.alive then
            return cast(SB.Flurry)
          end

          if -buff(SB.FingersofFrost) and not -buff(SB.BrainFreeze) then
            return cast(SB.IceLance)
          end

          if modifier.shift and -spell(SB.ConeofCold) == 0 then 
            return cast(SB.ConeofCold)
          end

          if modifier.shift and -spell(SB.FrozenOrb) == 0 then
            return cast(SB.FrozenOrb)
          end

          if target.has_stealable and usespellsteal == true and castable(SB.SpellSteal, 'target') then
            return cast(SB.SpellSteal, 'target')
          end
    end
    -- End heavy Movemnt

    if not -buff(SB.IceBarrior) and player.moving  and toggle('ice_barrier', false) and player.alive and -spell(SB.IceBarrior) == 0 then
      return cast(SB.IceBarrior, 'player')
    end

    if not player.moving and  talent(7,3) and castable(SB.GlacialSpike, 'target') and -buff(SB.BrainFreeze) and -spell(SB.GlacialSpike) == 0 then  
      return cast(SB.GlacialSpike)
    end

    if not player.moving and not talent(7,3) and -buff(SB.BrainFreeze) and player.spell(SB.Frostbolt).lastcast then
    	return cast(SB.Flurry)
    end

   -- WHhen cast at ground 'target' works, put this back in
   -- if talent(6,3) and -spell(SB.CometStorm) == 0 and -spell(SB.Freeze) == 0 and not -buff(SB.BrainFreeze) and  buff(SB.Icicles).count <= 3 and toggle('multitarget', false) and inRange >= 2 then 
   --    return cast(SB.Freeze, 'ground')
   --  end

    if talent(6,3) and -spell(SB.CometStorm) == 0 and toggle('multitarget', false) and not -buff(SB.BrainFreeze) then -- and  inRange >= multinumber then , and  buff(SB.Icicles).count <= 3 
      return cast(SB.CometStorm)
    end

    if castable(SB.FrozenOrb) and toggle('multitarget', false) and target.distance <= 40 then
      return cast(SB.FrozenOrb, 'target')
    end

    if -buff(SB.BrainFreeze) and player.spell(SB.Frostbolt).lastcast and buff(SB.Icicles).count <= 2 and not player.spell(SB.Flurry).lastcast and toggle('sounds', false) then
       PlaySoundFile("Interface\\AddOns\\WeakAuras\\PowerAurasMedia\\Sounds\\BITE.ogg", "Master")
      return cast(SB.Flurry, 'target')
    end

    if -buff(SB.BrainFreeze) and player.spell(SB.Frostbolt).lastcast and buff(SB.Icicles).count <= 2 and not player.spell(SB.Flurry).lastcast and not toggle('sounds', false) then
      return cast(SB.Flurry, 'target')
    end

    if castable(SB.Counterspell, 'target') and target.interrupt(intpercent, false) and toggle('interrupts', false) then
      return cast(SB.Counterspell, 'target')
    end

    if not player.moving and  -buff(SB.WintersReach) and -spell(SB.Flurry) == 0 and not player.spell(SB.Flurry).lastcast then
      return cast(SB.Flurry)
    end

    if not player.moving and  -buff(SB.WintersReachOther) and -spell(SB.Flurry) == 0 and not player.spell(SB.Flurry).lastcast then
      return cast(SB.Flurry)
    end

    if modifier.alt then
      return cast(SB.IceBarrior)
    end
    
    if modifier.shift and not player.moving then
      return cast(SB.Blizzard, 'ground')
    end

    if not player.moving and talent(7,3) and castable(SB.GlacialSpike, 'target') and toggle('gspike', false) then 
      return cast(SB.GlacialSpike)
    end

    if not player.moving and castable(SB.Ebonbolt, 'target') and toggle('cooldowns', false) and not -buff(SB.BrainFreeze) then
      return cast(SB.Ebonbolt, 'target')
    end

    if buff(SB.FingersofFrost).count > 0 and not -buff(SB.BrainFreeze) then
      return cast(SB.IceLance)
    end

    if GetItemCooldown(5512) == 0 and player.health.percent < healthstonepercent and usehealthstone == true then
      macro('/use Healthstone')
    end

    if usefrostnova == true and not -target.debuff(SB.FrostNova) and spell(SB.FrostNova).charges >= 1 and target.distance <= 12 then
      return cast(SB.FrostNova)
    end

    if usepoly == true and not -target.debuff(SB.Polymorph) and not player.spell(SB.Polymorph).lastcast then
      return cast(SB.Polymorph, 'target')
    end

    if target.has_stealable and usespellsteal == true and castable(SB.SpellSteal, 'target') then
      return cast(SB.SpellSteal, 'target')
    end

    if player.moving then
      return cast(SB.IceLance)
    end

    if spell(SB.Frostbolt).current and -buff(SB.BrainFreeze) and not talent(7,3) then
    	PlaySound(SOUNDKIT.GM_CHAT_WARNING, "Master");
    end

    if GetItemCooldown(159624) == 0 and toggle('cooldowns', false) then
           macro('/cast Rotcrusted Voodoo Doll')
    end
    -- Filler below
    return cast(SB.Frostbolt, 'target')
  end
end

-- Put great stuff here to do when your out of combat
local function resting()

  local inRange = 0
    for i = 1, 40 do
      if UnitExists('nameplate' .. i) and IsSpellInRange('Ebonbolt', 'nameplate' .. i) == 1 and UnitAffectingCombat('nameplate' .. i) then 
        inRange = inRange + 1
      end 
  end

   bxhnz7tp5bge7wvu.interface.status_extra('R:' .. bxhnz7tp5bge7wvu.version ..  '      T#:' .. inRange .. ' |cff5BFF33   D:|r ' .. target.distance)
  local mylevel = UnitLevel("player")
  local group_type_ds = IsInRaid() and 'raid' or IsInGroup() and 'party' or 'solo'
  local nameplates = bxhnz7tp5bge7wvu.settings.fetch('dr_example_usenameplates', false)
  local seeplates = GetCVar("nameplateShowEnemies")
  local callpet = bxhnz7tp5bge7wvu.settings.fetch('dr_example_callpet')

  if modifier.control and not -target.debuff(SB.FrostNova) and spell(SB.FrostNova).charges >= 1 then
    return cast(SB.FrostNova)
  end

  if nameplates == true and seeplates == '0' then
     SetCVar("nameplateShowEnemies",1)
  end

  if nameplates == false and seeplates == '1' then
     SetCVar("nameplateShowEnemies",0)
  end

  if not pet.exists and callpet == true and player.alive and not player.moving then 
    return cast(SB.SummonWaterElemental)
  end

  if not -buff(SB.IceBarrior) and player.moving  and toggle('ice_barrier', false) and player.alive then
    return cast(SB.IceBarrior, 'player')
  end

  if not -buff(SB.ArcaneInt) and player.moving and player.alive then
    return cast(SB.ArcaneInt, 'player')
  end
end

local function interface()



  local example = {
    key = 'dr_example',
    title = 'DarkRotations - Mage',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = 'Frost Mage Settings', align= 'center' },
      { type = 'text', text = 'Everything on the screen is LIVE.  As you make changes, they are being fed to the engine.' },
      { type = 'rule' },   
      { type = 'text', text = 'General Settings' },
      { key = 'callpet', type = 'checkbox', text = 'Call Pet', desc = 'Always call Water Elemental ' },
      { key = 'usenameplates', type = 'checkbox', text = 'Show Enemy Nameplates', desc = 'Use name plates to count baddies' },
      { key = 'healthstone', type = 'checkspin', text = 'Healthstone', desc = 'Auto use Healthstone at health %', min = 5, max = 100, step = 5 },
      { key = 'multi', type = 'spinner', text = 'MultiTarget', desc = 'Number of enemies to use AOE', min = 1, max = 20, step = 1 },
      -- { key = 'input', type = 'input', text = 'TextBox', desc = 'Description of Textbox' },
      { key = 'spinner', type = 'spinner', text = 'Interrupt %', desc = 'What % you will be interupting at', min = 5, max = 100, step = 5 },
      { type = 'rule' },   
      { type = 'text', text = 'PVP Options' },
      { key = 'usepolymorph', type = 'checkbox', text = 'Polymorph', desc = 'Polymorph your target if possible' },
      { key = 'usefrostnova', type = 'checkbox', text = 'Frost Nova', desc = 'Auto use Frost Nova if target is near' },
      { key = 'usespellsteal', type = 'checkbox', text = 'Spell Steal', desc = 'Use Spell Steal when possible' },
      { type = 'rule' },   
      { type = 'text', text = 'Raid / M+ / Party Options' },
      { key = 'heavymovement', type = 'checkbox', text = 'Heavy movement fight', desc = 'Rotation will be based on heavy movement' },
    }
  }

  configWindow = bxhnz7tp5bge7wvu.interface.builder.buildGUI(example)

  bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
    name = 'ice_barrier',
    label = 'Ice Barrier Auto Cast',
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
     name = 'sounds',
    label = 'Annoy you to smash GS',
    font = 'bxhnz7tp5bge7wvu_icon',
    on = {
      label = bxhnz7tp5bge7wvu.interface.icon('music'),
      color = bxhnz7tp5bge7wvu.interface.color.blue,
      color2 = bxhnz7tp5bge7wvu.interface.color.ratio(bxhnz7tp5bge7wvu.interface.color.dark_blue, 0.7)
    },
    off = {
      label = bxhnz7tp5bge7wvu.interface.icon('music'),
      color = bxhnz7tp5bge7wvu.interface.color.grey,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_grey
    }
  })
    bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
     name = 'iceblockon',
    label = 'Use Control for IceBlock',
    font = 'bxhnz7tp5bge7wvu_icon',
    on = {
      label = bxhnz7tp5bge7wvu.interface.icon('cube'),
      color = bxhnz7tp5bge7wvu.interface.color.blue,
      color2 = bxhnz7tp5bge7wvu.interface.color.ratio(bxhnz7tp5bge7wvu.interface.color.dark_blue, 0.7)
    },
    off = {
      label = bxhnz7tp5bge7wvu.interface.icon('cube'),
      color = bxhnz7tp5bge7wvu.interface.color.grey,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_grey
    }
  })
  bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
     name = 'gspike',
    label = 'Use GlacialSpike on CD (AOE)',
    font = 'bxhnz7tp5bge7wvu_icon',
    on = {
      label = bxhnz7tp5bge7wvu.interface.icon('cube'),
      color = bxhnz7tp5bge7wvu.interface.color.blue,
      color2 = bxhnz7tp5bge7wvu.interface.color.ratio(bxhnz7tp5bge7wvu.interface.color.dark_blue, 0.7)
    },
    off = {
      label = bxhnz7tp5bge7wvu.interface.icon('smile'),
      color = bxhnz7tp5bge7wvu.interface.color.grey,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_grey
    }
  })

  bxhnz7tp5bge7wvu.interface.buttons.add_toggle({
    name = 'settings',
    label = 'Rotation Settings',
    font = 'bxhnz7tp5bge7wvu_icon',
    on = {
      label = bxhnz7tp5bge7wvu.interface.icon('cog'),
      color = bxhnz7tp5bge7wvu.interface.color.cyan,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_blue
    },
    off = {
      label = bxhnz7tp5bge7wvu.interface.icon('cog'),
      color = bxhnz7tp5bge7wvu.interface.color.grey,
      color2 = bxhnz7tp5bge7wvu.interface.color.dark_grey
    },
    callback = function(self)
      if configWindow.parent:IsShown() then
        configWindow.parent:Hide()
      else
        configWindow.parent:Show()
      end

    end
  })
end

bxhnz7tp5bge7wvu.rotation.register({
  spec = bxhnz7tp5bge7wvu.rotation.classes.mage.frost,
  name = 'frost',
  label = 'Bundled Frost by Rotations',
  combat = combat,
  gcd = gcd,
  resting = resting,
  interface = interface
})

