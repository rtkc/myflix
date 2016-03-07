class InvitationsController < ApplicationController
  before_filter :require_user
  def new
    @invitation = Invitation.new
  end

  def create
     @invitation = Invitation.new(invitation_params.merge!(inviter: current_user))

    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver
      flash[:success] = "Your inviitation was successfully sent."
      redirect_to home_path
    else 
      flash.now[:error] = "Your invitation could not be sent. Please try again."
      render :new
    end
  end

  private
  def invitation_params
    params.require(:invitation).permit(:recipient_email, :recipient_name, :message)
  end
end
