class Electron::BrowserWindow
  @native = Electron.get('browser-window') # Module to create native browser window.

  def self.new(options)
    Native(`(new (#@native)(#{options.to_n}))`)
  end

  def open_dialog(options = {})
    require 'electron/dialog'
    Native(Electron::Dialog.showOpenDialog(to_n, options.to_n))
  end
end
