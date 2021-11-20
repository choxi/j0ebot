require "json"
require "csv"
require "pry"

class Data
  NUMBERS_TO_NAME = {
    '+12192994442' => 'Joe Janiczek',
    '+12245780974' => 'Roshan Choxi',
    '+18472715832' => 'Matt Carter',
    '+12247230113' => 'Jonas Owen',
    '+16308999196' => 'Max Schwanebeck',
  }

  UUID_TO_NAME = {
    'f2ac7614-a07f-46ee-8703-cb7ed2293840' => 'Max Schwanebeck',
    '120e1329-f5cd-4b9f-abe8-a77ff7e3be8a' => 'Matt Carter',
    'cf24122d-0db2-4d3b-bfd9-635eda38a9e1' => 'Schmitty Schmitt',
    '120e1329-f5cd-4b9f-abe8-a77ff7e3be8a' => 'Krishnan Warrior',
    'f06e4fc2-34a3-4820-a706-35d32eceb69e' => 'Jonas Owen',
    '64fa33dc-a206-4357-afee-d96daaa99354' => 'Roshan Choxi',
    'ac875429-1624-40c7-925c-731fe43d3cf7' => 'Frank'
  }

  def self.load
    rows = CSV.read("./schmitty.csv")
    rows[1..-1].map do |row|
      message = JSON.parse(row[2])
      number = message["source"]
      uuid = message["sourceUuid"]
      type = message["type"]
      next unless ["incoming", "outgoing"].include?(type)

      message["source_name"] = 'Schmitty Schmitt' if type == "outgoing"
      message["source_name"] ||= NUMBERS_TO_NAME[number]
      message["source_name"] ||= UUID_TO_NAME[uuid]

      if !message["source_name"]
        binding.pry
      end
      message
    end
  end
end

class J0ebot
  def run
  end
end

messages = Data.load
messages.filter {|m| m && m["source_name"] }.each do |message|
  puts "#{message["source_name"]}: #{message["body"]}"
end