class Controller

  def initialize(element)
    @element = element
  end

  private

  def render(name, locals = {})
    @element.html = View.render("client/controllers/views/#{controller_name}/#{name}", locals)
  end

  def controller_name
    @controller_name ||= self.class.name.gsub(/[A-Z]/) {|m| "_#{m[0].downcase}"}.gsub(/^_|_controller$/, '')
  end
end
