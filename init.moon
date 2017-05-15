mode_reg =
  name: 'red'
  extensions: {'red','reds'}
  create: bundle_load 'red_mode'

howl.config.define {
  name: 'red_executable'
  description: 'Red executable name or path'
  type_of: 'string'
  default: 'redc'
}

howl.command.register {
  name: 'red-run'
  description: 'Run current file with Red'
  handler: () ->
    howl.command.run "exec #{howl.config.red_executable} #{howl.app.editor.buffer.file.basename}"
}

howl.mode.register mode_reg

unload =  () ->
  howl.command.unregister 'red-run'
  howl.mode.unregister 'red'

return {
  info:
    author: 'Rok Fajfar',
    description: 'Red mode',
    license: 'MIT',
  :unload
}
