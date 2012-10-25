# Realtime Communications examples

Demo created for TwilioCon 2012

## Getting Started

### Add initializers/pusher.rb

	require 'pusher'

	Pusher.app_id = 'YOUR_APP_ID'
	Pusher.key = 'YOUR_APP_KEY'
	Pusher.secret = 'YOUR_APP_SECRET'

### Rename config/config.example.yml to config.yml

And update the values appropriately.