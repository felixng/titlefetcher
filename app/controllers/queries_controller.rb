require 'open-uri'
require 'nokogiri'
require 'date'
require 'cgi'
	
class QueriesController < ApplicationController
	def index
		@query = Query.new()
	end

	def create 
		@query = Query.new(query_params)
		if @query.save 
	    	fetch_titles(@query.url)
	  	else 
	    	render 'new' 
	 	end 
	end

	def fetch_titles(url)
		page = 1
	 
		loop do
			page_url = url.chomp('/') + "/page/#{page}/"

			begin 
				doc = Nokogiri::HTML(open(page_url))
				continute = get_post_title(doc)
			rescue OpenURI::HTTPError => e
			  if e.message == '404 Not Found'
			    break
			  else
			    raise e
			  end
			end 

			break if continute == false

			page += 1
		end

		posts = Post.order(:created_at)
	    send_data posts.as_csv, :filename => filenamify(url)
	end

	def filenamify(url)
		URI.parse(url).host + ".csv" 
	end

	def query_params 
		params.require(:query).permit(:url) 
	end
	 
	def get_post_title(doc)
		titles = doc.css('h2').map

		if (titles.count != 10)
			false
		else
		    titles.each do |title|
		    	post = Post.new(title: title.text)
		    	post.save
		    end
		   	true
		end 
	end

end
