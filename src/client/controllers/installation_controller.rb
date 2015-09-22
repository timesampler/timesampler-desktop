class InstallationController < Controller
  def show
    @element.html = <<-HTML
    <h2>Installing WIP</h2>
    <button>Install</button>
    HTML
  end
end

