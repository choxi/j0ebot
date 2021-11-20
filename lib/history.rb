class History
  attr_accessor :logger
  attr_accessor :history

  def initialize(file_path)
    @history = File.file?(file_path) ? File.read(file_path).split("\n").map do |line|
      begin
        JSON.parse(line)
      rescue
        binding.pry
      end
    end : []
    @storage = File.open(file_path, 'a')
    @logger = Logger.new(STDOUT)
    logger.info "Loaded #{@history.length} messages into history."
  end

  def push(message)
    @storage.puts message.to_json
    @history.push message
  end

  def conversation_context(since: Time.at(Time.now.utc.to_i - 60*60*100), group_id:)
    @history.filter do |msg|
      message = Message.new(msg)
      message.group_id == group_id && (message.sent_at > since) && message.body&.strip
    end.last(5)
  end
end