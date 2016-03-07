class UsersController < ApplicationController

  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'You have signed up successfully.'
      AppMailer.send_welcome_email(@user).deliver
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    @following_relationship = Relationship.new
  end

  def update
  end

  private
  def user_params
    params.require(:user).permit(:full_name, :password, :email)
  end
end