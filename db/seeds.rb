require 'net/http'
require 'json'
require 'csv'

# Name: Madison Sobering
# Class: WEBD-3012 Agile Full Stack Web Development
# Date: 29-01-2025

# Approximate run time of seed file with blank database: 22s

# Reset the database.
Unit.destroy_all
Call.destroy_all
Neighbourhood.destroy_all

# Gather data sources in variables.
call_endpoint = "https://data.winnipeg.ca/resource/yg42-q284.json?$limit=200"
neighbourhood_file = Rails.root.join('lib/seed_data/Neighbourhood.csv')
unit_file = Rails.root.join('lib/seed_data/Unit.csv')

# Make API call for calls data.
uri = URI(call_endpoint)
response = Net::HTTP.get(uri)
calls = JSON.parse(response)

# Read CSV files for the neighbourhood and unit data.
neighbourhood_data = File.read(neighbourhood_file)
unit_data = File.read(unit_file)

neighbourhoods = CSV.parse(neighbourhood_data, headers: true)
units = CSV.parse(unit_data, headers: true)

# Create Neighbourhood records.
neighbourhoods.each do |neighbourhood|
  Neighbourhood.create!(name: neighbourhood["Name"],
                        location: neighbourhood["the_geom"])
end

# Create Call record.
calls.each do |call|
  related_neighbourhood = Neighbourhood.find_by(name: call["neighbourhood"])

  # Only save calls that have a related neighbourhood, which should be all
  # of them, but this is a failsafe, just in case.
  if related_neighbourhood
    vehicle_crash = call["motor_vehicle_incident"].upcase == "YES" ? true : false

    current_call = related_neighbourhood.calls.create!(call_time: call["call_time"],
                                                       closed_time: call["closed_time"],
                                                       incident_type: call["incident_type"],
                                                       vehicle_crash: vehicle_crash,
                                                       ward: call["ward"])

    # Some call records do not have a units key.
    if call["units"]
      call_units = call["units"].split(",")

      # Create Unit records with the specific unit numbers from the call
      # and the description from the CSV.
      units.each do |unit|
        call_units.each do |call_unit|
          if call_unit.at(/#{unit["Code"]}/)
            related_unit = Unit.find_or_create_by!(code: call_unit,
                                                   name: unit["Name"])

            current_call.units << related_unit
          end
        end
      end
    end
  end
end