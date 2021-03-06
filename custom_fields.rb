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

def get_field_details(interface,zendesk)

	puts "Which table is your custom field part of? (Currently only supporting Incident and Contact tables from Oracle Service Cloud)"
	puts

	get_table = gets.chomp

	puts "What is the name of the field from the "+ get_table +" table?"
	puts

	get_field_name = gets.chomp

	get_custom_field(interface,zendesk,get_table,get_field_name)

end

def find_all_or_one(interface,zendesk)

	puts "Would you like to get all custom Incident and Contact fields?(y/n)"
	puts

	get_fields = gets.chomp

	if get_fields.downcase === "y"
		get_custom_fields(interface,zendesk)
	elsif get_fields.downcase === "n"
		
		get_field_details(interface,zendesk)		

	else
		puts 'Sorry, please type "y" for yes and "n" for no'
		puts
		find_all_or_one(interface,zendesk)
	end

end

def get_custom_fields(interface,zendesk)

	request_uri = 'https://' + interface + '.custhelp.com/cc/custom_fields/fields'

	tickets_uri = 'https://' + zendesk + '.zendesk.com/api/v2/ticket_fields.json'

	users_uri = 'https://' + zendesk + '.zendesk.com/api/v2/user_fields.json'

	final_tickets_uri = URI.parse(tickets_uri)

	final_users_uri = URI.parse(users_uri)

	buffer = open(request_uri).read

	results = JSON.parse(buffer)

	ticket_fields = results['Ticket Fields']

	ticket_fields.each_with_index do |tf,i|

		post_to_zendesk_api(final_tickets_uri,tf)

	end

	puts "finished ticket fields"
	puts

	user_fields = results['User Fields']

	user_fields.each_with_index do |uf,i|
		
		post_to_zendesk_api(final_users_uri,tf)

	end

	puts "finished user fields"
	puts

	puts "done adding custom user and ticket fields"
	puts

end

def get_zendesk_uri(zendesk,table)

	table = table.downcase

	if table ==="incident"

		return 'https://' + zendesk + '.zendesk.com/api/v2/ticket_fields.json'
		
	elsif table ==="contact"
	
		return 'https://' + zendesk + '.zendesk.com/api/v2/user_fields.json'

	else

		puts "The specified table not supported" 
		abort("Invalid table: " + table)
	
	end

end

def get_custom_field(interface,zendesk,table,name)

	osc_request_uri = 'https://' + interface + '.custhelp.com/cc/custom_fields/field?field_table='+ table + '&field_name=' + name

	zendesk_uri = get_zendesk_uri(zendesk,table)

	buffer = open(osc_request_uri).read

	field_type = table.downcase == "incident" ? "ticket_field" : "user_field"

	if valid_json?(buffer)

		results = JSON.parse(buffer)

		field_json = {}

		field_json[field_type] = results

		post_to_zendesk_api(zendesk_uri,field_json)

	else
		puts buffer
		puts
	end

end

puts "What is the name of the OSC interface you want to extract fields from?"
puts

interface = gets.chomp 

puts "What is the name of the Zendesk subdomain you want to import fields to?"
puts

zendesk = gets.chomp 

find_all_or_one(interface,zendesk)