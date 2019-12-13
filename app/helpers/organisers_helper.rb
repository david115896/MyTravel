module OrganisersHelper
	
	def current_duration
		if user_signed_in?
			return	Organiser.find(cookies[:organiser_id]).duration
		else
			hash = JSON.parse cookies[:tempo_organiser]
			return hash["duration"]
		end
	end


	def first_organiser_id
		return Organiser.first.id
	end

	
	def first_organiser
		return Organiser.first
	end


	def current_city_id
		if user_signed_in?
			return Organiser.find(cookies[:organiser_id]).city_id
		else
			if cookies[:tempo_organiser] == nil
				return first_city_id
			else
				hash = JSON.parse cookies[:tempo_organiser]
				return hash["city_id"]
			end
		end
	end

	def current_city
		if user_signed_in?

			if cookies[:organiser_id] != nil
				return	Organiser.find(cookies[:organiser_id])
			end

		else
			
			if cookies[:tempo_organiser] != nil
				hash = JSON.parse cookies[:tempo_organiser]
				return City.find(hash["city_id"])
			end

		end
	end

	def set_cookies
		if user_signed_in?
			if  params[:commit] == "new_travel"
				cookies[:organiser_id] = nil
			end
		else
			if params[:commit] == "new_travel"
				cookies[:tempo_organiser] = nil
			end
		end
	end

	def reset_cookies
		cookies.delete :tempo_organiser
		cookies.delete :organiser_id
		session.delete :current_day
	end
	

	def set_minutes(minutes)
		if minutes == 0 
			return "00"
		else
			return minutes.to_s
		end
	end

	def duration_options
		options_array = []
		(1..30).each do |i|
				options_array << [i.to_s, i]
		end
	return  options_for_select(options_array, current_duration)
	end

	def day_options
		options_array = []
		(1..current_duration).each do |i|
			options_array << [i.to_s, i]
		end
		
		return options_for_select(options_array, session[:current_day])
	end
			
	def ticket_options(checkout)
		if user_signed_in?
			return Ticket.where(activity_id: checkout.ticket.activity.id)
		else
			return Ticket.where(activity_id: get_ticket(checkout).activity.id)
		end
	end

	def last_index
		if user_signed_in?
			return Checkout.where(organiser_id: cookies[:organiser_id], day: session[:current_day]).order(:index).last.index
		else
			checkouts = set_checkouts
			current_checkouts =[]
			max_index = 0
			checkouts.each do |rank,checkout|
				if get_day({rank => checkout}) == session[:current_day] && get_index({rank => checkout}) > max_index
					max_index = get_index(rank => checkout)
				end
			end
			return max_index
		end
	end


end
