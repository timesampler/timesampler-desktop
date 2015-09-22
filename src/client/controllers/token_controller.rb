require_tree './views/token'

class TokenController < Controller
  def show
    return edit if token.empty?
    render 'show', token: token
  end

  def edit
    render 'edit', token: token
  end


  private

  def token
    Remote.token.to_s
  end

  def save_token
    token = Element['.val-token'].value
    Remote.token = token
    show
  end
end

