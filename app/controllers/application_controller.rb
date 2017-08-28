class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def flash_store(model_instance)
    flash[:errors] = model_instance.errors.full_messages
  end

  def login!(user)
    session[:session_token] = user.session_token
  end
end
