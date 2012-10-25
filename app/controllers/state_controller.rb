class StateController < ApplicationController
  
	before_filter :authenticate

	@@stages = [
		"opportunity",
		"convenience",
		"interaction",
		"end"
	]

 	def index
  	render :json => State.instance.to_json
  end

  def start
  	State.instance.stage = 0
  	State.instance.step = 0
  	State.instance.save
  	go_to_stage( 0 )
  end

  def next
  	stage = State.instance.stage
  	if stage < ( @@stages.length - 1 )
  		stage = ( stage + 1 )
  		State.instance.stage = stage
  		State.instance.step = 0
  		State.instance.save
  	end

    if @@stages[ stage ] == 'interaction'
      send_interaction_web_link()
    end

  	go_to_stage( stage )
  end

  def go_to_stage( stage )
  	redirect_to '/' + @@stages[stage]
	end

  def send_interaction_web_link

    account_sid = @@settings['twilio_account_sid']
    auth_token = @@settings['twilio_auth_token']
    twilio_number = @@settings['twilio_number']

    client = Twilio::REST::Client.new account_sid, auth_token

    SmsReceived.all.each do |sms|
      to = sms.from
      send_sms( client, twilio_number, to, 'Reply to this text to chat or go to http://rtcomms.herokuapp.com/interaction' )
    end
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

	protected

		def authenticate
			settings = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
		  authenticate_or_request_with_http_basic do |username, password|
		    username == settings['username'] && password == settings['password']
		  end
		end

end
