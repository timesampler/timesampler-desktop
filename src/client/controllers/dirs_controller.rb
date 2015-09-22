require_tree './views/dirs'

class DirsController < Controller
  def show
    return edit if dirs.empty?
    render 'show', dirs: dirs
  end

  def edit
    render 'edit', dirs: dirs
  end

  def add_dirs
    Remote.add_dirs
    edit
  end

  def remove_dir(index)
    dirs = self.dirs.clone
    dirs.delete_at(index)
    Remote.set_dirs dirs
    edit
  end



  private

  def dirs
    Remote.dirs || []
  end
end
