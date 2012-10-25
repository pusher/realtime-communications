class SurveyEntry < ActiveRecord::Base
	FORM_OPTIONS = ['Developer', 'Senior/Lead Developer', 'Designer', 'CTO/CEO', 'Other Exec', 'Other']

	def self.get_results
		counts =  SurveyEntry .count({ :group => :choice })	

		FORM_OPTIONS.map do |o|
		  {
			'title' => o,
			'votes' => counts[o]||0
		  }
		end
	end

end