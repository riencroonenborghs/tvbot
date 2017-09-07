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
      @actions_request.process
      @command_request.process
    end
  end # class Request

  class CommandRequest < Request
    def initialize(params)
      split_text    = (params[:text] || "").split(" ")
      @command      = split_text.shift
      @options      = split_text
      @response_url ||= params[:response_url]
    end

    def process
      return process_help   if help?
      return process_search if search?
      process_help
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

  class ActionsRequest < Request
    def initialize(params)
      @payload      = JSON.parse params[:payload] || "{}"
      @actions      = @payload["actions"] || []
      @response_url ||= @payload["response_url"]
    end

    def process
      return process_actions if actions?
    end

  private

    def actions?
      @actions.any?
    end

    def process_actions
      begin
        attachments = [].tap do |ret|
          @actions.each do |action|
            ret << process_follow(action)   if action["name"] == "follow"
            ret << process_unfollow(action) if action["name"] == "unfollow"
          end
        end.flatten

        puts "attachments"
        puts attachments
        
        Slack::Response::ToYouOnly.attachments do
          attachments
        end
      rescue => e
        Slack::Response::ToYouOnly.error e
      end
    end

    def process_follow action
      begin
        api     = TMDb::API::TvShows.new
        tv_show = api.getById action["value"]
        {
          fallback:     "You have started following #{tv_show[:name]}.",
          color:        "#36a64f", # greenish
          title:        "You have started following #{tv_show[:name]}.",
          text:         tv_show[:name],
        }
      rescue e
        Slack::Response::ToYouOnly.error e
      end
    end

    def process_unfollow action
    end
  end
end # module Slack