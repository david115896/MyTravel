class StaticController < ApplicationController
  def index
    @cities = City.all
		@city = City.all.sample
		
		cookies.delete(:organiser_id)
		if cookies[:organiser_id] == nil
			cookies[:organiser_id] = 1
		end
		
		# cookies.delete :tempo_organiser
		# cookies.delete :organiser_id
		# binding.pry

     # session[:user_id] = {id: (User.last.id + 1)}
      #cookies.encrypted[:username] = "John"      
     # cookies.delete(:username)
  end

end
