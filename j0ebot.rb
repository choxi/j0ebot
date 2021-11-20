require "json"
require "csv"
require "pry"

class Data
  NUMBERS_TO_NAME = {
    '+12192994442' => 'Joe',
    '+12245780974' => 'Roshan',
    '+18472715832' => 'Matt',
    '+12247230113' => 'Jonas',
    '+16308999196' => 'Max',
  }

  UUID_TO_NAME = {
    'f2ac7614-a07f-46ee-8703-cb7ed2293840' => 'Max',
    '120e1329-f5cd-4b9f-abe8-a77ff7e3be8a' => 'Matt',
    'cf24122d-0db2-4d3b-bfd9-635eda38a9e1' => 'Schmitty',
    '120e1329-f5cd-4b9f-abe8-a77ff7e3be8a' => 'Krishnan',
    'f06e4fc2-34a3-4820-a706-35d32eceb69e' => 'Jonas',
    '64fa33dc-a206-4357-afee-d96daaa99354' => 'Roshan',
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

      message["source_name"] = 'Schmitty' if type == "outgoing"
      message["source_name"] ||= NUMBERS_TO_NAME[number]
      message["source_name"] ||= UUID_TO_NAME[uuid]

      if !message["source_name"]
        binding.pry
      end
      message
    end
  end
end

messages = Data.load
formatted = messages.filter {|m| m && m["source_name"] }.map do |message|
  log = "#{message["source_name"]}: #{message["body"]}"
  { prompt: '', completion: log }.to_json
end


File.write("group-chat.jsonl", formatted.join("\n"))