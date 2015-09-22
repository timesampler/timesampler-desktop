require 'ostruct'

module View
  extend self

  def render(name, locals = {})
    context = OpenStruct.new(locals)
    context.extend View
    template = Template[name]
    raise "can't find template #{name.inspect}" unless template
    template.render(context)
  end
end
