RealtimeComms::Application.routes.draw do

  get "home/index"

  root :to => "home#index"

  # App control / requires auth
  get "state" => "state#index"
  get "state/start"
  get "state/next"

  # WebHook endpoints
  post "twilio/call"
  post "twilio/sms"

  # Stages
  get "opportunity" => "opportunity#index"

  get "convenience" => "convenience#index"
  post "convenience/news" => "convenience#post_news"

  get "interaction" => "interaction#index"
  post "interaction/chat" => "interaction#chat"

  get "end" => "end#index"

end