local addon, bxhnz7tp5bge7wvu = ...

bxhnz7tp5bge7wvu.rotation = {
  classes = {
    deathknight = { blood = 250, frost = 251, unholy = 252 },
    demonhunter = { havoc = 577, vengeance = 581 },
    druid = { balance = 102, feral = 103, guardian = 104, restoration = 105 },
    evoker = { devastation = 1467, preservation = 1468, augmentation = 1473 },
    hunter = { beastmastery = 253, marksmanship = 254, survival = 255 },
    mage = { arcane = 62, fire = 63, frost = 64 },
    monk = { brewmaster = 268, windwalker = 269, mistweaver = 270 },
    paladin = { holy = 65, protection = 66, retribution = 70 },
    priest = { discipline = 256, holy = 257, shadow = 258 },
    rogue = { assassination = 259, outlaw = 260, subtlety = 261 },
    shaman = { elemental = 262, enhancement = 263, restoration = 264 },
    warlock = { affliction = 265, demonology = 266, destruction = 267 },
    warrior = { arms = 71, fury = 72, protection = 73 }
  },
  rotation_store = { },
  spellbooks = { },
  talentbooks = { },
  dispellbooks = { },
  active_rotation = false
}

function bxhnz7tp5bge7wvu.rotation.register(config)
  if config.gcd then
    setfenv(config.gcd, bxhnz7tp5bge7wvu.environment.env)
  end
  if config.combat then
    setfenv(config.combat, bxhnz7tp5bge7wvu.environment.env)
  end
  if config.resting then
    setfenv(config.resting, bxhnz7tp5bge7wvu.environment.env)
  end
  bxhnz7tp5bge7wvu.rotation.rotation_store[config.name .. config.spec] = config
end

function bxhnz7tp5bge7wvu.rotation.load(name)
  local rotation
  for _, rot in pairs(bxhnz7tp5bge7wvu.rotation.rotation_store) do
    if (rot.spec == bxhnz7tp5bge7wvu.rotation.current_spec or rot.spec == false) and rot.name == name then
      rotation = rot
    end
  end

  if rotation then
    bxhnz7tp5bge7wvu.settings.store('active_rotation_' .. bxhnz7tp5bge7wvu.rotation.current_spec, name)
    bxhnz7tp5bge7wvu.rotation.active_rotation = rotation
    bxhnz7tp5bge7wvu.interface.buttons.reset()
    if rotation.interface then
      rotation.interface(rotation)
    end
    bxhnz7tp5bge7wvu.log('Loaded rotation: ' .. name)
    bxhnz7tp5bge7wvu.interface.status('Ready...')
  else
    bxhnz7tp5bge7wvu.error('Unload to load rotation: ' .. name)
  end
end

local loading_wait = false

local function init()
  if not loading_wait then
    C_Timer.After(0.3, function()
      bxhnz7tp5bge7wvu.rotation.current_spec = GetSpecializationInfo(GetSpecialization())
      local active_rotation = bxhnz7tp5bge7wvu.settings.fetch('active_rotation_' .. bxhnz7tp5bge7wvu.rotation.current_spec, false)
      if active_rotation then
        bxhnz7tp5bge7wvu.rotation.load(active_rotation)
        bxhnz7tp5bge7wvu.interface.status('Ready...')
      else
        bxhnz7tp5bge7wvu.interface.status('Load a rotation...')
      end
      loading_wait = false
    end)
  end
end

bxhnz7tp5bge7wvu.on_ready(function()
  init()
  loading_wait = true
end)

bxhnz7tp5bge7wvu.event.register("ACTIVE_TALENT_GROUP_CHANGED", function(...)
  init()
  loading_wait = true
end)
