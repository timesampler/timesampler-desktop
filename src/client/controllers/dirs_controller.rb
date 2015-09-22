require_tree './views/dirs'

class DirsController < Controller
  def show
    return edit if dirs.empty?
    render 'show', dirs: dirs
  end

  def edit
    render 'edit', dirs: dirs
  end



  private

  def dirs
    Remote.dirs || []
  end
end
