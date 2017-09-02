module Slack
  class Request
    HELP      = "help"
    SEARCH    = "search"
    FOLLOW    = "follow"
    UNFOLLOW  = "unfollow"

    def initialize params
      @user = Slack::User.new params[:user_id], params[:user_name]
      @command, @options = params[:text].split(" ")
    end

    # /tv help
    # /tv search
    # /tv follow ...
    # /tv unfollow ...
    def process
      if help?
        process_help
      elsif search?
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
      help << "`/tv search your tv program` finds out things about *your tv program*"
      help << "`/tv follow your tv program` starts following *your tv program* and notifies you when a new episode has been aired."
      help << "`/tv unfollow your tv program` unfolloes *your tv program*"
      Slack::Response::ToYouOnly.text help.join("\n")
    end

    def search?
      @command == SEARCH
    end

    def follow?
      @command == FOLLOW
    end

    def unfollow?
      @command == UNFOLLOW
    end

  end  
end