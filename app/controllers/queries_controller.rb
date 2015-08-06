require 'open-uri'

class QueriesController < ApplicationController
  def index
  	@query = Query.new
  end

  def create 
  	@query = Query.new(query_params)
  	if @query.save 
        redirect_to @query.url
      else 
        render 'new' 
     end 
  end
  
  def query_params 
    params.require(:query).permit(:url) 
  end
end
