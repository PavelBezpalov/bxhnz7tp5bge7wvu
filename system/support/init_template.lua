local addon, bxhnz7tp5bge7wvu = ...

_G['bxhnz7tp5bge7wvu_interface'] = bxhnz7tp5bge7wvu
bxhnz7tp5bge7wvu.name = 'bxhnz7tp5bge7wvu'
bxhnz7tp5bge7wvu.version = 'r${i}'
bxhnz7tp5bge7wvu.color = '727bad'
bxhnz7tp5bge7wvu.color2 = '72ad98'
bxhnz7tp5bge7wvu.color3 = '96ad72'
bxhnz7tp5bge7wvu.ready = false
bxhnz7tp5bge7wvu.settings_ready = false
bxhnz7tp5bge7wvu.ready_callbacks = { }
bxhnz7tp5bge7wvu.protected = false

function bxhnz7tp5bge7wvu.on_ready(callback)
  bxhnz7tp5bge7wvu.ready_callbacks[callback] = callback
end
