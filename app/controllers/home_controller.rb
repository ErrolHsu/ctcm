class HomeController < ApplicationController
	def index
		
	end

	def ajax
		render json: {a: 'okok'}.to_json
		puts response.body
	end
end
