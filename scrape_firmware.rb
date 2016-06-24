require 'mechanize'
require 'nokogiri'
require 'json'
require "cgi"

agent = Mechanize.new

agent2 = Mechanize.new

answer_id_array = [{'a_id'=> 1468,'ab_a_id'=>91},
{'a_id'=> 2144,'ab_a_id'=>76},
{'a_id'=> 2367,'ab_a_id'=>76},
{'a_id'=> 2410,'ab_a_id'=>76},
{'a_id'=> 2411,'ab_a_id'=>91},
{'a_id'=> 2413,'ab_a_id'=>76},
{'a_id'=> 2414,'ab_a_id'=>76},
{'a_id'=> 2415,'ab_a_id'=>76},
{'a_id'=> 2416,'ab_a_id'=>76},
{'a_id'=> 2417,'ab_a_id'=>91},
{'a_id'=> 2418,'ab_a_id'=>76},
{'a_id'=> 2419,'ab_a_id'=>91},
{'a_id'=> 2561,'ab_a_id'=>91},
{'a_id'=> 2562,'ab_a_id'=>79},
{'a_id'=> 2563,'ab_a_id'=>76},
{'a_id'=> 2564,'ab_a_id'=>76},
{'a_id'=> 2565,'ab_a_id'=>79},
{'a_id'=> 2566,'ab_a_id'=>79},
{'a_id'=> 2567,'ab_a_id'=>76},
{'a_id'=> 2568,'ab_a_id'=>79},
{'a_id'=> 2569,'ab_a_id'=>76},
{'a_id'=> 2570,'ab_a_id'=>79},
{'a_id'=> 2571,'ab_a_id'=>76},
{'a_id'=> 2572,'ab_a_id'=>91},
{'a_id'=> 2576,'ab_a_id'=>76},
{'a_id'=> 2577,'ab_a_id'=>76},
{'a_id'=> 2584,'ab_a_id'=>76},
{'a_id'=> 2585,'ab_a_id'=>76},
{'a_id'=> 2603,'ab_a_id'=>76},
{'a_id'=> 2604,'ab_a_id'=>91},
{'a_id'=> 2605,'ab_a_id'=>91},
{'a_id'=> 2610,'ab_a_id'=>76},
{'a_id'=> 2611,'ab_a_id'=>79},
{'a_id'=> 2612,'ab_a_id'=>76},
{'a_id'=> 2613,'ab_a_id'=>79},
{'a_id'=> 2624,'ab_a_id'=>91},
{'a_id'=> 2627,'ab_a_id'=>76},
{'a_id'=> 2628,'ab_a_id'=>79},
{'a_id'=> 2736,'ab_a_id'=>91},
{'a_id'=> 2737,'ab_a_id'=>91},
{'a_id'=> 2738,'ab_a_id'=>91},
{'a_id'=> 2820,'ab_a_id'=>76},
{'a_id'=> 2821,'ab_a_id'=>79},
{'a_id'=> 2822,'ab_a_id'=>79},
{'a_id'=> 2823,'ab_a_id'=>76},
{'a_id'=> 2835,'ab_a_id'=>79},
{'a_id'=> 2836,'ab_a_id'=>76},
{'a_id'=> 2837,'ab_a_id'=>76},
{'a_id'=> 2838,'ab_a_id'=>79}]

automation_key = ENV['ANSWER_AUTOMATION']

answer_id_array.each do |answer|

	url = "https://qsee--tst1.custhelp.com/cc/api/getAnswer?a_id=#{answer['a_id']}"

	puts "scraping #{url}"

	agent.get(url)

	answer_ = JSON.parse(agent.page.body)

	doc = Nokogiri::HTML(answer_['html'])

	doc.search('#imagemodal,button[data-dismiss="modal"]').each do |node|
      node.remove
    end

    firmware_popup = []

    doc.search('a.alert').each do |node|
      node.parent.set_attribute('toggle-child','')
      node.remove_attribute('href')
      node.set_attribute('id','firmware_link')
      node.set_attribute('class','pointer')
    end

    doc.search('#firmware_link').each do |node|
      firmware_popup.push(node.parent)
    end
    
    doc.search('.modal-body,.modal-footer').each do |node|
      firmware_popup.push(node)
    end

    doc.search('.modal-footer').each do |node|
      node.set_attribute('class','modal-footer text-center')
    end

    firmware_popup[1].search('.red.h2').each do |node|
    	node.after(firmware_popup[2])
    end 

    firmware_final = firmware_popup[0].to_s + firmware_popup[1].to_s

	puts 'done modifying answer, getting answer partial from answerbuilder'

	partial_url = "https://qseecode.herokuapp.com/qsee_rn_partial/#{answer['ab_a_id']}"

	agent2.get(partial_url)	

	answer_partial = JSON.parse(agent2.page.body)

	html_partial = answer_partial['content']

	html_partial = CGI.unescapeHTML(html_partial)

	html_partial = Nokogiri::HTML(html_partial)

	html_partial.search('.clearfix.text-uppercase.h6.col-lg-12.col-md-12.col-sm-12.col-xs-12.text-center').each do |node|
		node.after(firmware_final)
		node.remove()
	end

	puts 'partial has been constructed'

	formatted_url = URI.encode("https://qsee--tst1.custhelp.com/cc/answers/update_answer?automation_key=#{automation_key}")

	post_uri = URI.parse(formatted_url)

	puts "uploading to RN"

	response = Net::HTTP.post_form(post_uri, {"a_id" => answer['a_id'], "content" => html_partial})

	puts response.body

end

puts 'done updating the firmware answers'