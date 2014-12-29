# class EmailWorker 
#   include SideKiq::Worker 

#   def perform(user_id)
#     user = User.find(user_id)
#     Usermailer.delay.send_welcome_email(user)
#   end
# end   