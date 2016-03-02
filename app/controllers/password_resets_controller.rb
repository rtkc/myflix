class PasswordResetsController < ApplicationController
  def show
    user = User.where(token: params[:id]).first
    if user
      @token = user.token
    else 
      redirect_to expired_token_path
    end
  end

  def create
    user = User.where(token: params[:token]).first
    user.update_attributes(password: params[:password], token: nil) if user
    redirect_to sign_in_path
    flash[:success] = "Your password has been successfully reset. Please sign in with your new password."
  end
end