class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

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

  def logout!
    current_user.update(session_token: SecureRandom.urlsafe_base64)
    session[:session_token] = nil
  end

  def current_user
    @current_user ||= session[:session_token] &&
        User.find_by(session_token: session[:session_token])
  end

  def ensure_logged_in
    redirect_to new_session_url unless current_user
  end
end
