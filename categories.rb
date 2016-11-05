require 'open-uri'
require 'json'
require 'net/http'
require 'uri'



def valid_json?(json)
  begin
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
  end
end

def post_to_zendesk_api(uri,field)

	puts "POSTing to the "+uri+" URI"

	final_uri = URI.parse(uri)

	request = Net::HTTP::Post.new(final_uri)
	request.basic_auth(ENV['ZENDESK_ADMIN'], ENV['ZENDESK_PASSWORD'])
	request.content_type = "application/json"
	request.body = JSON.dump(field)

	response = Net::HTTP.start(final_uri.hostname, final_uri.port, use_ssl: final_uri.scheme == "https") do |http|
	  http.request(request)
	end
	
	puts response.body
	puts

end

def get_categories(interface,zendesk)

	request_uri = 'https://' + interface + '.custhelp.com/cc/service_categories/get_qsee_categories'

	categories_uri = 'https://' + zendesk + '.zendesk.com/api/v2/help_center/categories.json'

	final_categories_uri = URI.parse(categories_uri)

	buffer = open(request_uri).read

	results = JSON.parse(buffer)

	results.each do |cat|

		if cat['sc_parent_id'] == nil
			
			# TODO
			# 1. create an object
			# 2. set the locale hash to 'en-us'
			# 3. set name hash to cat['sc_name']
			# 4. post JSON data to categories creation URL

			puts cat['sc_name']

		else

			# TODO
			# 1. create a method for retrieving categories by name
				# parse the object that is fetched into some format where I can return the category ID
				# set to variable
			# 2. create an object
			# 3. set the locale hash to 'en-us'
			# 4. set name hash to cat['sc_name']
			# 5. post JSON data to sections creation URL

			puts 'this is a level 2 category:' + cat['sc_name']
		
		end

	end

	# ticket_fields = results['Ticket Fields']

	# ticket_fields.each_with_index do |tf,i|

	# 	post_to_zendesk_api(final_categories_uri,tf)

	# end

end

def init

	puts "What is the name of the OSC interface you want to categories from?"
	puts

	interface = gets.chomp 

	puts "What is the name of the Zendesk subdomain you want to import categories to?"
	puts

	zendesk = gets.chomp 

	get_categories(interface,zendesk)

end

init