#Require necessary libraries
require 'csv'
require 'erb'

#Define necessary functions
def as_money(number)
   sprintf("$%.2f", number).reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
end

#Declare variables
fry_trips = 0
fry_money = 0
amy_trips = 0
amy_money = 0
bender_trips = 0
bender_money = 0
leela_trips = 0
leela_money = 0

total_money = 0

#Create an array of hashes that imports the data, applies the
#employee to destination relationship, and makes most of the calculations
shipment_data = []
CSV.foreach('planet_express_logs.csv', headers: true) do |row|
  shipment = row.to_hash
  shipment_data << shipment
  case shipment["Destination"]
    when "Earth"
      shipment["Employee"] = "Fry"
      fry_trips += 1
      fry_money += shipment["Money"].to_i
    when "Mars"
      shipment["Employee"] = "Amy"
      amy_trips += 1
      amy_money += shipment["Money"].to_i
    when "Uranus"
      shipment["Employee"] = "Bender"
      bender_trips += 1
      bender_money += shipment["Money"].to_i
    else
      shipment["Employee"] = "Leela"
      leela_trips += 1
      leela_money += shipment["Money"].to_i
  end
end


#Create an array of hashes for the employee data, which would help us Create
#the table in HTML (includes bonus calculation)
bonusf = 0.1
employee_data= [{employee: "Fry", trips: fry_trips, bonus: fry_money * bonusf},
  {employee: "Amy", trips: amy_trips, bonus: amy_money * bonusf},
  {employee: "Bender", trips: bender_trips, bonus: bender_money * bonusf},
  {employee: "Leela", trips: leela_trips, bonus: leela_money * bonusf}
]

#Calculate total money from the employee data
employee_data.each do |row|
  total_money += row[:bonus] / bonusf
end

#To create the planet data, I would do cases on the planet unique values,
#which can be found like below
# unique_planets = shipment_data.map do |shipment|
#   shipment["Destination"]
# end.uniq
#print unique_planets



# Use puts to check data during the creation
# puts total_money
# puts "===="
#
# puts employee_data
#
# puts "======"
# puts "======"
#
# puts shipment_data
#
# puts "===="
#
# puts as_money(employee_data[0][:bonus])

#Read template, compile erb, and write html
html_template_as_a_string = File.read("template.html.erb")
html= ERB.new(html_template_as_a_string).result(binding)
File.open("index.html", "wb") {|file| file << html}



# puts "===="

# puts fry_money
# puts amy_money
# puts bender_money
# puts leela_money

# puts "======"
# puts fry_trips
# puts amy_trips
# puts bender_trips
# puts leela_trips
