class Controller

  def initialize(element)
    @element = element
  end

  private

  def render(name, locals = {})
    @element.html = View.render("client/controllers/views/#{controller_name}/#{name}", locals)
  end
end
