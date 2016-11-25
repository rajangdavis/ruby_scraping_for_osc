#!/usr/bin/env ruby

require 'open-uri'
require 'json'
require 'net/http'
require 'uri'


def question_loop(questions_array, q_id)

	questions_array.each do |k,v|

		if k['id']===q_id
			return k['question']
		end

	end

end

def csv_format(headers,rows)

	final_csv = headers*','

	# final_csv = final_csv+"\n"

	rows.each_with_index do |row,i|

		flattened_row = []

		row.each_with_index do |(k,v),i|
			val = v.to_s
			headers.each_with_index do |header,i|
				if header == k
					flattened_row.push(val)
				elsif k.empty?
					flattened_row.push(" ")
				end

			end

			if i == (row.length-1)
				final_csv = final_csv+"\n"
			end
		end


		if flattened_row.length!=0

			strings = flattened_row*','

			final_csv += strings+','
			
		else

			final_csv +='"",'

		end
		
	end

	final_csv = final_csv+"\n"

	return final_csv

end


request_uri = URI.parse(<insert URL here>)

buffer = open(request_uri).read

results = JSON.parse(buffer)

responses = results['responses']

questions = results['questions']

final_answers = []

headers = []

questions.each do |question|

	q = question['question']

	if !headers.include? q
		headers.push(q)
	end

end

responses.each do |response| 

	# if response['completed'] == "1"
		
		final_answer = {}

		response['answers'].each do |q_id, answer|

			final_answer[question_loop(questions,q_id)] = answer.to_json

		end
		if final_answer!=nil

			final_answers.push(final_answer)
		end
	# end

end

File.open('test2.csv','w') do |s|
  s.puts csv_format(headers,final_answers)
end
