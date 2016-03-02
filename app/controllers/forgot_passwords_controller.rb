class ForgotPasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user
      user.update_attribute(:token, SecureRandom.urlsafe_base64)
      flash[:success] = 'We have sent you an email.'
      AppMailer.send_reset_password_email(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      render :new
      flash[:error] = "Please enter a valid email."
    end
  end
end