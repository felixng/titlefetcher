require 'open-uri'

class QueriesController < ApplicationController
	def index
		@query = Query.new
	end

	def fetch_request(url)
		redirect_to url
	end

	def create 
		@query = Query.new(query_params)
		if @query.save 
	    	fetch_request(@query.url)
	  	else 
	    	render 'new' 
	 	end 
	end

	
	def query_params 
		params.require(:query).permit(:url) 
	end
end
