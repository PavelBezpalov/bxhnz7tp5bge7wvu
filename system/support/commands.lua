local addon, bxhnz7tp5bge7wvu = ...

bxhnz7tp5bge7wvu.commands = {
  commands = { }
}

function bxhnz7tp5bge7wvu.commands.register(command)
  if type(command.command) == 'table' then
    for _, command_key in ipairs(command.command) do
      bxhnz7tp5bge7wvu.commands.commands[command_key] = command
    end
  else
    bxhnz7tp5bge7wvu.commands.commands[command.command] = command
  end
end

local function format_help(command)
  local arguments = table.concat(command.arguments, ', ')
  local command_key
  if type(command.command) == 'table' then
    command_key = table.concat(command.command, '||')
  else
    command_key = command.command
  end
  return string.format('|cff%s/bxhnz7tp5bge7wvu %s|r |cff%s%s|r %s', bxhnz7tp5bge7wvu.color2, command_key, bxhnz7tp5bge7wvu.color3, arguments, command.text)
end

local function handle_command(msg, editbox)
  local _, _, command, _arguments = string.find(msg, "%s?(%w+)%s?(.*)")
  local arguments = { }

  if not _arguments then
    bxhnz7tp5bge7wvu.log('Build ' .. bxhnz7tp5bge7wvu.version)
    bxhnz7tp5bge7wvu.log('Type /bxhnz7tp5bge7wvu help for a list of known commands.')
    return
  end

  for argument in string.gmatch(_arguments, "%S+") do
    table.insert(arguments, argument)
  end

  command = bxhnz7tp5bge7wvu.commands.commands[command]
  if command then
    if #command.arguments == #arguments then
      result = command.callback(unpack(arguments))
      if not result then
        bxhnz7tp5bge7wvu.log('Command Usage:')
        bxhnz7tp5bge7wvu.log(format_help(command))
      end
    else
      bxhnz7tp5bge7wvu.log('Command Usage:')
      bxhnz7tp5bge7wvu.log(format_help(command))
    end
  else
    bxhnz7tp5bge7wvu.log('Command not found, type /bxhnz7tp5bge7wvu help for a list of known commands.')
  end
end

bxhnz7tp5bge7wvu.on_ready(function()
  bxhnz7tp5bge7wvu.commands.register({
    command = 'help',
    arguments = { },
    text = 'Display the list of known commands',
    callback = function(rotation_name)
      bxhnz7tp5bge7wvu.log('Known commands:')
      local printed = { }
      for _, command in pairs(bxhnz7tp5bge7wvu.commands.commands) do
        if not printed[tostring(command)] then
          bxhnz7tp5bge7wvu.log(format_help(command))
          printed[tostring(command)] = true
        end
      end
      return true
    end
  })

  bxhnz7tp5bge7wvu.commands.register({
    command = 'load',
    arguments = {
      'rotation_name'
    },
    text = 'Loads the specified rotation',
    callback = function(rotation_name)
      bxhnz7tp5bge7wvu.rotation.load(rotation_name)
      return true
    end
  })

  bxhnz7tp5bge7wvu.commands.register({
    command = 'list',
    arguments = { },
    text = 'List available rotations',
    callback = function()
      bxhnz7tp5bge7wvu.log('Available Rotations:')
      for name, rotation in pairs(bxhnz7tp5bge7wvu.rotation.rotation_store) do
        if rotation.spec == bxhnz7tp5bge7wvu.rotation.current_spec or rotation.spec == false then
          bxhnz7tp5bge7wvu.log(rotation.label and  rotation.name .. ' - ' .. rotation.label or rotation.name)
        end
      end
      return true
    end
  })

  bxhnz7tp5bge7wvu.commands.register({
    command = 'debug',
    arguments = {
      'debug_level',
    },
    text = 'Enable the debug console at the specified debug level',
    callback = function(debug_level)
      if tonumber(debug_level) then
        bxhnz7tp5bge7wvu.console.set_level(debug_level)
        return true
      else
        return false
      end
    end
  })

  bxhnz7tp5bge7wvu.commands.register({
    command = 'toggle',
    arguments = {
      'button_name',
    },
    text = 'Toggles the on/off state for the specified button',
    callback = function(button_name)
      if button_name and bxhnz7tp5bge7wvu.interface.buttons.buttons[button_name] then
        bxhnz7tp5bge7wvu.interface.buttons.buttons[button_name]:callback()
        return true
      end
      return false
    end
  })

  bxhnz7tp5bge7wvu.commands.register({
    command = 'econf',
    arguments = { },
    text = 'Shows the core engine config window.',
    callback = function(button_name)
      if bxhnz7tp5bge7wvu.econf.parent:IsShown() then
        bxhnz7tp5bge7wvu.econf.parent:Hide()
      else
        bxhnz7tp5bge7wvu.econf.parent:Show()
      end
      return true
    end
  })
end)

SLASH_BXHNZ7TP5BGE7WVU1 = '/bxhnz7tp5bge7wvu'
SlashCmdList["BXHNZ7TP5BGE7WVU"] = handle_command
