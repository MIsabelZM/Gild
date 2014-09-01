require 'nokogiri'
require 'mechanize'
require 'csv'
require 'open-uri'
require 'pp'
require 'pry'

class Developers_info

	def initialize
		@agent = Mechanize.new
		@agent.get('http://www.gild.com/')
		@other_links = []
		sign_in
		filter
	end
	
	def sign_in
		login = @agent.page.link_with(:text => "Sign In").click

		form = login.forms.first
		username_field = form.field_with(:name => "user[email]")
		username_field.value = "user" #ARGS[0]

		password_field = form.field_with(:name => "user[password]")
		password_field.value =  "pw" #ARGS[1]

		form.submit
	end

	def filter

		form = @agent.page.forms.first
		skills_field = form.field_with(:name => "search[omni]")
		skills_field.value = "Ruby"

		expertise_field = form.field_with(:name => "search[expertise]")
		expertise_field.value = "3;6"

		demand_field = form.field_with(:name => "search[market_value]")
		demand_field.value = "0;2"

		#location_field = form.field_with(:name => "search[jumpto]")
		#location_field.value = "Poland"

		form.submit
	end

	def get_dev_info
		list = @agent.page.search("div#profile-listings-sorters")
		size_per_page = list.search("select#search-size-select")

		count = 0
	  begin
			links_developers = @agent.page.search("h2.display_name a")
			links_developers.each do |developer|
				url = "https://source.gild.com" + developer.values[0]
				name = developer.child.text
				@agent.get(url).save_as name
				#binding.pry
				social_media = @agent.page.search("div#social-media-icons-wrapper a")
				#social_media.each_with_index {|href, index| @other_links << social_media[index].values[0]}
				#binding.pry
				@agent.back
			end
			next_page = @agent.page.link_with(:text => "Next ›")
			if (next_page != nil)
				next_page.click
			end
			count += 1
		end while next_page != nil #count <= 1
	end
		
end

a = Developers_info.new
a.get_dev_info
