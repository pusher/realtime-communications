class ApplicationController < ActionController::Base
  protect_from_forgery

  @@settings = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
end
