class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :current_user

  def current_user
    @current_user = User.find_by(uuid: cookies[:uuid])
    if !@current_user
      uuid = SecureRandom.uuid
      @current_user = User.create(uuid: uuid)
      cookies.permanent[:uuid] = uuid
    end
  end

end
