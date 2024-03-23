local addon, bxhnz7tp5bge7wvu = ...

local lastcasted_target = nil

function _CastSpellByName(spell, target)
  local target = target or "target"
  pcall(CastSpellByName,spell,target)
  lastcasted_target = target
  bxhnz7tp5bge7wvu.console.debug(2, 'cast', 'red', spell .. ' on ' .. target)
  bxhnz7tp5bge7wvu.interface.status(spell)
end

function _CastGroundSpellByName(spell)
  pcall(CastSpellByName,spell,'cursor')
  bxhnz7tp5bge7wvu.console.debug(2, 'cast', 'red', spell .. ' on cursor')
  bxhnz7tp5bge7wvu.interface.status(spell)
end

function _CastSpellByID(spell, target)
  if tonumber(spell) then
    spell, _ = GetSpellInfo(spell)
  end
  return _CastSpellByName(spell, target)
end

function _CastGroundSpellByID(spell, target)
  if tonumber(spell) then
    spell, _ = GetSpellInfo(spell)
  end
  return _CastGroundSpellByName(spell, target)
end

function _SpellStopCasting()
  pcall(SpellStopCasting)
end

function _SpellCancelQueuedSpell()
  pcall(SpellCancelQueuedSpell)
end

local function auto_attack()
  if not IsCurrentSpell(6603) then
    pcall(CastSpellByID,6603)
  end
end

local function auto_shot()
  if not IsAutoRepeatSpell(GetSpellInfo(75)) then
    pcall(CastSpellByID,75)
  end
end

function _RunMacroText(text)
  pcall(RunMacroText,text)
  bxhnz7tp5bge7wvu.console.debug(2, 'macro', 'red', text)
  bxhnz7tp5bge7wvu.interface.status('Macro')
end

local function is_unlocked()
  unlocked = false
  RunScript([[
    if not issecure() then
      return
    end
    unlocked = true
  ]])
  return unlocked
end

local turbo = false

function bxhnz7tp5bge7wvu.environment.hooks.cast(spell, target)
  if not bxhnz7tp5bge7wvu.protected then return end
  if type(target) == 'table' then target = target.unitID end
  if not UnitCastingInfo('player') then
    if target == 'ground' then
      if tonumber(spell) then
        _CastGroundSpellByID(spell, target)
      else
        _CastGroundSpellByName(spell, target)
      end
    else
      if tonumber(spell) then
        _CastSpellByID(spell, target)
      else
        _CastSpellByName(spell, target)
      end
    end
  end
end

function bxhnz7tp5bge7wvu.environment.hooks.cast_with_queue(spell, target)
  if not bxhnz7tp5bge7wvu.protected then return end
  if type(target) == 'table' then target = target.unitID end
  local isCurrentSpell = IsCurrentSpell(spell)
  
  if not isCurrentSpell then
    _SpellCancelQueuedSpell()
  end
  
  if target == 'ground' then
    if tonumber(spell) then
      _CastGroundSpellByID(spell, target)
    else
      _CastGroundSpellByName(spell, target)
    end
  else
    if tonumber(spell) then
      _CastSpellByID(spell, target)
    else
      _CastSpellByName(spell, target)
    end
  end
end

function bxhnz7tp5bge7wvu.environment.hooks.cast_while_casting(spell, target)
  if not bxhnz7tp5bge7wvu.protected then return end
  if type(target) == 'table' then target = target.unitID end
  if target == 'ground' then
    if tonumber(spell) then
      _CastGroundSpellByID(spell, target)
    else
      _CastGroundSpellByName(spell, target)
    end
  else
    if tonumber(spell) then
      _CastSpellByID(spell, target)
    else
      _CastSpellByName(spell, target)
    end
  end
end

function bxhnz7tp5bge7wvu.environment.hooks.sequenceactive(sequence)
  if sequence.active then
    return true
  end
  return false
end

function bxhnz7tp5bge7wvu.environment.hooks.dosequence(sequence)
  if sequence.complete then return false end
  if #sequence.spells == 0 then return false end
  return true
end

function bxhnz7tp5bge7wvu.environment.hooks.sequence(sequence)
  if not bxhnz7tp5bge7wvu.protected then return end
  if sequence.complete then return true end
  if not sequence.active then sequence.active = true end
  if not sequence.copy then
    sequence.copy = { }
    for _, value in ipairs(sequence.spells) do
      table.insert(sequence.copy, value)
    end
  end
  local lastcast = bxhnz7tp5bge7wvu.tmp.fetch('lastcast', false)
  local nextcast = sequence.copy[1]
  if tonumber(nextcast.spell) then
    nextcast.spell = GetSpellInfo(nextcast.spell)
  end
  if lastcast ~= nextcast.spell then
    _CastSpellByName(nextcast.spell, nextcast.target)
  else
    table.remove(sequence.copy, 1)
    if #sequence.copy == 0 then
      sequence.complete = true
    end
  end
end

function bxhnz7tp5bge7wvu.environment.hooks.resetsequence(sequence)
  if sequence.copy then
    sequence.copy = nil
    sequence.complete = false
    sequence.active = false
  end
end

function bxhnz7tp5bge7wvu.environment.hooks.auto_attack()
  auto_attack()
end

function bxhnz7tp5bge7wvu.environment.hooks.auto_shot()
  auto_shot()
end

function bxhnz7tp5bge7wvu.environment.hooks.stopcast()
  _SpellStopCasting()
end

function bxhnz7tp5bge7wvu.environment.hooks.cancel_queued_spell()
  _SpellCancelQueuedSpell()
end

function bxhnz7tp5bge7wvu.environment.hooks.macro(text)
  _RunMacroText(text)
end

function bxhnz7tp5bge7wvu.environment.virtual.targets.lastcasted_target()
  return lastcasted_target
end

local timer
timer = C_Timer.NewTicker(0.5, function()
  if not bxhnz7tp5bge7wvu.protected then
    local unlocked = is_unlocked()
    --print(unlocked)
    if unlocked then
    --if true then
      bxhnz7tp5bge7wvu.log('Enhanced functionality enabled!')
      bxhnz7tp5bge7wvu.protected = true
      timer:Cancel()
    end
  end
end)

bxhnz7tp5bge7wvu.event.register("UNIT_SPELLCAST_SUCCEEDED", function(...)
  local unitID, lineID, spellID = ...
  local spell = GetSpellInfo(spellID)
  if unitID == "player" then
    bxhnz7tp5bge7wvu.tmp.store('lastcast', spell)
  end
end)
