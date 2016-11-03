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

def find_all_or_one(interface,zendesk)

	puts "Would you like to get all custom Incident and Contact fields?(y/n)"
	puts

	get_fields = gets.chomp

	if get_fields.match(/y/)
		get_custom_fields(interface,zendesk)
	elsif get_fields.match(/n/)
		
		puts "Which table is your custom field part of? (Currently only supporting Incident and Contact tables from Oracle Service Cloud)"
		puts

		get_table = gets.chomp

		puts "What is the name of the field from the "+ get_table +" table?"
		puts

		get_field_name = gets.chomp

		get_custom_field(interface,zendesk,get_table,get_field_name)

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
		request = Net::HTTP::Post.new(final_tickets_uri)
		request.basic_auth(ENV['ZENDESK_ADMIN'], ENV['ZENDESK_PASSWORD'])
		request.content_type = "application/json"
		request.body = JSON.dump(tf)

		response = Net::HTTP.start(final_tickets_uri.hostname, final_tickets_uri.port, use_ssl: final_tickets_uri.scheme == "https") do |http|
		  http.request(request)
		end
		
		puts response.body
		puts
	end

	puts "finished ticket fields"
	puts

	user_fields = results['User Fields']

	user_fields.each_with_index do |uf,i|
		request = Net::HTTP::Post.new(final_users_uri)
		request.basic_auth(ENV['ZENDESK_ADMIN'], ENV['ZENDESK_PASSWORD'])
		request.content_type = "application/json"
		request.body = JSON.dump(uf)

		response = Net::HTTP.start(final_users_uri.hostname, final_users_uri.port, use_ssl: final_users_uri.scheme == "https") do |http|
		  http.request(request)
		end
		
		puts response.body
		puts
	end

	puts "finished user fields"
	puts

	puts "done adding custom user and ticket fields"
	puts

end

def get_custom_field(interface,zendesk,table,name)

	request_uri = 'https://' + interface + '.custhelp.com/cc/custom_fields/field?field_table='+ table + '&field_name=' + name

	# tickets_uri = 'https://' + zendesk + '.zendesk.com/api/v2/ticket_fields.json'

	# users_uri = 'https://' + zendesk + '.zendesk.com/api/v2/user_fields.json'

	# final_tickets_uri = URI.parse(tickets_uri)

	# final_users_uri = URI.parse(users_uri)

	buffer = open(request_uri).read

	if valid_json?(buffer)

		results = JSON.parse(buffer)

		puts JSON.pretty_generate(results)
		puts
	else
		puts buffer
		puts
	end
	# request = Net::HTTP::Post.new(final_users_uri)
	# request.basic_auth(ENV['ZENDESK_ADMIN'], ENV['ZENDESK_PASSWORD'])
	# request.content_type = "application/json"
	# request.body = JSON.dump(uf)

	# response = Net::HTTP.start(final_users_uri.hostname, final_users_uri.port, use_ssl: final_users_uri.scheme == "https") do |http|
	#   http.request(request)
	# end
	
	# puts response.body
	# puts

end

puts "What is the name of the OSC interface you want to extract fields from?"
puts

interface = gets.chomp 

puts "What is the name of the Zendesk subdomain you want to import fields to?"
puts

zendesk = gets.chomp 

find_all_or_one(interface,zendesk)