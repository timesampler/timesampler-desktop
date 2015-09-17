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
    Electron::IPC.sendSync(:set_token, value)
    @token = value
  end

  def token
    @token ||= Electron::IPC.sendSync(:get_token)
  end

  @dirs = []
  attr_reader :dirs
end

%w[click submit change].each do |event_name|
  Document.on event_name, "[e-#{event_name}]" do |event|
    event.prevent
    element = event.current_target
    $controller.send(element["e-#{event_name}"])
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
  end
end

Document.ready? { Document.trigger :render }
