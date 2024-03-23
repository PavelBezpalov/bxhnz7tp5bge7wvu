-- Brewmaster Monk for 8.0.1 - 9/2018

-- Holding Shift = Pausing Rotation for other activities
-- Use Light Brewing. Black Ox Not Yet Implemented
-- feedback to wulf2 on discord
-- big CDs are still players responsibility
-- 0,1,0,0,1,2,!2

local addon, bxhnz7tp5bge7wvu = ...
local SB = bxhnz7tp5bge7wvu.rotation.spellbooks.monk

local function combat()
  -- print(player.power.energy.actual)
  if target.alive and target.enemy and not modifier.shift then
    -- Mitigation Uptime
    if castable(SB.IronSkinBrew) and not buff(SB.IronSkinBrew).exists then
      cast(SB.IronSkinBrew, 'target')
    end
    if castable(SB.IronSkinBrew) and buff(SB.IronSkinBrew).remains < 13 then
      cast(SB.IronSkinBrew, 'target')
    end
    -- Damage
    if castable(SB.TigerPalm) and buff(SB.BlackoutCombo).exists then
      return cast(SB.TigerPalm, 'target')
    end
    if castable(SB.KegSmash) then
      return cast(SB.KegSmash, 'target')
    end
    if castable(SB.BlackoutStrike) then
      return cast(SB.BlackoutStrike, 'target')
    end
    if castable(SB.BreathofFire) then
      return cast(SB.BreathofFire, 'target')
    end
    if castable(SB.BrewRushingJadeWind) and player.talent(6,2) and (not buff(SB.BrewRushingJadeWind).exists or buff(SB.BrewRushingJadeWind).remains < 2) then
      return cast(SB.BrewRushingJadeWind, 'target')
    end
    if castable(SB.TigerPalm) and player.power.energy.actual > 35 then
      return cast(SB.TigerPalm, 'target')
    end
    if castable(SB.ChiBurst) then
      return cast(SB.ChiBurst, 'target')
    end
    if castable(SB.ChiWave) then
      return cast(SB.ChiWave, 'target')
    end
  end
end

local function resting()
  if player.alive then

  end
end

function interface()

end

bxhnz7tp5bge7wvu.rotation.register({
  spec = bxhnz7tp5bge7wvu.rotation.classes.monk.brewmaster,
  name = 'brewmaster',
  label = 'Brewmaster',
  combat = combat,
  resting = resting,
  interface = interface
})