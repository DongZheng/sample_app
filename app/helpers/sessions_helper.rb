module SessionsHelper
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  # setter for @current_user
  def current_user=(user)
    @current_user = user
  end

  # getter for @current_user
  def current_user
    @current_user ||= user_from_remember_token
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  # the rspec testing all passed even if user_from_remember_token is undefined, why??
  private

  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end

  def signed_in?
    !current_user.nil?
  end

end
