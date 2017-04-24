mode_reg =
  name: 'red'
  extensions: {'red','reds'}
  create: bundle_load 'red_mode'

howl.mode.register mode_reg

unload = -> howl.mode.unregister 'red'

return {
  info:
    author: 'Rok Fajfar',
    description: 'Red mode',
    license: 'MIT',
  :unload
}
