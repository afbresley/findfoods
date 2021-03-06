class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # before_action :pick_sidebar

  helper_method :signed_in?, :current_user

  private

  def current_user
  	return nil unless session[:session_token]
  	current_user ||= User.find_by_session_token(session[:session_token])
  end

  def signed_in?
  	!!current_user
  end

  def current_user_id
  	current_user ? current_user.id : nil
  end

  def sign_in(user)
  	@current_user = user
  	session[:session_token] = user.reset_session_token!
  end

  def sign_out
    @current_user.try(:reset_session_token!)
    session[:session_token] = nil
  end

  def require_user!
  	redirect_to session_url unless signed_in?
  end


  
end
