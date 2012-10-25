class State < ActiveRecord::Base

	settings = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
	@@instance = State.where(:event_name => settings['event_name']).first_or_create(:stage => 0, :step => 0)

	def self.instance
    return @@instance
  end

end
