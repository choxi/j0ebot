require 'json'
require 'logger'
require 'pry'

require './lib/multi_i_o'
require './lib/message'
require './lib/history'
require './lib/core_narrative'
require './lib/openai'

class J0ebot
  NUMBERS_TO_NAME = {
    '+12192994442' => 'Joe',
    '+12245780974' => 'Roshan',
    '+18472715832' => 'Matt',
    '+12247230113' => 'Jonas',
    '+16308999196' => 'Max',
  }

  J0EBOT_NUMBER = '+17342378793'
  LOGPATH = './j0ebot.log'
  HISTORY_PATH = File.join(".", "data", "messages.jsonl")
  STATE_PATH = File.join(".", "data", "state.json")

  QANON_GROUP = OpenStruct.new(
    id: 'x5YSAYskxcHxG4eiBLLz27UYE3O9lZWOgDxjnAHBonI=',
    name: '- Qanon',
  )
  SANDBOX_GROUP = OpenStruct.new(
    id: '67nCT9nzzzEmY9U/6dbSCU4XEBuBvloLFPOImo/zqF4',
    name: 'j0ebot sandbox'
  )

  ENGINES = OpenStruct.new(
    davinci: "davinci",
    curie: "curie"
  )

  MODELS = OpenStruct.new(
    # Trained on the full group chat messages from Schmitty.
    # Pretuned with OpenAI
    # No stop sequences
    # Results:
    # It doesn't format the chat like it's supposed to, doesn't use newlines if the prompt doesn't have them.
    group_chat: 'curie:ft-user-dcevl4kejddcyyy812bc7vkm-2021-11-20-08-52-47',
    just_joe: 'curie:ft-user-dcevl4kejddcyyy812bc7vkm-2021-11-20-21-12-42',
    davinci: "davinci",
  )

  attr_reader :number
  attr_reader :logger
  attr_reader :message_logger
  attr_reader :history

  def initialize(number = J0EBOT_NUMBER, state_path = STATE_PATH)
    @number = number
    @logger = Logger.new(MultiIO.new(STDOUT, File.open(LOGPATH, "a")))
    @history = History.new(HISTORY_PATH)
    @openai = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    @last_messaged_at = Time.now.utc
    @state_path = state_path

    if File.file?(@state_path)
      state = JSON.parse(File.read(@state_path))
      @last_messaged_at = Time.parse(state["last_messaged_at"]) if state["last_messaged_at"]
    end
  end

  def listen
    loop do
      puts "Pulse..."
      receive
      sleep 60 * 30 # 15 minutes
    end
  end

  def receive
    logger.info "J0ebot#receive"
    messages = run("receive")
    h = history.recent_context(group_id: QANON_GROUP.id, last: 30).map {|msg| Message.new(msg) }

    messages.each do |message|
      history.push(message) if message.is_a? Hash
    end

    context = history.recent_context(since: @last_messaged_at, group_id: QANON_GROUP.id).map {|msg| Message.new(msg) }
    if context.length > 0
      logger.info "Catching up on the conversation..."
      context = history.recent_context(group_id: QANON_GROUP.id, last: 20).map {|msg| Message.new(msg) }
      # context.last.body += '. What do you think, Joe?'

      prompt = context.map(&:formatted).join("\n")
      prompt = CoreNarrative.davinci(prompt)
      logger.info ">>> PROMPT"
      logger.info prompt
      response = openai.completions(parameters: {
        model: MODELS.davinci,
        prompt: prompt,
        max_tokens: 128,
        stop: "\n",
        frequency_penalty: 0.5,
        presence_penalty: 1.6,
        temperature: 0.7
      })
      choice = response["choices"][0]["text"]
      logger.info ">>> GPT-3"
      logger.info choice

      joe_statements = choice.split("\n").filter {|line| line =~ /^Joe\:/}
      logger.info "joe statements: #{joe_statements.inspect}}" if joe_statements.length > 0

      if statement = joe_statements.first
        message = statement.split(":")[1].strip
        send(message, group_id: QANON_GROUP.id)
        history.push(outbound_message(body: message, group_id: QANON_GROUP.id))
        @last_messaged_at = Time.now.utc
      end
    end

    logger.info "Saving state..."
    save

    messages
  end

  def send(message, group_id: nil, number: nil)
    logger.info "J0ebot#send message='#{message}' group_id=#{group_id} number=#{number}"

    if group_id && number
      logger.error 'must provide only group_id or number, not both'
      return
    end

    if group_id
      run(%Q(send -m "#{message}" -g #{group_id}))
      return
    end

    run(%Q(send -m "#{message}" #{number}))
  end

  def groups
    logger.info "J0ebot#groups"
    @groups ||= run("listGroups")
    logger.info "groups: #{@groups.inspect}"
    @groups
  end

  def save
    state = { last_messaged_at: @last_messaged_at }
    File.write(@state_path, state.to_json)
  end

  private

  def outbound_message(body:, group_id:)
    {
      "envelope" => {
        "source" => "+17342378793",
        "sourceNumber" => "+17342378793",
        "sourceUuid" => "j0ebot",
        "sourceName" => "Joe Janiczek",
        "sourceDevice" => 1,
        "timestamp" => Time.now.to_i * 1000,
        "dataMessage" => {
          "timestamp" => Time.now.to_i * 1000,
          "message" => body,
          "expiresInSeconds": 0,
          "viewOnce" => false,
          "reaction" => [],
          "mentions" => [],
          "attachments" => [],
          "contacts" => [],
          "groupInfo" => {
            "groupId" => group_id,
            "type" => "DELIVER"
          }
        }
      }
    }
  end

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
