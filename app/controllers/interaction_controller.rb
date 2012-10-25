class InteractionController < ApplicationController
  def index
  	@pusher_key = Pusher.key
  	@twilio_number = @@settings['twilio_number']
  end

  def chat
  	from = params['from']
  	text = params['text']
  	twitter_id = params['twitter_id']

  	if !text
  		render :nothing => true, :status => 400
  		return 
  	end

  	data = {
  		:from => from,
  		:text => text,
  		:medium => 'web',
  		:twitter_id => twitter_id
  	}

  	Pusher['chat'].trigger( 'new_message', data )

  	render :nothing => true, :status => 201
  end
end
