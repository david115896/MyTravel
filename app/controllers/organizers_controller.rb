class OrganizersController < ApplicationController
  before_action :set_organizer, only: [:show, :edit, :update, :destroy]

	def index 
		if user_signed_in?
      @cart_activities = Activity.list_cart(current_user)
      @organizers_tickets = Organizer.list_organizer(current_user)
    else
      if cookies[:activities] != nil
        @cart_activities = Activity.list_cookie(JSON.parse(cookies[:activities]))
      else
        @cart_activities = Array.new
      end

      if cookies[:organizer] != nil
        @organizers_tickets = Organizer.list_cookie(JSON.parse(cookies[:organizer]))
      else
        @organizers_tickets = Array.new
      end
    end

	end

  def show
    
	end

	def new
		@organizer = Organizer.new
	end


	def create
    if user_signed_in?
      @organizer = Organizer.new
      @organizer.user_id = current_user.id
      @organizer.ticket_id = Ticket.where(activity_id: params[:activity_id].first)
      respond_to do |format|
        if @organizer.save
          format.html { redirect_to organizers_path, flash: { success: 'Activities was successfully added to your agenda.'}}
        else
          format.html { redirect_to organizers_path, flash: { danger: 'Activities did success to be added to your agenda.'}}
          format.json { render json: @organizer.errors, status: :unprocessable_entity }
        end
      end
    else
      if cookies[:organizer] == nil
        cookies[:organizer] = JSON.generate([Activity.find(params[:activity_id]).id])
      else
        cookies[:organizer] = JSON.generate(JSON.parse(cookies[:organizer]) + [Ticket.where(activity_id: params[:activity_id]).id].first)
      end
      respond_to do |format|
        format.html { redirect_to organizers_path, flash: { success: 'Activities was successfully added to your agenda.'}}
      end
    end
  end

  def update
    respond_to do |format|
      if @organizer.update(organizer_params)
        format.html { redirect_to @organizer, notice: 'organizer was successfully updated.' }
        format.json { render :show, status: :ok, location: @organizer }
      else
        format.html { render :edit }
        format.json { render json: @organizer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @organizer.destroy
    respond_to do |format|
      format.html { redirect_to organizers_url, notice: 'organizer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
	
    # Use callbacks to share common setup or constraints between actions.
    def set_organizer
      @organizer = Organizer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organizer_params
      params.fetch(:organizer, {})
    end
end
