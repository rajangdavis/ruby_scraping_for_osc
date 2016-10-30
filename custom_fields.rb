# http://ruby-doc.org/stdlib-2.0.0/libdoc/open-uri/rdoc/OpenURI.html 
require 'open-uri'
# https://github.com/flori/json
require 'json'

puts "What is the name of the interface you want to extract fields from?"

interface = gets.chomp 

# get https://qseecode.herokuapp.com/qsee_rn_array.json
request_uri = 'https://' + interface+ '.custhelp.com/cc/custom_fields/fields'

# Actually fetch the contents of the remote URL as a String.
buffer = open(request_uri).read

results = JSON.parse(buffer)

# loop through the results

ticket_fields = results['Ticket Fields']

ticket_fields.each do |tf|

	puts JSON.pretty_generate(tf['ticket_field'])

end

puts "finished ticket fields"

user_fields = results['User Fields']

user_fields.each do |uf|

	puts JSON.pretty_generate(uf['user_field'])

end

puts "finished user fields"

# done

puts "done"