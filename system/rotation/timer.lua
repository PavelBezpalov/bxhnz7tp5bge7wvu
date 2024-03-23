local addon, bxhnz7tp5bge7wvu = ...

bxhnz7tp5bge7wvu.rotation.timer = {
  lag = 0
}

local last_duration = false

function bxhnz7tp5bge7wvu.rotation.tick(ticker)
  local toggled = bxhnz7tp5bge7wvu.settings.fetch_toggle('master_toggle', false)
  local turbo = bxhnz7tp5bge7wvu.settings.fetch('_engine_turbo', false)
  local castclip = bxhnz7tp5bge7wvu.settings.fetch('_engine_castclip', 0.15)
  local gcd_wait = 0
  ticker._duration = bxhnz7tp5bge7wvu.settings.fetch('_engine_tickrate', 0.1)

  if ticker._duration ~= last_duration then
    last_duration = ticker._duration
    bxhnz7tp5bge7wvu.console.debug(2, 'engine', 'engine', string.format('Ticket Rate: %sms', last_duration * 1000))
  end

  if not toggled then
    bxhnz7tp5bge7wvu.interface.status('Ready...')
    return
  end

  local gcd_start, gcd_duration = GetSpellCooldown(61304)
  local do_gcd = bxhnz7tp5bge7wvu.settings.fetch('_engine_gcd', true)
  if gcd_start > 0 then
    bxhnz7tp5bge7wvu.tmp.store('lastgcd', gcd_duration)
    gcd_wait = (gcd_duration - (GetTime() - gcd_start)) or 0
  end

  if bxhnz7tp5bge7wvu.rotation.active_rotation then
    if IsMounted() then return end

    if not turbo and do_gcd and gcd_wait > 0 then
      if bxhnz7tp5bge7wvu.rotation.active_rotation.gcd then
        return bxhnz7tp5bge7wvu.rotation.active_rotation.gcd()
      else
        return
      end
    end

    if UnitAffectingCombat('player') then
      bxhnz7tp5bge7wvu.rotation.active_rotation.combat()
    else
      bxhnz7tp5bge7wvu.rotation.active_rotation.resting()
      bxhnz7tp5bge7wvu.interface.status('Resting...')
    end
  end
end

bxhnz7tp5bge7wvu.on_ready(function()
  bxhnz7tp5bge7wvu.rotation.timer.ticker = C_Timer.NewAdvancedTicker(0.1, bxhnz7tp5bge7wvu.rotation.tick)
end)
