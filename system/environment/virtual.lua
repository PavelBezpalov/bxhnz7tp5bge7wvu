local addon, bxhnz7tp5bge7wvu = ...

bxhnz7tp5bge7wvu.environment.virtual = {
  targets = {},
  resolvers = {},
  resolved = {},
  exclude_tanks = true
}

local function GroupType()
  return IsInRaid() and 'raid' or IsInGroup() and 'party' or 'solo'
end

function bxhnz7tp5bge7wvu.environment.virtual.validate(virtualID)
  if bxhnz7tp5bge7wvu.environment.virtual.targets[virtualID] or virtualID == 'group' then
    return true
  end
  return false
end

function bxhnz7tp5bge7wvu.environment.virtual.resolve(virtualID)
  if virtualID == 'group' then
    return 'group', 'group'
  else
    return bxhnz7tp5bge7wvu.environment.virtual.resolved[virtualID], 'unit'
  end
end

function bxhnz7tp5bge7wvu.environment.virtual.targets.lowest()
  local members = GetNumGroupMembers()
  local group_type = GroupType()
  if bxhnz7tp5bge7wvu.environment.virtual.resolvers[group_type] then
    return bxhnz7tp5bge7wvu.environment.virtual.resolvers[group_type](members)
  end
end

function bxhnz7tp5bge7wvu.environment.virtual.targets.tank()
  return bxhnz7tp5bge7wvu.environment.virtual.resolvers.tanks('MAINTANK')
end

function bxhnz7tp5bge7wvu.environment.virtual.targets.offtank()
  return bxhnz7tp5bge7wvu.environment.virtual.resolvers.tanks('MAINASSIST')
end

function bxhnz7tp5bge7wvu.environment.virtual.resolvers.unit(unitA, unitB)
  local healthA = UnitHealth(unitA) / UnitHealthMax(unitA) * 100
  local healthB = UnitHealth(unitB) / UnitHealthMax(unitB) * 100
  if healthA < healthB then
    return unitA, healthA
  else
    return unitB, healthB
  end
end

function bxhnz7tp5bge7wvu.environment.virtual.resolvers.party(members)
  local lowest = 'player'
  local lowest_health
  for i = 1, (members - 1) do
    local unit = 'party' .. i
    if not UnitCanAttack('player', unit) and UnitInRange(unit) and not UnitIsDeadOrGhost(unit) and (not bxhnz7tp5bge7wvu.environment.virtual.exclude_tanks or not bxhnz7tp5bge7wvu.environment.virtual.resolvers.tank(unit)) then
      if not lowest then
        lowest, lowest_health = bxhnz7tp5bge7wvu.environment.virtual.resolvers.unit(unit, 'player')
      else
        lowest, lowest_health = bxhnz7tp5bge7wvu.environment.virtual.resolvers.unit(unit, lowest)
      end
    end
  end
  return lowest
end

function bxhnz7tp5bge7wvu.environment.virtual.resolvers.raid(members)
  local lowest = 'player'
  local lowest_health
  for i = 1, members do
    local unit = 'raid' .. i
    if not UnitCanAttack('player', unit) and UnitInRange(unit) and not UnitIsDeadOrGhost(unit) and (not bxhnz7tp5bge7wvu.environment.virtual.exclude_tanks or not bxhnz7tp5bge7wvu.environment.virtual.resolvers.tank(unit)) then
      if not lowest then
        lowest, lowest_health = unit, UnitHealth(unit)
      else
        lowest, lowest_health = bxhnz7tp5bge7wvu.environment.virtual.resolvers.unit(unit, lowest)
      end
    end
  end
  return lowest
end

function bxhnz7tp5bge7wvu.environment.virtual.resolvers.tank(unit)
  return GetPartyAssignment('MAINTANK', unit) or GetPartyAssignment('MAINASSIST', unit) or UnitGroupRolesAssigned(unit) == 'TANK'
end

function bxhnz7tp5bge7wvu.environment.virtual.resolvers.tanks(assignment)
  local members = GetNumGroupMembers()
  local group_type = GroupType()
  if UnitExists('focus') and not UnitCanAttack('player', 'focus') and not UnitIsDeadOrGhost('focus') and assignment == 'MAINTANK' then
    return 'focus'
  end
  if group_type ~= 'solo' then
    for i = 1, (members - 1) do
      local unit = group_type .. i
      if (GetPartyAssignment(assignment, unit) or (assignment == 'MAINTANK' and UnitGroupRolesAssigned(unit) == 'TANK')) and not UnitCanAttack('player', unit) and not UnitIsDeadOrGhost(unit) then
        return unit
      end
    end
  end
  return 'player'
end

function bxhnz7tp5bge7wvu.environment.virtual.resolvers.solo()
  return 'player'
end

bxhnz7tp5bge7wvu.on_ready(function()
  C_Timer.NewTicker(0.2, function()
    for target, callback in pairs(bxhnz7tp5bge7wvu.environment.virtual.targets) do
      bxhnz7tp5bge7wvu.environment.virtual.resolved[target] = callback()
    end
  end)
end)
