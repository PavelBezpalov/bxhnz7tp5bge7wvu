local addon, bxhnz7tp5bge7wvu = ...

bxhnz7tp5bge7wvu.environment = {
  conditions = { },
  hooks = { },
  unit_cache = { },
  group_cache = nil,
  hook_cache = { }
}

local env = { }

bxhnz7tp5bge7wvu.environment.env = setmetatable(env, {
  __index = function(_env, called)
    local ds = debugstack(2, 1, 0)
    local file, line = string.match(ds, '^.-\(%a-%.lua):(%d+):.+$')
    bxhnz7tp5bge7wvu.console.file = file
    bxhnz7tp5bge7wvu.console.line = line
    if bxhnz7tp5bge7wvu.environment.logical.validate(called) then
      if not bxhnz7tp5bge7wvu.environment.unit_cache[called] then
        bxhnz7tp5bge7wvu.environment.unit_cache[called] = bxhnz7tp5bge7wvu.environment.conditions.unit(called)
      end
      return bxhnz7tp5bge7wvu.environment.unit_cache[called]
    elseif bxhnz7tp5bge7wvu.environment.virtual.validate(called) then
      local resolved, virtual_type = bxhnz7tp5bge7wvu.environment.virtual.resolve(called)
      if virtual_type == 'unit' then
        if not bxhnz7tp5bge7wvu.environment.unit_cache[resolved] then
          bxhnz7tp5bge7wvu.environment.unit_cache[resolved] = bxhnz7tp5bge7wvu.environment.conditions.unit(resolved)
        end
        return bxhnz7tp5bge7wvu.environment.unit_cache[resolved]
      elseif virtual_type == 'group' then
        if not bxhnz7tp5bge7wvu.environment.group_cache then
          bxhnz7tp5bge7wvu.environment.group_cache = bxhnz7tp5bge7wvu.environment.conditions.group()
        end
        return bxhnz7tp5bge7wvu.environment.group_cache
      end
    elseif bxhnz7tp5bge7wvu.environment.hooks[called] then
      if not bxhnz7tp5bge7wvu.environment.hook_cache[called] then
        bxhnz7tp5bge7wvu.environment.hook_cache[called] = bxhnz7tp5bge7wvu.environment.hooks[called]
      end
      return bxhnz7tp5bge7wvu.environment.hook_cache[called]
    end
    return _G[called]
  end
})

function bxhnz7tp5bge7wvu.environment.hook(func)
  setfenv(func, bxhnz7tp5bge7wvu.environment.env)
end

function bxhnz7tp5bge7wvu.environment.iterator(raw)
  local members = GetNumGroupMembers()
  local group_type = IsInRaid() and 'raid' or IsInGroup() and 'party' or 'solo'
  local index = 0
  local returned_solo = false
  return function()
    local called
    if group_type == 'solo' and not returned_solo then
      returned_solo = true
      called = 'player'
    elseif group_type ~= 'solo' then
      if index <= members then
        index = index + 1
        if group_type == 'party' and index == members then
          called = 'player'
        else
          called = group_type .. index
        end
      end
    end
    if called then
      if raw then
        return called
      end
      if not bxhnz7tp5bge7wvu.environment.unit_cache[called] then
        bxhnz7tp5bge7wvu.environment.unit_cache[called] = bxhnz7tp5bge7wvu.environment.conditions.unit(called)
      end
      return bxhnz7tp5bge7wvu.environment.unit_cache[called]
    end
  end
end

bxhnz7tp5bge7wvu.environment.hooks.each_member = bxhnz7tp5bge7wvu.environment.iterator

bxhnz7tp5bge7wvu.environment.unit_buff = function(target, spell, owner)
  local buff, count, caster, expires, spellID
  local i = 0; local go = true
  while i <= 40 and go do
    i = i + 1
    buff, _, count, _, duration, expires, caster, stealable, _, spellID = _G['UnitBuff'](target, i)
    if not owner then
      if ((tonumber(spell) and spellID == tonumber(spell)) or buff == spell) and caster == "player" then go = false end
    elseif owner == "any" then
      if ((tonumber(spell) and spellID == tonumber(spell)) or buff == spell) then go = false end
    end
  end
  return buff, count, duration, expires, caster, stealable
end

bxhnz7tp5bge7wvu.environment.unit_debuff = function(target, spell, owner)
  local debuff, count, caster, expires, spellID
  local i = 0; local go = true
  while i <= 40 and go do
    i = i + 1
    debuff, _, count, _, duration, expires, caster, _, _, spellID = _G['UnitDebuff'](target, i)
    if not owner then
      if ((tonumber(spell) and spellID == tonumber(spell)) or debuff == spell) and caster == "player" then go = false end
    elseif owner == "any" then
      if ((tonumber(spell) and spellID == tonumber(spell)) or debuff == spell) then go = false end
    end
  end
  return debuff, count, duration, expires, caster
end

bxhnz7tp5bge7wvu.environment.unit_reverse_debuff = function(target, candidates)
  local debuff, count, caster, expires, spellID
  local i = 0; local go = true
  while i <= 40 and go do
    i = i + 1
    debuff, _, count, _, duration, expires, caster, _, _, spellID = _G['UnitDebuff'](target, i)
    if candidates[spellID] then go = false end
  end
  return debuff, count, duration, expires, caster, candidates[spellID]
end
