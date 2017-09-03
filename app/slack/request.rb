module Slack
  class Request
    attr_accessor :response_url
    
    HELP      = "help"
    SEARCH    = "search"
    FOLLOW    = "follow"
    UNFOLLOW  = "unfollow"

    def initialize params
      @user = Slack::User.new params[:user_id], params[:user_name]
      # actions for (un)following tv programs
      @payload  = JSON.parse params[:payload] || "{}"
      @actions  = @payload["actions"] || []
      # command
      parsed_text = (params[:text] || "").split(" ")
      @command    = parsed_text.shift
      @options    = parsed_text

      @response_url = params[:response_url] || @payload["response_url"]
    end

    # /tv help
    # /tv search
    # /tv list
    def process
      if actions?
        process_actions
      elsif help?
        process_help
      elsif search?
        process_search      
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
      help << "`/tv list` list all your followed tv programs"
      Slack::Response::ToYouOnly.text help.join("\n")
    end

    def search?
      @command == SEARCH
    end
    def process_search
      return Slack::Response::ToYouOnly.text "Nothing to search for. Try something like `/tv search game of thrones`." unless @options.any?
      begin
        api     = TMDb::API::Search.new @options.join(" ")
        results = api.search
        return Slack::Response::ToYouOnly.text "Nothing found for `#{@options.join(" ")}`." if results.size == 0
        Slack::Response::ToYouOnly.attachments { results }
      rescue => e
        Slack::Response::ToYouOnly.error e
      end
    end

    def actions?
      @actions.any?
    end
    def process_actions
      begin
        attachments = [].tap do |ret|
          @actions.each do |action|
            ret << process_follow(action)   if action["name"] == FOLLOW
            ret << process_unfollow(action) if action["name"] == UNFOLLOW
          end
        end.join("\n")
        
        Slack::Response::ToYouOnly.attachments do
          attachments
        end
      rescue => e
        Slack::Response::ToYouOnly.error e
      end
    end
    def process_follow action
      api     = TMDb::API::TvShows.new
      tv_show = api.get action["value"]
      {
        fallback:     "You have started following #{tv_show[:name]}.",
        color:        "#36a64f", # greenish
        title:        "You have started following #{tv_show[:name]}.",
        text:         tv_show[:name],
      }
    end
    def process_unfollow action
    end

  end  
end