class OpportunityController < ApplicationController
  def index
  	@twilio_number = @@settings['twilio_number']
  	@pusher_key = Pusher.key
  end
end
