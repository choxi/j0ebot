require 'json'
require 'logger'
require './lib/multi_i_o'

class History
  attr_accessor :logger

  def initialize(file_path)
    @history = File.file?(file_path) ? File.read(file_path).split("\n").map { |line| JSON.parse(line) } : []
    @storage = File.open(file_path, 'a')
    @logger = Logger.new(STDOUT)
    logger.info "Loaded #{@history.length} messages into history."
  end

  def push(message)
    @storage.write message.to_json
    @history.push message
  end

  def conversation_context
    @history.last(5)
  end
end

class J0ebot
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
  J0EBOT_NUMBER = '+17342378793'
  LOGPATH = './j0ebot.log'
  HISTORY_PATH = File.join(".", "data", "messages.jsonl")
  GROUPS = {
    id: 'x5YSAYskxcHxG4eiBLLz27UYE3O9lZWOgDxjnAHBonI=',
    name: '- Qanon',
  }

  attr_reader :number
  attr_reader :logger
  attr_reader :message_logger
  attr_reader :history

  def initialize(number = J0EBOT_NUMBER)
    @number = number
    @logger = Logger.new(MultiIO.new(STDOUT, File.open(LOGPATH, "a")))
    @history = History.new(HISTORY_PATH)
    @openai = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def listen
    loop do
      puts "Pulse..."
      receive.each do |message|
        source = UUID_TO_NAME[message["envelope"]["sourceUuid"]]
        body = message["envelope"]["dataMessage"]
        mentioned = body["envelope"]["dataMessage"]["mentions"]
      end
      sleep 5
    end
  end

  def receive
    logger.info "J0ebot#receive"
    messages = run("receive")
    response = openai.completions(engine: "davinci", parameters: { prompt: "Once upon a time", max_tokens: 5 })
    puts response.inspect

    messages.each do |message|
      if message.is_a? Hash
        message_logger.info message.to_json
        @history << message
      end
    end
  end

  def send(message, group_id: nil, number: nil)
    logger.info "J0ebot#send message='#{message}' group_id=#{group_id} number=#{number}"

    if group_id && number
      logger.error 'must provide only group_id or number, not both'
      return
    end

    if group_id
      run("send -m '#{message}' -g #{group_id}")
      return
    end

    run("send -m '#{message}' #{number}")
  end

  def groups
    logger.info "J0ebot#groups"
    @groups ||= run("listGroups")
    logger.info "groups: #{@groups.inspect}"
    @groups
  end

  private

  def run(command)
    logger.info "J0ebot#run command='#{command}'"
    output = `signal-cli -o json -u '#{number}' #{command}`.strip
    logger.info "output : #{output.inspect}"
    output.split("\n").map{|line| JSON.parse(line) }
  rescue => e
    logger.error "Failed to run command: #{command}"
    logger.error e.inspect
    nil
  end

  def openai
    @openai
  end
end