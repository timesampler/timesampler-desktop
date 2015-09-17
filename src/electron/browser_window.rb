Electron::BrowserWindow = Electron.get('browser-window') # Module to create native browser window.

def (Electron::BrowserWindow).new(options)
  Native(`(new (#{to_n})(#{options.to_n}))`)
end
