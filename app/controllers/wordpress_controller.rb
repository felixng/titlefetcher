class WordpressController < ApplicationController
  def index
  	@query = Query.new
  end

  def new 
  	@query = Query.new
  end

  def fetch
  end
end
