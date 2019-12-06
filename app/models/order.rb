class Order < ApplicationRecord
    has_many :activities, through: :tickets
    has_many :cities, through: :activities
    has_many :sold_tickets
    has_many :tickets, through: :sold_tickets
    belongs_to :user

		def self.add_order(current_user)
			o = Order.create(user: current_user)
			SoldItem.create(order: o, organiser_id: session[:organiser_id])
		end

end
