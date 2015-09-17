require 'native'
require 'nodejs/kernel'
require 'nodejs/io'

module Electron
  extend self

  def get(name)
    Native(node_require(name))
  end
end
