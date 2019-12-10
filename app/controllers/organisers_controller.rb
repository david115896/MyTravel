class OrganisersController < ApplicationController
  before_action :set_organiser, only: [:show, :edit, :update, :destroy]

  def index
    if user_signed_in?
      if cookies[:organiser] != nil
        Organiser.put_cookies_in_table(current_user, JSON.parse(cookies[:organiser]))
        cookies.delete(:organiser)
      end
      @cart_activities = Activity.list_cart(current_user)
      @organisers_tickets = Organiser.list_organiser(current_user)
      gon.organiser_activities = @cart_activities

    else
      if cookies[:activities] != nil
        @cart_activities = Activity.list_cookie(JSON.parse(cookies[:activities]))
        gon.organiser_activities = @cart_activities

      else
        @cart_activities = Array.new
      end

      if cookies[:organiser] != nil
        @organisers_tickets = Organiser.list_cookie(JSON.parse(cookies[:organiser]))
      else
        @organisers_tickets = Array.new
      end
    end  
    session[:show_itinerary] = false
  end

  def show
		if user_signed_in?
			@organiser = Organiser.find(cookies[:organiser_id])
			@checkouts = @organiser.checkouts
		else
			@tickets = parse_tickets
			hash = JSON.parse cookies[:tempo_organiser]
		end
  end

  def new
		@tickets = set_tickets
		@checkouts = set_checkouts
		hash = JSON.parse cookies[:tempo_organiser]
		@city = City.find(hash["city_id"])
		session[:tempo_organiser] = cookies[:tempo_organiser]
    gon.organiser_activities = @cart_activities
  end

	def create

		if user_signed_in?
			organiser = Organiser.new(user: current_user, city_id: params[:organiser][:city_id])
			if organiser.save
				cookies.permanent[:organiser_id] = organiser.id
				redirect_to city_activities_path(params[:organiser][:city_id])
			end
		else
			cookies.delete :tempo_organiser
			cookies.permanent[:tempo_organiser] = JSON.generate({city_id: params[:organiser][:city_id], checkouts: []})
			puts cookies[:tempo_organiser]
			redirect_to city_activities_path(params[:organiser][:city_id])
		end
	end

  # def create
		 # if user_signed_in?
  #      @organiser = Organiser.new
  #      @organiser.user_id = current_user.id
  #      @organiser.ticket_id = Ticket.where(activity_id: params[:activity_id]).first.id
  #      puts "******************"
  #      puts Organiser.get_duration
       
  #      respond_to do |format|
  #        if @organiser.save
           
  #          format.html { redirect_to organisers_path, flash: { success: 'Activities was successfully added to your agenda.'}}
  #        else
  #          format.html { redirect_to organisers_path, flash: { danger: 'Activities coudln\'t be added to your agenda.'}}
  #          format.json { render json: @organiser.errors, status: :unprocessable_entity }
  #        end
  #      end
  #    else
  #      if cookies[:organiser] == nil
  #        cookies[:organiser] = JSON.generate([Ticket.find_by(activity_id: params[:activity_id]).id])
  #      else
  #        cookies[:organiser] = JSON.generate(JSON.parse(cookies[:organiser]) + [Ticket.find_by(activity_id: params[:activity_id]).id])
  #      end
  #      respond_to do |format|
  #        format.html { redirect_to organisers_path, flash: { success: 'Activities was successfully added to your agenda.'}}
  #       end
  #     end
  # end

  def edit

		if params[:commit] == "change"
			cookies[:organiser_id] = params[:id]
		end

		@unselected_checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: false).order(:index)
		@selected_checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: true).order(:index)
		@organiser = Organiser.find(cookies[:organiser_id])
		@city = @organiser.city
		#tempo !!
		@cart_activities = set_activities(Checkout.where(organiser_id: cookies[:organiser_id]))
		gon.organiser_activities = @cart_activities

  end






  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organiser
      @organiser = Organiser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organiser_params
      params.fetch(:organiser, {})
    end

		def parse_tickets
			hash = JSON.parse cookies[:tempo_organiser]
			tickets = []
			for checkout in hash["checkouts"] do
				tickets <<	Ticket.find(checkout["ticket_id"])
			end

			return tickets
		end

		def set_checkouts
			hash = JSON.parse cookies[:tempo_organiser]
			return hash["checkouts"]
		end

		def set_tickets
			tickets = []
			hash = JSON.parse cookies[:tempo_organiser]
			for checkout in hash["checkouts"] do
				tickets << Ticket.find(checkout["ticket_id"])
			end
			return tickets
		end

		def set_activities (checkouts)
			activities = []
			for checkout in checkouts do
				activities << checkout.ticket.activity
			end
			return activities
		end

end
