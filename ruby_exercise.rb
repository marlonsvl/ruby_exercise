require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'active_support/all'

url = "https://www.port-monitor.com/plans-and-pricing"
doc = Nokogiri::HTML(open(url))
puts doc.at_css("title").text
puts doc.at_css(".product")
products = []
class Product
	attr_accessor :monitors, :check_rate, :history, :multipleNotifications, :pushNotifications, :price
	
	def initialize(monitors, check_rate, history, multipleNotifications, pushNotifications, price)
		@monitors = monitors
		@check_rate = check_rate
		@history = history
		@multipleNotifications = multipleNotifications
		@pushNotifications = pushNotifications
		@price = price
	end
end
doc.css(".product").each do |item|
	monitors = item.at_css("h2").text.to_i
	check_rate = item.css("dd")[0].text
	check_rate = check_rate.gsub(/[^0-9]/, '').to_i
	history = item.css("dd")[1].text
	history = history.gsub(/[^0-9]/, '').to_i
	multipleNotifications = item.css("dd")[2].text
	if multipleNotifications == "Yes"
		multipleNotifications = true
		puts multipleNotifications
	else
		multipleNotifications = false
		puts multipleNotifications
	end
	
	pushNotifications = item.css("dd")[3].text
	if pushNotifications == "Yes"
		pushNotifications = true
		puts pushNotifications	
	else
		pushNotifications = false
		puts pushNotifications	
	end
	
	price = item.at_css("p").text
	price = price.gsub(/[^0-9][^,.][^0-9]/, '').to_f
	puts price
	p = Product.new(monitors, check_rate, history, multipleNotifications, pushNotifications, price)
	products << p

end
puts products.to_json
