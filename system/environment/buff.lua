local addon, bxhnz7tp5bge7wvu = ...

local UnitBuff = bxhnz7tp5bge7wvu.environment.unit_buff

local buff = { }

function buff:exists()
  local buff, count, duration, expires, caster = UnitBuff(self.unitID, self.spell, 'any')
  if buff and (caster == 'player' or caster == 'pet') then
    return true
  end
  return false
end

function buff:down()
  return not self.exists
end

function buff:up()
  return self.exists
end

function buff:any()
  local buff, count, duration, expires, caster = UnitBuff(self.unitID, self.spell, 'any')
  if buff then
    return true
  end
  return false
end

function buff:count()
  local buff, count, duration, expires, caster = UnitBuff(self.unitID, self.spell, 'any')
  if buff and (caster == 'player' or caster == 'pet') then
    return count
  end
  return 0
end

function buff:remains()
  local buff, count, duration, expires, caster = UnitBuff(self.unitID, self.spell, 'any')
  if buff and (caster == 'player' or caster == 'pet') then
    return expires - GetTime()
  end
  return 0
end

function buff:duration()
  local buff, count, duration, expires, caster = UnitBuff(self.unitID, self.spell, 'any')
  if buff and (caster == 'player' or caster == 'pet') then
    return duration
  end
  return 0
end

function buff:stealable()
  local buff, count, duration, expires, caster, stealable = UnitBuff(self.unitID, self.spell, 'any')
  if stealable then
    return true
  end
  return false
end

function buff:refreshable()
  return not self.exists or self.remains < 0.3 * self.duration
end

function bxhnz7tp5bge7wvu.environment.conditions.buff(unit)
  return setmetatable({
    unitID = unit.unitID
  }, {
    __index = function(t, k)
      local result = buff[k](t)
      bxhnz7tp5bge7wvu.console.debug(4, 'buff', 'green', t.unitID .. '.buff(' .. t.spell .. ').' .. k .. ' = ' .. bxhnz7tp5bge7wvu.format(result))
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
      local result = buff['exists'](t)
      bxhnz7tp5bge7wvu.console.debug(4, 'buff', 'green', t.unitID .. '.buff(' .. t.spell .. ').exists = ' .. bxhnz7tp5bge7wvu.format(result))
      return result
    end
  })
end
