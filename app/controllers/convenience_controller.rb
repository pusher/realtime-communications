require 'twilio-ruby'

class ConvenienceController < ApplicationController
  def index
  	@pusher_key = Pusher.key
  end

  def post_news

  	if params['news_secret'] != @@settings['news_secret']
  		render :nothing => true, :status => 401
  		return
  	end

  	text = params['text']

  	account_sid = @@settings['twilio_account_sid']
		auth_token = @@settings['twilio_auth_token']
		twilio_number = @@settings['twilio_number']

		logger.debug( "Twilio details: #{account_sid} #{auth_token} #{twilio_number}" )

		client = Twilio::REST::Client.new account_sid, auth_token

  	SmsReceived.all.each do |sms|
  		to = sms.from
  		send_sms( client, twilio_number, to, text )
		end

  	Pusher['breaking-news'].trigger( 'new_article_received', { :text => text } )

  	render :nothing => true, :status => 201
  end

  def send_sms( client, from, to, text )

  	logger.debug("sending '#{text}' to '#{to}' from '#{from}")
		 
	  client.account.sms.messages.create(
	    :from => from,
	    :to => to,
	    :body => text
	  ) 
	  logger.info( "Sent message to #{to}" )

  end

end
