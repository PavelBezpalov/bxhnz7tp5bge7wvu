local addon, bxhnz7tp5bge7wvu = ...

local enemies = {}
local enemies_cache = {}

local function enemies_count(func)
  local count = 0
  for _, unit in pairs(enemies_cache) do
    if func(unit) then
      count = count + 1
    end
  end
  return count
end

function enemies:count(func)
  return enemies_count
end

local function enemies_match(func)
  for _, unit in pairs(enemies_cache) do
    if func(unit) then 
      return unit
    end
  end
  return false
end

function enemies:match(func)
  return enemies_match
end

local function enemies_around(distance)
  return enemies_count(function (unit)
    return unit.alive 
      and (
        (distance and unit.distance <= distance)
        or not distance
      )
  end)
end

function enemies:around(distance)
  return enemies_around
end

function bxhnz7tp5bge7wvu.environment.conditions.enemies()
  return setmetatable({ }, {
    __index = function(t, k)
      return enemies[k](t)
    end
  })
end

local function add_enemy(unitID)
  if not enemies_cache[unitID] and not UnitIsFriend("player", unitID) then
    enemies_cache[unitID] = bxhnz7tp5bge7wvu.environment.conditions.unit(unitID)
  end
end

local function remove_enemy(unitID)
  if enemies_cache[unitID] then
    enemies_cache[unitID] = nil
  end
end

bxhnz7tp5bge7wvu.event.register("NAME_PLATE_UNIT_ADDED", function(...)
  return add_enemy(...)
end)

bxhnz7tp5bge7wvu.event.register("FORBIDDEN_NAME_PLATE_UNIT_ADDED", function(...)
  return add_enemy(...)
end)

bxhnz7tp5bge7wvu.event.register("NAME_PLATE_UNIT_REMOVED", function(...)
  return remove_enemy(...)
end)

bxhnz7tp5bge7wvu.event.register("FORBIDDEN_NAME_PLATE_UNIT_REMOVED", function(...)
  return remove_enemy(...)
end)

local function update_ttd()
  for key, unit in pairs(enemies_cache) do 
    if unit then
      local unit_tdd = unit.update_ttd
    end
  end
end

C_Timer.NewTicker( 0.2, update_ttd )
