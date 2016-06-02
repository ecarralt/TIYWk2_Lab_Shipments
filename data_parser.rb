require 'csv'
require 'erb'

shipment_data = []

#First, create an array of hashes that imports the data and assigns it to an
#employee, per the additional data provided

CSV.foreach('planet_express_logs.csv', headers: true) do |row|
  shipment = row.to_hash
  shipment_data << shipment
  case shipment["Destination"]
    when "Earth"
      shipment["Employee"] = "Fry"
    when "Mars"
      shipment["Employee"] = "Amy"
    when "Uranus"
      shipment["Employee"] = "Bender"
    else
      shipment["Employee"] = "Leela"
  end
end

#Create variables for the data we need
fry_trips = 0
fry_money = 0
amy_trips = 0
amy_money = 0
bender_trips = 0
bender_money = 0
leela_trips = 0
leela_money = 0

empl_trips = shipment_data.select do |shipment|
  case shipment["Employee"]
  when "Fry"
    fry_trips += 1
    fry_money += shipment["Money"].to_i
  when "Amy"
    amy_trips += 1
    amy_money += shipment["Money"].to_i
  when "Bender"
    bender_trips += 1
    bender_money += shipment["Money"].to_i
  when "Leela"
    leela_trips += 1
    leela_money += shipment["Money"].to_i
  else
  end
end

#Create an array of hashes with the calculated data

employee_data= [{employee: "Fry", trips: fry_trips, money: fry_money},
  {employee: "Amy", trips: amy_trips, money: amy_money},
  {employee: "Bender", trips: bender_trips, money: bender_money},
  {employee: "Leela", trips: leela_trips, money: leela_money}
]

total_money = 0

employee_data.each do |row|
  total_money += row[:money]
end
puts total_money

puts "===="

puts employee_data

puts "======"
puts "======"

puts shipment_data

html_template_as_a_string = File.read("template.html.erb")
html= ERB.new(html_template_as_a_string).result(binding)
File.open("index.html", "wb") {|file| file << html}


#
# puts "===="
#
# puts fry_money
# puts amy_money
# puts bender_money
# puts leela_money
#
# puts "======"
# puts fry_trips
# puts amy_trips
# puts bender_trips
# puts leela_trips
