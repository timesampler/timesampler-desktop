require 'opal'
require 'nodejs/kernel'
`window.$ = window.jQuery = #{node_require('./client/jquery.js')}`
require 'opal-jquery'
require 'client/view'
require 'console'
require 'promise'
require 'electron/ipc'

require 'client/controller'
require_tree './client/controllers'

module Remote
  extend self

  def token= value
    Electron::IPC.send(:set_token, value)
    @token = value
  end

  def token
    @token ||= Electron::IPC.sendSync(:get_token)
  end

  def add_dirs
    @dirs = Electron::IPC.sendSync(:add_dirs)
  end

  def set_dirs(value)
    p [:set_dirs, value]
    Electron::IPC.send(:set_dirs, value)
    p [:set_dirs2, value]
    @dirs = value
  end

  def dirs
    @dirs ||= Electron::IPC.sendSync(:get_dirs)
  end
end


$controllers = []

Document.on :render do
  # $controller = case
  # when Remote.token.nil? then EditTokenController
  # when Remote.dirs.empty? then EditDirsController
  # else ShowDirsController
  # end

  Element['[controller]'].each do |element|
    name, action = element[:controller].split('#')
    controller = Object.const_get(name).new(element)
    $console.log controller, name, action
    $controllers << controller
    controller.send(action || :index)

    %w[click submit change].each do |event_name|
      element.on event_name, "[e-#{event_name}]" do |event|
        event.prevent
        element = event.current_target

        action_string = element["e-#{event_name}"]
        method_name, args = action_string.scan(/(\w+)(?:\((.*)\)|(.*))$/).first
        args = JSON.parse("[#{args}]")
        controller.send(method_name, *args)
      end
    end
  end
end

Document.ready? { Document.trigger :render }
