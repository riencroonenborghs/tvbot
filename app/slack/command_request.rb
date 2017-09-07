module Slack
  class CommandRequest < Request
    def initialize(params)
      split_text    = (params[:text] || "").split(" ")
      # @user         = Slack::User.new params["user"]
      puts "params----------"
      puts params
      @command      = split_text.shift
      @options      = split_text
      @response_url ||= params[:response_url]
    end

    def process
      return process_help   if help?
      return process_search if search?
      process_help
    end

    def valid?
      true
    end

  private

    def help?
      @command == "help"
    end

    def process_help
      help = ["`/tv help` helps you along the way"]
      help << "`/tv search tv program` finds out things about *tv program*"
      help << "`/tv list` list all your followed tv programs"
      Slack::Response::ToYouOnly.text help.join("\n")
    end

    def search?
      @command == "search"
    end

    def process_search
      return Slack::Response::ToYouOnly.text "Nothing to search for." unless @options.any?
      begin
        api     = TMDb::API::Search.new @options.join(" ")
        results = api.search
        return Slack::Response::ToYouOnly.text "Nothing found for `#{@options.join(" ")}`." if results.size == 0
        Slack::Response::ToYouOnly.attachments { results }
      rescue => e
        Slack::Response::ToYouOnly.error e
      end
    end    
  end
end