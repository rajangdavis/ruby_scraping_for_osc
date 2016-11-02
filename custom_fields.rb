require 'open-uri'
require 'json'
require 'net/http'
require 'uri'

puts "What is the name of the OSC interface you want to extract fields from?"

interface = gets.chomp 

puts "What is the name of the Zendesk subdomain you want to import fields to?"

zendesk = gets.chomp 

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
end

puts "finished ticket fields"

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
end

puts "finished user fields"

puts "done adding custom user and ticket fields"