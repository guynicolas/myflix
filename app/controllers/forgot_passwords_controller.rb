class ForgotPasswordsController < ApplicationController 

  def create
    user = User.where(email: params[:email]).first
    if user 
      Usermailer.delay.send_forgot_password(user)
      redirect_to forgot_password_confirmation_path
    else 
      flash[:danger] = params[:email].blank? ? "Email cannot be blank." : "No user with that email found in our system."
      redirect_to forgot_password_path
    end 
  end
end 