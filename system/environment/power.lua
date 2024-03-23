local addon, bxhnz7tp5bge7wvu = ...

local power = { }

function power:base()
  return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit)
end

function power:mana()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.Mana, 'mana')
end

function power:rage()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.Rage, 'rage')
end

function power:focus()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.Focus, 'focus')
end

function power:energy()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.Energy, 'energy')
end

function power:combopoints()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.ComboPoints, 'combopoints')
end

function power:runes()
 return bxhnz7tp5bge7wvu.environment.conditions.runes(self.unit, 'runes')
end

function power:runicpower()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.RunicPower, 'runicpower')
end

function power:soulshards()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.SoulShards, 'soulshards')
end

function power:lunarpower()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.LunarPower, 'lunarpower')
end

function power:astral()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.LunarPower, 'astral')
end

function power:holypower()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.HolyPower, 'holypower')
end

function power:maelstrom()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.Maelstrom, 'maelstrom')
end

function power:chi()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.Chi, 'chi')
end

function power:insanity()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.Insanity, 'insanity')
end

function power:arcanecharges()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.ArcaneCharges, 'arcanecharges')
end

function power:fury()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.Fury, 'fury')
end

function power:pain()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.Pain, 'pain')
end

function power:essence()
 return bxhnz7tp5bge7wvu.environment.conditions.powerType(self.unit, Enum.PowerType.Essence, 'essence')
end

function bxhnz7tp5bge7wvu.environment.conditions.power(unit, called)
  return setmetatable({
    unit = unit,
    unitID = unit.unitID
  }, {
    __index = function(t, k)
      return power[k](t)
    end,
    __unm = function(t)
      return power['base'](t)
    end
  })
end
