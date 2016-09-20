require 'mechanize'
require 'json'
require "cgi"

agent = Mechanize.new

agent2 = Mechanize.new

answer_id_array = [
	{'a_id' => 19,'categories' => "710"},
	{'a_id' => 396,'categories' => "707"},
	{'a_id' => 399,'categories' => "710"},
	{'a_id' => 1624,'categories' => "710"},
	{'a_id' => 1836,'categories' => "708"},
	{'a_id' => 1837,'categories' => "708"},
	{'a_id' => 1888,'categories' => "707"},
	{'a_id' => 1889,'categories' => "710"},
	{'a_id' => 1890,'categories' => "710"},
	{'a_id' => 1891,'categories' => "710"},
	{'a_id' => 1892,'categories' => "710"},
	{'a_id' => 1893,'categories' => "710"},
	{'a_id' => 1895,'categories' => "710"},
	{'a_id' => 1896,'categories' => "710"},
	{'a_id' => 1897,'categories' => "710"},
	{'a_id' => 1898,'categories' => "710"},
	{'a_id' => 1899,'categories' => "710"},
	{'a_id' => 1900,'categories' => "710"},
	{'a_id' => 1901,'categories' => "710"},
	{'a_id' => 1902,'categories' => "710"},
	{'a_id' => 1903,'categories' => "710"},
	{'a_id' => 1904,'categories' => "707"},
	{'a_id' => 1905,'categories' => "707"},
	{'a_id' => 1906,'categories' => "710"},
	{'a_id' => 1907,'categories' => "708"},
	{'a_id' => 1908,'categories' => "710"},
	{'a_id' => 1909,'categories' => "710"},
	{'a_id' => 1910,'categories' => "707"},
	{'a_id' => 1911,'categories' => "707"},
	{'a_id' => 1943,'categories' => "709"},
	{'a_id' => 2008,'categories' => "710"},
	{'a_id' => 2009,'categories' => "710"},
	{'a_id' => 2168,'categories' => "707"},
	{'a_id' => 2169,'categories' => "707"},
	{'a_id' => 2170,'categories' => "707"},
	{'a_id' => 2171,'categories' => "707"},
	{'a_id' => 2172,'categories' => "707"},
	{'a_id' => 2173,'categories' => "707"},
	{'a_id' => 2174,'categories' => "707"},
	{'a_id' => 2175,'categories' => "707"},
	{'a_id' => 2176,'categories' => "707"},
	{'a_id' => 2290,'categories' => "710,707"},
	{'a_id' => 2444,'categories' => "710"},
	{'a_id' => 2465,'categories' => "710"},
	{'a_id' => 2466,'categories' => "710"},
	{'a_id' => 2469,'categories' => "707,710"},
	{'a_id' => 2477,'categories' => "710"},
	{'a_id' => 2478,'categories' => "710"},
	{'a_id' => 2479,'categories' => "710"},
	{'a_id' => 2481,'categories' => "710"},
	{'a_id' => 2511,'categories' => "710"},
	{'a_id' => 2513,'categories' => "710"},
	{'a_id' => 2514,'categories' => "710"},
	{'a_id' => 2516,'categories' => "710"},
	{'a_id' => 2517,'categories' => "710"},
	{'a_id' => 2523,'categories' => "710"},
	{'a_id' => 2530,'categories' => "707,710"},
	{'a_id' => 2531,'categories' => "710"},
	{'a_id' => 2620,'categories' => "710"},
	{'a_id' => 2806,'categories' => "710"},
	{'a_id' => 2808,'categories' => "710"},
	{'a_id' => 2810,'categories' => "707,710"},
	{'a_id' => 2816,'categories' => "710"},
	{'a_id' => 2818,'categories' => "710"},
	{'a_id' => 2825,'categories' => "710"},
	{'a_id' => 2827,'categories' => "710"},
	{'a_id' => 2828,'categories' => "710"},
	{'a_id' => 2849,'categories' => "710"},
	{'a_id' => 2852,'categories' => "710"},
	{'a_id' => 2854,'categories' => "710"},
	{'a_id' => 2859,'categories' => "707"},
	{'a_id' => 2861,'categories' => "710"},
	{'a_id' => 2864,'categories' => "710"},
	{'a_id' => 2865,'categories' => "710"},
	{'a_id' => 2869,'categories' => "707,708"},
	{'a_id' => 2870,'categories' => "707,708"},
	{'a_id' => 2871,'categories' => "707,708"},
	{'a_id' => 2872,'categories' => "708,707"},
	{'a_id' => 2873,'categories' => "707,708"}]

automation_key = ENV['ANSWER_AUTOMATION']

answer_id_array.each do |answer|

	formatted_url = URI.encode("https://qsee--tst1.custhelp.com/cc/answers/updateJapaneseAnswers?automation_key=#{automation_key}")

	post_uri = URI.parse(formatted_url)

	puts "uploading to RN"

	response = Net::HTTP.post_form(post_uri, {"a_id" => answer['a_id'], "categories" => answer['categories']})

	puts response.body

end

puts 'done updating the japanese answers'