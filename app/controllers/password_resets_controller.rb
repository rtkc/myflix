class PasswordResetsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])
    if user
      @token = user.token
    else 
      redirect_to expired_token_path
    end
  end

  def create
    user = User.find_by(token: params[:token])
    if user && !params[:password].empty?
      user.update(password: params[:password], token: nil) 
      redirect_to sign_in_path
      flash[:success] = "Your password has been successfully reset. Please sign in with your new password."
    else 
      flash.now[:error] = "Please enter a password."
      render :show
    end
  end
end