require 'open-uri'

class QueriesController < ApplicationController
  def index
  	@query = Query.new
  end

  def create 
  	@query = Query.new(query_params)
  	if @query.save 
        redirect_to '/' 
      else 
        render 'new' 
     end 
  end

  def fetch(url)
  	
  end

  def query_params 
    params.require(:query).permit(:url) 
  end
end
