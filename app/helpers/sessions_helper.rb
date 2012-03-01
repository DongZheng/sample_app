module SessionsHelper
  def sign_in(user)
    #cookies.permanent.signed[:remember_token] = [user.id, user.salt]

    # Refer to section 4.1 @ http://guides.rubyonrails.org/action_controller_overview.html#session
    # Save the user ID in the session so it can be used in
    # subsequent requests
    session[:current_user_id] = user.id
    self.current_user = user
  end

  # setter for @current_user
  def current_user=(user)
    @current_user = user
  end

  # getter for @current_user
  def current_user
    #@current_user ||= user_from_remember_token
    @current_user ||= session[:current_user_id] && User.find_by_id(session[:current_user_id])
  end

  def sign_out
    #cookies.delete(:remember_token)
    #self.current_user = nil
    self.current_user = session[:current_user_id] = nil
  end

  def signed_in?
    !current_user.nil?
  end
  
  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  # the rspec testing all passed even if user_from_remember_token is undefined, why??
  private

  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end

end
