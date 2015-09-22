require 'opal'
require 'electron'
require 'electron/browser_window'

app = Electron.get('app') # Module to control application life.

# Report crashes to our server.
Electron.get('crash-reporter').start

# Keep a global reference of the window object, if you don't, the window will
# be closed automatically when the JavaScript object is garbage collected.
$window = nil

# Quit when all windows are closed.
app.on('window-all-closed', -> {
  # On OS X it is common for applications and their menu bar
  # to stay active until the user quits explicitly with Cmd + Q
  if ($$.process.platform != :darwin)
    app.quit
  end
})

# This method will be called when Electron has finished
# initialization and is ready to create browser windows.
app.on(:ready, -> {
  # Create the browser window.
  $window = Electron::BrowserWindow.new(width: 800, height: 600)

  # and load the index.html of the app.
  $window.loadUrl('file://' + `__dirname` + '/index.html')

  # Open the DevTools.
  $window.openDevTools

  # Emitted when the window is closed.
  $window.on(:closed, -> {
    # Dereference the window object, usually you would store windows
    # in an array if your app supports multi windows, this is the time
    # when you should delete the corresponding element.
    $window = nil
  })
})

require 'electron/ipc'
require 'nodejs/file'

module Token
  extend self

  def value
    @value ||= File.read(path) if File.exist?(path)
  end

  def value= value
    File.write(path, value)
    @value = value
  end

  def path
    @path ||= File.expand_path("~/.timesampler/token")
  end
end

module Dirs
  extend self

  def add(dir)
    self.value += [dir]
  end

  def value
    @value ||= File.exist?(path) ? parse(File.read(path)) : []
  end

  def value= value
    File.write(path, dump(value))
    p [:Dirs_value=, value]
    @value = value
  end

  def parse(string)
    string.split("\n").map(&:strip).reject(&:empty?)
  end

  def dump(value)
    value.join("\n")
  end

  def path
    @path ||= File.expand_path("~/.timesampler/watch_paths")
  end
end

Electron::IPC.on :set_token, -> _event, value { Token.value = value }
Electron::IPC.on :get_token, -> event { Native(event).returnValue = Token.value }
Electron::IPC.on :get_dirs,  -> event { Native(event).returnValue = Dirs.value }
Electron::IPC.on :set_dirs,  -> _event, value { Dirs.value = value }
Electron::IPC.on :add_dirs,  -> event do
  require 'electron/dialog'
  # result = $window.open_dialog(title: "Select a folder", properties: %w[openDirectory multiSelections])
  # result = Electron::Dialog.showOpenDialog(nil, title: "Select a folder", properties: %w[openDirectory multiSelections])
  result = `(#{Electron::Dialog.to_n}).showOpenDialog(#{{title: "Select a folder", properties: %w[openDirectory multiSelections]}.to_n})`
  p [:add_dirs, result]
  Dirs.value += result if result
  Native(event).returnValue = Dirs.value
end
