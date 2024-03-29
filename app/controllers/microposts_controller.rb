class MicropostsController < ApplicationController
  before_filter :authenticate, :only => [:index, :create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  def index
    @user = User.find_by_id(params[:user_id])
    redirect_to user_path(@user)
  end

  def create
    @micropost  = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = current_user.feed.paginate(:page => params[:page])
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end

  private

  def authorized_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_path if @micropost.nil?
  end
end