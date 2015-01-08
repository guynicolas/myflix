class InvitationsController < ApplicationController 
  before_filter :require_user

  def new
    @invitation = Invitation.new 
  end

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      Usermailer.send_invitation_email(@invitation).deliver
      flash[:success] = "You have successfully invited #{@invitation.recipient_name} to join MyFLix" 
      redirect_to new_invitation_path 
    else 
      render :new 
      flash[:danger] = "Your invitation was not sent."
    end 
  end

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message, :token)
  end
end 