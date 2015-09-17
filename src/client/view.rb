require 'ostruct'

module View
  extend self

  def render(name, locals = {})
    context = OpenStruct.new(locals)
    context.extend View
    Template[name].render(context)
  end
end
