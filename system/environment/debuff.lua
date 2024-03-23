local addon, bxhnz7tp5bge7wvu = ...

local UnitDebuff = bxhnz7tp5bge7wvu.environment.unit_debuff

local debuff = { }

function debuff:exists()
  local debuff, count, duration, expires, caster = UnitDebuff(self.unitID, self.spell, 'any')
  if debuff and (caster == 'player' or caster == 'pet') then
    return true
  end
  return false
end

function debuff:down()
  return not self.exists
end

function debuff:up()
  return self.exists
end

function debuff:any()
  local debuff, count, duration, expires, caster = UnitDebuff(self.unitID, self.spell, 'any')
  if debuff then
    return true
  end
  return false
end

function debuff:count()
  local debuff, count, duration, expires, caster = UnitDebuff(self.unitID, self.spell, 'any')
  if debuff and (caster == 'player' or caster == 'pet') then
    return count
  end
  return 0
end

function debuff:remains()
  local debuff, count, duration, expires, caster = UnitDebuff(self.unitID, self.spell, 'any')
  if debuff and (caster == 'player' or caster == 'pet') then
    return expires - GetTime()
  end
  return 0
end

function debuff:duration()
  local debuff, count, duration, expires, caster = UnitDebuff(self.unitID, self.spell, 'any')
  if debuff and (caster == 'player' or caster == 'pet') then
    return duration
  end
  return 0
end

function debuff:refreshable()
  return not self.exists or self.remains < 0.3 * self.duration
end

function bxhnz7tp5bge7wvu.environment.conditions.debuff(unit)
  return setmetatable({
    unitID = unit.unitID
  }, {
    __index = function(t, k)
      local result = debuff[k](t)
      bxhnz7tp5bge7wvu.console.debug(4, 'debuff', 'teal', t.unitID .. '.debuff(' .. t.spell .. ').' .. k .. ' = ' .. bxhnz7tp5bge7wvu.format(result))
      return result
    end,
    __call = function(t, k)
      t.spell = k
      if tonumber(t.spell) then
        t.spell = GetSpellInfo(t.spell)
      end
      return t
    end,
    __unm = function(t)
      local result = debuff['exists'](t)
      bxhnz7tp5bge7wvu.console.debug(4, 'debuff', 'teal', t.unitID .. '.debuff(' .. t.spell .. ').exists = ' .. bxhnz7tp5bge7wvu.format(result))
      return debuff['exists'](t)
    end
  })
end
