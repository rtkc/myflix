class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'You have signed up successfully.'
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:full_name, :password, :email)
  end

  def set_user
    @user = User.find_by[params[:id]]
  end
end