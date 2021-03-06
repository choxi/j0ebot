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
    '91d24822-6d0d-4c72-b9de-c6987a958724' => 'Matt Carter',
    'cf24122d-0db2-4d3b-bfd9-635eda38a9e1' => 'Michael Schmitt',
    '120e1329-f5cd-4b9f-abe8-a77ff7e3be8a' => 'Krishnan Warrior',
    'f06e4fc2-34a3-4820-a706-35d32eceb69e' => 'Jonas Owen',
    '64fa33dc-a206-4357-afee-d96daaa99354' => 'Roshan Choxi',
    'ac875429-1624-40c7-925c-731fe43d3cf7' => 'Francisco Saldana'
  }

  def self.load
    rows = CSV.read(File.join(".", "data", "schmitty.csv"))
    rows[1..-1].map do |row|
      message = JSON.parse(row[2])
      number = message["source"]
      uuid = message["sourceUuid"]
      type = message["type"]
      next unless ["incoming", "outgoing"].include?(type)

      message["source_name"] = 'Michael Schmitt' if type == "outgoing"
      message["source_name"] ||= NUMBERS_TO_NAME[number]
      message["source_name"] ||= UUID_TO_NAME[uuid]

      if !message["source_name"]
        binding.pry
      end
      message
    end
  end
end

def generate_fine_tuning_file(messages, generative: false)
  formatted = messages.filter {|m| m && m["source_name"] && (m["body"] || '').strip.length > 0 }.map do |message|
    received_at = Time.at(message["sent_at"] / 1000.0)
    name = message["source_name"].split.first
    name = 'Schmitty' if name == 'Michael'
    if generative
      puts "#{name}: #{message["body"]}"
      {
        prompt: "",
        completion: "[#{received_at.strftime("%m-%d-%Y %I:%M %p")}] <#{message["source_name"]}> #{message["body"]}",
      }.to_json
    else
      {
        prompt: "#{message["source_name"]}:",
        completion: " #{message["body"]} END",
      }.to_json
    end
  end.join("\n")
 end

def only_joe_tuning_file(messages)
  filtered = messages.filter do |m|
    m && m["source_name"] && (m["body"] || '').strip.length > 0 && m["source_name"] == 'Joe'
  end

  filtered.map do |message|
    puts "#{message["source_name"]}: #{message["body"]}"
    {
      prompt: "",
      completion: " #{message["body"]}",
    }.to_json
  end.join("\n")
end

data = Data.load
body = generate_fine_tuning_file(data, generative: true)
# body = only_joe_tuning_file(data)
words = body.split.size

puts "#{words} words -> #{words / 750 * 1000 } tokens -> $#{(0.0008 * words / 750).round(2)}"

File.write(File.join(".", "data", "group-chat-timestamps.jsonl"), body)