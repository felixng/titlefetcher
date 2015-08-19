require 'open-uri'
require 'nokogiri'
require 'date'
require 'cgi'
	
class QueriesController < ApplicationController
	def index
		@query = Query.new
	end

	def fetch_titles(url)
	    doc = Nokogiri::HTML(open(url))
	    @titles = doc.css('h2').map
		#@titles = result.scan(/<h2>([^<>]*)<\/h2>/imu).flatten.select{|x| !x.empty?}
		render 'fetch'
	end

	def create 
		@query = Query.new(query_params)
		if @query.save 
	    	fetch_titles(@query.url)
	  	else 
	    	render 'new' 
	 	end 
	end
	
	def query_params 
		params.require(:query).permit(:url) 
	end
	 
	private
	def get_post_details(doc)
	  #an array of hashes with each posts title, url, date, author
	  posts = []
	 
	  doc.css('h2').each do |post|
	 
	    details = post.xpath('.//a')[0].attributes()
	 
	    #get url
	    url = details['href'].value()
	    #verify that the url matches mashable.com and is not feedproxy.google.com
	    next #unless url =~ /mashable.com/
	    puts url
	 
	    #get and parse title
	    title = details['title'].value() if details['title'] != nil
	    title = title.gsub(/Permanent Link to /, '')
	    title = CGI.escape( title ) #make sure title is encoded
	    puts title
	 
	    #get published date
	    next if post.xpath('.//time')[0] == nil #avoid 'sponsored posts'
	 
	    date_details = post.xpath('.//time')[0].attributes()
	    date_string = date_details['datetime'].value()
	    date = DateTime.parse(date_string) #creates a time object
	    puts date.to_s
	 
	    #get author
	    author_details = post.xpath('.//span')[0].children()
	    author = author_details.children().inner_text()
	    puts author
	 
	    #store the data in a hash
	    posts << {'title' => title, 'date' => date, 'author' => author, 'url' => url}
	  end
	  posts #returns an array of hashes with details for each post
	end
	 
	public
	def crawl(url)
	  #keeps track of page number
	  page = 1
	 
	  #loop through each page on Mashable, and get the author, title, url, and date for each post
	  loop do
	    #get post details per page
	    url = url + "/#{page}/"
	    doc = Nokogiri::HTML(open(url))
	    posts = get_post_details(doc)
	    p posts
	 
	    #you've crawled all the pages if the returned posts array is empty
	    break if posts == []
	 
	    #move on to the next page
	    page += 1
	  end
	end
end
