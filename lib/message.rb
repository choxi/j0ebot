class Message
  UUID_TO_NAME = {
    'f2ac7614-a07f-46ee-8703-cb7ed2293840' => 'Max Schwanebeck',
    '91d24822-6d0d-4c72-b9de-c6987a958724' => 'Matt Carter',
    'cf24122d-0db2-4d3b-bfd9-635eda38a9e1' => 'Michael Schmitt',
    '120e1329-f5cd-4b9f-abe8-a77ff7e3be8a' => 'Krishnan Warrior',
    'f06e4fc2-34a3-4820-a706-35d32eceb69e' => 'Jonas Owen',
    '64fa33dc-a206-4357-afee-d96daaa99354' => 'Roshan Choxi',
    'ac875429-1624-40c7-925c-731fe43d3cf7' => 'Francisco Saldana',
    '69fcf7bb-142c-4d93-b7ac-2ae64cf57705' => 'Joe Janiczek',
    'j0ebot' => 'Joe Janiczek'
  }

  attr_accessor :envelope, :source, :sent_at, :group_id, :body, :mentions

  def initialize(raw)
    @raw = raw
    @envelope = raw["envelope"]
    @body = strip_emojis(raw.dig("envelope", "dataMessage", "message"))
    @source = UUID_TO_NAME[raw.dig("envelope", "sourceUuid")]
    @mentions = raw.dig("envelope", "dataMessage", "mentions")
    @sent_at = Time.at(raw.dig("envelope", "timestamp") / 1000)
    @group_id = raw.dig("envelope", "dataMessage", "groupInfo", "groupId")
  rescue => e
    binding.pry
  end

  def formatted
    first_name = @source.split.first
    first_name = 'Schmitty' if first_name == 'Michael'
    first_name = 'Carter' if first_name == 'Matt'
    body = body_with_mentions.gsub(/j0ebot/i, "Joe")
    "#{first_name}: #{body}"
  end

  # "mentions"=>
  # [{"name"=>"+12245780974",
  #   "number"=>"+12245780974",
  #   "uuid"=>"64fa33dc-a206-4357-afee-d96daaa99354",
  #   "start"=>0,
  #   "length"=>1}],
  def body_with_mentions
    return @body unless @mentions.length == 1
    mention = @mentions.first
    name = UUID_TO_NAME[mention['uuid']]
    first_name = name.split.first
    removed = remove_char_at(@body, mention["start"])
    removed.insert(mention["start"] || 0, first_name)
  rescue => e
    binding.pry
  end

  def remove_char_at(c, i)
    c.slice(0, i)+c.slice(i+1, c.length)
  end

  def strip_emojis(str)
    return unless str
    str.unpack('U*').reject{ |e| e.between?(0x1F600, 0x1F6FF) }.pack('U*')
  end
end
