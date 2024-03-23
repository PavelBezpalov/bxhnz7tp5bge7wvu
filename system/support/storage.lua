local addon, bxhnz7tp5bge7wvu = ...

local frame = CreateFrame('frame')
frame:RegisterEvent('ADDON_LOADED')
frame:SetScript('OnEvent', function(self, event, arg1)
  if event == 'ADDON_LOADED' and arg1 == addon then
    bxhnz7tp5bge7wvu.log('Build ' .. bxhnz7tp5bge7wvu.version)
    if bxhnz7tp5bge7wvu_storage == nil then
      bxhnz7tp5bge7wvu_storage = { }
      bxhnz7tp5bge7wvu.log('Creating new settings profile!')
    else
      bxhnz7tp5bge7wvu.log('Settings loaded, welcome back!')
    end
    bxhnz7tp5bge7wvu.settings_ready = true
  end
end)

bxhnz7tp5bge7wvu.settings = { }

function bxhnz7tp5bge7wvu.settings.store(key, value)
  bxhnz7tp5bge7wvu_storage[key] = value
  return true
end

function bxhnz7tp5bge7wvu.settings.fetch(key, default)
  local value = bxhnz7tp5bge7wvu_storage[key]
  return value == nil and default or value
end

function bxhnz7tp5bge7wvu.settings.store_toggle(key, value)
  if not bxhnz7tp5bge7wvu.rotation.current_spec then return end
  local active_rotation = bxhnz7tp5bge7wvu.settings.fetch('active_rotation_' .. bxhnz7tp5bge7wvu.rotation.current_spec, false)
  if not active_rotation then return end
  local full_key
  if bxhnz7tp5bge7wvu.rotation.active_rotation then
    full_key = active_rotation .. '_toggle_' .. key
  else
    full_key = 'toggle_' .. key
  end
  bxhnz7tp5bge7wvu_storage[full_key] = value
  bxhnz7tp5bge7wvu.console.debug(2, 'settings', 'purple', string.format(
    '%s <= %s', full_key, tostring(value)
  ))
  return true
end

function bxhnz7tp5bge7wvu.settings.fetch_toggle(key, default)
  if not bxhnz7tp5bge7wvu.rotation.current_spec then return end
  local active_rotation = bxhnz7tp5bge7wvu.settings.fetch('active_rotation_' .. bxhnz7tp5bge7wvu.rotation.current_spec, false)
  if not active_rotation then return end
  local full_key
  if bxhnz7tp5bge7wvu.rotation.active_rotation then
    full_key = active_rotation .. '_toggle_' .. key
  else
    full_key = 'toggle_' .. key
  end
  if not string.find(full_key, 'master_toggle') then
    bxhnz7tp5bge7wvu.console.debug(2, 'settings', 'purple', string.format(
      '%s => %s', full_key, tostring(default)
    ))
  end
  return bxhnz7tp5bge7wvu_storage[full_key] or default
end

bxhnz7tp5bge7wvu.tmp = {
  cache = { }
}

function bxhnz7tp5bge7wvu.tmp.store(key, value)
  bxhnz7tp5bge7wvu.tmp.cache[key] = value
  return true
end

function bxhnz7tp5bge7wvu.tmp.fetch(key, default)
  return bxhnz7tp5bge7wvu.tmp.cache[key] or default
end

bxhnz7tp5bge7wvu.on_ready(function()
  bxhnz7tp5bge7wvu.environment.hooks.toggle = function(key, default)
    return bxhnz7tp5bge7wvu.settings.fetch_toggle(key, default)
  end
  bxhnz7tp5bge7wvu.environment.hooks.storage = function(key, default)
    return bxhnz7tp5bge7wvu.settings.fetch(key, default)
  end
end)
