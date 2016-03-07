class ForgotPasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.generate_token
      flash.now[:success] = 'We have sent you an email.'
      AppMailer.send_reset_password_email(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash.now[:error] = "Please enter a valid email."
      render :new
    end
  end
end