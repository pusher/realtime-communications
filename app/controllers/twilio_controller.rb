require 'prize'
require 'pusher'

class TwilioController < ApplicationController

	protect_from_forgery :except => [:call, :sms]

	@@prizes = [
		Prize.new('$100 Pusher credit', 'images/100-credit.png'),
		Prize.new('$50 Pusher credit', 'images/50-credit.png'),
		Prize.new('$50 Pusher credit', 'images/50-credit.png'),
		Prize.new('$50 Pusher credit', 'images/50-credit.png'),
		Prize.new('Pusher t-shirt', 'images/t.png'),
		Prize.new('Pusher t-shirt', 'images/t.png'),
		Prize.new('Pusher t-shirt', 'images/t.png'),
		Prize.new('Pusher t-shirt', 'images/t.png'),
		Prize.new('Pusher t-shirt', 'images/t.png'),
		Prize.new('Pusher t-shirt', 'images/t.png')
	]
  
  def call
  end

  def sms

  	# Check application state
  	case State.instance.stage
  	when 0
  		opportunity( params )
  	when 1
  		convenience( params )
  	when 2
  		interaction( params )
  	else
  		# Event over
  		logger.debug( 'event over' )
  	end

  end

  # http://localhost:3000/twilio/sms?From=+447867526993&DateSent=Mon,%2015%20Aug%202005%2015:52:01%20+0000&Body=@leggetter
  def opportunity( params )
  	logger.debug( 'opportunity' )

  	sms = SmsReceived.new( :from => params['From'], :sent => Time.now.strftime("%Y-%m-%dT%H:%M:%S"), :body => params['Body'] )

  	if sms.save

  		step = State.instance.step
  		State.instance.step = (step + 1)
  		State.instance.save

	  	twitter_id = body_to_twitter_id( sms.body )

	  	event = {
	  		:sms => sms.attributes,
	  		:twitter_id => twitter_id,
	  		:prize => get_step_prize( step )
	  	}

	  	Pusher['opportunity'].trigger('sms_received', event)
	  else
	  	logger.info 'SmsReceived saving failed'
	  	logger.info sms.errors.full_messages
	  	render :status => 400, :text => 'SmsReceived saving failed'
  	end
  end

  def get_step_prize( step )
  	prize = nil
  	if step < (@@prizes.length - 1)
  		prize = @@prizes[ step ]
  	end
  	return prize
  end

  def convenience( params )
  	logger.debug( 'Recieved SMS whilst in convenience stage. Saving, but not publishing' )

  	sms = SmsReceived.new( :from => params['From'], :sent => Time.now.strftime("%Y-%m-%dT%H:%M:%S"), :body => params['Body'] )

  	if !sms.save
  		logger.info( 'could not save SMS' )
  	end
  end

  def interaction( params )
  	logger.debug( 'interaction' )

  	number = params['From']
  	twitter_id = get_twitter_id_from_number( number )

  	data = {
  		:text => params['Body'],
  		:twitter_id => twitter_id,
  		:from => params['From'],
  		:medium => 'sms'
  	}

  	Pusher['chat'].trigger( 'new_message', data )
  end

  def get_twitter_id_from_number( number )
  	twitter_id = nil

  	sms = SmsReceived.where( :from => number ).first
  	if sms
  		twitter_id = sms.body
  	end

  	return body_to_twitter_id( twitter_id )
  end

  def body_to_twitter_id( body )
  	twitter_id = nil
  	if body
  		body.strip!

			if body.length > 2
				if body[0] == '@'
					twitter_id = body
				else
					twitter_id = '@' + body
				end
			end

  	end

  	return twitter_id
  end

end
