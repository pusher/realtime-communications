class SmsReceived < ActiveRecord::Base
	validates :from, :sent, :body, :presence => true
	validates :from, :uniqueness => true
end
