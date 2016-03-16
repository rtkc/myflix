class UsersController < ApplicationController

  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def new_with_invitation
    invitation = Invitation.find_by(token: params[:token])

    if invitation
      @user = User.new(email: invitation.recipient_email, full_name: invitation.recipient_name)
      @invitation_token = invitation.token
      render :new
    else 
      redirect_to expired_token_path
    end
  end


  def create
    @user = User.new(user_params)
    if @user.save
      handle_invitation
      handle_payment
      session[:user_id] = @user.id
      AppMailer.send_welcome_email(@user).deliver
      flash[:success] = 'You have signed up successfully.'
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    @following_relationship = Relationship.new
  end

  private
  def user_params
    params.require(:user).permit(:full_name, :password, :email)
  end

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.expire_token   
    end
  end

  def handle_payment
    Stripe.api_key = ENV['stripe_secret_key']

    Stripe::Charge.create(
      :amount => 999,
      :currency => "usd",
      :source => params[:stripeToken],
      :description => "Charge for #{@user.email}"
    )
  end
end