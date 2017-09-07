module Slack
  class Request
    attr_accessor :response_url
    
    def initialize params
      @actions_request  = ActionsRequest.new params
      @command_request  = CommandRequest.new params
      @response_url     = @command_request.response_url || @actions_request.response_url
    end

    # /tv help
    # /tv search
    # /tv list
    def process
      return @actions_request.process if @actions_request.valid?
      return @command_request.process if @command_request.valid?
    end
  end # class Request
end # module Slack