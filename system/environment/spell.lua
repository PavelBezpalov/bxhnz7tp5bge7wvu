local addon, bxhnz7tp5bge7wvu = ...

local spell = { }

local function spell_cooldown(spell)
  local time, value = GetSpellCooldown(spell)
  if not time or time == 0 then
    return 0
  end
  local cd = time + value - GetTime() - (select(4, GetNetStats()) / 1000)
  if cd > 0 then
    return cd
  else
    return 0
  end
end

local function gcd_remains()
  return spell_cooldown(61304)
end

function spell:cooldown()
  return spell_cooldown(self.spell)
end

function spell:ready()
  return spell_cooldown(self.spell) <= gcd_remains()
end

function spell:cooldown_without_gcd()
  return spell_cooldown(self.spell) - gcd_remains()
end

function spell:cooldown_duration()
  local haste_mod = 1 + UnitSpellHaste("player") / 100
  local cooldown_ms, gcd_ms = GetSpellBaseCooldown(self.spell)
  return (cooldown_ms / haste_mod ) / 1000
end

function spell:exists()
  return IsPlayerSpell(self.spell)
end

function spell:casting_remains()
  local casting_name, _, _, _, casting_end_time = UnitCastingInfo(self.unitID)
  local channel_name, _, _, _, channel_end_time = UnitChannelInfo(self.unitID)
  if casting_name == self.spell then return casting_end_time / 1000 - GetTime() end
  if channel_name == self.spell then return channel_end_time / 1000 - GetTime() end
  return 0
end

function spell:castingtime()
  local name, _, _, castingTime = GetSpellInfo(self.spell)
  if name and castingTime then
    return castingTime / 1000
  end
  return 9999
end

function spell:charges()
  return GetSpellCharges(self.spell) or 0
end

local syncTime
local lastSync

function spell:fractionalcharges()
  local currentCharges, maxCharges, Start, Duration = GetSpellCharges(self.spell)
  local currentSync = GetTime() - Start
  if syncTime == nil then
    syncTime = currentSync
    lastSync = Start
  elseif Start ~= lastSync then
    syncTime = currentSync
    lastSync = Start
  end
  local syncedTime = GetTime() - syncTime
  local currentChargesFraction = (syncedTime - Start) / Duration
  local fractionalCharges = math.floor((currentCharges + currentChargesFraction)*100)/100
  if fractionalCharges > maxCharges then
    return maxCharges
  else
    return fractionalCharges
  end
end

function spell:recharge()
  local Charges, MaxCharges, CDTime, CDValue = GetSpellCharges(self.spell);
  if Charges == MaxCharges then
    return 0;
  end
  local CD = CDTime + CDValue - GetTime()
  if CD > 0 then
    return CD;
  else
    return 0;
  end
end

function spell:recharge_duration()
  local current_charges, max_charges, cooldown_start, cooldown_duration = GetSpellCharges(self.spell)
  return cooldown_duration
end

function spell:full_recharge_time()
  local current_charges, max_charges, cooldown_start, cooldown_duration = GetSpellCharges(self.spell)
  if not current_charges then return 0 end
  local diff = max_charges - current_charges
  if not current_charges or diff == 0 then return 0 end
  return cooldown_start + cooldown_duration * diff - GetTime()
end

function spell:lastcast()
  local lastcast = bxhnz7tp5bge7wvu.tmp.fetch('lastcast', false)
  return lastcast == self.spell
end

function spell:castable()
  local usable, noMana = IsUsableSpell(self.spell)
  if usable then
    if self.cooldown <= gcd_remains() then
      return true
    else
      return false
    end
  end
  return false
end

function spell:current()
  local casting, _ = UnitCastingInfo(self.unitID)
  local channel, _ = UnitChannelInfo(self.unitID)
  if casting then return self.spell == casting end
  if channel then return self.spell == channel end
  return false
end

function bxhnz7tp5bge7wvu.environment.conditions.spell(unit)
  return setmetatable({
    unitID = unit.unitID
  }, {
    __index = function(t, k)
      if t.unitID then
        local result = spell[k](t)
        bxhnz7tp5bge7wvu.console.debug(4, 'spell', 'indigo', t.unitID .. '.spell(' .. t.spell .. ').' .. k .. ' = ' .. bxhnz7tp5bge7wvu.format(result))
        return result
      end
      return false
    end,
    __call = function(t, k)
      t.spell = k
      if tonumber(t.spell) then
          t.spell = GetSpellInfo(t.spell)
      end
      return t
    end,
    __unm = function(t)
      local result = spell['cooldown'](t)
      bxhnz7tp5bge7wvu.console.debug(4, 'spell', 'indigo', t.unitID .. '.spell(' .. t.spell .. ').cooldown = ' .. bxhnz7tp5bge7wvu.format(result))
      return result
    end
  })
end
