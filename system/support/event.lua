local addon, bxhnz7tp5bge7wvu = ...

bxhnz7tp5bge7wvu.event = {
  events = { },
  callbacks = { }
}

local frame = CreateFrame('frame')

function bxhnz7tp5bge7wvu.event.register(event, callback)
  if not bxhnz7tp5bge7wvu.event.events[event] then
    frame:RegisterEvent(event)
    bxhnz7tp5bge7wvu.event.events[event] = true
    bxhnz7tp5bge7wvu.event.callbacks[event] = { }
  end
  table.insert(bxhnz7tp5bge7wvu.event.callbacks[event], callback)
end

frame:SetScript('OnEvent', function(self, event, ...)
  if bxhnz7tp5bge7wvu.event.callbacks[event] then
    for key, callback in ipairs(bxhnz7tp5bge7wvu.event.callbacks[event]) do
      callback(...)
    end
  end
end)
