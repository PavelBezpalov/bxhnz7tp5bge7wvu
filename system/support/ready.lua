local addon, bxhnz7tp5bge7wvu = ...

local ticker

ticker = C_Timer.NewTicker(0.1, function()
  if bxhnz7tp5bge7wvu.settings_ready then
    for _, callback in pairs(bxhnz7tp5bge7wvu.ready_callbacks) do
      callback()
    end
    ticker:Cancel()
  end
end)

