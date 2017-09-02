module Slack
  class Request
    HELP      = "help"
    SEARCH    = "search"
    FOLLOW    = "follow"
    UNFOLLOW  = "unfollow"

    def initialize params
      @user = Slack::User.new params[:user_id], params[:user_name]
      parsed_text = params[:text].split(" ")
      @command    = parsed_text.shift
      @options    = parsed_text
    end

    # /tv help
    # /tv search
    # /tv follow ...
    # /tv unfollow ...
    def process
      if help?
        process_help
      elsif search?
        process_search
      elsif follow?
      elsif unfollow?
      else
        process_help
      end
    end

  private

    def help?
      @command == HELP || @command.nil?
    end
    def process_help
      help = ["`/tv help` helps you along the way"]
      help << "`/tv search tv program` finds out things about *tv program*"
      help << "`/tv follow tv program` starts following *tv program* and notifies you when a new episode has aired"
      help << "`/tv unfollow tv program` unfollows *tv program*"
      Slack::Response::ToYouOnly.text help.join("\n")
    end

    def search?
      @command == SEARCH
    end
    def process_search
      return Slack::Response::ToYouOnly.text "Nothing to search for" unless @options.any?
      begin
        api     = TMDb::API::Search.new @options.join(" ")
        results = api.search
        return Slack::Response::ToYouOnly.text "Nothing found for #{@options.join(" ")}" if results.size == 0
        Slack::Response::ToYouOnly.attachments { results }
      rescue => e
        Slack::Response::ToYouOnly.error e
      end
    end

    def follow?
      @command == FOLLOW
    end

    def unfollow?
      @command == UNFOLLOW
    end

  end  
end