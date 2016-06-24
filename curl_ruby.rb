
# http://ruby-doc.org/stdlib-2.0.0/libdoc/open-uri/rdoc/OpenURI.html 
require 'open-uri'
# https://github.com/flori/json
require 'json'
# http://stackoverflow.com/questions/9008847/what-is-difference-between-p-and-pp

# get https://qseecode.herokuapp.com/qsee_rn_array.json
request_uri = 'https://qseecode.herokuapp.com/qsee_rn_array.json'

# Actually fetch the contents of the remote URL as a String.
buffer = open(request_uri).read

results = JSON.parse(buffer)

# loop through the results

puts 'Retrieved list of Answers'

results.each do |result|

	# go to https://qseecode.herokuapp.com/qsee_rn_partial/ + answer_id

	partial_url = "https://qseecode.herokuapp.com/qsee_rn_partial/#{result['answer_id']}"

	content = open(partial_url).read

	# save the response to content variable
	partial_content = JSON.parse(content)

	puts "Finished getting the partial content for answer #{result['answer_id']}"
	
	# set variable for ENV['ANSWER_AUTOMATION']

	automation_key = ENV['ANSWER_AUTOMATION']
	
	formatted_url = URI.encode("https://qsee--tst1.custhelp.com/cc/answers/update_answer?automation_key=#{automation_key}")

	post_uri = URI.parse(formatted_url)

	# go to https://qsee--tst1.custhelp.com/cc/answers/update_answer?automation_key

	# with the a_id set as rn_a_id and content set as content

	response = Net::HTTP.post_form(post_uri, {"a_id" => result['rn_a_id'], "content" => partial_content['content']})

	puts response.body
# end loop	
end

# done
puts 'Finished updating RN'