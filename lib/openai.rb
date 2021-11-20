module OpenAI
  class Client
    def completions(version: default_version, parameters: {})
      post(url: "/#{version}/completions", parameters: parameters)
    end
  end
end