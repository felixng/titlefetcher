class QueriesController < ApplicationController
  def index
  	@query = Query.new
  end

  def create 
  	@query = Query.new
  end
end
