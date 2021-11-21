class Message
  UUID_TO_NAME = {
    'f2ac7614-a07f-46ee-8703-cb7ed2293840' => 'Max Schwanebeck',
    '91d24822-6d0d-4c72-b9de-c6987a958724' => 'Matt Carter',
    'cf24122d-0db2-4d3b-bfd9-635eda38a9e1' => 'Michael Schmitt',
    '120e1329-f5cd-4b9f-abe8-a77ff7e3be8a' => 'Krishnan Warrior',
    'f06e4fc2-34a3-4820-a706-35d32eceb69e' => 'Jonas Owen',
    '64fa33dc-a206-4357-afee-d96daaa99354' => 'Roshan Choxi',
    'ac875429-1624-40c7-925c-731fe43d3cf7' => 'Francisco Saldana',
    'j0ebot' => 'Joe Janiczek'
  }

  attr_reader :envelope, :source, :sent_at, :group_id
  attr_accessor :body

  def initialize(raw)
    @raw = raw
    @envelope = raw["envelope"]
    @body = raw.dig("envelope", "dataMessage", "message")
    @source = UUID_TO_NAME[raw.dig("envelope", "sourceUuid")]
    @sent_at = Time.at(raw.dig("envelope", "timestamp") / 1000)
    @group_id = raw.dig("envelope", "dataMessage", "groupInfo", "groupId")
  rescue => e
    binding.pry
  end

  def formatted
    first_name = @source.split.first
    first_name = 'Schmitty' if first_name == 'Michael'
    "#{first_name}: #{@body}"
  end
end
