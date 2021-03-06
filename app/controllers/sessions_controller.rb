class SessionsController < ApplicationController 

  def new
    redirect_to home_path if current_user
  end
  
  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] =  "Welcome to MyFlix, #{user.full_name}!"
      redirect_to home_path
    else 
      flash[:danger] = "Invalid email or password"
      redirect_to sign_in_path
    end 
  end 

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You are signed out."
    redirect_to root_path
  end
end 