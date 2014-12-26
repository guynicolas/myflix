class AdminController < ApplicationController 
  def require_admin
    if !current_user.admin? 
      flash[:danger] = "Access Denied!"
      redirect_to home_path 
    end 
  end 
end 